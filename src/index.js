const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3333;

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "app",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "postgres",
});

app.get("/data", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, username, age FROM users ORDER BY id",
    );

    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.get("/alunos", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM alunos;");

    res.json(result.rows);
  } catch (error) {
    console.error("Database query failed:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`API listening on port ${port}`);
});
