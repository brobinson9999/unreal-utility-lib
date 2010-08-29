class PlatformStatics extends Logger;

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

defaultproperties
{
}