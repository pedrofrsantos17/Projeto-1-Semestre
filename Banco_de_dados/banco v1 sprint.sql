CREATE DATABASE SenseNoir;
USE SenseNoir;


-- ===================================================================================================================================
-- CRIAÇÃO DAS TABELAS
-- ===================================================================================================================================
DROP TABLE empresa;
CREATE TABLE empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome_empresa VARCHAR(70) NOT NULL,
    cnpj_empresa CHAR(18) NOT NULL UNIQUE,
    codigo_cadastro VARCHAR(20) NOT NULL UNIQUE,
    area_hectares DECIMAL(6,2),
    dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE usuario;
CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    fk_empresa INT NOT NULL,
    nome_usuario VARCHAR(70) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    ativo TINYINT(1) NOT NULL DEFAULT 1 ,
    dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

DROP TABLE sensor;
CREATE TABLE sensor (
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    numero_serie VARCHAR(20) NOT NULL UNIQUE,
    fk_empresa INT NOT NULL,
    localizacao VARCHAR(100),
    dt_instalacao DATE,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

drop table leitura_sensor;
CREATE TABLE leitura_sensor (
    id_leitura INT PRIMARY KEY AUTO_INCREMENT,
    fk_sensor INT NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    umidade DECIMAL(5,2) NOT NULL,
    dt_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_sensor) REFERENCES sensor(id_sensor),
    CHECK (umidade BETWEEN 0 AND 100)
);

DROP TABLE alerta;
CREATE TABLE alerta (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    fk_leitura INT NOT NULL,
    tipo_alerta VARCHAR(40) NOT NULL,
    dt_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_leitura) REFERENCES leitura_sensor(id_leitura)
);


-- ===================================================================================================================================
-- INSERT'S
-- ===================================================================================================================================


INSERT INTO empresa (nome_empresa, cnpj_empresa, codigo_cadastro, area_hectares) VALUES
('Vinícola Vale Verde', '24.999.432/0001-16', 'VVV-2026-01', 18.50),
('Quinta do Sol Vinhos Finos', '09.239.557/0001-54', 'QSV-2026-02', 22.00),
('Adega Serrana', '15.053.665/0001-30', 'ADS-2026-03', 30.00),
('Vinhedos de Altitude', '86.475.320/0001-13', 'VDA-2026-04', 28.00),
('Espumantes Dom Bosco', '57.646.469/0001-10', 'EDB-2026-05', 20.00),
('Cantina Rota das Uvas', '65.753.786/0001-63', 'CRU-2026-06', 20.00),
('Terroir dos Pampas', '12.147.968/0001-24', 'TDP-2026-07', 25.00);


INSERT INTO usuario (fk_empresa, nome_usuario, email, cpf, senha, ativo) VALUES
(1, 'Marina Costa', 'marina.costa@valeverdevinhos.com', '12345678976', 'Mc@2026vv', 1),
(1, 'Paulo Henrique', 'paulo.henrique@valeverdevinhos.com', '12345678844', 'Ph#26vale', 1),
(2, 'Renata Alves', 'renata.alves@quintadosol.com.br', '12345478909', 'Ra_qs2026', 1),
(4, 'João Vitor', 'joao.vitor@vinhedosdealtitude.com', '12346658909', 'Jv!alt26',  1),
(4, 'Camila Duarte', 'camila.duarte@vinhedosdealtitude.com', '21345678909', 'Cd_alt09',  1),
(6, 'Bruno Salles', 'bruno.salles@rotadasuvas.com', '12999890900', 'Bs#rota26', 1);


INSERT INTO sensor (numero_serie, fk_empresa, localizacao, dt_instalacao, ativo) VALUES
('DHT-1001', 1, 'Setor 1', '2026-03-10', 1),
('DHT-1002', 1, 'Setor 2', '2026-03-10', 1),
('DHT-1003', 1, 'Setor 3', '2026-03-12', 1),
('DHT-1004', 1, 'Setor 4', '2026-03-12', 1),
('DHT-2001', 2, 'Setor 1', '2026-02-20', 1),
('DHT-2002', 2, 'Setor 2', '2026-02-20', 1),
('DHT-2003', 2, 'Setor 3', '2026-02-21', 1),
('DHT-3001', 3, 'Setor 1', '2026-01-15', 0),
('DHT-3002', 3, 'Setor 2', '2026-01-15', 0),
('DHT-4001', 4, 'Setor 1', '2026-04-01', 1),
('DHT-4002', 4, 'Setor 2', '2026-04-01', 1),
('DHT-4003', 4, 'Setor 3', '2026-04-02', 1),
('DHT-4004', 4, 'Setor 4', '2026-04-02', 1),
('DHT-5001', 5, 'Setor 1', '2025-11-05', 0),
('DHT-5002', 5, 'Setor 2', '2025-11-05', 0),
('DHT-6001', 6, 'Setor 1', '2026-05-18', 1),
('DHT-6002', 6, 'Setor 2', '2026-05-18', 1),
('DHT-6003', 6, 'Setor 3', '2026-05-19', 1),
('DHT-7001', 7, 'Setor 1', '2025-09-30', 0),
('DHT-7002', 7, 'Setor 2', '2025-09-30', 0);


INSERT INTO leitura_sensor (fk_sensor, temperatura, umidade, dt_registro) VALUES
(1, 23.50, 65, '2026-08-01 08:00:00'),
(1, 22.80, 70, '2026-08-01 14:00:00'),
(1, 14.00, 55, '2026-08-02 08:00:00'),
(2, 25.10, 58, '2026-08-01 08:00:00'),
(2, 24.30, 62, '2026-08-01 14:00:00'),
(3, 19.50, 92, '2026-08-03 08:00:00'),
(3, 20.10, 94, '2026-08-03 14:00:00'),
(4, 26.40, 40, '2026-08-04 08:00:00'),
(4, 27.00, 38, '2026-08-04 14:00:00'),
(10, 21.90, 91, '2026-08-05 08:00:00'),
(10, 22.20, 96, '2026-08-05 14:00:00');


INSERT INTO alerta (fk_leitura, tipo_alerta, dt_alerta) VALUES
(6, 'Risco de Míldio', '2026-08-03 08:05:00'),
(7, 'Risco de Míldio', '2026-08-03 14:05:00'),
(8, 'Risco de Oídio', '2026-08-04 08:05:00'),
(9, 'Risco de Oídio', '2026-08-04 14:05:00'),
(10, 'Risco de Míldio', '2026-08-05 08:05:00'),
(11, 'Risco de Míldio', '2026-08-05 14:05:00');

-- ====================================================================================================================================
-- PRINCIPAIS SELECTS
-- ===================================================================================================================================

-- 1) Dados de uma vinícola específica

SELECT * FROM empresa WHERE nome_empresa = 'Vinhedos de Altitude';

-- 2) Sensores de uma vinícola, com status

SELECT 
	s.numero_serie, 
    e.nome_empresa, 
    s.localizacao, 
    s.ativo
FROM sensor s
	LEFT JOIN empresa e 
		ON s.fk_empresa = e.id_empresa
WHERE s.fk_empresa = 4;

-- 3) Usuários de uma vinícola 

SELECT nome_usuario, email, ativo
FROM usuario
WHERE fk_empresa = 4;

-- ====================================================================================================================================
-- SELECTS SECUNDÁRIOS
-- ===================================================================================================================================


-- 4) Cadastro de usuário: descobrir a empresa pelo código de cadastro.

SELECT id_empresa FROM empresa WHERE codigo_cadastro = 'VDA-2026-04';

-- 5) Leituras com nome da vinícola e status calculado da lavoura.
--    Limites do míldio (18-25°C, umidade >= 90%).

SELECT
    e.nome_empresa AS 'Vinícola',
    s.numero_serie AS 'Sensor',
    s.localizacao AS 'Localização',
    DATE_FORMAT(l.dt_registro, '%d/%m/%Y') AS 'Data',
    TIME(l.dt_registro) AS 'Hora',
    CONCAT(l.temperatura, ' °C') AS 'Temperatura',
    CONCAT(l.umidade, '%') AS 'Umidade',
    CASE
        WHEN l.temperatura BETWEEN 18 AND 25 AND l.umidade >= 90 THEN 'Risco de Míldio'
        WHEN l.temperatura > 25 AND l.umidade < 60 THEN 'Risco de Oídio'
        ELSE 'Estável'
    END AS 'Status da Lavoura'
FROM leitura_sensor l
JOIN sensor s ON s.id_sensor = l.fk_sensor
JOIN empresa e ON e.id_empresa = s.fk_empresa
ORDER BY l.dt_registro DESC;

-- 6) Histórico de alertas por vinícola

SELECT
    e.nome_empresa AS 'Vinícola',
    s.numero_serie AS 'Sensor',
    a.tipo_alerta AS 'Alerta',
    DATE_FORMAT(a.dt_alerta, '%d/%m/%Y %H:%i') AS 'Disparado em'
FROM alerta a
JOIN leitura_sensor l ON l.id_leitura = a.fk_leitura
JOIN sensor s ON s.id_sensor = l.fk_sensor
JOIN empresa e ON e.id_empresa = s.fk_empresa
ORDER BY a.dt_alerta DESC;

