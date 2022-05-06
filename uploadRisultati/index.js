const AWS = require('aws-sdk');        //Import AWS
const parser = require('xml2js');      //Import parser XML->JSON
const S3 = new AWS.S3;                  //Inizializzazione variabile bucket
const DB = new AWS.DynamoDB();
const bucket_name = "risultati-gare";      //Nome bucket

exports.handler = async (event) => {

    console.log(event)
    if (!event.queryStringParameters) {
        const response = {
            statusCode: 400,
            body: 'Parametro token mancante'
        };
        return response;
    }
    if (!event.queryStringParameters.token) {
        const response = {
            statusCode: 400,
            body: 'Parametro token mancante'
        };
        return response;
    }

    //Dati ricevuti dalla richiesta POST (data_xml -> XML)
    const data_xml = event.body;
    const token = event.queryStringParameters.token;

    //Dati XML convertiti in string (data_string -> String)
    const data_string = await parser.parseStringPromise(data_xml).then(function (result) {
        return JSON.stringify(result);
    })
        .catch(function (err) {
            throw err;
        });

    //Dati String convertiti in JSON (data_json ->JSON)
    const data_json = JSON.parse(data_string);

    //Recupero gara da DB
    const DBParams = {
        ExpressionAttributeValues: {
            ":id": { S: token }
        },
        FilterExpression: "TokenGara= :id",
        ProjectionExpression: "NomeGara, DataGara",
        TableName: "Gare",
    }

    const datiDB = await DB.scan(DBParams, function (err, data) {
        if (err) {
            console.log("Error", err);
        }
    }).promise();

    if (datiDB.Items.length == 0) {
        const response = {
            statusCode: 400,
            body: 'Il codice non corrisponde a nessuna gara'
        };
        return response;
    }

    const nomeGara = datiDB.Items[0].NomeGara.S;
    const dataGara = datiDB.Items[0].DataGara.S;

    //Definizione dei parametri per upload
    const S3Params = {
        Bucket: bucket_name,
        Key: nomeGara + dataGara + ".xml",
        Body: data_xml
    };

    //Upload del file
    await S3.putObject(S3Params, function (err, data) {
        if (err) console.log(err, err.stack);
    }).promise();

    //Risposta alla richiesta POST
    const response = {
        statusCode: 200,
        body: 'Gara registrata!'
    };
    return response;
};