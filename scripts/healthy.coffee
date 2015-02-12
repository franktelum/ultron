module.exports = (robot) ->
    robot.hear /healthiest/i, (msg) ->
        msg.send "I'm the healthiest robot!"

    robot.respond /I ((?:worked out)|did|ran|lifted|benched)(?: for)? (\d*) (.+)$/i, (msg) ->
        robot.brain.healthy = {} if robot.brain.healthy is undefined
        robot.brain.healthy[msg.user] = {"worked out": 0} if robot.brain.healthy[msg.user] is undefined
        currHealthy = robot.brain.healthy[msg.user]
        if msg.match[1] == "worked out"
            robot.brain.healthy[msg.user]["worked out"] = currHealthy["worked out"] + msg.match[2]
            msg.send JSON.stringify robot.brain.healthy[msg.user]