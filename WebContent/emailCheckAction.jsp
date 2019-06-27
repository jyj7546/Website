<!-- 이메일 인증 처리 함수-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정 스크립트 구문 출력할 떄 사용 -->
<%
	request.setCharacterEncoding("UTF-8"); //사용자로부터 입력 받은 요청 정보를 UTF-8으로 처리한다
	String code = null;
	if(request.getParameter("code") != null) {
		code = request.getParameter("code"); // code 변수 초기화
	}
	
	UserDAO userDAO = new UserDAO();
	String userID = null;
	
	// userID가 현재 로그인 되어 있는지 session 데이터로 확인
	if(session.getAttribute("userID") != null) { // 로그인 된 상태 인 경우,
		userID = (String) session.getAttribute("userID"); // session 값 같은 경우는 object객체를 반환하기 때문에 String 으로 형 변환 및 변수 초기화
	}

	if(userID == null) { // 로그인 안 된 상태인 경우,
		PrintWriter script = response.getWriter(); // 메세지 출력
		
		//스크립트 구문 시작
		script.println("<script>");
		script.println("alert('로그인 해주세요');"); // 메세지 출력
		script.println("location.href = 'userLogin.jsp'"); // 뒤로가기
		script.println("</script>");
		script.close();
		//스크립트 구문 닫기
		return; // 오류 발생 시, 현재 JSP 페이지 종료
	}
	String userEmail = userDAO.getUserEmail(userID); // 현재 userID 사용자의 Email 주소를 받음
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false; // 현재 사용자가 보낸 code가 해당 사용자의 Email 주소를 hash 값을 적용한 데이터와 일치하는지 비교
	if(isRight == true) { // EmailHash값 비교해서 참이면,
		userDAO.setUserEmailChecked(userID); // 해당 사용자의 이메일 인증 처리
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>