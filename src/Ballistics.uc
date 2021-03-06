class Ballistics extends Object;

// note: ported from ballistics.test.lisp

simulated static function int sign(float x) {
  if (x > 0)
    return 1;
  if (x < 0)
    return -1;
  return 0;
}

simulated static function float peakHeight(float startingHeight, float startingZVelocity, float gravityZ) {
  if (sign(startingZVelocity) == sign(gravityZ)) {
    return startingHeight + ((startingZVelocity * startingZVelocity) / (2 * gravityZ));
  } else {
    return startingHeight;
  }
}

simulated static function float timeToZeroOut(float zVelocity, float gravityZ) {
    return zVelocity / gravityZ;
}

// time to zero out, then time to fall
simulated static function float timeToDrop(float startingHeight, float finalHeight, float startingZVelocity, float gravityZ) {
  return timeToZeroOut(startingZVelocity, gravityZ) + sqrt(fmax(0, (peakHeight(startingHeight, startingZVelocity, gravityZ) - finalHeight) / (gravityZ / 2)));
}

// max-lob-range: float float float float -> float
// purpose: consumes the starting height, final height, and initial speed with which an object is lobbed and the gravitational acceleration on that object, and produces the maximum distance that object can be lobbed.
// The maximum lob distance is achieved when lobbing at a 45 degree angle above the horizontal.
// When lobbing at 45 degrees the horizontal velocity and the vertical velocity are both (/ (* (sqrt 2) initial-speed) 2)
simulated static function float maxLobRange(float startingHeight, float finalHeight, float initialSpeed, float gravityZ) {
  local float vhSpeed;
  
  vhSpeed = (sqrt(2) * initialSpeed) / 2.0;
  
  return vhSpeed * timeToDrop(startingHeight, finalHeight, vhSpeed, gravityZ);
}

// getLaunchDirection: float vector vector vector -> vector
// finds the direction to fire an object which is fired at fixed speed initialSpeed that starts from startPosition, so that it will end at endPosition.
// returns vect(0,0,0) if no suitable direction can be found.
simulated static function vector getLaunchDirection(float initialSpeed, vector startPosition, vector endPosition, vector gravity) {
  local vector testDirection1;
  
  testDirection1 = normal(normal(vect(1,1,0) * (endPosition - startPosition)) + vect(0,0,1));
  class'PlatformStatics'.static.platformLog("getLaunchDirection "$normal(endPosition - startPosition)$" "$testDirection1);
  return getLaunchDirectionIterative(initialSpeed, startPosition, endPosition, gravity, testDirection1, vect(0,0,1), 0.1);
}

// uses newton's method
// testDirection1 should lob farther than testDirection2
// could be more optimal
simulated static function vector getLaunchDirectionIterative(float initialSpeed, vector startPosition, vector endPosition, vector gravity, vector testDirection1, vector testDirection2, float acceptThreshold, optional int recursionLimiter) {
  local vector deltaPosition, middleDirection;
  local float horizontalDistance, startHeight, endHeight;
  local float deltaDistance1, deltaDistance2;
  
  if (recursionLimiter > 100)
    return vect(0,0,0);
  
  startHeight = startPosition.z;
  endHeight = endPosition.z;
  deltaPosition = endPosition - startPosition;
  horizontalDistance = vsize(deltaPosition * vect(1,1,0));
  
  // could be better, should probably base this off of the passed in test directions.
  if (maxLobRange(startHeight, endHeight, initialSpeed, -gravity.z) < horizontalDistance)
    return vect(0,0,0);

  deltaDistance1 = abs(horizontalDistance - (vsize(normal(testDirection1) * vect(1,1,0)) * initialSpeed * timeToDrop(startHeight, endHeight, vsize(normal(testDirection1) * vect(0,0,1)) * initialSpeed, -gravity.z)));
  deltaDistance2 = abs(horizontalDistance - (vsize(normal(testDirection2) * vect(1,1,0)) * initialSpeed * timeToDrop(startHeight, endHeight, vsize(normal(testDirection2) * vect(0,0,1)) * initialSpeed, -gravity.z)));

  if (deltaDistance1 < acceptThreshold)
    return testDirection1;
  if (deltaDistance2 < acceptThreshold)
    return testDirection2;
  
  class'PlatformStatics'.static.platformLog(testDirection1$" "$testDirection2$" "$deltaDistance1$" "$deltaDistance2);
  
  middleDirection = normal(testDirection1 + testDirection2);
  if (deltaDistance1 < deltaDistance2)
    return getLaunchDirectionIterative(initialSpeed, startPosition, endPosition, gravity, testDirection1, middleDirection, acceptThreshold, recursionLimiter + 1);
  else
    return getLaunchDirectionIterative(initialSpeed, startPosition, endPosition, gravity, middleDirection, testDirection2, acceptThreshold, recursionLimiter + 1);
}

// this part isn't from ballistics.test.lisp

simulated static function vector calculateLeadIn(vector ownLocation, vector ownVelocity, vector Target_Position, vector Target_Velocity, float ProjSpeed, optional float maxLeadInSeconds) {
  local int i;
  local vector Dp;
  local vector InterceptPoint;
  local float LDp;
  local float ETA;
  local vector RelativeVelocity;

  local float OldETA;
  local float IterateDelta;

  local float ShipApproachSpeed;
  local float ProjApproachSpeed;

  // Get Relative Velocity.
  RelativeVelocity = ownVelocity - Target_Velocity;

  InterceptPoint = Target_Position;

  // Head Toward
  Dp = InterceptPoint - ownLocation;
  LDp = VSize(Dp);
  IterateDelta = LDp;

  ETA = 0;

  if (ProjSpeed > 0)
  {
    // Iterative approach - closed form would be better.
    for (i=0;i<15;i++)
    {
      ShipApproachSpeed = (RelativeVelocity << Rotator(Dp)).X;
      ProjApproachSpeed = (ProjSpeed + ShipApproachSpeed);

      OldETA = ETA;
      ETA = LDp / ProjApproachSpeed;
      IterateDelta = Abs(ETA - OldETA);

      if (maxLeadInSeconds > 0)
        ETA = FMin(ETA, maxLeadInSeconds);

      InterceptPoint = Target_Position + (Target_Velocity * FMin(ETA, 2));

      // Calculate new distance.
      Dp = InterceptPoint - ownLocation;
      LDp = VSize(Dp);

      if (IterateDelta < 0.01) break;
    }
  }

  return InterceptPoint;
}



defaultproperties
{
}