class AutomatedTestRunner extends BaseObject
  config(dummyConfig); // made config to satisfy UT3 compiler

struct TestResult {
  var bool passed;
  var int testNumber;
  var string description;
};

var config bool bRecordResults; // made config to satisfy UT3 compiler
var config array<TestResult> testResults; // made config to satisfy UT3 compiler
var config string descriptionPrefix; // made config to satisfy UT3 compiler
var config array<string> expectedAssertFailures; // made config to satisfy UT3 compiler

simulated static function staticExpectAssertFail(string expectedMessage) {
  default.expectedAssertFailures[default.expectedAssertFailures.length] = expectedMessage;
}

simulated static function bool staticAssert(bool condition, optional string description, optional out string messageText, optional BaseObject logObject) {
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
    
    printTestResult(result, logObject);
  }
  
  return condition;
}

simulated static function printTestResult(TestResult result, BaseObject logObject) {
  local string okNotOk;
  local string resultMessage;
    
  if (result.passed)
    okNotOk = "ok";
  else
    okNotOk = "not ok";
  
  resultMessage = okNotOk$" "$result.testNumber$": "$result.description;
  if (logObject != none)
    logObject.infoMessage(resultMessage);
  else
    class'PlatformStatics'.static.platformLog(resultMessage);
}

simulated function printResults() {
  local int i, passedTests, failedTests;
  
  for (i=0;i<default.testResults.length;i++) {
    if (default.testResults[i].passed) {
      passedTests++;
    } else {
      failedTests++;
    }
  }
  
  if ((passedTests + failedTests) == 0)
    infoMessage("No tests to run.");
  else
    infoMessage(passedTests $ "/" $ (passedTests + failedTests) $ " tests passed. (" $ ((float(passedTests) / (passedTests + failedTests)) * 100)  $ "%)");
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