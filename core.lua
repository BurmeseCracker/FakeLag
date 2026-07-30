-- core.lua (Standalone Test & Auto-Respawn Fix)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local ghostConnection = nil
getgenv().GhostActive = false

local Core = {}

local function ClearConnection()
	if ghostConnection then
		ghostConnection:Disconnect()
		ghostConnection = nil
	end
end

function Core.Toggle()
	getgenv().GhostActive = not getgenv().GhostActive
	
	if getgenv().GhostActive then
		print("[GHOST MODE]: Activated (ON)")
		
		-- ယခင် ချိတ်ဆက်မှုဟောင်းများ ဖျက်မည်
		ClearConnection()

		-- Loop စတင်ခြင်း
		ghostConnection = RunService.Heartbeat:Connect(function()
			local Character = Player.Character
			local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			-- Player သေနေချိန် သို့မဟုတ် Respawn ဖြစ်နေချိန် စောင့်ဆိုင်းခြင်း
			if not Character or not RootPart or not Character:IsDescendantOf(workspace) then
				return
			end
			
			-- Humanoid သေ မသေ စစ်ဆေးခြင်း
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid and Humanoid.Health <= 0 then
				return
			end

			-- Assembly Velocity ကို Zero လုပ်ပြီး Desync ဖြစ်စေခြင်း
			for _, part in ipairs(Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end

			-- Safe sethiddenproperty
			if typeof(sethiddenproperty) == "function" then
				pcall(function()
					sethiddenproperty(RootPart, "NetworkIsSleeping", true)
				end)
			end
		end)
	else
		print("[GHOST MODE]: Deactivated (OFF)")
		ClearConnection()

		local Character = Player.Character
		local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		if typeof(sethiddenproperty) == "function" and RootPart then
			pcall(function()
				sethiddenproperty(RootPart, "NetworkIsSleeping", false)
			end)
		end
	end

	return getgenv().GhostActive
end

-- Player Respawn ဖြစ်သွားရင် Connection ကို မပျက်စေဘဲ Auto Reset လုပ်ပေးခြင်း
Player.CharacterAdded:Connect(function()
	if getgenv().GhostActive then
		print("[GHOST MODE]: Player Respawned - Auto Re-applying Ghost Mode")
		ClearConnection()
		task.wait(1) -- Character အသစ်သေချာ Load ဖြစ်သည်အထိ စောင့်မည်
		Core.Toggle() -- Switch Off & On
		Core.Toggle()
	end
end)

return Core
