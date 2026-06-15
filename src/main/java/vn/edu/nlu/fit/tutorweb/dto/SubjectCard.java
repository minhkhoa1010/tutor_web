package vn.edu.nlu.fit.tutorweb.dto;

public class SubjectCard {

    private String name;
    private String iconClass;
    private String bgColor;

    public SubjectCard(String name, String iconClass, String bgColor) {
        this.name = name;
        this.iconClass = iconClass;
        this.bgColor = bgColor;
    }

    public String getName() {
        return name;
    }

    public String getIconClass() {
        return iconClass;
    }

    public String getBgColor() {
        return bgColor;
    }
}