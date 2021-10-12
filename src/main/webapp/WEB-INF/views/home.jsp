<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>
<a href="/co/test/">a</a>
<input type="button"onclick="goKakaoLogin()"value="kakoLogin">
<input type="button"onclick="sendsms()"value="sendsms">
<P>  The time on the server is ${serverTime}. </P>
3
4
<form id="form1" action="/co/imageUpload" method="post" enctype="multipart/form-data">
    <input type="file" name="file">
    <input type="submit">
</form>

</body>
<script type="text/javascript">
var xhr=new XMLHttpRequest();
function goKakaoLogin(){
    xhr.open('POST', '/co/test', true); 
    xhr.send(); 
    xhr.onload = function() { 
        if(xhr.status==200){
			let kakaoLoingUrl=xhr.response;
			child=window.open(kakaoLoingUrl,'width=500','height=500');
			console.log(kakaoLoingUrl);
        }else{
            alert('abc');
        }
    }  
}
function sendsms(){
    xhr.open('POST', '/co/sendsms', true); 
    xhr.send(); 
    xhr.onload = function() { 
        if(xhr.status==200){
        	 alert('abc');
        }else{
            alert('abc');
        }
    }  
}
</script>
</html>
