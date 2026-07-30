-- main.lua
local CORE_URL = "https://raw.githubusercontent.com/BurmeseCracker/FakeLag/refs/heads/main/core.lua"
local GUI_URL  = "https://raw.githubusercontent.com/BurmeseCracker/FakeLag/refs/heads/main/gui.lua"

local function FetchModule(url, name)
	local success, response = pcall(function()
		return game:HttpGet(url)
	end)
	
	if not success or not response or response == "" then
		error("[" .. name .. "] Raw URL ကို ဖတ်မရပါ။ Link သေချာစစ်ပါ။")
	end
	
	local func, err = loadstring(response)
	if not func then
		error("[" .. name .. "] Syntax Error ရှိနေပါသည်။: " .. tostring(err))
	end
	
	return func()
end

local CoreModule = FetchModule(CORE_URL, "CoreModule")
local GuiModule  = FetchModule(GUI_URL, "GuiModule")

if type(GuiModule) == "table" and type(GuiModule.Create) == "function" then
	GuiModule.Create(function()
		return CoreModule.Toggle()
	end)
	print("Ghost Mode Loaded Successfully!")
end
