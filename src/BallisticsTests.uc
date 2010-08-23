class BallisticsTests extends AutomatedTest;

simulated function runTests() {

  myAssert(capVector(vect(0,0,0), 0) == vect(0,0,0), "capVector(vect(0,0,0), 0) == vect(0,0,0)");
  myAssert(capVector(vect(100,0,0), 0) == vect(0,0,0), "capVector(vect(100,0,0), 0) == vect(0,0,0)");
  myAssert(capVector(vect(100,0,0), 1) == vect(1,0,0), "capVector(vect(100,0,0), 1) == vect(1,0,0)");
  myAssert(capVector(vect(100,0,0), 1000) == vect(100,0,0), "capVector(vect(100,0,0), 1000) == vect(100,0,0)");
  myAssert(capVector(vect(3,4,0), 5) == vect(3,4,0), "capVector(vect(3,4,0), 5) == vect(3,4,0)");
  myAssert(capVector(vect(6,8,0), 5) == vect(3,4,0), "capVector(vect(6,8,0), 5) == vect(3,4,0)");

  // rot's format is (pitch, yaw, roll) while vectors are (yaw, pitch, roll)
  myAssert(copyVectToRot(vect(0,0,0)) == rot(0,0,0), "copyVectToRot on vect(0,0,0)");
  myAssert(copyVectToRot(vect(1000,2000,3000)) == rot(2000,1000,3000), "copyVectToRot on vect(1000,2000,3000)");
//  log(copyVectToRot(vect(1000,2000,3000)).pitch$" ~ "$rot(1000,2000,3000).pitch);

  // rotators round to the nearest integer
  myAssert(copyVectToRot(vect(1.2,0,0)) == rot(0,1,0), "copyVectToRot on vect(1.2,0,0)");

  myAssert(smallestRotatorMagnitude(rot(0,0,0)) == rot(0,0,0), "smallestRotatorMagnitude on rot(0,0,0)");
  myAssert(smallestRotatorMagnitude(rot(1000,0,0)) == rot(1000,0,0), "smallestRotatorMagnitude on rot(1000,0,0)");
  myAssert(smallestRotatorMagnitude(rot(-1000,0,0)) == rot(-1000,0,0), "smallestRotatorMagnitude on rot(-1000,0,0)");
  myAssert(smallestRotatorMagnitude(rot(64536,0,0)) == rot(-1000,0,0), "smallestRotatorMagnitude on rot(64536,0,0)");

  myAssert(smallestVRotatorMagnitude(vect(0,0,0)) == vect(0,0,0), "smallestVRotatorMagnitude on vect(0,0,0)");
  myAssert(smallestVRotatorMagnitude(vect(1000,0,0)) == vect(1000,0,0), "smallestVRotatorMagnitude on vect(1000,0,0)");
  myAssert(smallestVRotatorMagnitude(vect(-1000,0,0)) == vect(-1000,0,0), "smallestVRotatorMagnitude on vect(-1000,0,0)");
  myAssert(smallestVRotatorMagnitude(vect(64536,0,0)) == vect(-1000,0,0), "smallestVRotatorMagnitude on vect(64536,0,0)");
  myAssert(smallestVRotatorMagnitude(vect(1000.5,0,0)) == vect(1000.5,0,0), "smallestVRotatorMagnitude on vect(1000.5,0,0)");
}