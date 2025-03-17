<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="dto.CommentDTO" %>

<%
    request.setCharacterEncoding("UTF-8");
    String postIdStr = request.getParameter("id");
    
    if (postIdStr == null) {
        out.println("<script>alert('게시글 ID가 잘못되었습니다.'); location.href='board.jsp';</script>");
        return;
    }
    
    int postId = Integer.parseInt(postIdStr);
    BoardDAO boardDAO = new BoardDAO();
    CommentDAO commentDAO = new CommentDAO();
    
    // 게시글 상세 정보 가져오기
    BoardDTO post = boardDAO.getBoardDetail(postId);
    
    if (post == null) {
        out.println("<script>alert('존재하지 않는 게시글입니다.'); location.href='board.jsp';</script>");
        return;
    }
    
    // 댓글 목록 가져오기
    List<CommentDTO> comments = commentDAO.getCommentsByPostId(postId);
    
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세 보기</title>
    <link rel="stylesheet" type="text/css" href="../css/board.css">
</head>
<body>
    <header>
        <h1>게시판</h1>
        <div class="header-actions">
            <% if (username == null) { %>
                <a href="../login/login.jsp" class="login-btn">로그인</a>
            <% } else { %>
                <span><%= nickname %>님</span>
                <a href="../login/logout.jsp" class="login-btn">로그아웃</a>
            <% } %>
        </div>
    </header>

    <section class="post-detail">
        <h2><%= post.getTitle() %></h2>
        <p><strong>작성자:</strong> <%= post.getWriter() %> | <strong>작성일:</strong> <%= post.getDate() %> | <strong>조회수:</strong> <%= post.getViews() %></p>
        <p><%= post.getContent() %></p>

        <div class="post-actions">
            <% if (nickname != null && nickname.equals(post.getWriter())) { %>
                <a href="update.jsp?id=<%= postId %>" class="btn">수정</a>
                <a href="deleteAction.jsp?id=<%= postId %>" class="btn">삭제</a>
            <% } %>
        </div>

        <h3>댓글</h3>
        <ul class="comments-list">
            <% for (CommentDTO comment : comments) { %>
            <li>
                <div class="comment-header">
                    <strong><%= comment.getWriter() %> <%= comment.getDate() %></strong>
                </div>
                <div class="comment-content">
                    <%= comment.getContent() %>
                </div>
                <% if (nickname != null && nickname.equals(comment.getWriter())) { %>
                <a href="../comment/deleteComment.jsp?id=<%= comment.getId() %>&postId=<%= postId %>" class="comment-delete-btn">삭제</a>
                <% } %>
            </li>
            <% } %>
        </ul>

        <% if (nickname != null) { %>
            <form action="../comment/addComment.jsp" method="post" class="comment-form">
			    <textarea name="comment" placeholder="댓글을 작성하세요..." required></textarea>
			    <input type="hidden" name="postId" value="<%= postId %>">
			    <input type="submit" value="댓글 작성">
			</form>

        <% } else { %>
            <p>댓글을 작성하려면 <a href="../login/login.jsp">로그인</a>하세요.</p>
        <% } %>

        <form action="board.jsp">
            <input type="submit" value="목록으로 돌아가기">
        </form>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
