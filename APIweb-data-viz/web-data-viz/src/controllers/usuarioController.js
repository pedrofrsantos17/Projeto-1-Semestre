var usuarioModel = require("../models/usuarioModel");
var vinhedoModel = require("../models/vinhedoModel");

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está indefinida!");
    } else {
        usuarioModel.autenticar(email, senha)
            .then(function (resultado) {
                if (resultado.length == 1) {
                    var u = resultado[0];
                    vinhedoModel.buscarPorEmpresa(u.empresaId)
                        .then(function (vinhedos) {
                            res.json({
                                id: u.id,
                                nome: u.nome,
                                email: u.email,
                                empresaId: u.empresaId,
                                vinhedos: vinhedos
                            });
                        })
                        .catch(function (erro) {
                            console.log(erro);
                            res.status(500).json(erro.sqlMessage);
                        });
                } else if (resultado.length == 0) {
                    res.status(403).send("Email e/ou senha inválido(s)");
                } else {
                    res.status(403).send("Mais de um usuário com o mesmo login e senha!");
                }
            })
            .catch(function (erro) {
                console.log(erro);
                res.status(500).json(erro.sqlMessage);
            });
    }
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;
    var cpf = req.body.cpfServer;
    var codigoCadastro = req.body.codigoCadastroServer;

    if (nome == undefined || email == undefined || senha == undefined || cpf == undefined || codigoCadastro == undefined) {
        res.status(400).send("Faltam dados do cadastro!");
    } else {
        usuarioModel.cadastrar(nome, email, senha, cpf, codigoCadastro)
            .then(function (resultado) {
                if (resultado.affectedRows == 0) {
                    res.status(404).send("Código de cadastro da empresa não encontrado");
                } else {
                    res.json(resultado);
                }
            })
            .catch(function (erro) {
                console.log(erro);
                if (erro.code == "ER_DUP_ENTRY") {
                    res.status(409).send("Email ou CPF já cadastrado");
                } else {
                    res.status(500).json(erro.sqlMessage);
                }
            });
    }
}

module.exports = { autenticar, cadastrar };