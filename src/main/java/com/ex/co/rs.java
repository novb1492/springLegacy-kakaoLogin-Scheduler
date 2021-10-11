package com.ex.co;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

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

    
}
