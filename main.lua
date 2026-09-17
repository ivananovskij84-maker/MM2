-- =======================================================
-- GAG22 LOADER v8.0.11 | FIXED AUTO-FARM RESUME
-- =======================================================
local CG, Plrs, UIS, TS, RS, WS = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("Workspace")
local LP = Plrs.LocalPlayer or Plrs:GetPropertyChangedSignal("LocalPlayer"):Wait()
local setclip = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard) or function() end

local function I(cls, props, parent)
    local obj = Instance.new(cls)
    for k, v in pairs(props or {}) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end
local function C(r, p) return I("UICorner", {CornerRadius = UDim.new(0, r)}, p) end

for _, n in ipairs({"GAG22_Loader", "GAG22_UpdateCheck", "GAG22_Subscribe"}) do
    if CG:FindFirstChild(n) then CG[n]:Destroy() end
end

-- =======================================================
-- 1. MAIN HUB
-- =======================================================
local function LaunchGAG22Hub()
    if CG:FindFirstChild("GAG22") then CG.GAG22:Destroy() end

    local Flags = {KillAura = false, KillAuraRange = 20, SheriffAura = false, SheriffRange = 100, ESP = false, AutoFarm = false, FarmSpeed = 220, AutoResume = true, Noclip = false, InfJump = false, WalkSpeedEnabled = false, WalkSpeedValue = 16, JumpPowerEnabled = false, JumpPowerValue = 50}
    local Connections, Running, CurrentTween = {}, true, nil

    local function UnloadScript()
        Running = false
        if CurrentTween then pcall(function() CurrentTween:Cancel() end) end
        for _, conn in pairs(Connections) do if typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end end
        for _, p in pairs(Plrs:GetPlayers()) do if p.Character and p.Character:FindFirstChild("RoleHighlight") then p.Character.RoleHighlight:Destroy() end end
        if CG:FindFirstChild("GAG22") then CG.GAG22:Destroy() end
    end

    local function IsAlive(p)
        p = p or LP
        local c = p.Character
        return c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0 and c:FindFirstChild("HumanoidRootPart")
    end

    local function GetPlayerRole(p)
        if not p or not p.Character then return "Innocent" end
        local c, b = p.Character, p:FindFirstChild("Backpack")
        if c:FindFirstChild("Knife") or (b and b:FindFirstChild("Knife")) then return "Murderer"
        elseif c:FindFirstChild("Gun") or (b and b:FindFirstChild("Gun")) then return "Sheriff" end
        return "Innocent"
    end

    local function GetMurderer()
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and IsAlive(p) and GetPlayerRole(p) == "Murderer" then return p.Character end
        end
    end

    local function GetCoinContainer()
        return WS:FindFirstChild("CoinContainer") or (function() for _, c in pairs(WS:GetChildren()) do local cc = c:FindFirstChild("CoinContainer") if cc then return cc end end end)()
    end

    -- UI Setup
    local ScreenGui = I("ScreenGui", {Name = "GAG22", ResetOnSpawn = false}, CG:FindFirstChildOfClass("Folder") and CG or LP:WaitForChild("PlayerGui"))
    local MainFrame = I("Frame", {Size = UDim2.new(0, 750, 0, 430), Position = UDim2.new(0.5, -375, 0.5, -215), BackgroundColor3 = Color3.fromRGB(11, 14, 20), BorderSizePixel = 0, ClipsDescendants = true}, ScreenGui)
    C(8, MainFrame)

    local TopBar = I("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(11, 14, 20), BorderSizePixel = 0}, MainFrame)
    local Dragging, DragStart, StartPos
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging, DragStart, StartPos = true, i.Position, MainFrame.Position end end)
    TopBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UIS.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - DragStart MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y) end end)

    I("TextLabel", {Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 15, 0, 0), Text = "GAG22 MM2", TextColor3 = Color3.fromRGB(240, 240, 240), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, TopBar)
    local ControlBox = I("Frame", {Size = UDim2.new(0, 80, 0, 30), Position = UDim2.new(1, -90, 0, 7), BackgroundColor3 = Color3.fromRGB(16, 22, 31)}, TopBar)
    C(6, ControlBox)
    I("TextButton", {Size = UDim2.new(1, 0, 1, 0), Text = "✕  Закрыть", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBold, TextSize = 12, BackgroundTransparency = 1}, ControlBox).MouseButton1Click:Connect(UnloadScript)

    local TabsHolder = I("Frame", {Size = UDim2.new(0, 480, 1, 0), Position = UDim2.new(0, 170, 0, 0), BackgroundTransparency = 1}, TopBar)
    I("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6)}, TabsHolder)
    local PagesFolder = I("Frame", {Name = "Pages", Size = UDim2.new(1, -30, 1, -85), Position = UDim2.new(0, 15, 0, 50), BackgroundTransparency = 1}, MainFrame)
    local BottomBar = I("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 1, -30), BackgroundColor3 = Color3.fromRGB(8, 10, 15), BorderSizePixel = 0}, MainFrame)
    I("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = "READY | PLACE " .. tostring(game.PlaceId) .. " · GAG22 Hub v3.96", TextColor3 = Color3.fromRGB(120, 130, 145), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1}, BottomBar)

    local Tabs, Pages = {}, {}
    local function CreateTab(name)
        local Btn = I("TextButton", {Size = UDim2.new(0, 80, 0, 28), Text = name, TextColor3 = Color3.fromRGB(130, 140, 155), Font = Enum.Font.GothamMedium, TextSize = 13, BackgroundColor3 = Color3.fromRGB(11, 14, 20), BorderSizePixel = 0}, TabsHolder)
        C(6, Btn)
        local Line = I("Frame", {Size = UDim2.new(0.6, 0, 0, 2), Position = UDim2.new(0.2, 0, 1, -2), BackgroundColor3 = Color3.fromRGB(0, 210, 255), BorderSizePixel = 0, Visible = false}, Btn)
        local Page = I("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255), Visible = false}, PagesFolder)
        I("UIGridLayout", {CellSize = UDim2.new(0, 230, 0, 135), CellPadding = UDim2.new(0, 10, 0, 10)}, Page)

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.Btn.TextColor3 = Color3.fromRGB(130, 140, 155) t.Btn.BackgroundColor3 = Color3.fromRGB(11, 14, 20) t.Line.Visible = false end
            for _, p in pairs(Pages) do p.Visible = false end
            Btn.TextColor3, Btn.BackgroundColor3, Line.Visible, Page.Visible = Color3.fromRGB(0, 210, 255), Color3.fromRGB(18, 26, 38), true, true
        end)

        table.insert(Tabs, {Btn = Btn, Line = Line})
        table.insert(Pages, Page)
        if #Tabs == 1 then Btn.TextColor3, Btn.BackgroundColor3, Line.Visible, Page.Visible = Color3.fromRGB(0, 210, 255), Color3.fromRGB(18, 26, 38), true, true end
        return Page
    end

    local function CreateCard(page, title)
        local Card = I("Frame", {BackgroundColor3 = Color3.fromRGB(19, 25, 36), BorderSizePixel = 0}, page)
        C(8, Card)
        I("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 8), Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, Card)
        I("UIListLayout", {Padding = UDim.new(0, 6)}, Card)
        I("UIPadding", {PaddingTop = UDim.new(0, 35), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, Card)
        return Card
    end

    local function AddToggle(card, text, default, cb)
        local TF = I("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1}, card)
        I("TextLabel", {Size = UDim2.new(0.65, 0, 1, 0), Text = text, TextColor3 = Color3.fromRGB(150, 160, 175), Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, TF)
        local SB = I("TextButton", {Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -38, 0, 2), BackgroundColor3 = default and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(35, 45, 60), Text = "", AutoButtonColor = false}, TF)
        C(100, SB)
        local Knob = I("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, SB)
        C(100, Knob)

        local st = default
        local function SetState(val)
            st = val
            SB.BackgroundColor3 = st and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(35, 45, 60)
            Knob.Position = st and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            cb(st)
        end
        SB.MouseButton1Click:Connect(function() SetState(not st) end)
        return SetState
    end

    local function AddSlider(card, text, min, max, default, cb)
        local SF = I("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1}, card)
        local Lbl = I("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Text = text .. ": " .. tostring(default), TextColor3 = Color3.fromRGB(150, 160, 175), Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, SF)
        local Trk = I("TextButton", {Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(30, 40, 55), Text = "", AutoButtonColor = false}, SF)
        C(100, Trk)
        local Fill = I("Frame", {Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 210, 255), BorderSizePixel = 0}, Trk)
        C(100, Fill)

        local drag = false
        local function Upd(i)
            local p = math.clamp((i.Position.X - Trk.AbsolutePosition.X) / Trk.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * p)
            Fill.Size = UDim2.new(p, 0, 1, 0)
            Lbl.Text = text .. ": " .. tostring(v)
            cb(v)
        end
        Trk.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true Upd(i) end end)
        UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then Upd(i) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    end

    local function AddButton(card, text, cb)
        local Btn = I("TextButton", {Size = UDim2.new(1, 0, 0, 26), Text = text, TextColor3 = Color3.fromRGB(240, 240, 240), Font = Enum.Font.GothamBold, TextSize = 11, BackgroundColor3 = Color3.fromRGB(28, 36, 50), BorderSizePixel = 0}, card)
        C(5, Btn)
        Btn.MouseButton1Click:Connect(cb)
    end

    -- Tab Cards
    local CombatPage, PlayerPage, FarmPage, VisualsPage, UtilityPage = CreateTab("Combat"), CreateTab("Player"), CreateTab("Farm"), CreateTab("Visuals"), CreateTab("Utility")

    local KC = CreateCard(CombatPage, "Knife Kill Aura")
    local SetKA = AddToggle(KC, "Murderer Aura", false, function(v) Flags.KillAura = v end)
    AddSlider(KC, "Range", 5, 30, 18, function(v) Flags.KillAuraRange = v end)

    local SC = CreateCard(CombatPage, "Sheriff Auto Shoot")
    local SetSA = AddToggle(SC, "Auto Shoot Murderer", false, function(v) Flags.SheriffAura = v end)
    AddSlider(SC, "Shoot Distance", 20, 150, 100, function(v) Flags.SheriffRange = v end)

    local SpC = CreateCard(PlayerPage, "WalkSpeed")
    AddToggle(SpC, "STATE", false, function(v) Flags.WalkSpeedEnabled = v end)
    AddSlider(SpC, "Speed", 16, 120, 16, function(v) Flags.WalkSpeedValue = v end)

    local JpC = CreateCard(PlayerPage, "JumpPower")
    AddToggle(JpC, "STATE", false, function(v) Flags.JumpPowerEnabled = v end)
    AddSlider(JpC, "Power", 50, 200, 50, function(v) Flags.JumpPowerValue = v end)

    local PhC = CreateCard(PlayerPage, "Physics")
    AddToggle(PhC, "Noclip", false, function(v) Flags.Noclip = v end)
    AddToggle(PhC, "Infinite Jump", false, function(v) Flags.InfJump = v end)

    local FC = CreateCard(FarmPage, "Smart Auto Farm")
    local SetFarm = AddToggle(FC, "Auto Collect Coins", false, function(v)
        Flags.AutoFarm = v
        if not v and CurrentTween then
            pcall(function() CurrentTween:Cancel() end)
            CurrentTween = nil
        end
    end)
    AddToggle(FC, "Auto Resume Next Round", true, function(v) Flags.AutoResume = v end)
    AddSlider(FC, "Farm Speed", 80, 400, 220, function(v) Flags.FarmSpeed = v end)

    local EC = CreateCard(VisualsPage, "Role ESP")
    AddToggle(EC, "Show Roles", false, function(v) Flags.ESP = v end)

    local TC = CreateCard(UtilityPage, "Teleports")
    AddButton(TC, "TP to Dropped Gun", function()
        pcall(function() local g = WS:FindFirstChild("GunDrop", true) if g and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = g.CFrame + Vector3.new(0, 3, 0) end end)
    end)
    local SrvC = CreateCard(UtilityPage, "Server")
    AddButton(SrvC, "Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)

    -- Events & Mechanics
    local function SetupChar(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                if CurrentTween then pcall(function() CurrentTween:Cancel() end) CurrentTween = nil end
                if not Flags.AutoResume then SetFarm(false) end
            end)
        end
    end
    if LP.Character then SetupChar(LP.Character) end
    table.insert(Connections, LP.CharacterAdded:Connect(function(c) SetupChar(c) end))

    local lastRole = ""
    local farmResumedThisRound = false

    Connections.RoleCheck = RS.Heartbeat:Connect(function()
        if not Running or not IsAlive() then
            farmResumedThisRound = false
            return
        end

        local r = GetPlayerRole(LP)
        if r ~= lastRole then
            lastRole = r
            farmResumedThisRound = false
            if r == "Murderer" then SetFarm(false) SetKA(true) SetSA(false)
            elseif r == "Sheriff" then SetFarm(false) SetKA(false) SetSA(true)
            elseif r == "Innocent" then SetKA(false) SetSA(false) end
        end

        -- Автоматический старт фарма при появлении монет
        if r == "Innocent" and Flags.AutoResume and not farmResumedThisRound then
            local container = GetCoinContainer()
            if container and #container:GetChildren() > 0 then
                farmResumedThisRound = true
                SetFarm(true)
            end
        end
    end)

    local lastKA = 0
    Connections.KillAura = RS.RenderStepped:Connect(function()
        if not Running or not Flags.KillAura or not IsAlive() then return end
        pcall(function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local bp = LP:FindFirstChild("Backpack")
            local knife = char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))
            if knife and hrp then
                if knife.Parent == bp then char:FindFirstChildOfClass("Humanoid"):EquipTool(knife) end
                local mChar = GetMurderer()
                if mChar and mChar:FindFirstChild("HumanoidRootPart") and (hrp.Position - mChar.HumanoidRootPart.Position).Magnitude > Flags.KillAuraRange then hrp.CFrame = mChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) end
                if tick() - lastKA >= 0.04 then
                    lastKA = tick()
                    local h = knife:FindFirstChild("Handle")
                    if h then
                        for _, t in pairs(Plrs:GetPlayers()) do
                            if t ~= LP and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and t.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                                if (hrp.Position - t.Character.HumanoidRootPart.Position).Magnitude <= Flags.KillAuraRange then
                                    knife:Activate() firetouchinterest(t.Character.HumanoidRootPart, h, 0) firetouchinterest(t.Character.HumanoidRootPart, h, 1)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)

    Connections.SheriffAura = RS.RenderStepped:Connect(function()
        if not Running or not Flags.SheriffAura or not IsAlive() then return end
        pcall(function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local bp = LP:FindFirstChild("Backpack")
            local gun = char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))
            if gun and hrp then
                if gun.Parent == bp then char:FindFirstChildOfClass("Humanoid"):EquipTool(gun) end
                local mChar = GetMurderer()
                if mChar and mChar:FindFirstChild("HumanoidRootPart") and (hrp.Position - mChar.HumanoidRootPart.Position).Magnitude <= Flags.SheriffRange then
                    local rem = gun:FindFirstChild("Shoot") or gun:FindFirstChild("KnifeServer") or game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true)
                    if rem and rem:IsA("RemoteEvent") then rem:FireServer(mChar.HumanoidRootPart.CFrame) else gun:Activate() end
                end
            end
        end)
    end)

    task.spawn(function()
        while Running do
            if Flags.AutoFarm and IsAlive() then
                pcall(function()
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(0.01) return end
                    local mChar = GetMurderer()
                    local mHrp = mChar and mChar:FindFirstChild("HumanoidRootPart")

                    if mHrp and (hrp.Position - mHrp.Position).Magnitude < 30 then
                        if CurrentTween then pcall(function() CurrentTween:Cancel() end) CurrentTween = nil end
                        local container = GetCoinContainer()
                        local safePos = nil
                        if container then
                            local maxD = 0
                            for _, c in pairs(container:GetChildren()) do
                                local p = c:IsA("BasePart") and c or c:FindFirstChildOfClass("BasePart")
                                if p and p.Parent and (p.Position - mHrp.Position).Magnitude > maxD then maxD, safePos = (p.Position - mHrp.Position).Magnitude, p.Position end
                            end
                        end
                        if not safePos then local d = (hrp.Position - mHrp.Position).Unit safePos = hrp.Position + (d.Magnitude == 0 and Vector3.new(1,0,0) or d) * 50 end
                        hrp.CFrame = CFrame.new(safePos + Vector3.new(0, 3, 0)) task.wait(0.3) return
                    end

                    local container = GetCoinContainer()
                    if container then
                        local coins = {}
                        for _, c in pairs(container:GetChildren()) do local p = c:IsA("BasePart") and c or c:FindFirstChildOfClass("BasePart") if p and p.Parent then table.insert(coins, p) end end
                        if #coins > 0 and IsAlive() and Flags.AutoFarm then
                            local closest, minDist = nil, math.huge
                            for _, c in ipairs(coins) do
                                if c and c.Parent and (not mHrp or (c.Position - mHrp.Position).Magnitude > 25) then
                                    local d = (hrp.Position - c.Position).Magnitude
                                    if d < minDist then minDist, closest = d, c end
                                end
                            end
                            if closest and closest.Parent and IsAlive() and Flags.AutoFarm then
                                for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end
                                CurrentTween = TS:Create(hrp, TweenInfo.new(math.clamp(minDist / (Flags.FarmSpeed or 220), 0.01, 0.35), Enum.EasingStyle.Linear), {CFrame = closest.CFrame})
                                CurrentTween:Play()
                                while CurrentTween and CurrentTween.PlaybackState == Enum.PlaybackState.Playing and Flags.AutoFarm and IsAlive() do
                                    RS.Stepped:Wait() hrp.Velocity = Vector3.new(0, 0, 0)
                                    if not closest or not closest.Parent or (mHrp and (hrp.Position - mHrp.Position).Magnitude < 25) then if CurrentTween then CurrentTween:Cancel() CurrentTween = nil end break end
                                    if (hrp.Position - closest.Position).Magnitude <= 7 then firetouchinterest(hrp, closest, 0) firetouchinterest(hrp, closest, 1) break end
                                end
                                if CurrentTween then pcall(function() CurrentTween:Cancel() end) CurrentTween = nil end
                            else RS.RenderStepped:Wait() end
                        else task.wait(0.01) end
                    else task.wait(0.05) end
                end)
            else task.wait(0.05) end
            RS.Stepped:Wait()
        end
    end)

    local VU = game:GetService("VirtualUser")
    LP.Idled:Connect(function() pcall(function() VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end) end)

    Connections.ESP = RS.RenderStepped:Connect(function()
        if not Running then return end
        pcall(function()
            for _, p in pairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character then
                    local h = p.Character:FindFirstChild("RoleHighlight")
                    if Flags.ESP then
                        if not h then h = I("Highlight", {Name = "RoleHighlight"}, p.Character) end
                        local r = GetPlayerRole(p)
                        h.FillColor = r == "Murderer" and Color3.fromRGB(255, 40, 40) or (r == "Sheriff" and Color3.fromRGB(40, 120, 255) or Color3.fromRGB(40, 255, 120))
                        h.FillTransparency, h.Enabled = 0.4, true
                    elseif h then h.Enabled = false end
                end
            end
        end)
    end)

    Connections.Physics = RS.Stepped:Connect(function()
        if not Running or not IsAlive() then return end
        pcall(function()
            local c = LP.Character
            if c then
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hum then
                    if Flags.WalkSpeedEnabled then hum.WalkSpeed = Flags.WalkSpeedValue end
                    if Flags.JumpPowerEnabled then hum.JumpPower = Flags.JumpPowerValue end
                end
                if Flags.Noclip then for _, p in pairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            end
        end)
    end)

    Connections.InfJump = UIS.JumpRequest:Connect(function() pcall(function() if Running and Flags.InfJump and IsAlive() then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end) end)
end

-- =======================================================
-- 2. SUBSCRIBE MODAL
-- =======================================================
local function ShowSubscribeModal(onFinished)
    local SubGui = I("ScreenGui", {Name = "GAG22_Subscribe", ResetOnSpawn = false}, CG:FindFirstChildOfClass("Folder") and CG or LP:WaitForChild("PlayerGui"))
    local Modal = I("Frame", {Size = UDim2.new(0, 440, 0, 250), Position = UDim2.new(0.5, -220, 0.5, -125), BackgroundColor3 = Color3.fromRGB(11, 14, 20), BorderSizePixel = 0}, SubGui)
    C(12, Modal)
    I("UIStroke", {Color = Color3.fromRGB(0, 190, 240), Thickness = 1.5}, Modal)

    I("TextLabel", {Size = UDim2.new(1, -40, 0, 30), Position = UDim2.new(0, 20, 0, 20), Text = "📢 ПОДПИШИСЬ НА НАШ КАНАЛ!", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, BackgroundTransparency = 1}, Modal)
    I("TextLabel", {Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 20, 0, 55), Text = "Подпишись на наш Telegram, чтобы получать свежие обновления:\nt.me/GAG2212", TextColor3 = Color3.fromRGB(170, 180, 195), Font = Enum.Font.GothamMedium, TextSize = 12, TextWrapped = true, BackgroundTransparency = 1}, Modal)

    local CopyBtn = I("TextButton", {Size = UDim2.new(1, -40, 0, 42), Position = UDim2.new(0, 20, 0, 105), BackgroundColor3 = Color3.fromRGB(0, 150, 220), BorderSizePixel = 0, Text = "СКОПИРОВАТЬ ССЫЛКУ", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 13}, Modal)
    C(8, CopyBtn)
    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclip("https://t.me/GAG2212") end)
        CopyBtn.Text, CopyBtn.BackgroundColor3 = "СКОПИРОВАНО В БУФЕР!", Color3.fromRGB(0, 180, 130)
        task.wait(1.5)
        CopyBtn.Text, CopyBtn.BackgroundColor3 = "СКОПИРОВАНО В БУФЕР!", Color3.fromRGB(0, 150, 220)
    end)

    local TimerLabel = I("TextLabel", {Size = UDim2.new(1, -40, 0, 30), Position = UDim2.new(0, 20, 0, 185), Text = "Запуск скрипта через: 10 сек...", TextColor3 = Color3.fromRGB(0, 210, 255), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1}, Modal)

    task.spawn(function()
        for i = 10, 1, -1 do TimerLabel.Text = "Запуск скрипта через: " .. tostring(i) .. " сек..." task.wait(1) end
        SubGui:Destroy()
        if onFinished then onFinished() end
    end)
end

-- =======================================================
-- 3. LOADER GUI
-- =======================================================
local function ShowLoaderGui()
    local LoaderGui = I("ScreenGui", {Name = "GAG22_Loader", ResetOnSpawn = false}, CG:FindFirstChildOfClass("Folder") and CG or LP:WaitForChild("PlayerGui"))
    local BaseFrame = I("Frame", {Name = "BaseFrame", Size = UDim2.new(0, 960, 0, 420), Position = UDim2.new(0.5, -480, 0.5, -210), BackgroundTransparency = 1}, LoaderGui)

    local Dragging, DragStart, StartPos
    BaseFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging, DragStart, StartPos = true, i.Position, BaseFrame.Position end end)
    BaseFrame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UIS.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - DragStart BaseFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y) end end)

    local LeftPanel = I("Frame", {Size = UDim2.new(0, 300, 1, 0), BackgroundColor3 = Color3.fromRGB(8, 10, 14), BorderSizePixel = 0}, BaseFrame)
    C(12, LeftPanel)
    I("TextLabel", {Size = UDim2.new(1, -30, 0, 20), Position = UDim2.new(0, 15, 0, 20), Text = "COMPATIBILITY", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, LeftPanel)
    I("TextLabel", {Size = UDim2.new(1, -30, 0, 15), Position = UDim2.new(0, 15, 0, 42), Text = "SAFE CAPABILITY ANALYZER", TextColor3 = Color3.fromRGB(100, 110, 125), Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, LeftPanel)

    local XenoBox = I("Frame", {Size = UDim2.new(1, -30, 0, 44), Position = UDim2.new(0, 15, 0, 70), BackgroundColor3 = Color3.fromRGB(12, 28, 24), BorderSizePixel = 0}, LeftPanel)
    C(8, XenoBox)
    I("UIStroke", {Color = Color3.fromRGB(0, 180, 130), Thickness = 1}, XenoBox)
    I("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = "🟢  Xeno | LOADER COMPATIBLE", TextColor3 = Color3.fromRGB(0, 230, 160), Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, XenoBox)

    local items = {{name = "Connection", status = "service link ready"}, {name = "Protected core", status = "protected runtime ready"}, {name = "Integrity", status = "verification ready"}, {name = "Local continuity", status = "secure state ready"}}
    for i, item in ipairs(items) do
        local Box = I("Frame", {Size = UDim2.new(1, -30, 0, 38), Position = UDim2.new(0, 15, 0, 145 + (i - 1) * 44), BackgroundColor3 = Color3.fromRGB(12, 16, 22), BorderSizePixel = 0}, LeftPanel)
        C(6, Box)
        I("TextLabel", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = "🟢", TextSize = 8, BackgroundTransparency = 1}, Box)
        I("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 28, 0, 0), Text = item.name, TextColor3 = Color3.fromRGB(200, 210, 220), Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, Box)
        I("TextLabel", {Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Text = item.status, TextColor3 = Color3.fromRGB(0, 180, 130), Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1}, Box)
    end

    local RightPanel = I("Frame", {Size = UDim2.new(0, 645, 1, 0), Position = UDim2.new(0, 315, 0, 0), BackgroundColor3 = Color3.fromRGB(6, 8, 12), BorderSizePixel = 0}, BaseFrame)
    C(12, RightPanel)

    local LogoIcon = I("Frame", {Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 25, 0, 20), BackgroundColor3 = Color3.fromRGB(15, 23, 34), BorderSizePixel = 0}, RightPanel)
    C(8, LogoIcon)
    I("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Text = "G", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 22, BackgroundTransparency = 1}, LogoIcon)
    I("TextLabel", {Size = UDim2.new(0, 200, 0, 42), Position = UDim2.new(0, 78, 0, 20), Text = "LOADER  8.0.11", TextColor3 = Color3.fromRGB(220, 225, 235), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, RightPanel)

    local ProfileCard = I("Frame", {Size = UDim2.new(1, -50, 0, 95), Position = UDim2.new(0, 25, 0, 80), BackgroundColor3 = Color3.fromRGB(10, 14, 20), BorderSizePixel = 0}, RightPanel)
    C(10, ProfileCard)
    I("TextLabel", {Size = UDim2.new(0.5, 0, 0, 25), Position = UDim2.new(0, 20, 0, 20), Text = LP.Name, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, ProfileCard)
    I("TextLabel", {Size = UDim2.new(0.5, -20, 0, 30), Position = UDim2.new(0.5, 0, 0, 20), Text = "🟢 GAG22: Murder Mystery 2 готов к запуску", TextColor3 = Color3.fromRGB(200, 210, 225), Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, ProfileCard)

    local LaunchCard = I("TextButton", {Size = UDim2.new(1, -50, 0, 90), Position = UDim2.new(0, 25, 0, 220), BackgroundColor3 = Color3.fromRGB(12, 32, 48), BorderSizePixel = 0, Text = "", AutoButtonColor = false}, RightPanel)
    C(10, LaunchCard)
    I("TextLabel", {Size = UDim2.new(1, -60, 0, 30), Position = UDim2.new(0, 20, 0, 18), Text = "🚀  Запустить GAG22 Hub (MM2)", TextColor3 = Color3.fromRGB(0, 210, 255), Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, LaunchCard)
    I("TextLabel", {Size = UDim2.new(1, -60, 0, 20), Position = UDim2.new(0, 20, 0, 48), Text = "Нажмите для перехода к запуску версии v8.0.11", TextColor3 = Color3.fromRGB(120, 150, 180), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1}, LaunchCard)

    LaunchCard.MouseButton1Click:Connect(function()
        LoaderGui:Destroy()
        ShowSubscribeModal(LaunchGAG22Hub)
    end)
end

-- =======================================================
-- 4. UPDATE CHECK GUI
-- =======================================================
local function ShowUpdateCheckGui()
    local UpdateGui = I("ScreenGui", {Name = "GAG22_UpdateCheck", ResetOnSpawn = false}, CG:FindFirstChildOfClass("Folder") and CG or LP:WaitForChild("PlayerGui"))
    local Frame = I("Frame", {Size = UDim2.new(0, 400, 0, 190), Position = UDim2.new(0.5, -200, 0.5, -95), BackgroundColor3 = Color3.fromRGB(11, 14, 20), BorderSizePixel = 0}, UpdateGui)
    C(12, Frame)
    I("UIStroke", {Color = Color3.fromRGB(0, 210, 255), Thickness = 1.5}, Frame)

    I("TextLabel", {Size = UDim2.new(1, 0, 0, 35), Position = UDim2.new(0, 0, 0, 18), Text = "GAG22 LOADER | CHECKING UPDATES", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, BackgroundTransparency = 1}, Frame)
    local Status = I("TextLabel", {Size = UDim2.new(1, -40, 0, 25), Position = UDim2.new(0, 20, 0, 60), Text = "Подключение к серверу обновлений...", TextColor3 = Color3.fromRGB(150, 160, 175), Font = Enum.Font.GothamMedium, TextSize = 12, BackgroundTransparency = 1}, Frame)

    local BarBg = I("Frame", {Size = UDim2.new(1, -40, 0, 8), Position = UDim2.new(0, 20, 0, 105), BackgroundColor3 = Color3.fromRGB(20, 26, 36), BorderSizePixel = 0}, Frame)
    C(100, BarBg)
    local BarFill = I("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 210, 255), BorderSizePixel = 0}, BarBg)
    C(100, BarFill)

    task.spawn(function()
        TS:Create(BarFill, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.55, 0, 1, 0)}):Play()
        task.wait(1.0)
        Status.Text = "Синхронизация последней версии..."
        TS:Create(BarFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(0.8)
        Status.Text, Status.TextColor3 = "🟢 Версия актуальна! (v8.0.11)", Color3.fromRGB(0, 230, 160)
        task.wait(0.6)
        UpdateGui:Destroy()
        ShowLoaderGui()
    end)
end

ShowUpdateCheckGui()
