
/*
Substituí este model pelo model certo do script do banco, já o relacionando com o do meu pprojeto

Ele usa o as para apelido, e traz selects com base no meu  banco de dados da sprint

*/

var database = require("../database/config");
 
function buscarUltimasMedidas(idAquario, limite_linhas) {

    // Garantir que o limite passado é um inteiro seguro
    var limite = parseInt(limite_linhas);
    if (isNaN(limite) || limite <= 0) {
        limite = 7;
    }

    var instrucaoSql = `SELECT
            temperatura,
            umidade,
            dt_registro AS momento,
            DATE_FORMAT(dt_registro,'%H:%i:%s') AS momento_grafico
        FROM leitura_sensor
        WHERE fk_sensor = ?
        ORDER BY id_leitura DESC LIMIT ${limite}`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idAquario]);
    return database.executar(instrucaoSql, [idAquario]);
}
 
function buscarMedidasEmTempoReal(idAquario) {

    var instrucaoSql = `SELECT
            temperatura,
            umidade,
            DATE_FORMAT(dt_registro,'%H:%i:%s') AS momento_grafico,
            fk_sensor AS fk_aquario
        FROM leitura_sensor
        WHERE fk_sensor = ?
        ORDER BY id_leitura DESC LIMIT 1`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idAquario]);
    return database.executar(instrucaoSql, [idAquario]);
}
 
module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
}
