<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청 처리
	int rowPerPage = 10;
	int beginRow = 0;
	
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	Class.forName(driver);
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Connection conn = DriverManager.getConnection(dbUrl,dbUser,dbPw);
	// 2-1 deptEmpList 모델 데이터 생성
	String sql = "SELECT de.emp_no empNo, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName, d.dept_name deptName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<DeptEmp> deptEmpList = new ArrayList<DeptEmp>();
	while(rs.next()){
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.dept = new Department();
		de.emp.empNo = rs.getInt("empNo");
		de.emp.firstName = rs.getString("firstName");
		de.emp.lastName = rs.getString("lastName");
		de.dept.deptName = rs.getString("deptName");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		deptEmpList.add(de);
	}
	rs.close();
	stmt.close();
	// 2-2 페이징
	String countSql = "SELECT COUNT(*) cnt FROM dept_emp";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int cnt = 0;
	if(countRs.next()){
		cnt = countRs.getInt("cnt");
	}
	int lastPage = cnt/rowPerPage;
	if(cnt%rowPerPage!=0){
		lastPage+=1;
	}
	countStmt.close();
	countRs.close();
	conn.close();
	// 3. 결과출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptEmpList</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 메뉴 partial -->
		</div>
		<h1>부서별 사원목록</h1>
		<div id="div-table">
			<table class="table">
				<thead class="table-primary">
					<tr>
						<th>사원 번호</th>
						<th>사원 이름</th>
						<th>계약일자</th>
						<th>만료일자</th>
						<th>부서 이름</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(DeptEmp de : deptEmpList){
					%>
							<tr>
								<td><%=de.emp.empNo%></td>
								<td><%=de.emp.firstName%> <%=de.emp.lastName%></td>
								<td><%=de.fromDate%></td>
								<td><%=de.toDate%></td>
								<td><%=de.dept.deptName%></td>
							</tr>
					<%		
						}
					%>
				</tbody>
			</table>
		</div>
		<br>
		<div>
			<ul class="pagination justify-content-center">
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음으로</a></li>
				<%
					if(currentPage>1){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link active" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage%>"><%=currentPage%></a></li>
				<%
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
				<%				
					}
				%>
					<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막으로</a></li>
			</ul>
		</div>
	</div>
</body>
</html>