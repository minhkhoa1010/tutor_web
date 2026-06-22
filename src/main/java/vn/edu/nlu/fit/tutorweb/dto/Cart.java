package vn.edu.nlu.fit.tutorweb.dto;

import vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private final List<TutorSearchResult> items;

    public Cart() {
        this.items = new ArrayList<>();
    }

    public List<TutorSearchResult> getItems() {
        return items;
    }

    /**
     * Thêm gia sư vào giỏ hàng (Kiểm tra nếu đã có rồi thì không thêm trùng)
     */
    public boolean addItem(TutorSearchResult tutor) {
        for (TutorSearchResult item : items) {
            if (item.getTutorId() == tutor.getTutorId()) {
                return false;
            }
        }
        items.add(tutor);
        return true;
    }

    /**
     * Xóa gia sư khỏi giỏ hàng
     */
    public boolean removeItem(long tutorId) {
        return items.removeIf(item -> item.getTutorId() == tutorId);
    }

    /**
     * Lấy danh sách tất cả ID gia sư trong giỏ hàng để kiểm tra ngoài JSP bằng fn:contains
     */
    public List<Long> getTutorIds() {
        List<Long> ids = new ArrayList<>();
        for (TutorSearchResult item : items) {
            ids.add(item.getTutorId());
        }
        return ids;
    }

    /**
     * Đếm tổng số gia sư đang chờ thuê
     */
    public int getTotalItems() {
        return items.size();
    }
}