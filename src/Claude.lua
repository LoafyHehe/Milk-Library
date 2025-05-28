--[[
    Milk UI Library v1.0
    A creamy dark e-girl aesthetic UI library for Roblox
    Made with love and caffeine ♡
]]--

local Milk = {}
Milk.__index = Milk

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Player
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Color Palette (Creamy Dark E-Girl Theme)
local Colors = {
    Background = Color3.fromRGB(15, 12, 18),      -- Deep purple-black
    Secondary = Color3.fromRGB(25, 20, 30),       -- Slightly lighter
    Accent = Color3.fromRGB(255, 182, 193),       -- Soft pink
    AccentDark = Color3.fromRGB(200, 140, 160),   -- Darker pink
    Text = Color3.fromRGB(245, 240, 250),         -- Cream white
    TextDim = Color3.fromRGB(180, 170, 190),      -- Dimmed text
    Success = Color3.fromRGB(144, 238, 144),      -- Soft green
    Warning = Color3.fromRGB(255, 218, 185),      -- Peach
    Error = Color3.fromRGB(255, 160, 160),        -- Soft red
    Glow = Color3.fromRGB(255, 192, 203),         -- Pink glow
}

-- Animation configs
local Animations = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function AddGlow(frame, color, size)
    local glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        Parent = frame,
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = color or Colors.Glow,
        ImageTransparency = 0.7,
        Size = UDim2.new(1, size or 20, 1, size or 20),
        Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2),
        ZIndex = frame.ZIndex - 1,
    })
    
    CreateInstance("UICorner", {
        Parent = glow,
        CornerRadius = UDim.new(0, 12)
    })
    
    return glow
end

local function CreateGradient(parent, colors, rotation)
    local gradient = CreateInstance("UIGradient", {
        Parent = parent,
        Color = ColorSequence.new(colors or {Colors.Background, Colors.Secondary}),
        Rotation = rotation or 45,
    })
    return gradient
end

-- Main Library Functions
function Milk:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    
    config = config or {}
    local windowTitle = config.Name or "Milk UI ♡"
    local windowSize = config.Size or UDim2.new(0, 600, 0, 400)
    
    -- Main GUI
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "MilkUI_" .. tick(),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        Size = windowSize,
        ZIndex = 1,
    })
    
    CreateInstance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 16)
    })
    
    CreateGradient(MainFrame, {Colors.Background, Colors.Secondary})
    AddGlow(MainFrame, Colors.Glow, 30)
    
    -- Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        ZIndex = 2,
    })
    
    CreateInstance("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 16)
    })
    
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = windowTitle,
        TextColor3 = Colors.Accent,
        TextScaled = true,
        TextSize = 18,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        ZIndex = 3,
    })
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        BackgroundColor3 = Colors.Error,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Colors.Text,
        TextScaled = true,
        Position = UDim2.new(1, -40, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        ZIndex = 3,
    })
    
    CreateInstance("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Tab Container
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 120, 1, -50),
        ZIndex = 2,
    })
    
    local TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2,
    })
    
    CreateInstance("UIListLayout", {
        Parent = TabList,
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    
    -- Content Container
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 130, 0, 60),
        Size = UDim2.new(1, -140, 1, -70),
        ZIndex = 2,
    })
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, Animations.Medium, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Window Methods
    function Window:CreateTab(config)
        local Tab = {}
        config = config or {}
        local tabName = config.Name or "New Tab"
        local tabIcon = config.Icon or "♡"
        
        -- Tab Button
        local TabButton = CreateInstance("TextButton", {
            Name = "TabButton",
            Parent = TabList,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = tabIcon .. " " .. tabName,
            TextColor3 = Colors.TextDim,
            TextScaled = true,
            Size = UDim2.new(1, -10, 0, 35),
            ZIndex = 3,
        })
        
        CreateInstance("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        -- Tab Content
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = "TabContent",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Colors.Accent,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 2,
        })
        
        CreateInstance("UIListLayout", {
            Parent = TabContent,
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, Animations.Fast, {
                    BackgroundColor3 = Colors.Secondary,
                    TextColor3 = Colors.TextDim
                }):Play()
            end
            
            -- Show selected tab
            TabContent.Visible = true
            TweenService:Create(TabButton, Animations.Fast, {
                BackgroundColor3 = Colors.Accent,
                TextColor3 = Colors.Background
            }):Play()
        end)
        
        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, Animations.Fast, {
                    BackgroundColor3 = Colors.AccentDark,
                    TextColor3 = Colors.Text
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, Animations.Fast, {
                    BackgroundColor3 = Colors.Secondary,
                    TextColor3 = Colors.TextDim
                }):Play()
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Window.Tabs[#Window.Tabs + 1] = Tab
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Tab Methods
        function Tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Text or "Button"
            local callback = config.Callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Name = "Button",
                Parent = TabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Font = Enum.Font.Gotham,
                Text = buttonText,
                TextColor3 = Colors.Text,
                TextScaled = true,
                Size = UDim2.new(1, -20, 0, 40),
                ZIndex = 3,
            })
            
            CreateInstance("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 10)
            })
            
            AddGlow(Button, Colors.Accent, 10)
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, Animations.Fast, {Size = UDim2.new(1, -25, 0, 35)}):Play()
                wait(0.1)
                TweenService:Create(Button, Animations.Bounce, {Size = UDim2.new(1, -20, 0, 40)}):Play()
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, Animations.Fast, {
                    BackgroundColor3 = Colors.Accent,
                    TextColor3 = Colors.Background
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, Animations.Fast, {
                    BackgroundColor3 = Colors.Secondary,
                    TextColor3 = Colors.Text
                }):Play()
            end)
            
            return Button
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local defaultValue = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = CreateInstance("Frame", {
                Name = "ToggleFrame",
                Parent = TabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 50),
                ZIndex = 3,
            })
            
            CreateInstance("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(0, 10)
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Name = "Label",
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = toggleText,
                TextColor3 = Colors.Text,
                TextScaled = true,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                ZIndex = 4,
            })
            
            local ToggleButton = CreateInstance("Frame", {
                Name = "ToggleButton",
                Parent = ToggleFrame,
                BackgroundColor3 = defaultValue and Colors.Accent or Colors.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -60, 0.5, -12),
                Size = UDim2.new(0, 50, 0, 24),
                ZIndex = 4,
            })
            
            CreateInstance("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(0, 12)
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Name = "Circle",
                Parent = ToggleButton,
                BackgroundColor3 = Colors.Text,
                BorderSizePixel = 0,
                Position = defaultValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                ZIndex = 5,
            })
            
            CreateInstance("UICorner", {
                Parent = ToggleCircle,
                CornerRadius = UDim.new(0, 10)
            })
            
            local toggled = defaultValue
            
            local function updateToggle()
                TweenService:Create(ToggleButton, Animations.Medium, {
                    BackgroundColor3 = toggled and Colors.Accent or Colors.Background
                }):Play()
                
                TweenService:Create(ToggleCircle, Animations.Medium, {
                    Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }):Play()
                
                callback(toggled)
            end
            
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    updateToggle()
                end
            end)
            
            updateToggle()
            return ToggleFrame
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderText = config.Text or "Slider"
            local minValue = config.Min or 0
            local maxValue = config.Max or 100
            local defaultValue = config.Default or minValue
            local callback = config.Callback or function() end
            
            local SliderFrame = CreateInstance("Frame", {
                Name = "SliderFrame",
                Parent = TabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 60),
                ZIndex = 3,
            })
            
            CreateInstance("UICorner", {
                Parent = SliderFrame,
                CornerRadius = UDim.new(0, 10)
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Name = "Label",
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = sliderText,
                TextColor3 = Colors.Text,
                TextScaled = true,
                Position = UDim2.new(0, 15, 0, 5),
                Size = UDim2.new(0.6, 0, 0, 20),
                ZIndex = 4,
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Name = "ValueLabel",
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = tostring(defaultValue),
                TextColor3 = Colors.Accent,
                TextScaled = true,
                Position = UDim2.new(0.7, 0, 0, 5),
                Size = UDim2.new(0.25, 0, 0, 20),
                ZIndex = 4,
            })
            
            local SliderBar = CreateInstance("Frame", {
                Name = "SliderBar",
                Parent = SliderFrame,
                BackgroundColor3 = Colors.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 15, 0, 35),
                Size = UDim2.new(1, -30, 0, 8),
                ZIndex = 4,
            })
            
            CreateInstance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(0, 4)
            })
            
            local SliderFill = CreateInstance("Frame", {
                Name = "SliderFill",
                Parent = SliderBar,
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0),
                ZIndex = 5,
            })
            
            CreateInstance("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(0, 4)
            })
            
            local SliderHandle = CreateInstance("Frame", {
                Name = "SliderHandle",
                Parent = SliderBar,
                BackgroundColor3 = Colors.Text,
                BorderSizePixel = 0,
                Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 6,
            })
            
            CreateInstance("UICorner", {
                Parent = SliderHandle,
                CornerRadius = UDim.new(0, 8)
            })
            
            local currentValue = defaultValue
            local dragging = false
            
            local function updateSlider(value)
                currentValue = math.clamp(value, minValue, maxValue)
                local percentage = (currentValue - minValue) / (maxValue - minValue)
                
                TweenService:Create(SliderFill, Animations.Fast, {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }):Play()
                
                TweenService:Create(SliderHandle, Animations.Fast, {
                    Position = UDim2.new(percentage, -8, 0.5, -8)
                }):Play()
                
                ValueLabel.Text = tostring(math.floor(currentValue))
                callback(currentValue)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local mousePos = UserInputService:GetMouseLocation()
                    local barPos = SliderBar.AbsolutePosition
                    local percentage = math.clamp((mousePos.X - barPos.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local newValue = minValue + (maxValue - minValue) * percentage
                    updateSlider(newValue)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local barPos = SliderBar.AbsolutePosition
                    local percentage = math.clamp((mousePos.X - barPos.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local newValue = minValue + (maxValue - minValue) * percentage
                    updateSlider(newValue)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            updateSlider(defaultValue)
            return SliderFrame
        end
        
        function Tab:CreateTextbox(config)
            config = config or {}
            local textboxText = config.Text or "Textbox"
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local TextboxFrame = CreateInstance("Frame", {
                Name = "TextboxFrame",
                Parent = TabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 50),
                ZIndex = 3,
            })
            
            CreateInstance("UICorner", {
                Parent = TextboxFrame,
                CornerRadius = UDim.new(0, 10)
            })
            
            local TextboxLabel = CreateInstance("TextLabel", {
                Name = "Label",
                Parent = TextboxFrame,
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = textboxText,
                TextColor3 = Colors.Text,
                TextScaled = true,
                Position = UDim2.new(0, 15, 0, 5),
                Size = UDim2.new(0.4, 0, 0, 20),
                ZIndex = 4,
            })
            
            local Textbox = CreateInstance("TextBox", {
                Name = "Textbox",
                Parent = TextboxFrame,
                BackgroundColor3 = Colors.Background,
                BorderSizePixel = 0,
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Colors.TextDim,
                Text = "",
                TextColor3 = Colors.Text,
                TextScaled = true,
                Position = UDim2.new(0, 15, 0, 25),
                Size = UDim2.new(1, -30, 0, 20),
                ZIndex = 4,
            })
            
            CreateInstance("UICorner", {
                Parent = Textbox,
                CornerRadius = UDim.new(0, 6)
            })
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)
            
            Textbox.Focused:Connect(function()
                TweenService:Create(TextboxFrame, Animations.Fast, {
                    BackgroundColor3 = Colors.AccentDark
                }):Play()
            end)
            
            Textbox.FocusLost:Connect(function()
                TweenService:Create(TextboxFrame, Animations.Fast, {
                    BackgroundColor3 = Colors.Secondary
                }):Play()
            end)
            
            return TextboxFrame
        end
        
        function Tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"
            
            local Label = CreateInstance("TextLabel", {
                Name = "Label",
                Parent = TabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Font = Enum.Font.Gotham,
                Text = labelText,
                TextColor3 = Colors.Text,
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.new(1, -20, 0, 30),
                ZIndex = 3,
            })
            
            CreateInstance("UICorner", {
                Parent = Label,
                CornerRadius = UDim.new(0, 8)
            })
            
            CreateInstance("UIPadding", {
                Parent = Label,
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
            })
            
            return Label
        end
        
        return Tab
    end
    
    return Window
end

return Milk
