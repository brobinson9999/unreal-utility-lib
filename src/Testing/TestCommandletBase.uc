class TestCommandletBase extends Commandlet;

event int main(string parameters) {
  local bool bAllTestsPassed;
  local AutomatedTestRunner testRunner;
  local ObjectAllocator allocator;
  local DefaultClock clock;
  local Logger logger;
  
  class'AutomatedTestRunner'.default.bRecordResults = true;
  testRunner = new class'AutomatedTestRunner';

  allocator = new class'CompositeObjectPool';
  clock = new class'DefaultClock';
  logger = new class'DefaultLogger';
  allocator.setObjectAllocator(allocator);
  allocator.setClock(clock);
  allocator.setLogger(logger);

  allocator.propogateGlobals(clock);
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

function runTests(AutomatedTestRunner testRunner);

defaultproperties
{
  showBanner=false
}