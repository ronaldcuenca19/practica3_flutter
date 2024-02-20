'use strict'

module.exports = (sequelize, DataTypes) => {

    const comentario = sequelize.define('comentario', {
        texto: { type: DataTypes.STRING, defaultValue: "NONE" },
        estado: { type: DataTypes.BOOLEAN, defaultValue: true },
        cliente: { type: DataTypes.STRING, defaultValue: "NONE" },
        longitud: { type: DataTypes.DECIMAL(10, 10), defaultValue: 0.0 },
        latitud: { type: DataTypes.DECIMAL(10, 10), defaultValue: 0.0 },
        external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 }

    }, { freezeTableName: true });
    comentario.associate = function (models) {
        comentario.belongsTo(models.noticia, { foreignKey: 'id_noticia' });
    }
    return comentario;
}