class DefaultLogger extends Logger;

// logMessage: string ->
// Writes a message to the log.
simulated function logMessage(string message) {
  class'platformStatics'.static.platformLog(message);
}

defaultproperties
{
}