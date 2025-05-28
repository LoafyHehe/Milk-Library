-- Advanced Rayfield-like Loader with Draggable, Animations, and Features
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("Tween")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateMainUI()
    -- Main UI Frame
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "AdvancedLoaderUI"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Main.BackgroundTransparency = 0.2
    Main.ClipsDescendants = true

    -- Title Bar (Draggable)
    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Name = "TitleBar"

    local TitleText = Instance.new("TextLabel", TitleBar)
    TitleText.Text = "🍼 Milk Hub"
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 24
    TitleText.TextColor3 = Color3.fromRGB(255,255,255)
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1,0,1,0)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.PaddingLeft = UDim.new(0,10)

    -- Close Button
    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Size = UDim2.new(0,50,0,50)
    CloseBtn.Position = UDim2.new(1,-50,0,0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255,192,203)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.TextColor3 = Color3.fromRGB(20,20,20)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton", TitleBar)
    MinBtn.Size = UDim2.new(0,50,0,50)
    MinBtn.Position = UDim2.new(1,-100,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)
    MinBtn.Text = "_"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 20
    MinBtn.TextColor3 = Color3.fromRGB(20,20,20)

    -- Content Frame
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,0,1,-50)
    Content.Position = UDim2.new(0,0,0,50)
    Content.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Content.BorderSizePixel = 0

    -- Draggable Logic
    local dragging = false
    local dragInput, dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Close Button Functionality
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        wait(0.3)
        Main:Destroy()
    end)

    -- Minimize / Maximize
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Content, TweenInfo.new(0.3), {Size = UDim2.new(1,0,0,0)}):Play()
        else
            TweenService:Create(Content, TweenInfo.new(0.3), {Size = UDim2.new(1,0,1,-50)}):Play()
        end
    end)

    -- Utility: fade in the window
    Main.BackgroundTransparency = 1
    TweenService:Create(Main, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

    -- Return references for further UI creation
    return {
        Main = Main,
        Content = Content,
        TitleBar = TitleBar,
        Tween = TweenService,
        UI = {Content=Content, Main=Main}
    }
end

local UI = CreateMainUI()

-- Make the window draggable (already done above)

-- Add a sample button
local function createButton(text, callback)
    local btn = Instance.new("TextButton", UI.Content)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 20)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    return btn
end

-- Example: Add a button that prints
createButton("Say Hello", function()
    print("Hello from the advanced loader!")
    -- You can add more UI elements dynamically here
end)

-- Example: toggle visibility with hotkey
local hidden = false
local function toggleVisibility()
    hidden = not hidden
    if hidden then
        UI.Main.Visible = false
    else
        UI.Main.Visible = true
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        toggleVisibility()
    end
end)

-- Optional: animate window on load
local function fadeIn()
    UI.Main.BackgroundTransparency = 1
    UI.Tween:Create(UI.Main, TweenInfo.new(0.5), {BackgroundTransparency=0}):Play()
end
fadeIn()

-- You can add more features: tabs, sections, notifications, etc.
