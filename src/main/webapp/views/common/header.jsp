<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    String ctx = request.getContextPath();

    String pageTitle =
            request.getParameter("pageTitle") != null
                    ? request.getParameter("pageTitle")
                    : (String) request.getAttribute("pageTitle");

    String pageCss =
            request.getParameter("pageCss") != null
                    ? request.getParameter("pageCss")
                    : (String) request.getAttribute("pageCss");

    if (pageTitle == null || pageTitle.isBlank()) {
        pageTitle = "Gia Sư Bá Đạo";
    }
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= pageTitle %></title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= ctx %>/assets/css/header.css">

    <link rel="stylesheet"
          href="<%= ctx %>/assets/css/navbar.css">

    <link rel="stylesheet"
          href="<%= ctx %>/assets/css/footer.css">

    <% if (pageCss != null && !pageCss.isBlank()) { %>
    <link rel="stylesheet"
          href="<%= ctx + pageCss %>">
    <% } %>
</head>

<body>
<div class="page">