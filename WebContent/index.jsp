<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "user.UserDAO" %>
<%@ page import = "evaluation.EvaluationDTO" %>
<%@ page import = "evaluation.EvaluationDAO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "java.net.URLDecoder"%>
<%@ page import = "java.nio.charset.StandardCharsets"%>


<!doctype html>
<html>
  <head>
    <title>강의평가 웹 사이트</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- 부트스트랩 CSS 추가하기 -->
    <link rel="stylesheet" href="./css/bootstrap.min.css">

    <!-- 커스텀 CSS 추가하기 -->
    <link rel="stylesheet" href="./css/custom.css">
  </head>
  <body>
<%
	// 강의평가 정보 보여주는 초기 세팅
	request.setCharacterEncoding("utf-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;
	
	// 사용자가 검색을 했는지 판단
	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide"); // 사용자가 검색을 하기로 한 요청값 
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null) {
		try {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber")); 
		} catch (Exception e) { // pageNumber 가 정수형이 아닐 시, 오류 처리
			System.out.println("검색 페이지 번호 오류");
		}
	}
	String userID = null;
	boolean getUserEmailChecked;
	
	if(session.getAttribute("userID") != null) { // 세션에 저장된 userID의 값이 존재하다면,
		userID = (String) session.getAttribute("userID");
	
			UserDAO userDAO = new UserDAO(); // 객체 선언
			getUserEmailChecked = userDAO.getUserEmailChecked(userID); 
			if(getUserEmailChecked == false) { // 이메일 인증 안 받은 사람,
				PrintWriter script = response.getWriter();
				
				//스크립트 구문 시작
				script.println("<script>");
				script.println("alert('이메일 인증을 마쳐주세요.');");
				script.println("location.href = 'emailSendConfirm.jsp';");
				script.println("</script>");
				script.close();
				//스크립트 구문 닫기
				return; // 현재 JSP 페이지 종료
			}
		}

	/*
	if(userID == null) { // 로그인 안 된 경우,
		PrintWriter script = response.getWriter();
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('로그인 해 주세요. from index.jsp');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	}
	*/
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown" href="#"> 
						회원 관리	
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					
<%
	if(userID == null) { // 로그인 안 된 상태,
%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> 
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%
	} else {
%>			
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>
			</ul>
			
			<!-- 검색기능 구현 -->
			<form action="./index.jsp" method = "get" class="form-inline my-2 my-lg-0"> <!-- my-2 my-lg-0의 뜻은 무엇인가  margin y - for classes that set both *-top and *-bottom       2는 (by default) for classes that set the margin or padding to $spacer * .5      0은 for classes that eliminate the margin or padding by setting it to 0 -->
				<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-labelledby="Search"> <!-- mr-sm-2는 무엇인가  margin r - for classes that set margin-right or padding-right -->
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전필"><% if (lectureDivide.equals("전필")) out.println("selected"); %>>전필</option>
				<option value="전선"><% if (lectureDivide.equals("전선")) out.println("selected"); %>>전선</option>
				<option value="교필"><% if (lectureDivide.equals("교필")) out.println("selected"); %>>교필</option>
				<option value="교선"><% if (lectureDivide.equals("교선")) out.println("selected"); %>>교선</option>
				
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순"><% if (searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-success mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i = 0; i < evaluationList.size(); i++) {
			if(i == 5) break; // 6번째  evaluation은 출력 안 시킴
			EvaluationDTO evaluation = evaluationList.get(i);// 현재 리스트에 잇는 해당 인덱스의 값 가져옴
%>
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<!--------------------------------------------------------------------- 강의 평가 card 출력 내용 ----------------------------------------------------------------------------------->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>&nbsp;&nbsp;<%= evaluation.getProfessorName() %>교수님 &nbsp;<small>(<%= evaluation.getLectureYear() %>년 <%= evaluation.getSemesterDivide() %>학기 <%= evaluation.getLectureDivide() %>)</small></div>
					<div class="col-4 text-right">
						종합 <span style="color: red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
		</div>
		<div class="card-body">
			<h5 class="card-title">
				<%= evaluation.getEvaluationTitle() %>
			</h5>
			<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
			<div class="row">
				<div class="col-9 text-left">
					성적 <span style="color: red;"><%= evaluation.getCreditScore() %></span>
					유도리 <span style="color: red;"><%= evaluation.getComfortableScore() %></span>
					강의 <span style="color: red;"><%= evaluation.getLectureScore() %></span>
					<span style="color: green;">(추천: <%= evaluation.getLikeCount() %>)</span>
				</div>
				<div class="col-3 text-right">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">삭제</a>
				</div>
			</div>
		</div>
<% 
	}
%>
	</section>
	<!-- 이전페이지, 다음페이지 구현 -->
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <= 0) { // 이전 페이지가 존재하지 않을 때,
%>
	<a class="page-link disabled">이전</a>
<%
	} else { // 뒤로 갈 수 있는 페이지가 존재한다면,
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>
	&search=<%= URLEncoder.encode(search, "UTF-8") %>
	&pageNumber=<%= pageNumber - 1 %>">이전</a>
<%
	}
%>
		</li>
		
		<li>
<%
	if(evaluationList.size() < 6) { // 6개까지 가져온 강의평가 글이 6개 보다 적을 때, 즉 특정 페이지에서 5개 이하로 강의 평가 글들이 모두 출력 되었을 때, 다음 페이지가 존재하지 않다는 것과 같음. 다음 페이지 버튼 안 보이게 함
%>
	<a class="page-link disabled">다음</a>
<%
	} else { // 현재 가져온 페이지 갯수가 6개 보다 클 떄, 즉 특정 페이지에 5개의 강의 평가 글을 출력 했고, 나머지 한 개라도 있을 시, 다음 페이지가 존재한다는 것과 같음. 다음 페이지 버튼 보이게 함
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber + 1 %>">다음</a>
<%
	}
%>
		</li>
	</ul>
	
	<!-- 평가 등록 모달 -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span> <!-- &tiems은 닫기버튼 모양 -->
					</button>
				</div>
				
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post"> <!-- ./evaluationRegisterAction.jsp로 평가정보 전달 -->
						
						<!-- 강의, 교수 행 -->
						<div class="form-row"> <!-- form-low : 입력내용을 한 줄 씩 들어가게 나눔 -->
							<div class="form-group col-sm-6"> <!-- 한 개의 행에는 12개의 열이 들어감 col-sm-6으로 반절 나눔 -->
								<label>강의명</label>
								<input type="text" name="lectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label>
								<input type="text" name="professorName" class="form-control" maxlength="20">
							</div>
						</div>
						
						<!-- 수강연도, 수강학기, 강의구분 행 -->
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>수강 연도</label>
								<select name="lectureYear" class="form-control">
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019" selected>2019</option>
									<option value="2020">2020</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label>
								<select name="semesterDivide" class="form-control">
									<option value="1" selected>1</option>
									<option value="2">2</option>
									<option value="summer">여름계절</option>
									<option value="winter">겨울계절</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label>
								<select name="lectureDivide" class="form-control">
									<option value="전필" selected>전필</option>
									<option value="전선">전선</option>
									<option value="교필">교필</option>
									<option value="교선">교선</option>
								</select>
							</div>
						</div>
						
						<!-- 제목, 내용 행 -->
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="textarea">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="totalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>													
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>성적</label>
								<select name="creditScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>													
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>유도리</label>
								<select name="comfortableScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>													
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>강의</label>
								<select name="lectureScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>													
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록</button>						
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 신고 모달 -->
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span> <!-- &tiems은 닫기버튼 모양 -->
					</button>
				</div>
				
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						
						<!-- 제목, 내용 행 -->
						<div class="form-group">
							<label>신고 제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="textarea">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록</button>						
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #ffffff;">
		copyright &copy; 2019 전영준 All Right Reserved.
	</footer>
	<!-- jquery 자바 스크립트 추가 -->
	<script src="./js/jquery.min.js"></script>
	
	<!-- popper 스크립트 추가 -->
	<script src="./js/popper.js"></script>
	
	<!-- 부트스트랩 js 추가 --> 
	<script src="./js/bootstrap.min.js"></script>
	
</body>
</html>