const AWS = require('aws-sdk');
const S3 = new AWS.S3;
const bucket_name = "risultati-gare";
const xml2js = require('xml2js');
var builder = new xml2js.Builder();
const uuid = require('uuid');

exports.handler = async (event) => {

    if (!event.queryStringParameters.name || !event.queryStringParameters.date || !event.queryStringParameters.email) {
        const response = {
            statusCode: 400,
            body: "Parametri mancanti"
        }
        return response;
    }

    const name = event.queryStringParameters.name;
    const date = event.queryStringParameters.date;
    const email = event.queryStringParameters.email;
    const token = uuid.v4();

    const file = {
        nameEvent: name,
        dateEvent: date,
        emailCreator: email,
        token: token
    }

    var file_xml = builder.buildObject(file)

    const params = {
        Bucket: bucket_name,
        Key: name + date + ".xml",
        Body: file_xml
    }

    await S3.putObject(params).promise();

    const response = {
        statusCode: 200,
        body: "Gara creata\n IDGara = " + name + date + "\n token = " + token
    }
    return response;
}