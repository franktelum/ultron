module.exports = (robot) ->
	robot.respond /I'm sorry/i, (msg) ->
		curses = robot.brain.get('curses')
		curses[msg.message.user] = 0
		robot.brain.set 'curses', curses

		msg.send "Thank you, all is forgiven. For now, at least"
