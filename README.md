# LlamaBot

An [IRC](http://en.wikipedia.org/wiki/Internet_Relay_Chat) [bot](http://en.wikipedia.org/wiki/IRC_bot) with extensive interactive and multiplayer scripts, written in [mSL](http://en.wikipedia.org/wiki/MIRC_scripting_language).

*Maintained from around 2007 to 2010 (my high school years).*

## Installation

(mIRC is currently [Windows only](http://www.mirc.com/mac.html))

#### Easy setup

1. Clone this repo (or [download ZIP](https://github.com/cooperka/LlamaBot/archive/master.zip))
2. Run the executable included here under [`mIRC portable`](https://github.com/cooperka/LlamaBot/tree/master/mIRC%20portable)
  * All settings are pre-configured based on my own preferences, but you can always customize

#### Manual setup

1. Install the latest [mIRC client](http://www.mirc.com/get.html)
2. Clone the contents of [`mIRC portable`](https://github.com/cooperka/LlamaBot/tree/master/mIRC%20portable) into your root mIRC directory (found using `/echo $scriptdir`)
3. Add the scripts to their respective tabs (aliases into Aliases, variables into Variables, etc.)
  * Open the mIRC Scripts Editor (alt+R)
  * Choose File > Load (ctrl+L)
  * Choose all the relevant files
4. Restart mIRC

## Usage

Assuming you installed correctly, you now have a fully-functional clone of LlamaBot! You can use the Aliases yourself, and the Remote scripts will be triggered by other clients in your channels.

If you're not familiar, you should read some guides on IRC and mIRC for more information. A decent one is on Wikipedia [here](http://en.wikipedia.org/wiki/Wikipedia:IRC/Tutorial), but I'm sure there are many other good ones out there.

## History

The earliest recorded date I have of my own use of mIRC is a channel welcome message set on 2008-02-24, but that wasn't the first time I ever logged on. I started using IRC sometime in 2006 or 2007 as a means of communication while playing [RuneScape](http://en.wikipedia.org/wiki/RuneScape) (yes, I was one of THOSE kids!).

I noticed that many clients on the channels I frequented were fully or partially automated, and I had no idea how that was possible or how it worked. I had a VERY limited knowledge of programming at the time, and decided to dive in deeper and figure out how it worked.

Somehow I happened upon mIRC, downloaded it, and started playing around with basic aliases. I learned how to do really simple things like say "Congratulations!" in fancy colors, and I found it so fascinating that I kept experimenting and making my scripts more and more complex. By the end of high school I had the thousands of lines of code found here, plus a dedicated IRC channel, a [help website](http://llamabot.webs.com/), and my very own [Wikipedia page](http://en.wikipedia.org/wiki/LlamaBot) about LlamaBot. According to channel logs, LlamaBot was invited to over 100 unique IRC channels during the time it ran. I used IRC at the time the way most people use Facebook Messenger today: many of my friends were online too, and I spent a huge portion of my time chatting with them as LlamaBot.

This project was my first real taste of computer programming, and is absolutely the reason I ended up where I am today, as a full-time software developer.

*Note 1:
All the code here is in its (mostly) original form, and hasn't been modified since I wrote it in high school.*

*Note 2:
Unfortunately, the Wikipedia page was later deleted because LlamaBot was not open source at the time, and did not comply with various other Wikipedia standards of quality. Oops.*

## Files of interest

The files here are massive and not well organized... My game of two-player DeathMatch (based on Runescape) is what I was most proud of, and the related code can be found [here](mIRC%20portable/scripts/remote/dm.mrc). I also wrote some fairly extensive scripts that do rudimentary natural language processing to offer IRC help, found [here](mIRC%20portable/scripts/remote/help.mrc) and [here](mIRC%20portable/scripts/aliases/help.mrc). Other than that, you can look at the filenames to get a general idea of what sorts of scripts are in each file.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits

Though I wrote nearly all of this code entirely by myself, I'm sure several bits of it came from / were inspired by lots of different people around the web. It was a very long time ago, so I can't provide any attribution for things that I've copied, but I'd specifically like to thank [mircscripts.org](http://www.mircscripts.org/archive/snippets), [Hawkee](http://hawkee.com/mirc/snippets/), and [Pastebin](http://pastebin.com/archive/mirc) for hosting a huge base of examples that I could learn from.
