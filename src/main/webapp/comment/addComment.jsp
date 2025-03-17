<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>

<%
    request.setCharacterEncoding("UTF-8");
    String comment = request.getParameter("comment");
    String postId = request.getParameter("postId");

    // 세션에서 사용자 닉네임 가져오기
    String writer = (String) session.getAttribute("nickname");

    // 로그인하지 않은 사용자 처리
    if (writer == null) {
        out.println("<script>alert('로그인 후 댓글을 작성할 수 있습니다.'); location.href='../login/login.jsp';</script>");
        return;
    }

    // CommentDAO 객체 생성
    CommentDAO commentDAO = new CommentDAO();
    int postIdInt = Integer.parseInt(postId);
    
    // 댓글 추가
    int result = commentDAO.addComment(postIdInt, comment, writer);

    if (result > 0) {
        // 댓글이 정상적으로 추가되면 게시글 상세 페이지로 리디렉션
        response.sendRedirect("../board/detail.jsp?id=" + postId);
    } else {
        out.println("<script>");
        out.println("alert('댓글 작성에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>
