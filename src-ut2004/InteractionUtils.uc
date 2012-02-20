class InteractionUtils extends PlatformStatics abstract;

simulated private static function Interaction getExistingSingletonInteraction(PlayerController pc, class<Interaction> interactionClass) {
  local int i;
  
  for (i=0;i<pc.player.interactionMaster.globalInteractions.length;i++) {
    if (classIsChildOf(pc.player.interactionMaster.globalInteractions[i].class, interactionClass))
      return pc.player.interactionMaster.globalInteractions[i];
  }
  
  return none;
}

simulated static function bool isInteractionClassInstalled(PlayerController pc, class<Interaction> interactionClass) {
  return (getExistingSingletonInteraction(pc, interactionClass) != none);
}

simulated static function Interaction getSingletonInteraction(PlayerController pc, class<Interaction> interactionClass, string interactionClassName) {
  local Interaction existingResult;
  
  existingResult = getExistingSingletonInteraction(pc, interactionClass);
  if (existingResult != none)
    return existingResult;
  else
    return pc.player.interactionMaster.addInteraction(interactionClassName);
}

defaultproperties
{
}