package com.ex.co;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class sha256 {
	public static String encrypt(String text){
        try {
             //일반 가상계좌 "%s%s%s%s%s%s%s","nx_mid_il","vbank","TEST784512","20210913","132000","500","ST1009281328226982205"
           //일반nxca_jt_il ,card
           //010가상계죄 nxva_sb_il vbank010

            StringBuffer sb = new StringBuffer();
            MessageDigest sh = MessageDigest.getInstance("SHA-256");
            if (text != null) {
                sh.update(text.getBytes("UTF-8"));
                byte[] byteData = sh.digest();
                for (int i = 0; i < byteData.length; i++) {
                    sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
                }
                return sb.toString();
            }
            return null;
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new RuntimeException("암호화 실패");
        }
    }
}
