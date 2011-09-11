class AssociationListActor extends Actor;

var private array<object> keys, values;

simulated function int getKeyIndex(object other) {
  local int i;

  for (i=0;i<keys.length;i++)
    if (keys[i] == other)
      return i;

  return -1;
}
  
simulated function int getValueIndex(object other) {
  local int i;

  for (i=0;i<values.length;i++)
    if (values[i] == other)
      return i;

  return -1;
}

simulated function object getKey(object value) {
  local int i;
    
  i = getValueIndex(value);
  if (i >= 0)
    return keys[i];

  return none;
}

simulated function object getValue(object key) {
  local int i;
    
  i = getKeyIndex(key);
  if (i >= 0)
    return values[i];

  return none;
}
  
simulated function removeIndex(int index) {
  keys.remove(index,1);
  values.remove(index,1);
}

simulated function removeKey(object key) {
  local int i;

  i = getKeyIndex(key);
  if (i >= 0)
    removeIndex(i);
}

simulated function removeValue(object value) {
  local int i;

  i = getValueIndex(value);
  if (i >= 0)
    removeIndex(i);
}

simulated function addValue(object key, object value) {
  keys[keys.length] = key;
  values[values.length] = value;
}

simulated function cleanup() {
  if (keys.length > 0) keys.remove(0, keys.length);
  if (values.length > 0) values.remove(0, values.length);
}
  
simulated function destroyed() {
  cleanup();

  super.destroyed();
}

defaultproperties
{
  // Avoid destruction at the hands of mutators in PreBeginPlay.
  bGameRelevant=true
  
  bHidden=true
}