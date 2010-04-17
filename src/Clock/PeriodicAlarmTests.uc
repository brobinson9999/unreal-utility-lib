class PeriodicAlarmTests extends AutomatedTest;

var int runningTotal;
var private PeriodicAlarm memberVariableForTimerInCallbackTest;

simulated function runTests() {
  local PeriodicAlarm alarm;

  resetTotal();

  alarm = PeriodicAlarm(allocateObject(class'PeriodicAlarm'));
  
  myAssert(runningTotal == 0, "running total is initially zero");
  incrementTotal();
  myAssert(runningTotal == 1, "incrementTotal increments total");

  alarm.callBack = incrementTotal;
  alarm.setPeriod(1);
  getClock().tick(1);
  myAssert(runningTotal == 2, "timer goes off at the specified time");

  getClock().tick(2);
  myAssert(runningTotal == 4, "timer goes off repeatedly");

  alarm.setPeriod(0.5);
  getClock().tick(1);
  myAssert(runningTotal == 5, "changing period takes effect after the next time the alarm goes off (not immediately)");

  getClock().tick(0.5);
  myAssert(runningTotal == 6, "changing period takes effect after the next time the alarm goes off");

  alarm.setPeriod(1);
  getClock().tick(0.5);
  myAssert(runningTotal == 7, "changing period takes effect after the next time the alarm goes off (not immediately)");

  alarm.setTimer(0.5);
  getClock().tick(0.5);
  myAssert(runningTotal == 8, "alarm's timer can be set directly and takes effect immediately");

  alarm.setPeriod(0);
  getClock().tick(0.5);
  myAssert(runningTotal == 8, "setting period to zero stops the alarm immediately");
  
  // ISSUE: 94935ac5-7d8a-47d3-a3f3-ad16de0042a9
  // The periodic alarm sets it's next event after processing the callback. The normal periodic events can be overridden by
  // calling setTimer on the alarm. However, we don't want the automatically set periodic event to overwrite the timer set
  // by calling setTimer inside of the callBack.
  alarm.setPeriod(1);
  alarm.callBack = setTimerInCallback;
  memberVariableForTimerInCallbackTest = alarm;
  getClock().tick(2);
  memberVariableForTimerInCallbackTest = none;
  myAssert(runningTotal == 9, "setting timer in callback prevents it from being reset by the period");

  alarm.cleanup();
}

simulated function resetTotal() {
  runningTotal = 0;
}

simulated function incrementTotal() {
  runningTotal++;
}

simulated function setTimerInCallback() {
  incrementTotal();
  memberVariableForTimerInCallbackTest.setTimer(2);
}
