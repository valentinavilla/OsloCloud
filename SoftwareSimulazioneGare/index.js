const fs = require('fs')//Import FileSystem (input/output da file locali)
const xml2js = require('xml2js')//Import Parser
const moment = require ('moment')//Import moment (Gestione date)

const parser = new xml2js.Parser();

const inputFile = process.argv[2]//nome del file passato all'invocazione codice
const minPassati = process.argv[3]//minuti trascorsi da inizio gara passato all'invocazione codice


SimulaXML(inputFile,minPassati);

async function SimulaXML (file,minutes) {
    const file_xml = fs.readFileSync(file, 'utf8');//Lettura file 

    //Parse xml->JSON
    const file_string = await parser.parseStringPromise(file_xml).then(function (result) {
        return JSON.stringify(result);
    });
    const file_json = JSON.parse(file_string);

    //Estrazione inizio evento
    startTime = file_json.ResultList.Event[0].StartTime[0].Time
    startDate = file_json.ResultList.Event[0].StartTime[0].Date
    const start_string = startDate + " " + startTime;
    const start = moment(start_string)//Inizio evento come data

    const now = start.add(minutes, 'm');//data di inizio + minuti passati

    var output_json = file_json;//File di output

    //Modifica del file di output
    output_json.ResultList.ClassResult.forEach(function (categoria) {//Per ogni categoria
        var i;
        for (i = categoria.PersonResult.length - 1; i >= 0; i -= 1) {//Ogni concorrente
            if (!categoria.PersonResult[i].Result[0].FinishTime) {//Se non c'è il valore di arrivo
                //Eliminare
                continue;
            }

            var finish = moment("" + categoria.PersonResult[i].Result[0].FinishTime)//Data dell'arrivo del partecipante

            if (finish.isAfter(now)) {//Se l'arrivo è dopo il momento selezionato in input
                //Eliminare
            }
        }
    })

    //Parse output in xml
    //var output_xml = 

    //Salva output 

}

