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
		if not Character or not RootPart then 
			getgenv().GhostActive = false
			return false 
		end

		ghostConnection = RunService.Heartbeat:Connect(function()
			if not Character or not Character:Parent or not RootPart or not RootPart:IsDescendantOf(workspace) then
				if ghostConnection then ghostConnection:Disconnect() end
				getgenv().GhostActive = false
				return
			end
			
			if sethiddenproperty then
				sethiddenproperty(RootPart, "NetworkIsSleeping", true)
			end
			
			for _, part in ipairs(Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new(0, 0, 0)
					part.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
		end)
	else
		if ghostConnection then
			ghostConnection:Disconnect()
			ghostConnection = nil
		end
		
		if RootPart and sethiddenproperty then
			sethiddenproperty(RootPart, "NetworkIsSleeping", false)
		end
	end

	return getgenv().GhostActive
end

return Core
