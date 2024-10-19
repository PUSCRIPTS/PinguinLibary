local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateScreenGui()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICornerMain = Instance.new("UICorner")

    local existingGui = game.CoreGui:FindFirstChild("MyRobloxGUI")
    if existingGui then
        existingGui:Destroy()
    end

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "MyRobloxGUI"

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

    UICornerMain:Clone().Parent = DraggableBar

    local function animateFrameAppearance()
        local goalSize = UDim2.new(0, 800, 0, 400)
        local goalPosition = UDim2.new(0.3, 0, 0.3, 0)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

        TweenService:Create(Frame, tweenInfo, {Size = goalSize, Position = goalPosition}):Play()
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

    --- Dragging functionality ---
    local dragging = false 
    local dragStart = nil 
    local startPos = nil 

    DraggableBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    DraggableBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    --- Create UI Elements: Toggle, Slider, Dropdown ---
    
    -- Toggle Button Creator
    function Library:CreateToggleButton(parent, position, text)
        local button = Instance.new("TextButton")
        button.Parent = parent
        button.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        button.Size = UDim2.new(0, 60, 0, 30)
        button.Position = position
        button.Font = Enum.Font.SourceSans
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = button

        local indicator = Instance.new("Frame")
        indicator.Parent = button
        indicator.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
        indicator.Size = UDim2.new(0, 30, 0, 30)

        local isOn = false
        button.MouseButton1Click:Connect(function()
            isOn = not isOn
            indicator.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(128, 128, 128)
        end)
    end

    -- Slider Creator
    function Library:CreateSlider(parent, position, text, minValue, maxValue, defaultValue)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = parent
        sliderFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        sliderFrame.Position = position
        sliderFrame.Size = UDim2.new(0, 200, 0, 35)

        local sliderThumb = Instance.new("Frame")
        sliderThumb.Parent = sliderFrame
        sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderThumb.Size = UDim2.new(0, 20, 0, 20)
        sliderThumb.Position = UDim2.new((defaultValue-minValue)/(maxValue-minValue), 0, 0.5, -10)

        local dragging = false

        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderFrame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local xPos = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
                local value = minValue + (xPos / sliderFrame.AbsoluteSize.X) * (maxValue - minValue)
                sliderThumb.Position = UDim2.new(xPos / sliderFrame.AbsoluteSize.X, 0, 0.5, -10)
            end
        end)

        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    -- Dropdown Button Creator
    function Library:CreateDropdownButton(parent, position, text, options)
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Parent = parent
        DropdownButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        DropdownButton.Position = position
        DropdownButton.Size = UDim2.new(0, 160, 0, 30)
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Text = text
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Parent = parent
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        DropdownFrame.Position = UDim2.new(0, position.X.Offset, 0, position.Y.Offset + 30)
        DropdownFrame.Size = UDim2.new(0, 160, 0, 0)
        DropdownFrame.Visible = false
        
        local buttonHeight = 30
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Parent = DropdownFrame
            optionButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            optionButton.Size = UDim2.new(1, 0, 0, buttonHeight)
            optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * buttonHeight)
            optionButton.Font = Enum.Font.SourceSans
            optionButton.Text = option
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)

            optionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                DropdownFrame.Visible = false
                DropdownFrame.Size = UDim2.new(0, 160, 0, 0)
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownFrame.Visible = not DropdownFrame.Visible
            if DropdownFrame.Visible then
                DropdownFrame.Size = UDim2.new(0, 160, 0, #options * buttonHeight)
            else
                DropdownFrame.Size = UDim2.new(0, 160, 0, 0)
            end
        end)
    end

    return Frame
end

return Library
