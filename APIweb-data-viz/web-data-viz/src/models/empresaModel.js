var database = require("../database/config");

function cadastrar(nome, cnpj, areaHectares) {
    // Normaliza entrada
    nome = (nome || "").trim();
    cnpj = formatCnpj(cnpj);

    var codigo = "SNR-" + Math.random().toString(36).substring(2, 8).toUpperCase();
    // areaHectares pode ser nulo
    var area = areaHectares ? areaHectares : null;

    var instrucaoSql = `
        INSERT INTO empresa (nome_empresa, cnpj_empresa, codigo_cadastro, area_hectares)
        VALUES (?, ?, ?, ?);
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [nome, cnpj, codigo, area]);
    return database.executar(instrucaoSql, [nome, cnpj, codigo, area]).then(function (resultado) {
        return { idEmpresa: resultado.insertId, codigoCadastro: codigo };
    });
}

// Formata um CNPJ aceitando tanto a versão com pontuação quanto apenas dígitos
function formatCnpj(input) {
    if (!input && input !== 0) return null;
    var s = String(input).trim();
    // remove tudo que não é dígito
    var digits = s.replace(/\D/g, "");
    if (digits.length === 14) {
        return digits.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, "$1.$2.$3/$4-$5");
    }
    // se já estiver formatado e com tamanho aceitável, apenas retorna
    if (s.length <= 18) return s;
    // caso venha maior, tenta truncar para 18 caracteres
    return s.substring(0, 18);
}

function removerPorId(idEmpresa) {
    var instrucaoSql = `DELETE FROM empresa WHERE id_empresa = ?;`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idEmpresa]);
    return database.executar(instrucaoSql, [idEmpresa]);
}

module.exports = { cadastrar, removerPorId };
