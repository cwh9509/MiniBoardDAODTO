package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dto.UserDTO;
import util.DatabaseUtil;

public class UserDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 아이디 중복 체크
    public boolean checkUsernameExist(String username) {
        boolean isExist = false;
        String sql = "SELECT username FROM users WHERE username = ?";
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                isExist = true; // 아이디가 존재하면 true
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return isExist;
    }

    // 닉네임 중복 체크
    public boolean checkNicknameExist(String nickname) {
        boolean isExist = false;
        String sql = "SELECT nickname FROM users WHERE nickname = ?";
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                isExist = true; // 닉네임이 존재하면 true
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return isExist;
    }

    // 회원가입 처리
    public boolean registerUser(UserDTO user) {
        boolean isRegistered = false;
        String sql = "INSERT INTO users (username, nickname, password, email) VALUES (?, ?, ?, ?)";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getNickname());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getEmail());

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isRegistered = true;  // 회원가입 성공
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return isRegistered;
    }
    // 로그인
    public UserDTO loginUser(String username, String password) {
        UserDTO user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new UserDTO();
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return user;
    }
    
    // 사용자 정보 가져오기
    public UserDTO getUserInfo(String username) {
        UserDTO user = null;
        String sql = "SELECT username, nickname, email FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
             
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new UserDTO();
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    
	 // 특정 사용자의 정보 가져오기
	    public UserDTO getUserByUsername(String username) {
	        UserDTO user = null;
	        String sql = "SELECT username, nickname, email FROM users WHERE username = ?";
	
	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	
	            pstmt.setString(1, username);
	            ResultSet rs = pstmt.executeQuery();
	
	            if (rs.next()) {
	                user = new UserDTO();
	                user.setUsername(rs.getString("username"));
	                user.setNickname(rs.getString("nickname"));
	                user.setEmail(rs.getString("email"));
	            }
	            rs.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return user;
	    }
    
    
	 // 회원 정보 수정
	    public boolean updateUser(UserDTO user) {
	        String sql = "UPDATE users SET nickname = ?, password = ?, email = ? WHERE username = ?";
	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	             
	            pstmt.setString(1, user.getNickname());
	            pstmt.setString(2, user.getPassword());
	            pstmt.setString(3, user.getEmail());
	            pstmt.setString(4, user.getUsername());

	            int result = pstmt.executeUpdate();
	            return result > 0; // 수정 성공 여부 반환

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }

	    public boolean checkPassword(String username, String password) {
	        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setString(1, username);
	            pstmt.setString(2, password);
	            ResultSet rs = pstmt.executeQuery();
	            return rs.next();  // 비밀번호가 맞으면 true
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	    
	    
	 // 계정 삭제 처리
	    public boolean deleteUser(String username, String nickname) {
	        boolean isDeleted = false;
	        Connection conn = null;
	        PreparedStatement pstmt = null;

	        try {
	            conn = DatabaseUtil.getConnection();

	            // 트랜잭션 시작
	            conn.setAutoCommit(false);

	            // 사용자가 작성한 게시글 삭제
	            String deletePostsSql = "DELETE FROM board WHERE writer = ?";
	            pstmt = conn.prepareStatement(deletePostsSql);
	            pstmt.setString(1, nickname);
	            pstmt.executeUpdate();

	            // 사용자가 작성한 댓글 삭제
	            String deleteCommentsSql = "DELETE FROM comments WHERE writer = ?";
	            pstmt = conn.prepareStatement(deleteCommentsSql);
	            pstmt.setString(1, nickname);
	            pstmt.executeUpdate();

	            // 사용자 정보 삭제
	            String deleteUserSql = "DELETE FROM users WHERE username = ?";
	            pstmt = conn.prepareStatement(deleteUserSql);
	            pstmt.setString(1, username);
	            int result = pstmt.executeUpdate();

	            if (result > 0) {
	                // 커밋
	                conn.commit();
	                isDeleted = true;
	            } else {
	                // 롤백
	                conn.rollback();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	            try {
	                // 예외 발생 시 롤백
	                if (conn != null) {
	                    conn.rollback();
	                }
	            } catch (SQLException ex) {
	                ex.printStackTrace();
	            }
	        } finally {
	            try {
	                if (pstmt != null) pstmt.close();
	                if (conn != null) conn.close();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }

	        return isDeleted;
	    }
	    
	    public boolean changePassword(String username, String currentPassword, String newPassword) {
	        boolean isChanged = false;
	        String sql = "SELECT password FROM users WHERE username = ?";

	        try (Connection conn = DatabaseUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setString(1, username);
	            ResultSet rs = pstmt.executeQuery();

	            if (rs.next()) {
	                String storedPassword = rs.getString("password");

	                // 현재 비밀번호가 일치하면 새 비밀번호로 변경
	                if (storedPassword.equals(currentPassword)) {
	                    sql = "UPDATE users SET password = ? WHERE username = ?";
	                    try (PreparedStatement updatePstmt = conn.prepareStatement(sql)) {
	                        updatePstmt.setString(1, newPassword);
	                        updatePstmt.setString(2, username);
	                        int rowsAffected = updatePstmt.executeUpdate();
	                        if (rowsAffected > 0) {
	                            isChanged = true; // 비밀번호 변경 성공
	                        }
	                    }
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return isChanged;
	    }
	    
    // 자원 해제
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
