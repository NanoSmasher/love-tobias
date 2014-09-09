Tag oriented batch image and sound (tobias)
===========================================

TOBIAS :: version 0.1
Game Sound library

Author: Henry Lu
Date: August 24, 2014
For: LOVE 0.9
License: MIT

~~~~~~~~~~~
   ABOUT
~~~~~~~~~~~

This is a simple sound library that sorts sounds so you can do bulk changes.
You'll fine some neat features that I haven't seen appearing in any other library such as:

* Changing music
Cutscene? New Level? Instead of making a new sound data, stopping the old one, and playing the new one, have a function that does all of that for you. Keeps all the previous data of the old one too.

* BGM and SFX
BGM tend to use streaming and looping, while SFX are static and don't loop. Function for each one.

* Layered pauses
Let's call pause twice (for an effect and pause menu). But if you call resume both starts up again!

*Caching
Music is saved into memory even when it stops, and will clone itself if play is called while it is already playing. "Cleaning"/Removing the music from the cache is done using a separate function.

~~~~~~~~~~~~~
   RUNNING
~~~~~~~~~~~~~

This uses HUMP's class system so make sure you have

	Class = require "hump/class"

called before

	require "moan"

Note: If you didn't name it "Class", then change the first line so that it matches.

~~~~~~~~~~~~~~~
   FUNCTIONS
~~~~~~~~~~~~~~~

* tag = Hear(<loop>,<stream>)
* tag = Play(<loop>,<stream>)
Both inherits Moan, but has different loop and stream constants
Hear has loop = false, stream = false
Play has loop = true, stream = true

* tag:load(<sound>)
load a sound but don't play it
if you make a sound in two different tags, they'll be treated as separate sounds.
if the sound already exists for that tag, then it does nothing

* tag:play(<sound>)
load the sound if necessary and;
if the sound is stopped, play it from the beginning
if the sound is playing, clone it and play it
if the sound is paused, remove all counters and resume

* tag:change(<oldsound>,<newsound>)
replace the previous sound with a new sound
will do nothing if the sounds are the same

* tag:vol(<number>)
sets a new volume or the tag
returns the current volume or <number>

* tag:pause()
adds one to pause counter

* tag:resume()
subtracts one from pause counter

* tag:stop()
stops sound

* tag:kill(<sound>)
stops music and strips it from the music list
if no argument is provided it kills all sounds

* Moan.vol()
global tag:vol()

* Moan.pause()
global tag:pause()

* Moan.resume()
global tag:resume()

~~~~~~~~~~~~~~
   INTERNAL
~~~~~~~~~~~~~~
Moan.clean(<sound>)
- removes clones in tag:play()