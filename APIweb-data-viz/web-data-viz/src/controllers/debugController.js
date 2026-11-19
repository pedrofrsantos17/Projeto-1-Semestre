var database = require("../database/config");

function isDev() {
    return process.env.AMBIENTE_PROCESSO === 'desenvolvimento';
}

function usuarios(req, res) {
    if (!isDev()) return res.status(403).send('Debug endpoints disabled');

    var instrucaoSql = `
        SELECT id_usuario AS id, nome_usuario AS nome, email, cpf, fk_empresa
        FROM usuario
        ORDER BY id_usuario DESC
        LIMIT 200;
    `;
    database.executar(instrucaoSql)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error(erro);
            res.status(500).json(erro.sqlMessage || erro);
        });
}

function empresas(req, res) {
    if (!isDev()) return res.status(403).send('Debug endpoints disabled');

    var instrucaoSql = `SELECT id_empresa AS id, nome_empresa AS nome, cnpj_empresa AS cnpj, codigo_cadastro AS codigo, area_hectares AS area FROM empresa ORDER BY id_empresa DESC LIMIT 200;`;
    database.executar(instrucaoSql)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error(erro);
            res.status(500).json(erro.sqlMessage || erro);
        });
}

function vinhedos(req, res) {
    if (!isDev()) return res.status(403).send('Debug endpoints disabled');

    var instrucaoSql = `SELECT id_vinhedo AS id, fk_empresa AS empresaId, nome_vinhedo AS nome FROM vinhedo ORDER BY id_vinhedo DESC LIMIT 200;`;
    database.executar(instrucaoSql)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error(erro);
            res.status(500).json(erro.sqlMessage || erro);
        });
}

function leituras(req, res) {
    if (!isDev()) return res.status(403).send('Debug endpoints disabled');

    var instrucaoSql = `SELECT id_leitura AS id, fk_sensor AS sensorId, temperatura, umidade, dt_registro FROM leitura_sensor ORDER BY id_leitura DESC LIMIT 200;`;
    database.executar(instrucaoSql)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error(erro);
            res.status(500).json(erro.sqlMessage || erro);
        });
}

module.exports = { usuarios, empresas, vinhedos, leituras };
