class DefaultPerformanceThrottle extends PerformanceThrottle;

var protected float throttleFactor;
var protected float smoothedFPS;
var protected float desiredFPS;
var protected float tickSecondsPerRealSecond;

simulated function float getThrottleFactor() {
  return throttleFactor;
}

simulated function setDesiredFPS(float newDesiredFPS) {
  desiredFPS = newDesiredFPS;
}

simulated function setTickSecondsPerRealSecond(float newTickSecondsPerRealSecond) {
  tickSecondsPerRealSecond = newTickSecondsPerRealSecond;
}

simulated function updateThrottleFactor(float delta) {
  local float desiredVirtualFPS;
  local float virtualFPS;

  if (delta > 0) {
    desiredVirtualFPS = desiredFPS / tickSecondsPerRealSecond;
    virtualFPS = 1 / delta;

    // Initialize when zero.
    if (smoothedFPS == 0)
      smoothedFPS = desiredVirtualFPS;
    else if (smoothedFPS > virtualFPS)
      smoothedFPS = (smoothedFPS * 0.5) + (virtualFPS * 0.5);
    else if ((virtualFPS - smoothedFPS) > 1)  // Trying leaving some dead zone here.
      smoothedFPS = (smoothedFPS * 0.95) + (virtualFPS * 0.05);   // Go up more reluctantly than going down.

    if (desiredVirtualFPS > smoothedFPS)
      throttleFactor *= (1 + (delta * 1));
    else if ((SmoothedFPS - desiredVirtualFPS) > 1)  // Trying leaving some dead zone here.
      throttleFactor *= (1 - (delta * 0.05));  // Go up more reluctantly than going down.

    // Clamp the performance factor.
    // This prevents performance factor from running away when the no amount of cutting back can keep pace with the desired FPS.
    // That can happen when the performance slowdown is not caused by throttled elements, so no amount of throttling can achieve the desired FPS.
    throttleFactor = FClamp(throttleFactor, 0.1, 10); 
  }
}

defaultproperties
{
  throttleFactor=1
  desiredFPS=30
  tickSecondsPerRealSecond=1
}