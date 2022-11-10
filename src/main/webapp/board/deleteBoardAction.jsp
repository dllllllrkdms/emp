<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	if(boardPw == null || boardPw.equals("")){
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp");
		return;
	}
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db 연결
	String sql = "DELETE FROM board WHERE board_no =? and board_pw=?"; // 비밀번호가 일치해야만 삭제
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	int row = stmt.executeUpdate();
	String msg = ""; // 삭제 실패했을 시에 보낼 메세지
	if(row == 1){
		System.out.println("삭제 성공");
	} else{
		System.out.println("삭제 실패");
		msg = URLEncoder.encode("다시 입력해주세요","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>