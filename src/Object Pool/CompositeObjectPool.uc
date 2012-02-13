class CompositeObjectPool extends ObjectAllocator;

// An object allocator which pools any freed objects. When an object is allocated, it is taken from an object pool if one exists. Otherwise, a new object is created.

var array<MyObjectPool>     objectPools;
var array< class<object> >  poolClasses;

simulated function MyObjectPool getExistingPoolForClass(class<object> objectClass) {
  local int i;

  for (i=0;i<poolClasses.length;i++)
    if (poolClasses[i] == objectClass)
      return objectPools[i];

  return none;
}

simulated function MyObjectPool getOrCreatePoolForClass(class<object> objectClass) {
  local MyObjectPool pool;

  pool = getExistingPoolForClass(objectClass);
  if (pool == none)
    pool = addPoolForClass(objectClass);

  return pool;
}

simulated function MyObjectPool addPoolForClass(class<object> objectClass) {
  local MyObjectPool result;

  // Maybe this should be in a subclass.
  if (classIsChildOf(objectClass, class'BaseObject')) {
    result = MyObjectPool(allocateObject(class'BaseObjectPool'));
  } else {
    result = MyObjectPool(allocateObject(class'MyObjectPool'));
  }

  result.setObjectClass(objectClass);

  objectPools[objectPools.length] = result;
  poolClasses[poolClasses.length] = objectClass;

  return result;
}

simulated function object getInstance(class<object> objectClass) {
  local MyObjectPool pool;
  
  pool = getExistingPoolForClass(objectClass);
  if (pool != none)
    return pool.getInstance();
  else
    return new objectClass;
}

simulated function freeInstance(object freedObject) {
  getOrCreatePoolForClass(freedObject.class).freeInstance(freedObject);
}

simulated function cleanup() {
  while (objectPools.length > 0) {
    objectPools[0].cleanup();
    objectPools.remove(0,1);
  }

  if (poolClasses.length > 0)
    poolClasses.remove(0,poolClasses.length);

  super.cleanup();
}
  
defaultproperties
{
}