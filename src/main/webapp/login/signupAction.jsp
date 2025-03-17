<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 폼 데이터 받기
    String username = request.getParameter("username");
    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String email = request.getParameter("email");

    UserDAO userDAO = new UserDAO();

    // 비밀번호 확인 검사
    if (!password.equals(confirmPassword)) {
%>
        <script>
            alert('비밀번호가 일치하지 않습니다.');
            history.back();
        </script>
<%
        return;
    }

    // 아이디 중복 체크
    if (userDAO.checkUsernameExist(username)) {
%>
        <script>
            alert('이미 존재하는 아이디입니다.');
            history.back();
        </script>
<%
        return;
    }

    // 닉네임 중복 체크
    if (userDAO.checkNicknameExist(nickname)) {
%>
        <script>
            alert('이미 존재하는 닉네임입니다.');
            history.back();
        </script>
<%
        return;
    }

    // 회원가입 진행
    UserDTO user = new UserDTO(username, nickname, password, email);
    boolean isRegistered = userDAO.registerUser(user);

    if (isRegistered) {
%>
        <script>
            alert('회원가입이 완료되었습니다.');
            location.href = 'login.jsp';
        </script>
<%
    } else {
%>
        <script>
            alert('회원가입에 실패했습니다. 다시 시도해주세요.');
            history.back();
        </script>
<%
    }
%>
