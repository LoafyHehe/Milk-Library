local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("Tween")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function createUI()
    local UI = {}
    -- Main UI container
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "CustomUI"
    screenGui.ResetOnSpawn = false

    local window = Instance.new("Frame", screenGui)
    window.Size = UDim2.new(0, 700, 0, 500)
    window.Position = UDim2.new(0.5, -350, 0.5, -250)
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    window.BorderSizePixel = 0
    window.ClipsDescendants = true

    -- Title Bar (draggable)
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(15,15,15)
    titleBar.BorderSizePixel = 0

    local titleText = Instance.new("TextLabel", titleBar)
    titleText.Text = "My Loader UI"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 20
    titleText.TextColor3 = Color3.fromRGB(255,255,255)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1,0,1,0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.PaddingLeft = UDim.new(0,10)

    -- Close button
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0,50,0,50)
    closeBtn.Position = UDim2.new(1,-50,0,0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Color3.fromRGB(20,20,20)

    -- Minimize button
    local minBtn = Instance.new("TextButton", titleBar)
    minBtn.Size = UDim2.new(0,50,0,50)
    minBtn.Position = UDim2.new(1,-100,0,0)
    minBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)
    minBtn.Text = "_"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.TextColor3 = Color3.fromRGB(20,20,20)

    -- Content area (tabs & elements)
    local content = Instance.new("Frame", window)
    content.Size = UDim2.new(1, 0, 1, -50)
    content.Position = UDim2.new(0, 0, 0, 50)
    content.BackgroundColor3 = Color3.fromRGB(25,25,25)

    -- Tabs container
    local tabContainer = Instance.new("Frame", content)
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 0, 0, 0)

    -- Pages container
    local pagesContainer = Instance.new("Frame", content)
    pagesContainer.Size = UDim2.new(1, 0, 1, -40)
    pagesContainer.Position = UDim2.new(0, 0, 0, 40)

    -- Make window draggable
    local dragging = false
    local dragStart
    local startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Close button
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(window, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
        wait(0.3)
        window:Destroy()
    end)

    -- Minimize toggle
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(pagesContainer, TweenInfo.new(0.3), {Size=UDim2.new(1,0,0,0)}):Play()
        else
            TweenService:Create(pagesContainer, TweenInfo.new(0.3), {Size=UDim2.new(1,0,1,-40)}):Play()
        end
    end)

    -- Methods for adding tabs & pages
    local pages = {}
    function UI:CreateTab(name)
        local tabButton = Instance.new("TextButton", tabContainer)
        tabButton.Text = name
        tabButton.Size = UDim2.new(0, 120, 1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 16
        tabButton.TextColor3 = Color3.fromRGB(255,255,255)

        local pageFrame = Instance.new("Frame", pagesContainer)
        pageFrame.Size = UDim2.new(1,0,1,0)
        pageFrame.Position = UDim2.new(0,0,0,0)
        pageFrame.BackgroundTransparency = 1
        pageFrame.Visible = false

        -- Tab button click
        tabButton.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do
                p.Frame.Visible = false
                p.Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
            end
            pageFrame.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
        end)

        table.insert(pages, {Button=tabButton, Frame=pageFrame})
        -- default to first tab
        if #pages == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
            pageFrame.Visible = true
        end

        -- Return page object for adding elements
        local pageObj = {}
        function pageObj:AddButton(text, callback)
            local btn = Instance.new("TextButton", pageFrame)
            btn.Size = UDim2.new(0, 180, 0, 40)
            btn.Position = UDim2.new(0, 10, 0, (#pageFrame:GetChildren() -1)*50 + 10)
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BorderSizePixel = 0

            btn.MouseButton1Click:Connect(function()
                callback()
            end)
            return btn
        end

        function pageObj:AddToggle(name, default, callback)
            local toggleFrame = Instance.new("Frame", pageFrame)
            toggleFrame.Size = UDim2.new(0, 200, 0, 40)
            toggleFrame.Position = UDim2.new(0, 10, 0, (#pageFrame:GetChildren()-1)*50 + 10)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)

            local label = Instance.new("TextLabel", toggleFrame)
            label.Size = UDim2.new(0, 150, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255,255,255)

            local switch = Instance.new("Frame", toggleFrame)
            switch.Size = UDim2.new(0, 50, 0, 25)
            switch.Position = UDim2.new(0, 150, 0, 7)
            switch.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            switch.BorderSizePixel = 0
            switch.Name = "Switch"

            local indicator = Instance.new("Frame", switch)
            indicator.Size = UDim2.new(0, 20, 0, 20)
            indicator.Position = UDim2.new(0, default and 25 or 5, 0, 2)
            indicator.BackgroundColor3 = Color3.fromRGB(255,255,255)
            indicator.BorderSizePixel = 0
            indicator.Name = "Indicator"

            switch.MouseButton1Click:Connect(function()
                local current = indicator.Position
                local toRight = current.X.Scale < 0.5
                local targetPos = toRight and UDim2.new(0,25,0,2) or UDim2.new(0,5,0,2)
                local targetColor = toRight and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                TweenService:Create(indicator, TweenInfo.new(0.3), {Position=targetPos}):Play()
                TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3=targetColor}):Play()
                callback(toRight)
            end)

            local toggleObj = {
                Set = function(state)
                    local targetPos = state and UDim2.new(0,25,0,2) or UDim2.new(0,5,0,2)
                    local targetColor = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                    TweenService:Create(indicator, TweenInfo.new(0.3), {Position=targetPos}):Play()
                    TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3=targetColor}):Play()
                end,
                Get = function() 
                    return indicator.Position.X.Scale > 0.5
                end,
            }
            return toggleObj
        end

        -- You can add more elements: sliders, dropdowns, color pickers, keybinds, labels, paragraphs, etc.

        return pageObj
    end
    return UI
end

local UI = createUI()

-- Usage:
local tab1 = UI:CreateTab("Main")
local btn1 = tab1:AddButton("Say Hi", function() print("Hi!") end)
local toggle1 = tab1:AddToggle("Enable Feature", false, function(state) print("Feature:", state) end)

local tab2 = UI:CreateTab("Settings")
local toggle2 = tab2:AddToggle("Dark Mode", false, function(state) print("Dark Mode:", state) end)

-- Add more elements as needed...

-- Optional: Save config, themes, notifications, etc.

return UI
