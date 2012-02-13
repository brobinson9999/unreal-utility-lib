class InputDriver extends InputDriverCommon;

// This class serves as an engine-specific adapter for capturing user input and passing it to an engine-independant observer.

simulated function initializeInputDriver() {
  // Assign Delegates.
  onReceivedNativeInputKey = keyEvent;
  onReceivedNativeInputAxis = axisEvent;
}

simulated function bool axisEvent(int controllerId, name key, float deltaKey, float deltaTime, optional bool bGamepad) {
  return keyEvent(controllerId, key, IE_Axis, deltaKey, bGamepad);
}

simulated function bool keyEvent(int controllerId, name key, EInputEvent eventType, optional float delta=1.f, optional bool bGamepad )
{
  local string keyName;
  local string actionName;
  local bool bHandled;

  // Map Key and Action.
  keyName = mapKey(Key);
  actionName = mapEventType(EventType);

  bHandled = receivedKeyEvent(keyName, actionName, delta);

  // Some keys should always return true for handling.
  // For now, this includes only mouse x and y, so the camera is not moved externally.
  if (keyName == "IK_MouseX" || keyName == "IK_MouseY")
    return true;

  // Some keys should always return false for handling.
  // For now, this includes left mouse click so you can still use it to respawn.
  if (keyName == "IK_LeftMouse")
    return false;
  else
    return bHandled;
}

simulated function string mapEventType(EInputEvent eventType)
{
  switch (eventType)
  {
    case IE_Repeat:   return "IST_Hold";
    case IE_Pressed:  return "IST_Press";
    case IE_Released: return "IST_Release";
    case IE_Axis:     return "IST_Axis";
  }

  return String(eventType);
}

simulated function string mapKey(name key)
{
  switch (key)
  {
    case 'one':               return "IK_1";
    case 'two':               return "IK_2";
    case 'three':             return "IK_3";
    case 'four':              return "IK_4";
    case 'five':              return "IK_5";
    case 'six':               return "IK_6";
    case 'seven':             return "IK_7";
    case 'eight':             return "IK_8";
    case 'nine':              return "IK_9";
    case 'zero':              return "IK_0";
    case 'LeftMouseButton':   return "IK_LeftMouse";
    case 'RightMouseButton':  return "IK_RightMouse";
    case 'MiddleMouseButton': return "IK_MiddleMouse";
    case 'MouseScrollUp':     return "IK_MouseWheelUp";
    case 'MouseScrollDown':   return "IK_MouseWheelDown";
  }

  return "IK_"$String(key);
}

simulated function cleanup() {
  // Not necessary in UT3?
//    Master.RemoveInteraction(Self);

  super.cleanup();
}

simulated static function InputDriver installNewInputDriver(PlayerController pc) {
  local InputDriver newDriver;
  
  // Create Input Interaction.
  newDriver = new class'InputDriver';
  newDriver.initializeInputDriver();

  // Put in Interaction List.
  // Insert after the console and UIController but before the player interaction.
  // A better way might be to scan the list instead of hardcoding a position.
  if (LocalPlayer(pc.player).viewportClient.insertInteraction(newDriver, 2) == -1)
    `log("An error occurred while installing the input driver.");
  
  return newDriver;
}

defaultproperties
{
}