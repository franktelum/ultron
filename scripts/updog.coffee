module.exports = (robot) ->
  robot.hear /what'?s up ?dog/i, (msg) ->
    msg.send "Not much dog, what's up with you?\nhttp://24.media.tumblr.com/e34e161b522223bca171fd21812f75bc/tumblr_n1p1vohHx21qewacoo1_r3_400.jpg"
