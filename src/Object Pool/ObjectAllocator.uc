class ObjectAllocator extends BaseObject;

// getInstance: class<object> -> object
// Returns an instance of the given class.
simulated function object getInstance(class<object> objectClass);

// freeInstance: object ->
// Deallocates an instance of the given class.
simulated function freeInstance(object freedObject);

defaultproperties
{
}