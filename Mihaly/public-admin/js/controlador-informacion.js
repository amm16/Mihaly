function llenarTabla(){
	parametros=null;
	console.log('funcion');
	$.ajax({
		url:"/obtener-datos-usuarios",
		method:"POST",
		data: parametros,
		dataType:"json",
		success:function(respuesta){
			console.log('peticion');
			for(var i=0; i<respuesta.length;i++){

				$('#cuerpo-tabla').append(		
				`<tr>
      				<td>${respuesta[i].usuario}</td>
      				<td>${respuesta[i].correo}</td>
      				<td>${respuesta[i].nombre_plan}</td>
      				<td>${respuesta[i].nombre_tipo_usuario}</td>
      				<td>${respuesta[i].fecha_registro}</td>
    			</tr>`);
			}
		}
	});
}

