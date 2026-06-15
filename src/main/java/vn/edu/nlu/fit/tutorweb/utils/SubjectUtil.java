package vn.edu.nlu.fit.tutorweb.utils;

public class SubjectUtil {

    public static String getIcon(String subject) {

        String s = subject.toLowerCase();

        if (s.contains("toán")) return "fa-solid fa-square-root-variable";
        if (s.contains("lý")) return "fa-solid fa-bolt";
        if (s.contains("hóa")) return "fa-solid fa-flask";
        if (s.contains("sinh")) return "fa-solid fa-dna";

        if (s.contains("văn")) return "fa-solid fa-book-open";
        if (s.contains("tiếng việt")) return "fa-solid fa-language";

        if (s.contains("anh")) return "fa-solid fa-globe";
        if (s.contains("toeic")) return "fa-solid fa-certificate";
        if (s.contains("ielts")) return "fa-solid fa-award";
        if (s.contains("toefl")) return "fa-solid fa-graduation-cap";

        if (s.contains("pháp")) return "fa-solid fa-earth-europe";
        if (s.contains("hàn")) return "fa-solid fa-earth-asia";
        if (s.contains("hoa")) return "fa-solid fa-earth-asia";
        if (s.contains("nhật")) return "fa-solid fa-torii-gate";

        if (s.contains("sử")) return "fa-solid fa-landmark";
        if (s.contains("địa")) return "fa-solid fa-map-location-dot";

        if (s.contains("tin")) return "fa-solid fa-laptop-code";

        if (s.contains("vẽ")) return "fa-solid fa-palette";
        if (s.contains("rèn chữ")) return "fa-solid fa-pen-fancy";

        if (s.contains("piano")) return "fa-solid fa-music";
        if (s.contains("organ")) return "fa-solid fa-keyboard";
        if (s.contains("guitar")) return "fa-solid fa-guitar";

        if (s.contains("nhảy")) return "fa-solid fa-person-dancing";

        if (s.contains("khoa học tự nhiên"))
            return "fa-solid fa-atom";

        if (s.contains("khoa học"))
            return "fa-solid fa-microscope";

        if (s.contains("báo bài"))
            return "fa-solid fa-clipboard-check";

        return "fa-solid fa-book";
    }

    public static String getBgColor(String subject) {

        String s = subject.toLowerCase();

        if (s.contains("toán")) return "#eff6ff";
        if (s.contains("lý")) return "#fefce8";
        if (s.contains("hóa")) return "#f0fdf4";
        if (s.contains("sinh")) return "#ecfdf5";

        if (s.contains("văn")) return "#fff7ed";
        if (s.contains("tiếng việt")) return "#fff1f2";

        if (s.contains("anh")) return "#fdf2f8";
        if (s.contains("toeic")) return "#eef2ff";
        if (s.contains("ielts")) return "#f5f3ff";
        if (s.contains("toefl")) return "#ede9fe";

        if (s.contains("pháp")) return "#ecfeff";
        if (s.contains("hàn")) return "#fdf2f8";
        if (s.contains("hoa")) return "#fef3c7";
        if (s.contains("nhật")) return "#fee2e2";

        if (s.contains("sử")) return "#fef3c7";
        if (s.contains("địa")) return "#dcfce7";

        if (s.contains("tin")) return "#dbeafe";

        if (s.contains("vẽ")) return "#ecfdf5";
        if (s.contains("rèn chữ")) return "#fff7ed";

        if (s.contains("piano")) return "#fdf2f8";
        if (s.contains("organ")) return "#eef2ff";
        if (s.contains("guitar")) return "#fef3c7";

        if (s.contains("nhảy")) return "#fae8ff";

        if (s.contains("khoa học tự nhiên")) return "#ecfeff";
        if (s.contains("khoa học")) return "#f0fdf4";

        return "#f1f5f9";
    }
}