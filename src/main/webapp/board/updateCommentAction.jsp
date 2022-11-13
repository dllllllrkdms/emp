<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null || request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	if(request.getParameter("commentNo")==null || request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo"));
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String updateSql = "UPDATE comment SET comment_content=? WHERE comment_no=? and comment_pw=?"; 
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, commentContent);
	updateStmt.setInt(2, commentNo);
	updateStmt.setString(3, commentPw);
	int row = updateStmt.executeUpdate();
	if(row==1){
		System.out.println("댓글 수정 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else{
		System.out.println("댓글 수정 실패");
		String msg = URLEncoder.encode(" * 다시 입력해주세요.","UTF-8");
		System.out.println(msg+"<--updateCommentAction/else문");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
	}
	
	// 3. 결과 출력
	// 3. 결과 출력
%>