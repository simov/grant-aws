
var grant = require('grant').aws({
  config: require('./config'),
  session: {secret: 'grant', store: require('./store')}
})

exports.handler = async (event) => {
  if (/\/connect\/google$/.test(event.path)) {
    var state = {dynamic: {scope: ['openid']}}
  }
  else if (/\/connect\/twitter$/.test(event.path)) {
    var state = {dynamic: {key: 'CONSUMER_KEY', secret: 'CONSUMER_SECRET'}}
  }

  var {redirect, response, session} = await grant(event, state)

  if (redirect) {
    return redirect
  }
  else {
    await session.remove()
    return {
      statusCode: 200,
      headers: {'content-type': 'text/plain'},
      body: JSON.stringify(response, null, 2)
    }
  }
}
