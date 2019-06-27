<!-- 강의 평가 등록 처리 함수-->

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%> <!-- 특정 스크립트 구문 출력할 떄 사용 -->
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%

	String userID = null;    
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); // session에 저장된 userID 있으면 불러옴
	}
	if(userID == null) { // 로그인 안 했을 때,
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
	request.setCharacterEncoding("utf-8");
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null; // 유도리 점수
	String lectureScore = null;
	
	if(request.getParameter("lectureName") != null) {
		lectureName = request.getParameter("lectureName");
	}
	if(request.getParameter("professorName") != null) {
		professorName = request.getParameter("professorName");
	}
	if(Integer.parseInt(request.getParameter("lectureYear")) != 0) {
		try {
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));
		} catch(Exception e) {
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if(request.getParameter("semesterDivide") != null) {
		semesterDivide = request.getParameter("semesterDivide");
		
	}
	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle") != null) {
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null) {
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != null) {
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore") != null) {
		creditScore = request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore") != null) {
		comfortableScore = request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore") != null) {
		lectureScore = request.getParameter("lectureScore");
	}
	
	if(		lectureName == null | lectureName.equals("") | lectureName.equals("null")
			| professorName == null | professorName.equals("") | professorName.equals("null")
			| evaluationTitle == null | evaluationTitle.equals("") | evaluationTitle.equals("null")
			| evaluationContent == null | evaluationContent.equals("") | evaluationContent.equals("null")
			/*| lectureYear == 0 | semesterDivide == null | lectureDivide == null
			| totalScore == null | creditScore == null | comfortableScore == null | lectureScore == null*/)
		{ //  하나라도 공란이 있는 경우, "null" 로 들어가는 것까지 체크하기 - 중요!
		
			PrintWriter script = response.getWriter(); // 메세지 출력
			
			//스크립트 구문 시작
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.');"); // 메세지 출력
			script.println("history.back();"); // 뒤로가기
			script.println("</script>");
			script.close();
			return;
			//스크립트 구문 닫기

	} else { // 강의 평가 제대로 다 입력 했을 때,
		EvaluationDAO evaluationDAO = new EvaluationDAO(); // 초기화
		int result = evaluationDAO.write(new EvaluationDTO(0, userID, lectureName, professorName 
				, lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent
				, totalScore, creditScore, comfortableScore, lectureScore, 0)); // write함수를 이용해 실제로 사용자가 작성한 강의 평가 글을 등록
			
			if (result == -1) { // 강의 평가 등록 오류
			PrintWriter script = response.getWriter();
		
			//스크립트 구문 시작
			script.println("<script>");
			script.println("alert('강의 평가 게시글 등록 실패');"); // 메세지 출력
			script.println("history.back();"); // 뒤로가기
			script.println("</script>");
			script.close();
			//스크립트 구문 닫기
			return; // 오류 발생 시, 현재 JSP 페이지 종료
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('등록 완료.');"); // 메세지 출력
				script.println("location.href = 'index.jsp'");
				script.println("</script>");
				return;
			}
	}
		
%>