var moment = require ('moment')

const startTime = "10:00:00+01:00"
const startDate = "2011-07-30"

const start_string = startDate + " "+ startTime.split('+')[0];

const start = moment(start_string, "YYYY-MM-DD hh:mm:ss");

const minInput = 10

const now = start.add(minInput, 'm');

const finish = moment("2011-07-30T10:33:21+01:00")
console.log(start)
console.log(finish)

