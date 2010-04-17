class ParameterTestCommandlet extends TestCommandletBase;

var array<string> testNames;

event int main(string parameters) {
  local bool bAllTestsPassed;
  local AutomatedTestRunner testRunner;
  local ObjectAllocator allocator;
  local DefaultClock clock;
  local Logger logger;
  
  replaceText(parameters, "\"", "");
  split(parameters, " ", testNames);
  
  class'AutomatedTestRunner'.default.bRecordResults = true;
  testRunner = new class'AutomatedTestRunner';

  allocator = new class'CompositeObjectPool';
  clock = new class'DefaultClock';
  clock.setEventQueue(new class'DynamicArrayEventQueue');
  logger = new class'DefaultLogger';
  allocator.setObjectAllocator(allocator);
  allocator.setClock(clock);
  allocator.setLogger(logger);

  allocator.propogateGlobals(clock);
  allocator.propogateGlobals(clock.getEventQueue());
  allocator.propogateGlobals(logger);
  allocator.propogateGlobals(testRunner);
  
  runTests(testRunner);
  testRunner.printResults();  
  bAllTestsPassed = testRunner.allTestsPassed();
  
  testRunner.cleanup();
  
  if (bAllTestsPassed)
    return 0;
  else
    return 1;
}

function runTests(AutomatedTestRunner testRunner) {
  local int i;
  local class<AutomatedTest> testClass;
  
  for (i=0;i<testNames.length;i++) {
    if (testNames[i] != "") {
      testClass = class<AutomatedTest>(dynamicLoadObject(testNames[i], class'Class', true));
      if (testClass == none)
        log("Could not load test class '"$testNames[i]$"'.");
      else
        testRunner.runTest(testClass);
    }
  }
}

defaultproperties
{
  showBanner=false
}