<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String search = "";
	if(request.getParameter("search")!=null){
		search = request.getParameter("search");
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
	String sql = null;
	PreparedStatement stmt = null;
	if(search==null){
		sql = "SELECT de.emp_no empNO, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name,' ',e.last_name) empName, d.dept_name deptName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else{
		sql = "SELECT de.emp_no empNO, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name,' ',e.last_name) empName, d.dept_name deptName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		stmt.setString(2, "%"+search+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
	}
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
	String countSql = null;
	PreparedStatement countStmt = null;
	if(search==null){
		countSql = "SELECT COUNT(*) cnt FROM dept_emp";
		countStmt = conn.prepareStatement(countSql);
	}else{
		countSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+search+"%");
		countStmt.setString(2, "%"+search+"%");
	}
	
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
		<div style="float:right">
			<form action="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp">
				<input type="text" name="search" value="<%=search%>" placeholder="검색어를 입력하세요">
				<button type="submit">검색</button>
			</form>
		</div>
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
		<!-- 페이징처리 -->
		<div>
			<ul class="pagination justify-content-center">
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=1&search=<%=search%>">처음으로</a></li>
				<%
					if(currentPage>1){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link active" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage%>&search=<%=search%>"><%=currentPage%></a></li>
				<%
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage%>&search=<%=search%>">마지막으로</a>	</li>
			</ul>
		</div>
	</div>
</body>
</html>