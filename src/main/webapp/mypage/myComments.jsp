<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.CommentDAO" %>
<%@ page import="dto.CommentDTO" %>
<%
    // 세션에서 사용자 정보 가져오기
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");

    if (username == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // 페이징 처리 변수
    int pages = 1;
    int pageSize = 10;
    String pageNumStr = request.getParameter("pages");
    if (pageNumStr != null) {
        pages = Integer.parseInt(pageNumStr);
    }

    int startRow = (pages - 1) * pageSize;

    CommentDAO commentDAO = new CommentDAO();
    List<CommentDTO> commentList = commentDAO.getUserComments(nickname, pageSize, startRow);
    int totalComments = commentDAO.getTotalComments(nickname);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 댓글 보기</title>
    <link rel="stylesheet" type="text/css" href="../css/mypage.css">
</head>
<body>
    <header>
        <h1>내 댓글</h1>
    </header>
    <div class="header-actions">
        <a href="mypage.jsp" class="login-btn">마이 페이지로 돌아가기</a>
        <a href="../login/logout.jsp" class="login-btn">로그아웃</a>
    </div>
    
    <section class="my-comments">
        <h2 class="board-title">내가 작성한 댓글</h2>
        <table>
            <thead>
                <tr>
                    <th>내용</th>
                    <th>작성일</th>
                    <th>게시글</th>
                </tr>
            </thead>
            <tbody>
                <% for (CommentDTO comment : commentList) { %>
                    <tr>
                        <td><%= comment.getContent() %></td>
                        <td><%= comment.getDate() %></td>
                        <td><a href="../detail.jsp?id=<%= comment.getBoardId() %>"><%= comment.getTitle() %></a></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="pagination">
            <% int totalPages = (int) Math.ceil((double) totalComments / pageSize);
                if (pages > 1) { %>
                <a href="?pages=<%= pages - 1 %>">&lt;</a>
            <% } %>
            
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="?pages=<%= i %>" <%= pages == i ? "class='active'" : "" %>><%= i %></a>
            <% } %>
            
            <% if (pages < totalPages) { %>
                <a href="?pages=<%= pages + 1 %>">&gt;</a>
            <% } %>
        </div>
        
    </section>
    
    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
