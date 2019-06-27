<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<!-- bootstrap은 반응형 웹 플랫폼이기 때문에 viewport 관련 설정을 meta 태그에 넣음 -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">  
	
	<title>강의평가 웹 사이트</title>
	
	<!-- 부트스트랩 CSS 추가 -->
	<link rel="stylesheet" href="css/bootstrap.min.css">
	
	<!-- 커스텀 CSS 추가 -->    <!-- 이부분 안된것 같은데?????????????????????????????????????????????????????????????????????????????????????글꼴 바꿔도 똑같슴돠 -->
	<link rel="stylesheet" href="css/custom.css">
	
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID != null) { // 이미 로그인 된 경우,
		PrintWriter script = response.getWriter();
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('이미 로그인 되어 있습니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	}
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

						<a class="dropdown-item" href="userLogin.jsp">로그인</a> <!-- href="#" 이 태그는 a태그 안의 href 속성을 빼버리면 해당 item에 마우스커서 위치시, 마우스 커서가 I가 되버리므로 누를수있는 버튼인 것처럼 보이기 위해서 사용한다. 링크를 걸 데가 없으므로 "#"으로 어디에도 링크를 걸지 않는 형식으로 href태그를 억지로 넣은것임 -->
						<a class="dropdown-item" href="userJoin.jsp">회원가입</a>

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
	
	<section class="container mt-3" style="max-width: 560px;">
		<form method="post" action="./userLoginAction.jsp">
			<div class="form-group">
				<label>아이디</label>
				<input type="text" name="userID" class="form-control">
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" name="userPassword" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">로그인</button>
		</form>
	</section>
	
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