---------------------------------------------------------------------------------------------------------------
-----------------------------------------CUSTOM CODE SECTION---------------------------------------------------
---------------------------------------------------------------------------------------------------------------

function GenericCrateSpawner(self)
	PreloadLUAScript()
end

function PreloadLUAScript()
	if rename("scripts.lua","scripts.lua") then 
		dofile("scripts.lua") 
		ExecuteAction("DISPLAY_TEXT", "MESSAGE:ExternalLUAScriptsLoaded")
	end
end

SuperweaponPreventer_Init = false

function NoSuperweaponsOption(self)
	if not SuperweaponPreventer_Init then
		SuperweaponPreventer_Init = true
		SuperweaponsBuildability("NO")
		SpawnSuperweaponPreventerDummy(self)
	end
end

function SuperweaponsBuildability(what)
	local BUILDABILITY_TYPE = {["YES"]=0, ["IGNORE_PREREQUISITES"]=1, ["NO"]=2, ["ONLY_BY_AI"]=3}	
	ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "GDIIonCannonControl", BUILDABILITY_TYPE[what])
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "SteelTalonsIonCannonControl", BUILDABILITY_TYPE[what])	
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "ZOCOMIonCannonControl", BUILDABILITY_TYPE[what])
	ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "NODTempleOfNOD", BUILDABILITY_TYPE[what])
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "BlackHandTempleOfNOD", BUILDABILITY_TYPE[what])
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "MarkedOfKaneTempleOfNOD", BUILDABILITY_TYPE[what])
	ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "AlienRiftGenerator", BUILDABILITY_TYPE[what])
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "Reaper17RiftGenerator", BUILDABILITY_TYPE[what])
	--ExecuteAction("TECHTREE_MODIFY_BUILDABILITY_OBJECT", "Traveler59RiftGenerator", BUILDABILITY_TYPE[what])
end

function SpawnSuperweaponPreventerDummy(self)
	for i=1,8,1 do
		ExecuteAction("CREATE_UNNAMED_ON_TEAM_AT_WAYPOINT", "SuperweaponPreventerDummy", "Player_" .. tostring(i) .. "/teamPlayer_" .. tostring(i), "Player_" .. tostring(i) .. "_Start")
		ExecuteAction("CREATE_UNNAMED_ON_TEAM_AT_WAYPOINT", "SuperweaponPreventerDummy", "Player_" .. tostring(i) .. "/defaultSkirmishTeamPlayer_" .. tostring(i), "Player_" .. tostring(i) .. "_Start")
		--ExecuteAction("UNIT_SPAWN_NAMED_LOCATION_ORIENTATION", "SuperweaponPreventerDummy_" .. i, "SuperweaponPreventerDummy", "Player_" .. i .. "/teamPlayer_" .. i, "((0.00,0.00,0.00))", 0)
	end
end

function GetValidTeamList()
	local TeamList={
	"Player_1/teamPlayer_1",
	"Player_2/teamPlayer_2",
	"Player_3/teamPlayer_3",
	"Player_4/teamPlayer_4",
	"Player_5/teamPlayer_5",
	"Player_6/teamPlayer_6",
	"Player_7/teamPlayer_7",
	"Player_8/teamPlayer_8",
	"Player_1/defaultSkirmishTeamPlayer_1",
	"Player_2/defaultSkirmishTeamPlayer_2",
	"Player_3/defaultSkirmishTeamPlayer_3",
	"Player_4/defaultSkirmishTeamPlayer_4",
	"Player_5/defaultSkirmishTeamPlayer_5",
	"Player_6/defaultSkirmishTeamPlayer_6",
	"Player_7/defaultSkirmishTeamPlayer_7",
	"Player_8/defaultSkirmishTeamPlayer_8",
	--"/team", --NeutralTeam
	--"PlyrCivilian/teamPlyrCivilian",
	--"PlyrCreeps/teamPlyrCreeps",
	--"ReplayObserver/teamReplayObserver",
	}	
	local ValidTeamList = {}
	for i=1,getn(TeamList),1 do
		local TempUnitRef = "UNITREF_" .. tostring(GetRandomNumber())
		ExecuteAction("UNIT_SPAWN_NAMED_LOCATION_ORIENTATION", TempUnitRef, "GDIHarvester", TeamList[i], "((0.00,0.00,0.00))", 0)
		if EvaluateCondition("NAMED_NOT_DESTROYED", TempUnitRef) then tinsert(ValidTeamList, TeamList[i]) end --EvaluateCondition("TEAM_DESTROYED", TeamList[i])
		ExecuteAction("NAMED_DELETE", TempUnitRef)
	end
	return ValidTeamList
end

SlowDownGame50PercentDummy_SpawnState = false

function SpawnSlowDownGame50PercentDummy(self)
	if not SlowDownGame50PercentDummy_SpawnState then
		SlowDownGame50PercentDummy_SpawnState = true
		ExecuteAction("UNIT_SPAWN_NAMED_LOCATION_ORIENTATION", "UNITREF_SlowDownGame50PercentDummy", "SlowDownGame50PercentDummy", "/team", "((0.00,0.00,0.00))", 0)
		ExecuteAction("MAP_CHANGE_CLOUD_SPEED", 50)
		--ExecuteAction("TEAM_EXECUTE_SEQUENTIAL_SCRIPT_LOOPING", "/team", "FPS_SCRIPT", 1)
	end
end
  
function HandleFPSAndGameSpeed() --unused, doesn't work
	local CUSTOM_FPS=60
	local NORMAL_FPS=30
	ExecuteAction("SET_FPS_LIMIT", CUSTOM_FPS)
	ExecuteAction("SET_VISUAL_SPEED_MULTIPLIER", NORMAL_FPS/CUSTOM_FPS)
	ExecuteAction("CAMERA_MOD_SET_FINAL_SPEED_MULTIPLIER", 0.5)
	ExecuteAction("MAP_CHANGE_CLOUD_SPEED", 50)
	ExecuteAction("ENABLE_SCRIPT", "FPS_SCRIPT")
	ExecuteAction("TEAM_EXECUTE_SEQUENTIAL_SCRIPT_LOOPING", "/team", "FPS_SCRIPT", 1)  --is working, uses a map script from a library map
end

function OnCreated_Viscords_IntermediateDummySpawner(self)
	if GetRandomNumber() > 0.4 then ExecuteAction("NAMED_DELETE", self) end
end

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

--- define lua functions 
function NoOp(self, source)
end


function kill(self) -- Kill unit self.
	ExecuteAction("NAMED_KILL", self);
end

function RadiateUncontrollableFear( self )
	ObjectBroadcastEventToEnemies( self, "BeUncontrollablyAfraid", 350 )
end

function RadiateGateDamageFear(self)
	ObjectBroadcastEventToAllies(self, "BeAfraidOfGateDamaged", 200)
end

function OnNeutralGarrisonableBuildingCreated(self)
	ObjectHideSubObjectPermanently( self, "ARMOR", true )
end

function OnGDITechCenterCreated(self)
	ObjectHideSubObjectPermanently( self, "UG_Boost", true )
	ObjectHideSubObjectPermanently( self, "UG_Mortar", true )
	ObjectHideSubObjectPermanently( self, "B_MortarRound_1", true )
	ObjectHideSubObjectPermanently( self, "UG_Rail", true )
	ObjectHideSubObjectPermanently( self, "UG_Scan", true )
end

function OnGDIMedicalBayCreated(self)
	ObjectHideSubObjectPermanently( self, "UG_Armor", true )
	ObjectHideSubObjectPermanently( self, "UG_StealthDetector", true )
	ObjectHideSubObjectPermanently( self, "UG_StealthDetector01", true )
	ObjectHideSubObjectPermanently( self, "UG_Injector", true )
end

function OnGDIPowerPlantCreated(self)
	ObjectHideSubObjectPermanently( self, "Turbines", true )
	ObjectHideSubObjectPermanently( self, "TurbineGlows", true )
end

function OnGDIZoneTrooperCreated(self)
	ObjectHideSubObjectPermanently( self, "UGSCANNER", true )
	ObjectHideSubObjectPermanently( self, "UGJUMP", true )
	ObjectHideSubObjectPermanently( self, "UGINJECTOR", true )
end

function OnGDIPredatorCreated(self)
	ObjectHideSubObjectPermanently( self, "UGRAIL_01", true )
end

function OnGDIMammothCreated(self)
	ObjectHideSubObjectPermanently( self, "UGRAIL_01", true )
	ObjectHideSubObjectPermanently( self, "UGRAIL_02", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
end

function OnGDIJuggernaughtCreated(self)
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_03", true )
	
end

function OnGDIWatchTowerCreated(self)
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
end

function OnGDIFirehawkCreated(self)
	-- bomb load by default.
	ObjectGrantUpgrade( self, "Upgrade_SelectLoad_02" )
	ObjectHideSubObjectPermanently( self, "Plane04", true )
end

function OnGDIPitbullCreated(self)
	ObjectHideSubObjectPermanently( self, "MortorTube", true )
end

function OnGDIOrcaCreated(self)
	ObjectHideSubObjectPermanently( self, "UG_PROBE", true )
end

function OnGDISniperSquadCreated(self)
	ObjectSetObjectStatus( self, "CAN_SPOT_FOR_BOMBARD" )
end

function OnGDIOrcaClipEmpty(self)
	ObjectHideSubObjectPermanently( self, "MISSILE01", true )
end

function OnGDIOrcaClipFull(self)
	ObjectHideSubObjectPermanently( self, "MISSILE01", false )
end

function OnGDIV35Ox_SummonedForVehicleCreated(self)
	ObjectHideSubObjectPermanently( self, "LOADREF", true )
end

function OnNODShredderCreated(self)

end

function OnNODRaiderTankCreated(self)
	ObjectHideSubObjectPermanently( self, "Gun_Upgrade", true )
	ObjectHideSubObjectPermanently( self, "Turret2_Gun", true )
	ObjectHideSubObjectPermanently( self, "Turret2", true )
	ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
	ObjectHideSubObjectPermanently( self, "DOZERBLADE", true )
end

function OnNODAvatarCreated(self)
	ObjectHideSubObjectPermanently( self, "NUBEAM", true )
	ObjectHideSubObjectPermanently( self, "FLAMETANK", true )
	ObjectHideSubObjectPermanently( self, "S_DETECTOR", true )
	ObjectHideSubObjectPermanently( self, "S_GENERATOR", true )
end

function OnNODAvatarGenericEvent(self, data)

	local str = tostring( data )

	if str == "upgrades_copied" then
		ObjectRemoveUpgrade( self, "Upgrade_Veterancy_VETERAN" );
		ObjectRemoveUpgrade( self, "Upgrade_Veterancy_ELITE" );
		ObjectRemoveUpgrade( self, "Upgrade_Veterancy_HEROIC" );
	end
end

function OnNODScorpionBuggyCreated(self)
	ObjectHideSubObjectPermanently( self, "EMP", true )
end

function OnNODVenomCreated(self)
	ObjectHideSubObjectPermanently( self, "SigGen", true )
end

function OnNODTechAssembleyPlantCreated(self)
	ObjectHideSubObjectPermanently( self, "UG_EMP", true )
	ObjectHideSubObjectPermanently( self, "UG_Lasers", true )
	ObjectHideSubObjectPermanently( self, "UG_SigGen", true )
	ObjectHideSubObjectPermanently( self, "UG_DozerBlades", true )
end

function OnNODSecretShrineCreated(self)
	ObjectHideSubObjectPermanently( self, "GLOWS", true )	
	ObjectHideSubObjectPermanently( self, "ConfUpgrd", true )
end

function OnNODSecretShrinePowerOutage(self)	
	if ObjectHasUpgrade( self, "Upgrade_NODConfessorUpgrade" ) == 1 then
		ObjectHideSubObjectPermanently( self, "GLOWS", true )	
	end
end

function OnNODSecretShrinePowerRestored(self)		 
	if ObjectHasUpgrade( self, "Upgrade_NODConfessorUpgrade" ) == 1 then
		ObjectHideSubObjectPermanently( self, "GLOWS", false )	
	end
end

function onCreatedControlPointFunctions(self)
	ObjectHideSubObjectPermanently( self, "TB_CP_ALN", true )
	ObjectHideSubObjectPermanently( self, "TB_CP_GDI", true )
	ObjectHideSubObjectPermanently( self, "TB_CP_NOD", true )
	ObjectHideSubObjectPermanently( self, "LIGHTSF01", true )
	ObjectHideSubObjectPermanently( self, "100", false)
	ObjectHideSubObjectPermanently( self, "75", false)
	ObjectHideSubObjectPermanently( self, "50", false)
	ObjectHideSubObjectPermanently( self, "25", false )
end

function onBuildingPowerOutage(self)
	ObjectHideSubObjectPermanently( self, "LIGHTS", true )
	ObjectHideSubObjectPermanently( self, "FXLIGHTS05", true )
	ObjectHideSubObjectPermanently( self, "FXLIGHTS", true )
	ObjectHideSubObjectPermanently( self, "FXGLOWS", true )
	ObjectHideSubObjectPermanently( self, "FLASHINGLIGHTS", true )
	ObjectHideSubObjectPermanently( self, "MESH01", true )
	ObjectHideSubObjectPermanently( self, "POWERPLANTGLOWS", true )
	ObjectHideSubObjectPermanently( self, "LIGHTL", true )
	ObjectHideSubObjectPermanently( self, "LIGHTR", true )
	ObjectHideSubObjectPermanently( self, "LIGHTS1", true )
	ObjectHideSubObjectPermanently( self, "NBCHEMICALPTE1", true )
	ObjectHideSubObjectPermanently( self, "LINKS", true )
	ObjectHideSubObjectPermanently( self, "MESH28", true )
	ObjectHideSubObjectPermanently( self, "TURBINEGLOWS", true )
	ObjectHideSubObjectPermanently( self, "GLOWS", true )
end

function onBuildingPowerRestored(self)
	ObjectHideSubObjectPermanently( self, "LIGHTS", false )
	ObjectHideSubObjectPermanently( self, "FXLIGHTS05", false )
	ObjectHideSubObjectPermanently( self, "FXLIGHTS", false )
	ObjectHideSubObjectPermanently( self, "FXGLOWS", false )
	ObjectHideSubObjectPermanently( self, "FLASHINGLIGHTS", false )
	ObjectHideSubObjectPermanently( self, "MESH01", false )
	ObjectHideSubObjectPermanently( self, "POWERPLANTGLOWS", false )
	ObjectHideSubObjectPermanently( self, "LIGHTL", false )
	ObjectHideSubObjectPermanently( self, "LIGHTR", false )
	ObjectHideSubObjectPermanently( self, "LIGHTS1", false )
	ObjectHideSubObjectPermanently( self, "NBCHEMICALPTE1", false )
	ObjectHideSubObjectPermanently( self, "LINKS", false )
	ObjectHideSubObjectPermanently( self, "MESH28", false )
	ObjectHideSubObjectPermanently( self, "TURBINEGLOWS", false )
	ObjectHideSubObjectPermanently( self, "GLOWS", false )
end







function OnNeutralGarrisonableBuildingGenericEvent(self,data)
end

function onCreatedGDIOrcaAirstrike(self)
	ObjectForbidPlayerCommands( self, true )
end

function onCreatedAlienMCVUnpacking(self)
	ObjectForbidPlayerCommands( self, true )
end

function GoIntoRampage(self)
	ObjectEnterRampageState(self)
		
	--Broadcast fear to surrounding unit(if we actually rampaged)
	if ObjectTestModelCondition(self, "WEAPONSET_RAMPAGE") then
		ObjectBroadcastEventToUnits(self, "BeAfraidOfRampage", 250)
	end
end

function MakeMeAlert(self)
	ObjectEnterAlertState(self)
end

function BecomeUncontrollablyAfraid(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterUncontrollableCowerState(self, other)
end

function BecomeAfraidOfRampage(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterCowerState(self, other)
end

function RadiateTerror(self, other)
	ObjectBroadcastEventToEnemies(self, "BeTerrified", 180)
end
	
function RadiateTerrorEx(self, other, terrorRange)
	ObjectBroadcastEventToEnemies(self, "BeTerrified", terrorRange)
end
	

function BecomeTerrified(self, other)
	ObjectEnterRunAwayPanicState(self, other)
end

function BecomeAfraidOfGateDamaged(self, other)
	if not ObjectTestCanSufferFear(self) then
		return
	end

	ObjectEnterCowerState(self,other)
end


function ChantForUnit(self) -- Used by units to broadcast the chant event to their own side.
	ObjectBroadcastEventToAllies(self, "BeginChanting", 9999)
end

function StopChantForUnit(self) -- Used by units to stop the chant event to their own side.
	ObjectBroadcastEventToAllies(self, "StopChanting", 9999)
end

function SpyMoving(self, other)
	print(ObjectDescription(self).." spying movement of "..ObjectDescription(other));
end

function OnGarrisonableCreated(self)
	ObjectHideSubObjectPermanently( self, "GARRISON01", true )
	ObjectHideSubObjectPermanently( self, "GARRISON02", true )
end

function OnRubbleDropshipCreated(self)
	ObjectHideSubObjectPermanently( self, "Loadref", true )
end

function OnAlienMotherShipCreated(self)
	ObjectSetObjectStatus( self, "AIRBORNE_TARGET" )
end