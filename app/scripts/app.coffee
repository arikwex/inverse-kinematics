$ = require 'jquery'
animation = require 'animation'
Frame = require './view/Frame'

app = new Frame
$('app-body').append app.$el

window.app = app
window.$ = $