class ThrottledPeriodicAlarm extends PeriodicAlarm;

var float throttleMultiplier;
var float minimumPeriod;

// getPeriod: -> float
// Returns the amount of time between timer events.
simulated function float getPeriod() {
  return FMax(minimumPeriod, getPerformanceThrottleFactor() * throttleMultiplier * super.getPeriod());
}

defaultproperties
{
  minimumPeriod=0
  throttleMultiplier=1
}