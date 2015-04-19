# caseybot

CaseyBot Mk.III is the chatbot of the [Coupa](http://coupa.com) Engineering Team.
She is powered by GitHub's [Hubot](https://hubot.github.com).

![CaseyBot Mk.III](coupa-eve.png)

[heroku]: http://www.heroku.com
[hubot]: http://hubot.github.com
[generator-hubot]: https://github.com/github/generator-hubot

## Hacking

### Install dependencies

Caseybot uses the [hubot-hipchat](https://github.com/aergonaut/hubot-hipchat)
adapter to connect to HipChat. On Mac OS X, this requires you to instasll the
icu4c library, which is available on Homebrew.

```
$ brew install icu4c
$ brew link --force icu4c
```

Once that installs, you can install the rest of the dependencies using npm:

```
$ npm install
```

### Running locally

You can start a Caseybot in test mode by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    caseybot>

Then you can interact with caseybot by typing `caseybot help`.

    caseybot> caseybot help
    caseybot animate me <query> - The same thing as `image me`, except adds [snip]
    caseybot help - Displays all of the help commands that caseybot knows about.
    ...

### Configuration

A few scripts (including some installed by default) require environment
variables to be set as a simple form of configuration.

Each script should have a commented header which contains a "Configuration"
section that explains which values it requires to be placed in which variable.
When you have lots of scripts installed this process can be quite labour
intensive. The following shell command can be used as a stop gap until an
easier way to do this has been implemented.

    grep -o 'hubot-[a-z0-9_-]\+' external-scripts.json | \
      xargs -n1 -i sh -c 'sed -n "/^# Configuration/,/^#$/ s/^/{} /p" \
          $(find node_modules/{}/ -name "*.coffee")' | \
        awk -F '#' '{ printf "%-25s %s\n", $1, $2 }'

How to set environment variables will be specific to your operating system.
Rather than recreate the various methods and best practices in achieving this,
it's suggested that you search for a dedicated guide focused on your OS.

### Writing scripts

Writing scripts is easy. There are two ways to add scripts to Hubot: local
scripts and external scripts. Local scripts are included in the bot's repo;
external scripts are included via node modules. While writing local scripts is
easier, external scripts provide better organization and allow you to control
the script's code separately from the bot.

Check Hubot's [scripting documentation](https://hubot.github.com/docs/scripting/)
for more information on how to write scripts.
