<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
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

</body>
<script type="text/javascript">
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
	.then( editor => {
        console.log( 'Editor was initialized', editor );
        myEditor = editor;
    } )
	.catch( error => {
	   
	} );
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
