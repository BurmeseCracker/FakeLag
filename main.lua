-- main.lua (Main Script Loader)

-- ⚠️ သင့် GitHub ရဲ့ Raw URL များဖြင့် အစားထိုးပါ
local CORE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/core.lua"
local GUI_URL  = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/gui.lua"

-- GitHub မှ Module များကို Fetch လုပ်ယူခြင်း
local CoreModule = loadstring(game:HttpGet(CORE_URL))()
local GuiModule  = loadstring(game:HttpGet(GUI_URL))()

-- GUI ကို စတင်ဆွဲပြီး Core Logic Function ကို Callback အဖြစ် ချိတ်ဆက်ခြင်း
GuiModule.Create(function()
    return CoreModule.Toggle()
end)

print("Main Script Loaded Successfully!")
