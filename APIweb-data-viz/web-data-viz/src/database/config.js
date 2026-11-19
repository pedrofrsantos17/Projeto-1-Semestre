var mysql = require("mysql2");

// CONEXÃO DO BANCO MYSQL SERVER
var mySqlConfig = {
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
};

// Normaliza variáveis de ambiente comuns (remove aspas envolvendo valores)
function stripQuotes(v) {
    if (v === undefined || v === null) return v;
    var s = String(v).trim();
    if ((s.startsWith('"') && s.endsWith('"')) || (s.startsWith("'") && s.endsWith("'"))) {
        return s.substring(1, s.length - 1);
    }
    return s;
}

if (mySqlConfig.password) mySqlConfig.password = stripQuotes(mySqlConfig.password);
if (mySqlConfig.port) mySqlConfig.port = Number(stripQuotes(mySqlConfig.port)) || mySqlConfig.port;

/**
 * Executa uma instrução SQL. Aceita opcionalmente um array de parâmetros
 * para queries parametrizadas (prepared statements).
 *
 * @param {string} instrucao SQL com placeholders (?)
 * @param {Array} [params] Parâmetros para os placeholders
 * @returns {Promise<any>} resultados da query
 */
function executar(instrucao, params) {

    if (process.env.AMBIENTE_PROCESSO !== "producao" && process.env.AMBIENTE_PROCESSO !== "desenvolvimento") {
        console.log("\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM .env OU dev.env OU app.js\n");
        return Promise.reject("AMBIENTE NÃO CONFIGURADO EM .env");
    }

    return new Promise(function (resolve, reject) {
        var conexao = mysql.createConnection(mySqlConfig);

        conexao.connect(function (err) {
            if (err) {
                console.error("ERRO AO CONECTAR NO MySQL: ", err.sqlMessage || err.message || err);
                reject(err);
                return;
            }

            // callback comum para as queries
            var cb = function (erro, resultados) {
                conexao.end();
                if (erro) {
                    reject(erro);
                    return;
                }
                console.log(resultados);
                resolve(resultados);
            };

            try {
                if (params && Array.isArray(params)) {
                    conexao.query(instrucao, params, cb);
                } else {
                    conexao.query(instrucao, cb);
                }
            } catch (queryErr) {
                conexao.end();
                reject(queryErr);
            }
        });

        conexao.on('error', function (erro) {
            console.error('ERRO NO MySQL SERVER: ', erro.sqlMessage || erro);
            reject(erro);
        });
    });
}

module.exports = {
    executar
};
