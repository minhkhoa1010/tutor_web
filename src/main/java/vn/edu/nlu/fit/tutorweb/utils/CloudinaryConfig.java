package vn.edu.nlu.fit.tutorweb.utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    public static Cloudinary getCloudinary() {
        if  (cloudinary == null) {
            try {
                Properties prop = new Properties();
                InputStream input = CloudinaryConfig.class.getClassLoader().getResourceAsStream("config.properties");

                // THÊM CHECK NÀY ĐỂ TRÁNH LỖI KHI KHÔNG LOAD ĐƯỢC FILE
                if (input == null) {
                    throw new IOException("Không tìm thấy file config.properties");
                }

                prop.load(input);
                cloudinary = new Cloudinary(ObjectUtils.asMap(
                        "cloud_name", prop.getProperty("cloudinary.cloud_name"),
                        "api_key", prop.getProperty("cloudinary.api_key"),
                        "api_secret", prop.getProperty("cloudinary.api_secret"),
                        "secure", true
                ));
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException("Lỗi cấu hình Cloudinary: " + e.getMessage());
            }
        }
        return cloudinary;
        }
    public static String getPublicIdFromUrl(String url) {
        if (url == null || !url.contains("/upload/")) return null;

        // URL thường có dạng: .../upload/v171827473/avatars/user_123.jpg
        // Ta cắt lấy phần sau /upload/
        String part = url.split("/upload/")[1];

        // Bỏ cái version (v12345/...) nếu có.
        // Version thường bắt đầu bằng chữ 'v' và là các chữ số tiếp theo
        if (part.startsWith("v")) {
            part = part.substring(part.indexOf("/") + 1);
        }

        // Bỏ phần đuôi file (ví dụ .jpg, .png)
        return part.substring(0, part.lastIndexOf("."));
    }
}