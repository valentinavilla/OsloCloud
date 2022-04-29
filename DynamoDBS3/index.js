const AWS = require('aws-sdk');
const parser = require('xml2js');
const DB = new AWS.DynamoDB();
const S3 = new AWS.S3;
exports.handler = async (event) => {
    //Estrazione nome bucket
    const bucket = event.Records[0].s3.bucket.name;

    //Estrazione key
    const keyRaw = JSON.stringify(event.Records[0].s3.object.key);
    const key_string = keyRaw.replace("+", " ");
    const key = JSON.parse(key_string);

    //Get XML
    const params = {
        Bucket: bucket,
        Key: key
    };
    const data = await S3.getObject(params).promise();
    const data_xml = data.Body.toString('utf-8');

    //Parse JSON
    const data_string = await parser.parseStringPromise(data_xml).then(function (result) {
        return JSON.stringify(result);
    })
        .catch(function (err) {
            throw err;
        });
    const data_json = JSON.parse(data_string);

    //Creazione item DynamoDB
    const nomeGara = "" + data_json.ResultList.Event[0].Name;
    const dataGara = "" + data_json.ResultList.Event[0].StartTime[0].Date;
    const OraInizioGara = "" + data_json.ResultList.Event[0].StartTime[0].Time;
    const OraFineGara = "" + data_json.ResultList.Event[0].EndTime[0].Time;

    var DynamoParams = {
        "TableName": 'Gare',

        Item: {
            "Nome": { S: nomeGara },
            "Data": { S: dataGara },
            "OraInizio": { S: OraInizioGara },
            "OraFine": { S: OraFineGara }
        }
    };

    //Inserimento in DynamoDB
    DB.putItem(DynamoParams, function (err, data) {
        if (err) throw err;
    });
};
