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

simulated static function InputDriver getSingletonInputDriver(PlayerController pc) {
  // Set Interaction Master to require raw joystick data. Not sure if this is necessary or not.
  pc.player.interactionMaster.bRequireRawJoystick = true;

  return InputDriver(class'InteractionUtils'.static.getSingletonInteraction(pc, class'InputDriver', "UnrealUtilityLib.InputDriver"));
}

/*
simulated static function InputDriver installNewInputDriver(PlayerController pc) {
  local InputDriver newDriver;
  
  // Set Interaction Master to require raw joystick data.
  // Not sure if this is necessary or not.
  pc.player.interactionMaster.bRequireRawJoystick = true;

  // Create Input Interaction.
  newDriver = InputDriver(pc.player.interactionMaster.addInteraction("UnrealUtilityLib.InputDriver"));

  return newDriver;
}
*/

defaultproperties
{
  bActive=true
  axisFactor=0.1
}