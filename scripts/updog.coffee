# Description:
#   A rather threatening greeting
#
# Commands:
#   hi/hello ultron - Ultron introduces himself
#
# Author: jakestambaugh
#

module.exports = (robot) ->
  robot.hear /what'?s? up ?dog/i, (msg) ->
    msg.send "http://static.comicvine.com/uploads/original/11111/111114407/3744731-6925790424-pun-d.jpg\nNot much dog, what's up with you?"
