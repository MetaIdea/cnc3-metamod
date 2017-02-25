
do

local ModScriptName="script.ExampleScript.lua"
ModScripts["status"]["script.ExampleScript.lua"] = 0
ModScripts.RegisterRepeatFunction("ExampleScript.HelloWorld()",ModScriptName)

ExampleScript={}

function ExampleScript.HelloWorld()
  print("hello world")
end

end
