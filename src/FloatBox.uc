class FloatBox extends Object;

var float value;

simulated static function FloatBox from(float newValue) {
  local FloatBox result;
  
  result = new class'FloatBox';
  result.value = newValue;
  
  return result;
}

defaultproperties
{
}