class CanvasDriver extends CanvasDriverCommon;

// This class serves as an engine-specific adapter for capturing HUD events and passing it to an engine-independant observer.


simulated function cleanup()
{
  super.cleanup();

  master.removeInteraction(self);
  master = none;
}

simulated static function CanvasDriver getSingletonCanvasDriver(PlayerController pc) {
  // Set Interaction Master to require raw joystick data. Not sure if this is necessary or not.
  pc.player.interactionMaster.bRequireRawJoystick = true;

  return CanvasDriver(class'InteractionUtils'.static.getSingletonInteraction(pc, class'CanvasDriver', "UnrealUtilityLib.CanvasDriver"));
}

/*
simulated static function CanvasDriver installNewCanvasDriver(PlayerController pc) {
  local CanvasDriver newDriver;

  // Create Canvas Interaction.
  newDriver = CanvasDriver(pc.player.interactionMaster.addInteraction("UnrealUtilityLib.CanvasDriver"));

  return newDriver;
}
*/

defaultproperties
{
  bActive=false
  bVisible=true
}