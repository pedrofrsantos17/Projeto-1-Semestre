var database = require("../database/config");

function buscarPorEmpresa(idEmpresa) {
    var instrucaoSql = `
        SELECT id_vinhedo AS id, nome_vinhedo AS nome
        FROM vinhedo
        WHERE fk_empresa = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idEmpresa]);
    return database.executar(instrucaoSql, [idEmpresa]);
}

// Cadastra um vinhedo associando-o à empresa do usuário informado
function cadastrar(descricao, idUsuario) {
    var instrucaoSql = `
        INSERT INTO vinhedo (fk_empresa, nome_vinhedo)
        SELECT fk_empresa, ?
        FROM usuario
        WHERE id_usuario = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [descricao, idUsuario]);
    return database.executar(instrucaoSql, [descricao, idUsuario]);
}

module.exports = { buscarPorEmpresa, cadastrar };
