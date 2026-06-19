package vn.edu.nlu.fit.tutorweb.helper;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import vn.edu.nlu.fit.tutorweb.service.BookingService;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class BackgroundJobListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private final BookingService bookingService = new BookingService();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println(">>> [SYSTEM] Khởi chạy luồng quét ngầm tự động cho Gia Sư Bá Đạo...");

        // Tạo luồng Thread chạy ngầm độc lập
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Cấu hình định kỳ:
        // - Sau khi bật server 10 giây sẽ quét lần đầu (initialDelay)
        // - Sau đó cứ cách mỗi 60 phút sẽ tự động quét lại một lần (period)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                bookingService.scanAndReleaseAutoCompletions();
            } catch (Exception e) {
                System.err.println(">>> [CRITICAL] Lỗi xảy ra trong tiến trình quét tự động ngầm!");
                e.printStackTrace();
            }
        }, 10, 60, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println(">>> [SYSTEM] Đang đóng luồng quét ngầm để tắt Server an toàn...");
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
        }
    }
}