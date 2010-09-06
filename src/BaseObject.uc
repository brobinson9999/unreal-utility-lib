class BaseObject extends Object;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var private BaseObject game;
var private Logger logger;
var private ObjectAllocator objectAllocator;
var private Clock clock;
var private PerformanceThrottle performanceThrottle;

var QueuedEvent timerEvent;               // Holds the timer event, so it can be cancelled if necessary.

//var bool bDebugCleanedUp;

simulated function string getDebugString() {
  return self$"";
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function propogateGlobals(BaseObject other) {
  other.setGameSimulation(getGameSimulation());
  other.setObjectAllocator(getObjectAllocator());
  other.setLogger(getLogger());
  other.setClock(getClock());
  other.setPerformanceThrottle(getPerformanceThrottle());
}

simulated function setGameSimulation(BaseObject newGameSimulation) {
  game = newGameSimulation;
}

simulated function BaseObject getGameSimulation() {
  return game;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setObjectAllocator(ObjectAllocator newObjectAllocator) {
  objectAllocator = newObjectAllocator;
}

simulated function ObjectAllocator getObjectAllocator() {
  return objectAllocator;
}

simulated function object allocateObject(class<object> objectClass) {
  local object result;
  
  result = allocateObjectWithoutPropogation(objectClass);
  if (BaseObject(result) != none)
    propogateGlobals(BaseObject(result));
    
  return result;
}

simulated function object allocateObjectWithoutPropogation(class<object> objectClass) {
  local ObjectAllocator allocator;
  
  allocator = getObjectAllocator();
  if (allocator != none)
    return allocator.getInstance(objectClass);
  else
    return new objectClass;
}

simulated function freeObject(object other) {
  local ObjectAllocator allocator;
  
  allocator = getObjectAllocator();
  if (allocator != none)
    allocator.freeInstance(other);
}

simulated function freeAndCleanupObject(BaseObject other) {
  local ObjectAllocator oldAllocator;

  if (game != none && other == self) {
    oldAllocator = getObjectAllocator();
    cleanup();
    if (oldAllocator != none)
      oldAllocator.freeObject(self);
  } else {
    other.cleanup();
    freeObject(other);
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setLogger(Logger newLogger) {
  logger = newLogger;
}

simulated function Logger getLogger() {
  return logger;
}

// This uses a separate function name so that these can be distinguished from debug messages in searches.
simulated function errorMessage(coerce String message) {
  if (getLogger() != none)
    getLogger().logMessage(message);
  else
    class'PlatformStatics'.static.platformLog(message);
}

simulated function infoMessage(coerce String message) {
  errorMessage(message);
}

simulated function expectAssertFail(string expectedMessage) {
  class'AutomatedTestRunner'.static.staticExpectAssertFail(expectedMessage);
}

// Similar to debugMSG, this type of assert is intended to be temporary and should not be left in code.
simulated function debugAssert(bool condition, optional string description) { 
  myAssert(condition, description);
}

// This assert is used for tests and should always be enabled.
simulated function testAssert(bool condition, optional string description) { 
  myAssert(condition, description);
}

simulated function myAssert(bool condition, optional string description) {
  local string messageText;
  
  class'AutomatedTestRunner'.static.staticAssert(condition, description, messageText, self);
  if (!condition && !class'AutomatedTestRunner'.default.bRecordResults)
    errorMessage(messageText);
}

simulated function debugMSG(coerce String message) {
  errorMessage(message);
}

simulated function debugMSGList(array<object> inputList)
{
  local int i;

  if (inputList.length == 0)
  {
    debugMSG("Attempted to export empty list.");
    return;
  }

  for (i=0;i<inputList.length;i++)
    debugMSG(i$": " $ inputList[i]);
}

simulated function debugMSGStringList(array<string> inputList)
{
  local int i;

  if (inputList.length == 0)
  {
    debugMSG("Attempted to export empty list.");
    return;
  }

  for (i=0;i<inputList.length;i++)
    debugMSG(i$": " $ inputList[i]);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setPerformanceThrottle(PerformanceThrottle newPerformanceThrottle) {
  performanceThrottle = newPerformanceThrottle;
}

simulated function PerformanceThrottle getPerformanceThrottle() {
  return performanceThrottle;
}

simulated function float getPerformanceThrottleFactor() {
  local PerformanceThrottle throttle;
  
  throttle = getPerformanceThrottle();
  if (throttle == none)
    return 1;
  else
    return throttle.getThrottleFactor();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated static function vector copyRotToVect(rotator input) {
  local vector result;
  
  result.x = input.yaw;
  result.y = input.pitch;
  result.z = input.roll;
  
  return result;
}

simulated static function rotator copyVectToRot(vector input) {
  local rotator result;
  
  result.yaw = input.x;
  result.pitch = input.y;
  result.roll = input.z;
  
  return result;
}

simulated static function vector capVector(vector in, float maxLength) {
  return normal(in) * fmin(maxLength, vsize(in));
}

simulated static function rotator capRotator(rotator in, float maxLength) {
  return copyVectToRot(capVector(copyRotToVect(in), maxLength));
}

final static operator(23) vector coordRot(vector A, rotator B)
{
  if (A == Vect(0,0,0) || B == Rot(0,0,0))
    return A;

  return A >> B;
}

final static operator(23) vector unCoordRot(vector A, rotator B)
{
  if (A == Vect(0,0,0) || B == Rot(0,0,0))
    return A;

  return A << B;
}

final static operator(23) rotator coordRot(rotator A, rotator B)
{
  local vector X, Y, Z;

  if (A == Rot(0,0,0))
    return B;

  if (B == Rot(0,0,0))
    return A;

  GetAxes(A, X, Y, Z);

  X = X CoordRot B;
  Y = Y CoordRot B;
  Z = Z CoordRot B;

  return OrthoRotation(X, Y, Z);
}

final static operator(23) rotator unCoordRot(rotator A, rotator B)
{
  local vector X, Y, Z;

  if (B == Rot(0,0,0))
    return A;

  GetAxes(A, X, Y, Z);

  X = X UnCoordRot B;
  Y = Y UnCoordRot B;
  Z = Z UnCoordRot B;

  return OrthoRotation(X, Y, Z);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated static function rotator smallestRotatorMagnitude(rotator inputRotator)
{
  local rotator result;

  result.yaw = smallestRotatorAngleMagnitude(inputRotator.yaw);
  result.pitch = smallestRotatorAngleMagnitude(inputRotator.pitch);
  result.roll = smallestRotatorAngleMagnitude(inputRotator.roll);

  return result;
}

simulated static function vector smallestVRotatorMagnitude(vector inputVRotator)
{
  local vector result;

  result.x = smallestRotatorAngleMagnitude(inputVRotator.x);
  result.y = smallestRotatorAngleMagnitude(inputVRotator.y);
  result.z = smallestRotatorAngleMagnitude(inputVRotator.z);

  return result;
}

simulated static function float smallestRotatorAngleMagnitude(float InputAngle)
{
  local float Result;

  Result = InputAngle;
  while (Result >= 32768)
    Result -= 65536;
  while (Result <= -32768)
    Result += 65536;

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated static function vector ClosestPointOnLine(vector LineStart, vector LineEnd, vector ComparePoint)
{
  local vector Line;
  local float  LineLength;

  local float U;
  local vector Intersection;

  // Setup
  Line = LineEnd - LineStart;
  LineLength = VSize(Line);

  // Find U.
  U = ( ((ComparePoint.X - LineStart.X) * Line.X) +
        ((ComparePoint.Y - LineStart.Y) * Line.Y) +
        ((ComparePoint.Z - LineStart.Z) * Line.Z) )
        / (LineLength ** 2);

  // Check for ends of line segment.
  if (U < 0)
    return LineStart;

  if (U > 1)
    return LineEnd;

  Intersection = LineStart + (U * Line);

  return Intersection;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setClock(Clock newClock) {
  clock = newClock;
}

simulated function Clock getClock() {
  return clock;
}

simulated function float getCurrentTime() {
  return getClock().getCurrentTime();
}

simulated function setTimer(float time)
{
  // This system cannot handle two timers simultaneously, so cancel any existing timer.
  cancelTimer();

  timerEvent = getClock().addAlarm(getCurrentTime() + time, self);
  timerEvent.callback = timerElapsed;
}

simulated function timerElapsed();

simulated function cancelTimer() {
  if (timerEvent != none) {
//    myAssert(timerEvent.callbackTarget == self, "BaseObject.cancelTimer: timerEvent.callbackTarget == self");
//    debugMSG(self$" cancelling "$timerevent);
    if (getClock() != none)
      getClock().removeAlarm(timerEvent);
    timerEvent = none;
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// reset: ->
// This function can be called whenever no operations have been performed on an object since it was allocated or since the last time it's cleanup method was called.
// When it returns the object will be in a state indistinguishable from one that was just allocated. In practical terms, this means that it resets any values to
// default that did not need to be reset to default in cleanup.
simulated function reset() {
//  bDebugCleanedUp = false;
}

// cleanup: ->
// This function can be called in any state. After it returns, the object is safe to discard (for garbage collection) or to put into an object pool.
simulated function cleanup() {
  cancelTimer();
  setClock(none);
  setObjectAllocator(none);
  setLogger(none);
  setGameSimulation(none);
  setPerformanceThrottle(none);
  
//  bDebugCleanedUp = true;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}