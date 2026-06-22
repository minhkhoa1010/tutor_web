package vn.edu.nlu.fit.tutorweb.helper;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import vn.edu.nlu.fit.tutorweb.db.ConfigProperties;

import java.io.IOException;

public class SocialAuthHelper {

    // --- XỬ LÝ GOOGLE ---
    public static JsonObject getGoogleUserInfo(String code) throws IOException {
        // 1. Đổi "code" lấy Access Token từ ConfigProperties
        String response = Request.Post("https://oauth2.googleapis.com/token")
                .bodyForm(Form.form()
                        .add("client_id", ConfigProperties.get("google.client.id"))
                        .add("client_secret", ConfigProperties.get("google.client.secret"))
                        .add("redirect_uri", ConfigProperties.get("google.redirect.uri"))
                        .add("code", code)
                        .add("grant_type", "authorization_code").build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").getAsString();

        // 2. Dùng Access Token lấy thông tin User thông qua UserInfo API
        String userInfoResponse = Request.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken)
                .execute().returnContent().asString();

        return new Gson().fromJson(userInfoResponse, JsonObject.class);
    }

    // --- XỬ LÝ FACEBOOK ---
    public static JsonObject getFacebookUserInfo(String code) throws IOException {
        // 1. Đổi "code" lấy Access Token từ Facebook Graph API sử dụng ConfigProperties
        String tokenUrl = "https://graph.facebook.com/v19.0/oauth/access_token?"
                + "client_id=" + ConfigProperties.get("facebook.client.id")
                + "&redirect_uri=" + ConfigProperties.get("facebook.redirect.uri")
                + "&client_secret=" + ConfigProperties.get("facebook.client.secret")
                + "&code=" + code;

        String response = Request.Get(tokenUrl).execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").getAsString();

        // 2. Lấy các trường thông tin cụ thể (id, name, email, picture)
        String userUrl = "https://graph.facebook.com/me?fields=id,name,email,picture.type(large)&access_token=" + accessToken;
        String userInfoResponse = Request.Get(userUrl).execute().returnContent().asString();

        return new Gson().fromJson(userInfoResponse, JsonObject.class);
    }
}