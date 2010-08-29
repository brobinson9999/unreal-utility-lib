class PlatformStatics extends Logger;

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

defaultproperties
{
}