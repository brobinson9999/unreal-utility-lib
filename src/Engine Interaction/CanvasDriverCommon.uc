class CanvasDriverCommon extends Interaction;

// This class provides common functionality for engine-independant HUD interactions.

var array<CanvasObserver> observers;

simulated function addObserver(CanvasObserver other) {
  observers[observers.length] = other;
}

simulated function bool removeObserver(CanvasObserver other) {
  local int i;

  for (i=0;i<observers.length;i++) {
    if (observers[i] == other) {
      observers.remove(i,1);
      return true;
    }
  }

  return false;
}
  
simulated function preRender(Canvas canvas) {
  local int i;
  
  for (i=observers.length-1;i>=0;i--)
    observers[i].preRender(canvas);
}

simulated function postRender(Canvas canvas) {
  local int i;
  
  for (i=observers.length-1;i>=0;i--)
    observers[i].postRender(canvas);
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