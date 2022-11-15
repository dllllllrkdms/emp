<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%> <!-- HashMap<키,값>, ArrayList<요소> -->
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String search = "" ; 
	if(request.getParameter("search")!=null){
		search = request.getParameter("search");
	}
	// 2. 요청 처리 
	// paging 
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	// 매개변수에는 값을 직접적으로 넣는것보다는 변수를 만들어서 입력하는게 유지보수에 좋음
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees"; // "프로토콜://주소:포트번호/데이터베이스 이름"
	String dbUser = "root"; 
	String dbPw = "java1234";
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // db 연결
	String sql = null;
	PreparedStatement stmt = null;
	if(search==null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY e.emp_no ASC LIMIT ?,? "; 
		// CONCAT() 행을 합쳐서 추출 FK(외래키)가 있는 테이블을 먼저 작성 /ON 행을 합치는 조건 
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else{
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY e.emp_no ASC LIMIT ?,? "; 
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		stmt.setString(2, "%"+search+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);
	}
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> hmList = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> hm  = new HashMap<String, Object>();
		hm.put("empNo", rs.getInt("empNo"));
		hm.put("salary", rs.getInt("salary"));
		hm.put("fromDate", rs.getString("fromDate"));
		hm.put("toDate", rs.getString("toDate"));
		hm.put("name", rs.getString("name"));
		hmList.add(hm);
	}
	rs.close();
	stmt.close();
	// 2-2 페이징
	String countSql = null;
	PreparedStatement countStmt = null;
	if(search==null){
		countSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no";
		countStmt = conn.prepareStatement(countSql);
	} else{
		countSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
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
	if(cnt%rowPerPage!=0){
		lastPage+=1;
	}
	countRs.close();
	countStmt.close();
	conn.close(); // 불필요한 db연결을 끊어주는 메소드 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>salaryMapList</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- 메뉴 -->
		</div>
		<h1>연봉관리</h1>
		<div style="float: right">
			<form action="<%=request.getContextPath()%>/salary/salaryMapList.jsp" method="post">
				<input type="text" name="search" value="<%=search%>" placeholder="검색어를 입력해주세요">
				<button type="submit">검색</button>
			</form>
		</div>
		<div id="div-table">
			<table class="table">
				<thead class="table-primary">
					<tr>
						<th>NO</th>
						<th>NAME</th>
						<th>연봉</th>
						<th>계약일자</th>
						<th>만료일자</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(HashMap<String, Object> hm : hmList){
					%>		
							<tr>
								<td><%=hm.get("empNo")%></td>
								<td><%=hm.get("name")%></td>
								<td><%=hm.get("salary")%></td>
								<td><%=hm.get("fromDate")%></td>
								<td><%=hm.get("toDate")%></td>
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
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1&search=<%=search%>">처음으로</a></li>
				<%
					if(currentPage>1){
				%>
					<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item active"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage%>&search=<%=search%>"><%=currentPage%></a></li>
				<%
					if(currentPage<lastPage){
				%>
					<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>&search=<%=search%>">마지막으로</a></li>
			</ul>
		</div>
	</div>
</body>
</html>