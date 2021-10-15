package com.ex.co;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CrossOrigin;
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
        String companyPhone="01091443409";
       
        Message coolsms = new Message(apikey, apiSecret);
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("to", "01091443409");
        params.put("from", companyPhone);
        params.put("type", "SMS");
        params.put("text", "테스트");
        try {
            coolsms.send(params);
            System.out.println("문자 전송 완료");
        } catch (CoolsmsException e) {
          
            
        }
    
    }
    @RequestMapping("/deleteImage")
    public void deleteImage() {
		System.out.println("deleteImage");
		 awsService awsService=new awsService();
		 awsService.deleteFile("kimsshop/images", "2021-10-12f2b0fb82-bb82-4873-855b-b8bf5f843a1a사본 -스크린샷(1837).png");
	}
    @CrossOrigin
    @RequestMapping("/imageUpload")
    public JSONObject imageUpload( MultipartHttpServletRequest request,HttpServletResponse response) {
        System.out.println("imageUpload요청");   
 
       List<MultipartFile> multipartFiles=new ArrayList<MultipartFile>();
		try {
			multipartFiles = request.getFiles("upload");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        System.out.println(multipartFiles.toString());
        awsService awsService=new awsService();
        return awsService.uploadAws(multipartFiles.get(0), "kimsshop/images");

    }
    @RequestMapping("/settle")
    public void settle() {
    	System.out.println("settle");
    	  Map<String,String>map=getTrdDtTrdTm();
          String pktHash=requestcancleString("reservation5470474622",Integer.toString(1000),"nxca_jt_il",map.get("trdDt"),map.get("trdTm"));
          //requestcancleString("reservation1630370258",Integer.toString(2000),"nxca_jt_il",map.get("trdDt"),map.get("trdTm"));
          System.out.println(2000);
          JSONObject body=new JSONObject();
          JSONObject params=new JSONObject();
          JSONObject data=new JSONObject();
          params.put("mchtId","nxca_jt_il");
          params.put("ver", "0A17");
          params.put("method", "CA");
          params.put("bizType", "C0");
          params.put("encCd", "23");
          params.put("mchtTrdNo","reservation5470474622");
          params.put("trdDt", map.get("trdDt"));
          params.put("trdTm",map.get("trdTm"));
          data.put("cnclOrd", "1");
          data.put("pktHash",sha256.encrypt(pktHash));
          data.put("orgTrdNo","STFP_PGCAnxca_jt_il0211014105043M1158168");
          data.put("crcCd", "KRW");
          data.put("cnclAmt",aes256.encrypt(Integer.toString(1000)));
          body.put("params", params);
          body.put("data", data);
         requestToSettle("https://tbgw.settlebank.co.kr/spay/APICancel.do", body);
         
    }
    @RequestMapping("/getInfor")
    public JSONObject getInfor() {
    	System.out.println("getInfor");
    	JSONObject jsonObject=new JSONObject();
    	jsonObject.put("pktHash",sha256.encrypt(requestPayString()));
    	jsonObject.put("trdAmt", aes256.encrypt("500"));
    	return jsonObject;
         
    }
    private String requestPayString() {
        return  String.format("%s%s%s%s%s%s%s","nxca_jt_il","card","test5","20211014","113000","500","ST1009281328226982205");
    }
    private String requestcancleString(String mchtTrdNo,String price,String mchtId,String trdDt,String trdTm) {
        System.out.println("requestcancleString");
        return  String.format("%s%s%s%s%s%s",trdDt,trdTm,mchtId,mchtTrdNo,price,"ST1009281328226982205"); 
    }
    private static Map<String,String> getTrdDtTrdTm() {
        System.out.println("getTrdDtTrdTm");
        Timestamp timestamp=Timestamp.valueOf(LocalDateTime.now());
        System.out.println(timestamp+" 시간");
        String[] spl=timestamp.toString().split(" ");
        String trdDt=spl[0].replace("-","");
        System.out.println(trdDt+" 요일");
        String min=LocalDateTime.now().getMinute()+"";
        String second=LocalDateTime.now().getSecond()+"";
        String hour=LocalDateTime.now().getHour()+"";
        if(hour.length()<2){
            hour="0"+hour;
        }
        if(min.length()<2){
            min="0"+min;
        }
        if(second.length()<2){
            second="0"+second;
        }
        String trdTm=hour+min+second;
        System.out.println(trdTm+" 요일");
        Map<String,String>map=new HashMap<>();
        map.put("trdDt", trdDt);
        map.put("trdTm", trdTm);
        return map;
    }
    private JSONObject requestToSettle(String url,JSONObject body) {
        System.out.println("reuqestToSettle");
         RestTemplate restTemplate=new RestTemplate();
         HttpHeaders headers=new HttpHeaders();
        try {
            headers.add(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE);
            headers.set("charset", "UTF-8");
      
            HttpEntity<JSONObject>entity=new HttpEntity<>(body,headers);
            System.out.println(entity.getBody()+" 요청정보"+entity.getHeaders());
            JSONObject response= restTemplate.postForObject(url,entity,JSONObject.class);
            System.out.println(response+" 세틀뱅크 통신결과");
            showResponse(response);
            return response;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("requestToSettle error "+ e.getMessage());
            throw new RuntimeException("세틀뱅크 통신 실패");
        }finally{
            body.clear();
            headers.clear();
        }
    }
    private void showResponse(JSONObject response) {
        LinkedHashMap<String,Object> data=(LinkedHashMap<String,Object>) response.get("data");
        System.out.println(data+" 세틀뱅크 통신결과");
        if(data.get("cnclAmt")!=null){
            System.out.println("환불 금액"+aesToNomal((String)data.get("cnclAmt")));
            System.out.println("환불 가능 금액"+aesToNomal((String)data.get("blcAmt")));
        }
        LinkedHashMap<String,Object> params=(LinkedHashMap<String,Object>) response.get("params");
        if(params.get("outStatCd").equals("0031")){
            System.out.println("세틀 뱅크 0031 ");
            throw new RuntimeException((String) params.get("outRsltMsg"));
        }
    }
    public String aesToNomal(String hash) {
        try {
            byte[] aesCipherRaw2=aes256.decodeBase64(hash);
            return new String(aes256.aes256DecryptEcb(aesCipherRaw2),"UTF-8");
        } catch (Exception e) {
            throw new RuntimeException("복호화 실패");
        }
    }
    
}
