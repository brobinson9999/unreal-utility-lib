class Functional extends Object;

delegate float highestRatedUtilityFunction(object x);

simulated function object highestRatedInList(array<object> candidates) {
  local int i;
  local object thisObject, bestObject;
  local float thisScore, bestScore;
  
  for (i=0;i<candidates.length;i++) {
    thisObject = candidates[i];
    thisScore = highestRatedUtilityFunction(thisObject);
    if (thisScore > bestScore || bestObject == none) {
      bestObject = thisObject;
      bestScore = thisScore;
    }
  }
  
  return bestObject;
}

defaultproperties
{
}