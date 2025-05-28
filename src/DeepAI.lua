local Milk = {}
Milk.__index = Milk

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Main UI Folder
local UIName = "MilkUI"
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UIName
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark base
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundTransparency = 0.2

-- Creamy accent color
local AccentColor = Color3.fromRGB(255, 192, 203) -- Light pinkish hue for a cute vibe

-- Title Label
local Title = Instance.new("TextLabel")
Title.Text = "Milk Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
CloseButton.TextColor3 = Color3.fromRGB(20, 20, 20)
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    -- Animate closing
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Container for buttons
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- Function to create styled buttons
function Milk:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 18
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = ButtonContainer
    Button.LayoutOrder = #ButtonContainer:GetChildren()

    -- Hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)

    -- Click callback
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

-- Example: Adding a toggle button
local function CreateToggle(name, default, callback)
    local toggleState = default or false

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 0, 40)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Font = Enum.Font.GothamMedium
    ToggleButton.TextSize = 18
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 18
    label.Parent = ToggleButton

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0.75, 0, 0.5, -10)
    indicator.BackgroundColor3 = toggleState and AccentColor or Color3.fromRGB(50, 50, 50)
    indicator.BorderSizePixel = 0
    indicator.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        indicator.BackgroundColor3 = toggleState and AccentColor or Color3.fromRGB(50, 50, 50)
        if callback then callback(toggleState) end
    end)

    ToggleButton.Parent = ButtonContainer
end

-- Example usage
Milk:CreateButton("Say Hi", function()
    print("Hi from Milk!")
end)

CreateToggle("Enable Feature", false, function(state)
    print("Feature enabled:", state)
end)

return Milk
