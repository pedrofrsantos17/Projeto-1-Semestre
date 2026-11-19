var database = require("../database/config")

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL - autenticar", email);

    var instrucaoSql = `
        SELECT
            id_usuario AS id,
            nome_usuario AS nome,
            email,
            fk_empresa AS empresaId
        FROM usuario
        WHERE email = ? AND senha = ? AND ativo = 1;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [email, senha]);
    return database.executar(instrucaoSql, [email, senha]);
}
 
// Só se a tela de cadastro for usada. Mantenha a assinatura que o seu controller já chama.
function cadastrar(nome, email, senha, cpf, codigoCadastro) {
    var instrucaoSql = `
        INSERT INTO usuario (fk_empresa, nome_usuario, email, senha, cpf)
        SELECT id_empresa, ?, ?, ?, ?
        FROM empresa
        WHERE codigo_cadastro = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [nome, email, senha, cpf, codigoCadastro]);
    return database.executar(instrucaoSql, [nome, email, senha, cpf, codigoCadastro]);
}

// Cadastrar usuário diretamente com id da empresa (sem usar codigoCadastro)
function cadastrarPorEmpresaId(nome, email, senha, cpf, idEmpresa) {
    var instrucaoSql = `
        INSERT INTO usuario (fk_empresa, nome_usuario, email, senha, cpf)
        VALUES (?, ?, ?, ?, ?);
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idEmpresa, nome, email, senha, cpf]);
    return database.executar(instrucaoSql, [idEmpresa, nome, email, senha, cpf]);
}
module.exports = {
    autenticar,
    cadastrar
    , cadastrarPorEmpresaId
};
