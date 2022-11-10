<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석 
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	String msg = "";
	if(request.getParameter("msg")!=null){
		msg = "* "+request.getParameter("msg");
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db 연결
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = new Board();
	if(rs.next()){
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteBoardForm</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
	input,textarea {
		width: 100%; 
		box-sizing : border-box;
		padding: 13px;
	}
	.btn{
		background-color: white;
	}
	.read-only:focus{
			background-color: white;
			outline : none;
		}
	</style>
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1 style="text-align:center">자유 게시판</h1>
		<br>
		<div id="warning"><%=msg%></div>
		<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
			<div id="div-table">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<table class="table">
					<thead>
						<tr>
							<th colspan="2" style="padding: 20px" class="table-success">
								<span style="float:left; font-size:30px;">글쓰기</span>
								<span style="float:right"><button type="submit" class="btn btn-outline-secondary">삭제</button></span>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2"><input type="text" name="boardTitle" value="<%=board.boardTitle%>" readonly="readonly" class="read-only"></td>
						</tr>
						<tr>
							<td colspan="2"><textarea cols="100" rows="10" name="boardContent" class="read-only" readonly><%=board.boardContent%></textarea></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">작성자</td>
							<td><input type="text" name="boardWriter" value="<%=board.boardWriter%>" readonly="readonly" class="read-only"></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">비밀번호 확인</td>
							<td><input type="password" name="boardPw" maxlength="50"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>