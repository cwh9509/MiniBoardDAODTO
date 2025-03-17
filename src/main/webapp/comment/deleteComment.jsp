<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>

<%
    String commentIdStr = request.getParameter("id");
    String postIdStr = request.getParameter("postId");

    if (commentIdStr == null || postIdStr == null) {
        out.println("<script>alert('잘못된 접근입니다.'); location.href='../board/board.jsp';</script>");
        return;
    }

    int commentId = Integer.parseInt(commentIdStr);
    int postId = Integer.parseInt(postIdStr);

    // CommentDAO 객체 생성
    CommentDAO commentDAO = new CommentDAO();

    // 댓글 삭제
    int result = commentDAO.deleteComment(commentId);

    if (result > 0) {
        // 삭제가 성공하면 게시글 상세 페이지로 리디렉션
        response.sendRedirect("../board/detail.jsp?id=" + postId);
    } else {
        out.println("<script>");
        out.println("alert('댓글 삭제에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>
