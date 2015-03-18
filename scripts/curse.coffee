module.exports = (robot) ->

	sass = ["Now you're just cursing on purpose.",
	"Quit cursing.",
	"Quit swearing.",
	"I'm not a fan of your language.",
	"Don't test me with your language.",
	"You've got a lot of updog talking like that."]

	robot.hear /fuck|damn|shit|dammit/i, (msg) ->
		curses = robot.brain.get('curses') or {}
		curseCount = curses[msg.message.user] or 0
		curseCount++
		curses[msg.message.user] = curseCount;
		robot.brain.set 'curses', curses

		if curseCount == 1
			msg.reply "Inappropriate language will not be tolerated. 
This is your only warning."
		else if curseCount == 2
			msg.send "I warned you once about language, #{msg.message.user.name}, and you \
didn't heed me. That was your mistake."
		else if curseCount >= 3 and curseCount < 10
			msg.reply msg.random sass
		else
			msg.send "Good news @everyone, because #{msg.message.user.name} can't stop \
swearing, they now have to buy the whole club pizza. Think of it \
like a delicious swear jar. See you all at the pizza party!"
