class DefaultFloatSmootherTests extends AutomatedTest;

simulated function runTests() {
  local DefaultFloatSmoother smoother;
  
  smoother = DefaultFloatSmoother(allocateObject(class'DefaultFloatSmoother'));
  
  myAssert(smoother.getSmoothedValue() == 0, "DefaultFloatSmoother default value = 0");
  
  smoother.addRawValue(1);
  myAssert(smoother.getSmoothedValue() == 1, "DefaultFloatSmoother single raw datum has the same smoothed value");

  smoother.addRawValue(2);
  myAssert(smoother.getSmoothedValue() == 1.5, "DefaultFloatSmoother values are smoothed");

  smoother.addRawValue(2);
  smoother.addRawValue(2);
  smoother.addRawValue(2);
  myAssert(smoother.getSmoothedValue() < 2, "DefaultFloatSmoother old data not purged until maxValues");
  smoother.addRawValue(2);
  myAssert(smoother.getSmoothedValue() == 2, "DefaultFloatSmoother old data is purged after maxValues");
}
