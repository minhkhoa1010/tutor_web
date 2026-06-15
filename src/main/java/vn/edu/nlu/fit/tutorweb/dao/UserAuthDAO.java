package vn.edu.nlu.fit.tutorweb.dao;

import org.mindrot.jbcrypt.BCrypt;
import org.jdbi.v3.core.Jdbi;
import vn.edu.nlu.fit.tutorweb.db.DBConnect;
import vn.edu.nlu.fit.tutorweb.entity.UserSession;

import java.util.List;
import java.util.Map;

public class UserAuthDAO {
    private final Jdbi jdbi = DBConnect.get();

    public UserSession loginWithCredentials(String identifier, String password) {
        String sql = "SELECT id, username, password, email, fullname, avatar_url, is_active " +
                "FROM users WHERE email = :identifier OR username = :identifier OR phone = :identifier";

        return jdbi.withHandle(handle -> {
            try {
                return handle.createQuery(sql)
                        .bind("identifier", identifier)
                        .mapToMap()
                        .findFirst()
                        .map(row -> {
                            Object activeObj = row.get("is_active");
                            String activeStr = (activeObj != null) ? activeObj.toString() : "0";

                            if ("false".equalsIgnoreCase(activeStr) || "0".equals(activeStr)) {
                                System.out.println(">>> LOGIN: Tai khoan dang bi khoa!");
                                return null;
                            }

                            String hashedPass = (String) row.get("password");

                            // In thông tin ra Console để kiểm tra xem Java có đọc được DB không
                            System.out.println(">>> LOGIN: Identifier nhap vao = " + identifier);
                            System.out.println(">>> LOGIN: Chuoi password hash trong DB = " + hashedPass);

                            if (hashedPass != null && BCrypt.checkpw(password, hashedPass)) {
                                UserSession user = new UserSession();
                                user.setId(Long.parseLong(row.get("id").toString()));
                                user.setUsername((String) row.get("username"));
                                user.setEmail((String) row.get("email"));
                                user.setFullname((String) row.get("fullname"));
                                user.setAvatarUrl((String) row.get("avatar_url"));
                                user.setRoles(getUserRoles(user.getId()));
                                return user;
                            }

                            System.out.println(">>> LOGIN: BCrypt.checkpw tra ve FALSE (Sai mat khau)!");
                            return null;
                        }).orElse(null);
            } catch (Exception e) {
                // In chi tiết lỗi đỏ lòm ra tab Console/Tomcat nếu code bi sập ngầm
                System.err.println(">>> LỖI CHÍ MẠNG KHI ĐĂNG NHẬP:");
                e.printStackTrace();
                return null;
            }
        });
    }

    // 2. Đăng nhập mạng xã hội (Tự động đăng ký nếu chưa có tài khoản)
    public UserSession loginOrRegisterSocial(String provider, String providerUserId, String email, String fullname, String avatarUrl) {
        return jdbi.inTransaction(handle -> {
            String checkIdentitySql = "SELECT user_id FROM user_identities WHERE provider = :provider AND provider_user_id = :pUid";
            Long userId = handle.createQuery(checkIdentitySql)
                    .bind("provider", provider.toUpperCase())
                    .bind("pUid", providerUserId)
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(null);

            if (userId != null) {
                return getUserById(userId);
            }

            String checkUserSql = "SELECT id FROM users WHERE email = :email";
            userId = handle.createQuery(checkUserSql)
                    .bind("email", email)
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(null);

            if (userId == null) {
                String insertUserSql = "INSERT INTO users (username, password, email, fullname, avatar_url, is_active) " +
                        "VALUES (:username, :password, :email, :fullname, :avatarUrl, 1)";

                String randomUsername = "oauth_" + provider.toLowerCase() + "_" + providerUserId;
                String randomPassword = BCrypt.hashpw(Long.toString(System.currentTimeMillis()), BCrypt.gensalt());

                userId = handle.createUpdate(insertUserSql)
                        .bind("username", randomUsername)
                        .bind("password", randomPassword)
                        .bind("email", email)
                        .bind("fullname", fullname)
                        .bind("avatarUrl", avatarUrl)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                String assignRoleSql = "INSERT INTO user_roles (user_id, role_id) SELECT :userId, id FROM roles WHERE name = 'USER'";
                handle.createUpdate(assignRoleSql)
                        .bind("userId", userId)
                        .execute();
            }

            String insertIdentitySql = "INSERT INTO user_identities (user_id, provider, provider_user_id) VALUES (:userId, :provider, :pUid)";
            handle.createUpdate(insertIdentitySql)
                    .bind("userId", userId)
                    .bind("provider", provider.toUpperCase())
                    .bind("pUid", providerUserId)
                    .execute();

            return getUserById(userId);
        });
    }

    // Hàm phụ lấy danh sách các Role (Quyền) của User từ DB
    public List<String> getUserRoles(long userId) {
        String sql = "SELECT r.name FROM roles r " +
                "JOIN user_roles ur ON r.id = ur.role_id " +
                "WHERE ur.user_id = :userId";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(String.class)
                        .list()
        );
    }

    // Hàm phụ lấy User thông qua ID
    public UserSession getUserById(long userId) {
        String sql = "SELECT id, username, email, fullname, avatar_url, is_active FROM users WHERE id = :userId";

        return jdbi.withHandle(handle -> {
            return handle.createQuery(sql)
                    .bind("userId", userId)
                    .mapToMap()
                    .findFirst()
                    .map(row -> {
                        Object activeObj = row.get("is_active");
                        String activeStr = (activeObj != null) ? activeObj.toString() : "0";

                        if ("false".equalsIgnoreCase(activeStr) || "0".equals(activeStr)) {
                            return null;
                        }

                        UserSession user = new UserSession();
                        user.setId(Long.parseLong(row.get("id").toString()));
                        user.setUsername((String) row.get("username"));
                        user.setEmail((String) row.get("email"));
                        user.setFullname((String) row.get("fullname"));
                        user.setAvatarUrl((String) row.get("avatar_url"));
                        user.setRoles(getUserRoles(userId));
                        return user;
                    }).orElse(null);
        });
    }

    public boolean register(String email,
                            String phone,
                            String fullname,
                            String password) {

        try {
            return jdbi.inTransaction(handle -> {

                Long existed = handle.createQuery(
                                "SELECT id FROM users " +
                                        "WHERE email = :email OR phone = :phone")
                        .bind("email", email)
                        .bind("phone", phone)
                        .mapTo(Long.class)
                        .findFirst()
                        .orElse(null);

                if (existed != null) {
                    return false;
                }

                String hashedPassword =
                        BCrypt.hashpw(password, BCrypt.gensalt());

                String username = email != null ? email : phone;

                Long userId = handle.createUpdate(
                                "INSERT INTO users " +
                                        "(username,password,email,phone,fullname,is_active) " +
                                        "VALUES (:username,:password,:email,:phone,:fullname,1)")
                        .bind("username", username)
                        .bind("password", hashedPassword)
                        .bind("email", email)
                        .bind("phone", phone)
                        .bind("fullname", fullname)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Long.class)
                        .one();

                handle.createUpdate(
                                "INSERT INTO user_roles(user_id,role_id) " +
                                        "SELECT :userId,id FROM roles WHERE name='USER'")
                        .bind("userId", userId)
                        .execute();

                return true;
            });

        } catch (Exception e) {
            e.printStackTrace();
            return false;

        }
    }
    public Long findUserIdByEmail(String email) {
        return jdbi.withHandle(h ->
                h.createQuery("""
                SELECT id
                FROM users
                WHERE email = :email
            """)
                        .bind("email", email)
                        .mapTo(Long.class)
                        .findOne()
                        .orElse(null)
        );
    }
    public boolean createResetToken(Long userId, String token) {

        return jdbi.withHandle(h ->
                h.createUpdate("""
                INSERT INTO password_reset_tokens
                (
                    user_id,
                    token,
                    expired_at
                )
                VALUES
                (
                    :userId,
                    :token,
                    DATE_ADD(NOW(), INTERVAL 30 MINUTE)
                )
            """)
                        .bind("userId", userId)
                        .bind("token", token)
                        .execute() > 0
        );
    }
    public void markTokenUsed(String token) {

        jdbi.useHandle(h ->
                h.createUpdate("""
                UPDATE password_reset_tokens
                SET used = 1
                WHERE token = :token
            """)
                        .bind("token", token)
                        .execute()
        );
    }
    public boolean updatePasswordByUserId(
            Long userId,
            String newPassword
    ) {

        String hash =
                BCrypt.hashpw(
                        newPassword,
                        BCrypt.gensalt()
                );

        return jdbi.withHandle(h ->
                h.createUpdate("""
                UPDATE users
                SET password = :password
                WHERE id = :userId
            """)
                        .bind("password", hash)
                        .bind("userId", userId)
                        .execute() > 0
        );
    }

    public Long validateResetToken(String token) {

        String sql = """
        SELECT user_id
        FROM password_reset_tokens
        WHERE token = :token
          AND expired_at > NOW()
          AND used = FALSE
    """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("token", token)
                        .mapTo(Long.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}