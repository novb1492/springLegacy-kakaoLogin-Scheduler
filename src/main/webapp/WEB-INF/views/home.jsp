<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<html>
<head>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://tbnpg.settlebank.co.kr/resources/js/SettlePG.js"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
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
   <a href="/co/deleteImage">del</a>
<form id="form1" action="/co/imageUpload" method="post" enctype="multipart/form-data">
    <input type="file" name="file">
    <input type="submit">
</form>
    <textarea id="summernote" name="editordata"></textarea>
<input type="button" value="seteditor" onclick="seteditor()">
<input type="button" value="geteditor" onclick="geteditor()">
<input type="button" value="settle" onclick="settle()">
<input type="button" value="opensettle" onclick="opensettle()">
</body>
<script type="text/javascript">

let editor;

class MyUploadAdapter {
    constructor(props) {
        // CKEditor 5's FileLoader instance.
      this.loader = props;
      // URL where to send files.
      this.url = 'http://localhost:8080/co/imageUpload';
    }

    // Starts the upload process.
    upload() {
        return new Promise((resolve, reject) => {
            this._initRequest();
            this._initListeners(resolve, reject);
            this._sendRequest();
        } );
    }

    // Aborts the upload process.
    abort() {
        if ( this.xhr ) {
            this.xhr.abort();
        }
    }

    // Example implementation using XMLHttpRequest.
    _initRequest() {
        const xhr = this.xhr = new XMLHttpRequest();

        xhr.open('POST', this.url, true);
        xhr.responseType = 'json';

    }

    // Initializes XMLHttpRequest listeners.
    _initListeners( resolve, reject ) {
        const xhr = this.xhr;
        const loader = this.loader;
        const genericErrorText = 'Couldn\'t upload file:' + ` ${ loader.file.name }.`;

        xhr.addEventListener( 'error', () => reject( genericErrorText ) );
        xhr.addEventListener( 'abort', () => reject() );
        xhr.addEventListener( 'load', () => {
            const response = xhr.response;
            if ( !response || response.error ) {
                return reject( response && response.error ? response.error.message : genericErrorText );
            }

            // If the upload is successful, resolve the upload promise with an object containing
            // at least the "default" URL, pointing to the image on the server.
            resolve({
                default: response.url
            });
        } );

        if ( xhr.upload ) {
            xhr.upload.addEventListener( 'progress', evt => {
                if ( evt.lengthComputable ) {
                    loader.uploadTotal = evt.total;
                    loader.uploaded = evt.loaded;
                }
            } );
        }
    }

    // Prepares the data and sends the request.
    _sendRequest() {
        const data = new FormData();

        this.loader.file.then(result => {
          data.append('upload', result);
          //this.xhr.setRequestHeader('Content-type', 'multipart/form-data');
          this.xhr.send(data);
          }
        )
    }

}
function MyCustomUploadAdapterPlugin( editor ) {
    editor.plugins.get( 'FileRepository' ).createUploadAdapter = ( loader ) => {
    // Configure the URL to the upload script in your back-end here!
    return new MyUploadAdapter( loader );
    };
}
ClassicEditor
.create( document.querySelector( '#summernote' ), {
        extraPlugins: [ MyCustomUploadAdapterPlugin ],

        // ...
    } )
	.then( newEditor  => {
        console.log( 'Editor was initialized', newEditor  );
        editor = newEditor ;
    } )
	.catch( error => {
	   
	} );
function seteditor() {
	alert('b');
	 editor.setData('<p>example</p><img src="https://s3.ap-northeast-2.amazonaws.com/kimsshop/images/2021-10-136a47a7e1-d86c-443a-980b-24a03fe9d03cabcd.png">');
}
function geteditor() {
	alert('a');
	alert(editor.getData());
}
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
	        "mchtTrdNo": "test4",
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
</html>
