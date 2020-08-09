
var grant = require('grant').aws({
  config: require('./config'), session: {secret: 'grant'}
})

exports.handler = async (event) => {
  var {redirect, response} = await grant(event)
  return redirect || {
    statusCode: 200,
    headers: {'content-type': 'text/plain'},
    body: JSON.stringify(response, null, 2)
  }
}
