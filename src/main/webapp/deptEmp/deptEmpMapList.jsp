<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청 분석
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청 처리
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver); // 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl,dbUser,dbPw); // db연결
	// 2-1 deptEmpList 모델데이터
	String sql = "SELECT de.emp_no empNO, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name,' ',e.last_name) empName, d.dept_name deptName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> hmList = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> hm = new HashMap<String, Object>();
		hm.put("empNo", rs.getInt("empNo"));
		hm.put("fromDate", rs.getString("fromDate"));
		hm.put("toDate", rs.getString("toDate"));
		hm.put("empName", rs.getString("empName"));
		hm.put("deptName", rs.getString("deptName"));
		hmList.add(hm);
	}
	stmt.close();
	rs.close();
	// 2-2 페이징
	String countSql = "SELECT COUNT(*) cnt FROM dept_emp";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int cnt = 0;
	if(countRs.next()){
		cnt = countRs.getInt("cnt");
	}
	int lastPage = cnt/rowPerPage;
	if(cnt%rowPerPage!=1){
		lastPage+=1;
	}
	countStmt.close();
	countRs.close();
	conn.close();	
	// 3. 결과 출력
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deptEmpMapList</title>
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
		<h1>부서별 사원 목록</h1>
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
						for(HashMap<String, Object> hm : hmList){
					%>
							<tr>
								<td><%=hm.get("empNo")%></td>
								<td><%=hm.get("empName")%></td>
								<td><%=hm.get("fromDate")%></td>
								<td><%=hm.get("toDate")%></td>
								<td><%=hm.get("deptName")%></td>
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
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=1">처음으로</a></li>
				<%
					if(currentPage>1){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link active" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage%>"><%=currentPage%></a></li>
				<%
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage%>">마지막으로</a>	</li>
			</ul>
		</div>
	</div>
</body>
</html>