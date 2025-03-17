package dto;

public class CommentDTO {
    private int id;
    private int boardId;     // 게시글 ID (외래키)
    private String writer;
    private String content;
    private String date;
    private String title;    // 게시글 제목 추가

    public CommentDTO() {}

    public CommentDTO(int id, int boardId, String writer, String content, String date, String title) {
        this.id = id;
        this.boardId = boardId;
        this.writer = writer;
        this.content = content;
        this.date = date;
        this.title = title;
    }

    // Getter와 Setter 추가
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
