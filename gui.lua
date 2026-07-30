-- gui.lua (User Interface)
local CoreGui = game:GetService("CoreGui")

local UI = {}

function UI.Create(onToggleCallback)
	if CoreGui:FindFirstChild("GitHubGhostGui") then
		CoreGui.GitHubGhostGui:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GitHubGhostGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui

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

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.BackgroundTransparency = 1
	Title.Text = "Ghost Mode (Fake Lag)"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.Font = Enum.Font.SourceSansBold
	Title.Parent = MainFrame

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
