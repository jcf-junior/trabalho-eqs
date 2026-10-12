const pool = require("../config/db");

async function getHome(req, res) {
  res.json("Welcome to UniPVC Fake API!");
}

async function getAlunos(req, res) {
  try {
    const result = await pool.query("SELECT * FROM alunos;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getProfessores(req, res) {
  try {
    const result = await pool.query("SELECT * FROM professores;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getCursos(req, res) {
  try {
    const result = await pool.query("SELECT * FROM cursos;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getDisciplinas(req, res) {
  try {
    const result = await pool.query("SELECT * FROM disciplinas;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

module.exports = {
  getHome,
  getAlunos,
  getProfessores,
  getCursos,
  getDisciplinas,
};
