const AWS = require('aws-sdk');//Import aws-sdk
const DB = AWS.DynamoDB();//Inizializzazione DB

exports.handler = async (event) =>{
    //Parametri per la selezione del DB
    const params={
        ProjectionExpression: "NomeGara, DataGara, ID",
        TableName: "Gare"
    };

    //Scan del DB
    const ListaGare= await DB.scan(params, function(err,data){
        if(err){
            throw err;
        }
    }).promise();

    //Risposta
    const response = {
        statusCode: 200,
        body: ListaGare
    };
    return response;
}