
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="util.Gmail"%>
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정 스크립트 구문 출력할 떄 사용 -->
<%
	
	UserDAO userDAO = new UserDAO();
	String userID = null;
	String userPassword = null;
	if(session.getAttribute("userID") != null) { //  로그인 된 상태 (세션 값 유효한 상태) 일 떄,
		userID = (String) session.getAttribute("userID"); // getAttribute로 session 내부 값(object값)을 가져와서 String 형변환
	}
	if(userID == null) { // 로그인 하지 않은 상태
		PrintWriter script = response.getWriter(); // 메세지 출력
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('로그인 해주세요.');"); // 메세지 출력
		script.println("location.href = 'userLogin.jsp';"); // 로그인 페이지로 이동
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	}
	boolean emailChecked = userDAO.getUserEmailChecked(userID); // 특정 사용자의 이메일 인증 확인
	if(emailChecked == true) { // 사용자가 이메일 인증한 상태라면,
		PrintWriter script = response.getWriter(); // 메세지 출력
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.');"); // 메세지 출력
		script.println("location.href = 'index.jsp';"); // 메인 페이지로 이동
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 현재 JSP 페이지 종료
	}
	
	String host = "http://localhost:8080/webDesign_1/";
	String from = "wjsdudwns319@gmail.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "강의평가사이트 이메일 인증 메일입니다.";
	String content = "링크에 접속하여 이메일 인증을 완료해 주세요." + 
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>"; //emailCheckAction.jsp에 특정 SHA256 code를 보내면서 이메일 인증하게 함.
	
		//이메일 전송을 위한 smtp 설정
	Properties p = new Properties();
	p.put("mail.smtp.user", from); // 관리자 계정 이메일
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "456");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
		
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF8");
		Transport.send(msg);
	} catch (Exception e) {
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다. from emailSendAction.jsp');");
		script.println("history.back");
		script.println("</script>");
		script.close();
		return;
	}
		
%>

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
					
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
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
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일이 전송되었습니다. 회원가입 시 입력 했던 이메일에 접속해서 인증을 마쳐주세요.
		</div>

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