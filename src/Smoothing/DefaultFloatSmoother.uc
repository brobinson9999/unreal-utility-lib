class DefaultFloatSmoother extends BaseObject;

var array<float> values;
var int maxValues;

simulated function addRawValue(float value) {
  values[values.length] = value;
  while (values.length > maxValues)
    values.remove(0,1);
}

simulated function float getSmoothedValue() {
  local int i;
  local float total;
  
  if (values.length == 0)
    return 0;
    
  for (i=0;i<values.length;i++)
    total += values[i];
    
  return total / values.length;
}

defaultproperties
{
  maxValues=5
}