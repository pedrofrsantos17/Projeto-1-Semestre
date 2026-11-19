
require('dotenv').config({ path: '.env.dev' });
const mysql = require('mysql2');

function stripQuotes(s) {
  if (!s && s !== '') return s;
  s = String(s).trim();
  if ((s.startsWith("\"") && s.endsWith("\"")) || (s.startsWith("'") && s.endsWith("'"))) {
    return s.substring(1, s.length - 1);
  }
  return s;
}

const config = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'aluno',
  database: process.env.DB_DATABASE || 'SenseNoir',
  password: stripQuotes(process.env.DB_PASSWORD) || 'Sptech#2024',
  port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 3307,
  connectTimeout: 10000
};

console.log('Tentando conectar ao MySQL com:', config);

const conn = mysql.createConnection(config);
conn.connect(function(err) {
  if (err) {
    console.error('Erro connect:', err);
    process.exit(1);
  }
  conn.query('SELECT NOW() AS now', (err, results) => {
    if (err) {
      console.error('Erro query:', err);
      process.exit(1);
    }
    console.log('Query OK:', results);
    conn.end();
  });
});
