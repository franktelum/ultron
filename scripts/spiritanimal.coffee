module.exports = (robot) ->
  robot.hear /my spirit animal is (.*)/i, (msg) ->
    animals = robot.brain.get('animals') or {}
    animals[msg.message.user.name] = msg.match[1]
    robot.brain.set('animals', animals)
    msg.send "Now I know what #{msg.message.user.name}\'s spirit animal is!"

  robot.respond /spirit animals/i, (msg) ->
    response = ""
    for user in animals
      response += "#{user}\'s spirit animal is #{animal[user]}\n"

    msg.send response
