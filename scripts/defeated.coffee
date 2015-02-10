boasts = [
  "I am super powerful! I have so much Updog!",
  "I am the best robot.",
  "@jarvis never stood a chance.",
  "Victory at last!"
]

module.exports = (robot) ->
  robot.respond /has defeated me!/i, (msg) ->
    msg.send msg.random boasts
