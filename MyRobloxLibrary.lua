local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateScreenGui()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICornerMain = Instance.new("UICorner")
    local ToggleButton = Instance.new("TextButton")

    local existingGui = game.CoreGui:FindFirstChild("MyRobloxLibraryGUI")
    if existingGui then
        existingGui:Destroy()
    end

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "MyRobloxLibraryGUI"

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Frame.Position = UDim2.new(0.5, -400, 0.5, -200)
    Frame.Size = UDim2.new(0, 0, 0, 0)
    Frame.BorderSizePixel = 0

    UICornerMain.Parent = Frame
    UICornerMain.CornerRadius = UDim.new(0, 10)

    -- Draggable Bar
    local DraggableBar = Instance.new("Frame")
    DraggableBar.Parent = Frame
    DraggableBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    DraggableBar.Size = UDim2.new(1, 0, 0, 75)
    DraggableBar.Position = UDim2.new(0, 0, 0, -66)
    DraggableBar.BorderSizePixel = 0
    DraggableBar.ZIndex = 5

    UICornerMain:Clone().Parent = DraggableBar

    self:AnimateFrameAppearance(Frame)

    -- Dragging Functionality
    self:SetupDragging(DraggableBar, Frame)

    -- Toggle Button
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(1, -60, 1, -60)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.Text = "X"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 24
    ToggleButton.ZIndex = 6

    local UICornerToggleButton = Instance.new("UICorner")
    UICornerToggleButton.Parent = ToggleButton
    UICornerToggleButton.CornerRadius = UDim.new(0, 12)

    ToggleButton.MouseButton1Click:Connect(function()
        self:ToggleFrame(Frame)
    end)

    -- Create Tabs
    self.tabs = {}
    self:CreateTabs(Frame)

    return Frame
end

function Library:AnimateFrameAppearance(Frame)
    local goalSize = UDim2.new(0, 800, 0, 400)
    local goalPosition = UDim2.new(0.3, 0, 0.3, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

    TweenService:Create(Frame, tweenInfo, {Size = goalSize}):Play()
    TweenService:Create(Frame, tweenInfo, {Position = goalPosition}):Play()
    Frame.Visible = true
end

function Library:AnimateFrameDisappearance(Frame)
    local goalSize = UDim2.new(0, 0, 0, 0)
    local goalPosition = UDim2.new(0.5, -400, 0.5, -200)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

    local sizeTween = TweenService:Create(Frame, tweenInfo, {Size = goalSize})
    local positionTween = TweenService:Create(Frame, tweenInfo, {Position = goalPosition})

    sizeTween:Play()
    positionTween:Play()
    
    sizeTween.Completed:Connect(function()
        Frame.Visible = false
    end)
end

function Library:ToggleFrame(Frame)
    if Frame.Visible then
        self:AnimateFrameDisappearance(Frame)
    else
        self:AnimateFrameAppearance(Frame)
    end
end

function Library:SetupDragging(DraggableBar, Frame)
    local dragToggle = false
    local dragStart
    local startPos

    DraggableBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    DraggableBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragToggle then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

function Library:CreateTabs(Frame)
    local tabs = {
        {name = "AIM", position = UDim2.new(0, 10, 0, 10)},
        {name = "VISUALS", position = UDim2.new(0, 10, 0, 50)},
        {name = "MISC", position = UDim2.new(0, 10, 0, 90)},
        {name = "SETTINGS", position = UDim2.new(0, 10, 0, 130)}
    }
    
    self.frames = {}
    
    for _, tabInfo in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = Frame
        tabButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        tabButton.Size = UDim2.new(0, 80, 0, 30)
        tabButton.Position = tabInfo.position
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Text = tabInfo.name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 18
        
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = tabButton
        
        local tabFrame = Instance.new("Frame")
        tabFrame.Parent = Frame
        tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabFrame.Position = UDim2.new(0, 100, 0, 10)
        tabFrame.Size = UDim2.new(1, -110, 1, -20)
        tabFrame.Visible = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.Parent = tabFrame
        
        tabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(self.frames) do
                frame.Visible = false
            end
            tabFrame.Visible = true
        end)

        self.frames[tabInfo.name] = tabFrame
    end
    
    -- Initialize the first tab
    self.frames["AIM"].Visible = true
end

function Library:CreateToggleButton(parent, position, text)
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

    local indicator = Instance.new("Frame")
    indicator.Parent = button
    indicator.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    indicator.Size = UDim2.new(0, 30, 0, 30)
    indicator.Position = UDim2.new(0, 0, 0, 0)

    local UICornerIndicator = Instance.new("UICorner")
    UICornerIndicator.Parent = indicator

    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    label.Position = UDim2.new(position.X.Scale, position.X.Offset + 75, position.Y.Scale, position.Y.Offset)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Font = Enum.Font.SourceSans
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 18

    local UICornerLabel = Instance.new("UICorner")
    UICornerLabel.Parent = label

    local isOn = false

    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        local positionGoal = isOn and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 0, 0, 0)
        local colorGoal = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(128, 128, 128)
        
        indicator:TweenPosition(positionGoal, "InOut", "Quad", 0.3, true)
        TweenService:Create(indicator, TweenInfo.new(0.3), {BackgroundColor3 = colorGoal}):Play()
    end)
end

return Library
