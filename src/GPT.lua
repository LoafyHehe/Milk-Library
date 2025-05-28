-- MilkUI v1.1
-- A creamy-dark, e-girl styled UI library for Roblox (Luau)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local MilkUI = {}
MilkUI.__index = MilkUI

-- Theme settings
MilkUI.Theme = {
    BackgroundColor = Color3.fromRGB(30, 30, 35),
    AccentColor = Color3.fromRGB(255, 182, 193),  -- pastel pink
    TextColor = Color3.fromRGB(230, 230, 235),
    HoverDarken = 0.1,
    CornerRadius = UDim.new(0, 12),
    ShadowTransparency = 0.5,
    SoundId = "rbxassetid://9118823102" -- Soft UI click
}

-- Utility: corners, shadows, sound
local function applyCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or MilkUI.Theme.CornerRadius
    corner.Parent = frame
end

local function applyShadow(frame)
    local shadow = Instance.new("UIShadow")
    shadow.BlurSize = 8
    shadow.Color = Color3.new(0, 0, 0)
    shadow.Transparency = MilkUI.Theme.ShadowTransparency
    shadow.Parent = frame
end

local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = MilkUI.Theme.SoundId
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    game.Debris:AddItem(sound, 2)
end

-- Create main window
function MilkUI.new(title)
    local self = setmetatable({}, MilkUI)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MilkUI" .. math.random(1,9999)
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 450, 0, 320)
    main.Position = UDim2.new(0.5, -225, 0.5, -160)
    main.BackgroundColor3 = MilkUI.Theme.BackgroundColor
    main.BorderSizePixel = 0
    main.Parent = screenGui

    applyCorner(main)
    applyShadow(main)

    -- Drag logic
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

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

-- [Button, Label, Toggle, Slider — same as before, with playClickSound() added in click functions]
-- (skip unchanged parts for brevity)

-- Dropdown
function MilkUI:Dropdown(text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = MilkUI.Theme.BackgroundColor
    frame.Parent = self.Content
    applyCorner(frame)
    applyShadow(frame)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text or "Select Option"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = MilkUI.Theme.TextColor
    btn.Parent = frame

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 0)
    list.BackgroundColor3 = MilkUI.Theme.BackgroundColor
    list.ClipsDescendants = true
    list.Visible = false
    list.Parent = frame
    applyCorner(list)
    applyShadow(list)

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 16
        optBtn.TextColor3 = MilkUI.Theme.TextColor
        optBtn.Parent = list

        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            list.Visible = false
            list:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.2, true)
            pcall(callback, opt)
            playClickSound()
        end)
    end

    btn.MouseButton1Click:Connect(function()
        list.Visible = true
        list:TweenSize(UDim2.new(1, 0, 0, #options * 30), "Out", "Quad", 0.25, true)
        playClickSound()
    end)

    return frame
end

-- Keybind
function MilkUI:Keybind(labelText, defaultKey, callback)
    local key = defaultKey or Enum.KeyCode.F
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = self.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText .. " [" .. key.Name .. "]"
    label.TextColor3 = MilkUI.Theme.TextColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 1, 0)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Text = "Set Key"
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextColor3 = MilkUI.Theme.AccentColor
    button.BackgroundTransparency = 1
    button.Parent = frame

    local listening = false
    button.MouseButton1Click:Connect(function()
        listening = true
        button.Text = "Press..."
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and listening and input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode
            label.Text = labelText .. " [" .. key.Name .. "]"
            button.Text = "Set Key"
            listening = false
        elseif not processed and input.KeyCode == key then
            pcall(callback)
            playClickSound()
        end
    end)

    return frame
end

return MilkUI
