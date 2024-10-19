local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main Library Table
local MyLibrary = {}

-- Create the main GUI
function MyLibrary:CreateScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICornerMain = Instance.new("UICorner")
    local ToggleButton = Instance.new("TextButton")

    -- Remove existing GUI if present
    local existingGui = game.CoreGui:FindFirstChild("TestGUI")
    if existingGui then
        existingGui:Destroy()
    end

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "TestGUI"

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Frame.Position = UDim2.new(0.5, -400, 0.5, -200)
    Frame.Size = UDim2.new(0, 800, 0, 400)
    Frame.BorderSizePixel = 0

    UICornerMain.Parent = Frame
    UICornerMain.CornerRadius = UDim.new(0, 10)

    local DraggableBar = Instance.new("Frame")
    DraggableBar.Parent = Frame
    DraggableBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    DraggableBar.Size = UDim2.new(1, 0, 0, 75)
    DraggableBar.Position = UDim2.new(0, 0, 0, -66)
    DraggableBar.BorderSizePixel = 0
    DraggableBar.ZIndex = 5

    UICornerMain.Parent = DraggableBar
    UICornerMain.CornerRadius = UDim.new(0, 10)

    return Frame, ToggleButton
end

-- Animate frame appearance
local function animateFrameAppearance(Frame)
    Frame.Visible = true
    Frame.Size = UDim2.new(0, 800, 0, 400)
    Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
end

-- Animate frame disappearance
local function animateFrameDisappearance(Frame)
    Frame.Size = UDim2.new(0, 0, 0, 0)
    Frame.Position = UDim2.new(0.5, -400, 0.5, -200)
    Frame.Visible = false
end

-- Create the Toggle Button
function MyLibrary:CreateToggleButton(parent, position, text)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    button.Size = UDim2.new(0, 60, 0, 30)
    button.Position = position
    button.Font = Enum.Font.SourceSans
    button.Text = ""
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18

    local UICornerButton = Instance.new("UICorner")
    UICornerButton.Parent = button
    UICornerButton.CornerRadius = UDim.new(0, 8)

    local indicator = Instance.new("Frame")
    indicator.Parent = button
    indicator.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    indicator.Size = UDim2.new(0, 30, 0, 30)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.BorderSizePixel = 0

    local UICornerIndicator = Instance.new("UICorner")
    UICornerIndicator.Parent = indicator
    UICornerIndicator.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    label.Position = UDim2.new(position.X.Scale, position.X.Offset + 75, position.Y.Scale, position.Y.Offset)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Font = Enum.Font.SourceSans
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    local isOn = false

    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        local positionGoal = isOn and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 0, 0, 0)
        local colorGoal = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(128, 128, 128)

        indicator:TweenPosition(positionGoal, "InOut", "Quad", 0.3, true)
        TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = colorGoal}):Play()
    end)
end

-- Create slider
function MyLibrary:CreateSlider(parent, position, text, minValue, maxValue, defaultValue)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    sliderFrame.Size = UDim2.new(0, 200, 0, 35)
    sliderFrame.Position = position

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = sliderFrame
    UICorner.CornerRadius = UDim.new(0, 8)

    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
    sliderBar.Size = UDim2.new(1, 0, 0, 25)
    sliderBar.Position = UDim2.new(0, 0, 0.3, -5)

    local sliderThumb = Instance.new("Frame")
    sliderThumb.Parent = sliderBar
    sliderThumb.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderThumb.Size = UDim2.new(0, 25, 0, 25)
    sliderThumb.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -12.5, 0.25, -7.5)

    local label = Instance.new("TextLabel")
    label.Parent = sliderFrame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.Text = text .. " : " .. tostring(defaultValue)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Center

    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputEnded:Connect(function()
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local x = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local value = minValue + ((x / sliderBar.AbsoluteSize.X) * (maxValue - minValue))
            sliderThumb.Position = UDim2.new(x / sliderBar.AbsoluteSize.X, -12.5, 0.5, -12.5)
            label.Text = text .. " : " .. tostring(value)
        end
    end)
end

-- Create Dropdown Button
function MyLibrary:CreateDropdownButton(parent, position, text, options)
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = parent
    DropdownButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    DropdownButton.Position = position
    DropdownButton.Size = UDim2.new(0, 160, 0, 30)
    DropdownButton.Font = Enum.Font.SourceSans
    DropdownButton.Text = text
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 18

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    DropdownFrame.Position = UDim2.new(0, position.X.Offset, 0, position.Y.Offset + 30)
    DropdownFrame.Size = UDim2.new(0, 160, 0, 0)
    DropdownFrame.Visible = false

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownFrame
        OptionButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 18

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            DropdownFrame.Visible = false
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownFrame.Visible = not DropdownFrame.Visible
    end)
end

-- Create Tabs
function MyLibrary:InitializeTabs(Frame)
    local tabs = {
        {name = "AIM", position = UDim2.new(0, 10, 0, 10)},
        {name = "VISUALS", position = UDim2.new(0, 10, 0, 50)},
        {name = "MISC", position = UDim2.new(0, 10, 0, 90)},
        {name = "SETTINGS", position = UDim2.new(0, 10, 0, 130)}
    }

    local currentTabButton
    local frames = {}

    for _, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = Frame
        tabButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        tabButton.Size = UDim2.new(0, 80, 0, 30)
        tabButton.Position = tab.position
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Text = tab.name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 18

        local corner = Instance.new("UICorner")
        corner.Parent = tabButton
        corner.CornerRadius = UDim.new(0, 10)

        local tabFrame = Instance.new("Frame")
        tabFrame.Parent = Frame
        tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabFrame.Position = UDim2.new(0, 100, 0, 10)
        tabFrame.Size = UDim2.new(1, -110, 1, -20)
        tabFrame.Visible = false

        local cornerFrame = Instance.new("UICorner")
        cornerFrame.Parent = tabFrame
        cornerFrame.CornerRadius = UDim.new(0, 10)

        if currentTabButton == nil then
            currentTabButton = tabButton
            tabFrame.Visible = true
        end

        tabButton.MouseButton1Click:Connect(function()
            if currentTabButton then
                currentTabButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            end

            tabButton.BackgroundColor3 = Color3.fromRGB(0, 76, 153)
            currentTabButton = tabButton

            for _, frame in pairs(frames) do
                frame.Visible = false
            end
            tabFrame.Visible = true
        end)

        frames[tab.name] = tabFrame
    end
end

-- Execute the library
function MyLibrary:Initialize()
    local Frame, ToggleButton = self:CreateScreenGui()
    animateFrameAppearance(Frame)
    self:InitializeTabs(Frame)

    -- Toggle Button Functionality
    ToggleButton.Parent = Frame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(1, -60, 1, -60)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.Text = "X"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 24

    local UICornerToggleButton = Instance.new("UICorner")
    UICornerToggleButton.Parent = ToggleButton
    UICornerToggleButton.CornerRadius = UDim.new(0, 12)

    ToggleButton.MouseButton1Click:Connect(function()
        local isVisible = Frame.Visible
        Frame.Visible = not isVisible
        if Frame.Visible then
            animateFrameAppearance(Frame)
        else
            animateFrameDisappearance(Frame)
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl or input.UserInputType == Enum.UserInputType.Touch then
            ToggleButton.MouseButton1Click:Fire()
        end
    end)
end

-- Finalize the library
return MyLibrary
