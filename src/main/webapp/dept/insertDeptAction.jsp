<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청 분석
	request.getParameter("UTF-8");
	String deptName = request.getParameter("deptName");
	String deptNo = request.getParameter("deptNo");
	
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection connection = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	String sql = "INSERT INTO departments(dept_no, dept_name) VALUES (?,?)";
	PreparedStatement stmt = connection.prepareStatement(sql); // 쿼리 생성
	stmt.setString(1, deptNo); 
	stmt.setString(2, deptName);
	int row = stmt.executeUpdate(); // 쿼리 실행
	if(row==1){
		System.out.println("추가 성공");
	} else{
		System.out.println("추가 실패");
	}
	
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>

