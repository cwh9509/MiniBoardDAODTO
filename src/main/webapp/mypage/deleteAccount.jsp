<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>
<%
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");

    if (username == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    boolean isDeleted = userDAO.deleteUser(username, nickname); // 계정 삭제

    if (isDeleted) {
        session.invalidate(); // 세션 무효화
        out.println("<script>alert('계정이 삭제되었습니다.'); location.href='../login/login.jsp';</script>");
    } else {
        out.println("<p>계정 삭제에 실패했습니다. 다시 시도해주세요.</p>");
    }
%>
