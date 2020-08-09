
var grant = require('grant').aws({
  config: require('./config'), session: {secret: 'grant'}
})

exports.handler = async (event) => {
  var {redirect} = await grant(event)
  return redirect
}
