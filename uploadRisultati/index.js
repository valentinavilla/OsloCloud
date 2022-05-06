const AWS = require('aws-sdk');        //Import AWS
const parser = require('xml2js');      //Import parser XML->JSON
const S3 = new AWS.S3;                  //Inizializzazione variabile bucket
const DB = new AWS.DynamoDB();
const bucket_name = "risultati-gare";      //Nome bucket

exports.handler = async (event) => {
    //Dati ricevuti dalla richiesta POST (data_xml -> XML)
    const data_xml = event.body;
    const token = event.queryStringParameters.token

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
        FilterExpression: "t= :Token",
        ExpressionAttributeNames: {
            "#N": "Nome",
            "#D": "Data"
        },
        ExpressionAttributeValues: {
            ":Token": { S: "557872c9-b1bc-4c39-bde5-3a360c424576" }
        },
        ProjectionExpression: "#N, #D",
        TableName: "Gare",
    }

    const datiDB = await DB.scan(DBParams, function (err, data) {
        if (err) {
            console.log("Error", err);
        }
    }).promise();

    console.log(datiDB.Items)

    //Definizione dei parametri per upload
    const S3Params = {
        Bucket: bucket_name,
        Key: "a.xml",
        Body: data_xml
    };

    //Upload del file
    await S3.putObject(S3Params, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else console.log(data);           // successful response
    }).promise();

    //Risposta alla richiesta POST
    const response = {
        statusCode: 200,
        body: 'Gara registrata!'
    };
    return response;
};