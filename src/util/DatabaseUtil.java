
/*�����ͺ��̽��� �����ؼ� ���� ���ٵ� ������ �� ��ü�� ��ȯ�ϴ� �Լ�*/
package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	//�����ͺ��̽��� ���� ����
	public static Connection getConnection() {
		try {
			//mysql�� ����
			String dbURL = "jdbc:mysql://localhost:3306/webDesign_1?autoReconnect=true&useSSL=false"; // connection URL�� ?autoReconnect=true&useSSL=false ���̸� SSL ��Ȱ��ȭ���Ѽ� SSL warning���� �����
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			return DriverManager.getConnection(dbURL, dbID, dbPassword); //���� �� ���� ���� ��ȯ
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
