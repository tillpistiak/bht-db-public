const csv = require("csvtojson");
const fs = require("fs");

async function readCSV() {
  const values = await csv().fromFile("./data/cow2iso.csv");
  const preparedData = values
    .filter((value) => value.cow3 && value.iso3)
    .map((value) => {
      return {
        cow: value.cow3,
        iso: value.iso3,
      };
    });
  console.log(preparedData);
  return preparedData;
}

async function createStatement() {
  const values = await readCSV();
  let output = "INSERT ALL \n";
  for (let value of values) {
    output += `INTO tbl_iso_cow_mapping (cow, iso) VALUES ('${value.cow}', '${value.iso}') \n`;
  }
  output += "SELECT * FROM dual;";
  console.log(output);
  fs.writeFileSync("../db/dml/iso_cow_mapping.sql", output);
}

createStatement();
// readCSV();
