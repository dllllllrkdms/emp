<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석(Controller)
	
	// 2. 요청 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	// 외부 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//System.out.println("드라이버 로딩 성공");
	// 데이터베이스 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); 
	// 쿼리 생성 
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_No asc";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	ResultSet rs = stmt.executeQuery(); // <-- 모델 데이터 ResultSet은 일반적,독립적인 타입이 아니다.
	
	// ResultSet rs라는 모델 자료구조를 좀더 일반적이고 독립적인 자료구조로 변경하기 
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()){ // ResultSet의 API(사용방법)을 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		a{
			text-decoration:none;
		}
		#div-table{			
			border-radius:16px;
			box-shadow: 0 0 8px;
			overflow: hidden;
		}
		
	</style>
</head>
<body>
	<div class="container">
		<div><h1 style="text-align:center">DEPT LIST</h1></div>
		<div style="float:right">
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
		</div>
		<br>
		<div id="div-table">
			<!-- 부서 목록(부서번호 오름차순) -->
			<table class="table">
				<thead class="table-danger" style="border-radius:16px">
					<tr>
						<th>부서번호</th>
						<th>부서명</th>
						<th>수정</th>
						<th>삭제</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Department d : list){
					%>
							<tr>
								<td><%=d.deptNo%></td>
								<td><%=d.deptName%></td>
								<td><a href="">수정</a></td>
								<td><a href="<%=request.getContextPath()%>/dept/deleteDeptForm.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
							</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>

