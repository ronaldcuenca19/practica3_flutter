'use strict'

var models = require('../models');
var comentarioAentario = models.comentarioAentario;
var noticia = models.noticia;


class comentarioAentarioControl {
    async listar(req, res) {
        var lista = await comentarioAentario.findAll({
            attributes: ["texto", "estado", "cliente", "longitud", "latitud", "external_id"],
            include: [
                { model: models.noticia, as: "noticia", where: { external_id: req.params.external }, attributes: ["titulo", "estado", "external_id"] },
            ],
            order: [["createdAt", "DESC"]],
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async listarTodo(req, res) {
        var lista = await comentarioAentario.findAll({
            attributes: ["texto", "estado", "cliente", "longitud", "latitud", "external_id"],
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async guardar(req, res) {

        if (req.body.hasOwnProperty('texto') &&
            req.body.hasOwnProperty('longitud') &&
            req.body.hasOwnProperty('latitud') &&
            req.body.hasOwnProperty('cliente') &&
            req.body.hasOwnProperty('noticia')) {

            var uuid = require('uuid');

            var noticiaA = await noticia.findOne({ where: { external_id: req.body.noticia } });

            if (noticiaA != undefined) {

                var data = {
                    texto: req.body.texto,
                    cliente: req.body.cliente,
                    longitud: req.body.longitud,
                    latitud: req.body.latitud,
                    id_noticia: noticiaA.id,
                    external_id: uuid.v4(),
                }


                let transaction = await models.sequelize.transaction();

                try {
                    var result = await comentarioAentario.create(data, { transaction });
                    await transaction.comentarioAmit();
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "Error", tag: "No se lo pudo enviar Correctamente", code: 401 });
                    } else {
                        noticiaA.external_id = uuid.v4();
                        await noticiaA.save();
                        res.status(200);
                        res.json({ msg: "OK", tag: "Su comentarioAentario se ha Guardado", code: 200 });
                    }

                } catch (error) {
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    console.log(error)
                    res.json({ msg: "Error", code: 203, tag: error.errors });
                }


            } else {
                res.status(400);
                res.json({ msg: "Error", tag: "Info a buscar no se ha creado", code: 400 });
            }

        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "faltan datos", code: 400 });
        }

    }

    async modificar(req, res) {
        var comentarioA = await comentarioAentario.findOne({ where: { external_id: req.body.external } })

        if (comentarioA === null) {
            res.status(400);
            res.json({ msg: "Error", tag: "Este dato no se edito ya que no existe", code: 400 });
        } else {

            if (req.body.hasOwnProperty('texto') &&
                req.body.hasOwnProperty('longitud') &&
                req.body.hasOwnProperty('latitud')) {

                var uuid = require('uuid')

                comentarioA.texto = req.body.nombres;
                comentarioA.longitud = req.body.apellidos;
                comentarioA.latitud = req.body.direccion;
                comentarioA.external_id = uuid.v4();

                var result = await comentarioA.save();

                if (result === null) {
                    res.status(400);
                    res.json({ msg: "Error", tag: "Los datos no se pudieron modificar", code: 400 });
                } else {
                    res.status(200);
                    res.json({ msg: "Success", tag: "Datos Correctamente Modificados", code: 200 });
                }

            } else {
                res.status(400);
                res.json({ msg: "Error", tag: "faltan datos", code: 400 });
            }
        }
    }

}
module.exports = comentarioAentarioControl;