const oracledb = require("oracledb");
const app = require("express")();
const cors = require("cors");
const fs = require("fs");

if (process.env.USE_DB) {
  oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
  oracledb.initOracleClient({ libDir: process.env.ORACLE_CLIENT_PATH });
  process.on("SIGINT", () => killProcess());
}

app.use(
  cors({
    origin: ["http://localhost:8000", "http://127.0.0.1:5500"],
  })
);

async function query(question_id) {
  let connection;

  try {
    connection = await oracledb.getConnection({
      user: process.env.ORACLE_USER,
      password: process.env.ORACLE_PASSWORD,
      connectionString: `
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)
        (HOST = localhost)
        (PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SID = rispdb1)
        )
      )
      `,
    });
    const result = await connection.execute(
      `select * from S87682.VW_FRAGE_${question_id}`
    );
    fs.writeFileSync(
      `./cache/FRAGE_${question_id}.json`,
      JSON.stringify(result)
    );
    return result;
  } catch (err) {
    console.error(err);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
}

function loadCache(question_id) {
  const data = fs.readFileSync(`./cache/FRAGE_${question_id}.json`, "utf-8");
  return JSON.parse(data);
}

app.get("/data", async (req, res) => {
  const question_id = Number.parseInt(req.query.question);
  if (!Number.isNaN(question_id) && question_id > 0 && question_id < 13) {
    const result = process.env.USE_DB
      ? await query(question_id)
      : loadCache(question_id);
    res.json(result);
  } else {
    res.sendStatus(500);
  }
});

const port = process.env.PORT || 8004;
app.listen(port, () => console.log(`app listening on ${port}`));
