
var qs = require('qs')

exports.handler = async (event) => ({
  statusCode: 200,
  headers: {
    'content-type': 'application/json',
  },
  body: JSON.stringify(qs.parse(event.queryStringParameters), null, 2)
})
