<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>

<%
    // 폼에서 받은 값
    request.setCharacterEncoding("UTF-8");
    String postId = request.getParameter("id");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (postId == null || title == null || content == null || postId.isEmpty() || title.isEmpty() || content.isEmpty()) {
        out.println("<script>alert('필수 항목이 비어 있습니다.'); history.back();</script>");
        return;
    }

    // BoardDAO 객체 생성
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO board = new BoardDTO();

    // DTO에 폼에서 받은 값 설정
    board.setId(Integer.parseInt(postId));
    board.setTitle(title);
    board.setContent(content);

    // 게시글 수정
    boolean isUpdated = boardDAO.updatePost(board);

    if (isUpdated) {
        // 수정이 성공하면 게시글 상세 페이지로 리다이렉트
        response.sendRedirect("detail.jsp?id=" + postId);
    } else {
        // 수정이 실패하면 에러 메시지 출력
        out.println("<script>alert('게시글 수정에 실패했습니다.'); history.back();</script>");
    }
%>
