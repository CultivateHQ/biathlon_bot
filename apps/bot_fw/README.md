# BotFw

Assembles the appropriate applications to create the Biathlon Bot firmware, that runs the laser-shooting robot itself:

* (events)(../events) for receiving hit events from the (separate) sensor via distributed Erlang / Phoenix.PubSub
* (game_state)(../game_state) (via WiFi) for tracking whether a game is started, in progress, or finished.
* (laser)(../laser) err, fires the laser.
* (locomotion)(../locomotion) moves the bot, via it's stepper motors.
* [web](../web) for the web interface
* (wifi)(../wifi) for networking over WiFi, and connected distributed nodes

* 
