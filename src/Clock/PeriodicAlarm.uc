class PeriodicAlarm extends BaseObject;

// The amount of time that should elapse between each call to timerElapsed. If zero or negative, the timer is disabled.
var float period;

// ISSUE: 94935ac5-7d8a-47d3-a3f3-ad16de0042a9
// The periodic alarm sets it's next event after processing the callback. The normal periodic events can be overridden by
// calling setTimer on the alarm. However, we don't want the automatically set periodic event to overwrite the timer set
// by calling setTimer inside of the callBack.
var bool bSetTimerInCallback;

delegate callBack();

// setPeriod: float ->
// Sets the amount of time between timer events.
// If the timer is not running and the new period is positive, the timer is started.
// If the timer is running and the new period is negative or zero, the timer is stopped.
// If the timer is running and the new period is positive, the new period takes effect
// the next time setupNextUpdateEvent is called.
simulated function setPeriod(float newPeriod) {
  period = newPeriod;
  
  if (timerEvent == none && newPeriod > 0)
    setupNextUpdateEvent();
  else if (timerEvent != none && newPeriod <= 0)
    cancelTimer();
}

// getPeriod: -> float
// Returns the amount of time between timer events.
simulated function float getPeriod() {
  return period;
}

simulated function setTimer(float time) {
  // ISSUE: 94935ac5-7d8a-47d3-a3f3-ad16de0042a9
  bSetTimerInCallback = true;
  super.setTimer(time);
}

simulated function timerElapsed() {
  // ISSUE: 94935ac5-7d8a-47d3-a3f3-ad16de0042a9
  bSetTimerInCallback = false;

  callBack();
  
  if (!bSetTimerInCallback)
    setupNextUpdateEvent();

  bSetTimerInCallback = false;
}

simulated function setupNextUpdateEvent() {
  local float localPeriod;
  
  localPeriod = getPeriod();
  if (localPeriod > 0)
    setTimer(localPeriod);
}

simulated function cleanup() {
  setPeriod(0);
  callBack = none;
  
  super.cleanup();
}
  
defaultproperties
{
}