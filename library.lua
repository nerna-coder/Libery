local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

local function GetTargetParent()
    local parent = LocalPlayer:WaitForChild("PlayerGui")
    pcall(function()
        if gethui then
            parent = gethui()
        elseif game:GetService("CoreGui") then
            parent = game:GetService("CoreGui")
        end
    end)
    return parent
end

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Hub"
    
    local TargetParent = GetTargetParent()
    if TargetParent:FindFirstChild("MyCustomGui_Container") then
        TargetParent["MyCustomGui_Container"]:Destroy()
    end

    local Theme = {
        Bg = Color3.fromRGB(20, 21, 26),
        Sidebar = Color3.fromRGB(16, 17, 21),
        Group = Color3.fromRGB(26, 28, 34),
        Item = Color3.fromRGB(32, 34, 42),
        -- Цвета точно по видео:
        ToggleOn = Color3.fromRGB(165, 135, 255),  -- Яркий фиолетовый
        ToggleOff = Color3.fromRGB(42, 45, 56),   -- Тёмно-серый
        KnobOn = Color3.fromRGB(255, 255, 255),   -- Белый шарик
        KnobOff = Color3.fromRGB(120, 125, 140),  -- Серый шарик
        Text = Color3.fromRGB(240, 242, 248),
        TextSub = Color3.fromRGB(130, 134, 146),
        Border = Color3.fromRGB(38, 40, 48)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyCustomGui_Container"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = TargetParent

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 560, 0, 330)
    Main.Position = UDim2.new(0.5, -280, 0.5, -165)
    Main.BackgroundColor3 = Theme.Bg
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SideDivider = Instance.new("Frame")
    SideDivider.Size = UDim2.new(0, 1, 1, 0)
    SideDivider.Position = UDim2.new(1, -1, 0, 0)
    SideDivider.BackgroundColor3 = Theme.Border
    SideDivider.BorderSizePixel = 0
    SideDivider.Parent = Sidebar

    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, -20, 0, 32)
    Logo.Position = UDim2.new(0, 16, 0, 10)
    Logo.BackgroundTransparency = 1
    Logo.Text = windowName
    Logo.TextColor3 = Theme.Text
    Logo.TextSize = 14
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    Logo.Parent = Sidebar

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, -16, 1, -100)
    TabHolder.Position = UDim2.new(0, 8, 0, 50)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabHolder

    local ContainerArea = Instance.new("Frame")
    ContainerArea.Size = UDim2.new(1, -160, 1, 0)
    ContainerArea.Position = UDim2.new(0, 160, 0, 0)
    ContainerArea.BackgroundTransparency = 1
    ContainerArea.Parent = Main

    -- Драг окна
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Кнопка скрыть/показать UI
    local ToggleUI = Instance.new("ImageButton")
    ToggleUI.Size = UDim2.new(0, 50, 0, 50)
    ToggleUI.Position = UDim2.new(0, 15, 0, 15)
    ToggleUI.BackgroundColor3 = Theme.Sidebar
    ToggleUI.Image = "rbxassetid://15315284749"
    ToggleUI.AutoButtonColor = false
    ToggleUI.ClipsDescendants = true
    ToggleUI.Parent = ScreenGui
    Instance.new("UICorner", ToggleUI).CornerRadius = UDim.new(0, 10)

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Theme.Border
    ToggleStroke.Parent = ToggleUI

    local btnDragging, btnDragStart, btnStartPos, hasDraggedBtn = false, nil, nil, false
    ToggleUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true
            hasDraggedBtn = false
            btnDragStart = input.Position
            btnStartPos = ToggleUI.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then hasDraggedBtn = true end
            ToggleUI.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = false
        end
    end)
    ToggleUI.MouseButton1Click:Connect(function()
        if not hasDraggedBtn then Main.Visible = not Main.Visible end
    end)

    local WindowObj = {}
    local FirstTab = true

    function WindowObj:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Border
        Page.Parent = ContainerArea

        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop, Padding.PaddingLeft, Padding.PaddingRight, Padding.PaddingBottom = UDim.new(0, 12), UDim.new(0, 12), UDim.new(0, 12), UDim.new(0, 12)
        Padding.Parent = Page

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
        end)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Theme.ToggleOn
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextSub
        TabBtn.TextSize, TabBtn.Font = 11, Enum.Font.GothamMedium
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabHolder
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local function SelectTab()
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundTransparency = 1
                    btn.TextColor3 = Theme.TextSub
                end
            end
            for _, p in pairs(ContainerArea:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.Text
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        if FirstTab then
            SelectTab()
            FirstTab = false
        end

        local TabObj = {}

        function TabObj:CreateGroupbox(groupName)
            local Group = Instance.new("Frame")
            Group.Size = UDim2.new(1, 0, 0, 38)
            Group.BackgroundColor3 = Theme.Group
            Group.Parent = Page
            Instance.new("UICorner", Group).CornerRadius = UDim.new(0, 8)
            local GStroke = Instance.new("UIStroke")
            GStroke.Color = Theme.Border
            GStroke.Parent = Group

            local GTitle = Instance.new("TextLabel")
            GTitle.Size = UDim2.new(1, -20, 0, 24)
            GTitle.Position = UDim2.new(0, 10, 0, 6)
            GTitle.BackgroundTransparency = 1
            GTitle.Text = groupName or "Group"
            GTitle.TextColor3 = Theme.Text
            GTitle.TextSize = 11
            GTitle.Font = Enum.Font.GothamBold
            GTitle.TextXAlignment = Enum.TextXAlignment.Left
            GTitle.Parent = Group

            local ContentBox = Instance.new("Frame")
            ContentBox.Size = UDim2.new(1, 0, 0, 0)
            ContentBox.Position = UDim2.new(0, 0, 0, 30)
            ContentBox.BackgroundTransparency = 1
            ContentBox.Parent = Group

            local CLayout = Instance.new("UIListLayout")
            CLayout.Padding = UDim.new(0, 6)
            CLayout.Parent = ContentBox

            local CPadding = Instance.new("UIPadding")
            CPadding.PaddingLeft, CPadding.PaddingRight, CPadding.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8), UDim.new(0, 8)
            CPadding.Parent = ContentBox

            CLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Group.Size = UDim2.new(1, 0, 0, CLayout.AbsoluteContentSize.Y + 38)
            end)

            local GroupObj = {}

            -- Кнопка
            function GroupObj:AddButton(text, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 32)
                Btn.BackgroundColor3 = Theme.Item
                Btn.Text = text
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 11
                Btn.Font = Enum.Font.GothamMedium
                Btn.AutoButtonColor = false
                Btn.Parent = ContentBox
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            -- Плавный Switch 1 в 1 как на видео
            function GroupObj:AddToggle(text, default, callback)
                local Toggled = default or false
                
                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, 0, 0, 36)
                ToggleBtn.BackgroundColor3 = Theme.Item
                ToggleBtn.Text = ""
                ToggleBtn.AutoButtonColor = false
                ToggleBtn.Parent = ContentBox
                Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

                local TText = Instance.new("TextLabel")
                TText.Size = UDim2.new(1, -65, 1, 0)
                TText.Position = UDim2.new(0, 12, 0, 0)
                TText.BackgroundTransparency = 1
                TText.Text = text
                TText.TextColor3 = Theme.Text
                TText.TextSize = 12
                TText.Font = Enum.Font.GothamMedium
                TText.TextXAlignment = Enum.TextXAlignment.Left
                TText.Parent = ToggleBtn

                -- Фоновый капсюль
                local SwitchPill = Instance.new("Frame")
                SwitchPill.Size = UDim2.new(0, 44, 0, 22)
                SwitchPill.Position = UDim2.new(1, -52, 0.5, -11)
                SwitchPill.BackgroundColor3 = Toggled and Theme.ToggleOn or Theme.ToggleOff
                SwitchPill.BorderSizePixel = 0
                SwitchPill.Parent = ToggleBtn
                Instance.new("UICorner", SwitchPill).CornerRadius = UDim.new(1, 0)

                -- Шарик переключателя
                local Knob = Instance.new("Frame")
                Knob.Size = Toggled and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 14, 0, 14)
                Knob.Position = Toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 4, 0.5, -7)
                Knob.BackgroundColor3 = Toggled and Theme.KnobOn or Theme.KnobOff
                Knob.BorderSizePixel = 0
                Knob.Parent = SwitchPill
                Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                local tweenFast = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                local ToggleObj = {}

                function ToggleObj:Set(value)
                    Toggled = value
                    
                    local targetPos = Toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 4, 0.5, -7)
                    local targetSize = Toggled and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 14, 0, 14)
                    local pillColor = Toggled and Theme.ToggleOn or Theme.ToggleOff
                    local knobColor = Toggled and Theme.KnobOn or Theme.KnobOff

                    TweenService:Create(Knob, tweenFast, {
                        Position = targetPos,
                        Size = targetSize,
                        BackgroundColor3 = knobColor
                    }):Play()

                    TweenService:Create(SwitchPill, tweenFast, {
                        BackgroundColor3 = pillColor
                    }):Play()

                    if callback then callback(Toggled) end
                end

                ToggleBtn.MouseButton1Click:Connect(function()
                    ToggleObj:Set(not Toggled)
                end)

                return ToggleObj
            end

            return GroupObj
        end

        return TabObj
    end

    return WindowObj
end

return Library
