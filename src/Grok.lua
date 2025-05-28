local MilkUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Core UI Setup
function MilkUI:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MilkUI"
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 600, 0, 400)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42) -- Dark creamy base
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = MainFrame

	local TitleBar = Instance.new("Frame")
	TitleBar.Size = UDim2.new(1, 0, 0, 40)
	TitleBar.BackgroundColor3 = Color3.fromRGB(255, 245, 225) -- Creamy accent
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -10, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title or "Milk Hub"
	TitleLabel.TextColor3 = Color3.fromRGB(216, 191, 216) -- Pastel purple
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.FredokaOne
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TitleBar

	-- Dragging functionality
	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)
	TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(0, 120, 1, -40)
	TabContainer.Position = UDim2.new(0, 0, 0, 40)
	TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 54)
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.FillDirection = Enum.FillDirection.Vertical
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabContainer

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, -120, 1, -40)
	ContentFrame.Position = UDim2.new(0, 120, 0, 40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = MainFrame

	local window = {Tabs = {}, ContentFrame = ContentFrame}
	return window
end

-- Tab Creation
function MilkUI:CreateTab(window, name)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(1, -10, 0, 30)
	TabButton.Position = UDim2.new(0, 5, 0, 0)
	TabButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Pastel pink
	TabButton.Text = name
	TabButton.TextColor3 = Color3.fromRGB(255, 245, 225)
	TabButton.TextSize = 14
	TabButton.Font = Enum.Font.FredokaOne
	TabButton.Parent = window.MainFrame:FindFirstChild("TabContainer")

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = TabButton

	local Content = Instance.new("ScrollingFrame")
	Content.Size = UDim2.new(1, 0, 1, 0)
	Content.Position = UDim2.new(0, 0, 0, 0)
	Content.BackgroundTransparency = 1
	Content.ScrollBarThickness = 4
	Content.ScrollBarImageColor3 = Color3.fromRGB(255, 182, 193)
	Content.Visible = false
	Content.Parent = window.ContentFrame

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Padding = UDim.new(0, 10)
	ContentLayout.Parent = Content

	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(window.Tabs) do
			tab.Content.Visible = false
		end
		Content.Visible = true
		local tween = TweenService:Create(
			TabButton,
			TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{BackgroundColor3 = Color3.fromRGB(216, 191, 216)}
		)
		tween:Play()
	end)

	local tab = {Content = Content}
	table.insert(window.Tabs, tab)
	return tab
end

-- Custom Button
function MilkUI:CreateButton(tab, name, callback)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -20, 0, 40)
	Button.Position = UDim2.new(0, 10, 0, 0)
	Button.BackgroundColor3 = Color3.fromRGB(255, 245, 225)
	Button.Text = name .. " ♡"
	Button.TextColor3 = Color3.fromRGB(30, 30, 42)
	Button.TextSize = 16
	Button.Font = Enum.Font.FredokaOne
	Button.Parent = tab.Content

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Button

	local HeartEffect = Instance.new("ImageLabel")
	HeartEffect.Size = UDim2.new(0, 20, 0, 20)
	HeartEffect.Position = UDim2.new(1, -30, 0.5, -10)
	HeartEffect.BackgroundTransparency = 1
	HeartEffect.Image = "rbxassetid://1234567890" -- Replace with heart decal ID
	HeartEffect.Visible = false
	HeartEffect.Parent = Button

	Button.MouseEnter:Connect(function()
		TweenService:Create(
			Button,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine),
			{BackgroundColor3 = Color3.fromRGB(255, 182, 193)}
		):Play()
		HeartEffect.Visible = true
	end)
	Button.MouseLeave:Connect(function()
		TweenService:Create(
			Button,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine),
			{BackgroundColor3 = Color3.fromRGB(255, 245, 225)}
		):Play()
		HeartEffect.Visible = false
	end)

	Button.MouseButton1Click:Connect(function()
		if callback then callback() end
		local sparkle = Instance.new("ImageLabel")
		sparkle.Size = UDim2.new(0, 30, 0, 30)
		sparkle.Position = UDim2.new(0.5, -15, 0.5, -15)
		sparkle.BackgroundTransparency = 1
		sparkle.Image = "rbxassetid://9876543210" -- Replace with sparkle decal ID
		sparkle.Parent = Button
		TweenService:Create(
			sparkle,
			TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 50, 0, 50), ImageTransparency = 1}
		):Play()
		game.Debris:AddItem(sparkle, 0.5)
	end)
end

-- Custom Toggle
function MilkUI:CreateToggle(tab, name, default, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
	ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 54)
	ToggleFrame.Parent = tab.Content

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ToggleFrame

	local ToggleLabel = Instance.new("TextLabel")
	ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
	ToggleLabel.BackgroundTransparency = 1
	ToggleLabel.Text = name
	ToggleLabel.TextColor3 = Color3.fromRGB(255, 245, 225)
	ToggleLabel.TextSize = 16
	ToggleLabel.Font = Enum.Font.FredokaOne
	ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	ToggleLabel.Parent = ToggleFrame

	local ToggleButton = Instance.new("ImageButton")
	ToggleButton.Size = UDim2.new(0, 40, 0, 20)
	ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
	ToggleButton.BackgroundColor3 = default and Color3.fromRGB(255, 182, 193) or Color3.fromRGB(100, 100, 120)
	ToggleButton.Image = "rbxassetid://4567891230" -- Replace with star icon ID
	ToggleButton.Parent = ToggleFrame

	local state = default
	ToggleButton.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(
			ToggleButton,
			TweenInfo.new(0.2, Enum.EasingStyle.Sine),
			{BackgroundColor3 = state and Color3.fromRGB(255, 182, 193) or Color3.fromRGB(100, 100, 120)}
		):Play()
		if callback then callback(state) end
	end)
end

-- Custom Slider
function MilkUI:CreateSlider(tab, name, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, -20, 0, 50)
	SliderFrame.Position = UDim2.new(0, 10, 0, 0)
	SliderFrame.BackgroundTransparency = 1
	SliderFrame.Parent = tab.Content

	local SliderLabel = Instance.new("TextLabel")
	SliderLabel.Size = UDim2.new(1, 0, 0, 20)
	SliderLabel.BackgroundTransparency = 1
	SliderLabel.Text = name .. ": " .. default
	SliderLabel.TextColor3 = Color3.fromRGB(255, 245, 225)
	SliderLabel.TextSize = 16
	SliderLabel.Font = Enum.Font.FredokaOne
	SliderLabel.Parent = SliderFrame

	local SliderBar = Instance.new("Frame")
	SliderBar.Size = UDim2.new(1, 0, 0, 10)
	SliderBar.Position = UDim2.new(0, 0, 0, 30)
	SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 54)
	SliderBar.Parent = SliderFrame

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = SliderBar

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 191, 216))
	}
	Gradient.Parent = SliderBar

	local SliderHandle = Instance.new("ImageButton")
	SliderHandle.Size = UDim2.new(0, 20, 0, 20)
	SliderHandle.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
	SliderHandle.BackgroundTransparency = 1
	SliderHandle.Image = "rbxassetid://6543210987" -- Replace with kawaii handle ID
	SliderHandle.Parent = SliderBar

	local dragging = false
	SliderHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	SliderHandle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouseX = input.Position.X
			local barX = SliderBar.AbsolutePosition.X
			local barWidth = SliderBar.AbsoluteSize.X
			local relativeX = math.clamp((mouseX - barX) / barWidth, 0, 1)
			local value = min + (max - min) * relativeX
			value = math.floor(value + 0.5)
			SliderHandle.Position = UDim2.new(relativeX, -10, 0, -5)
			SliderLabel.Text = name .. ": " .. value
			if callback then callback(value) end
		end
	end)
end

return MilkUI
