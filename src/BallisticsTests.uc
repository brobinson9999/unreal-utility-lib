class BallisticsTests extends AutomatedTest;

simulated function runTests() {
  myAssert(class'Ballistics'.static.peakHeight(0, 0, 10) == 0, "(is (peak-height 0 0 10) 0)");
  myAssert(class'Ballistics'.static.peakHeight(20, 0, 10) == 20, "(is (peak-height 20 0 10) 20)");
  myAssert(class'Ballistics'.static.peakHeight(0, 10, 10) == 5, "(is (peak-height 0 10 10) 5)");
  myAssert(class'Ballistics'.static.peakHeight(0, 20, 10) == 20, "(is (peak-height 0 20 10) 20)");
  myAssert(class'Ballistics'.static.peakHeight(10, 20, 10) == 30, "(is (peak-height 10 20 10) 30)");
  myAssert(class'Ballistics'.static.peakHeight(-10, -20, -10) == -30, "(is (peak-height -10 -20 -10) -30)");
  myAssert(class'Ballistics'.static.peakHeight(-20, 0, -10) == -20, "(is (peak-height -20 0 -10) -20)");
  myAssert(class'Ballistics'.static.peakHeight(-10, -20, 10) == -10, "(is (peak-height -10 -20 10) -10)");
  myAssert(class'Ballistics'.static.peakHeight(0, 2, 1) == 2, "(is (peak-height 0 2 1) 2)");

  myAssert(class'Ballistics'.static.timeToZeroOut(10, 5) == 2, "(is (time-to-zero-out 10 5) 2)");
  myAssert(class'Ballistics'.static.timeToZeroOut(10, 10) == 1, "(is (time-to-zero-out 10 10) 1)");
  myAssert(class'Ballistics'.static.timeToZeroOut(-10, -5) == 2, "(is (time-to-zero-out -10 -5) 2)");

  myAssert(class'Ballistics'.static.timeToDrop(10, 0, 0, 20) == 1, "(is (time-to-drop 10 0 0 20) 1)");
  myAssert(class'Ballistics'.static.timeToDrop(20, 0, 0, 10) == 2, "(is (time-to-drop 20 0 0 10) 2)");
  myAssert(class'Ballistics'.static.timeToDrop(0, 0, 10, 10) == 2, "(is (time-to-drop 0 0 10 10) 2)");
  myAssert(class'Ballistics'.static.timeToDrop(0, 0, 20, 20) == 2, "(is (time-to-drop 0 0 20 20) 2)");
  myAssert(class'Ballistics'.static.timeToDrop(15, 0, 10, 10) == 3, "(is (time-to-drop 15 0 10 10) 3)");
  myAssert(class'Ballistics'.static.timeToDrop(-15, 0, -10, -10) == 3, "(is (time-to-drop -15 0 -10 -10) 3)");
  myAssert(class'Ballistics'.static.timeToDrop(0, 2, 2, 1) == 2, "(is (time-to-drop 0 2 2 1) 2)");
  myAssert(class'Ballistics'.static.timeToDrop(0, 0, 0.9, 1.0) == 1.8, "(is (time-to-drop 0 0 0.9 1.0) 1.8)");
  myAssert(class'Ballistics'.static.timeToDrop(0, 0.5, 1.0, 1.0) == 1.0, "(is (time-to-drop 0.0 0.5 1.0 1.0) 1.0)");

  myAssert(abs(class'Ballistics'.static.maxLobRange(0, 0, sqrt(2), 1.0) - 2) < 0.1, "(is (max-lob-range 0 0 (sqrt 2) 1.0) 2 :compare-sym 'close-to)");
  myAssert(abs(class'Ballistics'.static.maxLobRange(0, 0, sqrt(2), 2.0) - 1) < 0.1, "(is (max-lob-range 0 0 (sqrt 2) 2.0) 1 :compare-sym 'close-to)");
  myAssert(abs(class'Ballistics'.static.maxLobRange(0, 0, 0, 2) - 0) < 0.1 , "(is (max-lob-range 0 0 0 2) 0 :compare-sym 'close-to)");
  myAssert(abs(class'Ballistics'.static.maxLobRange(0, 0.5, sqrt(2), 1.0) - 1) < 0.1 , "(is (max-lob-range 0 0.5 (sqrt 2) 1.0) 1 :compare-sym 'close-to)");
  
  class'PlatformStatics'.static.platformLog(class'Ballistics'.static.getLaunchDirection(100, vect(0,0,0), vect(1000,0,0), vect(0,0, -100)));
}