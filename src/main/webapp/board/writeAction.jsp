<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%
request.setCharacterEncoding("UTF-8");
String title = request.getParameter("title");
String content = request.getParameter("content");
String writer = (String) session.getAttribute("nickname");  // 세션에서 닉네임 가져오기

if (writer == null) {
    response.sendRedirect("../login/login.jsp");  // 로그인되지 않은 상태에서 작성 시 로그인 페이지로 리디렉션
    return;
}

BoardDAO boardDAO = new BoardDAO();
BoardDTO board = new BoardDTO();
board.setTitle(title);
board.setContent(content);
board.setWriter(writer);

boolean isInserted = boardDAO.insertPost(board);

if (isInserted) {
    response.sendRedirect("board.jsp");  // 게시글 작성 완료 후, 게시판 목록으로 리디렉션
} else {
    out.println("<script>");
    out.println("alert('게시글 작성에 실패했습니다.');");
    out.println("history.back();");
    out.println("</script>");
}
%>
