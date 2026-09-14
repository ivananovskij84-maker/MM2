-- =======================================================
-- MM2 CONTROL CENTER (CRASH-FIXED & STABLE AUTO-FARM)
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Защита от повторного запуска
if CoreGui:FindFirstChild("MM2ControlCenter") then
    CoreGui.MM2ControlCenter:Destroy()
end

-- Переменные состояния
local Flags = {
    KillAura = false,
    KillAuraRange = 20,
    SheriffAura = false,
    SheriffRange = 100,
    ESP = false,
    AutoFarm = false,
    FarmSpeed = 60, -- Безопасная скорость во избежание киков
    Noclip = false,
    InfJump = false,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50
}

local Connections = {}
local Running = true
local CurrentTween = nil

-- Функция полного закрытия скрипта
local function UnloadScript()
    Running = false
    if CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end
    
    for _, conn in pairs(Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("RoleHighlight") then
            player.Character.RoleHighlight:Destroy()
        end
    end

    if CoreGui:FindFirstChild("MM2ControlCenter") then
        CoreGui.MM2ControlCenter:Destroy()
    end
end

-- =======================================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА (GUI BUILDER)
-- =======================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2ControlCenter"
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

local Dragging, DragInput, DragStart, StartPos
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
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
Title.Text = "CONTROL CENTER"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
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
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
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
StatusText.Text = "READY | PLACE " .. tostring(game.PlaceId) .. " · MM2 VIP Hub v3.7 (Anti-AFK & SafeFarm)"
StatusText.TextColor3 = Color3.fromRGB(120, 130, 145)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Right
StatusText.BackgroundTransparency = 1
StatusText.Parent = BottomBar

local Tabs = {}
local Pages = {}

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
    PageGrid.SortOrder = Enum.SortOrder.LayoutOrder
    PageGrid.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.TextColor3 = Color3.fromRGB(130, 140, 155)
            t.Btn.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
            t.Line.Visible = false
        end
        for _, p in pairs(Pages) do
            p.Visible = false
        end
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
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
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

local FarmCard = CreateCard(FarmPage, "Auto Farm")
AddToggle(FarmCard, "Auto Collect Coins", false, function(v) 
    Flags.AutoFarm = v 
    if not v and CurrentTween then
        pcall(function() CurrentTween:Cancel() end)
    end
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

local function GetPlayerRole(player)
    if not player or not player.Character then return "Innocent" end
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

-- Безопасный KillAura
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

-- Безопасный Sheriff Auto Shoot
local lastSheriffAura = 0
Connections.SheriffAura = RunService.RenderStepped:Connect(function()
    if not Running or not Flags.SheriffAura then return end
    if tick() - lastSheriffAura < 0.3 then return end

    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local backpack = LocalPlayer:FindFirstChild("Backpack")

        local gun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
        if not gun then return end

        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and GetPlayerRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    murderer = p
                    break
                end
            end
        end

        if murderer and murderer.Character then
            local mHrp = murderer.Character.HumanoidRootPart
            local distance = (hrp.Position - mHrp.Position).Magnitude

            if distance <= Flags.SheriffRange then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {char, murderer.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                local rayResult = Workspace:Raycast(hrp.Position, (mHrp.Position - hrp.Position), raycastParams)

                if not rayResult then
                    lastSheriffAura = tick()

                    if gun.Parent == backpack then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(gun) end
                    end

                    local predictedPos = mHrp.Position + (mHrp.Velocity * 0.15)
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(predictedPos.X, hrp.Position.Y, predictedPos.Z))

                    local shootRemote = gun:FindFirstChild("Shoot") or (gun:FindFirstChild("KnifeServer") and gun.KnifeServer:FindFirstChild("ShootGun"))
                    if shootRemote then
                        shootRemote:FireServer(1, predictedPos, CFrame.new(hrp.Position, predictedPos))
                    else
                        gun:Activate()
                    end
                end
            end
        end
    end)
end)

-- УЛЬТИМАТИВНЫЙ И НАДЕЖНЫЙ АВТО-ФАРМ (Защита от 3+ часов фарма, багов раунда, падений за карту и зависаний)
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
                if not char or not char:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then
                    task.wait(2)
                    return
                end

                local hrp = char.HumanoidRootPart

                -- Защита от бесконечного застревания в объектах / падения сквозь карту (Anti-Stuck & Void Protections)
                if tick() - lastPositionCheck > 3 then
                    if (hrp.Position - lastPosVector).Magnitude < 2 and Flags.AutoFarm then
                        stuckPositionCount = stuckPositionCount + 1
                        if stuckPositionCount >= 3 then
                            -- Если персонаж застрял, телепортируем его в безопасную верхнюю точку лобби/карты на секунду
                            hrp.CFrame = hrp.CFrame + Vector3.new(0, 15, 0)
                            stuckPositionCount = 0
                        end
                    else
                        stuckPositionCount = 0
                    end
                    lastPosVector = hrp.Position
                    lastPositionCheck = tick()
                end

                if hrp.Position.Y < -50 then
                    -- Если упали в пустоту — возвращаем наверх
                    hrp.CFrame = CFrame.new(0, 50, 0)
                    task.wait(1)
                end

                local container = GetCoinContainer()
                if container then
                    local children = container:GetChildren()
                    local validCoins = {}
                    
                    for _, child in pairs(children) do
                        if child and child.Parent then
                            if child:IsA("BasePart") then
                                table.insert(validCoins, child)
                            else
                                local part = child:FindFirstChildOfClass("BasePart")
                                if part then table.insert(validCoins, part) end
                            end
                        end
                    end

                    if #validCoins > 0 then
                        local closestCoin = nil
                        local minDistance = math.huge

                        for _, coin in ipairs(validCoins) do
                            if coin and coin.Parent then
                                local dist = (hrp.Position - coin.Position).Magnitude
                                if dist < minDistance then
                                    minDistance = dist
                                    closestCoin = coin
                                end
                            end
                        end

                        if closestCoin and closestCoin.Parent then
                            local speed = Flags.FarmSpeed or 60
                            local tweenTime = math.clamp(minDistance / speed, 0.05, 3.5)

                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then part.CanCollide = false end
                            end

                            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
                            CurrentTween = TweenService:Create(hrp, tweenInfo, {CFrame = closestCoin.CFrame})
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
                                else
                                    break
                                end
                            end

                            if CurrentTween then
                                pcall(function() CurrentTween:Cancel() end)
                            end

                            if not collected and closestCoin and closestCoin.Parent then
                                -- Принудительный долет, если твин не дошел до конца из-за лагов сервера
                                hrp.CFrame = closestCoin.CFrame
                                firetouchinterest(hrp, closestCoin, 0)
                                firetouchinterest(hrp, closestCoin, 1)
                                task.wait(0.05)
                            end
                        else
                            task.wait(0.2)
                        end
                    else
                        -- Монет нет на карте (ожидание нового раунда / конца таймера)
                        task.wait(0.5)
                    end
                else
                    -- Контейнер монет еще не появился (начало матча или лобби)
                    task.wait(1)
                end
            end)
        else
            task.wait(0.5)
        end
        RunService.Stepped:Wait()
    end
end)

-- Автоматический Anti-AFK (Борьба с киком Roblox через 20 минут бездействия)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ESP
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
                    if role == "Murderer" then
                        highlight.FillColor = Color3.fromRGB(255, 40, 40)
                    elseif role == "Sheriff" then
                        highlight.FillColor = Color3.fromRGB(40, 120, 255)
                    else
                        highlight.FillColor = Color3.fromRGB(40, 255, 120)
                    end
                    highlight.FillTransparency = 0.4
                    highlight.Enabled = true
                else
                    if highlight then highlight.Enabled = false end
                end
            end
        end
    end)
end)

-- Физика
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
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end)

-- Infinite Jump
Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if Running and Flags.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)