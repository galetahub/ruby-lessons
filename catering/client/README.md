# Client for catering API

Using services:

  - https://nodejs.org/en/
  - http://yeoman.io/
  - http://gruntjs.com/getting-started
  - http://gulpjs.com/
  - https://www.npmjs.com/
  - http://handlebarsjs.com/
  - https://github.com/yeoman/generator-backbone
  - http://requirejs.org/
  - http://coffeescript.org/

## Installation

```sh
$ brew install nodejs (Mac OS)
$ sudo npm install -g yo grunt-cli bower gulp
$ npm install -g generator-backbone
$ cd <my-app-name>
$ yo backbone --template-framework=handlebars
```

Select:
  - Twitter Bootstrap with sass
  - RequireJS
  - CoffeeScript

```sh
$ bower install
$ npm install
```

1. Bower is a package manager for the web which allows you to easily manage dependencies for your projects
2. Gulp is a task-based command-line tool for JavaScript projects. It can be used to build projects, but also exposes several commands which you will want to use in your workflow
3. Grunt is a task-based command-line tool for JavaScript projects

## Application seleton

app/scripts:
 - collections
 - models
 - routes
 - templates
 - views


## Start
  
```sh
$ grunt serve
```
