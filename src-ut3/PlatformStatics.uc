class PlatformStatics extends Object;

simulated static final function string platformReplaceText(string text, string replace, string with) {
  return repl(text, replace, with);
}

simulated static final function platformLog(coerce string message) {
  `log(message);
}

simulated static final function array<String> platformSplitString(coerce string inputString, coerce string delimiter) {
  local array<string> result;
  
  parseStringIntoArray(inputString, result, delimiter, true);
  
  return result;
}

simulated static final function GameInfo getGameInfoFromActor(Actor anchor) {
  return anchor.worldInfo.game;
}

// "Mutator" can be either a GameRules mutator or a Mutator.
simulated static final function bool mutatorIsInstalled(Actor anchor, class<Actor> mutClass) {
  local Mutator mut;
  local GameRules rules;
  
  if (class<Mutator>(mutClass) != none) {
    for (mut=getGameInfoFromActor(anchor).baseMutator;mut != none;mut=mut.nextMutator)
      if (mut.class == mutClass)
        return true;
  } else {
    for (rules=getGameInfoFromActor(anchor).gameRulesModifiers;rules != none;rules=rules.nextGameRules)
      if (rules.class == mutClass)
        return true;
  }
  
  return false;
}

// "Mutator" can be either a GameRules mutator or a Mutator.
simulated static final function installMutator(Actor anchor, Actor newMutator) {
  local GameInfo game;
  
  game = getGameInfoFromActor(anchor);
  
  if (Mutator(newMutator) != none) {
    if (game.baseMutator == none)
      game.baseMutator = Mutator(newMutator);
    else
      game.baseMutator.addMutator(Mutator(newMutator));
  } else {
    if (game.gameRulesModifiers == none)
      game.gameRulesModifiers = GameRules(newMutator);
    else
      game.gameRulesModifiers.addGameRules(GameRules(newMutator));
  }
}

// "Mutator" can be either a GameRules mutator or a Mutator.
simulated static final function installMutatorClassIfNotInstalled(Actor anchor, class<Actor> newMutatorClass) {
  if (!mutatorIsInstalled(anchor, newMutatorClass))
    installMutator(anchor, getGameInfoFromActor(anchor).spawn(newMutatorClass));
}

defaultproperties
{
}