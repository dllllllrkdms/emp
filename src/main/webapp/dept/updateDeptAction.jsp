<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Department"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	if(deptName==null || deptName.equals("")){
		String msg = URLEncoder.encode("부서명을 입력해주세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?deptNo="+deptNo+"&msg="+msg);
		return;
	}
	Department dept = new Department(); // 1번과 2번 페이지가 분리되었을때 묶어서 보내는게 더좋기 때문에 데이터 묶어두기
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 외부 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결\
	// 2-1 dept_name 중복검사
	String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, dept.deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){
		String msg =URLEncoder.encode("사용할 수 없습니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?deptNo="+dept.deptNo+"&msg="+msg); 
		// deptNo를 넘기지 않으면 null로 넘어가기 때문에 form 요청분석에서 무한루프가 발생 -> deptNo값도 같이 넘겨준다
		return;
	}
	// 2-2 수정
	String sql2 = "UPDATE departments SET dept_name = ? WHERE dept_no = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, dept.deptName);
	stmt2.setString(2, dept.deptNo);
	int row = stmt2.executeUpdate();
	/*
	if(row==1){
		System.out.println("수정 성공");
	} else {
		System.out.println("수정 실패");
	}
	*/
	// 3. 결과 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); 

%>
