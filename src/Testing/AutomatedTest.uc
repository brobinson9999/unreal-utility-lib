class AutomatedTest extends BaseObject abstract;

simulated static function bool assertEqualVectors(coerce vector a, coerce vector b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a == b, a$" == "$b,, logObject);
}

simulated static function bool assertEqualStrings(coerce string a, coerce string b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a ~= b, a$" ~= "$b,, logObject);
}

simulated static function bool assertNotEqualStrings(coerce string a, coerce string b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(!(a ~= b), "!("$a$" ~= "$b$")",, logObject);
}

simulated static function bool assertEqualNumbers(coerce float a, coerce float b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a == b, a$" == "$b,, logObject);
}

simulated static function bool assertNotEqualNumbers(coerce float a, coerce float b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a != b, a$" != "$b,, logObject);
}

simulated static function bool assertEqualObjects(object a, object b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a == b, a$" == "$b,, logObject);
}

simulated static function bool assertNotEqualObjects(object a, object b, optional BaseObject logObject) {
  return class'AutomatedTestRunner'.static.staticAssert(a != b, a$" != "$b,, logObject);
}

simulated function runTests();

defaultproperties
{
}