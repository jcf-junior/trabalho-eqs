const express = require("express");
const routes = require("./routes/index");

const app = express();
const port = process.env.PORT || 3333;

app.use(express.json());
app.use("/", routes);

app.use((error, req, res, next) => {
  if (error.type === "entity.parse.failed") {
    return res.status(400).json({ error: "JSON inválido" });
  }

  next(error);
});

app.listen(port, "0.0.0.0", () => {
  console.log(`API listening on port ${port}`);
});
