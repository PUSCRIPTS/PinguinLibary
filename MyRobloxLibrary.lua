-- MyRobloxLibrary.lua
local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Library:CreateScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICornerMain = Instance.new("UICorner")
    local ToggleButton = Instance.new("TextButton")

    local existingGui = game.CoreGui:FindFirstChild("PinguinLibrary")
    if existingGui then
        existingGui:Destroy()
    end

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "PinguinLibrary"

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
    self:SetupDragging(DraggableBar, Frame)
    self:CreateToggleButton(ScreenGui, Frame)

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

function Library:SetupDragging(DraggableBar, Frame)
    local dragToggle = false
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Frame.Position = newPosition
    end

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
                updateInput(input)
            end
        end
    end)
end

function Library:CreateToggleButton(ScreenGui, Frame)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ScreenGui
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

    local isVisible = true

    ToggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        if isVisible then
            self:AnimateFrameAppearance(Frame)
        else
            Frame.Visible = false
        end
    end)
end

-- Slider
function Library:CreateSlider(parent, position, text, minValue, maxValue, defaultValue, callback)
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
    sliderThumb.BackgroundColor3 = Color3.new(1, 1, 1)
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
    label.Text = text .. " : " .. defaultValue
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
            label.Text = text .. " : " .. math.round(value)
            if callback then
                callback(value)
            end
        end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Dropdown
function Library:CreateDropdownButton(parent, position, text, options, callback)
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
            if callback then
                callback(option)
            end
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

-- Example Usage
function Library:ExampleUsage()
    local mainFrame = self:CreateScreenGui()
    
    self:CreateSlider(mainFrame, UDim2.new(0, 20, 0, 220), "Example Slider", 0, 100, 50, function(value)
        print("Slider value: " .. value)
    end)

    self:CreateDropdownButton(mainFrame, UDim2.new(0, 20, 0, 260), "Example Dropdown", {"Option 1", "Option 2", "Option 3"}, function(selected)
        print("Dropdown selected: " .. selected)
    end)

end

return Library
