-- main.lua (Fix & Auto-Detect Loader)

local CORE_URL = "https://raw.githubusercontent.com/BurmeseCracker/FakeLag/refs/heads/main/core.lua"
local GUI_URL  = "https://raw.githubusercontent.com/BurmeseCracker/FakeLag/refs/heads/main/gui.lua"

local function FetchModule(url, name)
    -- 1. HttpGet စစ်ဆေးခြင်း
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not response or response == "" then
        error("[" .. name .. "] Raw URL ကို ဖတ်မရပါ။ Link သေချာစစ်ပါ။")
    end
    
    -- 2. loadstring Compile စစ်ဆေးခြင်း
    local func, err = loadstring(response)
    if not func then
        error("[" .. name .. "] Syntax Error ရှိနေပါသည်။: " .. tostring(err))
    end
    
    -- 3. Execution & Return စစ်ဆေးခြင်း
    local result = func()
    if type(result) ~= "table" then
        error("[" .. name .. "] သည် Table မဟုတ်ဘဲ " .. type(result) .. " ဖြစ်နေသည်။ GitHub ဖိုင်အဆုံးတွင် 'return Core' သို့မဟုတ် 'return UI' ထည့်ထားပါသလား?")
    end
    
    return result
end

-- Module များကို ဘေးကင်းစွာ ခေါ်ယူခြင်း
local CoreModule = FetchModule(CORE_URL, "CoreModule")
local GuiModule  = FetchModule(GUI_URL, "GuiModule")

-- GUI ကို စတင်ခြင်း
if GuiModule and type(GuiModule.Create) == "function" then
    GuiModule.Create(function()
        return CoreModule.Toggle()
    end)
    print("Ghost Mode Successfully Loaded!")
else
    error("[GuiModule] ထဲတွင် Create ဆိုသည့် function ပါမလာပါ။ gui.lua ကို စစ်ပါ။")
end
