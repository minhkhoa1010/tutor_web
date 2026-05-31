<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.edu.nlu.fit.tutorweb.entity.TutorSearchResult" %>
<jsp:include page="/views/common/header.jsp">
  <jsp:param name="pageTitle" value="Tim gia su - Gia Su Ba Dao" />
  <jsp:param name="pageCss" value="/assets/css/tutor-list.css" />
</jsp:include>
<jsp:include page="/views/common/navbar.jsp" />

<main class="page-main">
  <div class="container">
    <section class="section">
      <h2 class="section-title">Tìm kiếm gia sư</h2>
      <div class="section-sub">Lọc theo môn học, khu vực và mức học phí.</div>
      <div class="sidebar-layout">
        <aside class="sidebar">
          <div class="filter-group">
            <div class="card-header">Môn học</div>
            <label class="meta"><input type="checkbox"> Toán học</label><br>
            <label class="meta"><input type="checkbox"> Tiếng Anh</label><br>
            <label class="meta"><input type="checkbox"> Vật lý</label><br>
            <label class="meta"><input type="checkbox"> Hóa học</label>
          </div>
          <div class="filter-group">
            <div class="card-header">Khu vực</div>
            <label class="meta"><input type="checkbox"> TP.HCM</label><br>
            <label class="meta"><input type="checkbox"> Hà Nội</label><br>
            <label class="meta"><input type="checkbox"> Đà Nẵng</label>
          </div>
          <div class="filter-group">
            <div class="card-header">Học phí</div>
            <input class="input-field" type="text" placeholder="Từ 200k">
            <input class="input-field" type="text" placeholder="Đến 700k" style="margin-top: 8px;">
          </div>
          <button class="btn btn-primary" style="width: 100%;">Áp dụng</button>
        </aside>
        <div class="grid-4">
          <%
            List<TutorSearchResult> tutors = (List<TutorSearchResult>) request.getAttribute("tutors");
            if (tutors == null || tutors.isEmpty()) {
          %>
          <div class="card">
            <div class="card-header">
              <span>Chưa có kết quả</span>
              <span class="badge">0</span>
            </div>
            <div class="meta">Vui lòng thử lại với bộ lọc khác.</div>
          </div>
          <%
          } else {
            for (TutorSearchResult tutor : tutors) {
          %>
          <div class="card">
            <div class="card-header">
              <span><%= tutor.getFullName() %></span>
              <span class="badge"><%= tutor.getGenderLabel() %></span>
            </div>
            <div class="meta"><%= tutor.getSubjectsLabel() %> • <%= tutor.getAreaLabel() %></div>
            <div class="meta" style="margin-top: 10px;">
              <%= tutor.getRateLabel() %>
            </div>
            <a class="btn btn-outline" href="<%= request.getContextPath() %>/views/tutor/detail.jsp" style="margin-top: 12px; display: inline-block;">Xem hồ sơ</a>
          </div>
          <%
              }
            }
          %>
        </div>
      </div>
    </section>
  </div>
</main>

<jsp:include page="/views/common/footer.jsp" />
