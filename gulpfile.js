var gulp = require('gulp');
var rename = require('gulp-rename');
//var source = require('vinyl-source-stream')
//var streamify = require('gulp-streamify')
//var coffee = require('gulp-coffee');  
var browserify = require('gulp-browserify');

gulp.task('scripts', function() {
    gulp.src('src/coffee/app.coffee', { read: false })
       .pipe(browserify({
                transform: ['coffeeify'],
                extensions: ['.coffee']
              }))
    .pipe(rename('bundle.js'))
})

//gulp.task('specs', function() {  
//    gulp.src(['spec/**/*.coffee'])
//        .pipe(coffee({bare: true}).on('error', gutil.log))
//})

gulp.task('default', function() {  
    gulp.watch('src/**', function(event) {
        gulp.run('scripts');
    })

    gulp.watch('spec/**', function(event) {
        gulp.run('specs');
    })
})
