gulp = require "gulp"
mocha = require "gulp-mocha"
argv = require "yargs"
	.options({
	  'reporter': {
		  default: 'spec'
	  },
	  'timeout': {
		  default: 2000
	  },
	})
	.argv

paths = require "../paths"
utils = require "../utils"

mocha_cli_exposure = {
    reporter: argv.reporter,
    grep: argv.grep,
    invert: argv.invert,
    retries: argv.retries,
    timeout: argv.timeout,
}

gulp.task "test", ["defaults:generate"], ->
  gulp.src ["./test", "./test/all.coffee"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:client", ->
  gulp.src ["./test", "./test/client.coffee"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:core", ->
  gulp.src ["./test", "./test/core"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:document", ->
  gulp.src ["./test", "./test/document.coffee"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:models", ->
  gulp.src ["./test", "./test/models"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:utils", ->
  gulp.src ["./test", "./test/utils.coffee"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:common", ["defaults:generate"], ->
  gulp.src ["./test", "./test/common"], read: false
    .pipe mocha(mocha_cli_exposure)

gulp.task "test:size", ->
  gulp.src ["./test", "./test/size.coffee"], read: false
    .pipe mocha(mocha_cli_exposure)

utils.buildWatchTask "test", paths.test.watchSources
