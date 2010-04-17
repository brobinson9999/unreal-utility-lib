class LinkedListEventQueueTests extends EventQueueTestsAbstract;

simulated function runTests() {
  local LinkedListEventQueue queue;

  queue = LinkedListEventQueue(allocateObject(class'LinkedListEventQueue'));

  runGeneralEventQueueTests(queue);  
}

