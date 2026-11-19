var empresaModel = require("../models/empresaModel");

function cadastrar(req, res) {
    // aceitar nomes diferentes de campos que podem vir do cliente
    var nome = (req.body.nomeServer || req.body.nome_empresa || req.body.nomeEmpresaServer || '').trim();
    var cnpj = req.body.cnpjServer || req.body.cnpjEmpresaServer || req.body.cnpj || '';
    var area = req.body.areaServer || req.body.area || null;

    if (!nome || !cnpj) {
        res.status(400).send("Faltam nome ou CNPJ da empresa!");
    } else {
        empresaModel.cadastrar(nome, cnpj, area)
            .then(function (resultado) {
                res.json(resultado);
            })
            .catch(function (erro) {
                console.log(erro);
                if (erro.code == "ER_DUP_ENTRY") {
                    res.status(409).send("Esse CNPJ já está cadastrado");
                } else {
                    res.status(500).json(erro.sqlMessage);
                }
            });
    }
}

module.exports = { cadastrar };
