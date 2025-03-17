<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>

<%
    // 세션에서 사용자 정보 가져오기
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // DAO를 이용하여 사용자 정보 가져오기
    UserDAO userDAO = new UserDAO();
    UserDTO user = userDAO.getUserInfo(username);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보</title>
    <link rel="stylesheet" type="text/css" href="../css/mypage.css">
</head>
<body>

    <header>
        <h1>내 정보</h1>
    </header>
    <div class="header-actions">
    	<a href="mypage.jsp" class="login-btn">마이 페이지로 돌아가기</a>
    	<a href="../login/logout.jsp" class="login-btn">로그아웃</a>
	</div>

    <section class="my-profile">
        <h2>내 정보</h2>
        <p><strong>아이디:</strong> <%= user.getUsername() %></p>
        <p><strong>닉네임:</strong> <%= user.getNickname() %></p>
        <p><strong>이메일:</strong> <%= user.getEmail() %></p>

        <a href="editProfile.jsp">회원정보 수정</a> | 
        <a href="changePassword.jsp">비밀번호 변경</a> |
        <a href="deleteAccount.jsp">계정 삭제</a>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
