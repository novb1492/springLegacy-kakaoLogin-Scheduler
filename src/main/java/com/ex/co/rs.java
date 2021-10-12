package com.ex.co;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@RestController
public class rs {

	
	@PostMapping("/test")
	public String name() {
		System.out.println("av");	
		return "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=2b8214590890931fb474d08986898680&redirect_uri=http://localhost:8080/co/kakaoLogincallback";
	}
    @RequestMapping("/kakaoLogincallback")
    public void kakaoLogincallback(HttpServletRequest request,HttpServletResponse response) {
        System.out.println("kakaologin요청");   
        String code=request.getParameter("code");
        System.out.println(code);
         RestTemplate restTemplate=new RestTemplate();
         HttpHeaders headers=new HttpHeaders();
         LinkedMultiValueMap<String,Object> body=new LinkedMultiValueMap<>();
       //kakaoLogin(request.getParameter("code"),response);
         String getAccessTokenGrandType="authorization_code";
         body.add("grant_type", getAccessTokenGrandType);
         body.add("client_id", "2b8214590890931fb474d08986898680");
         body.add("redirect_uri", "http://localhost:8080/co/kakaoLogincallback");
         body.add("code", code);
             System.out.println("requestToKakao");
             try {
                 headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                 HttpEntity<MultiValueMap<String,Object>>entity=new HttpEntity<>(body,headers);
                 System.out.println(entity.getBody()+" 요청정보"+entity.getHeaders());
                 String s= restTemplate.postForObject("https://kauth.kakao.com/oauth/token",entity,String.class);
                 System.out.println(s);
             } catch (Exception e) {
                 e.printStackTrace();
                 System.out.println("requestToKakao error "+ e.getMessage());
                 throw new RuntimeException("카카오 통신 실패");
             }finally{
                 body.clear();
                 headers.clear();
             }
    }
    @RequestMapping("/sendsms")
    public void sms(HttpServletRequest request,HttpServletResponse response) {
        System.out.println("sms요청");   
        String apikey="NCSFT0AZ2O3FHMAX";
        String apiSecret="AHZNZ3IIMGSYIXFLR7HQDBYA5KPFSFCS";
        String companyPhone="회사전화";
       
        Message coolsms = new Message(apikey, apiSecret);
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("to", "보낼전화");
        params.put("from", companyPhone);
        params.put("type", "SMS");
        params.put("text", "테스트");
        try {
            coolsms.send(params);
            System.out.println("문자 전송 완료");
        } catch (CoolsmsException e) {
          
            
        }
    
    }
    @RequestMapping("/imageUpload")
    public void imageUpload(@RequestParam(name = "file") MultipartFile request,HttpServletResponse response) {
        System.out.println("imageUpload요청");   
        /*List<MultipartFile> multipartFiles=new ArrayList<MultipartFile>();
		try {
			MultipartHttpServletRequest multipartHttpServletRequest=(MultipartHttpServletRequest)request;
			multipartFiles = multipartHttpServletRequest.getFiles("upload");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        System.out.println(multipartFiles.toString());*/
        awsService awsService=new awsService();
        awsService.uploadAws(request, "kimsshop/images");

    }

    
}
