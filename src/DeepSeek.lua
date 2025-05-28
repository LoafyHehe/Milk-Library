--[[
    Milk UI Library
    by [Your Name]

    A creamy dark e-girl style UI library
]]

local MilkLibrary = {
    Flags = {},
    Theme = {
        Default = {
            -- Creamy dark e-girl color scheme
            TextColor = Color3.fromRGB(255, 220, 240),
            
            Background = Color3.fromRGB(40, 30, 40),
            Topbar = Color3.fromRGB(50, 35, 50),
            Shadow = Color3.fromRGB(30, 20, 30),
            
            NotificationBackground = Color3.fromRGB(35, 25, 35),
            NotificationActionsBackground = Color3.fromRGB(240, 220, 240),
            
            TabBackground = Color3.fromRGB(80, 60, 80),
            TabStroke = Color3.fromRGB(90, 70, 90),
            TabBackgroundSelected = Color3.fromRGB(220, 180, 220),
            TabTextColor = Color3.fromRGB(255, 220, 240),
            SelectedTabTextColor = Color3.fromRGB(60, 40, 60),
            
            ElementBackground = Color3.fromRGB(50, 40, 50),
            ElementBackgroundHover = Color3.fromRGB(60, 50, 60),
            SecondaryElementBackground = Color3.fromRGB(40, 30, 40),
            ElementStroke = Color3.fromRGB(70, 60, 70),
            SecondaryElementStroke = Color3.fromRGB(60, 50, 60),
            
            SliderBackground = Color3.fromRGB(220, 150, 220),
            SliderProgress = Color3.fromRGB(240, 170, 240),
            SliderStroke = Color3.fromRGB(250, 190, 250),
            
            ToggleBackground = Color3.fromRGB(45, 35, 45),
            ToggleEnabled = Color3.fromRGB(240, 150, 240),
            ToggleDisabled = Color3.fromRGB(110, 90, 110),
            ToggleEnabledStroke = Color3.fromRGB(250, 170, 250),
            ToggleDisabledStroke = Color3.fromRGB(135, 115, 135),
            ToggleEnabledOuterStroke = Color3.fromRGB(120, 100, 120),
            ToggleDisabledOuterStroke = Color3.fromRGB(75, 65, 75),
            
            DropdownSelected = Color3.fromRGB(60, 50, 60),
            DropdownUnselected = Color3.fromRGB(50, 40, 50),
            
            InputBackground = Color3.fromRGB(45, 35, 45),
            InputStroke = Color3.fromRGB(80, 70, 80),
            PlaceholderColor = Color3.fromRGB(190, 170, 190)
        },
        
        -- Additional themes could be added here
        Pastel = {
            -- Pastel e-girl theme
            TextColor = Color3.fromRGB(255, 240, 245),
            Background = Color3.fromRGB(60, 50, 70),
            -- ... other colors ...
        }
    }
}

-- Custom rounded corners and softer edges
local function createRoundedFrame(parent, size, position, cornerRadius)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = MilkLibrary.Theme.Default.Background
    frame.Size = size
    frame.Position = position
    frame.ClipsDescendants = true
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(cornerRadius, 0)
    uicorner.Parent = frame
    
    frame.Parent = parent
    return frame
end

-- Custom button with e-girl aesthetic
local function createPinkButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = MilkLibrary.Theme.Default.TextColor
    button.BackgroundColor3 = MilkLibrary.Theme.Default.ElementBackground
    button.AutoButtonColor = false
    button.Size = UDim2.new(0, 120, 0, 36)
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0.2, 0)
    uicorner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = MilkLibrary.Theme.Default.ElementStroke
    stroke.Thickness = 1
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = MilkLibrary.Theme.Default.ElementBackgroundHover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = MilkLibrary.Theme.Default.ElementBackground
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    button.Parent = parent
    return button
end

-- Custom toggle switch with heart shape
local function createHeartToggle(parent, name, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Name = name
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = MilkLibrary.Theme.Default.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, 50, 0, 30)
    toggleContainer.Position = UDim2.new(1, -60, 0.5, -15)
    toggleContainer.BackgroundColor3 = MilkLibrary.Theme.Default.ToggleBackground
    toggleContainer.ClipsDescendants = true
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0.5, 0)
    uicorner.Parent = toggleContainer
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = defaultValue and MilkLibrary.Theme.Default.ToggleEnabledOuterStroke 
                   or MilkLibrary.Theme.Default.ToggleDisabledOuterStroke
    stroke.Thickness = 2
    stroke.Parent = toggleContainer
    
    local heart = Instance.new("ImageLabel")
    heart.Image = "rbxassetid://6746678855" -- Heart icon
    heart.Size = UDim2.new(0, 24, 0, 24)
    heart.Position = defaultValue and UDim2.new(1, -28, 0.5, -12) 
                     or UDim2.new(0, 4, 0.5, -12)
    heart.BackgroundTransparency = 1
    heart.ImageColor3 = defaultValue and MilkLibrary.Theme.Default.ToggleEnabled 
                        or MilkLibrary.Theme.Default.ToggleDisabled
    heart.Parent = toggleContainer
    
    local interact = Instance.new("TextButton")
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""
    interact.Parent = toggleContainer
    
    toggleContainer.Parent = toggleFrame
    
    interact.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        defaultValue = newValue
        
        game:GetService("TweenService"):Create(heart, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = newValue and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12),
            ImageColor3 = newValue and MilkLibrary.Theme.Default.ToggleEnabled 
                          or MilkLibrary.Theme.Default.ToggleDisabled
        }):Play()
        
        game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.3), {
            Color = newValue and MilkLibrary.Theme.Default.ToggleEnabledOuterStroke 
                   or MilkLibrary.Theme.Default.ToggleDisabledOuterStroke
        }):Play()
        
        callback(newValue)
    end)
    
    toggleFrame.Parent = parent
    return {
        Set = function(self, value)
            defaultValue = value
            heart.Position = value and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
            heart.ImageColor3 = value and MilkLibrary.Theme.Default.ToggleEnabled 
                               or MilkLibrary.Theme.Default.ToggleDisabled
            stroke.Color = value and MilkLibrary.Theme.Default.ToggleEnabledOuterStroke 
                          or MilkLibrary.Theme.Default.ToggleDisabledOuterStroke
            callback(value)
        end
    }
end

-- Custom slider with cute design
local function createCuteSlider(parent, name, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Name = name
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = MilkLibrary.Theme.Default.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(defaultValue)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextColor3 = MilkLibrary.Theme.Default.TextColor
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -70, 0, 10)
    sliderTrack.Position = UDim2.new(0, 0, 0, 30)
    sliderTrack.BackgroundColor3 = MilkLibrary.Theme.Default.SliderBackground
    sliderTrack.ClipsDescendants = true
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0.5, 0)
    uicorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = MilkLibrary.Theme.Default.SliderProgress
    
    local uicorner2 = Instance.new("UICorner")
    uicorner2.CornerRadius = UDim.new(0.5, 0)
    uicorner2.Parent = sliderFill
    
    sliderFill.Parent = sliderTrack
    
    local sliderButton = Instance.new("ImageButton")
    sliderButton.Image = "rbxassetid://6746678855" -- Heart icon
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.BackgroundTransparency = 1
    sliderButton.ImageColor3 = MilkLibrary.Theme.Default.SliderProgress
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0.5, -10)
    sliderButton.Parent = sliderTrack
    
    sliderTrack.Parent = sliderFrame
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local x = math.clamp(mouse.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
            local percent = x / sliderTrack.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
            valueLabel.Text = tostring(value)
            
            if value ~= defaultValue then
                defaultValue = value
                callback(value)
            end
        end
    end)
    
    sliderFrame.Parent = parent
    return {
        Set = function(self, value)
            value = math.clamp(value, min, max)
            local percent = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
            valueLabel.Text = tostring(value)
            defaultValue = value
            callback(value)
        end
    }
end

-- Main window creation function
function MilkLibrary:CreateWindow(settings)
    local milkWindow = Instance.new("ScreenGui")
    milkWindow.Name = "MilkUI"
    milkWindow.ResetOnSpawn = false
    milkWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if gethui then
        milkWindow.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(milkWindow)
        milkWindow.Parent = game:GetService("CoreGui")
    else
        milkWindow.Parent = game:GetService("CoreGui")
    end
    
    -- Main container with rounded corners
    local mainFrame = createRoundedFrame(milkWindow, UDim2.new(0, 500, 0, 500), UDim2.new(0.5, -250, 0.5, -250), 0.1)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Top bar with cute design
    local topBar = createRoundedFrame(mainFrame, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0), 0.1)
    topBar.BackgroundColor3 = MilkLibrary.Theme.Default.Topbar
    
    local title = Instance.new("TextLabel")
    title.Text = settings.Name or "Milk UI"
    title.Font = Enum.Font.GothamSemibold
    title.TextColor3 = MilkLibrary.Theme.Default.TextColor
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 50, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local icon = Instance.new("ImageLabel")
    icon.Image = "rbxassetid://6746678855" -- Heart icon
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = MilkLibrary.Theme.Default.TextColor
    icon.Parent = topBar
    
    -- Close button with heart
    local closeButton = Instance.new("ImageButton")
    closeButton.Image = "rbxassetid://6746678855" -- Heart icon
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.BackgroundTransparency = 1
    closeButton.ImageColor3 = MilkLibrary.Theme.Default.TextColor
    closeButton.Parent = topBar
    
    closeButton.MouseButton1Click:Connect(function()
        milkWindow:Destroy()
    end)
    
    -- Tab system
    local tabButtons = Instance.new("Frame")
    tabButtons.Size = UDim2.new(1, 0, 0, 40)
    tabButtons.Position = UDim2.new(0, 0, 0, 40)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -20, 1, -100)
    tabContent.Position = UDim2.new(0, 10, 0, 90)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.Parent = mainFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.Parent = tabButtons
    
    local tabs = {}
    local currentTab = nil
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window functions
    local window = {}
    
    function window:CreateTab(name, iconId)
        local tabButton = createPinkButton(tabButtons, name, function()
            if currentTab then
                currentTab.Visible = false
            end
            tabs[name].Visible = true
            currentTab = tabs[name]
        end)
        
        if iconId then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Image = "rbxassetid://"..iconId
            tabIcon.Size = UDim2.new(0, 20, 0, 20)
            tabIcon.Position = UDim2.new(0, 5, 0.5, -10)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Parent = tabButton
            
            tabButton.Text = ""
            
            local tabLabel = Instance.new("TextLabel")
            tabLabel.Text = name
            tabLabel.Font = Enum.Font.GothamSemibold
            tabLabel.TextColor3 = MilkLibrary.Theme.Default.TextColor
            tabLabel.BackgroundTransparency = 1
            tabLabel.Size = UDim2.new(1, -30, 1, 0)
            tabLabel.Position = UDim2.new(0, 30, 0, 0)
            tabLabel.TextXAlignment = Enum.TextXAlignment.Left
            tabLabel.Parent = tabButton
        end
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 5
        tabFrame.ScrollBarImageColor3 = MilkLibrary.Theme.Default.TextColor
        tabFrame.Visible = false
        tabFrame.Parent = tabContent
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 10)
        uiListLayout.Parent = tabFrame
        
        tabs[name] = tabFrame
        
        if not currentTab then
            tabFrame.Visible = true
            currentTab = tabFrame
        end
        
        local tab = {}
        
        function tab:CreateButton(settings)
            local button = createPinkButton(tabFrame, settings.Name, settings.Callback)
            return {
                Set = function(self, newText)
                    button.Text = newText
                end
            }
        end
        
        function tab:CreateToggle(settings)
            return createHeartToggle(tabFrame, settings.Name, settings.CurrentValue, settings.Callback)
        end
        
        function tab:CreateSlider(settings)
            return createCuteSlider(tabFrame, settings.Name, settings.Range[1], settings.Range[2], 
                                  settings.CurrentValue, settings.Callback)
        end
        
        function tab:CreateSection(name)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 30)
            section.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Text = name
            label.Font = Enum.Font.GothamSemibold
            label.TextColor3 = MilkLibrary.Theme.Default.TextColor
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = section
            
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.Position = UDim2.new(0, 0, 1, -1)
            divider.BackgroundColor3 = MilkLibrary.Theme.Default.ElementStroke
            divider.Parent = section
            
            section.Parent = tabFrame
            
            return {
                Set = function(self, newName)
                    label.Text = newName
                end
            }
        end
        
        return tab
    end
    
    function window:ModifyTheme(newTheme)
        if MilkLibrary.Theme[newTheme] then
            -- Apply theme changes to all elements
            -- This would need to be implemented to update all UI elements
        end
    end
    
    return window
end

-- Example usage:
--[[
local Milk = MilkLibrary:CreateWindow({
    Name = "Milk UI Example",
    Theme = "Default"
})

local MainTab = Milk:CreateTab("Main", "6746678855") -- Heart icon
local SettingsTab = Milk:CreateTab("Settings", "6746678855")

MainTab:CreateSection("Fun Stuff")

local MyButton = MainTab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

local MyToggle = MainTab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Callback = function(value)
        print("Toggle state:", value)
    end
})

local MySlider = MainTab:CreateSlider({
    Name = "Intensity",
    Range = {0, 100},
    CurrentValue = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})
]]

return MilkLibrary
