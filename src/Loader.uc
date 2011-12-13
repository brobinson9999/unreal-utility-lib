class Loader extends Object;

var array<string> strings;
var array<object> objects;

simulated static function object get(string objectName, class objectClass) {
  return dynamicLoadObject(objectName, class'Sound', true);
}

defaultproperties
{
}