package vn.edu.nlu.fit.tutorweb.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import vn.edu.nlu.fit.tutorweb.dao.UserDAO;
import vn.edu.nlu.fit.tutorweb.db.ConfigProperties;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;
import vn.edu.nlu.fit.tutorweb.helper.MomoHelper;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class PaymentService {

    private final UserDAO userDAO = new UserDAO();

    // Credentials sandbox MoMo public
    private static final String PARTNER_CODE = ConfigProperties.get("momo.partner_code").trim();
    private static final String ACCESS_KEY   = ConfigProperties.get("momo.access_key").trim();
    private static final String SECRET_KEY   = ConfigProperties.get("momo.secret_key").trim();
    private static final String ENDPOINT     = ConfigProperties.get("momo.endpoint").trim();
    private static final String RETURN_URL   = ConfigProperties.get("momo.return_url").trim();
    private static final String NOTIFY_URL   = ConfigProperties.get("momo.return_url").trim();

    public String createMomoPaymentUrl(String amountStr) throws Exception {

        String orderId    = "ORDER_" + System.currentTimeMillis();
        String requestId  = UUID.randomUUID().toString();
        String orderInfo  = "Nap tien vi Gia Su Ba Dao";
        String amount     = amountStr;
        String extraData  = "";
        String requestType = "payWithATM";

        // Build rawSignature theo đúng thứ tự MoMo yêu cầu
        String rawSignature =
                "accessKey="   + ACCESS_KEY   +
                        "&amount="     + amount        +
                        "&extraData="  + extraData     +
                        "&ipnUrl="     + NOTIFY_URL    +
                        "&orderId="    + orderId       +
                        "&orderInfo="  + orderInfo     +
                        "&partnerCode="+ PARTNER_CODE  +
                        "&redirectUrl="+ RETURN_URL    +
                        "&requestId="  + requestId     +
                        "&requestType="+ requestType;

        String signature = MomoHelper.hmacSHA256(SECRET_KEY, rawSignature);

        // Build JSON body
        Map<String, String> body = new HashMap<>();
        body.put("partnerCode", PARTNER_CODE);
        body.put("accessKey",   ACCESS_KEY);
        body.put("requestId",   requestId);
        body.put("amount",      amount);
        body.put("orderId",     orderId);
        body.put("orderInfo",   orderInfo);
        body.put("redirectUrl", RETURN_URL);
        body.put("ipnUrl",      NOTIFY_URL);
        body.put("extraData",   extraData);
        body.put("requestType", requestType);
        body.put("signature",   signature);
        body.put("lang",        "vi");

        String jsonBody = new ObjectMapper().writeValueAsString(body);

        // Gọi API MoMo
        HttpURLConnection conn = (HttpURLConnection) new URL(ENDPOINT).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }

        String response = new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

        System.out.println("\n========== MOMO CREATE ==========");
        System.out.println("RAW SIGNATURE: " + rawSignature);
        System.out.println("SIGNATURE: " + signature);
        System.out.println("RESPONSE: " + response);
        System.out.println("==================================\n");

        // Parse payUrl từ response
        Map<?, ?> responseMap = new ObjectMapper().readValue(response, Map.class);
        String payUrl = (String) responseMap.get("payUrl");

        if (payUrl == null || payUrl.isEmpty()) {
            throw new Exception("MoMo không trả về payUrl: " + response);
        }

        return payUrl;
    }

    public long processMomoCallback(HttpServletRequest request, UserSession userSession) throws Exception {

        String resultCode = request.getParameter("resultCode");
        String amount     = request.getParameter("amount");
        String orderId    = request.getParameter("orderId");
        String signature  = request.getParameter("signature");

        // Verify signature
        String rawSignature =
                "accessKey="   + ACCESS_KEY  +
                        "&amount="     + amount       +
                        "&extraData="  + request.getParameter("extraData") +
                        "&message="    + request.getParameter("message")   +
                        "&orderId="    + orderId      +
                        "&orderInfo="  + request.getParameter("orderInfo") +
                        "&orderType="  + request.getParameter("orderType") +
                        "&partnerCode="+ PARTNER_CODE +
                        "&payType="    + request.getParameter("payType")   +
                        "&requestId="  + request.getParameter("requestId") +
                        "&responseTime="+ request.getParameter("responseTime") +
                        "&resultCode=" + resultCode   +
                        "&transId="    + request.getParameter("transId");

        String mySignature = MomoHelper.hmacSHA256(SECRET_KEY, rawSignature);

        System.out.println("\n========== MOMO CALLBACK ==========");
        System.out.println("RAW: " + rawSignature);
        System.out.println("MoMo SIG : " + signature);
        System.out.println("My SIG   : " + mySignature);
        System.out.println("MATCH    : " + mySignature.equalsIgnoreCase(signature));
        System.out.println("====================================\n");

        if (!mySignature.equalsIgnoreCase(signature)) return -1;
        if (!"0".equals(resultCode)) return -1;
        if (userSession == null) return -1;

        long amountLong = Long.parseLong(amount);
        boolean updated = userDAO.depositMoney(userSession.getId(), amountLong, orderId);
        if (!updated) return -1;

        userSession.setBalance(userSession.getBalance() + amountLong);
        return amountLong;
    }
}