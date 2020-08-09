
var request = require('request-compose').client

var path = process.env.FIREBASE_PATH
var auth = process.env.FIREBASE_AUTH

module.exports = {
  get: async (sid) => {
    var {body} = await request({
      method: 'GET', url: `${path}/${sid}.json`, qs: {auth},
    })
    return body
  },
  set: async (sid, json) => {
    await request({
      method: 'PATCH', url: `${path}/${sid}.json`, qs: {auth}, json,
    })
  },
  remove: async (sid) => {
    await request({
      method: 'DELETE', url: `${path}/${sid}.json`, qs: {auth},
    })
  },
}
