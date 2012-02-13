class AssociationListTests extends AutomatedTest;

simulated function runTests() {
  local AssociationList al;
  local AssociationList a, b, c, d, e, f;
  
  al = AssociationList(allocateObject(class'AssociationList'));
  a = AssociationList(allocateObject(class'AssociationList'));
  b = AssociationList(allocateObject(class'AssociationList'));
  c = AssociationList(allocateObject(class'AssociationList'));
  d = AssociationList(allocateObject(class'AssociationList'));
  e = AssociationList(allocateObject(class'AssociationList'));
  f = AssociationList(allocateObject(class'AssociationList'));
  
  al.addValue(a, d);
  al.addValue(b, e);
  al.addValue(c, f);
  
  myAssert(al.getKey(d) == a, "key lookup");
  myAssert(al.getKey(a) == none, "nonexistent key lookup");

  myAssert(al.getValue(b) == e, "value lookup");
  myAssert(al.getValue(e) == none, "nonexistent value lookup");
  
  al.removeKey(a);
  myAssert(al.getKey(d) == none && al.getValue(a) == none, "remove by key");
  
  al.removeValue(e);
  myAssert(al.getValue(b) == none && al.getKey(e) == none, "remove by value");

}