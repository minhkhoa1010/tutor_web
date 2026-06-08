package vn.edu.nlu.fit.tutorweb.utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", "dbr5ywhoa",
                    "api_key", "547263652169477",
                    "api_secret", "t98WnEhdhpxhtUj9c4oH9FBhLpk",
                    "secure", true
            ));

        }
        return cloudinary;
    }
}

