<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.*"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null){ // boardNo가 안넘어왔을 때 방어코드
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	if(request.getParameter("boardTitle")==null || request.getParameter("boardTitle").equals("") ||  request.getParameter("boardContent")==null ||  // 아무 내용이 없게 수정했을때
		request.getParameter("boardContent").equals("") || request.getParameter("boardPw")==null || request.getParameter("boardPw").equals("")){
		String msg = URLEncoder.encode("빈칸을 입력해주세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+request.getParameter("boardNo")+"&msg="+msg);
		return;
	}
	request.setCharacterEncoding("UTF-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "UPDATE board SET board_title =?, board_content =? WHERE board_no = ? AND board_pw=?"; // where A and B A,B 둘다 트루여야 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setInt(3, boardNo);
	stmt.setString(4, boardPw);
	int row = stmt.executeUpdate();
	String msg = "";
	if(row==1){
		System.out.println("수정 성공");
	}else{
		System.out.println("수정 실패");
		msg = URLEncoder.encode("다시 입력해주세요","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
	
	
	
	// 3. 결과출력
%>