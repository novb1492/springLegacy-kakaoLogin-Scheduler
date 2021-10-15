<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
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
</script>
</body>
</html>