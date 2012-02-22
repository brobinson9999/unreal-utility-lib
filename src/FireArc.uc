class FireArc extends Object;

// constrainVectorToFireArc: vector vector float -> vector
// Consumes a desired direction to fire in, the facing of the weapon, and the maximum fire arc of the weapon. Returns the
// direction closest to the desired direction that is also within the arc. If the desired direction is within the fire arc
// of the weapon it is returned unchanged. The fire arc is measured in Unreal Rotation Units and is independant on each of
// yaw and pitch.
simulated static function vector constrainVectorToFireArc(vector desiredFireDirection, vector centerOfFireArc, float fireArcSize) {
  local rotator relativeFireRotation;
  
  if (fireArcSize == 0)
    return centerOfFireArc;
  if (fireArcSize == 32768)
    return normal(desiredFireDirection);
  
  relativeFireRotation = normalize(rotator(desiredFireDirection << rotator(centerOfFireArc)));
  
  // Give the desired fire direction exactly if it is within the arc.
  if (abs(relativeFireRotation.yaw) - fireArcSize <= 0 && abs(relativeFireRotation.pitch) - fireArcSize <= 0)
    return desiredFireDirection;

  // This introduces an imperfect result due to the conversion to rotator and then back to vector, but it is extremely close.
  relativeFireRotation.yaw = FClamp(relativeFireRotation.yaw, -fireArcSize, fireArcSize);
  relativeFireRotation.pitch = FClamp(relativeFireRotation.pitch, -fireArcSize, fireArcSize);
  return vector(relativeFireRotation) >> rotator(centerOfFireArc);
}

defaultproperties
{
}