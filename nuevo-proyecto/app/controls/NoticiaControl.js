'use strict';
var formidable = require('formidable');
var models = require('../models');
var fs = require('fs');
var persona = models.persona;
var noticia = models.noticia;
var formatos = ['jpg', 'png', "mp4"]

class NoticiaControl {
    async listar(req, res) {
        var lista = await noticia.findAll({
            include: [
                { model: models.persona, as: "persona", attributes: ['apellidos', 'nombres'] },
            ],
            attributes: ['titulo', ['external_id', 'id'],'cuerpo', 'tipo_archivo', 'fecha', 'tipo_noticia', 'archivo', 'estado']
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await noticia.findOne({
            where: { external_id: external },
            include: [
                { model: models.persona, as: "persona", attributes: ['apellidos', 'nombres'] },
            ],
            attributes: ['titulo', ['external_id', 'id'],'cuerpo', 'tipo_archivo', 'fecha', 'tipo_noticia', 'archivo', 'estado']
        });
        if (lista === undefined || lista == null) {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: {} });
        } else {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('titulo') &&
            req.body.hasOwnProperty('cuerpo') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('tipo_noticia') &&
            req.body.hasOwnProperty('persona')) {
            var uuid = require('uuid');
            var perA = await persona.findOne({
                where: { external_id: req.body.persona },
                include: [
                    { model: models.rol, as: "rol", attributes: ['nombre'] }]
            });
            if (perA == undefined || perA == null) {
                res.status(401);
                res.json({ msg: "ERROR", tag: "No se encuentra el editor", code: 401 });
            } else {
                if (perA.rol.nombre == 'editor') {
                    var data = {
                        cuerpo: req.body.cuerpo,
                        external_id: uuid.v4(),
                        titulo: req.body.titulo,
                        fecha: req.body.fecha,
                        tipo_noticia: req.body.tipo_noticia,
                        id_persona:perA.id,
                        estado: false,
                        archivo: 'noticia.png'
                    };
                    console.log("*********");
                    console.log(data);
                    var result = await noticia.create(data);
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "No se puede crear", code: 401 });
                    } else {
                        perA.external_id = uuid.v4();
                        await perA.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } else {
                    res.status(400);
                    res.json({ msg: "ERROR", tag: "La persona que esta ingresando la noticia no es un editor", code: 400 });
                }
            }
        } else {
            res.status(400);
            res.json({ msg: "ERROR", tag: "Faltan datos", code: 400 });
        }

    }

    async cambiarEstado(req, res) {
        const external = req.params.external;
        const nuevoEstado = req.params.nuevoEstado;
        console.log('Valor de nuevoEstado:', nuevoEstado);
        try{
            var lista = await noticia.findOne({
                where: { external_id: external },
            });
            if (lista === undefined || lista == null) {
                res.status(200);
                res.json({ msg: "OK", code: 200, datos: {} });
            } else {
                lista.estado = nuevoEstado;
                await lista.save();
                res.status(200);
                res.json({ msg: "OK", code: 200});
            }
        }catch(error){
            console.log("Error al cambiar estado de noticia", error);
            res.status(500).json({mensaje: "Error en server", code:500})
        }
    }

    async guardarImage(req, res) {
        var form = new formidable.IncomingForm(), files = [];

        form.on('file', function (field, file) {
            files.push(file);
        }).on('end', function () {
            console.log('OK');
        });
        form.parse(req, function (err, fields) {
            let listado = files;

            let external = fields.external[0];

            for (let index = 0; index < listado.length; index++) {
                var file = listado[index];

                var extension = file.originalFilename.split('.').pop().toLowerCase();

                if (formatos.includes(extension)) {
                    if (file.size <= (2 * 1024 * 1024)) {
                        const name = external + '.' + extension;
                        console.log(formatos);
                        fs.rename(file.filepath, "public/multimedia/" + name, async function () {
                            if (err) {
                                res.status(200);
                                res.json({ msg: "Error", tag: 'Error al guardar', code: 200 });
                            } else {
                                var notiAux = await noticia.findOne({ where: { external_id: external } });

                                notiAux.archivo = name;
                                notiAux.estado = true;
                                notiAux.save()

                                res.status(200);
                                res.json({ msg: "OK", tag: 'Dato guardado Exitosamente', code: 200 });
                            }
                        });
                    } else {
                        res.status(400);
                        res.json({ msg: "ERROR", tag: 'No aceptado archivos de mas de 2mb', code: 400 });
                    }

                } else {
                    res.status(400);
                    res.json({ msg: "ERROR", tag: 'soportado solo para ' + formatos, code: 400 });
                }
            };
        });
    }

}
module.exports = NoticiaControl;