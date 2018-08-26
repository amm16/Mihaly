function cargarUnidad(){
	var parametros ="carpetaActual="+$('#carpeta-actual').val();
	$.ajax({
		url:"/obtener-unidad",
		method:"POST",
		data: parametros,
		dataType:"json",
		success:function(respuesta){
			console.log(respuesta);
			$("#contenedor-archivos").html("");
			for(var i=0; i<respuesta.length;i++){
				var cssClass=""; 
				if (respuesta[i].tipo_archivo == 'carpeta')
					cssClass="fas fa-folder"; 
				else
					cssClass="fas fa-file-code";
				$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${respuesta[i].codigo_archivo}" value="${respuesta[i].nombre_archivo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'${respuesta[i].tipo_archivo}');";>
    					<center><i  value="${respuesta[i].codigo_archivo}"class="${cssClass}"></i></center>
    					<div value="${respuesta[i].codigo_archivo}"title="${respuesta[i].nombre_archivo}">${respuesta[i].nombre_archivo}</div>
    				</div>`
				);
				
			}
		}
	});
	
}

function cargarNombre(){
	var parametros ="carpetaActual="+$('#carpeta-actual').val();
	if($('#carpeta-actual').val()==0){
		$("#lb-nombre-carpeta").html("Home");
	}else{
		$.ajax({
			url:"/obtener-nombre-carpeta",
			method:"GET",
			data: parametros,
			dataType:"json",
			success:function(response){
				console.log(response);
				$("#lb-nombre-carpeta").html(response[0].nombre_archivo);
			}
		
		});

	}
}

// Antes de mostrar menu
$(document).bind("contextmenu", function (event) {


    $(event.target).trigger('click');
    // Elimina el real
    event.preventDefault();
    // Mostar contextmenu
    if(event.target.matches('.archivo *')){
    	 $(".custom-menu").finish().toggle(100).
    	
    // En la posicion del mouse
    css({
        top: event.pageY + "px",
        left: event.pageX + "px"
    });

    }
   
});

// Cuando se da click
$(document).bind("mousedown", function (e) {
    
    // Si se da clic fuera del menu
    if (!$(e.target).parents(".custom-menu").length > 0) {
        
        // Esconder menu
        $(".custom-menu").hide(100);
    }
});


// Si se da click al menu
$(".custom-menu li").click(function(){
    
    // El nombre de la accion
    switch($(this).attr("data-action")) {
        
        // Caso para cada accion
        case "Compartir": mostrarCompartir();break;
        case "Favoritos": agregarFavoritos(); break;
        case "Eliminar": eliminarArchivo(); break;
        case "CambiarNombre": mostrarCambiarNombre(); break;
        
    }
  
    // Esconder menu
    $(".custom-menu").hide(100);
  });

$('#carpeta-actual').val(0);
$('#carpeta-actual').change(function(){
	cargarUnidad();
	cargarNombre();
});
function agregarFavoritos(){
	var archivo = $('#ultimo-seleccionado').val();
        var parametros = "archivo="+$('#ultimo-seleccionado').val();
		$.ajax({
			url:"/agregar-favorito",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				if (response.affectedRows==0){
					console.log("Se agrego a favoritos");
				}else{
					console.log("Se quito de Favoritos");
				}
			}
		});
}
function eliminarArchivo(){
	var archivo = $('#ultimo-seleccionado').val();
        var parametros = "archivo="+$('#ultimo-seleccionado').val();
		$.ajax({
			url:"/eliminar-archivo",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				if (response.affectedRows==1){
					console.log("Se elimino archivo");
				}else{
					console.log("S");
				}
			}
		});
		cargarUnidad();
}
function compartir(){
	var parametros = "archivo"+$('#ultimo-seleccionado').val() + "&"+
                        "correoUsuario="+$('#carpeta-actual').val();
}
function seleccionarArchivo(id){
	if($('#ultimo-seleccionado').val()!=''){
		var id_anterior=$('#ultimo-seleccionado').val();
		 id_anterior ='#'+id_anterior;
		$(id_anterior).children('div').css('background-color', '#393b3e');
	}
	var codigo =id;
	var id ='#'+id;
	console.log(id);
	$(id).children('div').css('background-color', '#691d51');
 	$('#ultimo-seleccionado').val(codigo);
}
function cargarHome(){
	$('#carpeta-actual').val(0).trigger('change');
}

function cargarCompartidos(){
	$("#lb-nombre-carpeta").html("Compartidos");
	 var parametros=null;
	$.ajax({
		url:"/obtener-compartidos",
		method:"POST",
		data: parametros,
		dataType:"json",
		success:function(respuesta){
			console.log(respuesta);
			$("#contenedor-archivos").html("");
			for(var i=0; i<respuesta.length;i++){
				var cssClass=""; 
				if (respuesta[i].tipo_archivo == 'carpeta')
					cssClass="fas fa-folder"; 
				else
					cssClass="fas fa-file-code";
				$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${respuesta[i].codigo_archivo}" value="${respuesta[i].nombre_archivo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'${respuesta[i].tipo_archivo}');";>
    					<center><i  value="${respuesta[i].codigo_archivo}"class="${cssClass}"></i></center>
    					<div value="${respuesta[i].codigo_archivo}"title="${respuesta[i].nombre_archivo}">${respuesta[i].nombre_archivo}</div>
    				</div>`
				);
				
			}
		}
	});
}
function cargarFavoritos(){
	$("#lb-nombre-carpeta").html("Favoritos");
	 var parametros=null;
	$.ajax({
		url:"/obtener-favoritos",
		method:"POST",
		data: parametros,
		dataType:"json",
		success:function(respuesta){
			console.log(respuesta);
			$("#contenedor-archivos").html("");
			for(var i=0; i<respuesta.length;i++){
				var cssClass=""; 
				if (respuesta[i].tipo_archivo == 'carpeta')
					cssClass="fas fa-folder"; 
				else
					cssClass="fas fa-file-code";
				$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${respuesta[i].codigo_archivo}" value="${respuesta[i].nombre_archivo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'${respuesta[i].tipo_archivo}');";>
    					<center><i  value="${respuesta[i].codigo_archivo}"class="${cssClass}"></i></center>
    					<div value="${respuesta[i].codigo_archivo}"title="${respuesta[i].nombre_archivo}">${respuesta[i].nombre_archivo}</div>
    				</div>`
				);
				
			}
		}
	});
}
function cargarPapelera(){
	$("#lb-nombre-carpeta").html("Papelera");
	 var parametros=null;
	$.ajax({
		url:"/obtener-papelera",
		method:"POST",
		data: parametros,
		dataType:"json",
		success:function(respuesta){
			console.log(respuesta);
			$("#contenedor-archivos").html("");
			for(var i=0; i<respuesta.length;i++){
				var cssClass=""; 
				if (respuesta[i].tipo_archivo == 'carpeta')
					cssClass="fas fa-folder"; 
				else
					cssClass="fas fa-file-code";
				$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${respuesta[i].codigo_archivo}" value="${respuesta[i].nombre_archivo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'${respuesta[i].tipo_archivo}');";>
    					<center><i  value="${respuesta[i].codigo_archivo}"class="${cssClass}"></i></center>
    					<div value="${respuesta[i].codigo_archivo}"title="${respuesta[i].nombre_archivo}">${respuesta[i].nombre_archivo}</div>
    				</div>`
				);
				
			}
		}
	});
}
function mostrarCompartir(){
	$('#modal-compartir').modal('toggle');

}
function mostrarCambiarNombre(){
	$('#modal-cambiar-nombre').modal('toggle');

}
function abrirArchivo(id,tipo_archivo){

	if(tipo_archivo=='carpeta'){
		$('#carpeta-anterior').val($('#carpeta-actual').val());
		console.log('h'+$('#'+id).val());
		$('#carpeta-actual').val(id).trigger('change');
		console.log($('#carpeta-actual').val());
	}else{
		var archivo = $('#ultimo-seleccionado').val();
        var parametros = "archivo="+archivo;
		$.ajax({
			url:"/documento-seleccionado",
			method:"GET",
			data: parametros,
			dataType:"json",
			success:function(response){
				console.log(response);
				window.location = "editor.html";
			}
			
		});
	}
}
function atras(){
	$('#carpeta-actual').val($('#carpeta-anterior').val());
	$('#carpeta-anterior').val(null);
}
///Si cambia valor de la carpeta actual
$('#carpeta-actual').change(function(){
	cargarUnidad();
});
$('#txt-nueva-carpeta-nombre').val('Nueva Carpeta');

$( "#btn-unidad" ).click(function(){
	$('#carpeta-actual').val(0);//Cuando la carpeta actual es la unidad
});
$( "#txt-correo-compartir" ).keyup(function(){
	if ( validarCampoVacio("txt-correo-compartir")){
		$( "#btn-compartir" ).prop( "disabled", false);
	}else{
		$( "#btn-compartir" ).prop( "disabled", true );
}
});


$( "#txt-nueva-carpeta-nombre" ).keyup(function(){
	if ( validarCampoVacio("txt-nueva-carpeta-nombre")){
		$( "#btn-nueva-carpeta" ).prop( "disabled", false);
	}else{
		$( "#btn-nueva-carpeta" ).prop( "disabled", true );
}
});

$( "#txt-nuevo-documento-nombre" ).keyup(function(){
	if ( validarCampoVacio("txt-nuevo-documento-nombre")){
		$( "#btn-nuevo-documento" ).prop( "disabled", false);
	}else{
		$( "#btn-nuevo-documento" ).prop( "disabled", true );
}
});
$( "#txt-nuevo-nombre" ).keyup(function(){
	if ( validarCampoVacio("txt-nuevo-nombre")){
		$("#btn-cambiar-nombre").prop( "disabled", false);
	}else{
		$("#btn-cambiar-nombre").prop( "disabled", true );
}
});
$("#btn-compartir").click(function(){
	if ( validarCampoVacio("txt-correo-compartir")){
		var archivo = $('#ultimo-seleccionado').val();
        var parametros = "correo="+$("#txt-correo-compartir").val() + "&"+
                        "archivo="+$('#ultimo-seleccionado').val();
		$.ajax({
			url:"/compartir",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				if (response.affectedRows==1){
					console.log("Se compartio carpeta");
				}else{
					console.log("No existe usuario con esa carpeta o carpeta ya estaba compartida");
				}
			}
		});
		
	}
});
$("#btn-cambiar-nombre").click(function(){
	if ( validarCampoVacio("txt-nuevo-nombre")){
		var archivo = $('#ultimo-seleccionado').val()
        var parametros = "nombre="+$("#txt-nuevo-nombre").val() + "&"+
                        "archivo="+archivo;
		$.ajax({
			url:"/cambiar-nombre",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				console.log(response);
				if (response.affectedRows==1){
					cargarUnidad();
				}
			}
		});
		
	}
});
$("#btn-nuevo-documento").click(function(){
	if ( validarCampoVacio("txt-nuevo-documento-nombre")){

        var parametros = "nombre="+$("#txt-nuevo-documento-nombre").val() + "&"+
                        "carpetaPadre="+$('#carpeta-actual').val();
		$.ajax({
			url:"/nuevo-documento",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				console.log(response);
				if (response.affectedRows==1){
					var cssClass="fas fa-file-code";
            		$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${response.codigo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'documento');";>
    					<center><i class="${cssClass}"></i></center>
    					<div title="${$('#txt-nueva-carpeta-nombre').val()}">${$('#txt-nuevo-documento-nombre').val()}</div>
    				</div>`
					);
				}
			}
		});
		
	}
});


$("#btn-nueva-carpeta").click(function(){
	if ( validarCampoVacio("txt-nueva-carpeta-nombre")){

        var parametros = "nombre="+$("#txt-nueva-carpeta-nombre").val() + "&"+
                        "carpetaPadre="+$('#carpeta-actual').val();
		$.ajax({
			url:"/nueva-carpeta",
			method:"POST",
			data: parametros,
			dataType:"json",
			success:function(response){
				console.log(response);
				if (response.affectedRows==1){
					var cssClass="fas fa-folder";
					$("#contenedor-archivos").append(
            		`<div  class="archivo" id="${response.codigo}"
            			onclick="seleccionarArchivo(this.id);" ondblclick="abrirArchivo(this.id,'carpeta');";>
    					<center><i class="${cssClass}"></i></center>
    					<div title="${$('#txt-nueva-carpeta-nombre').val()}">${$('#txt-nueva-carpeta-nombre').val()}</div>
    				</div>`
					);
				}
			}
		});
		
	}
});

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

$(document).ready(function(){
	cargarUnidad();
});
