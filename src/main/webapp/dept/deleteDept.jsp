<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청 분석 Controller
	request.setCharacterEncoding("UTF-8");
	String deptNo = request.getParameter("deptNo");
	
	// 2. 요청 처리 Model
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	//System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String sql = "DELETE FROM departments where dept_no = ?"; // 쿼리 작성 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	int row = stmt.executeUpdate(); // 쿼리 실행
	if(row==1){ // 영항받은 행 수로 디버깅
		System.out.println("삭제 성공");
	}else {
		System.out.println("삭제 실패");
	}
	
	// 3. 결과 출력 View
	// 결과 출력이 없음
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); 
%>