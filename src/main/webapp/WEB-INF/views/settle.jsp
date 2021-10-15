<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://tbnpg.settlebank.co.kr/resources/js/SettlePG.js"></script>
</head>
<body>
<input type="button" value="환불하기" onclick="settle()">
<input type="button" value="카드결제" onclick="opensettle()">

<script type="text/javascript">
var xhr=new XMLHttpRequest();
function  settle(){
	 xhr.open('POST', '/co/settle', true); 
	    xhr.send(); 
	    xhr.onload = function() { 
	        if(xhr.status==200){
	        	alert('abc');
	        }else{
	            alert('abc');
	        }
	    }  
}
function opensettle() {
	var r=fisrtRequest('/co/getInfor',null);
	console.log(r.pktHash);
	  SETTLE_PG.pay({
	        "env": "https://tbnpg.settlebank.co.kr",
	        "mchtId": "nxca_jt_il",
	        "method": "card",
	        "trdDt": 20211014,    
	        "trdTm": 113000,
	        "mchtTrdNo": "test5",
	        "mchtName": "kimsshop",
	        "mchtEName": "kimsshop",
	        "pmtPrdtNm": "test",
	        "trdAmt": r.trdAmt,
	        "notiUrl": "http://kim80800.iptime.org:8080/auth/settlebank",
	        "nextUrl": "http://localhost:8080/co/doneSettlebankPage",
	        "cancUrl": "https://localhost:8443/canceSettlePage.html",
	        "pktHash": r.pktHash,
	        "ui": {
	            "type": "popup",
	            "width": "430",
	            "height": "660"
	        }
	        }, function(rsp){
	            //iframe인경우 온다고 한다
	            console.log('통신완료');
	            console.log(rsp);
	        });      
}
var result;
function fisrtRequest(requestUrl,data){
   reUrl=requestUrl;
   $.ajax({
       type: 'POST',
       url: requestUrl,
       dataType : "json",
       data: data,
       contentType: "application/json; charset:UTF-8",
       async: false,
       xhrFields: {withCredentials: true},
       success: function(response) {
           result=response;
       },
       error : function(request,status,error) {
           showError(request,status,error);
       }
   });
   console.log(result);
   return result;
}
</script>
</script>
</body>
</html>