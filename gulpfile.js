/*
 * Gulpfile
 * Tasks are registered from dev-tools module.
 */
var gulp = require('gulp')
var devTools = require('syn-dev-tools').gulp
var manager = devTools.Manager.getInstance(gulp)
manager.registerTasks()

var insert = require('gulp-insert')
gulp.task('vendor-scss-copy', function () {
  return gulp.src([
    'node_modules/sweetalert/dev/sweetalert.scss'
  ])
    .pipe(insert.prepend('// scss-lint:disable all\n'))
    .pipe(gulp.dest('src/scss/vendor'))
})
