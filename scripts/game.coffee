module.exports = (robot) ->
	robot.respond /new game/i, (msg) ->
		games = robot.brain.get('games') or {}
		games[msg.message.user.name] = {}
		robot.brain.set 'games', {}
		
		msg.respond "OK, welcome to the world of magic."
