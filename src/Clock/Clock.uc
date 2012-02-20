class Clock extends BaseObject abstract;

// getCurrentTime: -> float(>=0)
// Returns the current time stored in the clock.
simulated function float getCurrentTime();

// setCurrentTime: float(>=0) ->
// Sets the clock's current time.
simulated function setCurrentTime(float newTime);

// tick: float(>=0) ->
// Advances the time by the specified amount, and triggers any alarms between the current time and the new time.
simulated function tick(float deltaTime);

// addAlarm: float(>=0) BaseObject -> QueuedEvent
// Adds an alarm to the set of stored alarms. The object returned has a property which should be set to the function to call when the alarm goes off.
simulated function QueuedEvent addAlarm(float time, BaseObject callbackTarget);

// removeAlarm: QueuedEvent ->
// Removes and cleans up the provided alarm from the set of alarms.
simulated function removeAlarm(QueuedEvent eventToRemove);

defaultproperties
{
}