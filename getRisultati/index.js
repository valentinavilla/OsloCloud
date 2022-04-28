const AWS = require('aws-sdk');//Import AWS
const parser = require("xml2js")//Import parser xml->json

const S3 = new AWS.S3;//Inizializzazione S3
const bucket_name = "risultati-gare";//Nome bucket

exports.handler = async (event) => {

    //Gestione caso parametri mancanti
    if (!event.queryStringParameters.name || !event.queryStringParameters.date) {
        const response = {
            statusCode: 400,
            body: "Parametri mancanti"
        }
        return response;
    }

    //Setup dei parametri di ricerca
    const name = event.queryStringParameters.name
    const date = event.queryStringParameters.date
    const data_key = name + date + ".xml"

    const params = {
        Bucket: bucket_name,
        Key: data_key
    };

    //Estrazione file richiesto
    const data = await S3.getObject(params).promise();
    const data_xml = data.Body.toString('utf-8')

    //Parse Xml->String
    const data_string = await parser.parseStringPromise(data_xml).then(function (result) {
        return JSON.stringify(result);
    })
        .catch(function (err) {
            throw err;
        });

    //Estrazione lista delle categorie
    const data_json = JSON.parse(data_string)
    const classlist = data_json.ResultList.ClassResult


    //Risposta 
    const response = {
        statusCode: 200,
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data_json)

    };
    return response;
};