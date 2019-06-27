// 강의평가와 관련된 DB접근 직접적으로 해주는 객체

package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import util.DatabaseUtil;

public class EvaluationDAO {
	
	/**/
	public int write(EvaluationDTO evaluationDTO) {
		
		Connection conn = null;
		conn = DatabaseUtil.getConnection();
		PreparedStatement pstmt = null;

		try {

			String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0);";

			pstmt = conn.prepareStatement(SQL);

			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(2, evaluationDTO.getLectureName().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(3, evaluationDTO.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setInt(4, evaluationDTO.getLectureYear());

			pstmt.setString(5, evaluationDTO.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(6, evaluationDTO.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(7, evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(8, evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(9, evaluationDTO.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(10, evaluationDTO.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(11, evaluationDTO.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			pstmt.setString(12, evaluationDTO.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", " &gt;").replaceAll("\r\n", "<br>"));

			return pstmt.executeUpdate();

		} catch (Exception e) {

			e.printStackTrace();

		} finally {

			try {

				if(pstmt != null) pstmt.close();

				if(conn != null) conn.close();

			} catch (Exception e) {

				e.printStackTrace();

			}

		}

		return -1;

	}
	
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {
		Connection conn = null;
		conn = DatabaseUtil.getConnection();
		if(lectureDivide.equals("전체")) {

			lectureDivide = "";

		}

		ArrayList<EvaluationDTO> evaluationList = null;

		PreparedStatement pstmt = null;

		String SQL = "";

		ResultSet rs = null;
		try {

			if(searchType.equals("최신순")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			} else if(searchType.equals("추천순")) {

				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE ? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

			}

			pstmt = conn.prepareStatement(SQL);

			pstmt.setString(1, "%" + lectureDivide + "%");

			pstmt.setString(2, "%" + search + "%");

			rs = pstmt.executeQuery();

			evaluationList = new ArrayList<EvaluationDTO>();

			while(rs.next()) {

				EvaluationDTO evaluation = new EvaluationDTO(

					rs.getInt(1),

					rs.getString(2),

					rs.getString(3),

					rs.getString(4),

					rs.getInt(5),

					rs.getString(6),

					rs.getString(7),

					rs.getString(8),

					rs.getString(9),

					rs.getString(10),

					rs.getString(11),

					rs.getString(12),

					rs.getString(13),

					rs.getInt(14)

				);

				evaluationList.add(evaluation);

			}

		} catch (Exception e) {

			e.printStackTrace();

		} finally {

			try {

				if(rs != null) rs.close();

				if(pstmt != null) pstmt.close();

				if(conn != null) conn.close();

			} catch (Exception e) {

				e.printStackTrace();

			}

		}

		return evaluationList;

	}
	
	public int like(String evaluationID) {
	/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
		String SQL = "UPDATE EVALUATION SET likeCount = likeCount + 1 WHERE evaluationID = ?"; // ?아이디를 가진 사용자로 하여금 이메일 인증이 되도록 처리
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
		try {
			conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - daabaseutil이라는 함수로 모듈화
			pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
			
			pstmt.setInt(1, Integer.parseInt(evaluationID)); //사용자로부터 받은 값들 ?에 각각 저장
			
			return pstmt.executeUpdate(); //특정 이메일 확인 링크 누를 시, 해당 사용자에 관한 인증이 된 상태. 또 눌러도 다시 인증 된 상태로 하게 함
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
					try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
					try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
		}
		return -1; // 데이터베이스 오류
	}
	
	public int delete(String evaluationID) {
		/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
			String SQL = "DELETE FROM EVALUATION WHERE evaluationID = ?"; // ?아이디를 가진 사용자로 하여금 이메일 인증이 되도록 처리
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - daabaseutil이라는 함수로 모듈화
				pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
				
				pstmt.setInt(1, Integer.parseInt(evaluationID)); //사용자로부터 받은 값들 ?에 각각 저장
				
				return pstmt.executeUpdate(); //특정 이메일 확인 링크 누를 시, 해당 사용자에 관한 인증이 된 상태. 또 눌러도 다시 인증 된 상태로 하게 함
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return -1; // 데이터베이스 오류
		}
		
		public String getUserID(String evaluationID) {
		
			/*사용자로부터 입력받은 ? userID가 가지는 userPassword를 불러옴*/
			String SQL = "SELECT userID FROM EVALUATION WHERE evaluationID = ?";
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null; //특정한 SQL문을 실행한 이후 나온 결과 값 처리하고자 할 때 쓰는 클래스. try 안에서 선언
			try {
				conn = DatabaseUtil.getConnection(); // dbURL, dbID, dbPassword 객체 반환 - databaseutil이라는 함수로 모듈화
				pstmt = conn.prepareStatement(SQL); // conn객체에서 SQL문을 실행시키기 위한 준비
				
				pstmt.setInt(1, Integer.parseInt(evaluationID)); //사용자로부터 받은 값들 ?에 각각 저장
				
				rs = pstmt.executeQuery();
				if(rs.next()) //결과 존재하는 경우, 
					{
						return rs.getString(1); // 결과 존재 시, ID값 반환
					}
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally { // 데이터베이스 접근이후에는 접근했던 자원들을 전부 해제해서 서버에 무리를 최소화
						try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(pstmt != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
						try { if(rs != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			}
			return null; // 데이터베이스 오류
		}
	
}

