const csv = require("csvtojson");
const fs = require("fs");

async function readCSV() {
  const countries = await csv().fromFile("./data/countries.csv");
  const preparedCountries = countries
    .filter((country) => country.code)
    .map((country) => {
      const parsedGdp = parseFloat(country.val);
      return {
        name: country.name,
        code: country.code,
        gdp: isNaN(parsedGdp) ? 0 : parsedGdp,
      };
    });
  return preparedCountries;
}

async function createStatement() {
  const values = await readCSV();
  let output = "INSERT ALL \n";
  for (let value of values) {
    output += `INTO tbl_countries (CODE, NAME) VALUES ('${value.code}', '${value.name}') \n`;
  }
  output += "SELECT * FROM dual;";
  console.log(output);
  fs.writeFileSync("../db/dml/countries.sql", output);
}

createStatement();
