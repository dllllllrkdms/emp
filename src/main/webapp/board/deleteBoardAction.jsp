<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null || request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	if(boardPw == null){ //|| boardPw.equals("") 비밀번호가 공백으로 넘어오면 어차피 요청 처리에서 비밀번호가 틀려서 삭제되지 않기 때문에 써도되고, 안써도됨 + 입력하지 않으면 넘어오지 않게 막아둠
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
	if(row == 1){ // 영향받은 행 수로 디버깅
		//System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else{
		//System.out.println("삭제 실패");
		String msg = URLEncoder.encode(" 비밀번호를 입력해주세요.","UTF-8"); // 삭제 실패시에 보낼 메세지, get방식으로 보낼때 한글깨짐 방지
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	
	// 3. 결과 출력
%>