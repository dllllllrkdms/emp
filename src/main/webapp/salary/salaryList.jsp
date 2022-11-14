<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="vo.*"%>
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
	int rowPerPage = 100;
	int beginRow = (currentPage-1)*rowPerPage;
	Class.forName("org.mariadb.jdbc.Driver"); // 외부 드라이버 로딩
	//System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // 데이터베이스 연결

	// 2-1 ArrayList<Salary> 모델데이터 생성
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(rs.next()){
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName=rs.getString("lastName");
		salaryList.add(s);
	}
	// 2-2 페이징 
	final int PAGE_COUNT = 10;
	int startPage = (currentPage-1)/PAGE_COUNT*PAGE_COUNT+1;
	int endPage = startPage + PAGE_COUNT -1;
	String countSql = "SELECT COUNT(*) cnt FROM salaries";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int cnt=0;
	if(countRs.next()){
		cnt = countRs.getInt("cnt");
	}
	int lastPage = cnt/rowPerPage;
	if(cnt%rowPerPage!=0){
		lastPage+=1;
	}
	if(lastPage < currentPage){
		currentPage = lastPage;
	}
	if(lastPage < endPage){
		endPage = lastPage;
	}
	System.out.println(cnt+"<-cnt");
	System.out.println(startPage+"<-startpage");
	System.out.println(endPage+"<-endpage");
	
	// 3. 결과 출력
 %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>salaryList</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- header -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>SALARY LIST</h1>
		<div style="float:right">
			<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
				<input type="text" name="search" value="<%=search%>" placeholder="이름을 입력하세요">
				<button type="submit">검색</button>
			</form>
		</div>
		<!-- 연봉 출력 -->
		<div id="div-table">
			<table class="table table-bordered">
				<thead class="table table-primary">
					<tr>
						<th>NO</th>
						<th>FIRST NAME</th>
						<th>LAST NAME</th>
						<th>FROM DATE</th>
						<th>TO DATE</th>
						<th>연봉</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Salary s : salaryList){
					%>
							<tr>
								<td><%=s.emp.empNo%></td>
								<td><%=s.emp.firstName%></td>
								<td><%=s.emp.lastName%></td>
								<td><%=s.fromDate%></td>
								<td><%=s.toDate%></td>
								<td><%=s.salary%></td>
							</tr>
					<% 
						}
					%>
				</tbody>
			</table>
		</div>
		<br>
		<!-- 페이징 -->
		<div>
			<ul class="pagination justify-content-center">
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">&laquo;</a></li>
				<%
					if(currentPage>PAGE_COUNT){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=startPage-1%>">이전</a></li>
				<%
					}
					for(int i=startPage; i<=endPage; i++){
						if(currentPage==i){
				%>
							<li class="page-item active"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>"><%=i%></a></li>
				<%
						}else{
				%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>"><%=i%></a></li>
				<%
						}
					}
					if(currentPage<lastPage && PAGE_COUNT<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=endPage+1%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">&raquo;</a></li>
			</ul>
		</div>
	</div>
</body>
</html>