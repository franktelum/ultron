module.exports = (robot) ->
  robot.hear /beetlejuice/i, (msg) ->
    count = robot.brain.get('beetlejuice') or 0
    count++
    if count < 3
      robot.brain.set 'beetlejuice', count
    else
      msg.send "http://i.perezhilton.com/wp-content/uploads/2013/10/r8w96ys.gif"
      robot.brain.set 'beetlejuice', 0
