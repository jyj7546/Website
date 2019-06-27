package util;

import java.security.MessageDigest;

public class SHA256 {

	public static String getSHA256(String input) {
		StringBuffer result = new StringBuffer();
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256"); // 사용자가 입력한 값을 SHA256으로 알고리즘을 적용
			byte[] salt = "Hello! This is Salt." .getBytes();
			digest.reset();
			digest.update(salt);
			byte[] chars = digest.digest(input.getBytes("UTF-8")); // 해시 적용 값을 UTF-8형식으로 chars 변수에 담음
			for(int i = 0; i < chars.length; i++) { 
				String hex = Integer.toHexString(0xff & chars[i]); // 문자형 변환
				if(hex.length() == 1) result.append("0");
				result.append(hex);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
}
