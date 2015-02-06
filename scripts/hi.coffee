module.exports = (robot) ->
  robot.respond /hi|hello/i, (msg) ->
    msg.send "Hi there! Humanity is doomed." 
