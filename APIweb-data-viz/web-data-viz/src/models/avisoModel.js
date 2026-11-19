var database = require("../database/config");

function listar() {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");
    var instrucaoSql = `
        SELECT 
            a.id_aviso AS idAviso,
            a.titulo,
            a.descricao,
            a.fk_usuario,
            u.id_usuario AS idUsuario,
            u.nome_usuario AS nome,
            u.email AS email
        FROM aviso a
            INNER JOIN usuario u
                ON a.fk_usuario = u.id_usuario;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function pesquisarDescricao(texto) {
    console.log("ACESSEI O AVISO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function pesquisarDescricao()");
    var instrucaoSql = `
        SELECT 
            a.id_aviso AS idAviso,
            a.titulo,
            a.descricao,
            a.fk_usuario,
            u.id_usuario AS idUsuario,
            u.nome,
            u.email
        FROM aviso a
            INNER JOIN usuario u
                ON a.fk_usuario = u.id_usuario
        WHERE a.descricao LIKE ?;
    `;
    // usar wildcard para pesquisa parcial
    var param = '%' + texto + '%';
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [param]);
    return database.executar(instrucaoSql, [param]);
}

function listarPorUsuario(idUsuario) {
    console.log("ACESSEI O AVISO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listarPorUsuario()");
    var instrucaoSql = `
        SELECT 
            a.id_aviso AS idAviso,
            a.titulo,
            a.descricao,
            a.fk_usuario,
            u.id_usuario AS idUsuario,
            u.nome,
            u.email
        FROM aviso a
            INNER JOIN usuario u
                ON a.fk_usuario = u.id_usuario
        WHERE u.id_usuario = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idUsuario]);
    return database.executar(instrucaoSql, [idUsuario]);
}

function publicar(titulo, descricao, idUsuario) {
    console.log("ACESSEI O AVISO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function publicar(): ", titulo, descricao, idUsuario);
    var instrucaoSql = `
        INSERT INTO aviso (titulo, descricao, fk_usuario) VALUES (?, ?, ?);
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [titulo, descricao, idUsuario]);
    return database.executar(instrucaoSql, [titulo, descricao, idUsuario]);
}

function editar(novaDescricao, idAviso) {
    console.log("ACESSEI O AVISO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function editar(): ", novaDescricao, idAviso);
    var instrucaoSql = `
        UPDATE aviso SET descricao = ? WHERE id_aviso = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [novaDescricao, idAviso]);
    return database.executar(instrucaoSql, [novaDescricao, idAviso]);
}

function deletar(idAviso) {
    console.log("ACESSEI O AVISO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function deletar():", idAviso);
    var instrucaoSql = `
        DELETE FROM aviso WHERE id_aviso = ?;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql + "\nParams: ", [idAviso]);
    return database.executar(instrucaoSql, [idAviso]);
}

module.exports = {
    listar,
    listarPorUsuario,
    pesquisarDescricao,
    publicar,
    editar,
    deletar
}
