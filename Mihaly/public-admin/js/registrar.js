var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "shinobu96"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});


module.exports={
    test: function(req, res){
    	var usuario = {};
        usuario.usuario =  req.body.usuario;
        usuario.correo =  req.body.correo;
        usuario.clave =  req.body.clave;
        console.log('Se agrego usuario');
        res.send('Se agrego usuario '+ usuario.usuario);
    }
};
