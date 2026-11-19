const http = require('http');

function request(options, body) {
  return new Promise((resolve, reject) => {
    const req = http.request(options, res => {
      let out = '';
      res.on('data', c => out += c);
      res.on('end', () => resolve({ status: res.statusCode, headers: res.headers, body: out }));
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

async function postRegistro(port, payload) {
  const body = JSON.stringify(payload);
  const options = {
    hostname: 'localhost',
    port,
    path: '/registro',
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) }
  };
  return request(options, body);
}

async function postAutenticar(port, email, senha) {
  const body = JSON.stringify({ emailServer: email, senhaServer: senha });
  const options = { hostname: 'localhost', port, path: '/usuarios/autenticar', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) } };
  return request(options, body);
}

async function getDebug(port, path) {
  const options = { hostname: 'localhost', port, path, method: 'GET' };
  return request(options);
}

(async () => {
  try {
    const port = 3333;
    const r = Math.floor(Math.random() * 90000) + 10000;
    const cpf = (10000000000 + (r % 900000)).toString().slice(-11);
    const payload = {
      nomeServer: 'TesteUserVM' + r,
      emailServer: 'testevm' + r + '@example.com',
      senhaServer: 'Senha#321',
      cpfServer: cpf,
      nomeEmpresaServer: 'EmpresaVM ' + r,
      cnpjEmpresaServer: '12.345.678/0001-' + String(r % 100).padStart(2, '0'),
      areaServer: '15.5'
    };

    console.log('Enviando /registro com payload:', payload);
    const reg = await postRegistro(port, payload);
    console.log('Resposta /registro status:', reg.status);
    console.log('Resposta body:', reg.body);

    if (reg.status === 200) {
      // tentar autenticar
      const auth = await postAutenticar(port, payload.emailServer, payload.senhaServer);
      console.log('Resposta /usuarios/autenticar status:', auth.status);
      console.log('Resposta body:', auth.body);

      const empresas = await getDebug(port, '/debug/empresas');
      console.log('/debug/empresas status:', empresas.status);
      console.log('/debug/empresas body:', empresas.body);

      const usuarios = await getDebug(port, '/debug/usuarios');
      console.log('/debug/usuarios status:', usuarios.status);
      console.log('/debug/usuarios body:', usuarios.body);
    } else {
      console.error('Falha ao registrar:', reg.status, reg.body);
    }
  } catch (err) {
    console.error('Erro no teste:', err);
  }
})();
