<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	String boardWriter = request.getParameter("boardWriter");
	if(boardTitle==null || boardTitle.equals("") || boardContent==null || boardContent.equals("") || boardPw==null || boardPw.equals("") || boardWriter==null || boardWriter.equals("")){
		String msg = URLEncoder.encode("입력이 잘못되었습니다","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String insertSql = "INSERT INTO board(board_title, board_content, board_pw, board_writer, createdate) VALUES(?,?,?,?,curdate())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setString(1, boardTitle);
	insertStmt.setString(2, boardContent);
	insertStmt.setString(3, boardPw);
	insertStmt.setString(4, boardWriter);
	int row = insertStmt.executeUpdate();
	if(row==1){
		//System.out.println("추가 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	}else{
		//System.out.println("추가 실패");
		String msg =URLEncoder.encode(" * 다시 작성해주세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?msg="+msg);
	}
	
	
	
	
	// 3. 결과 출력
%>