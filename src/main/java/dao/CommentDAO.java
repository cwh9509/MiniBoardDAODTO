package dao;

import dto.CommentDTO;
import util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 댓글 추가
    public int addComment(int postId, String content, String writer) {
        int result = 0;
        String sql = "INSERT INTO comments (board_id, content, writer, date) VALUES (?, ?, ?, NOW())";
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            pstmt.setString(2, content);
            pstmt.setString(3, writer);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    // 댓글 삭제
    public int deleteComment(int commentId) {
        int result = 0;
        String sql = "DELETE FROM comments WHERE id = ?";
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    // 특정 게시글의 댓글 목록 가져오기
    public List<CommentDTO> getCommentsByPostId(int postId) {
        List<CommentDTO> commentList = new ArrayList<>();
        String sql = "SELECT id, content, writer, date FROM comments WHERE board_id = ? ORDER BY date ASC";
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                CommentDTO comment = new CommentDTO();
                comment.setId(rs.getInt("id"));
                comment.setBoardId(postId);
                comment.setContent(rs.getString("content"));
                comment.setWriter(rs.getString("writer"));
                comment.setDate(rs.getString("date"));
                commentList.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return commentList;
    }
	    
    // 사용자의 댓글을 페이징 처리하여 가져오는 메서드
    public List<CommentDTO> getUserComments(String nickname, int pageSize, int startRow) {
        List<CommentDTO> commentList = new ArrayList<>();
        String sql = "SELECT c.id, c.content, c.date, b.title, b.id AS board_id " +
                     "FROM comments c " +
                     "JOIN board b ON c.board_id = b.id " +  // c.post_id -> c.board_id로 수정
                     "WHERE c.writer = ? " +
                     "ORDER BY c.date DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nickname);
            pstmt.setInt(2, pageSize);
            pstmt.setInt(3, startRow);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommentDTO comment = new CommentDTO();
                    comment.setId(rs.getInt("id"));
                    comment.setContent(rs.getString("content"));
                    comment.setDate(rs.getString("date"));
                    comment.setBoardId(rs.getInt("board_id"));  // 게시글 ID 저장
                    comment.setTitle(rs.getString("title"));   // 게시글 제목 저장
                    commentList.add(comment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return commentList;
    }

    // 전체 댓글 수를 가져오는 메서드
    public int getTotalComments(String nickname) {
        int totalComments = 0;
        String countQuery = "SELECT COUNT(*) FROM comments WHERE writer = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(countQuery)) {
            pstmt.setString(1, nickname);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalComments = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalComments;
    }
	    
 // 특정 게시글의 댓글 삭제
    public int deleteCommentsByPostId(int postId) {
        int result = 0;
        String sql = "DELETE FROM comments WHERE board_id = ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return result;
    }

    
    // DB 연결 해제 (공통)
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
