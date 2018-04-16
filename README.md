# wp-default-init

This is a shell script to be run on a Mac to spin up a WordPress installation via cli.

 Uses:
* [Composer](https://github.com/composer/composer)
* [MAMP](https://www.mamp.info/en/)
* [Node](https://nodejs.org)/[npm](https://www.npmjs.com)
* [Bedrock](https://github.com/roots/bedrock)
* [Advanced Custom Fields](https://www.advancedcustomfields.com/) - The script pulls from my [personal fork](https://www.advancedcustomfields.com/) via composer.
* [Sage](https://github.com/roots/sage/tree/8.5.4) — The script pulls from my own [custom implemenation](https://github.com/thisbailiwick/sage-default) of Sage via composer.
* The script also installs [fitvids](https://github.com/davatron5000/FitVids.js/), [flickity](https://github.com/metafizzy/flickity), [video.js](https://github.com/videojs/video.js) into the Sage theme via node/npm.