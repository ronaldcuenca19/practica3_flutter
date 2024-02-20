'use strict';

module.exports =(sequelize, DataTypes) => {
    const persona = sequelize.define('persona',{
        apellidos: {type:DataTypes.STRING(100)},
        nombres: {type:DataTypes.STRING(100)},
        direccion: {type:DataTypes.STRING,defaultValue: "NONE"},
        celular: {type:DataTypes.STRING(20),defaultValue: "NONE"},
        fecha_nac: {type:DataTypes.DATEONLY},
        external_id: {type:DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
    },{freezeTableName: true});
    persona.associate = function(models){
        persona.hasOne(models.cuenta,{foreignKey:'id_persona', as:'cuenta'}); //rol tiene muchas perosnas asociadas
        persona.hasMany(models.noticia,{foreignKey:'id_persona', as:'noticia'}); 
        persona.belongsTo(models.rol,{foreignKey:'id_rol'}); 
    };
    return persona;
};