<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="util.DatabaseUtil" %>
<%
    String postIdParam = request.getParameter("id");

    if (postIdParam == null) {
        out.println("<script>alert('게시글 ID가 잘못되었습니다.'); location.href='index.jsp';</script>");
        return;
    }

    int postId = Integer.parseInt(postIdParam);
    
    // DAO 객체 생성
    BoardDAO boardDAO = new BoardDAO();
    CommentDAO commentDAO = new CommentDAO();

    try {
        // 댓글 삭제
        int deletedCommentsCount = commentDAO.deleteCommentsByPostId(postId);
        if (deletedCommentsCount > 0) {
            System.out.println("댓글이 삭제되었습니다.");
        }
        
        // 게시글 삭제
        boolean isDeleted = boardDAO.deletePost(postId);
        if (isDeleted) {
            out.println("<script>alert('게시글이 삭제되었습니다.'); location.href='index.jsp';</script>");
        } else {
            out.println("<script>alert('게시글 삭제에 실패했습니다.'); location.href='index.jsp';</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    }
%>
