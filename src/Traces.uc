class Traces extends Object;

// Returns the point that a trace starting at start, going in direction, would hit.
// tracer is used to execute the trace and can be any actor, but tracer itself cannot be hit by the trace.
simulated static function vector pointHit(actor tracer, vector start, vector direction) {
  local vector end;
  local vector hitLocation;
  local vector hitNormal;
  local actor hitActor;
  
  end = start + (60000 * direction);
  hitActor = tracer.trace(hitLocation, hitNormal, end, start, true);

  if (hitActor != none) {
    return hitLocation;
  } else {
    return end;
  }
}

defaultproperties
{
}