var gulp = require('gulp');
var quickSip = require('quick-sip')(gulp, {
  styles: {
    root: 'app/styles/app.scss',
    src: 'app/**/*.scss'
  },
  copy: {
    excludes: 'scss|coffee|js'
  },
  browserify: {
    root: 'app/scripts/app.coffee',
    transforms: ['coffeeify', 'aliasify'],
    extensions: ['.coffee']
  }
});