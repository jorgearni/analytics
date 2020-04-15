//importing required libraries
const puppeteer = require('puppeteer');
const csv = require('csv-parser')
const fs = require('fs')
const createCsvWriter = require('csv-writer').createObjectCsvWriter;

//defining output / input file names
const outputFileName = 'output.csv';
const variableInputFileName = 'variables.csv';
const pagesInputFileName = 'pages.csv';

//define output file and its headers
const csvWriter = createCsvWriter({
  path: outputFileName,
  header: [
        {id: 'url', title: 'URL'},
        {id: 'variable', title: 'VARIABLE'},
        {id: 'value', title: 'VALUE'}
    ]
});

//define arrays to store variables / pages (url) / output
const variables = [];
const pages = [];
const outputData = [];

//Reading variables file and storing in variables array
fs.createReadStream(variableInputFileName)
  .pipe(csv())
  .on('data', (row) => variables.push(row["variables"]));

//Reading pages file and storing in pages array
fs.createReadStream(pagesInputFileName)
  .pipe(csv())
  .on('data', (row) => pages.push(row["pages"]));

//loading browser
(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  //iterating on pages
  for (const url of pages) {
    console.log("Iterating on page "+url);
    await page.goto(url);

    //iterating on variables and getting their value
    for (const variable of variables) {
      var variableValue = await page.evaluate((x) => {
        return eval(x);
      }, variable);

      //storing output in array
      outputData.push(
        {
          url: url,
          variable: variable,
          value: variableValue
        }
      );
    }
  }

  //writing outputArray to output file
  csvWriter.writeRecords(outputData).then(() => console.log("Output file was generated"));

  //close browser
  await browser.close();
})();
