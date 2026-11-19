var express = require('express');
var router = express.Router();

var debugController = require('../controllers/debugController');

router.get('/usuarios', function (req, res) { debugController.usuarios(req, res); });
router.get('/empresas', function (req, res) { debugController.empresas(req, res); });
router.get('/vinhedos', function (req, res) { debugController.vinhedos(req, res); });
router.get('/leituras', function (req, res) { debugController.leituras(req, res); });

module.exports = router;
