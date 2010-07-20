class InputDriverCommon extends Interaction;

// This class provides common functionality for engine-independant input interactions.

var array<InputObserver> observers;

simulated function addObserver(InputObserver other) {
  observers[observers.length] = other;
}

simulated function bool removeObserver(InputObserver other) {
  local int i;

  for (i=0;i<observers.length;i++) {
    if (observers[i] == other) {
      observers.remove(i,1);
      return true;
    }
  }

  return false;
}
  
simulated function bool receivedKeyEvent(string key, string action, float delta) {
  local int i;
  
  for (i=observers.length-1;i>=0;i--)
    if (observers[i].keyEvent(key, action, delta))
      return true;
      
  return false;
}

simulated function cleanup()
{
  while (observers.length > 0)
    removeObserver(observers[0]);

  // superclass is not a BaseObject
//  super.cleanup();
}

defaultproperties
{
}