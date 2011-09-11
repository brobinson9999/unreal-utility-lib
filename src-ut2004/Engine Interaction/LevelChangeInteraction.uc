class LevelChangeInteraction extends Interaction;

var array<BaseObject> cleanupTargets;

simulated event notifyLevelChange() {
  while (cleanupTargets.length > 0) {
    cleanupTargets[cleanupTargets.length-1].cleanup();
    cleanupTargets.remove(cleanupTargets.length-1, 1);
  }

  cleanup();
  
  super.notifyLevelChange();
}

simulated function cleanup() {
  if (cleanupTargets.length > 0)
    cleanupTargets.remove(0,cleanupTargets.length);

  // Not necessary in UT3.
  master.removeInteraction(self);
}

defaultproperties
{
}