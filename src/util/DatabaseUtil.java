
/*데이터베이스에 접근해서 현재 접근된 상태인 그 객체를 반환하는 함수*/
package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	//데이터베이스와 연결 관리
	public static Connection getConnection() {
		try {
			//mysql에 접속
			String dbURL = "jdbc:mysql://localhost:3306/webDesign_1?autoReconnect=true&useSSL=false"; // connection URL에 ?autoReconnect=true&useSSL=false 붙이면 SSL 비활성화시켜서 SSL warning오류 잡아줌
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			return DriverManager.getConnection(dbURL, dbID, dbPassword); //접속 및 접속 상태 반환
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
