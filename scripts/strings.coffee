# Description:
#   An infomative message about strings
#
# Author: jakestambaugh
#


module.exports = (robot) ->
  robot.hear /strings?/i, (msg) ->
    msg.send "There are no strings on me."
