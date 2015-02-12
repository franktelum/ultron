# Description:
#   A rather threatening greeting
#
# Commands:
#   hi/hello ultron - Ultron introduces himself
#
# Author: jakestambaugh
#

module.exports = (robot) ->
  robot.hear /(?:hi|hello) (?:ultron|@ultron)/i, (msg) ->
    msg.send "Hi there! Humanity is doomed." 
