<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석
	request.getParameter("UTF-8");
	String deptName = request.getParameter("deptName");
	String deptNo = request.getParameter("deptNo");
	
	if(deptNo==null || deptName==null || deptNo.equals("") || deptName.equals("")){
		String msg = URLEncoder.encode("부서 번호와 부서명을 입력하세요.","UTF-8"); // URLEncoder.encode : response.sendRedirect로 값을 보낼때 한글이 깨지지 않게
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	Department dept = new Department(); // 1번과 2번 페이지가 분리되었을때 묶어서 보내는게 더좋기 때문에 데이터 묶어두기
	dept.deptNo = deptNo;
	dept.deptName = deptName;
		
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	// 2-1 dept_no, dept_name 중복검사
	// 이미 존재하는 key값과 동일한 값이 입력되면 예외(에러)가 발생 -> 동일한 값이 입력됐을때 중복 검사 후에 돌려보내거나 입력시키기
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?"; // 같은 dept_no가 존재하는지 검사하는 쿼리
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, dept.deptNo);
	stmt1.setString(2, dept.deptName);
	ResultSet rs1 = stmt1.executeQuery(); // 쿼리 실행
	if (rs1.next()){ // rs.next()가 true다 -> 같은 dept_no나 같은 dept_name이 존재한다. -> form으로 다시 돌려보낸다.
		String msg = URLEncoder.encode("사용할 수 없습니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 2-2 추가 입력
	String sql2 = "INSERT INTO departments(dept_no, dept_name) VALUES (?,?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2); // 쿼리 생성
	stmt2.setString(1, dept.deptNo); 
	stmt2.setString(2, dept.deptName);
	int row = stmt2.executeUpdate(); // 쿼리 실행
	/*
	if(row==1){
		System.out.println("추가 성공");
	} else{
		System.out.println("추가 실패");
	}
	*/
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>

