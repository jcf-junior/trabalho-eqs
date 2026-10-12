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

router.post("/professores", apiController.createProfessor);
router.post("/cursos", apiController.createCurso);
router.post("/disciplinas", apiController.createDisciplina);
router.post("/alunos", apiController.createAluno);
router.post("/alunos/:id/disciplinas", apiController.createInscricao);

router.delete("/professores/:id", apiController.deleteProfessor);
router.delete("/cursos/:id", apiController.deleteCurso);
router.delete("/disciplinas/:sigla", apiController.deleteDisciplina);
router.delete("/alunos/:id", apiController.deleteAluno);
router.delete("/alunos/:id/disciplinas/:sigla", apiController.deleteInscricao);

module.exports = router;
