-- MilkUI v1.0
-- A creamy-dark, e-girl styled UI library for Roblox (Luau)

local TweenService = game:GetService("TweenService")

local MilkUI = {}
MilkUI.__index = MilkUI

-- Default theme settings
MilkUI.Theme = {
    BackgroundColor = Color3.fromRGB(30, 30, 35),
    AccentColor = Color3.fromRGB(255, 182, 193),  -- pastel pink
    TextColor = Color3.fromRGB(230, 230, 235),
    HoverDarken = 0.1,
    CornerRadius = UDim.new(0, 12),
    ShadowTransparency = 0.5,
}

-- Utility: apply rounded corners
local function applyCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or MilkUI.Theme.CornerRadius
    corner.Parent = frame
end

-- Utility: create drop shadow
local function applyShadow(frame)
    local shadow = Instance.new("UIShadow")
    shadow.BlurSize = 8
    shadow.Color = Color3.new(0, 0, 0)
    shadow.Transparency = MilkUI.Theme.ShadowTransparency
    shadow.Parent = frame
end

-- Create main window
function MilkUI.new(title)
    local self = setmetatable({}, MilkUI)

    -- Screen GUI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MilkUI" .. math.random(1,9999)
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main frame
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 450, 0, 320)
    main.Position = UDim2.new(0.5, -225, 0.5, -160)
    main.BackgroundColor3 = MilkUI.Theme.BackgroundColor
    main.BorderSizePixel = 0
    main.Parent = screenGui

    applyCorner(main)
    applyShadow(main)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = MilkUI.Theme.AccentColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title or "Milk UI"
    titleLabel.Parent = titleBar

    -- Content holder
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 55)
    content.BackgroundTransparency = 1
    content.Parent = main

    self.Root = screenGui
    self.Content = content
    return self
end

-- Create Button
function MilkUI:Button(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = MilkUI.Theme.BackgroundColor:Lerp(Color3.new(0,0,0), MilkUI.Theme.HoverDarken)
    btn.Text = text or "Button"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = MilkUI.Theme.TextColor
    btn.BorderSizePixel = 0
    btn.Parent = self.Content

    applyCorner(btn)
    applyShadow(btn)

    -- Hover effect
    btn.MouseEnter:Connect(function()
        local darker = btn.BackgroundColor3:Lerp(Color3.new(0,0,0), MilkUI.Theme.HoverDarken * 2)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = darker}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = MilkUI.Theme.BackgroundColor:Lerp(Color3.new(0,0,0), MilkUI.Theme.HoverDarken)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return btn
end

-- Create Label
function MilkUI:Label(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansItalic
    lbl.TextSize = 16
    lbl.TextColor3 = MilkUI.Theme.TextColor
    lbl.Text = text or "Label"
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = self.Content
    return lbl
end

-- Create Toggle
function MilkUI:Toggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    frame.Parent = self.Content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.TextColor3 = MilkUI.Theme.TextColor
    lbl.Text = text or "Toggle"
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 34, 0, 18)
    button.Position = UDim2.new(1, -40, 0.5, -9)
    button.BackgroundColor3 = default and MilkUI.Theme.AccentColor or MilkUI.Theme.BackgroundColor
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = frame

    applyCorner(button, UDim.new(0,9))

    local state = default or false
    button.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = state and MilkUI.Theme.AccentColor or MilkUI.Theme.BackgroundColor}):Play()
        pcall(callback, state)
    end)

    return frame
end

-- Create Slider
function MilkUI:Slider(labelText, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = self.Content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextColor3 = MilkUI.Theme.TextColor
    lbl.Text = string.format("%s: %d", labelText, default)
    lbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = MilkUI.Theme.BackgroundColor:Lerp(Color3.new(0,0,0), MilkUI.Theme.HoverDarken)
    sliderBg.Parent = frame
    applyCorner(sliderBg, UDim.new(0,3))

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.BackgroundColor3 = MilkUI.Theme.AccentColor
    sliderFill.Parent = sliderBg
    applyCorner(sliderFill, UDim.new(0,3))

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(min + (max-min) * pos)
        lbl.Text = string.format("%s: %d", labelText, value)
        pcall(callback, value)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    sliderBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    return frame
end

-- Return library
return MilkUI

