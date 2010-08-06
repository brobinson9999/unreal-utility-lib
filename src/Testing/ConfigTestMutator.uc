class ConfigTestMutator extends Mutator
  config(ConfigTestMutator);

var config array<string> testNames;

simulated function tick(float delta) {
  if (delta > 0) {
    class'ParameterTestCommandlet'.static.staticMain(testNames, class'FileLogger'.static.createFileLogger(spawn(class'FileLog'), "ConfigTestMutatorResults"));
    consoleCommand("exit");
  }
  
  super.tick(delta);
}

defaultproperties
{
}