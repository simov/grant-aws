
var Session = require('grant/lib/session')({
  secret: 'grant', store: require('./store')
})

exports.handler = async (event) => {
  var session = Session(event)

  var {response} = (await session.get()).grant
  await session.remove()

  return {
    statusCode: 200,
    headers: {
      'content-type': 'application/json',
    },
    body: JSON.stringify(response, null, 2)
  }
}
