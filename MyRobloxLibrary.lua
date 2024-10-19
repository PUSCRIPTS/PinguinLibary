local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MyLibrary = {}

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local ToggleButton = Instance.new("TextButton")

local existingGui = game.CoreGui:FindFirstChild("TestGUI")
if existingGui then
    existingGui:Destroy()
end

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TestGUI"

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Frame.Position = UDim2.new(0.5, -400, 0.5, -200)
Frame.Size = UDim2.new(0, 0, 0, 0)
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

local function animateFrameAppearance()
    local goalSize = UDim2.new(0, 800, 0, 400)
    local goalPosition = UDim2.new(0.3, 0, 0.3, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    local sizeTween = TweenService:Create(Frame, tweenInfo, {Size = goalSize})
    local positionTween = TweenService:Create(Frame, tweenInfo, {Position = goalPosition})
    
    sizeTween:Play()
    positionTween:Play()
    Frame.Visible = true
end

local function animateFrameDisappearance()
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

animateFrameAppearance()

local dragToggle = nil
local dragSpeed = 0.1
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    Frame:TweenPosition(newPosition, "InOut", "Linear", dragSpeed, true)
end

DraggableBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInput(input)
        end
    end
end)

local dragToggleButton = nil
local dragStartButton = nil
local startPosButton = nil

local function updateInputButton(input)
    local delta = input.Position - dragStartButton
    local newPosition = UDim2.new(
        startPosButton.X.Scale,
        startPosButton.X.Offset + delta.X,
        startPosButton.Y.Scale,
        startPosButton.Y.Offset + delta.Y
    )
    ToggleButton.Position = newPosition
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggleButton = true
        dragStartButton = input.Position
        startPosButton = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggleButton = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggleButton then
            updateInputButton(input)
        end
    end
end)

local tabs = {
    {name = "AIM", position = UDim2.new(0, 10, 0, 10)},
    {name = "VISUALS", position = UDim2.new(0, 10, 0, 50)},
    {name = "MISC", position = UDim2.new(0, 10, 0, 90)},
    {name = "SETTINGS", position = UDim2.new(0, 10, 0, 130)}
}

local currentTabButton

local function createTabButton(tabInfo)
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = Frame
    tabButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    tabButton.Size = UDim2.new(0, 80, 0, 30)
    tabButton.Position = tabInfo.position
    tabButton.Font = Enum.Font.SourceSans
    tabButton.Text = tabInfo.name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 18
    tabButton.ZIndex = 1

    local corner = Instance.new("UICorner")
    corner.Parent = tabButton
    corner.CornerRadius = UDim.new(0, 10)

    return tabButton
end

local function createTabFrame()
    local frame = Instance.new("Frame")
    frame.Parent = Frame
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Position = UDim2.new(0, 100, 0, 10)
    frame.Size = UDim2.new(1, -110, 1, -20)
    frame.Visible = false
    frame.ZIndex = 1

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)

    return frame
end

-- Create Toggle Button Method
function MyLibrary:createToggleButton(parent, position, text)
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
    label.ZIndex = 1
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    local UICornerLabel = Instance.new("UICorner")
    UICornerLabel.Parent = label
    UICornerLabel.CornerRadius = UDim.new(0, 8)

    local isOn = false

    button.MouseButton1Click:Connect(function()
        isOn = not isOn

        local positionGoal
        local colorGoal

        if isOn then
            positionGoal = UDim2.new(0, 30, 0, 0)
            colorGoal = Color3.fromRGB(0, 255, 0)
        else
            positionGoal = UDim2.new(0, 0, 0, 0)
            colorGoal = Color3.fromRGB(128, 128, 128)
        end

        indicator:TweenPosition(positionGoal, "InOut", "Quad", 0.3, true)
        TweenService:Create(
            indicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {BackgroundColor3 = colorGoal}
        ):Play()
    end)
end

-- Create Slider Method
function MyLibrary:createSlider(parent, position, text, minValue, maxValue, defaultValue)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    sliderFrame.Size = UDim2.new(0, 200, 0, 35)
    sliderFrame.Position = position
    sliderFrame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = sliderFrame
    UICorner.CornerRadius = UDim.new(0, 8)

    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
    sliderBar.Size = UDim2.new(1, 0, 0, 25)
    sliderBar.Position = UDim2.new(0, 0, 0.3, -5)
    sliderBar.BorderSizePixel = 0

    local sliderThumb = Instance.new("Frame")
    sliderThumb.Parent = sliderBar
    sliderThumb.BackgroundColor3 = Color3.new(1.000000, 1.000000, 1.000000)
    sliderThumb.Size = UDim2.new(0, 25, 0, 25)
    sliderThumb.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -12.5, 0.25, -7.5)
    sliderThumb.BorderSizePixel = 0

    local UICornerThumb = Instance.new("UICorner")
    UICornerThumb.Parent = sliderThumb
    UICornerThumb.CornerRadius = UDim.new(0, 10)

    local labelFrame = Instance.new("Frame")
    labelFrame.Parent = sliderFrame
    labelFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    labelFrame.Size = UDim2.new(1, 0, 0, 30)
    labelFrame.Position = UDim2.new(0, 0, 1, 5)
    labelFrame.BorderSizePixel = 0

    local UICornerLabel = Instance.new("UICorner")
    UICornerLabel.Parent = labelFrame
    UICornerLabel.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Parent = labelFrame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.SourceSans
    
    if text == "Prediction" then
        label.Text = text .. " :  " .. string.format("%.1f", defaultValue)
    else
        label.Text = text .. " :  " .. math.round(defaultValue)
    end

    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center

    local dragging = false

    local function updateSlider(input)
        if dragging then
            local x = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local value = minValue + ((x / sliderBar.AbsoluteSize.X) * (maxValue - minValue))
            sliderThumb.Position = UDim2.new(x / sliderBar.AbsoluteSize.X, -12.5, 0.5, -12.5)

            if text == "Prediction" then
                label.Text = text .. " :  " .. string.format("%.1f", value)
            else
                label.Text = text .. " :  " .. math.round(value)
            end
        end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Create Dropdown Method
function MyLibrary:createDropdownButton(parent, position, text, options)
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = parent
    DropdownButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    DropdownButton.Position = position
    DropdownButton.Size = UDim2.new(0, 160, 0, 30)
    DropdownButton.Font = Enum.Font.SourceSans
    DropdownButton.Text = text
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 18

    local UICornerDropdown = Instance.new("UICorner")
    UICornerDropdown.Parent = DropdownButton
    UICornerDropdown.CornerRadius = UDim.new(0, 5)

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    DropdownFrame.Position = UDim2.new(0, position.X.Offset, 0, position.Y.Offset + 30)
    DropdownFrame.Size = UDim2.new(0, 160, 0, 0)
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Visible = false

    local UICornerDropdownFrame = Instance.new("UICorner")
    UICornerDropdownFrame.Parent = DropdownFrame
    UICornerDropdownFrame.CornerRadius = UDim.new(0, 5)

    local buttonHeight = 30

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownFrame
        OptionButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        OptionButton.Size = UDim2.new(1, 0, 0, buttonHeight)
        OptionButton.Position = UDim2.new(0, 0, 0, (i - 1) * buttonHeight)
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 18

        local UICornerOption = Instance.new("UICorner")
        UICornerOption.Parent = OptionButton
        UICornerOption.CornerRadius = UDim.new(0, 5)

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            DropdownFrame.Visible = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 160, 0, 0)}):Play()
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        if DropdownFrame.Visible then
            DropdownFrame.Visible = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 160, 0, 0)}):Play()
        else
            DropdownFrame.Visible = true
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 160, 0, #options * buttonHeight)}):Play()
        end
    end)
end

local frames = {}
local tabButtons = {}

for _, tab in ipairs(tabs) do
    local tabButton = createTabButton(tab)
    local tabFrame = createTabFrame()

    frames[tab.name] = tabFrame
    tabButtons[tab.name] = tabButton

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
end

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

for _, frame in pairs(frames) do
    frame.Visible = false
end
frames["AIM"].Visible = true
local defaultTabButton = tabButtons["AIM"]
defaultTabButton.BackgroundColor3 = Color3.fromRGB(0, 76, 153)
currentTabButton = defaultTabButton

local isVisible = true

local function toggleGUI()
    isVisible = not isVisible
    if isVisible then
        animateFrameAppearance()
    else
        animateFrameDisappearance()
    end
end

ToggleButton.MouseButton1Click:Connect(toggleGUI)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl or input.UserInputType == Enum.UserInputType.Touch then
        toggleGUI()
    end
end)

return MyLibrary
