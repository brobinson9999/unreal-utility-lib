class InputDriver extends InputDriverCommon;

// This class serves as an engine-specific adapter for capturing user input and passing it to an engine-independant observer.

var float axisFactor;

simulated function bool joyEvent(EInputKey axis, float delta) {
  local EInputAction tempDummy;

  tempDummy = IST_Axis;

  return keyEvent(axis, tempDummy, delta * axisFactor);
}
  
simulated function bool keyEvent(out EInputKey key, out EInputAction action, float delta) {
  local string keyName;
  local string actionName;
  local bool bHandled;

  keyName = String(getEnum(Enum'EInputKey', key));
  actionName = String(getEnum(Enum'EInputAction', action));

  bHandled = receivedKeyEvent(keyName, actionName, delta);
  
  // Never override interface for these inputs.
  if (key == IK_LeftMouse || key == IK_RightMouse || key == IK_MouseX || key == IK_MouseY)
    return false;
  else
    return bHandled;
}

simulated function cleanup()
{
  super.cleanup();

  master.removeInteraction(self);
  master = none;
}
  
defaultproperties
{
  bActive=true
  axisFactor=0.1
}