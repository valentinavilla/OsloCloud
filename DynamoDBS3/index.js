const AWS = require('aws-sdk')
const DB = AWS.DynamoDB.DocumentClient;
const S3 = new AWS.S3
exports.handler = async (event) => {
    
    const bucket=event.Records[0].s3.bucket.name
    const keyRaw=JSON.stringify(event.Records[0].s3.object.key)

    const key_string= keyRaw.replace("+", " ");
    const key=JSON.parse(key_string);
    
    //Get XML
    const params={
        Bucket: bucket,
        Key: key
    }
    const data = await S3.getObject(params).promise();
    const data_xml = data.Body.toString('utf-8')
    
    //Parse JSON
    const data_string = await parser.parseStringPromise(data_xml).then(function (result) {
        return JSON.stringify(result);
    })
    .catch(function (err) {
        throw err;
    });

    const data_json= JSON.parse(data_string)
    
    console.log(data_xml)
    
};
