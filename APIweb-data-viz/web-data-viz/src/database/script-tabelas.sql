DROP DATABASE IF EXISTS SenseNoir;
CREATE DATABASE SenseNoir;
USE SenseNoir;

-- ===================================================================================================================================
-- CRIAÇÃO DAS TABELAS
-- ===================================================================================================================================

CREATE TABLE empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome_empresa VARCHAR(70) NOT NULL,
    cnpj_empresa CHAR(18) NOT NULL UNIQUE,
    codigo_cadastro VARCHAR(20) NOT NULL UNIQUE,
    area_hectares DECIMAL(6,2),
    dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    fk_empresa INT NOT NULL,
    nome_usuario VARCHAR(70) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf CHAR(11) UNIQUE,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    dt_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ct_fk_usuario_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE vinhedo (
    id_vinhedo INT PRIMARY KEY AUTO_INCREMENT,
    fk_empresa INT NOT NULL,
    nome_vinhedo VARCHAR(70) NOT NULL,
    cidade VARCHAR(60),
    uf CHAR(2),
    CONSTRAINT ct_fk_vinhedo_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE setor (
    id_setor INT PRIMARY KEY AUTO_INCREMENT,
    fk_vinhedo INT NOT NULL,
    nome_setor VARCHAR(50) NOT NULL,
    CONSTRAINT ct_fk_setor_vinhedo FOREIGN KEY (fk_vinhedo) REFERENCES vinhedo(id_vinhedo)
);

CREATE TABLE sensor (
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    numero_serie VARCHAR(20) NOT NULL UNIQUE,
    fk_setor INT NOT NULL,
    dt_instalacao DATE,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT ct_fk_sensor_setor FOREIGN KEY (fk_setor) REFERENCES setor(id_setor)
);

CREATE TABLE leitura_sensor (
    id_leitura INT PRIMARY KEY AUTO_INCREMENT,
    fk_sensor INT NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    umidade DECIMAL(5,2) NOT NULL,
    dt_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ct_fk_leitura_sensor FOREIGN KEY (fk_sensor) REFERENCES sensor(id_sensor),
    CONSTRAINT ct_umidade CHECK (umidade BETWEEN 0 AND 100)
);

CREATE TABLE alerta (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    fk_leitura INT NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    tipo_alerta VARCHAR(50) NOT NULL,
    resolvido TINYINT(1) NOT NULL DEFAULT 0,
    dt_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ct_fk_alerta_leitura FOREIGN KEY (fk_leitura) REFERENCES leitura_sensor(id_leitura),
    CONSTRAINT ct_nivel CHECK (nivel IN ('Atenção', 'Crítico'))
);

CREATE TABLE aviso (
    id_aviso INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    fk_usuario INT NOT NULL,
    dt_publicacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ct_fk_aviso_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario)
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
(4, 'João Vitor', 'joao.vitor@vinhedosdealtitude.com', '12346658909', 'Jv!alt26', 1),
(4, 'Camila Duarte', 'camila.duarte@vinhedosdealtitude.com', '21345678909', 'Cd_alt09', 1),
(6, 'Bruno Salles', 'bruno.salles@rotadasuvas.com', '12999890900', 'Bs#rota26', 1);

INSERT INTO vinhedo (fk_empresa, nome_vinhedo, cidade, uf) VALUES
(1, 'Vinhedo Vale Verde', 'Bento Gonçalves', 'RS'),
(2, 'Vinhedo Quinta do Sol', 'Garibaldi', 'RS'),
(3, 'Vinhedo Serrana', 'Farroupilha', 'RS'),
(4, 'Vinhedo Aurora', 'São Joaquim', 'SC'),
(5, 'Vinhedo Dom Bosco', 'Flores da Cunha', 'RS'),
(6, 'Vinhedo Rota das Uvas', 'Caxias do Sul', 'RS'),
(7, 'Vinhedo Pampas', 'Santana do Livramento', 'RS');

INSERT INTO setor (fk_vinhedo, nome_setor) VALUES
(1, 'Setor 1'), (1, 'Setor 2'), (1, 'Setor 3'), (1, 'Setor 4'),
(2, 'Setor 1'), (2, 'Setor 2'), (2, 'Setor 3'),
(3, 'Setor 1'), (3, 'Setor 2'),
(4, 'Setor 1'), (4, 'Setor 2'), (4, 'Setor 3'), (4, 'Setor 4'), (4, 'Setor 5'), (4, 'Setor 6'),
(5, 'Setor 1'), (5, 'Setor 2'),
(6, 'Setor 1'), (6, 'Setor 2'), (6, 'Setor 3'),
(7, 'Setor 1'), (7, 'Setor 2');

INSERT INTO sensor (numero_serie, fk_setor, dt_instalacao, ativo) VALUES
('DHT-1001', 1, '2026-03-10', 1),
('DHT-1002', 2, '2026-03-10', 1),
('DHT-1003', 3, '2026-03-12', 1),
('DHT-1004', 4, '2026-03-12', 1),
('DHT-2001', 5, '2026-02-20', 1),
('DHT-2002', 6, '2026-02-20', 1),
('DHT-2003', 7, '2026-02-21', 1),
('DHT-3001', 8, '2026-01-15', 0),
('DHT-3002', 9, '2026-01-15', 0),
('DHT-4001', 10, '2026-04-01', 1),
('DHT-4002', 11, '2026-04-01', 1),
('DHT-4003', 12, '2026-04-02', 1),
('DHT-4004', 13, '2026-04-02', 1),
('DHT-4005', 14, '2026-04-03', 1),
('DHT-4006', 15, '2026-04-03', 1),
('DHT-5001', 16, '2025-11-05', 0),
('DHT-5002', 17, '2025-11-05', 0),
('DHT-6001', 18, '2026-05-18', 1),
('DHT-6002', 19, '2026-05-18', 1),
('DHT-6003', 20, '2026-05-19', 1),
('DHT-7001', 21, '2025-09-30', 0),
('DHT-7002', 22, '2025-09-30', 0);

-- as datas usam NOW(), então rode o script de novo antes de apresentar para a dash mostrar as últimas 24 h
INSERT INTO leitura_sensor (fk_sensor, temperatura, umidade, dt_registro) VALUES
(10, 22.00, 84, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(10, 22.80, 85, DATE_SUB(NOW(), INTERVAL 960 MINUTE)),
(10, 24.10, 87, DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
(10, 24.60, 88, DATE_SUB(NOW(), INTERVAL 300 MINUTE)),
(10, 23.90, 86, DATE_SUB(NOW(), INTERVAL 200 MINUTE)),
(10, 23.40, 86, DATE_SUB(NOW(), INTERVAL 120 MINUTE)),
(10, 23.20, 85, DATE_SUB(NOW(), INTERVAL 45 MINUTE)),
(10, 23.40, 86, DATE_SUB(NOW(), INTERVAL 5 MINUTE)),
(11, 21.50, 68, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(11, 22.40, 70, DATE_SUB(NOW(), INTERVAL 960 MINUTE)),
(11, 23.80, 72, DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
(11, 24.50, 74, DATE_SUB(NOW(), INTERVAL 300 MINUTE)),
(11, 24.80, 76, DATE_SUB(NOW(), INTERVAL 200 MINUTE)),
(11, 30.80, 91, DATE_SUB(NOW(), INTERVAL 120 MINUTE)),
(11, 31.00, 92, DATE_SUB(NOW(), INTERVAL 45 MINUTE)),
(11, 31.20, 92, DATE_SUB(NOW(), INTERVAL 5 MINUTE)),
(12, 20.50, 70, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(12, 21.30, 72, DATE_SUB(NOW(), INTERVAL 960 MINUTE)),
(12, 22.60, 74, DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
(12, 22.90, 75, DATE_SUB(NOW(), INTERVAL 300 MINUTE)),
(12, 22.40, 74, DATE_SUB(NOW(), INTERVAL 200 MINUTE)),
(12, 22.10, 74, DATE_SUB(NOW(), INTERVAL 120 MINUTE)),
(12, 21.90, 73, DATE_SUB(NOW(), INTERVAL 45 MINUTE)),
(12, 22.10, 74, DATE_SUB(NOW(), INTERVAL 5 MINUTE)),
(13, 20.10, 70, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(13, 20.80, 71, DATE_SUB(NOW(), INTERVAL 1200 MINUTE)),
(13, 21.30, 72, DATE_SUB(NOW(), INTERVAL 1000 MINUTE)),
(14, 19.80, 66, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(14, 20.50, 68, DATE_SUB(NOW(), INTERVAL 960 MINUTE)),
(14, 21.90, 69, DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
(14, 22.30, 70, DATE_SUB(NOW(), INTERVAL 300 MINUTE)),
(14, 22.00, 71, DATE_SUB(NOW(), INTERVAL 200 MINUTE)),
(14, 21.70, 70, DATE_SUB(NOW(), INTERVAL 120 MINUTE)),
(14, 21.40, 69, DATE_SUB(NOW(), INTERVAL 45 MINUTE)),
(14, 21.20, 69, DATE_SUB(NOW(), INTERVAL 5 MINUTE)),
(15, 19.20, 64, DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(15, 20.10, 65, DATE_SUB(NOW(), INTERVAL 960 MINUTE)),
(15, 21.20, 67, DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
(15, 21.80, 68, DATE_SUB(NOW(), INTERVAL 300 MINUTE)),
(15, 21.50, 68, DATE_SUB(NOW(), INTERVAL 200 MINUTE)),
(15, 21.00, 67, DATE_SUB(NOW(), INTERVAL 120 MINUTE)),
(15, 20.60, 66, DATE_SUB(NOW(), INTERVAL 45 MINUTE)),
(15, 20.40, 66, DATE_SUB(NOW(), INTERVAL 5 MINUTE));

INSERT INTO alerta (fk_leitura, nivel, tipo_alerta, dt_alerta) VALUES
(1, 'Atenção', 'Umidade fora da faixa', DATE_SUB(NOW(), INTERVAL 1320 MINUTE)),
(14, 'Crítico', 'Temperatura e umidade fora da faixa', DATE_SUB(NOW(), INTERVAL 120 MINUTE));

-- ===================================================================================================================================
-- VIEWS
-- Ideal: 15 a 25 °C e 60 a 80% | Atenção: fora do ideal | Crítico: < 10 ou > 30 °C, < 50 ou > 90%
-- ===================================================================================================================================

CREATE VIEW vw_leituras AS
SELECT
    v.fk_empresa AS id_empresa,
    v.id_vinhedo,
    v.nome_vinhedo,
    st.id_setor,
    st.nome_setor,
    s.id_sensor,
    s.numero_serie,
    l.id_leitura,
    l.temperatura,
    l.umidade,
    l.dt_registro,
    CASE
        WHEN l.temperatura < 10 OR l.temperatura > 30 OR l.umidade < 50 OR l.umidade > 90 THEN 'Crítico'
        WHEN l.temperatura NOT BETWEEN 15 AND 25 OR l.umidade NOT BETWEEN 60 AND 80 THEN 'Atenção'
        ELSE 'Ideal'
    END AS status
FROM leitura_sensor l
    JOIN sensor s ON s.id_sensor = l.fk_sensor
    JOIN setor st ON st.id_setor = s.fk_setor
    JOIN vinhedo v ON v.id_vinhedo = st.fk_vinhedo;

CREATE VIEW vw_leituras_recentes AS
SELECT * FROM vw_leituras
WHERE dt_registro >= NOW() - INTERVAL 1 HOUR;

CREATE VIEW vw_setores AS
SELECT
    v.fk_empresa AS id_empresa,
    v.id_vinhedo,
    v.nome_vinhedo,
    st.id_setor,
    st.nome_setor,
    COUNT(DISTINCT s.id_sensor) AS total_sensores,
    COUNT(DISTINCT r.id_sensor) AS sensores_enviando,
    ROUND(AVG(r.temperatura), 1) AS temperatura_media,
    ROUND(AVG(r.umidade), 0) AS umidade_media,
    MAX(r.dt_registro) AS ultima_leitura,
    CASE
        WHEN COUNT(r.id_leitura) = 0 THEN 'Sem leitura'
        WHEN AVG(r.temperatura) < 10 OR AVG(r.temperatura) > 30 OR AVG(r.umidade) < 50 OR AVG(r.umidade) > 90 THEN 'Crítico'
        WHEN AVG(r.temperatura) NOT BETWEEN 15 AND 25 OR AVG(r.umidade) NOT BETWEEN 60 AND 80 THEN 'Atenção'
        ELSE 'Ideal'
    END AS situacao
FROM setor st
    JOIN vinhedo v ON v.id_vinhedo = st.fk_vinhedo
    LEFT JOIN sensor s ON s.fk_setor = st.id_setor
    LEFT JOIN vw_leituras_recentes r ON r.id_sensor = s.id_sensor
GROUP BY v.fk_empresa, v.id_vinhedo, v.nome_vinhedo, st.id_setor, st.nome_setor;

CREATE VIEW vw_resumo_vinhedo AS
SELECT
    id_empresa,
    id_vinhedo,
    nome_vinhedo,
    COUNT(*) AS total_setores,
    SUM(CASE WHEN situacao = 'Ideal' THEN 1 ELSE 0 END) AS setores_ideais,
    SUM(CASE WHEN situacao = 'Atenção' THEN 1 ELSE 0 END) AS setores_atencao,
    SUM(CASE WHEN situacao = 'Crítico' THEN 1 ELSE 0 END) AS setores_criticos,
    SUM(CASE WHEN situacao = 'Sem leitura' THEN 1 ELSE 0 END) AS setores_sem_leitura,
    SUM(total_sensores) AS total_sensores,
    SUM(sensores_enviando) AS sensores_enviando,
    MAX(ultima_leitura) AS ultima_atualizacao
FROM vw_setores
GROUP BY id_empresa, id_vinhedo, nome_vinhedo;

CREATE VIEW vw_media_hora AS
SELECT
    id_vinhedo,
    DATE_FORMAT(dt_registro, '%Y-%m-%d %H:00:00') AS hora_completa,
    DATE_FORMAT(dt_registro, '%H:00') AS hora,
    ROUND(AVG(temperatura), 1) AS temperatura_media,
    ROUND(AVG(umidade), 1) AS umidade_media
FROM vw_leituras
WHERE dt_registro >= NOW() - INTERVAL 24 HOUR
GROUP BY id_vinhedo, DATE_FORMAT(dt_registro, '%Y-%m-%d %H:00:00'), DATE_FORMAT(dt_registro, '%H:00');

CREATE VIEW vw_alertas AS
SELECT
    a.id_alerta,
    v.fk_empresa AS id_empresa,
    v.id_vinhedo,
    v.nome_vinhedo,
    st.nome_setor,
    s.numero_serie,
    a.nivel,
    a.tipo_alerta,
    a.resolvido,
    a.dt_alerta
FROM alerta a
    JOIN leitura_sensor l ON l.id_leitura = a.fk_leitura
    JOIN sensor s ON s.id_sensor = l.fk_sensor
    JOIN setor st ON st.id_setor = s.fk_setor
    JOIN vinhedo v ON v.id_vinhedo = st.fk_vinhedo;

-- ===================================================================================================================================
-- SELECTS DA DASHBOARD (id 4 = Vinhedo Aurora, sensor 11 = DHT-4002 do Setor 2)
-- ===================================================================================================================================

-- 1) Seletor de vinhedos da empresa do usuário
SELECT id_vinhedo, nome_vinhedo FROM vinhedo WHERE fk_empresa = 4;

-- 2) Cards do topo
SELECT * FROM vw_resumo_vinhedo WHERE id_vinhedo = 4;

-- 3) Quais setores estão em Atenção / Crítico
SELECT nome_setor, situacao FROM vw_setores
WHERE id_vinhedo = 4 AND situacao IN ('Atenção', 'Crítico');

-- 4) Gráficos de temperatura e umidade (últimas 24 h)
SELECT hora, temperatura_media, umidade_media FROM vw_media_hora
WHERE id_vinhedo = 4
ORDER BY hora_completa;

-- 5) Tabela Setores monitorados
SELECT
    nome_setor AS 'Setor',
    CONCAT(temperatura_media, ' °C') AS 'Temperatura',
    CONCAT(umidade_media, '%') AS 'Umidade',
    situacao AS 'Situação',
    DATE_FORMAT(ultima_leitura, '%d/%m · %H:%i') AS 'Última leitura'
FROM vw_setores
WHERE id_vinhedo = 4
ORDER BY FIELD(situacao, 'Crítico', 'Atenção', 'Ideal', 'Sem leitura');

-- 6) Selo de alertas
SELECT COUNT(*) AS alertas_abertos FROM vw_alertas WHERE id_vinhedo = 4 AND resolvido = 0;

-- 7) Página do sensor: valores atuais
SELECT numero_serie, nome_setor, nome_vinhedo, temperatura, umidade, status, dt_registro
FROM vw_leituras
WHERE id_sensor = 11
ORDER BY dt_registro DESC
LIMIT 1;

-- 8) Página do sensor: última condição normal e há quantos minutos está fora da faixa
SELECT
    MAX(dt_registro) AS ultima_condicao_normal,
    TIMESTAMPDIFF(MINUTE, MAX(dt_registro), NOW()) AS minutos_fora_da_faixa
FROM vw_leituras
WHERE id_sensor = 11 AND status = 'Ideal';

-- 9) Página do sensor: últimas leituras
SELECT DATE_FORMAT(dt_registro, '%H:%i') AS 'Horário', temperatura, umidade, status
FROM vw_leituras
WHERE id_sensor = 11
ORDER BY dt_registro DESC
LIMIT 4;

-- ===================================================================================================================================
-- CADASTRO SEM ERRO DE FK: o INSERT ... SELECT acha o id sozinho pelo código da empresa / número de série
-- ===================================================================================================================================

INSERT INTO usuario (fk_empresa, nome_usuario, email, senha, cpf)
SELECT id_empresa, 'Teste da API', 'teste@api.com', 'senha123', '11122233344'
FROM empresa
WHERE codigo_cadastro = 'VDA-2026-04';

INSERT INTO leitura_sensor (fk_sensor, temperatura, umidade)
SELECT id_sensor, 23.50, 65
FROM sensor
WHERE numero_serie = 'DHT-4002';
