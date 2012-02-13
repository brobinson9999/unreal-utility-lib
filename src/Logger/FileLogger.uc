class FileLogger extends Logger;

var FileLog fileLog;

// logMessage: string ->
// Writes a message to the log.
simulated function logMessage(string message) {
  fileLog.logf(message);
}

// createFileLogger: FileLog [string] -> FileLogger
// Creates a new FileLogger which will write to the provided FileLog. If a string is provided, the FileLog is opened to that file.
simulated static function FileLogger createFileLogger(FileLog newLogger, optional string logFileName) {
  local FileLogger result;
  
  result = new class'FileLogger';
  result.fileLog = newLogger;
  if (logFileName != "")
    newLogger.openLog(logFileName);
  
  return result;
}

// cleanup: ->
// Closes the FileLog, if one exists.
simulated function cleanup() {
  if (fileLog != none) {
    fileLog.closeLog();
    fileLog = none;
  }
}

defaultproperties
{
}