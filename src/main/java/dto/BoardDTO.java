package dto;

public class BoardDTO {
	private int id;  // 게시글 고유 ID
	private String title;  // 제목
	private String writer;
	private String date;
	private int views;
	private String content;
	
	public BoardDTO() { super(); }

	public int getId() { return id; }
	public void setId(int id) { this.id = id; }
	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }
	public String getWriter() { return writer; }
	public void setWriter(String writer) { this.writer = writer; }
	public String getDate() { return date; }
	public void setDate(String date) { this.date = date; }
	public int getViews() { return views; }
	public void setViews(int views) { this.views = views; }
	public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
	public BoardDTO(int id, String title, String writer,String content, String date, int views) {
		super();
		this.id = id;
		this.title = title;
		this.writer = writer;
		this.content = content;
		this.date = date;
		this.views = views;
		
	}


}
