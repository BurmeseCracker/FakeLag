-- core.lua (Desync Logic Engine)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local ghostConnection = nil
getgenv().GhostActive = false

local Core = {}

function Core.Toggle()
	getgenv().GhostActive = not getgenv().GhostActive
	
	local Character = Player.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if getgenv().GhostActive then
		if not Character then 
			getgenv().GhostActive = false
			return false 
		end
		
		if not RootPart then 
			getgenv().GhostActive = false
			return false 
		end

		ghostConnection = RunService.Heartbeat:Connect(function()
			if not Character or not Character:Parent or not RootPart or not RootPart:IsDescendantOf(workspace) then
				if ghostConnection then 
					ghostConnection:Disconnect() 
				end
				getgenv().GhostActive = false
				return
			end
			
			-- Assembly Velocity ကို Zero လုပ်ပြီး Desync ဖြစ်စေခြင်း
			for _, part in ipairs(Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end
			
			-- Executor Compatibility Check
			if typeof(sethiddenproperty) == "function" then
				pcall(function()
					sethiddenproperty(RootPart, "NetworkIsSleeping", true)
				end)
			end
		end)
	else
		if ghostConnection then
			ghostConnection:Disconnect()
			ghostConnection = nil
		end
		
		if typeof(sethiddenproperty) == "function" and RootPart then
			pcall(function()
				sethiddenproperty(RootPart, "NetworkIsSleeping", false)
			end)
		end
	end

	return getgenv().GhostActive
end

return Core
