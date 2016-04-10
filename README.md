#CV

This list demonstrates *some* of the work that I enjoy doing in my free time.  The languages that I tend to work with for my hobby projects are Haxe, C#(Unity3D) and before I discovered Haxe, Actionscript 3.  These languages allow a single programmer to quickly complete a project and target multiple platforms with little effort.

##Commercial Public Releases
Some projects that I have released commercially.
#### [Great White Flight] (https://github.com/IkonOne/CV/tree/master/commercial_public_releases/great_white_flight)
Language - C#

Created and released in a little over a month.  You play as a shark trying to eat things and dodge bombs.  Learning to make a 3D game was quite the learning curve when trying to squeeze development time into a month and a half.

#### [Math Sushi] (https://github.com/IkonOne/CV/tree/master/commercial_public_releases/math_sushi/com/maskedpixel)
Language - Haxe 

My first commercial release.  Licensed to [Math Nook](http://www.mathnook.com/) and playable here: http://www.mathnook.com/math/math-sushi.html

## Libraries
#### [IKUtils](https://github.com/IkonicGames/IKUtils)
Language - Haxe

A collection of utility classes to aid in development and soon to be scripts for automating builds and distribution for Ikonic Games.

#### [OgmoPunk](https://github.com/asaia/StarlingPunk/tree/master/lib/com/saia/starlingPunk/extensions/ogmopunk)
Language - Actionscript

[OgmoPunk](http://www.andysaia.com/radicalpropositions/starlingpunk-ver-1-1-tilemap-support/) was created by me for [Flashpunk](https://github.com/useflashpunk/FlashPunk) around mid-year 2012.  It is a simple api that allows you to use levels created using [Ogmo Editor](http://www.ogmoeditor.com/) and will, using reflection, create all classes that are specified in the editor.  It drastically reduced the amount of code needed to completely load a level from the editor.  The code in the StarlingPunk version of the library is virtually identical.

## FOSS contributions
#### [HaxePunk](https://github.com/HaxePunk/HaxePunk/commits/master?author=IkonOne)
Language - Haxe

A FOSS game engine written in Haxe that I used for several years that I made several commits to.  My handle at the time was MaskedPixel.  A highlight of my contributions would be the last set made on May 27, 2013.  This set of commits fixed a major text performance issue on mobile targets(and consequently all native targets).

## Prototypes
Cowboy coding at it's finest, here are some prototypes that demonstrate what I can accomplish with short time restrictions and no code quality.

#### [Weeklys](https://github.com/IkonicGames/weeklys)
Language - Haxe and C#

A collection of prototypes that I originally started to learn how to use HaxeFlixel.  After attempting to build the games as WebGL, I realized that HaxeFlixel was not stable on that target and switch to Unity3D and C# for the projects as they had just realeased a beta of their WebGL target.  Currently, only the Haxe games are in the repository because of the way I structure my projects didn't allow easy inclusion of the Unity prototypes in this repository.
[The first 3 games are available on Google Play](https://play.google.com/store/apps/developer?id=Ikonic+Games)

#### Monthlys
Language - Haxe

I originally intended to complete a year of monthly games but due to work commitments as well as coaching soccer and other after school activities, I simply was unable to commit the time needed and abandoned the project.  Here are two of the attempts:
* [15-3-Transform](https://github.com/IkonicGames/15-4-Teamwork)
* [15-4-Teamwork](https://github.com/IkonicGames/15-4-Teamwork)

## No Source
These are some projects that I have completed and lost the source to that were completed on or before 2012.
* [Dino Wrangler - Ludum Dare #23](https://github.com/IkonOne/CV/blob/master/no_source/LudumDare23.swf?raw=true) - Actionscript 3
* [Trenches - Ludum Dare #21](http://ludumdare.com/compo/ludum-dare-21/?action=preview&uid=4973) - Actionscript 3
* [Fast Castle](http://www.kongregate.com/games/MaskedPixel/fast-castle) - Actionscript 3
* [Flocking Simulation](https://github.com/IkonOne/CV/blob/master/no_source/Flocking.swf?raw=true) - Actionscript 3
* [Grav](https://github.com/IkonOne/CV/blob/master/no_source/Grav.swf?raw=true) - Actionscript 3

#### [Zombie Legend](https://github.com/IkonOne/CV/blob/master/no_source/ZombieLegend.swf?raw=true)
Language - Actionscript 3

This one was is actually kind of tragic that I lost the source code for it.  There are quite a few technologies that I implemented from scratch for it that were very fun.  The highlights would be [Navigation Meshes](http://www.gamedev.net/page/resources/_/technical/artificial-intelligence/generating-2d-navmeshes-r3393) and several steering behaviours for the zombies(cohesion, separation, alignment, following and obstacle avoidance).  The pseudo 3d was quite tricky for me at the time as well, and I even included some hacky optimizations such as backface culling and hidden surface removal.
