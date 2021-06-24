do

local ModScriptName="script.ArtOfDefenseQuickChange.lua"
ModScripts["status"]["script.ArtOfDefenseQuickChange.lua"] = 0

	function NAOD.BaseFormula() return (Max_Waves/(1+1*exp(-((1/(Max_Waves/7))*(NAOD.WaveTimeDifficultyFactor()-(Max_Waves/2)))))) end	 --logistic growth

	NAOD.Scalar={}
	NAOD.Scalar.Infantry1										= 3.0
	NAOD.Scalar.Vehicle1										= 2.15
	NAOD.Scalar.Infantry2										= 2.0
	NAOD.Scalar.Vehicle2										= 2.0
	NAOD.Scalar.Air1												= 2.0
	NAOD.Scalar.Infantry3										= 0.2 
	NAOD.Scalar.Vehicle3										= 2.0
	NAOD.Scalar.Air2												= 2.0
	NAOD.Scalar.Vehicle4										= 0.2
	NAOD.Scalar.StormriderSwarm							= 5.5
	NAOD.Scalar.FanaticSquadSwarm						= 7.0
	NAOD.Scalar.LowHealthAvatarSwarm					= 8.0
	NAOD.Scalar.BoostedAvatarsSwarm					= 0.35
	NAOD.Scalar.AlienCustomizableVehicleSwarm		= 5.0
	NAOD.Scalar.RandomUnitCategorySwarm			= 2.0
	NAOD.Scalar.HammerheadZoneRaiderSwarm		= 5.0
	NAOD.Scalar.Tier1				= 3.0
	NAOD.Scalar.Tier2				= 2.1
	NAOD.Scalar.Tier3				= 2.0
	NAOD.Scalar.Tier4				= 0.2
	NAOD.Scalar.AntiAir				= 3.0
	NAOD.Scalar.AntiInfantry		= 3.0

	function NAOD.Spawner()
	  local ActionsOnObject = {}
	  if NAOD.Wave >= round(Max_Waves*0.80) and NAOD.Time >= 360 then tinsert(ActionsOnObject,NAOD.Veterancy3)
	  elseif NAOD.Wave >= round(Max_Waves*0.55) and NAOD.Time >= 240 then tinsert(ActionsOnObject,NAOD.Veterancy2)
	  elseif NAOD.Wave >= round(Max_Waves*0.25) and NAOD.Time >= 180 then tinsert(ActionsOnObject,NAOD.Veterancy1) 
	  end
	  if random(100)<25 then tinsert(ActionsOnObject,NAOD.RandomAttributesBoostTable[random(getn(NAOD.RandomAttributesBoostTable))]) end
	  if NAOD.Wave<=3 then 
		NAOD.CurrentRoundType="StandardSpawner"
		NAOD.StandardSpawner(number,ActionsOnObject)
	  elseif mod(NAOD.Wave,8)==0 then --endboss round
		NAOD.CurrentRoundType="Endboss"
		NAOD.Endboss(ceil(NAOD.Wave/8),ActionsOnObject)  
	  elseif mod(NAOD.Wave,7)==0 then   --repeat the most successfull round type
		NAOD.CurrentRoundType=NAOD.MemoryTable.RoundType[NAOD.GetNegativeCountChangeMaximumWave(NAOD.MemoryTable.AllTeams[NAOD.Personality.AdaptFocus])]
		NAOD.RoundType[NAOD.CurrentRoundType](ceil(NAOD.Wave/7),ActionsOnObject)
	  elseif mod(NAOD.Wave,5)==0 or random(100)<16 then --special round type                                
		NAOD.CurrentRoundType = GetRandomTableIndex(NAOD.RandomRoundType)
		RoundTypeFunction = NAOD.RandomRoundType[NAOD.CurrentRoundType]
		RoundTypeFunction(NAOD.SpawnFactor,ActionsOnObject)
	  elseif mod(NAOD.Wave,6)==0 or random(100)<16 then
		if random(100)<50 then NAOD.RandomUnitCategorySwarm(NAOD.SpawnFactor,ActionsOnObject)
		else NAOD.RandomUnitTypeSwarm(NAOD.SpawnFactor,ActionsOnObject) end
	  else	--normal round type
		NAOD.CurrentRoundType="StandardSpawner"
		NAOD.StandardSpawner(number,ActionsOnObject)
	  end
	  if random(20)<=1 and NAOD.Wave>3 then NAOD.EventTypeFunctions[NAOD.EventType[random(getn(NAOD.EventType))]]() end
	  if random(100)<=1 and NAOD.Wave>3 then NAOD.RareEventTypeFunctions[NAOD.RareEventType[random(getn(NAOD.RareEventType))]]() end
	end

end
