<%@ page import="java.util.List" %>
<%@ page import="dao.BoardDAO" %>
<%@ page import="dto.BoardDTO" %>
<%@ page import="util.DatabaseUtil" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");
    request.setCharacterEncoding("UTF-8");

    String searchKeyword = request.getParameter("searchKeyword");
    String searchCategory = request.getParameter("searchCategory");

    int pages = 1;
    int pageSize = 10;
    String pageNumStr = request.getParameter("pages");
    if (pageNumStr != null && !pageNumStr.isEmpty()) {
        try {
            pages = Integer.parseInt(pageNumStr);
            if (pages < 1) pages = 1; // 1보다 작은 값 방지
        } catch (NumberFormatException e) {
            pages = 1; // 잘못된 값이 들어오면 기본값 유지
        }
    }
    
    int startRow = (pages - 1) * pageSize;

    // DAO 사용하여 총 게시글 개수 가져오기
    BoardDAO boardDAO = new BoardDAO();
    int totalPosts = boardDAO.getTotalPosts(searchCategory, searchKeyword);

    // DAO 사용하여 게시글 목록 가져오기
    List<BoardDTO> boardList = boardDAO.getBoardList(searchCategory, searchKeyword, startRow, pageSize);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판 목록</title>
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

    <section class="board-list">
        <div class="board-header">
            <h3 class="board-title">게시글 목록</h3>
            <form method="get" class="search-form">
                <select name="searchCategory">
                    <option value="title" <%= "title".equals(searchCategory) ? "selected" : "" %>>제목</option>
                    <option value="writer" <%= "writer".equals(searchCategory) ? "selected" : "" %>>작성자</option>
                </select>
                <input type="text" name="searchKeyword" value="<%= searchKeyword != null ? searchKeyword : "" %>" placeholder="검색어 입력">
                <button type="submit">검색</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <% for (BoardDTO board : boardList) { %>
                    <tr>
                        <td><%= board.getId() %></td>
                        <td><a href="detail.jsp?id=<%= board.getId() %>"><%= board.getTitle() %></a></td>
                        <td><%= board.getWriter() %></td>
                        <td><%= board.getDate() %></td>
                        <td><%= board.getViews() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div class="pagination">
            <% int totalPages = (int) Math.ceil((double) totalPosts / pageSize);
                if (pages > 1) { %>
                <a href="?pages=<%= pages - 1 %>&searchKeyword=<%= searchKeyword != null ? searchKeyword : "" %>&searchCategory=<%= searchCategory != null ? searchCategory : "" %>">&lt;</a>
            <% } %>

            <% for(int i = 1; i <= totalPages; i++) { %>
                <a href="?pages=<%= i %>&searchKeyword=<%= searchKeyword != null ? searchKeyword : "" %>&searchCategory=<%= searchCategory != null ? searchCategory : "" %>" <%= pages == i ? "class='active'" : "" %>><%= i %></a>
            <% } %>

            <% if(pages < totalPages) { %>
                <a href="?pages=<%= pages + 1 %>&searchKeyword=<%= searchKeyword != null ? searchKeyword : "" %>&searchCategory=<%= searchCategory != null ? searchCategory : "" %>">&gt;</a>
            <% } %>
        </div>

        <div class="board-actions">
            <a href="write.jsp" class="btn">새 게시글 작성</a>
        </div>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
