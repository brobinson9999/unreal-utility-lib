class FunctionalTests extends AutomatedTest;

simulated function runTests() {
  local array<FloatBox> testObjects;
  local FloatBox one, ten, five, minusTwo;
  local Functional functionalInstance;
  
  functionalInstance = new class'Functional';
  
  one = class'FloatBox'.static.from(1);
  ten = class'FloatBox'.static.from(10);
  five = class'FloatBox'.static.from(5);
  minusTwo = class'FloatBox'.static.from(-2);

  functionalInstance.HighestRatedUtilityFunction = takeHighest;
  myAssert(functionalInstance.highestRatedInList(testObjects) == none, "highestRatedInList(takeHighest, testObjects) == none");

  testObjects[testObjects.length] = one;

  functionalInstance.HighestRatedUtilityFunction = takeHighest;
  myAssert(functionalInstance.highestRatedInList(testObjects) == one, "highestRatedInList(takeHighest, testObjects) == one");
  functionalInstance.HighestRatedUtilityFunction = takeLowest;
  myAssert(functionalInstance.highestRatedInList(testObjects) == one, "highestRatedInList(takeLowest, testObjects) == one");

  testObjects[testObjects.length] = ten;
  testObjects[testObjects.length] = five;
  testObjects[testObjects.length] = minusTwo;

  functionalInstance.HighestRatedUtilityFunction = takeHighest;
  myAssert(functionalInstance.highestRatedInList(testObjects) == ten, "highestRatedInList(takeHighest, testObjects) == ten");
  functionalInstance.HighestRatedUtilityFunction = takeLowest;
  myAssert(functionalInstance.highestRatedInList(testObjects) == minusTwo, "highestRatedInList(takeLowest, testObjects) == minusTwo");

  functionalInstance.HighestRatedUtilityFunction = none;
}

simulated function float takeHighest(object x) {
  return FloatBox(x).value;
}

simulated function float takeLowest(object x) {
  return -FloatBox(x).value;
}