<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	int currentPage = 1; // 기본값 : 1페이지
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리
	int rowPerPage = 10; // 한페이지당 볼 행의 개수
	// 외부 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	//System.out.println("드라이버 로딩 성공");
	// 데이터베이스 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); 
	// lastPage 처리 쿼리 생성 
	String countSql = "SELECT COUNT(*) FROM employees"; // *행의 개수를 출력
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count=countRs.getInt("COUNT(*)");
	}
	int lastPage = count/rowPerPage;
	if(count%rowPerPage !=0){ // 올림
		lastPage +=1;
	}
	// 사원 목록 출력
	String empSql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, (currentPage-1)*rowPerPage);
	empStmt.setInt(2, rowPerPage);
	ResultSet empRs = empStmt.executeQuery(); // 쿼리 실행
	
	ArrayList<Employee> empList = new ArrayList<Employee>(); // 일반적인 타입으로 데이터 묶어두기
	while(empRs.next()){
		Employee emp = new Employee();
		emp.empNo = empRs.getInt("empNo");
		emp.firstName = empRs.getString("firstName");
		emp.lastName = empRs.getString("lastName");
		empList.add(emp);
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empList</title>
		<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<link href="../css/style.css" rel="stylesheet">
	</head>
	<body>
		<div class="container">
			<!-- 중복 영역 처리 메뉴 partial jsp 구성-->
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>
			<div><h1 style="text-align:center">EMP LIST</h1></div>
			<br>
			<div id="div-table">
				<table class="table table-hover">
					<thead class="table-primary">
						<tr>
							<th>사원번호</th>
							<th>FIRST NAME</th>
							<th>LAST NAME</th>
						</tr>
					</thead>
					<tbody>
						<%
							for(Employee emp : empList){
						%>
							<tr>
								<td><%=emp.empNo%></td>
								<!-- firstName을 누르면 상세정보가 나오도록 -->
								<td><a href=""><%=emp.firstName%></a></td>
								<td><%=emp.lastName%></td>
							</tr>
						<%
							}
						%>
					</tbody>
				</table>
			</div>
			<br>
			<nav aria-label="Page navigation">
				<ul class="pagination justify-content-center">
				<%
					if(currentPage>1){
				%>
						<li class="page-item">
							<a class="page-link" aria-label="firstPage" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">
							<span aria-hidden="true">&laquo;</span>
							</a>
						</li>
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전
							</a>
						</li>
				<%
					}
				%>
					<li class="page-item active"><a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage%>"><%=currentPage%></a></li>
				<%	
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
						<li class="page-item">
							<a class="page-link" aria-label="lastPage" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">
							<span aria-hidden="true">&raquo;</span>
							</a>
						</li>
				<%
					}
				%>
				</ul>
			</nav>
		</div>
	</body>
</html>