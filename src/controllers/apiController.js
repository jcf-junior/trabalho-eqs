const pool = require("../config/db");

const UNIQUE_VIOLATION = "23505";
const FOREIGN_KEY_VIOLATION = "23503";
const INVALID_TEXT_REPRESENTATION = "22P02";
const NUMERIC_VALUE_OUT_OF_RANGE = "22003";
const VALUE_TOO_LONG = "22001";

function handleInsertError(res, error) {
  if (error.code === UNIQUE_VIOLATION) {
    return res.status(409).json({ error: "Registo já existe" });
  }

  if (error.code === FOREIGN_KEY_VIOLATION) {
    return res.status(400).json({ error: "Referência inválida" });
  }

  if (
    error.code === INVALID_TEXT_REPRESENTATION ||
    error.code === NUMERIC_VALUE_OUT_OF_RANGE ||
    error.code === VALUE_TOO_LONG
  ) {
    return res.status(400).json({ error: "Dados inválidos" });
  }

  console.error("Database query failed:", error);
  res.status(500).json({ error: "Internal server error" });
}

function handleDeleteError(res, error) {
  if (error.code === FOREIGN_KEY_VIOLATION) {
    return res
      .status(409)
      .json({ error: "Registo em uso por outros registos" });
  }

  if (
    error.code === INVALID_TEXT_REPRESENTATION ||
    error.code === NUMERIC_VALUE_OUT_OF_RANGE
  ) {
    return res.status(400).json({ error: "Dados inválidos" });
  }

  console.error("Database query failed:", error);
  res.status(500).json({ error: "Internal server error" });
}

async function runInTransaction(work) {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");
    const result = await work(client);
    await client.query("COMMIT");
    return result;
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
}

async function getHome(req, res) {
  console.log("Incoming request from:", req.ip);
  res.json("Welcome to UniPVC Fake API!");
}

async function getAlunos(req, res) {
  console.log("Incoming request from:", req.ip);
  try {
    const result = await pool.query("SELECT * FROM alunos;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getAlunoById(req, res) {
  console.log("Incoming request from:", req.ip);

  try {
    const { id } = req.params;

    const result = await pool.query("SELECT * FROM alunos WHERE id = $1;", [
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Aluno não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getProfessores(req, res) {
  console.log("Incoming request from:", req.ip);
  try {
    const result = await pool.query("SELECT * FROM professores;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getProfessorById(req, res) {
  console.log("Incoming request from:", req.ip);

  try {
    const { id } = req.params;

    const result = await pool.query(
      "SELECT * FROM professores WHERE id = $1;",
      [id],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Professor não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getCursos(req, res) {
  console.log("Incoming request from:", req.ip);
  try {
    const result = await pool.query("SELECT * FROM cursos;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getCursoById(req, res) {
  console.log("Incoming request from:", req.ip);

  try {
    const { id } = req.params;

    const result = await pool.query("SELECT * FROM cursos WHERE id = $1;", [
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Curso não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getDisciplinas(req, res) {
  console.log("Incoming request from:", req.ip);
  try {
    const result = await pool.query("SELECT * FROM disciplinas;");
    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function getDisciplinaBySigla(req, res) {
  console.log("Incoming request from:", req.ip);

  try {
    const { sigla } = req.params;

    const result = await pool.query(
      "SELECT * FROM disciplinas WHERE sigla = $1;",
      [sigla],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Disciplina não encontrada" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

async function createProfessor(req, res) {
  console.log("Incoming request from:", req.ip);

  const { nome, habilitacoes, email } = req.body ?? {};

  if (!nome || !habilitacoes || !email) {
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: nome, habilitacoes, email" });
  }

  try {
    const result = await pool.query(
      "INSERT INTO professores (nome, habilitacoes, email) VALUES ($1, $2, $3) RETURNING *;",
      [nome, habilitacoes, email],
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    handleInsertError(res, error);
  }
}

async function createCurso(req, res) {
  console.log("Incoming request from:", req.ip);

  const { nome, sigla, professor_coordenador_id, tipo } = req.body ?? {};

  if (!nome || !sigla || !professor_coordenador_id || !tipo) {
    return res.status(400).json({
      error: "Campos obrigatórios: nome, sigla, professor_coordenador_id, tipo",
    });
  }

  try {
    const result = await pool.query(
      "INSERT INTO cursos (nome, sigla, professor_coordenador_id, tipo) VALUES ($1, $2, $3, $4) RETURNING *;",
      [nome, sigla, professor_coordenador_id, tipo],
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    handleInsertError(res, error);
  }
}

async function createDisciplina(req, res) {
  console.log("Incoming request from:", req.ip);

  const { sigla, nome, professor_responsavel_id } = req.body ?? {};

  if (!sigla || !nome || !professor_responsavel_id) {
    return res.status(400).json({
      error: "Campos obrigatórios: sigla, nome, professor_responsavel_id",
    });
  }

  try {
    const result = await pool.query(
      "INSERT INTO disciplinas (sigla, nome, professor_responsavel_id) VALUES ($1, $2, $3) RETURNING *;",
      [sigla, nome, professor_responsavel_id],
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    handleInsertError(res, error);
  }
}

async function createAluno(req, res) {
  console.log("Incoming request from:", req.ip);

  const { nome, curso_id, email } = req.body ?? {};

  if (!nome || !curso_id || !email) {
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: nome, curso_id, email" });
  }

  try {
    const result = await pool.query(
      "INSERT INTO alunos (nome, curso_id, email) VALUES ($1, $2, $3) RETURNING *;",
      [nome, curso_id, email],
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    handleInsertError(res, error);
  }
}

async function createInscricao(req, res) {
  console.log("Incoming request from:", req.ip);

  const { id } = req.params;
  const { sigla } = req.body ?? {};

  if (!sigla) {
    return res.status(400).json({ error: "Campos obrigatórios: sigla" });
  }

  try {
    const result = await pool.query(
      "INSERT INTO aluno_disciplinas (aluno_id, disciplina_sigla) VALUES ($1, $2) RETURNING *;",
      [id, sigla],
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    handleInsertError(res, error);
  }
}

async function deleteProfessor(req, res) {
  console.log("Incoming request from:", req.ip);

  const { id } = req.params;

  try {
    const result = await pool.query("DELETE FROM professores WHERE id = $1;", [
      id,
    ]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Professor não encontrado" });
    }

    res.sendStatus(204);
  } catch (error) {
    handleDeleteError(res, error);
  }
}

async function deleteCurso(req, res) {
  console.log("Incoming request from:", req.ip);

  const { id } = req.params;

  try {
    const result = await pool.query("DELETE FROM cursos WHERE id = $1;", [id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Curso não encontrado" });
    }

    res.sendStatus(204);
  } catch (error) {
    handleDeleteError(res, error);
  }
}

async function deleteDisciplina(req, res) {
  console.log("Incoming request from:", req.ip);

  const { sigla } = req.params;

  try {
    const result = await runInTransaction(async (client) => {
      await client.query(
        "DELETE FROM aluno_disciplinas WHERE disciplina_sigla = $1;",
        [sigla],
      );
      return client.query("DELETE FROM disciplinas WHERE sigla = $1;", [sigla]);
    });

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Disciplina não encontrada" });
    }

    res.sendStatus(204);
  } catch (error) {
    handleDeleteError(res, error);
  }
}

async function deleteAluno(req, res) {
  console.log("Incoming request from:", req.ip);

  const { id } = req.params;

  try {
    const result = await runInTransaction(async (client) => {
      await client.query("DELETE FROM aluno_disciplinas WHERE aluno_id = $1;", [
        id,
      ]);
      return client.query("DELETE FROM alunos WHERE id = $1;", [id]);
    });

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Aluno não encontrado" });
    }

    res.sendStatus(204);
  } catch (error) {
    handleDeleteError(res, error);
  }
}

async function deleteInscricao(req, res) {
  console.log("Incoming request from:", req.ip);

  const { id, sigla } = req.params;

  try {
    const result = await pool.query(
      "DELETE FROM aluno_disciplinas WHERE aluno_id = $1 AND disciplina_sigla = $2;",
      [id, sigla],
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Inscrição não encontrada" });
    }

    res.sendStatus(204);
  } catch (error) {
    handleDeleteError(res, error);
  }
}

module.exports = {
  getHome,
  getAlunos,
  getAlunoById,
  getProfessores,
  getProfessorById,
  getCursos,
  getCursoById,
  getDisciplinas,
  getDisciplinaBySigla,
  createProfessor,
  createCurso,
  createDisciplina,
  createAluno,
  createInscricao,
  deleteProfessor,
  deleteCurso,
  deleteDisciplina,
  deleteAluno,
  deleteInscricao,
};
