class NaNTests extends AutomatedTest;

simulated function runTests() {
  local float NaN;
  
  NaN = 1 / 0;
  
  myAssert(NaN > 100000, NaN$" > 100000");
  myAssert(!(NaN < 0), NaN$" < 0");
  myAssert(!(NaN == 0), NaN$" == 0");
  myAssert(NaN != 0, NaN$" != 0");
}