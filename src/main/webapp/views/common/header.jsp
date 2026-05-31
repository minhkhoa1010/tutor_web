<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        String pageTitle = request.getParameter("pageTitle");
        if (pageTitle == null || pageTitle.isBlank()) {
            pageTitle = "Gia Sư Bá Đạo";
        }
        String pageCss = request.getParameter("pageCss");
        String ctx = request.getContextPath();
    %>
    <title><%= pageTitle %></title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/header.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/navbar.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/footer.css">

    <% if (pageCss != null && !pageCss.isBlank()) { %>
    <link rel="stylesheet" href="<%= ctx + pageCss %>">
    <% } %>
</head>
<body>
<div class="page">