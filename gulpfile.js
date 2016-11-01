/*
 * Gulpfile
 * Tasks are registered from dev-tools module.
 */
var gulp = require('gulp')
var devTools = require('syn-dev-tools').gulp
var manager = devTools.Manager.getInstance(gulp)
manager.registerTasks()

gulp.task('vendor-scss-copy', function () {
  return gulp.src([
    'node_modules/sweetalert/dev/sweetalert.scss'
  ])
    .pipe(gulp.dest('src/scss/vendor'))
})
