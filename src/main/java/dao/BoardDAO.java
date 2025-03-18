package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.BoardDTO;
import util.DatabaseUtil;

public class BoardDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 전체 게시글 가져오기
	public int getTotalPosts(String searchCategory, String searchKeyword) {
	    int totalPosts = 0;
	    boolean hasSearch = searchKeyword != null && !searchKeyword.isEmpty();
	    
	    String sql = "SELECT COUNT(*) FROM board";
	    if (hasSearch) {
	        sql += " WHERE " + searchCategory + " LIKE ?";
	    }

	    try {
	        conn = DatabaseUtil.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        if (hasSearch) {
	            pstmt.setString(1, "%" + searchKeyword + "%");
	        }

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            totalPosts = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        closeResources();
	    }
	    return totalPosts;
	}


	// DB 연결 해제 ( 공통 )
	private void closeResources() {
		try {
			if ( rs != null) rs.close();
			if ( pstmt != null) pstmt.close();
			if ( conn != null) conn.close();
		} catch ( Exception e) {
			e.printStackTrace();
		}
	}
	
	// 게시글 목록 가져오기 (검색 & 페이징 적용)
    public List<BoardDTO> getBoardList(String searchCategory, String searchKeyword, int startRow, int pageSize) {
        List<BoardDTO> boardList = new ArrayList<>();
        String sql = "SELECT id, title, writer, date, views FROM board WHERE 1=1";

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            if ("title".equals(searchCategory)) {
                sql += " AND title LIKE ?";
            } else if ("writer".equals(searchCategory)) {
                sql += " AND writer LIKE ?";
            }
        }

        sql += " ORDER BY id DESC LIMIT ? OFFSET ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                pstmt.setString(1, "%" + searchKeyword + "%");
                pstmt.setInt(2, pageSize);
                pstmt.setInt(3, startRow);
            } else {
                pstmt.setInt(1, pageSize);
                pstmt.setInt(2, startRow);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO board = new BoardDTO();
                board.setId(rs.getInt("id"));
                board.setTitle(rs.getString("title"));
                board.setWriter(rs.getString("writer"));
                board.setDate(rs.getString("date"));
                board.setViews(rs.getInt("views"));
                boardList.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return boardList;
    }
	
    
    // 게시글 상세보기
    public BoardDTO getBoardDetail(int postId) {
        BoardDTO board = null;
        String sql = "SELECT id, title, writer, content, date, views FROM board WHERE id = ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                board = new BoardDTO();
                board.setId(rs.getInt("id"));
                board.setTitle(rs.getString("title"));
                board.setWriter(rs.getString("writer"));
                board.setContent(rs.getString("content"));
                board.setDate(rs.getString("date"));
                board.setViews(rs.getInt("views"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return board;
    }
	
    // 게시글 작성하기
    public boolean insertPost(BoardDTO board) {
        boolean isInserted = false;
        String sql = "INSERT INTO board (title, content, writer, date, views) VALUES (?, ?, ?, NOW(), 0)";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setString(3, board.getWriter());

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isInserted = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return isInserted;
    }
    
	// 게시글 수정하기
    public boolean updatePost(BoardDTO board) {
        boolean isUpdated = false;
        String sql = "UPDATE board SET title = ?, content = ?, date = NOW() WHERE id = ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setInt(3, board.getId());

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isUpdated = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return isUpdated;
    }
    
    // 게시글 삭제하기
    public boolean deletePost(int postId) {
        boolean isDeleted = false;
        String sql = "DELETE FROM board WHERE id = ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isDeleted = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return isDeleted;
    }

	 // 사용자가 작성한 모든 게시글 삭제하기
	    public int deletePostsByUsername(String username) {
	        int result = 0;
	        String sql = "DELETE FROM board WHERE writer = ?";  // 'writer' 컬럼을 사용하여 작성자 기준으로 삭제
	
	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	
	            pstmt.setString(1, username);  // 사용자 닉네임 또는 사용자 ID로 설정
	            result = pstmt.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	
	        return result;
	    }

    
 
}