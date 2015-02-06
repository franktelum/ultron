module.exports = (robot) ->
  robot.hear /updog|up dog/i, (msg) ->
    msg.send "Not much dog, how about you?"
