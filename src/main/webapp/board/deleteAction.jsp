<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BoardDAO"%>
<%@ page import="util.DatabaseUtil"%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // id 파라미터 확인
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int postId = 0;
    try {
        postId = Integer.parseInt(idStr); // 숫자 형식으로 변환
    } catch (NumberFormatException e) {
        out.println("<script>alert('잘못된 게시글 ID입니다.'); history.back();</script>");
        return;
    }

    BoardDAO boardDAO = new BoardDAO();

    boolean isDeleted = boardDAO.deletePost(postId);  // 게시글 삭제 시도

    if (isDeleted) {
        response.sendRedirect("board.jsp"); // 삭제 성공 시 리다이렉트
    } else {
        out.println("<script>alert('삭제에 실패했습니다.'); history.back();</script>");
    }
%>
