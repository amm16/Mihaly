function verificarPermiso(){
	var parametros = ""
	$.ajax({
		url:"/ruta-restringida",
		method:"GET",
		data: parametros,
		dataType:"json",
		success:function(response){
			console.log(response);
			if(response.estado==1){
				$("body").fadeOut(); 
				window.location = "login.html";
			}else{
				$("body").show(); 
			}
		}
	});
}
verificarPermiso();
$("#cerrar-sesion").click(function(){
	var parametros = "cerrar-sesion=0";
	
	$.ajax({
		url:"/logout",
		method:"GET",
		data: parametros,
		dataType:"json",
		success:function(response){
			$("body").hide(); 
			window.location = "login.html";
		}

		
	});
});