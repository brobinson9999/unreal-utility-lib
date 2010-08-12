#!/usr/bin/python

from buildUT2004Mod import *

buildUT2k4mod(os.getenv("UT2004PATH"), "UnrealUtilityLib", ["src", "src-ut2004"], [], ["Fire", "Editor", "UnrealEd", "IpDrv", "UWeb", "GamePlay", "UnrealGame", "XGame_rc", "XEffects", "XWeapons_rc", "XPickups_rc", "XPickups", "XGame", "XWeapons", "XInterface", "UT2k4Assault", "Onslaught", "GUI2K4", "UT2k4AssaultFull", "OnslaughtFull", "UTV2004c", "UTV2004s", "xVoting", "OnslaughtBP", "StreamlineFX", "XAdmin", "XWebAdmin", "Vehicles", "BonusPack", "SkaarjPack", "SkaarjPack_rc", "UTClassic"], exportcache=False)
