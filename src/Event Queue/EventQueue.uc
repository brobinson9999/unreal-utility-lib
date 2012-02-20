class EventQueue extends BaseObject abstract;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// A time can be bigger than this without being NaN, but this should be big enough. (~11 days)
const NaNLimit = 1000000;

// ISSUE: ecf7eaf8-224d-4948-811d-f4c38ba4a6c5
// See the regression test for this issue for details on why this is necessary.
var QueuedEvent eventToRecycleAfterProcessing;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function QueuedEvent newEvent() {
    local QueuedEvent result;
    
    result = QueuedEvent(allocateObject(class'QueuedEvent'));
    result.bCleanupAfterProcessing = true;
    
    // ISSUE: ecf7eaf8-224d-4948-811d-f4c38ba4a6c5
    // See the regression test for this issue for details on why this is necessary.
    if (result == eventToRecycleAfterProcessing)
      eventToRecycleAfterProcessing = none;
      
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function QueuedEvent setupEvent(float time, BaseObject callbackTarget)
  {
    local QueuedEvent result;
    
//    debugAssert(time > 0, "EventQueue.setupEvent: time > 0");
//    debugAssert(time < NaNLimit, "EventQueue.setupEvent: time < NaNLimit");
    
    // debug temp code: don't let NaN's mess with me while I am debugging something else
    if (!(time < NaNLimit)) time = NaNLimit;
    
    result = newEvent();
//    debugAssert(result.callbackTarget == none, "EventQueue.setupEvent: result.callbackTarget == none");

    result.time = time;
    result.callbackTarget = callbackTarget;
    
    queueEvent(result);
    
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function queueEvent(QueuedEvent eventToQueue);
  simulated function removeEvent(QueuedEvent eventToRemove);
  simulated function QueuedEvent getNextEvent();
  simulated function removeNextEvent();
  simulated function int getLength();
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function recycleEvent(QueuedEvent oldEvent) {
//    debugMSG("recycling "$oldEvent);
    freeAndCleanupObject(oldEvent);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function runEventsTo(float endTime)
  {
    local QueuedEvent nextEvent;
//    local float PerformanceTimer;
    
    // Get next event.
    nextEvent = getNextEvent();
    while (nextEvent != none && nextEvent.time <= endTime) {
//      if (PerformanceTimeTally != None)
//        getGameSimulation().getEngineAdapter().clock(performanceTimer);

      // Advance the time and process this event.
      getClock().setCurrentTime(nextEvent.time);    

      // This has to happen BEFORE processing the event, because processing the event could potentially add or remove items from
      // the scheduler. An example is if an object is destroyed in it's update event, and removes it's event (which happens to
      // be the one that is being processed), then if we come back here and remove the "next" event, we actually end up removing
      // the one after.
      removeNextEvent();

//      debugMSG("processing "$nextEvent$" "$nextEvent.callBacktarget);

      eventToRecycleAfterProcessing = nextEvent;
      nextEvent.processEvent();

//      debugMSG("done processing "$nextEvent$" "$nextEvent.callBacktarget);

      if (eventToRecycleAfterProcessing != none && eventToRecycleAfterProcessing.bCleanupAfterProcessing)
        recycleEvent(eventToRecycleAfterProcessing);

      eventToRecycleAfterProcessing = none;

//      if (PerformanceCallCountTally != None)
//        PerformanceCallCountTally.Add(getCallbackTargetClassName(nextEvent), 1);
          
//      if (PerformanceTimeTally != None) {
//        getGameSimulation().getEngineAdapter().unClock(performanceTimer);
//        if (PerformanceTimer > 0)
//          PerformanceTimeTally.Add(getCallbackTargetClassName(nextEvent), performanceTimer);
//      }

      nextEvent = getNextEvent();
    }
  }
  
  simulated function string getCallbackTargetClassName(QueuedEvent nextEvent) {
    if (nextEvent.callBackTarget != none)
      return String(nextEvent.callBackTarget.class);
    else
      return "No Callback Target";
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

//  simulated function cleanup()
//  {
//    if (PerformanceTimeTally != None) PerformanceTimeTally.Cleanup();
//    if (PerformanceCallCountTally != None) PerformanceCallCountTally.Cleanup();
    
//    PerformanceTimeTally = None;
//    PerformanceCallCountTally = None;

//    super.cleanup();
//  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}