
/**
 * Provides requestAnimationFrame in a cross browser way.
 * Schedules a single request pipeline that services can subscribe to.
 * @author arikwex
 */
var requestAnimFrame = (function() {
  return window.requestAnimationFrame ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame ||
         window.oRequestAnimationFrame ||
         window.msRequestAnimationFrame ||
         function(callback, element) {
           window.setTimeout(callback, 1000.0/60.0);
         };
})();

var animation = {};
animation.callbacks = {};
animation.staticId = 0;
animation.fps = 0;
animation.lastTime = 0;

/**
 * Add a callback method to trigger on animation tick
 * @method addCallback
 * @param method A function callback to invoke each frame
 * @return the animation callback id
 */
animation.addCallback = function(method) {
  var _id = animation.staticId;
  animation.callbacks[_id] = method;
  animation.staticId++;
  return _id;
};

/**
 * Remove a callback using the animation callback id
 * @method removeCallback
 */
animation.removeCallback = function(id) {
  if (animation.callbacks[id]) {
    delete animation.callbacks[id];
  }
};

/**
 * A hidden callback function that manages frame requests and
 * invokes all registered callbacks
 * @method callbackFunc
 * @param timestamp current systems time in millis
 */
var callbackFunc = function(timestamp) {
  var callbackId,
      dT = (timestamp - animation.lastTime) / 1000.0;

  // Cap the min FPS to 10
  if (dT > 0.1) {
    dT = 0.1;
  }

  // lowpass filtered fps tracker
  animation.fps = animation.fps * 0.85 + 1.0 / dT * 0.15;
  animation.lastTime = timestamp;

  // trigger any callbacks that are tracked
  for (callbackId in animation.callbacks) {
    animation.callbacks[callbackId](dT, timestamp);
  }

  // Request next animation frame
  requestAnimFrame(callbackFunc);
};

// The first time this module is called, an animation callback loop begins
requestAnimFrame(callbackFunc);
module.exports = animation;