<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>
<%@ page import="java.net.URLEncoder" %>

<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    String nickname = "";
    String email = "";
    String newNickname = request.getParameter("nickname");
    String newEmail = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String message = "";

    UserDAO userDAO = new UserDAO();
    UserDTO user = userDAO.getUserInfo(username);  // UserDTO 객체로 정보 가져오기
    nickname = user.getNickname();
    email = user.getEmail();

    boolean isValidPassword = false;

    try {
        // 입력한 비밀번호 검증
        if (password != null && !password.trim().isEmpty()) {
            isValidPassword = userDAO.checkPassword(username, password);  // 비밀번호 검증
            if (!isValidPassword) {
                message = "비밀번호가 맞지 않습니다.";
            }
        }

        // 비밀번호가 맞을 경우 정보 수정
        if (isValidPassword) {
            if (!password.equals(confirmPassword)) {
                message = "비밀번호가 일치하지 않습니다.";
            } else {
                if ((newNickname != null && !newNickname.trim().isEmpty()) || (newEmail != null && !newEmail.trim().isEmpty())) {
                    user.setNickname(newNickname != null ? newNickname : nickname);
                    user.setEmail(newEmail != null ? newEmail : email);
                    user.setPassword(password);

                    boolean isUpdated = userDAO.updateUser(user);
                    if (isUpdated) {
                        session.setAttribute("nickname", user.getNickname());
                        message = "회원 정보가 성공적으로 수정되었습니다.";
                        response.sendRedirect("mypage.jsp?message=" + URLEncoder.encode(message, "UTF-8"));
                    } else {
                        message = "정보 수정에 실패했습니다.";
                    }
                } else {
                    message = "변경할 값이 없습니다.";
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "오류가 발생했습니다. 다시 시도해주세요.";
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정</title>
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
    <h1>회원 정보 수정</h1>
</header>

<section class="edit-profile">
    <form action="editProfile.jsp" method="POST">
        <p><strong>아이디:</strong> <%= username %></p>
        <p><strong>닉네임:</strong> <input type="text" name="nickname" value="<%= nickname %>"></p>
        <p><strong>이메일:</strong> <input type="email" name="email" value="<%= email %>"></p>
        <p><strong>비밀번호:</strong> <input type="password" name="password" required></p>
        <p><strong>비밀번호 확인:</strong> <input type="password" name="confirmPassword" required></p>
        <button type="submit">수정하기</button>
        <a href="mypage.jsp" class="btn">내 정보로 돌아가기</a>
    </form>
</section>

<footer>
    <p>&copy; 2025 게시판 시스템</p>
</footer>

</body>
</html>
