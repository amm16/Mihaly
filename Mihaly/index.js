
//Servidor Web 
var express  = require("express");
var bodyParser = require("body-parser");
var mysql = require("mysql");
var app = express();
var session = require("express-session");
//Session
app.use(session({secret:"ASDFE$%#%",resave:true, saveUninitialized:true}));
//Body Parser
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true}));
//Cookie Parser 
var cookieParser = require("cookie-parser");


////////////////Base de Datos////////////////
var credenciales = {
    user:"root",
    password:"clave",
    port:"3306",
    host:"localhost",
    database:"mihaly"
};
//Exponer una carpeta como publica
app.use(express.static("public"));
////////////////Registro////////////////
app.post('/registrar', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_usuarios(1, 2, null, 1, ?, ?, ?, 'null')";
    
    conexion.query(
        sql,
        [request.body.usuario, 
        request.body.clave, 
        request.body.correo],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
////////////////Editar Usuario////////////////
app.post('/editar-perfil', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_usuarios(2, null, ?, null, ?, ?, ?, null)";
    
    conexion.query(
        sql,
        [request.session.codigoUsuario,
        request.body.usuario, 
        request.body.clave, 
        request.body.correo],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});////////////////Adquirir Plan////////////////
app.post('/comprar', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_usuarios(2, null, ?, ?,null, null, null, null)";
    
    conexion.query(
        sql,
        [request.session.codigoUsuario,
        request.body.plan],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
////////////////Editar Usuario////////////////
app.post('/editar-perfil', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_usuarios(2, null, ?, null, ?, ?, ?, null)";
    
    conexion.query(
        sql,
        [request.session.codigoUsuario,
        request.body.usuario, 
        request.body.clave, 
        request.body.correo],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
////////////////Verificar si correo es unico////////////////
app.post('/validarCorreo', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_correo(?)";
    
    conexion.query(sql,
        [ request.body.correo],
       
       function(err, data, fields){
                if (data[0].length>0){
   					response.send({estado:1, mensaje: "Correo Repetido"});
                }else{
                    response.send({estado:0, mensaje: "Correo Valido"}); 
                }
        }

    );
    }); 
////////////////Login////////////////
app.post('/login', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_login(?, ?)";
    
    conexion.query(sql,
        [ request.body.correo, request.body.clave],
       
       function(err, data, fields){
       			usuario = data[0][0];
                if (data[0].length>0){
                	
                    request.session.correo = usuario.correo;
                    request.session.codigoTipoUsuario = usuario.codigo_tipo_usuario;
                    request.session.usuario = usuario.usuario;
                    request.session.codigoUsuario = usuario.codigo_usuario;
   					usuario.estado=0;
   					var sql1 = "call sp_accesos(?)";
      				var conexion = mysql.createConnection(credenciales);
      	 			conexion.query( sql1,
       					[ usuario.codigo_usuario],
        				function(err, result){
           					if (err) throw err;
        				});
    				response.send(usuario); 
                }else{
                    response.send({estado:1, mensaje: "Login fallido"}); 
                }
        }

    );
    }); 
var publicAdmin = express.static("public-admin");//Hace publica la carpeta de admin
var publicUsuario = express.static("public-usuario");//Hace publica la carpeta de usuarios

//Verificar si existe una variable de sesion para poner publica la carpeta segun tipo de usuario
app.use(
    function(request,response,next){
        if (request.session.correo){
            if (request.session.codigoTipoUsuario == 1){
                publicAdmin(request,response,next);
            }else if (request.session.codigoTipoUsuario == 2){
                publicUsuario(request,response,next);
            }  	
        }else
            return next();
    }
);

//Obtener sesion correo
app.get("/obtener-sesion", function(peticion, respuesta){
   respuesta.send(peticion.session.correo);
});
////////////////Cerrar Sesion////////////////
app.get("/logout",function(request, response){
	request.session.destroy();
	console.log('Cerrando Sesion');
	response.send({estado:0, mensaje: "Sesion Eliminada"});

});
////////////////Guardar Codigo Archivo Seleccionado////////////////
app.get("/documento-seleccionado",function(request, response){
    request.session.codigoArchivo= request.query.archivo;
    response.send({mensaje:'Se guardo archivo seleccionado'});

});
//Ruta Restringida
app.get("/ruta-restringida",verificarAutenticacion,  function(peticion, respuesta){
    console.log('Bienvenido a la ruta restringida');
    respuesta.send({estado:0, mensaje: "Bienvenido a la Ruta Restringida"});
});
///Para agregar seguridad a una ruta especifica:
function verificarAutenticacion(peticion, respuesta, next){
    if(peticion.session.correo){
        console.log('Ruta Permitida');
        return next();
    }else{
      respuesta.send({estado:1, mensaje: "Error: Acceso No Autorizado"});  
    }
}

////////////////Crear Nueva Carpeta////////////////
app.post('/nueva-carpeta', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_archivos(1, null, ?, ?, ?, 'carpeta', null,null,null)";
    var codigoCarpetaPadre = request.body.carpetaPadre;
    codigoArchivo = null;
    if(codigoCarpetaPadre==0){
      sql = "call sp_archivos(1, null, null, ?, ?, 'carpeta', null,null,null)";
        conexion.query(
            sql,
            [request.session.codigoUsuario, 
            request.body.nombre],
       
        function(err, result){
            if (err) throw err;
            sql1 = "SELECT LAST_INSERT_ID() AS codigo;";
            conexion.query(
                sql1,
                function(err, result1){
                    if (err) throw err;
                    console.log(result1[0].codigo);
                    var respuesta ={affectedRows:1};
                    respuesta.codigo=result1[0].codigo;
                    response.send(respuesta);
                }
            );
        }
        );   
    }else{
        conexion.query(
            sql,
            [
            codigoCarpetaPadre,
            request.session.codigoUsuario, 
            request.body.nombre],
       
            function(err, result){
                if (err) throw err;
                sql1 = "SELECT LAST_INSERT_ID() AS codigo;";
                conexion.query(
                    sql1,
                    function(err, result1){
                        if (err) throw err;
                        console.log(result1[0].codigo);
                        var respuesta ={affectedRows:1};
                        respuesta.codigo=result1[0].codigo;
                        response.send(respuesta);
                }
            );
        }
        );  
    }
         
});
////////////////Crear Nuevo Documento////////////////
app.post('/nuevo-documento', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_archivos(1, null, ?, ?, ?, 'documento', 'null','null','null')";
    var codigoCarpetaPadre = request.body.carpetaPadre;
    codigoArchivo = null;
    if(codigoCarpetaPadre==0){
      sql = "call sp_archivos(1, null, null, ?, ?, 'documento', 'null','null','null')";
        conexion.query(
            sql,
            [request.session.codigoUsuario, 
            request.body.nombre],
       
        function(err, result){
            if (err) throw err;
            sql1 = "SELECT LAST_INSERT_ID() AS codigo;";
            conexion.query(
                sql1,
                function(err, result1){
                    if (err) throw err;
                    console.log(result1[0].codigo);
                    var respuesta ={affectedRows:1};
                    respuesta.codigo=result1[0].codigo;
                    response.send(respuesta);
                }
            );
        }
        );   
    }else{
        conexion.query(
            sql,
            [
            codigoCarpetaPadre,
            request.session.codigoUsuario, 
            request.body.nombre],
       
            function(err, result){
                if (err) throw err;
                sql1 = "SELECT LAST_INSERT_ID() AS codigo;";
                conexion.query(
                    sql1,
                    function(err, result1){
                        if (err) throw err;
                        console.log(result1[0].codigo);
                        var respuesta ={affectedRows:1};
                        respuesta.codigo=result1[0].codigo;
                        response.send(respuesta);
                }
            );
        }
        );  
    }
         
});
////////////////Cambiar Nombre de Archivo////////////////
app.post('/cambiar-nombre', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_archivos(2, ?, null,?, ?, null, null,null,null)";
        conexion.query(
            sql,
            [request.body.archivo,
            request.session.codigoUsuario, 
            request.body.nombre],
       
            function(err, result){
                if (err) throw err;
                response.send(result);
            }
        );
});   

////////////////Cargar Unidad////////////////
app.post('/obtener-unidad', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    console.log(request.body.carpetaActual);
    if(request.body.carpetaActual==0){
        sql = "call sp_consulta_archivos(?, null)";
        conexion.query(sql,
        [ request.session.codigoUsuario],
            function(err, data, fields){
                archivos = data[0];
                if (data.length>0){
                    console.log(archivos);
                    response.send(archivos); 
                }else{
                    response.send({estado:1, mensaje: "No se pudieron cargar los archivos"}); 
                }
            }
            );
        }else{
            var sql = "call sp_consulta_archivos(?, ?)";
            conexion.query(sql,
                [ request.session.codigoUsuario, request.body.carpetaActual],
       
                 function(err, data, fields){
                    console.log(data);
                    archivos = data[0];
                    if (data.length>0){
                        console.log(archivos);
                        response.send(archivos); 
                    }else{
                        response.send({estado:1, mensaje: "No se pudieron cargar los archivos"}); 
                    }
                }
            );


        }
    });
////////////////Cargar Compartidos////////////////
app.post('/obtener-compartidos', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_consulta_compartidos(?)";
        conexion.query(sql,
        [ request.session.codigoUsuario],
            function(err, data, fields){
                var archivos = data[0];
                if (data.length>0){
                    console.log(archivos);
                    response.send(archivos); 
                }else{
                    response.send({estado:1, mensaje: "No se pudieron cargar los archivos compartidos"}); 
                }
            }
        );
        
    });
////////////////Cargar Favoritos////////////////
app.post('/obtener-favoritos', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_consulta_favoritos(?)";
        conexion.query(sql,
        [ request.session.codigoUsuario],
            function(err, data, fields){
                var favoritos = data[0];
                if (data.length>0){
                    console.log(favoritos);
                    response.send(favoritos); 
                }else{
                    response.send({estado:1, mensaje: "No se pudieron cargar los archivos favoritos"}); 
                }
            }
        );
        
    });
////////////////Cargar Papelera////////////////
app.post('/obtener-papelera', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_consulta_papelera(?)";
        conexion.query(sql,
        [ request.session.codigoUsuario],
            function(err, data, fields){
                var eliminados = data[0];
                if (data.length>0){
                    console.log(eliminados);
                    response.send(eliminados); 
                }else{
                    response.send({estado:1, mensaje: "No se pudieron cargar los archivos eliminados"}); 
                }
            }
        );
        
    });
////////////////Obtener Nombre de Carpeta////////////////
app.get('/obtener-nombre-carpeta', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    console.log(request.query.carpetaActual);
        sql = "call sp_nombre_archivos(?)";
        conexion.query(sql,
        [ request.query.carpetaActual],
            function(err, data, fields){
                var nombre = data[0];
                if (data.length>0){
                    console.log(nombre);
                    response.send(nombre); 
                }else{
                    response.send({estado:1, mensaje: "No se pudo cargar el nombre"}); 
                }
            }
            );
    });
////////////////Obtener Archivo////////////////
app.post('/obtener-archivo', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_contenido_archivo(?)";
        conexion.query(sql,
        [ request.session.codigoArchivo],
            function(err, data, fields){
                var archivo = data[0][0];
                if (data.length>0){
                    console.log(archivo);
                    response.send(archivo); 
                }else{
                    response.send({estado:1, mensaje: "No se pudo cargar el archivo"}); 
                }
            }
            );
    });
////////////////Guardar Archivo////////////////
app.post('/guardar-archivo', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_archivos(2, ?, null,null, null, null, null, ?, null)";
        conexion.query(sql,
        [ request.session.codigoArchivo,
        request.body.contenido],
            function(err, data, fields){
            }
            );
    })
////////////////Obtener Datos de Perfil////////////////
app.post('/obtener-perfil', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    console.log(request.query.carpetaActual);
        sql = "call mihaly.sp_consulta_perfil(?)";
        conexion.query(sql,
        [ request.session.codigoUsuario],
            function(err, data, fields){
                var datos = data[0][0];
                if (data.length>0){
                    console.log(datos);
                    response.send(datos); 
                }else{
                    response.send({estado:1, mensaje: "No se pudo cargar los datos"}); 
                }
            }
            );
    });
////////////////Obtener Datos de Usuarios////////////////
app.post('/obtener-datos-usuarios', function(request, response){
    var conexion = mysql.createConnection(credenciales);
        sql = "call sp_consulta_usuarios_registrados()";
        conexion.query(sql,
            function(err, data, fields){
                var datos = data[0];
                if (data.length>0){
                    console.log(datos);
                    response.send(datos); 
                }else{
                    response.send({estado:1, mensaje: "No se pudo cargar el datos"}); 
                }
            }
            );
    });



////////////////Compartir////////////////
app.post('/compartir', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call mihaly.sp_archivos_compartidos(1, ?, ?)";
    console.log(request.body.archivo);
    conexion.query(
        sql,
        [request.body.archivo, 
        request.body.correo],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
////////////////Agregar Favorito////////////////
app.post('/agregar-favorito', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_favoritos(?, ?)";
    console.log(request.body.archivo);
    conexion.query(
        sql,
        [request.body.archivo, 
        request.session.codigoUsuario],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
////////////////Eliminar Archivo////////////////
app.post('/eliminar-archivo', function(request, response){
    var conexion = mysql.createConnection(credenciales);
    var sql = "call sp_archivos(2, ?, null, ?, null, null, null, null, 2)";
    console.log(request.body.archivo);
    conexion.query(
        sql,
        [request.body.archivo, 
        request.session.codigoUsuario],
       
        function(err, result){
            if (err) throw err;
            response.send(result);
        }
    ); 
});
//Crear y levantar el servidor web.
app.listen(3000);
console.log("Servidor iniciado");