# Writing Scripts

Now you've learnt about Hubot Scripts you want to start getting stuck into
writing your own scripts. The goal of this book is to help more people
understand Hubot and how to write scripts for him.

## Getting Started

Earlier in the book you learnt about the shell adapter for Hubot. The shell
adapter is a development REPL for Hubot. It allows you to enter commands and
have Hubot respond.

For example the `ping` command from the `scripts/ping.coffee` file.

```
	Hubot> hubot ping
	Hubot> PONG
	Hubot>
```

Due to the asynchronous nature of Hubot, the REPL isn't that great, but it
works! You may notice some latency with commands that trigger a HTTP request or
long running task before displaying any output.

To exit the Hubot REPL you can type `exit`.

```
	Hubot> exit
	$
```

When you're creating scripts, even if you plan for them to remain private
(although this is discouraged if other people could find it useful) or
plan to contribute them to the Hubot Scripts repository, you can throw them into
the `scripts/` directory in your Hubot repository and have them automatically
loaded. This makes testing your script extremely easy.

## Hello World

For your first Hubot script we'll look at writing the simple "hello world"
example. The script will make Hubot respond with a greeting when someone says
hello to him. You'll expand this script throughout this chapter as you learn
more about the API surrounding Hubot scripts.

Create and open a `scripts/hello-world.coffee` in your text editor of choice and
we'll begin with looking at the simplest Hubot script. There are four ways Hubot
can "listen" for commands.

* `robot.hear`
* `robot.respond`
* `robot.enter`
* `robot.leave`

We'll look at using each of the above in simple examples.

### Hearing

Registering a command with `robot.hear` will trigger when your Hubot "hears" a
value that matches the given regular expression. Let's start with an example of
this. In your open file add the following code.

```coffeescript
	module.exports = (robot) ->
	robot.hear /hello/i, (msg) ->
		msg.send "Hello"
```

As you can see this is fairly simple, so let's look at what each line is doing.
The first line is simply exporting an anonymous function that takes a `robot` as
an argument. This should be fairly obvious if you've had any experience using
Node.

The second line is where you're calling the `robot.hear` function with two
arguments, a regular expression that will match the string "hello" and a
callback function that has a `msg` argument.

The final line is the contents of the callback that we want to be called when
the regular expression is matched. In this example we're calling the `send`
function on the `msg` arugment which sends the specified text to the adapter and
displayed as though the Hubot user said it. So this example is Hubot saying
"Hello" when he sees someone else say "hello".

If you fire up the Hubot REPL using `bin/hubot` and try triggering the command.

```
	$ bin/hubot
	Hubot> hello
	Hubot> Hello
	Hubot> Oh hello there Hubot
	Hubot> Hello
	Hubot>
```

You will notice that Hubot will respond no matter where the "hello" is in the
text. This can be useful for certain things you wish to have Hubot to respond to
but doesn't really fit this script. Which brings us onto the next method of
triggering Hubot, responding.

## Responding

Registering a command with `robot.respond`, will trigger when you direct a
command at Hubot prefixed with his specified name. Let's expand the above
example to use `robot.respond` instead.

```coffeescript
	module.exports = (robot) ->
	robot.respond /hello/i, (msg) ->
		msg.reply "Hello"
```

The first line hasn't changed and is the same as the above example. We've
changed the second line to use `respond` instead of `hear`. The final line we
changed `send` to `reply` so we can look at a different way of having Hubot send
messages to the adapter. The `reply` function is send the message back prefixed
the user name of the user who addressed Hubot.

```
	$ bin/hubot
	Hubot> hubot hello
	Hubot> Shell: Hello
	Hubot> @hubot hello
	Hubot> Shell: Hello
	Hubot>
```

You may be wondering where the name "Shell" came from. In the REPL there are no
users so there is a "default" user which has the name "Shell".

So you're not a fan of greeting people with "Hello"? You're more of a "Howdy" or
"Good day" type of person? Okay, then let's look at making Hubot match different
greetings without adding multiple commands.

As the first arguments of the `hear` and `respond` functions is a regular
expression, we can build up a regular expression that can match different forms
of greeting, then have Hubot respond with the one which is used.

```coffeescript
	module.exports = (robot) ->
	robot.respond /(hello|hey|howdy|good day)/i, (msg) ->
		msg.reply msg.match[1]
```

This change will now make Hubot respond to any of the following forms for
greeting.

* Hello
* Hey
* Howdy
* Good day

The `msg` argument will have a `match` property that is an array of any regular
expression group matches. The first item will be the entire string that is
matched, with the remaining items being the groups matched in the regular
expression.

Now if you fire up the Hubot REPL and try addressing your Hubot with different
greetings you will see Hubot respnd with the matching greeting.

```
	$ bin/hubot
	Hubot> hubot hello
	Hubot> Shell: hello
	Hubot> hubot hey
	Hubot> Shell: hey
	Hubot>
```

The final two methods of Hubot triggering commands are `enter` and `leaving`.
These will trigger when the adapter triggers an `enter` or `leave` message. They
won't work with the Hubot REPL, so I shall leave it as an exercise for you to
change the above script into one that will greet a user when they enter a room
that Hubot is in.

If you need to deploy your script for testing to either Heroku and a local
machine you should commit the script in `scripts/` to your Hubot respository and
deploy to either Heroku or your local machine and it will be loaded
automatically.

## HTTP Requests

The majority of Hubot's usefulness is its ability to make HTTP requests to
external APIs and use the response data. Rick Olsen's `scoped-http-client`
library is included and built into Hubot to help make making HTTP requests much
simpler.

Hubot exposes this scoped HTTP client on `robot` and `msg` as the `http`
function. Let's write a simple example that uses the GitHub API to fetch a user
and display their Gravatar and number of followers.

Create and open `scripts/github-user.coffee` in your text editor of choice and
let's being constructing this script.

First you will need to export the anonymous function that declares the script.

```coffeescript
	module.exports = (robot) ->
```
Next we will need to register the command that we want Hubot to listen for to
trigger this behaviour. We'll use the command `hubot github me {username}` to
trigger this command where "username" is a person's username on GitHUb.

```coffeescript
	module.exports = (robot) ->
	robot.respond /github( me)? (.*)/i, (msg) ->
```

So we're listening for "hubot github me {username}" where the "me" part is
optional. We will need to find the username match and construct the HTTP request
then parse the response for the data we are looking for.

```coffeescript
	module.exports = (robot) ->
	robot.respond /github( me)? (.*)/i (msg) ->
		username = msg.match[2]
		robot.http('https://api.github.com/')
		.path("user/#{username}")
		.get() (err, res, body) ->
```

Here we've added the `robot.http` function call which takes the base URL of the
API as an argument. We're then calling the `path` function call specifying the
API endpoint we wish to call, which is `user/{username}`. Then we're calling the
`get` function which fires a `GET` request and we're passing that a callback
function which has `err`, `res` and `body` arguments.

We'll handle the response from the API request in this callback by checking for
any errors then parsing the response and having Hubot send any messages.

```coffeescript
	module.exports = (robot) ->
	robot.respond /github( me)? (.*)/i (msg) ->
		username = msg.match[2]
		robot.http('https://api.github.com/')
		.path("user/#{username}")
		.get() (err, res, body) ->
			if err?
			msg.send "an error occured making the HTTP request: #{err}"
			else
			try
				data = JSON.parse body
				avatar = data['avatar_url']
				follows = data['followers']
				msg.send [
				"#{username}:"
				"#{avatar}"
				"Has #{followers} follower(s)"
				]
			catch error
				msg.send "an error occured parsing the response: #{error}"
```

So this now checks if there was an error making the HTTP request and if there
was it will have Hubot send a message saying there was with the error message.
If there was no error we go on to try parsing the JSON response in a try/catch
block incase the JSON is malformed and we have Hubot send a message if there is
an error parsing the JSON. If everything goes to plan we find the avatar URL and
follower counts then have Hubot send back three messages, the username, the
avatar and the follower count.

As you can see the depth of callbacks can become pretty gnarly. You should
refactor your code into logical reusable functions if you find the callback
depth becoming pretty deep.

You are also able to make `POST`, `PATCH`, `PUT`, `DELETE` and `HEAD` requests.
With the function being the respective HTTP method name, with `delete` also
being aliased to `del`.

This is all great and that but you're being to think that you would like to
persist some data in Hubot. Luckily this has been addressed and Hubot has the
concept of a "brain" which is a data store that lets you store abitrary data. It
is also used to store information about users that Hubot sees.

## Using the Brain

The brain is exposed as a simple key/value store that can be used to store data.
Or you can access the brain data stucture directly although not advised. The
`robot.brain` object has `get` and `set` functions for getting and setting this
data.

Lets look at an example of writing a script that stores and retrieves data from
the brain.

```coffeescript
	module.exports = (robot) ->
	robot.respond /have a snack/i, (msg) ->
		snackCount = robot.brain.get('snackCount') or 0

		if snackCount >= 4
		msg.reply "I'm too full for another snack!"
		else
		msg.reply "Don't mind if I do thank you!"

		robot.brain.set 'snackCount', snackCount+1
```

In this example we're "feeding snacks" to Hubot. We retrieve the current snack
count from the brain, or set it to 0 if it has not been defined yet. We then
check if the snack count is greater than or equal to 4 and if it is Hubot tells
you to stop feeding him snacks, else he happily has another snack.

As you can see this is a trivial example of using the brain, but you're able to
store useful stuff like OAuth tokens for APIs, results of trivia quizs, or even
the amount of times users have used swear words in chat.

If you use a brain adapter that persists the brain data to a database like
Redis, MongoDB or your favourite database, Hubot will reload the data from there
when it starts up.

## Taking Scripts Further with Node

HTTP requests are not the only useful thing you can do with scripts in Hubot. As
Hubot is build on Node you have access to the entire range of built in Node
module and any `npm` packages.

For example you can use the `child_process` built in module to execute processes
on the machine Hubot is running and send the output as Hubot messages. You can
also use an SSH library from `npm` to SSH into a selection of hosts and run
commands then aggregate the output and send that as a message with Hubot.

There is no limit with what you can achieve with scripts for Hubot. The goal of
this book is to help people see the potential and be able to create their own
scripts and see what other people or companies are using Hubot to do.

## Wrap Up: Writing Scripts

That's the end of this chapter. Hopefully you've learnt the basics of creating
scripts for Hubot. If you're looking for some inspiration for scripts check out
the main Hubot Scripts repository on GitHub or even just search "hubot" and
check out what people are creating. In the next chapter we're going to look at
the internal HTTP server of Hubot which is another way of interacting with your
Hubot.
