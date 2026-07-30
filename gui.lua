-- gui.lua (User Interface)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local UI = {}

function UI.Create(onToggleCallback)
	-- ၁။ UI အဟောင်းရှိရင် ရှင်းထုတ်မည် (CoreGui သို့မဟုတ် PlayerGui ထဲကပါ စစ်ပေးသည်)
	local oldUI = CoreGui:FindFirstChild("GitHubGhostGui") or (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("GitHubGhostGui"))
	if oldUI then
		oldUI:Destroy()
	end

	-- ၂။ ScreenGui ဖန်တီးခြင်း
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GitHubGhostGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999999 -- အခြား UI များ၏ အပေါ်ဆုံးတွင် ပေါ်စေရန်

	-- ၃။ Universal Parenting Logic (Executor အားလုံးတွင် မြင်ရစေရန်)
	if gethui then
		ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui
	else
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	-- ၄။ Main Panel Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 220, 0, 110)
	MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame

	-- ၅။ UI Title
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.BackgroundTransparency = 1
	Title.Text = "Ghost Mode (Fake Lag)"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.Font = Enum.Font.SourceSansBold
	Title.Parent = MainFrame

	-- ၆။ Toggle Button
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "ToggleButton"
	ToggleButton.Size = UDim2.new(0.85, 0, 0, 45)
	ToggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	ToggleButton.Text = "Ghost Mode: OFF"
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.TextSize = 14
	ToggleButton.Font = Enum.Font.SourceSansSemibold
	ToggleButton.Parent = MainFrame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = ToggleButton

	-- ၇။ Toggle Logic
	ToggleButton.MouseButton1Click:Connect(function()
		if onToggleCallback then
			local state = onToggleCallback()
			if state then
				ToggleButton.Text = "Ghost Mode: ON"
				ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
			else
				ToggleButton.Text = "Ghost Mode: OFF"
				ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
			end
		end
	end)
end

return UI
