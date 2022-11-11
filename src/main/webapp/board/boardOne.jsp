<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	String boardNoStr = request.getParameter("boardNo");
	int boardNo = Integer.parseInt(boardNoStr);
	
		
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
	// 2-1 게시판 글 모델 데이터
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter FROM board WHERE board_no =?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = new Board();
	if(boardRs.next()){
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
	}
	// 2-2 댓글 목록 모델 데이터
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, createdate FROM comment WHERE board_no =? ORDER BY comment_no DESC"; // LIMIT ?,? 댓글 페이징까지
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, board.boardNo);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment cmt = new Comment();
		cmt.commentNo = commentRs.getInt("commentNo");
		cmt.commentContent = commentRs.getString("commentContent");
		cmt.createdate = commentRs.getString("createdate");
		commentList.add(cmt);
	}
	
	// 3. 결과 출력
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardOne</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		td {
			box-sizing : border-box;
			padding: 20px;
		}
		th{
			width: 10%;
			padding: 20px;
		}
		textarea{
			width: 100%;
		}
		#div-table{
			margin-bottom: 50px;
		}
	</style>
</head>
<body>
	<div class="container">
		 <!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>자유 게시판</h1>
		<!-- jsp:include는 jsp:param을 이용하여 값을 넘길 수 있음 ** param 은 String 값만 넘겨줄 수 있다-->
		<!-- jsp:include 안에 주석을 달면 오류가 생김(왠지 모르겠음, 됐다가 안됐다가 함.)/value 표현식 안에 인용부호를 쓰면 예외가 생김 -> 검색해서 인용부호예외처리를 하면 되지만 지금은 아예 변수를 만듦 -->
		<div style="float:left">
			<jsp:include page="/inc/boardMenu.jsp">
				<jsp:param name="boardNo" value="<%=boardNoStr%>"/>
			</jsp:include>
		</div>
		<br>
		<br>
		<div id="div-table">
			<table class="table">
				<tr class="table-success">
					<th style="font-weight: 400; padding:20px 20px 0px 20px">no. <%=board.boardNo%></th>
					<td style="font-size:30px; padding: 20px 20px 0px 20px"><%=board.boardTitle%></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="table-success">
					<th style="padding:0px 20px; border-top: hidden;">&nbsp;</th>
					<td style="padding:5px 20px; border-top: hidden;"><%=board.boardWriter%></td>
					<td style="padding:0px 20px; border-top: hidden;">&nbsp;</td>
					<td style="padding:0px 20px; border-top: hidden;">&nbsp;</td>
				</tr>
				<tr>
					<th>&nbsp;</th>
					<td style="padding: 20px"><%=board.boardContent%></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<table class="table table-sm">
					<!-- 댓글 입력폼 -->
					<tr>
						<th><div style="padding: 40px;">&nbsp;</div></th>
						<td>
							<div style="padding:0px 20px"><textarea cols="100" rows="5" name="commentContent" placeholder="댓글을 남겨보세요."></textarea></div>
							<div style="padding:10px 20px"><input type="password" name="commentPw" placeholder="비밀번호를 입력하세요"></div>
						</td>
						<td class="cellBtn" style="vertical-align:top; padding: 15px"><button type="submit" class="btn btn-outline-secondary">등록</button></td>
						<td style="padding: 20px;">&nbsp;</td>
					</tr>
				</table>
			</form>
			<table class="table table-sm">
				<!-- 댓글 목록 -->
				<%
					for(Comment c : commentList){
				%>
						<tr>
							<th style="font-weight: 400; text-align:center;"><%=c.createdate%></th>
							<td style="padding: 20px"><%=c.commentContent%></td>
							<td class="cellBtn"><a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?boardNo=<%=board.boardNo%>&commentNo=<%=c.commentNo%>" class="btn btn-outline-primary">수정</a></td>
							<td class="cellBtn"><a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?boardNo=<%=board.boardNo%>&commentNo=<%=c.commentNo%>" class="btn btn-outline-danger">삭제</a></td>
						</tr>
				<%
					}
				%>	
			</table>
		</div>
	</div>
</body>
</html>