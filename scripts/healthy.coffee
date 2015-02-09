healthiest = (robot) ->
    robot.hear /healthiest/i, (msg) ->
        msg.send "I'm the healthiest robot!"

worked_out = (robot) ->
    robot.respond /I ((?:worked out)|did|ran|lifted|benched)(?: for)? (\d*) (.+)$/i, (msg) ->
        currHealthy = robot.brain.healthy[msg.user]
        if msg.match[1] == "worked out"
            robot.brain.healthy[msg.user]["worked out"] = currHealthy["worked out"] + msg.match[2]

module.exports = healthiest