-- True Ghost Desync (No Heartbeat / No Velocity)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local SavedCFrame = nil
getgenv().IsGhostON = false

-- UI Setup
local oldUI = CoreGui:FindFirstChild("DesyncGhostMenu") or LocalPlayer.PlayerGui:FindFirstChild("DesyncGhostMenu")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DesyncGhostMenu"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 190, 0, 100)
MainFrame.Position = UDim2.new(0.5, -95, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.85, 0, 0, 45)
ToggleButton.Position = UDim2.new(0.075, 0, 0.3, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleButton.Text = "Ghost Lock: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

-- Toggle Handler
ToggleButton.MouseButton1Click:Connect(function()
	getgenv().IsGhostON = not getgenv().IsGhostON
	
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then return end

	if getgenv().IsGhostON then
		-- ၁။ မူလနေရာ CFrame ကို မှတ်မည်
		SavedCFrame = RootPart.CFrame
		
		-- ၂။ Server ဆီ Position Data မသွားအောင် Network ရပ်မည်
		if typeof(sethiddenproperty) == "function" then
			pcall(function()
				sethiddenproperty(RootPart, "NetworkIsSleeping", true)
			end)
		end
		
		ToggleButton.Text = "Ghost Lock: ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
		print("[GHOST]: ON - Server-side Position Frozen!")
	else
		-- ၃။ OFF လိုက်ပါက မူလ CFrame သို့ ပြန်ပို့မည်
		if SavedCFrame then
			RootPart.CFrame = SavedCFrame
			SavedCFrame = nil
		end
		
		-- ၄။ Network ပြန်ဖွင့်မည်
		if typeof(sethiddenproperty) == "function" then
			pcall(function()
				sethiddenproperty(RootPart, "NetworkIsSleeping", false)
			end)
		end
		
		ToggleButton.Text = "Ghost Lock: OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
		print("[GHOST]: OFF - Returned to Original Position!")
	end
end)
