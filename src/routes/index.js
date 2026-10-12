const express = require("express");
const router = express.Router();
const apiController = require("../controllers/apiController");

router.get("/alunos/:id", apiController.getAlunoById);
router.get("/", apiController.getHome);
router.get("/alunos", apiController.getAlunos);
router.get("/professores", apiController.getProfessores);
router.get("/professores/:id", apiController.getProfessorById);
router.get("/cursos", apiController.getCursos);
router.get("/cursos/:id", apiController.getCursoById);
router.get("/disciplinas", apiController.getDisciplinas);
router.get("/disciplinas/:sigla", apiController.getDisciplinaBySigla);

module.exports = router;
