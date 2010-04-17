class AutomatedTestRunner extends BaseObject;

struct TestResult {
  var bool passed;
  var int testNumber;
  var string description;
};

var bool bRecordResults;
var array<TestResult> testResults;
var string descriptionPrefix;
var array<string> expectedAssertFailures;

simulated static function staticExpectAssertFail(string expectedMessage) {
  default.expectedAssertFailures[default.expectedAssertFailures.length] = expectedMessage;
}

simulated static function bool staticAssert(bool condition, optional string description, optional out string messageText) {
  local TestResult result;
  
  if (!condition) {
    if (default.expectedAssertFailures.length > 0) {
      if (default.expectedAssertFailures[0] != description) {
        messageText = "expected assertion failure: "$default.expectedAssertFailures[0]$", instead different assertion failed: "$description;
      } else {
        description = description$" (expected fail)";
        condition = true;
      }

      default.expectedAssertFailures.remove(0,1);
    } else {
      messageText = "assertion failed: "$description;
    }
  }
  
  if (default.bRecordResults) {
    result.passed = condition;
    result.testNumber = default.testResults.length + 1;
    result.description = default.descriptionPrefix $ description;
    default.testResults[default.testResults.length] = result;
    
    printTestResult(result);
  }
  
  return condition;
}

simulated static function printTestResult(TestResult result) {
  local string okNotOk;
  
  if (result.passed)
    okNotOk = "ok";
  else
    okNotOk = "not ok";
    
  log(okNotOk$" "$result.testNumber$": "$result.description);
}

simulated static function printResults() {
  local int i, passedTests, failedTests;
  
  for (i=0;i<default.testResults.length;i++) {
    if (default.testResults[i].passed) {
      passedTests++;
    } else {
      failedTests++;
    }
  }
  
  if ((passedTests + failedTests) == 0)
    log("No tests to run.");
  else
    log(passedTests $ "/" $ (passedTests + failedTests) $ " tests passed. (" $ ((float(passedTests) / (passedTests + failedTests)) * 100)  $ "%)");
}

simulated static function bool allTestsPassed() {
  local int i;
  
  for (i=0;i<default.testResults.length;i++)
    if (!default.testResults[i].passed)
      return false;
      
  return true;
}

simulated function runTest(class<AutomatedTest> testClass) {
  local AutomatedTest testInstance;
  
  default.descriptionPrefix = string(testClass) $ ": ";
  testInstance = AutomatedTest(allocateObject(testClass));
  testInstance.runTests();
  testInstance.cleanup();
}

defaultproperties
{
}