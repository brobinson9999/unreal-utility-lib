class DynamicArrayEventQueueTests extends EventQueueTestsAbstract;

simulated function runTests() {
  local DynamicArrayEventQueue queue;

  queue = DynamicArrayEventQueue(allocateObject(class'DynamicArrayEventQueue'));

  runGeneralEventQueueTests(queue);  
}

