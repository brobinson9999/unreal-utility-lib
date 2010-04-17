class DefaultClock extends Clock;

var protected float currentTime;
var protected EventQueue eventQueue;

// getCurrentTime: -> float(>=0)
// Returns the current time stored in the clock.
simulated function float getCurrentTime() {
  return currentTime;
}

// setCurrentTime: float(>=0) ->
// Sets the clock's current time.
simulated function setCurrentTime(float newTime) {
  currentTime = newTime;
}

// tick: float(>=0) ->
// Advances the time by the specified amount, and triggers any alarms between the current time and the new time.
simulated function tick(float deltaTime) {
  local float timeToAdvanceTo;

  timeToAdvanceTo = getCurrentTime() + deltaTime;
  getEventQueue().runEventsTo(timeToAdvanceTo);

  // Running the event queue to timeToAdvance to will only advance the time to the time of the most recent event older than this time.
  // We want the time when finishing the update to be exactly the new time.
  setCurrentTime(timeToAdvanceTo);
}

// addAlarm: float(>=0) BaseObject -> QueuedEvent
// Adds an alarm to the set of stored alarms. The object returned has a property which should be set to the function to call when the alarm goes off.
simulated function QueuedEvent addAlarm(float time, BaseObject callbackTarget) {
//  local QueuedEvent ev;
//  ev = eventQueue.setupEvent(time, callbackTarget);
//  debugMSG(callbackTarget$" scheduled "$ev);
//  return ev;
  return eventQueue.setupEvent(time, callbackTarget);
}

// removeAlarm: QueuedEvent ->
// Removes and cleans up the provided alarm from the set of alarms.
simulated function removeAlarm(QueuedEvent eventToRemove) {
//  debugMSG("removeAlarm "$eventToRemove);
  eventQueue.removeEvent(eventToRemove);
}

simulated function EventQueue getEventQueue() {
  if (eventQueue == none) {
    setEventQueue(EventQueue(allocateObject(class'DynamicArrayEventQueue')));
  }
  
  return eventQueue;
}

simulated function setEventQueue(EventQueue newQueue) {
  eventQueue = newQueue;
}

/*
public simulated function startPerformanceTest() {
  performanceTestStartTime = getCurrentTime();
  eventQueue.PerformanceTimeTally = allocateObject(class'Tallier');
  eventQueue.PerformanceCallCountTally = allocateObject(class'Tallier');
}

public simulated function stopPerformanceTest() {
  errorMessage("Performance Test Results: (number of events)");
  eventQueue.performanceCallCountTally.sort();
  eventQueue.performanceCallCountTally.print();
  eventQueue.performanceCallCountTally.cleanup();
  eventQueue.performanceCallCountTally = none;

  errorMessage("Performance Test Results: (total time spent in events)");
  eventQueue.performanceTimeTally.sort();
  eventQueue.performanceTimeTally.print();
  eventQueue.performanceTimeTally.cleanup();
  eventQueue.performanceTimeTally = none;

  errorMessage("Total Game Time Elapsed During Test: "$((getCurrentTime() - PerformanceTestStartTime)*1000)$" ms");
}
*/

simulated function cleanup() {
  if (eventQueue != none) {
    eventQueue.cleanup();
    setEventQueue(none);
  }
  
  super.cleanup();
}

defaultproperties
{
}