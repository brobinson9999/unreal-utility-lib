class EventQueueTestsAbstract extends AutomatedTest abstract;

simulated function runGeneralEventQueueTests(EventQueue queue) {
  // ISSUE: ecf7eaf8-224d-4948-811d-f4c38ba4a6c5
  // Tricky issue that came up:
  // A timer event goes off, and the object pool contains no timer events.
  // The object cleans up it's timer event, putting that event into the event queue.
  // The object allocates a new timer event - getting back the one that it just freed.
  // When control returns back to the event queue, it sees that the event is not cleaned up, and cleans it up.
  // RESOLUTION: The event queue will track the currently processing object with a member variable.
  // If it ever allocates that same event, it will reset it's variable, so it will know not to recycle that event.
  // PROBLEM WITH THIS RESOLUTION: It only works if there is only one event queue!
  setTimer(1);
  myAssert(timerEvent.callBackTarget == self, "timer event set up correctly");
  getClock().tick(1);
  myAssert(timerEvent.callBackTarget == self, "timer events don't get cleaned up twice when a timer is set immediately after freeing a timer event that just lapsed");
}

simulated function timerElapsed() {
  cancelTimer();
  setTimer(1);
}