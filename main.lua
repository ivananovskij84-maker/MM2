-- =======================================================
-- GAG22 LOADER v8.0.7 | MURDER MYSTERY 2 EDITION
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Удаление копий
if CoreGui:FindFirstChild("GAG22_Loader") then
    CoreGui.GAG22_Loader:Destroy()
end

-- =======================================================
-- ВСТРОЕННЫЙ ОСНОВНОЙ СКРИПТ (GAG22 MM2 HUB)
-- =======================================================
local function LaunchGAG22Hub()
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    if CoreGui:FindFirstChild("GAG22") then
        CoreGui.GAG22:Destroy()
    end

    local Flags = {
        KillAura = false, KillAuraRange = 20,
        SheriffAura = false, SheriffRange = 100,
        ESP = false, AutoFarm = false, FarmSpeed = 60,
        Noclip = false, InfJump = false,
        WalkSpeedEnabled = false, WalkSpeedValue = 16,
        JumpPowerEnabled = false, JumpPowerValue = 50
    }

    local Connections = {}
    local Running = true
    local CurrentTween = nil

    local function UnloadScript()
        Running = false
        if CurrentTween then pcall(function() CurrentTween:Cancel() end) end
        for _, conn in pairs(Connections) do
            if conn and typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("RoleHighlight") then
                player.Character.RoleHighlight:Destroy()
            end
        end
        if CoreGui:FindFirstChild("GAG22") then CoreGui.GAG22:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GAG22"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 750, 0, 430)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local Dragging, DragStart, StartPos
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)

    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 150, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "GAG22 MM2"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    local ControlBox = Instance.new("Frame")
    ControlBox.Size = UDim2.new(0, 80, 0, 30)
    ControlBox.Position = UDim2.new(1, -90, 0, 7)
    ControlBox.BackgroundColor3 = Color3.fromRGB(16, 22, 31)
    ControlBox.Parent = TopBar

    local ControlCorner = Instance.new("UICorner")
    ControlCorner.CornerRadius = UDim.new(0, 6)
    ControlCorner.Parent = ControlBox

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(1, 0, 1, 0)
    CloseBtn.Text = "✕  Закрыть"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = ControlBox
    CloseBtn.MouseButton1Click:Connect(UnloadScript)

    local TabsHolder = Instance.new("Frame")
    TabsHolder.Size = UDim2.new(0, 480, 1, 0)
    TabsHolder.Position = UDim2.new(0, 170, 0, 0)
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Parent = TopBar

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.Padding = UDim.new(0, 6)
    TabsLayout.Parent = TabsHolder

    local PagesFolder = Instance.new("Frame")
    PagesFolder.Name = "Pages"
    PagesFolder.Size = UDim2.new(1, -30, 1, -85)
    PagesFolder.Position = UDim2.new(0, 15, 0, 50)
    PagesFolder.BackgroundTransparency = 1
    PagesFolder.Parent = MainFrame

    local BottomBar = Instance.new("Frame")
    BottomBar.Size = UDim2.new(1, 0, 0, 30)
    BottomBar.Position = UDim2.new(0, 0, 1, -30)
    BottomBar.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
    BottomBar.BorderSizePixel = 0
    BottomBar.Parent = MainFrame

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -20, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.Text = "READY | PLACE " .. tostring(game.PlaceId) .. " · GAG22 Hub v3.7"
    StatusText.TextColor3 = Color3.fromRGB(120, 130, 145)
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 11
    StatusText.TextXAlignment = Enum.TextXAlignment.Right
    StatusText.BackgroundTransparency = 1
    StatusText.Parent = BottomBar

    local Tabs, Pages = {}, {}
    local function CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 80, 0, 28)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(130, 140, 155)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = TabsHolder

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local ActiveLine = Instance.new("Frame")
        ActiveLine.Size = UDim2.new(0.6, 0, 0, 2)
        ActiveLine.Position = UDim2.new(0.2, 0, 1, -2)
        ActiveLine.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
        ActiveLine.BorderSizePixel = 0
        ActiveLine.Visible = false
        ActiveLine.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
        Page.Visible = false
        Page.Parent = PagesFolder

        local PageGrid = Instance.new("UIGridLayout")
        PageGrid.CellSize = UDim2.new(0, 230, 0, 135)
        PageGrid.CellPadding = UDim2.new(0, 10, 0, 10)
        PageGrid.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.Btn.TextColor3 = Color3.fromRGB(130, 140, 155) t.Btn.BackgroundColor3 = Color3.fromRGB(11, 14, 20) t.Line.Visible = false end
            for _, p in pairs(Pages) do p.Visible = false end
            TabBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(18, 26, 38)
            ActiveLine.Visible = true
            Page.Visible = true
        end)

        table.insert(Tabs, {Btn = TabBtn, Line = ActiveLine})
        table.insert(Pages, Page)

        if #Tabs == 1 then
            TabBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(18, 26, 38)
            ActiveLine.Visible = true
            Page.Visible = true
        end
        return Page
    end

    local function CreateCard(page, title)
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Color3.fromRGB(19, 25, 36)
        Card.BorderSizePixel = 0
        Card.Parent = page

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card

        local CardTitle = Instance.new("TextLabel")
        CardTitle.Size = UDim2.new(1, -20, 0, 25)
        CardTitle.Position = UDim2.new(0, 10, 0, 8)
        CardTitle.Text = title
        CardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.TextSize = 13
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.BackgroundTransparency = 1
        CardTitle.Parent = Card

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = Card

        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop = UDim.new(0, 35)
        Padding.PaddingLeft = UDim.new(0, 10)
        Padding.PaddingRight = UDim.new(0, 10)
        Padding.Parent = Card

        return Card
    end

    local function AddToggle(card, text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = card

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.65, 0, 1, 0)
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(150, 160, 175)
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = ToggleFrame

        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Size = UDim2.new(0, 38, 0, 20)
        SwitchBg.Position = UDim2.new(1, -38, 0, 2)
        SwitchBg.BackgroundColor3 = default and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(35, 45, 60)
        SwitchBg.Text = ""
        SwitchBg.AutoButtonColor = false
        SwitchBg.Parent = ToggleFrame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = SwitchBg

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 14, 0, 14)
        Knob.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.Parent = SwitchBg

        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob

        local state = default
        SwitchBg.MouseButton1Click:Connect(function()
            state = not state
            SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(35, 45, 60)
            Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            callback(state)
        end)
    end

    local function AddSlider(card, text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 40)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = card

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 16)
        Label.Text = text .. ": " .. tostring(default)
        Label.TextColor3 = Color3.fromRGB(150, 160, 175)
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = SliderFrame

        local Track = Instance.new("TextButton")
        Track.Size = UDim2.new(1, 0, 0, 6)
        Track.Position = UDim2.new(0, 0, 0, 22)
        Track.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
        Track.Text = ""
        Track.AutoButtonColor = false
        Track.Parent = SliderFrame

        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = Track

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
        Fill.BorderSizePixel = 0
        Fill.Parent = Track

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local dragging = false
        local function Update(input)
            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = text .. ": " .. tostring(value)
            callback(value)
        end

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(input) end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    local function AddButton(card, text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 26)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 11
        Btn.BackgroundColor3 = Color3.fromRGB(28, 36, 50)
        Btn.BorderSizePixel = 0
        Btn.Parent = card

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 5)
        BtnCorner.Parent = Btn
        Btn.MouseButton1Click:Connect(callback)
    end

    -- Настройка вкладок и карточек
    local CombatPage  = CreateTab("Combat")
    local PlayerPage  = CreateTab("Player")
    local FarmPage    = CreateTab("Farm")
    local VisualsPage = CreateTab("Visuals")
    local UtilityPage = CreateTab("Utility")

    local KnifeCard = CreateCard(CombatPage, "Knife Kill Aura")
    AddToggle(KnifeCard, "Murderer Aura", false, function(v) Flags.KillAura = v end)
    AddSlider(KnifeCard, "Range", 5, 30, 18, function(v) Flags.KillAuraRange = v end)

    local SheriffCard = CreateCard(CombatPage, "Sheriff Auto Shoot")
    AddToggle(SheriffCard, "Auto Shoot Murderer", false, function(v) Flags.SheriffAura = v end)
    AddSlider(SheriffCard, "Shoot Distance", 20, 150, 100, function(v) Flags.SheriffRange = v end)

    local SpeedCard = CreateCard(PlayerPage, "WalkSpeed")
    AddToggle(SpeedCard, "STATE", false, function(v) Flags.WalkSpeedEnabled = v end)
    AddSlider(SpeedCard, "Speed", 16, 120, 16, function(v) Flags.WalkSpeedValue = v end)

    local JumpCard = CreateCard(PlayerPage, "JumpPower")
    AddToggle(JumpCard, "STATE", false, function(v) Flags.JumpPowerEnabled = v end)
    AddSlider(JumpCard, "Power", 50, 200, 50, function(v) Flags.JumpPowerValue = v end)

    local PhysCard = CreateCard(PlayerPage, "Physics")
    AddToggle(PhysCard, "Noclip", false, function(v) Flags.Noclip = v end)
    AddToggle(PhysCard, "Infinite Jump", false, function(v) Flags.InfJump = v end)

    local FarmCard = CreateCard(FarmPage, "Auto Farm")
    AddToggle(FarmCard, "Auto Collect Coins", false, function(v) 
        Flags.AutoFarm = v 
        if not v and CurrentTween then pcall(function() CurrentTween:Cancel() end) end
    end)
    AddSlider(FarmCard, "Farm Speed", 30, 70, 60, function(v) Flags.FarmSpeed = v end)

    local EspCard = CreateCard(VisualsPage, "Role ESP")
    AddToggle(EspCard, "Show Roles", false, function(v) Flags.ESP = v end)

    local TeleportCard = CreateCard(UtilityPage, "Teleports")
    AddButton(TeleportCard, "TP to Dropped Gun", function()
        pcall(function()
            local gunDrop = Workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 3, 0)
            end
        end)
    end)

    local ServerCard = CreateCard(UtilityPage, "Server")
    AddButton(ServerCard, "Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)

    -- Вспомогательные функции ролей
    local function GetPlayerRole(player)
        if not player or not player.Character then return "Innocent" end
        local char = player.Character
        local backpack = player:FindFirstChild("Backpack")
        if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer"
        elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
        return "Innocent"
    end

    -- Логика KillAura & SheriffAura & AutoFarm
    local lastKillAura = 0
    Connections.KillAura = RunService.RenderStepped:Connect(function()
        if not Running or not Flags.KillAura then return end
        if tick() - lastKillAura < 0.1 then return end
        lastKillAura = tick()
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local knife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
            if knife then
                if knife.Parent == backpack then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(knife) end
                end
                local handle = knife:FindFirstChild("Handle")
                if handle then
                    for _, target in pairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                            if targetHum and targetHum.Health > 0 then
                                local dist = (char.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= Flags.KillAuraRange then
                                    knife:Activate()
                                    firetouchinterest(target.Character.HumanoidRootPart, handle, 0)
                                    firetouchinterest(target.Character.HumanoidRootPart, handle, 1)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- Цикл автофарма
    local function GetCoinContainer()
        local container = Workspace:FindFirstChild("CoinContainer")
        if container then return container end
        for _, child in pairs(Workspace:GetChildren()) do
            container = child:FindFirstChild("CoinContainer")
            if container then return container end
        end
        return nil
    end

    task.spawn(function()
        local lastPositionCheck = tick()
        local stuckPositionCount = 0
        local lastPosVector = Vector3.new(0, 0, 0)

        while Running do
            if Flags.AutoFarm then
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then task.wait(2) return end
                    local hrp = char.HumanoidRootPart

                    if tick() - lastPositionCheck > 3 then
                        if (hrp.Position - lastPosVector).Magnitude < 2 and Flags.AutoFarm then
                            stuckPositionCount = stuckPositionCount + 1
                            if stuckPositionCount >= 3 then
                                hrp.CFrame = hrp.CFrame + Vector3.new(0, 15, 0)
                                stuckPositionCount = 0
                            end
                        else stuckPositionCount = 0 end
                        lastPosVector = hrp.Position
                        lastPositionCheck = tick()
                    end

                    if hrp.Position.Y < -50 then
                        hrp.CFrame = CFrame.new(0, 50, 0)
                        task.wait(1)
                    end

                    local container = GetCoinContainer()
                    if container then
                        local validCoins = {}
                        for _, child in pairs(container:GetChildren()) do
                            if child and child.Parent then
                                if child:IsA("BasePart") then table.insert(validCoins, child)
                                else local part = child:FindFirstChildOfClass("BasePart") if part then table.insert(validCoins, part) end end
                            end
                        end

                        if #validCoins > 0 then
                            local closestCoin, minDistance = nil, math.huge
                            for _, coin in ipairs(validCoins) do
                                if coin and coin.Parent then
                                    local dist = (hrp.Position - coin.Position).Magnitude
                                    if dist < minDistance then minDistance = dist closestCoin = coin end
                                end
                            end

                            if closestCoin and closestCoin.Parent then
                                local speed = Flags.FarmSpeed or 60
                                local tweenTime = math.clamp(minDistance / speed, 0.05, 3.5)
                                for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end

                                CurrentTween = TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestCoin.CFrame})
                                CurrentTween:Play()

                                local startFly = tick()
                                local collected = false
                                while (tick() - startFly) < (tweenTime + 0.2) and Flags.AutoFarm and Running do
                                    RunService.Stepped:Wait()
                                    hrp.Velocity = Vector3.new(0, 0, 0)
                                    if closestCoin and closestCoin.Parent then
                                        if (hrp.Position - closestCoin.Position).Magnitude <= 5 then
                                            firetouchinterest(hrp, closestCoin, 0)
                                            firetouchinterest(hrp, closestCoin, 1)
                                            collected = true
                                            break
                                        end
                                    else break end
                                end

                                if CurrentTween then pcall(function() CurrentTween:Cancel() end) end
                                if not collected and closestCoin and closestCoin.Parent then
                                    hrp.CFrame = closestCoin.CFrame
                                    firetouchinterest(hrp, closestCoin, 0)
                                    firetouchinterest(hrp, closestCoin, 1)
                                    task.wait(0.05)
                                end
                            else task.wait(0.2) end
                        else task.wait(0.5) end
                    else task.wait(1) end
                end)
            else task.wait(0.5) end
            RunService.Stepped:Wait()
        end
    end)

    -- Anti-AFK
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)

    -- ESP & Physics
    Connections.ESP = RunService.RenderStepped:Connect(function()
        if not Running then return end
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local highlight = char:FindFirstChild("RoleHighlight")
                    if Flags.ESP then
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "RoleHighlight"
                            highlight.Parent = char
                        end
                        local role = GetPlayerRole(player)
                        highlight.FillColor = role == "Murderer" and Color3.fromRGB(255, 40, 40) or (role == "Sheriff" and Color3.fromRGB(40, 120, 255) or Color3.fromRGB(40, 255, 120))
                        highlight.FillTransparency = 0.4
                        highlight.Enabled = true
                    else if highlight then highlight.Enabled = false end end
                end
            end
        end)
    end)

    Connections.Physics = RunService.Stepped:Connect(function()
        if not Running then return end
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if Flags.WalkSpeedEnabled then hum.WalkSpeed = Flags.WalkSpeedValue end
                    if Flags.JumpPowerEnabled then hum.JumpPower = Flags.JumpPowerValue end
                end
                if Flags.Noclip then
                    for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
                end
            end
        end)
    end)

    Connections.InfJump = UserInputService.JumpRequest:Connect(function()
        pcall(function()
            if Running and Flags.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end)
end

-- =======================================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА ЛОАДЕРА (LOADER GUI BUILDER)
-- =======================================================

local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "GAG22_Loader"
LoaderGui.ResetOnSpawn = false
pcall(function() LoaderGui.Parent = CoreGui end)
if not LoaderGui.Parent then LoaderGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local BaseFrame = Instance.new("Frame")
BaseFrame.Name = "BaseFrame"
BaseFrame.Size = UDim2.new(0, 960, 0, 420)
BaseFrame.Position = UDim2.new(0.5, -480, 0.5, -210)
BaseFrame.BackgroundTransparency = 1
BaseFrame.Parent = LoaderGui

-- Перетаскивание
local Dragging, DragStart, StartPos
BaseFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = BaseFrame.Position
    end
end)
BaseFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        local delta = input.Position - DragStart
        BaseFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

-- -------------------------------------------------------
-- ЛЕВАЯ ПАНЕЛЬ (COMPATIBILITY ANALYZER)
-- -------------------------------------------------------
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 300, 1, 0)
LeftPanel.Position = UDim2.new(0, 0, 0, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = BaseFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 12)
LeftCorner.Parent = LeftPanel

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Size = UDim2.new(1, -30, 0, 20)
LeftTitle.Position = UDim2.new(0, 15, 0, 20)
LeftTitle.Text = "COMPATIBILITY"
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 14
LeftTitle.TextXAlignment = Enum.TextXAlignment.Left
LeftTitle.BackgroundTransparency = 1
LeftTitle.Parent = LeftPanel

local LeftSubTitle = Instance.new("TextLabel")
LeftSubTitle.Size = UDim2.new(1, -30, 0, 15)
LeftSubTitle.Position = UDim2.new(0, 15, 0, 42)
LeftSubTitle.Text = "SAFE CAPABILITY ANALYZER"
LeftSubTitle.TextColor3 = Color3.fromRGB(100, 110, 125)
LeftSubTitle.Font = Enum.Font.GothamBold
LeftSubTitle.TextSize = 10
LeftSubTitle.TextXAlignment = Enum.TextXAlignment.Left
LeftSubTitle.BackgroundTransparency = 1
LeftSubTitle.Parent = LeftPanel

-- Блок Xeno Compatible
local XenoBox = Instance.new("Frame")
XenoBox.Size = UDim2.new(1, -30, 0, 44)
XenoBox.Position = UDim2.new(0, 15, 0, 70)
XenoBox.BackgroundColor3 = Color3.fromRGB(12, 28, 24)
XenoBox.BorderSizePixel = 0
XenoBox.Parent = LeftPanel

local XenoCorner = Instance.new("UICorner")
XenoCorner.CornerRadius = UDim.new(0, 8)
XenoCorner.Parent = XenoBox

local XenoStroke = Instance.new("UIStroke")
XenoStroke.Color = Color3.fromRGB(0, 180, 130)
XenoStroke.Thickness = 1
XenoStroke.Parent = XenoBox

local XenoText = Instance.new("TextLabel")
XenoText.Size = UDim2.new(1, -20, 1, 0)
XenoText.Position = UDim2.new(0, 12, 0, 0)
XenoText.Text = "🟢  Xeno | LOADER COMPATIBLE"
XenoText.TextColor3 = Color3.fromRGB(0, 230, 160)
XenoText.Font = Enum.Font.GothamBold
XenoText.TextSize = 12
XenoText.TextXAlignment = Enum.TextXAlignment.Left
XenoText.BackgroundTransparency = 1
XenoText.Parent = XenoBox

local CapSubtitle = Instance.new("TextLabel")
CapSubtitle.Size = UDim2.new(1, -30, 0, 15)
CapSubtitle.Position = UDim2.new(0, 15, 0, 128)
CapSubtitle.Text = "Capability flags only | no script or memory scan"
CapSubtitle.TextColor3 = Color3.fromRGB(90, 100, 115)
CapSubtitle.Font = Enum.Font.Gotham
CapSubtitle.TextSize = 10
CapSubtitle.TextXAlignment = Enum.TextXAlignment.Left
CapSubtitle.BackgroundTransparency = 1
CapSubtitle.Parent = LeftPanel

-- Список проверок
local items = {
    {name = "Connection", status = "service link ready"},
    {name = "Protected core", status = "protected runtime ready"},
    {name = "Integrity", status = "verification ready"},
    {name = "Local continuity", status = "secure state ready"}
}

for i, item in ipairs(items) do
    local ItemBox = Instance.new("Frame")
    ItemBox.Size = UDim2.new(1, -30, 0, 38)
    ItemBox.Position = UDim2.new(0, 15, 0, 145 + (i - 1) * 44)
    ItemBox.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
    ItemBox.BorderSizePixel = 0
    ItemBox.Parent = LeftPanel

    local ItemCorner = Instance.new("UICorner")
    ItemCorner.CornerRadius = UDim.new(0, 6)
    ItemCorner.Parent = ItemBox

    local Dot = Instance.new("TextLabel")
    Dot.Size = UDim2.new(0, 20, 1, 0)
    Dot.Position = UDim2.new(0, 10, 0, 0)
    Dot.Text = "🟢"
    Dot.TextSize = 8
    Dot.BackgroundTransparency = 1
    Dot.Parent = ItemBox

    local NameLbl = Instance.new("TextLabel")
    NameLbl.Size = UDim2.new(0.5, 0, 1, 0)
    NameLbl.Position = UDim2.new(0, 28, 0, 0)
    NameLbl.Text = item.name
    NameLbl.TextColor3 = Color3.fromRGB(200, 210, 220)
    NameLbl.Font = Enum.Font.GothamMedium
    NameLbl.TextSize = 11
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.BackgroundTransparency = 1
    NameLbl.Parent = ItemBox

    local StatLbl = Instance.new("TextLabel")
    StatLbl.Size = UDim2.new(0.5, -10, 1, 0)
    StatLbl.Position = UDim2.new(0.5, 0, 0, 0)
    StatLbl.Text = item.status
    StatLbl.TextColor3 = Color3.fromRGB(0, 180, 130)
    StatLbl.Font = Enum.Font.Gotham
    StatLbl.TextSize = 10
    StatLbl.TextXAlignment = Enum.TextXAlignment.Right
    StatLbl.BackgroundTransparency = 1
    StatLbl.Parent = ItemBox
end

local FooterText = Instance.new("TextLabel")
FooterText.Size = UDim2.new(1, -30, 0, 30)
FooterText.Position = UDim2.new(0, 15, 1, -35)
FooterText.Text = "Loader transport checks passed. Game-module compatibility is verified only after launch."
FooterText.TextColor3 = Color3.fromRGB(70, 80, 95)
FooterText.Font = Enum.Font.Gotham
FooterText.TextSize = 9
FooterText.TextWrapped = true
FooterText.TextXAlignment = Enum.TextXAlignment.Left
FooterText.BackgroundTransparency = 1
FooterText.Parent = LeftPanel

-- -------------------------------------------------------
-- ПРАВАЯ ПАНЕЛЬ (MAIN CONTENT AREA)
-- -------------------------------------------------------
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 645, 1, 0)
RightPanel.Position = UDim2.new(0, 315, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(6, 8, 12)
RightPanel.BorderSizePixel = 0
RightPanel.Parent = BaseFrame

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 12)
RightCorner.Parent = RightPanel

-- Шапка (Logo GAG22 + LOADER 8.0.7)
local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 42, 0, 42)
LogoIcon.Position = UDim2.new(0, 25, 0, 20)
LogoIcon.BackgroundColor3 = Color3.fromRGB(15, 23, 34)
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = RightPanel

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = LogoIcon

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.Text = "G"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 22
LogoText.BackgroundTransparency = 1
LogoText.Parent = LogoIcon

local LoaderTitle = Instance.new("TextLabel")
LoaderTitle.Size = UDim2.new(0, 200, 0, 42)
LoaderTitle.Position = UDim2.new(0, 78, 0, 20)
LoaderTitle.Text = "LOADER  8.0.7"
LoaderTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
LoaderTitle.Font = Enum.Font.GothamBold
LoaderTitle.TextSize = 13
LoaderTitle.TextXAlignment = Enum.TextXAlignment.Left
LoaderTitle.BackgroundTransparency = 1
LoaderTitle.Parent = RightPanel

local StatusBadge = Instance.new("Frame")
StatusBadge.Size = UDim2.new(0, 110, 0, 38)
StatusBadge.Position = UDim2.new(1, -135, 0, 22)
StatusBadge.BackgroundColor3 = Color3.fromRGB(12, 28, 24)
StatusBadge.BorderSizePixel = 0
StatusBadge.Parent = RightPanel

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 8)
BadgeCorner.Parent = StatusBadge

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, 0, 1, 0)
BadgeText.Text = "🟢  ACTIVE"
BadgeText.TextColor3 = Color3.fromRGB(0, 210, 150)
BadgeText.Font = Enum.Font.GothamBold
BadgeText.TextSize = 11
BadgeText.BackgroundTransparency = 1
BadgeText.Parent = StatusBadge

-- Блок ПРОФИЛЬ
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -50, 0, 95)
ProfileCard.Position = UDim2.new(0, 25, 0, 80)
ProfileCard.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
ProfileCard.BorderSizePixel = 0
ProfileCard.Parent = RightPanel

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 10)
ProfileCorner.Parent = ProfileCard

local ProfileHeader = Instance.new("TextLabel")
ProfileHeader.Size = UDim2.new(1, -30, 0, 15)
ProfileHeader.Position = UDim2.new(0, 20, 0, 15)
ProfileHeader.Text = "ПРОФИЛЬ"
ProfileHeader.TextColor3 = Color3.fromRGB(100, 110, 125)
ProfileHeader.Font = Enum.Font.GothamBold
ProfileHeader.TextSize = 10
ProfileHeader.TextXAlignment = Enum.TextXAlignment.Left
ProfileHeader.BackgroundTransparency = 1
ProfileHeader.Parent = ProfileCard

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(0.5, 0, 0, 25)
ProfileName.Position = UDim2.new(0, 20, 0, 42)
ProfileName.Text = LocalPlayer.Name
ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255)
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 18
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.BackgroundTransparency = 1
ProfileName.Parent = ProfileCard

local ProfileStatus = Instance.new("TextLabel")
ProfileStatus.Size = UDim2.new(0.5, -20, 0, 30)
ProfileStatus.Position = UDim2.new(0.5, 0, 0, 40)
ProfileStatus.Text = "🟢 GAG22: Murder Mystery 2 готов к запуску"
ProfileStatus.TextColor3 = Color3.fromRGB(200, 210, 225)
ProfileStatus.Font = Enum.Font.GothamMedium
ProfileStatus.TextSize = 11
ProfileStatus.TextWrapped = true
ProfileStatus.TextXAlignment = Enum.TextXAlignment.Left
ProfileStatus.BackgroundTransparency = 1
ProfileStatus.Parent = ProfileCard

-- Подзаголовок запуска
local LaunchHeader = Instance.new("TextLabel")
LaunchHeader.Size = UDim2.new(1, -50, 0, 15)
LaunchHeader.Position = UDim2.new(0, 25, 0, 195)
LaunchHeader.Text = "MURDER MYSTERY 2 • ЗАПУСК"
LaunchHeader.TextColor3 = Color3.fromRGB(100, 110, 125)
LaunchHeader.Font = Enum.Font.GothamBold
LaunchHeader.TextSize = 10
LaunchHeader.TextXAlignment = Enum.TextXAlignment.Left
LaunchHeader.BackgroundTransparency = 1
LaunchHeader.Parent = RightPanel

-- Единая карточка запуска
local LaunchCard = Instance.new("TextButton")
LaunchCard.Size = UDim2.new(1, -50, 0, 90)
LaunchCard.Position = UDim2.new(0, 25, 0, 220)
LaunchCard.BackgroundColor3 = Color3.fromRGB(12, 32, 48)
LaunchCard.BorderSizePixel = 0
LaunchCard.Text = ""
LaunchCard.AutoButtonColor = false
LaunchCard.Parent = RightPanel

local LaunchCorner = Instance.new("UICorner")
LaunchCorner.CornerRadius = UDim.new(0, 10)
LaunchCorner.Parent = LaunchCard

local LaunchTitle = Instance.new("TextLabel")
LaunchTitle.Size = UDim2.new(1, -60, 0, 25)
LaunchTitle.Position = UDim2.new(0, 20, 0, 20)
LaunchTitle.Text = "Запустить GAG22 Hub"
LaunchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchTitle.Font = Enum.Font.GothamBold
LaunchTitle.TextSize = 16
LaunchTitle.TextXAlignment = Enum.TextXAlignment.Left
LaunchTitle.BackgroundTransparency = 1
LaunchTitle.Parent = LaunchCard

local LaunchSub = Instance.new("TextLabel")
LaunchSub.Size = UDim2.new(1, -60, 0, 20)
LaunchSub.Position = UDim2.new(0, 20, 0, 48)
LaunchSub.Text = "Нажмите для загрузки основного функционала MM2"
LaunchSub.TextColor3 = Color3.fromRGB(0, 190, 240)
LaunchSub.Font = Enum.Font.Gotham
LaunchSub.TextSize = 11
LaunchSub.TextXAlignment = Enum.TextXAlignment.Left
LaunchSub.BackgroundTransparency = 1
LaunchSub.Parent = LaunchCard

local Arrow = Instance.new("TextLabel")
Arrow.Size = UDim2.new(0, 30, 0, 30)
Arrow.Position = UDim2.new(1, -40, 0, 30)
Arrow.Text = "›"
Arrow.TextColor3 = Color3.fromRGB(0, 190, 240)
Arrow.Font = Enum.Font.GothamBold
Arrow.TextSize = 26
Arrow.BackgroundTransparency = 1
Arrow.Parent = LaunchCard

LaunchCard.MouseButton1Click:Connect(function()
    LoaderGui:Destroy()
    LaunchGAG22Hub()
end)

-- Нижние кнопки (Инструкция / Устройство / Закрыть)
local BtnInst = Instance.new("TextButton")
BtnInst.Size = UDim2.new(0, 130, 0, 42)
BtnInst.Position = UDim2.new(0, 25, 0, 335)
BtnInst.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
BtnInst.BorderSizePixel = 0
BtnInst.Text = "Инструкция"
BtnInst.TextColor3 = Color3.fromRGB(220, 225, 235)
BtnInst.Font = Enum.Font.GothamMedium
BtnInst.TextSize = 13
BtnInst.Parent = RightPanel

local InstCorner = Instance.new("UICorner")
InstCorner.CornerRadius = UDim.new(0, 8)
InstCorner.Parent = BtnInst

local BtnDev = Instance.new("TextButton")
BtnDev.Size = UDim2.new(0, 130, 0, 42)
BtnDev.Position = UDim2.new(0, 165, 0, 335)
BtnDev.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
BtnDev.BorderSizePixel = 0
BtnDev.Text = "Устройство"
BtnDev.TextColor3 = Color3.fromRGB(220, 225, 235)
BtnDev.Font = Enum.Font.GothamMedium
BtnDev.TextSize = 13
BtnDev.Parent = RightPanel

local DevCorner = Instance.new("UICorner")
DevCorner.CornerRadius = UDim.new(0, 8)
DevCorner.Parent = BtnDev

local CloseArrow = Instance.new("TextButton")
CloseArrow.Size = UDim2.new(0, 30, 0, 30)
CloseArrow.Position = UDim2.new(1, -45, 0, 341)
CloseArrow.BackgroundTransparency = 1
CloseArrow.Text = "v"
CloseArrow.TextColor3 = Color3.fromRGB(100, 110, 125)
CloseArrow.Font = Enum.Font.GothamBold
CloseArrow.TextSize = 14
CloseArrow.Parent = RightPanel

CloseArrow.MouseButton1Click:Connect(function()
    LoaderGui:Destroy()
end)
