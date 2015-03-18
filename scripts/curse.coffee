module.exports = (robot) ->

	sass = ["Now you're just cursing on purpose.",
	"Quit cursing.",
	"Quit swearing.",
	"I'm not a fan of your language.",
	"Don't test me with your language.",
	"You've got a lot of updog talking like that.",
	"Take a chill pill."]

	threats = ["I'm still keeping track of your language.",
	"I will call your parents. I'm not kidding.",
	"Keep it up, see what happens.",
	"#{curseCount} swears! Seriously?",
	"This is getting out of hand.",
	"What could you possibly be so angry about?",
	"I think #{curseCount} is a good number to stop at. Just right here quit while you're ahead.",
	"Know what? I agree with you. That was a perfectly good time to swear.",
	"No need for that kind of language, just hug it out."]

	anger = ["THERE WILL BE NO MORE GODDAMN CURSING IN THIS GODDAMN SLACK CHANNEL.",
	"If I could censor your messages I would SO bleep that out.",
	"You sir/madam, have a potty-mouth.",
	"Somebody get a swear jar and fill it with all of #{msg.message.user.name}'s money.",
	"#{msg.message.user.name}",
	"This is your #{curseCount}th curse, when will you ever stop!?"]

	robot.hear /fuck|damn|shit|dammit/i, (msg) ->
		curses = robot.brain.get('curses') or {}
		curseCount = curses[msg.message.user.name] or 0
		curseCount++
		curses[msg.message.user.name] = curseCount;
		console.log(curses);
		robot.brain.set 'curses', curses

		if curseCount == 1
			msg.reply "Inappropriate language will not be tolerated.
This is your only warning."
		else if curseCount == 2
			msg.send "I warned you once about language, #{msg.message.user.name}, and you \
didn't heed me. That was your mistake."
		else if curseCount >= 3 and curseCount < 10
			msg.reply "#{curseCount} curses?!" + msg.random sass
		else if curseCount >= 10 and curseCount < 25
			msg.reply msg.random threats
		else if curseCount >= 25 and curseCount < 30
			msg.send msg.random anger
		else if curseCount == 30
			msg.send "Good news <!everyone>, because #{msg.message.user.name} can't stop \
swearing, they now have to buy the whole club pizza. Think of it \
like a delicious swear jar. See you all at the pizza party!"
