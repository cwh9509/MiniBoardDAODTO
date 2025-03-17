<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UserDAO, dto.UserDTO" %>

<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    UserDAO userDAO = new UserDAO();
    UserDTO user = userDAO.loginUser(username, password);

    if (user != null) {
        session.setAttribute("username", user.getUsername());
        session.setAttribute("nickname", user.getNickname());
        response.sendRedirect("../board/board.jsp");
    } else {
%>
        <script>
            alert('아이디 또는 비밀번호가 잘못되었습니다.');
            history.back();
        </script>
<%
    }
%>
