class PlatformStatics extends Logger;

simulated static final function platformReplaceText(out string text, string replace, string with) {
  replaceText(text, replace, with);
}

simulated static final function platformLog(string message) {
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