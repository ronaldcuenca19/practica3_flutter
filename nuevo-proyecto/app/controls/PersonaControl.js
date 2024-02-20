'use strict';
var models = require('../models')
var persona = models.persona;
var rol = models.rol;
class PersonaControl {
    async listar(req, res) {
        var lista = await persona.findAll({
            include: [
                { model: models.cuenta, as: "cuenta", attributes: ['correo'] },
                { model: models.rol, as: "rol", attributes: ['nombre'] },
            ],
            attributes: ['apellidos', ['external_id', 'id'], 'nombres', 'direccion', 'celular', 'fecha_nac']
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await persona.findOne({
            where: { external_id: external },
            include: [
                { model: models.cuenta, as: "cuenta", attributes: ['correo'] },
                { model: models.rol, as: "rol", attributes: ['nombre'] }
            ],
        });
        if (lista === undefined || lista == null) {
            res.status(200);
            res.json({ msg: "OKI DOKI", code: 200, datos: {} });
        } else {
            res.status(200);
            res.json({ msg: "OK DOKI", code: 200, datos: lista });
        }
    }

    async modificar(req, res) {
        const external = req.params.external;
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave') &&
            req.body.hasOwnProperty('rol')) {

                const lista = await persona.findOne({
                    where: { external_id: external },
                    include: [
                        { model: models.cuenta, as: "cuenta", attributes: ['correo'] },
                        { model: models.rol, as: "rol", attributes: ['nombre'] },
                    ],
                });

            var uuid = require('uuid');
            var rolA = await rol.findOne({ where: { external_id: req.body.rol } });
            if (rolA != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    external_id: lista.external_id,
                    apellidos: req.body.apellidos,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    fecha_nac: req.body.fecha,
                    id_rol: rolA.id,
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }
                }

                let transaction = await models.sequelize.transaction();
                try {
                    var result = await lista.update(data, {transaction });     
                    await lista.getCuenta().then(async function(cuenta) {
                        await cuenta.update({
                            correo: req.body.correo,
                            clave: req.body.clave
                        }, { transaction });
                    });

                    await transaction.commit();
                                   
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR_Ronald", tag: "NO se puede crear", code: 401 });
                    } else {
                        rolA.external_id = uuid.v4();
                        await rolA.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } catch (error) {
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "ERROR_Ronald", code: 200, error_msg: "Que paso bro el correo es unico"});
                }

            } else {
                res.status(401);
                res.json({ msg: "ERROR_Ronald", tag: "El dato a buscar no existe", code: 401 });
            }
        } else {
            res.status(401);
            res.json({ msg: "ERROR_Ronald", tag: "Faltan datos", code: 401 });
        }
    }

    async modificarCuenta(req, res) {
        var person = await persona.findOne({
            where: { external_id: req.params.external }
        });


        if (person === null) {
            res.status(400);
            res.json({ msg: "Error", tag: "El dato a modificar no existe", code: 400 });
        } else {

            if (req.body.hasOwnProperty('nombres') &&
                req.body.hasOwnProperty('apellidos') &&
                req.body.hasOwnProperty('correo')) {

                var uuid = require('uuid')


                person.nombres = req.body.nombres;
                person.apellidos = req.body.apellidos;
                var cuentaAux = await cuenta.findOne({ where: { id_persona: person.id } });
                if (req.body.clave !== '') {
                    console.log("entro");
                    cuentaAux.clave = req.body.clave;
                    cuentaAux.correo = req.body.correo;
                } else {
                    console.log("no entro");
                    cuentaAux.correo = req.body.correo;
                }


                var result = await person.save();
                var result2 = await cuentaAux.save();

                if (result === null && result2 === null) {
                    res.status(400);
                    res.json({ msg: "Error", tag: "No se han modificado los datos", code: 400 });
                } else {
                    res.status(200);
                    res.json({ msg: "Success", tag: "Datos modificados correctamente", code: 200 });
                }

            } else {
                res.status(400);
                res.json({ msg: "Error", tag: "faltan datos", code: 400 });
            }
        }
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave') &&
            req.body.hasOwnProperty('rol')) {
            var uuid = require('uuid');
            var rolA = await rol.findOne({ where: { external_id: req.body.rol } });
            if (rolA != undefined) {
                var data = {
                    nombres: req.body.nombres,
                    external_id: uuid.v4(),
                    apellidos: req.body.apellidos,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    fecha_nac: req.body.fecha,
                    id_rol: rolA.id,
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }
                }

                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });
                    await transaction.commit();
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "ERROR", tag: "NO se puede crear", code: 401 });
                    } else {
                        rolA.external_id = uuid.v4();
                        await rolA.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } catch (error) {
                    if (transaction) await transaction.rollback();
                    res.status(203);
                    res.json({ msg: "Error", code: 200, error_msg: "Que paso bro el correo es unico como nuestro amor" });
                }

            } else {
                res.status(401);
                res.json({ msg: "ERROR", tag: "El dato a buscar no existe", code: 401 });
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
}
module.exports = PersonaControl;