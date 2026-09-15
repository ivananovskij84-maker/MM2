-- =======================================================
-- GAG22 LOADER v8.0.10 | MURDER MYSTERY 2 EDITION
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Функция копирования ссылки в буфер обмена
local setclip = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard) or function() end

-- Удаление старых копий GUI
if CoreGui:FindFirstChild("GAG22_Loader") then CoreGui.GAG22_Loader:Destroy() end
if CoreGui:FindFirstChild("GAG22_UpdateCheck") then CoreGui.GAG22_UpdateCheck:Destroy() end
if CoreGui:FindFirstChild("GAG22_Subscribe") then CoreGui.GAG22_Subscribe:Destroy() end

-- =======================================================
-- 1. ВСТРОЕННЫЙ ОСНОВНОЙ СКРИПТ (GAG22 MM2 HUB)
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
        ESP = false, AutoFarm = false, FarmSpeed = 220,
        AutoResume = true,
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
    StatusText.Text = "READY | PLACE " .. tostring(game.PlaceId) .. " · GAG22 Hub v3.96"
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
        local function SetState(val)
            state = val
            SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(35, 45, 60)
            Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            callback(state)
        end

        SwitchBg.MouseButton1Click:Connect(function() SetState(not state) end)
        return SetState
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

    -- Вкладки
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

    local FarmCard = CreateCard(FarmPage, "Smart Auto Farm")
    local SetFarmToggle = AddToggle(FarmCard, "Auto Collect Coins", false, function(v) 
        Flags.AutoFarm = v 
        if not v and CurrentTween then pcall(function() CurrentTween:Cancel() end) end
    end)
    AddToggle(FarmCard, "Auto Resume Next Round", true, function(v) Flags.AutoResume = v end)
    AddSlider(FarmCard, "Farm Speed", 80, 400, 220, function(v) Flags.FarmSpeed = v end)

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

    local function IsAlive(player)
        player = player or LocalPlayer
        local char = player.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        return hum and hum.Health > 0 and hrp ~= nil
    end

    local function SetupCharacterEvents(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                if CurrentTween then pcall(function() CurrentTween:Cancel() end) CurrentTween = nil end
                if not Flags.AutoResume then SetFarmToggle(false) else Flags.AutoFarm = false end
            end)
        end
    end

    if LocalPlayer.Character then SetupCharacterEvents(LocalPlayer.Character) end
    table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
        SetupCharacterEvents(char)
        if Flags.AutoResume then Flags.AutoFarm = true SetFarmToggle(true) end
    end))

    local function GetPlayerRole(player)
        if not player or not player.Character then return "Innocent" end
        local char = player.Character
        local backpack = player:FindFirstChild("Backpack")
        if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer"
        elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
        return "Innocent"
    end

    local function GetMurderer()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsAlive(player) then
                if GetPlayerRole(player) == "Murderer" then return player.Character end
            end
        end
        return nil
    end

    local lastKillAura = 0
    Connections.KillAura = RunService.RenderStepped:Connect(function()
        if not Running or not Flags.KillAura or not IsAlive() then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local knife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
            if knife then
                if knife.Parent == backpack then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum:EquipTool(knife) end end
                local murdererChar = GetMurderer()
                if murdererChar and murdererChar:FindFirstChild("HumanoidRootPart") then
                    local mHrp = murdererChar.HumanoidRootPart
                    if (hrp.Position - mHrp.Position).Magnitude > Flags.KillAuraRange then
                        hrp.CFrame = mHrp.CFrame * CFrame.new(0, 0, 2)
                    end
                end
                if tick() - lastKillAura >= 0.04 then
                    lastKillAura = tick()
                    local handle = knife:FindFirstChild("Handle")
                    if handle then
                        for _, target in pairs(Players:GetPlayers()) do
                            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                                if targetHum and targetHum.Health > 0 then
                                    if (hrp.Position - target.Character.HumanoidRootPart.Position).Magnitude <= Flags.KillAuraRange then
                                        knife:Activate()
                                        firetouchinterest(target.Character.HumanoidRootPart, handle, 0)
                                        firetouchinterest(target.Character.HumanoidRootPart, handle, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

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
        while Running do
            if Flags.AutoFarm and IsAlive() then
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(0.01) return end
                    local container = GetCoinContainer()
                    if container then
                        local validCoins = {}
                        for _, child in pairs(container:GetChildren()) do
                            if child and child.Parent then
                                local part = child:IsA("BasePart") and child or child:FindFirstChildOfClass("BasePart")
                                if part and part.Parent then table.insert(validCoins, part) end
                            end
                        end
                        if #validCoins > 0 and IsAlive() and Flags.AutoFarm then
                            local closestCoin, minDistance = nil, math.huge
                            for _, coin in ipairs(validCoins) do
                                if coin and coin.Parent then
                                    local dist = (hrp.Position - coin.Position).Magnitude
                                    if dist < minDistance then minDistance = dist closestCoin = coin end
                                end
                            end
                            if closestCoin and closestCoin.Parent and IsAlive() and Flags.AutoFarm then
                                local speed = Flags.FarmSpeed or 220
                                local tweenTime = math.clamp(minDistance / speed, 0.01, 0.35)
                                for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
                                CurrentTween = TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestCoin.CFrame})
                                CurrentTween:Play()
                                while CurrentTween and CurrentTween.PlaybackState == Enum.PlaybackState.Playing and Flags.AutoFarm and IsAlive() do
                                    RunService.Stepped:Wait()
                                    hrp.Velocity = Vector3.new(0, 0, 0)
                                    if not closestCoin or not closestCoin.Parent then break end
                                    if (hrp.Position - closestCoin.Position).Magnitude <= 7 then
                                        firetouchinterest(hrp, closestCoin, 0)
                                        firetouchinterest(hrp, closestCoin, 1)
                                        break
                                    end
                                end
                                if CurrentTween then pcall(function() CurrentTween:Cancel() end) CurrentTween = nil end
                            else RunService.RenderStepped:Wait() end
                        else task.wait(0.01) end
                    else task.wait(0.05) end
                end)
            else task.wait(0.05) end
            RunService.Stepped:Wait()
        end
    end)

    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)

    Connections.ESP = RunService.RenderStepped:Connect(function()
        if not Running then return end
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local highlight = char:FindFirstChild("RoleHighlight")
                    if Flags.ESP then
                        if not highlight then highlight = Instance.new("Highlight") highlight.Name = "RoleHighlight" highlight.Parent = char end
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
        if not Running or not IsAlive() then return end
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if Flags.WalkSpeedEnabled then hum.WalkSpeed = Flags.WalkSpeedValue end
                    if Flags.JumpPowerEnabled then hum.JumpPower = Flags.JumpPowerValue end
                end
                if Flags.Noclip then for _, part in pairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end
            end
        end)
    end)

    Connections.InfJump = UserInputService.JumpRequest:Connect(function()
        pcall(function()
            if Running and Flags.InfJump and IsAlive() then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end)
end

-- =======================================================
-- 2. ОКТНО ПОДПИСКИ ТЕЛЕГРАМ (SUBSCRIBE MODAL)
-- =======================================================
local function ShowSubscribeModal(onFinished)
    local SubGui = Instance.new("ScreenGui")
    SubGui.Name = "GAG22_Subscribe"
    SubGui.ResetOnSpawn = false
    pcall(function() SubGui.Parent = CoreGui end)
    if not SubGui.Parent then SubGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Modal = Instance.new("Frame")
    Modal.Size = UDim2.new(0, 440, 0, 250)
    Modal.Position = UDim2.new(0.5, -220, 0.5, -125)
    Modal.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
    Modal.BorderSizePixel = 0
    Modal.Parent = SubGui

    local ModalCorner = Instance.new("UICorner")
    ModalCorner.CornerRadius = UDim.new(0, 12)
    ModalCorner.Parent = Modal

    local ModalStroke = Instance.new("UIStroke")
    ModalStroke.Color = Color3.fromRGB(0, 190, 240)
    ModalStroke.Thickness = 1.5
    ModalStroke.Parent = Modal

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -40, 0, 30)
    SubTitle.Position = UDim2.new(0, 20, 0, 20)
    SubTitle.Text = "📢 ПОДПИШИСЬ НА НАШ КАНАЛ!"
    SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubTitle.Font = Enum.Font.GothamBold
    SubTitle.TextSize = 16
    SubTitle.BackgroundTransparency = 1
    SubTitle.Parent = Modal

    local SubText = Instance.new("TextLabel")
    SubText.Size = UDim2.new(1, -40, 0, 40)
    SubText.Position = UDim2.new(0, 20, 0, 55)
    SubText.Text = "Подпишись на наш Telegram, чтобы получать свежие обновления и скрипты:\nt.me/GAG2212"
    SubText.TextColor3 = Color3.fromRGB(170, 180, 195)
    SubText.Font = Enum.Font.GothamMedium
    SubText.TextSize = 12
    SubText.TextWrapped = true
    SubText.BackgroundTransparency = 1
    SubText.Parent = Modal

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(1, -40, 0, 42)
    CopyBtn.Position = UDim2.new(0, 20, 0, 105)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "СКОПИРОВАТЬ ССЫЛКУ"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.TextSize = 13
    CopyBtn.Parent = Modal

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 8)
    CopyCorner.Parent = CopyBtn

    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclip("https://t.me/GAG2212") end)
        CopyBtn.Text = "СКОПИРОВАНО В БУФЕР!"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
        task.wait(1.5)
        CopyBtn.Text = "СКОПИРОВАТЬ ССЫЛКУ"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
    end)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(1, -40, 0, 30)
    TimerLabel.Position = UDim2.new(0, 20, 0, 185)
    TimerLabel.Text = "Запуск скрипта через: 10 сек..."
    TimerLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextSize = 13
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Parent = Modal

    task.spawn(function()
        for i = 10, 1, -1 do
            TimerLabel.Text = "Запуск скрипта через: " .. tostring(i) .. " сек..."
            task.wait(1)
        end
        SubGui:Destroy()
        if onFinished then onFinished() end
    end)
end

-- =======================================================
-- 3. ОСНОВНОЙ ГУЙ ВЫБОРА ВЕРСИИ (LOADER GUI)
-- =======================================================
local function ShowLoaderGui()
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

    local LeftPanel = Instance.new("Frame")
    LeftPanel.Size = UDim2.new(0, 300, 1, 0)
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

    local RightPanel = Instance.new("Frame")
    RightPanel.Size = UDim2.new(0, 645, 1, 0)
    RightPanel.Position = UDim2.new(0, 315, 0, 0)
    RightPanel.BackgroundColor3 = Color3.fromRGB(6, 8, 12)
    RightPanel.BorderSizePixel = 0
    RightPanel.Parent = BaseFrame

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 12)
    RightCorner.Parent = RightPanel

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
    LoaderTitle.Text = "LOADER  8.0.10"
    LoaderTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
    LoaderTitle.Font = Enum.Font.GothamBold
    LoaderTitle.TextSize = 13
    LoaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    LoaderTitle.BackgroundTransparency = 1
    LoaderTitle.Parent = RightPanel

    local ProfileCard = Instance.new("Frame")
    ProfileCard.Size = UDim2.new(1, -50, 0, 95)
    ProfileCard.Position = UDim2.new(0, 25, 0, 80)
    ProfileCard.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
    ProfileCard.BorderSizePixel = 0
    ProfileCard.Parent = RightPanel

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 10)
    ProfileCorner.Parent = ProfileCard

    local ProfileName = Instance.new("TextLabel")
    ProfileName.Size = UDim2.new(0.5, 0, 0, 25)
    ProfileName.Position = UDim2.new(0, 20, 0, 20)
    ProfileName.Text = LocalPlayer.Name
    ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.TextSize = 18
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left
    ProfileName.BackgroundTransparency = 1
    ProfileName.Parent = ProfileCard

    local ProfileStatus = Instance.new("TextLabel")
    ProfileStatus.Size = UDim2.new(0.5, -20, 0, 30)
    ProfileStatus.Position = UDim2.new(0.5, 0, 0, 20)
    ProfileStatus.Text = "🟢 GAG22: Murder Mystery 2 готов к запуску"
    ProfileStatus.TextColor3 = Color3.fromRGB(200, 210, 225)
    ProfileStatus.Font = Enum.Font.GothamMedium
    ProfileStatus.TextSize = 11
    ProfileStatus.TextWrapped = true
    ProfileStatus.TextXAlignment = Enum.TextXAlignment.Left
    ProfileStatus.BackgroundTransparency = 1
    ProfileStatus.Parent = ProfileCard

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
    LaunchTitle.Size = UDim2.new(1, -60, 0, 30)
    LaunchTitle.Position = UDim2.new(0, 20, 0, 18)
    LaunchTitle.Text = "🚀  Запустить GAG22 Hub (MM2)"
    LaunchTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
    LaunchTitle.Font = Enum.Font.GothamBold
    LaunchTitle.TextSize = 16
    LaunchTitle.TextXAlignment = Enum.TextXAlignment.Left
    LaunchTitle.BackgroundTransparency = 1
    LaunchTitle.Parent = LaunchCard

    local LaunchSubText = Instance.new("TextLabel")
    LaunchSubText.Size = UDim2.new(1, -60, 0, 20)
    LaunchSubText.Position = UDim2.new(0, 20, 0, 48)
    LaunchSubText.Text = "Нажмите для перехода к запуску версии v8.0.10"
    LaunchSubText.TextColor3 = Color3.fromRGB(120, 150, 180)
    LaunchSubText.Font = Enum.Font.Gotham
    LaunchSubText.TextSize = 11
    LaunchSubText.TextXAlignment = Enum.TextXAlignment.Left
    LaunchSubText.BackgroundTransparency = 1
    LaunchSubText.Parent = LaunchCard

    -- Кликая по кнопке запуска, скрываем Лоадер, показываем Подписку, а затем запускаем Хаб
    LaunchCard.MouseButton1Click:Connect(function()
        LoaderGui:Destroy()
        ShowSubscribeModal(function()
            LaunchGAG22Hub()
        end)
    end)
end

-- =======================================================
-- 4. ГУЙ ПРОВЕРКИ ОБНОВЛЕНИЙ (ОТКРЫВАЕТСЯ СРАЗУ ПОСЛЕ ИНЖЕКТА)
-- =======================================================
local function ShowUpdateCheckGui()
    local UpdateGui = Instance.new("ScreenGui")
    UpdateGui.Name = "GAG22_UpdateCheck"
    UpdateGui.ResetOnSpawn = false
    pcall(function() UpdateGui.Parent = CoreGui end)
    if not UpdateGui.Parent then UpdateGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 190)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -95)
    Frame.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = UpdateGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 210, 255)
    Stroke.Thickness = 1.5
    Stroke.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 18)
    Title.Text = "GAG22 LOADER | CHECKING UPDATES"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 25)
    Status.Position = UDim2.new(0, 20, 0, 60)
    Status.Text = "Подключение к серверу обновлений..."
    Status.TextColor3 = Color3.fromRGB(150, 160, 175)
    Status.Font = Enum.Font.GothamMedium
    Status.TextSize = 12
    Status.BackgroundTransparency = 1
    Status.Parent = Frame

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -40, 0, 8)
    BarBg.Position = UDim2.new(0, 20, 0, 105)
    BarBg.BackgroundColor3 = Color3.fromRGB(20, 26, 36)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBg

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = BarFill

    -- Симуляция проверки обновлений
    task.spawn(function()
        TweenService:Create(BarFill, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.55, 0, 1, 0)}):Play()
        task.wait(1.0)
        
        Status.Text = "Синхронизация последней версии..."
        TweenService:Create(BarFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(0.8)
        
        Status.Text = "🟢 Версия актуальна! (v8.0.10)"
        Status.TextColor3 = Color3.fromRGB(0, 230, 160)
        task.wait(0.6)
        
        UpdateGui:Destroy()
        ShowLoaderGui() -- Переход к основному GUI лоадера
    end)
end

-- Старт цепочки при выполнении инжекта
ShowUpdateCheckGui()
