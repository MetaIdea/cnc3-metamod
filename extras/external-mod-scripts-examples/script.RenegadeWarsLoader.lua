--for future Meta Mod support
do

	local ModScriptName="script.RenegadeWarsLoader.lua"
	ModScripts["status"]["script.RenegadeWarsLoader.lua"] = 1	
	local RenegadeWarsScriptFile="RenegadeWars.lua"

	if EvaluateCondition("COUNTER_COUNTER","RENWARS",CompareTable["EQ"],CounterTable[1]) then
	  dofile(GetFilePath() .. RenegadeWarsScriptFile)  --rename the scripts.lua from renegade wars to this filename and put it to the MetaModIO folder
    else return end

end
