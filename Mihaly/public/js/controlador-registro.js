



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
function validarUsuario(etiqueta){
    if (validarCampoVacio('txt-usuario')== true) {
        etiqueta.classList.remove("is-invalid");
        etiqueta.classList.add("is-valid");
        return true;
    } else{
        etiqueta.classList.remove("is-valid");
        etiqueta.classList.add("is-invalid");
        return false;
    };

}

function validarCorreo(etiqueta) {
    if (validarCampoVacio('txt-correo')== true) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (re.test(etiqueta.value)){
            var parametros = "correo="+$("#txt-correo").val();
            resultado=true;
            $.ajax({
                url:"/validarCorreo",
                method:"POST",
                data:parametros,
                dataType:"json",
                success:function(response){
                    if (response.estado == 0){
                        console.log(response);
                        etiqueta.classList.remove("is-invalid");
                        etiqueta.classList.add("is-valid");
                        document.getElementById("res-correo").innerHTML ="Este campo es obligatorio";
                        resultado= true;
                    }else{
                        etiqueta.classList.remove("is-valid");
                        etiqueta.classList.add("is-invalid");
                        document.getElementById("res-correo").innerHTML ="Ya existe una cuenta con este correo";
                        resultado=false; 
                    }
                }
            });
            return resultado;
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
function validarClave(){
    var clave1 = document.getElementById('txt-clave1').value;
    if(validarCampoVacio("txt-clave1")== true){
         if(clave1.length>7){
            document.getElementById('txt-clave1').classList.remove("is-invalid");
            document.getElementById('txt-clave1').classList.add("is-valid");
            document.getElementById("res-clave1").innerHTML ="Este campo es obligatorio";
            return true;
        }else{
            document.getElementById('txt-clave1').classList.remove("is-valid");
            document.getElementById('txt-clave1').classList.add("is-invalid");
            document.getElementById("res-clave1").innerHTML ="La constraseña debe tener minimo 8 caracteres";
            return false;
        }   
    }else{
        return false;
    }
}
$("#txt-clave1").keyup(function(){
    validarClave();

});


function comprobarClave(etiqueta){
    var clave1 = document.getElementById('txt-clave1').value;
    var clave2 = document.getElementById('txt-clave2').value;
    if(validarClave()== true &&
        validarCampoVacio("txt-clave2")== true 
        ){
            if (clave2 == clave1){
                document.getElementById('txt-clave2').classList.remove("is-invalid");
                document.getElementById('txt-clave2').classList.add("is-valid");
                document.getElementById("res-clave2").innerHTML ="Este campo es obligatorio";
                return true;
            }else{
                document.getElementById('txt-clave2').classList.remove("is-valid");
                document.getElementById('txt-clave2').classList.add("is-invalid");
                document.getElementById("res-clave2").innerHTML ="Las contraseñas no coinciden";
                return false;
            } 
        }else{
            document.getElementById("res-clave2").innerHTML ="Este campo es obligatorio";
            validarCampoVacio("txt-clave2");
            return false;
        }
}
     

$("#btn-registro").click(function(){



    if (
        validarUsuario(document.getElementById("txt-usuario")) &&
        validarCorreo(document.getElementById("txt-correo")) &&
        comprobarClave(document.getElementById("txt-clave1")) &&
        comprobarClave(document.getElementById("txt-clave2"))
    ){

        var parametros = "usuario="+$("#txt-usuario").val() + "&" + 
                     "clave="+$("#txt-clave1").val() + "&"+
                     "correo="+$("#txt-correo").val();
        $.ajax({
            url:"/registrar",
            method:"POST",
            data:parametros,
            dataType:"json",
            success:function(respuesta){
                if (respuesta.affectedRows==1){
                    window.location = "login.html";
                }
                console.log(respuesta);
            }
        });
    }else{
        validarUsuario(document.getElementById("txt-usuario"));
        validarCorreo(document.getElementById("txt-correo"));
        comprobarClave(document.getElementById("txt-clave1"));
        comprobarClave(document.getElementById("txt-clave2"));
    }
    
});
