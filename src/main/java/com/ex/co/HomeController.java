package com.ex.co;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	@RequestMapping("/doneSettlebankPage")
	public void done(HttpServletRequest request,HttpServletResponse response) {
		System.out.println("done");
		 String mchtId=request.getParameter("mchtId");//상점아이디
		    String outStatCd=request.getParameter("outStatCd");          //결과코드
		    String outRsltCd=request.getParameter("outRsltCd");          //거절코드
		    String outRsltMsg= request.getParameter("outRsltMsg");         //결과메세지
		    String method= request.getParameter("method");             //결제수단
		    String mchtTrdNo=         request.getParameter("mchtTrdNo");          //상점주문번호
		    String mchtCustId=request.getParameter("mchtCustId");         //상점고객아이디
		    String trdNo=             request.getParameter("trdNo");              //세틀뱅크 거래번호
		    String trdAmt=            request.getParameter("trdAmt");             //거래금액
		    String mchtParam=         request.getParameter("mchtParam");          //상점 예약필드
		    String authDt=            request.getParameter("authDt");             //승인일시
		    String authNo=            request.getParameter("authNo");             //승인번호
		    String reqIssueDt=     	request.getParameter("reqIssueDt");       	//채번요청일시
		    String intMon=            request.getParameter("intMon");             //할부개월수
		    String fnNm=              request.getParameter("fnNm");               //카드사명
		    String fnCd=              request.getParameter("fnCd");               //카드사코드
		    String pointTrdNo=        request.getParameter("pointTrdNo");         //포인트거래번호
		    String pointTrdAmt=       request.getParameter("pointTrdAmt");        //포인트거래금액
		    String cardTrdAmt=        request.getParameter("cardTrdAmt");         //신용카드결제금액
		    String vtlAcntNo=         request.getParameter("vtlAcntNo");          //가상계좌번호
		    String expireDt=          request.getParameter("expireDt");           //입금기한
		    String cphoneNo=          request.getParameter("cphoneNo");           //휴대폰번호
		    String billKey=           request.getParameter("billKey");            //자동결제키
		    System.out.println(trdNo);
	}
	
}

