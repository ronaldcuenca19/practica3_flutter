'use strict';

module.exports =(sequelize, DataTypes) => {
    const noticia = sequelize.define('noticia',{
        titulo: {type:DataTypes.STRING(150), defaultValue:"NONE"},
        cuerpo: {type:DataTypes.TEXT,defaultValue: "NONE"},
        archivo: {type:DataTypes.STRING(150),defaultValue: "NONE"},
        tipo_archivo:{type: DataTypes.ENUM(['VIDEO', 'IMAGEN']),defaultValue: "IMAGEN"},
        tipo_noticia: {type: DataTypes.ENUM(['NORMAL', 'DEPORTIVA', 'POLITICA', 'CULTURAL', 'CIENTIFICA']),defaultValue: "NORMAL"},
        fecha: {type:DataTypes.DATEONLY},
        estado:{type:DataTypes.BOOLEAN, defaultValue: true},
        external_id: {type:DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
    },{freezeTableName: true});
    noticia.associate = function(models){
        //noticia.hasOne(models.cuenta,{foreignKey:'id_persona', as:'cuenta'}); //rol tiene muchas perosnas asociadas
        noticia.belongsTo(models.persona,{foreignKey:'id_persona'}); 
    };
    return noticia;
};