const csv = require("csvtojson");
const fs = require("fs");

async function readCSV() {
  const leaders = await csv({
    delimiter: [";"],
  }).fromFile("./data/leaders.csv");
  const preparedData = leaders.map((leader) => {
    return {
      name: leader.leader.replace("'", "`"),
      code: leader.idacr,
      begin: convertDate(leader.startdate),
      end: convertDate(leader.enddate),
    };
  });
  console.log(preparedData);
  return preparedData;
}

function convertDate(originalDate) {
  const date = new Date(originalDate);
  return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
}

async function createStatement() {
  const values = await readCSV();
  let output = "INSERT ALL \n";
  for (let index = 0; index < values.length; index++) {
    const leader = values[index];
    output += `INTO tbl_leaders (id, name, country_code, begin, end) VALUES (${index},'${leader.name}', '${leader.code}', (TO_DATE('${leader.begin}', 'yyyy/mm/dd')), (TO_DATE('${leader.end}', 'yyyy/mm/dd'))) \n`;
  }
  output += "SELECT * FROM dual;";
  console.log(output);
  fs.writeFileSync("../db/dml/leaders.sql", output);
}

createStatement();
