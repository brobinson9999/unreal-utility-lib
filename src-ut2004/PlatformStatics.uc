class PlatformStatics extends Object abstract;

simulated static final function string platformReplaceText(string text, string replace, string with) {
  local string result;
  
  result = text;
  replaceText(result, replace, with);
  return result;
}

simulated static final function platformLog(coerce string message) {
  log(message);
}

simulated static final function array<String> platformSplitString(coerce string inputString, coerce string delimiter) {
  local array<string> result;
  
  split(inputString, delimiter, result);
  
  return result;
}


simulated static final function GameInfo getGameInfoFromActor(Actor anchor) {
  return anchor.level.game;
}

simulated static final function bool mutatorIsInstalled(Actor anchor, class<Mutator> mutClass) {
  local Mutator mut;
  
  for (mut=getGameInfoFromActor(anchor).baseMutator;mut != none;mut=mut.nextMutator)
    if (mut.class == mutClass)
      return true;
      
  return false;
}

simulated static final function installMutator(Actor anchor, Mutator newMutator) {
  local GameInfo game;
  
  game = getGameInfoFromActor(anchor);
  if (game.baseMutator == none)
    game.baseMutator = newMutator;
  else
    game.baseMutator.addMutator(newMutator);
}

simulated static final function installMutatorClassIfNotInstalled(Actor anchor, class<Mutator> newMutatorClass) {
  if (!mutatorIsInstalled(anchor, newMutatorClass))
    installMutator(anchor, getGameInfoFromActor(anchor).spawn(newMutatorClass));
}

defaultproperties
{
}