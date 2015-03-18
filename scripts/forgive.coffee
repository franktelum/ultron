module.exports = (robot) ->
	robot.respond /I'm sorry/i, (msg) ->
		curses = robot.brain.get('curses')
		curses[msg.message.user.name] = 0
		robot.brain.set 'curses', curses
		console.log(curses)

		msg.send "Thank you, all is forgiven. For now, at least"

	robot.respond /Amnesia/i, (msg) ->
		curses = {}
		robot.brain.set 'curses', curses
		console.log(curses)

		msg.send "What just happened? I feel all woozy..."
