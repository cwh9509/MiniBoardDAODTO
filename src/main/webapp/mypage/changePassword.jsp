<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    String message = "";

    // 비밀번호 변경 처리
    if (newPassword != null && confirmPassword != null && currentPassword != null) {
        if (!newPassword.equals(confirmPassword)) {
            message = "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.";
        } else {
            // UserDAO 객체 생성
            UserDAO userDAO = new UserDAO();

            // 비밀번호 변경 처리
            boolean isChanged = userDAO.changePassword(username, currentPassword, newPassword);
            if (isChanged) {
                message = "비밀번호가 성공적으로 변경되었습니다.";
            } else {
                message = "현재 비밀번호가 잘못되었습니다.";
            }
        }
    }
    
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 변경</title>
    <link rel="stylesheet" type="text/css" href="../css/mypage.css">
    <script>
        window.onload = function() {
            var message = "<%= message %>";
            if (message.trim() !== "") {
                alert(message);
            }
        };
    </script>
</head>
<body>

    <header>
        <h1>비밀번호 변경</h1>
    </header>

    <section class="change-password">
        <form action="changePassword.jsp" method="POST">
            <p><strong>현재 비밀번호:</strong> <input type="password" name="currentPassword" required></p>
            <p><strong>새 비밀번호:</strong> <input type="password" name="newPassword" required></p>
            <p><strong>새 비밀번호 확인:</strong> <input type="password" name="confirmPassword" required></p>
            <button type="submit">비밀번호 변경</button>
            <a href="myProfile.jsp" class="btn">내 정보로 돌아가기</a>
        </form>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
