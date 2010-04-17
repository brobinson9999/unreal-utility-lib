class ThrottledPeriodicAlarmTests extends AutomatedTest;

var int runningTotal;

simulated function runTests() {
  local ThrottledPeriodicAlarm alarm;
  local FixedPerformanceThrottle throttle;

  resetTotal();

  alarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
  throttle = FixedPerformanceThrottle(allocateObject(class'FixedPerformanceThrottle'));
  alarm.setPerformanceThrottle(throttle);
  
  alarm.callBack = incrementTotal;
  alarm.setPeriod(1);
  getClock().tick(1);
  myAssert(runningTotal == 1, "timer goes off at the specified time with performance factor 1");

  throttle.throttleFactor = 0.5;
  getClock().tick(0.5);
  myAssert(runningTotal == 1, "throttle does not take effect until after the next time the alarm goes off");
  getClock().tick(0.5);
  myAssert(runningTotal == 2, "alarm goes off normally");
  getClock().tick(1);
  myAssert(runningTotal == 4, "throttle factor takes effect after the next time the alarm goes off");

  alarm.minimumPeriod = 1;
  getClock().tick(0.5);
  myAssert(runningTotal == 5, "minimum period does not take effect until after the next time the alarm goes off");
  getClock().tick(1);
  myAssert(runningTotal == 6, "minimum period takes effect after the next time the alarm goes off");

  alarm.cleanup();
}

simulated function resetTotal() {
  runningTotal = 0;
}

simulated function incrementTotal() {
  runningTotal++;
}
