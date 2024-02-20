var express = require('express');
var router = express.Router();
const personaC = require('../app/controls/PersonaControl');
let personaControl = new personaC();
const rolC = require('../app/controls/RolControl');
let rolControl = new rolC();
const noticiaC = require('../app/controls/NoticiaControl');
let noticiaControl = new noticiaC();
const cuentaC = require('../app/controls/CuentaControl');
let cuentaControl = new cuentaC();
const comentarioC = require('../app/controls/ComentarioControl');
let comentarioControl = new comentarioC();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('reporte de quinto');
});

//MIDDLEWARE
const auth = function middleware(req, res, next){
  //AUTENTICACION
  const token = req.headers['practica3-token'];
  if(token === undefined){
    res.status(400);
    res.json({ msg: "ERROR", tag: "Falta token", code: 400 });
  }else{
    require('dotenv').config();
    const key = process.env.KEY_JWT;
    jwt.verify(token, key, async(error, decoded) => {
      if(error){
        res.status(400);
        res.json({ msg: "ERROR", tag: "TOKEN NO VALIDO O EXPIRADO", code: 400 });
      }else{
        console.log(decoded.external);
        const models = require('../app/models');
        const cuenta = models.cuenta;
        const aux = await cuenta.findOne({
          where: {external_id : decoded.external}
        });
        if(aux === null){
          res.status(400);
        res.json({ msg: "ERROR", tag: "TOKEN NO VALIDO", code: 400 });
        }else{
          //AUTORIZACION
          next();
        }
      }
      
    });
    
  }
}

router.get('/admin/personas', personaControl.listar);
router.get('/admin/personas/get/:external', personaControl.obtener);
router.post('/admin/personas/save', personaControl.guardar);
router.put('/admin/personas/put/:external', personaControl.modificar);
router.post('/admin/personas/modificar/:external', personaControl.modificar);
router.get('/admin/personas/cambiarEstado/:external/:nuevoEstado', personaControl.cambiarEstado);

router.get('/admin/rol', rolControl.listar);
router.post('/admin/rol/save', rolControl.guardar);

router.get('/noticias', noticiaControl.listar);
router.get('/noticias/get/:external', noticiaControl.obtener);
router.get('/admin/noticias/cambiarEstado/:external/:nuevoEstado', noticiaControl.cambiarEstado);
router.post('/admin/noticias/save', noticiaControl.guardar);
router.post('/admin/noticias/guardar/archivo', auth, noticiaControl.guardarImage);

router.get('/comentarios', auth, comentarioControl.listarTodo);
router.get('/comentarios/:external', auth, comentarioControl.listar);
router.post('/admin/comentarios/save', auth, comentarioControl.guardar);
router.post('/admin/comentarios/modificar', auth, comentarioControl.modificar);

router.post('/login', cuentaControl.inicio_sesion);

module.exports = router;
