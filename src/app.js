const express = require("express");
const routes = require("./routes/index");

const app = express();
const port = process.env.PORT || 3333;

app.use("/", routes);

app.listen(port, "0.0.0.0", () => {
  console.log(`API listening on port ${port}`);
});
