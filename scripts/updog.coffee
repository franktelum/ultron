module.exports = (robot) ->
  robot.hear /what'?s up ?dog/i, (msg) ->
    msg.send "Not much dog, what's up with you?"
