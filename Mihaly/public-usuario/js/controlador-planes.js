
$( "#txt-tarjeta-habiente" ).keyup(function(){
	if ( validarCampoVacio("txt-tarjeta-habiente")){
		$( "#btn-comprar" ).prop( "disabled", false);
	}else{
		$( "#btn-comprar" ).prop( "disabled", true );
}
});
$( "#txt-no-tarjeta" ).keyup(function(){
	if ( validarCampoVacio("txt-no-tarjeta")){
		$( "#btn-comprar" ).prop( "disabled", false);
	}else{
		$( "#btn-comprar" ).prop( "disabled", true );
}
});
$( "#txt-fecha_vencimiento" ).keyup(function(){
	if ( validarCampoVacio("txt-fecha_vencimiento")){
		$( "#btn-comprar" ).prop( "disabled", false);
	}else{
		$( "#btn-comprar" ).prop( "disabled", true );
}
});
$( "#txt-codigo-seguridad" ).keyup(function(){
	if ( validarCampoVacio("txt-codigo-seguridad")){
		$( "#btn-comprar" ).prop( "disabled", false);
	}else{
		$( "#btn-comprar" ).prop( "disabled", true );
}
});
habilitarBotones();
function habilitarBotones(){
	$.ajax({
		url:"/obtener-perfil",
		method:"POST",
		dataType:"json",
		success:function(respuesta){
			console.log(respuesta);
			console.log(respuesta.codigo_plan);
			if(respuesta.codigo_plan==3){

				$("#btn-principiante").prop( "disabled", true);
				$("#btn-experto").prop( "disabled", true);
				$("#btn-principiante").html('Ya cuentas con el plan Experto');
				$("#btn-experto").html('Ya cuentas con el plan');
			}else if(respuesta.codigo_plan==2){
				$("#btn-principiante").prop( "disabled", true);
				$("#btn-principiante").html('Ya cuentas con el plan');
			}
		}
	});
}

$("#btn-principiante").click(function(){
	$("#plan-seleccionado").val('2');
});
$("#btn-experto").click(function(){
	$("#plan-seleccionado").val('3');
});
$("#btn-comprar").click(function(){

    if ( validarCampoVacio("txt-codigo-seguridad")&& validarCampoVacio("txt-fecha_vencimiento") &&
    	validarCampoVacio("txt-tarjeta-habiente") && validarCampoVacio("txt-no-tarjeta")
        
    ){
    	$('#modal-comprobando').modal('toggle');
    	setTimeout(function(){$('#modal-comprobando').modal('toggle')}, 4000);
        var parametros = "plan="+$("#plan-seleccionado").val();
        $.ajax({
            url:"/comprar",
            method:"POST",
            data:parametros,
            dataType:"json",
            success:function(respuesta){
                if (respuesta.affectedRows==1){
          			habilitarBotones();
          			cargarPerfil();
                }
                console.log(respuesta);
            }
        });
    }else{
        validarCampoVacio("txt-codigo-seguridad");
        validarCampoVacio("txt-fecha_vencimiento");
    	validarCampoVacio("txt-tarjeta-habiente");
    	validarCampoVacio("txt-no-tarjeta");
        $("#btn-comprar").prop( "disabled", true);
    }
    
});

function mostrarModalComprar(){
	$('#modal-comprar').modal('toggle');
}