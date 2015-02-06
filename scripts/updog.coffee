module.exports = (robot) ->
  robot.hear what'?s updog|(?:up dog)?\?, (msg) ->
    msg.send "Not much dog, how about you?"
