#SWAGSWAP  
[![forthebadge](http://forthebadge.com/images/badges/built-with-swag.svg)](http://forthebadge.com)

Swagswap is a community-based local commerce application that intends to be used by students and faculty of universities and colleges to promote and simplifiy the exchange of items.

## Installation
##### ~ Prerequisites
1. Install <a href="http://docs.mongodb.org/manual/installation/" target="_blank">MongoDB</a>
2. Install <a href="http://nodejs.org" target="_blank">Node.js</a>
3. Install Bower: `npm install -g bower`
4. Install Grunt: `npm install -g grunt-cli`
5. OPTIONAL: Install Cocoapods (for iOS): `sudo gem install cocoapods`

##### ~ Clone this project: `git clone git@github.com:loganisitt/SwagSwap.git`
##### ~ Setup
1. Change to Web directory of SwagSwap: `cd SwagSwap/Web/`
2. Install the npm modules: `npm install`
3. Install the Bower components: `bower install`
4. OPTIONAL: Change to iOS directory of SwagSwap: `cd ../iOS`
5. OPTIONAL: Install Cocoapod dependencies: `pod install`

## Development
##### ~ For web
1. Make sure MongoDB is running: `mongod` or `sudo mongod`
2. Run Grunt: `grunt`
3. Visit the application in your browser at `http://localhost:8080`

##### ~ For iOS
1. Use the workspace: `SwagSwap.xcworkspace`

##### ~ For Android
- To be determined

## Resources
SwagSwap uses a number of open source projects to work properly:
* [AngularJS] - HTML enhanced for web apps!
* [Angular Strap] - great UI boilerplate for modern web apps
* [Node.js] - evented I/O for the backend
* [Express] - fast node.js network app framework
* more to be added

[MongoDB]:http://www.mongodb.org
[Node.js]:http://nodejs.org
[Bower]:http://bower.io
[Grunt]:http://gruntjs.com
[Cocoapods]:http://cocoapods.org
[AngularJS]:http://angularjs.org
[Angular Strap]:http://mgcrea.github.io/angular-strap/
[express]:http://expressjs.com
