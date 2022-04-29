const fs = require('fs')
const xml2js = require('xml2js')
const moment = require ('moment')

const parser = new xml2js.Parser();

const inputFile = process.argv[2]
const minPassati = process.argv[3]


SimulaXML(inputFile,minPassati);

async function SimulaXML (file,minutes) {
    const file_xml = fs.readFileSync(file, 'utf8');

    const file_string = await parser.parseStringPromise(file_xml).then(function (result) {
        return JSON.stringify(result);
    });
    const file_json = JSON.parse(file_string);

    startTime = file_json.ResultList.Event[0].StartTime[0].Time
    startDate = file_json.ResultList.Event[0].StartTime[0].Date
    const start_string = startDate + " " + startTime;
    const start = moment(start_string)

    const now = start.add(minutes, 'm');

    var output_json = file_json;

    output_json.ResultList.ClassResult.forEach(function (categoria) {
        var i;
        for (i = categoria.PersonResult.length - 1; i >= 0; i -= 1) {
            if (!categoria.PersonResult[i].Result[0].FinishTime) {
                //Eliminare
                continue;
            }

            var finish = moment("" + categoria.PersonResult[i].Result[0].FinishTime)

            if (finish.isAfter(now)) {
                //Eliminare

            }
        }
    })
}

