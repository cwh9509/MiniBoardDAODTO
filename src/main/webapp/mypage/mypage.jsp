<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO, dto.UserDTO" %>

<%
    // 세션에서 사용자 정보 가져오기
    String username = (String) session.getAttribute("username");

    if (username == null) {
        // 로그인되지 않은 상태에서 접근 시 로그인 페이지로 리다이렉트
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // DAO를 사용해서 사용자 정보 가져오기
    UserDAO userDAO = new UserDAO();
    UserDTO user = userDAO.getUserByUsername(username);

    // 사용자 정보가 없을 경우 예외 처리
    if (user == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }
    
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 페이지</title>
    <link rel="stylesheet" type="text/css" href="../css/mypage.css">
</head>
<body>
    <header>
        <h1>마이 페이지</h1>
    </header>
    <div class="header-actions">
        <a href="../login/logout.jsp" class="login-btn">로그아웃</a>
    </div>

    <div class="my-page-container">
        <div class="profile-card">
            <h3>환영합니다, <%= user.getNickname() %>님!</h3>
            <div class="actions">
                <a href="myProfile.jsp" class="btn">내 정보 확인하기</a>
                <a href="myPosts.jsp" class="btn">내 게시글 보기</a>
                <a href="myComments.jsp" class="btn">내 댓글 보기</a>
                <a href="../board/board.jsp" class="btn">게시판 화면으로 돌아가기</a>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
