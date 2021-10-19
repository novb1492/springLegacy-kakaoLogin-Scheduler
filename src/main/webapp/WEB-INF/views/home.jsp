<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<title>Insert title here</title>
</head>
<body>
<textarea id="summernote" name="editordata"></textarea>
<input type="button" value="seteditor" onclick="seteditor()">
<input type="button" value="geteditor" onclick="geteditor()">
<input type="button"onclick="goKakaoLogin()"value="kakoLogin">
<input type="button" onclick="kakaopay()" value="kakaopay">
<input type="button"onclick="sendsms()"value="문자보내기">
<a href="/co/deleteImage">del</a>
<a href="/co/settle">결제테이지</a>
<Br>
<input type="text" class="form-control joinInput mt-2" id="sample6_postcode" v-bind:value="postcode" placeholder="우편번호" disabled>
                    <input type="text" class="form-control joinInput" id="sample6_address" v-bind:value="address" placeholder="주소" disabled>
                    <input type="text" class="form-control joinInput" id="sample6_detailAddress"  v-bind:value="detailAddress" placeholder="상세주소">
                    <input type="button" onclick="sample6_execDaumPostcode()" class="btn btn-primary btn-default btn-sm mt-2" value="우편번호 찾기">
<script type="text/javascript">
function sample6_execDaumPostcode() {
    new daum.Postcode({
    oncomplete: function(data) {
        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
        var addr = ''; // 주소 변수
        var extraAddr = ''; // 참고항목 변수
        console.log(data);
        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
            addr = data.roadAddress;
        } else { // 사용자가 지번 주소를 선택했을 경우(J)
            addr = data.jibunAddress;
        }

        // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
        if(data.userSelectedType === 'R'){
            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraAddr !== ''){
                extraAddr = ' (' + extraAddr + ')';
            }
            // 조합된 참고항목을 해당 필드에 넣는다.
            //document.getElementById("sample6_extraAddress").value = extraAddr;
        
        } else {
            //document.getElementById("sample6_extraAddress").value = '';
        }
        // 우편번호와 주소 정보를 해당 필드에 넣는다.
        document.getElementById("sample6_postcode").value=data.zonecode;
        document.getElementById("sample6_address").value=addr;
 
        // 커서를 상세주소 필드로 이동한다.
        //document.getElementById("sample6_detailAddress").focus();
    }
    }).open();
}
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
///////////////////////////////////////////게시판
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
        	 alert('전송완료');
        }else{
            alert('abc');
        }
    }  
}
function  kakaopay() {
	xhr.open('POST', '/co/kakaopay', true); 
    xhr.send(); 
    xhr.onload = function() { 
        if(xhr.status==200){
        	let kakaoLoingUrl=xhr.response;
        	window.open(kakaoLoingUrl,'width=500','height=500');
        }else{
            alert('abc');
        }
    }  
}
</script>
</body>
</html>