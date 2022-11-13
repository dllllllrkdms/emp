<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 1. 요청 분석
	// 방어코드 (commentPw는 처리부분에서 일치하지 않으면 )
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
	String commentPw = request.getParameter("commentPw");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String deleteSql = "DELETE FROM comment WHERE comment_no = ? and comment_pw = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setInt(1, commentNo);
	deleteStmt.setString(2, commentPw);
	int row = deleteStmt.executeUpdate();
	if(row==1){
		System.out.println("댓글 삭제 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else{
		System.out.println("댓글 삭제 실패");
		String msg = URLEncoder.encode(" * 다시 시도해주세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
	}
	
	// 3. 결과출력
%>
