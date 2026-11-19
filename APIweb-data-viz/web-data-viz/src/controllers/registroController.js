var empresaModel = require("../models/empresaModel");
var usuarioModel = require("../models/usuarioModel");
var vinhedoModel = require("../models/vinhedoModel");

async function registrar(req, res) {
    var nome = (req.body.nomeServer || '').trim();
    var email = (req.body.emailServer || '').trim();
    var senha = req.body.senhaServer;
    var cpf = (req.body.cpfServer || '').replace(/\D/g, '');

    if (!nome || !email || !senha || !cpf) {
        return res.status(400).send("Faltam dados do cadastro!");
    }

    // Se vier dados da empresa, cria empresa e usuário em sequência
    var nomeEmpresa = req.body.nomeEmpresaServer;
    var cnpjEmpresa = req.body.cnpjEmpresaServer;
    var area = req.body.areaServer;
    var codigoCadastro = req.body.codigoCadastroServer;

    try {
        if (nomeEmpresa && cnpjEmpresa) {
            // Criar empresa
            var resultadoEmpresa = await empresaModel.cadastrar(nomeEmpresa, cnpjEmpresa, area);
            var idEmpresa = resultadoEmpresa.idEmpresa;

            // Criar usuário com fk direto
            try {
                var resultadoUsuario = await usuarioModel.cadastrarPorEmpresaId(nome, email, senha, cpf, idEmpresa);
            } catch (errUsuario) {
                // se falhar ao criar usuário, tenta remover a empresa criada para manter o estado consistente
                console.error('Erro ao cadastrar usuário após criar empresa:', errUsuario);
                try {
                    await empresaModel.removerPorId(idEmpresa);
                } catch (errRemocao) {
                    console.error('Falha ao remover empresa após erro no cadastro do usuário:', errRemocao);
                }

                if (errUsuario && errUsuario.code === 'ER_DUP_ENTRY') {
                    return res.status(409).send('Email ou CPF já cadastrado');
                }

                return res.status(500).json(errUsuario.sqlMessage || errUsuario);
            }

            // Buscar vinhedos da empresa
            var vinhedos = await vinhedoModel.buscarPorEmpresa(idEmpresa);

            return res.json({ id: resultadoUsuario.insertId, nome: nome, email: email, empresaId: idEmpresa, vinhedos: vinhedos });
        }

        if (codigoCadastro) {
            // usar o fluxo existente: cadastrar pelo codigo
            var resultado = await usuarioModel.cadastrar(nome, email, senha, cpf, codigoCadastro);
            if (resultado.affectedRows == 0) {
                return res.status(404).send("Código de cadastro da empresa não encontrado");
            }
            // autenticar para retornar o payload padrão
            var auth = await usuarioModel.autenticar(email, senha);
            if (auth.length == 1) {
                var u = auth[0];
                var vinhedos = await vinhedoModel.buscarPorEmpresa(u.empresaId);
                return res.json({ id: u.id, nome: u.nome, email: u.email, empresaId: u.empresaId, vinhedos: vinhedos });
            } else {
                return res.status(500).send("Erro ao autenticar após cadastro");
            }
        }

        return res.status(400).send("Dados insuficientes: informe codigoCadastroServer ou os dados da nova empresa");

    } catch (erro) {
        console.error(erro);
        if (erro && erro.code === 'ER_DUP_ENTRY') {
            return res.status(409).send('Esse CNPJ já está cadastrado');
        }
        if (erro && erro.sqlMessage) {
            return res.status(500).json(erro.sqlMessage);
        }
        return res.status(500).json(erro);
    }
}

module.exports = { registrar };
