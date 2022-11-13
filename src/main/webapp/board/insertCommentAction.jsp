<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 1. 요청 분석 
	request.setCharacterEncoding("UTF-8");
	if(request.getParameter("boardNo")==null || request.getParameter("boardNo").equals("")){ // 방어코드
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	if(request.getParameter("commentContent")==null || request.getParameter("commentContent").equals("") // 빈칸이 넘어오지 않게
		|| request.getParameter("commentPw")==null || request.getParameter("commentPw").equals("")){ 
		String msg = URLEncoder.encode(" * 댓글 작성을 실패하였습니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo")+"&msg="+msg);
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	//System.out.println(commentContent+"<--insertCommentAction commentContent");
	String commentPw = request.getParameter("commentPw");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String insertSql = "INSERT INTO comment(board_no, comment_pw, comment_content, createdate) VALUES(?,?,?,curdate())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setInt(1, boardNo);
	insertStmt.setString(2, commentPw);
	insertStmt.setString(3, commentContent);
	int row = insertStmt.executeUpdate();
	if(row==1){
		//System.out.println("댓글 작성 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else{
		//System.out.println("댓글 작성 실패");
		String msg = URLEncoder.encode("댓글 작성을 실패하였습니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
	}
	
	
	// 3. 결과 출력
%>