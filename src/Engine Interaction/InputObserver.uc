class InputObserver extends BaseObject;

simulated function bool keyEvent(string key, string action, float delta);
simulated function rawInput(float deltaTime, float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY, float aForward, float aTurn, float aStrafe, float aUp, float aLookUp);

defaultproperties
{
}