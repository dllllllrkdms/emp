<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("UTF-8");
	int currentPage = 1; // 기본값 : 1페이지
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String search = "";
	if(request.getParameter("search")!=null){
		search = request.getParameter("search"); // 검색어
	}
	
	// 2. 요청처리
	int rowPerPage = 10; // 한페이지당 볼 행의 개수
	int beginRow = (currentPage-1)*rowPerPage; // 
	Class.forName("org.mariadb.jdbc.Driver"); // 외부 드라이버 로딩
	//System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // 데이터베이스 연결
	// 2-1 페이징 처리 쿼리 생성 
	String countSql = null;
	PreparedStatement countStmt = null;
	if(search!=null){
		countSql = "SELECT COUNT(*) FROM employees"; // *행의 개수를 출력
		countStmt = conn.prepareStatement(countSql);
	} else{
		countSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?"; // *행의 개수를 출력
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+search+"%");
		countStmt.setString(2, "%"+search+"%");
	}
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count=countRs.getInt("COUNT(*)");
	}
	int lastPage = count/rowPerPage;
	if(count%rowPerPage !=0){ // 올림
		lastPage +=1;
	}
	if(lastPage < currentPage){ // 임의로 currentPage를 lastPage보다 크게 적었을 때를 예방
		currentPage = lastPage;
	}
	final int PAGE_COUNT = 10; // 하단에 보여질 페이지 개수
	int startPage = (currentPage-1)/PAGE_COUNT*PAGE_COUNT+1; // 하단에 보여지는 페이지중 가장 첫번째 수 1, 11, 21,.../0, 10, 20로 시작하지 않기 위한 +1/ 현재페이지와 endpage가 같을 때를 생각해서 -1, 
	int endPage = startPage + PAGE_COUNT -1; // 마지막 수가 10 20 30 으로 끝나게 하기 위한 -1
	if(lastPage < endPage){ // 가장 마지막 페이지는 endPage가 lastPage로 짤리게 설정
		endPage = lastPage; 
	}
	// 2-2 사원 목록 출력
	String empSql = null;
	PreparedStatement empStmt = null;
	if(search==null){
		empSql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, beginRow);
		empStmt.setInt(2, rowPerPage);
	} else {
		empSql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+search+"%");
		empStmt.setString(2, "%"+search+"%");
		empStmt.setInt(3, beginRow);
		empStmt.setInt(4, rowPerPage);
	}
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
		<style>
		.title:link, .title:visited{ /* 상세보기a태그 css */
			color: black;
		}
		.title:hover{
			text-decoration: underline;
		}
	</style>
	</head>
	<body>
		<div class="container">
			<!-- 중복 영역 처리 메뉴 partial jsp 구성-->
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>
			<div><h1 style="text-align:center">EMP LIST</h1></div>
			<div style="float:right">
				<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
					<input type="text" name="search" value="<%=search%>" placeholder="이름을 입력하세요">
					<button type="submit">검색</button>
				</form>
			</div>
			<div id="div-table">
				<table class="table table-hover">
					<thead class="table-primary">
						<tr>
							<th>NO</th>
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
								<td><a class="title" href=""><%=emp.firstName%></a></td>
								<td><%=emp.lastName%></td>
							</tr>
						<%
							}
						%>
					</tbody>
				</table>
			</div>
			<br>
			<!-- 페이징처리 -->
			<nav aria-label="Page navigation">
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a class="page-link" aria-label="firstPage" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">
						<span aria-hidden="true">&laquo;</span>
						</a>
					</li>
				<%
					if(currentPage>rowPerPage){
				%>
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=startPage-1%>&search=<%=search%>">이전
							</a>
						</li>
				<%
					}
					for(int i=startPage; i<=endPage; i++){
						if(currentPage==i){
				%>
							<li class="page-item active"><a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=i%>&search=<%=search%>"><%=i%></a></li>
				<%
						} else{
				%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=i%>&search=<%=search%>"><%=i%></a></li>
				<%
						}
					}
					if(currentPage<lastPage && rowPerPage<lastPage){
				%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=endPage+1%>&search=<%=search%>">다음</a></li>
				<%
					}
				%>
					<li class="page-item">
						<a class="page-link" aria-label="lastPage" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&search=<%=search%>">
						<span aria-hidden="true">&raquo;</span>
						</a>
					</li>
				</ul>
			</nav>
		</div>
	</body>
</html>