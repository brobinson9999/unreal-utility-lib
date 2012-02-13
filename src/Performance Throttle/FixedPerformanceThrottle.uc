class FixedPerformanceThrottle extends PerformanceThrottle;

var float throttleFactor;

simulated function float getThrottleFactor() {
  return throttleFactor;
}

defaultproperties
{
  throttleFactor=1
}