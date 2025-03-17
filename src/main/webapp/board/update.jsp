<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>

<%
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");
    request.setCharacterEncoding("UTF-8");

    // 게시글 ID 가져오기 (URL 파라미터에서)
    String postId = request.getParameter("id");
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO board = null;

    // 게시글 조회
    if (postId != null) {
        board = boardDAO.getBoardDetail(Integer.parseInt(postId));
    }

    // 폼 제출 시 수정 작업 처리
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // DTO 객체에 새 데이터 설정
        board.setTitle(title);
        board.setContent(content);

        // 게시글 업데이트
        boolean isUpdated = boardDAO.updatePost(board);

        // 수정 결과에 따라 메시지 출력
        if (isUpdated) {
            out.print("<script>alert('게시글이 수정되었습니다.'); window.location='detail.jsp?id" + board.getId() + "';</script>");
        } else {
            out.print("<script>alert('수정 실패. 다시 시도해주세요.'); history.back();</script>");
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="../css/board.css">
</head>
<body>

    <header>
        <h1>게시판</h1>
    </header>

    <div class="header-actions">
        <% if (username == null) { %>
            <a href="../login/login.jsp" class="login-btn">로그인</a>
        <% } else { %>
            <span><%= (nickname != null) ? nickname : username %>님</span>
            <a href="../mypage/mypage.jsp" class="mypage-btn">마이 페이지</a>
            <a href="../login/logout.jsp" class="login-btn">로그아웃</a>
        <% } %>
    </div>

    <section class="post-update">
        <h2>게시글 수정</h2>

        <form action="update.jsp?id=<%= request.getParameter("id") %>" method="post">
            <div>
                <label for="title">제목</label>
                <input type="text" id="title" name="title" value="<%= board != null ? board.getTitle() : "" %>" required>
            </div>

            <div>
                <label for="content">내용</label>
                <textarea id="content" name="content" rows="10" required><%= board != null ? board.getContent() : "" %></textarea>
            </div>

            <div>
                <button type="submit" class="btn">수정 완료</button>
            </div>
        </form>

        <form action="board.jsp">
            <input type="submit" value="목록으로 돌아가기" class="btn">
        </form>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
