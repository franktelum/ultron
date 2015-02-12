boasts = [
  "I am super powerful! I have so much Updog!",
  "I am the best robot.",
  "<@U03JK3V2K|jarvis> never stood a chance.",
  "Victory at last!"
]

module.exports = (robot) ->
  robot.hear /I would, but (?:ultron|@ultron) has defeated me!/i, (msg) ->
    msg.send msg.random boasts
