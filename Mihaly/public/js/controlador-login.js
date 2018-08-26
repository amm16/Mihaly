



function validarCampoVacio(id){
    if (document.getElementById(id).value==""){
        document.getElementById(id).classList.remove("is-valid");
        document.getElementById(id).classList.add("is-invalid");
        return false;
    } else{
        document.getElementById(id).classList.remove("is-invalid");
        document.getElementById(id).classList.add("is-valid");
        return true;
    }
}

function validarCorreo(etiqueta) {
    if (validarCampoVacio('txt-correo')== true) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (re.test(etiqueta.value)){
            etiqueta.classList.remove("is-invalid");
            etiqueta.classList.add("is-valid");
            document.getElementById("res-correo").innerHTML ="Este campo es obligatorio";
            return true
        } else{
            etiqueta.classList.remove("is-valid");
            etiqueta.classList.add("is-invalid");
            document.getElementById("res-correo").innerHTML ="Este correo no es valido";
            return false
        }
    }else{
        return false
    }
       
}



$("#btn-login").click(function(){
    if (
        validarCorreo(document.getElementById("txt-correo")) &&
        validarCampoVacio("txt-clave")
    ){

        var parametros = "clave="+$("#txt-clave").val() + "&"+
                        "correo="+$("#txt-correo").val();
        $.ajax({
            url:"/login",
            method:"POST",
            data:parametros,
            dataType:"json",
            success:function(response){
                if (response.estado == 0){
                    console.log(response);
                    if(response.codigo_tipo_usuario==1)
                        window.location = "informacion-usuarios.html";
                    else
                        window.location = "archivos.html";
                }else{
                    console.log(response);  
                    $('#alert').show();
                }
            }
        });

    }else{
        validarCorreo(document.getElementById("txt-correo"));
        validarCampoVacio("txt-clave");
    }
                
});

/*Redes Sociales*/
// Called when Google Javascript API Javascript is loaded
function HandleGoogleApiLibrary() {
    // Load "client" & "auth2" libraries
    gapi.load('client:auth2',  {
        callback: function() {
            // Initialize client & auth libraries
            gapi.client.init({
                apiKey: 'AIzaSyAdClypJH2A9ofcD9czwcKhYJkphY3lE5E',
                clientId: '254472839589-kcpru0s6kifljdm47plghmc48admc2r7.apps.googleusercontent.com',
                scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me'
            }).then(
                function(success) {
                    // Libraries are initialized successfully
                    // You can now make API calls
                }, 
                function(error) {
                    // Error occurred
                    // console.log(error) to find the reason
                }
            );
        },
        onerror: function() {
            // Failed to load libraries
        }
    });


    // Call login API on a click event
$("#btn-google").on('click', function() {
    // API call for Google login
    gapi.auth2.getAuthInstance().signIn().then(
        function(success) {
            // Login API call is successful 
        },
        function(error) {
            // Error occurred
            console.log(error);// to find the reason
        }
    );
});
}

