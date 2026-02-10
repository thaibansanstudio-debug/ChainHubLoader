-- CHAIN HUB FREE (STABLE)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 GUB FREE 🔥", "Ocean")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(c)
    char = c
end)

------------------------------------------------
-- SPEED
local Main = Window:NewTab("Main")
local SpeedSec = Main:NewSection("🏃 Speed")

SpeedSec:NewButton("Speed 100", "", function()
    char.Humanoid.WalkSpeed = 100
end)

SpeedSec:NewSlider("Custom Speed", "", 300, 0, function(v)
    char.Humanoid.WalkSpeed = v
end)

------------------------------------------------
-- FLY
local FlyTab = Window:NewTab("Fly")
local FlySec = FlyTab:NewSection("🕊 Fly")

local flying = false
local flySpeed = 80
local bv, bg, flyLoop

local function startFly()
    local hrp = char.HumanoidRootPart

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e9,1e9,1e9)

    flyLoop = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        bg.CFrame = cam.CFrame

        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= cam.CFrame.UpVector end

        bv.Velocity = move * flySpeed
    end)
end

local function stopFly()
    if flyLoop then flyLoop:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

FlySec:NewToggle("Enable Fly", "", function(v)
    flying = v
    if v then startFly() else stopFly() end
end)

FlySec:NewSlider("Fly Speed", "", 300, 10, function(v)
    flySpeed = v
end)

------------------------------------------------
-- NOCLIP
local NoTab = Window:NewTab("Noclip")
local NoSec = NoTab:NewSection("🚪 Noclip")

local noclip = false

RunService.Stepped:Connect(function()
    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

NoSec:NewToggle("Enable Noclip", "", function(v)
    noclip = v
end)

------------------------------------------------
-- GOD MODE
local GodTab = Window:NewTab("GodMode")
local GodSec = GodTab:NewSection("🛡 Immortal")

local god = false

RunService.Stepped:Connect(function()
    if god and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = math.huge
        char.Humanoid.Health = math.huge
    end
end)

GodSec:NewToggle("Enable GodMode", "", function(v)
    god = v
end)

------------------------------------------------
-- KILL AURA
local KillTab = Window:NewTab("Kill Aura")
local KillSec = KillTab:NewSection("💀 รอบตัวตาย")

local killAura = false
local killRange = 15

RunService.Stepped:Connect(function()
    if not killAura then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist <= killRange then
                local h = plr.Character:FindFirstChild("Humanoid")
                if h then h.Health = 0 end
            end
        end
    end
end)

KillSec:NewToggle("Enable Kill Aura", "", function(v)
    killAura = v
end)

KillSec:NewSlider("Kill Range", "", 100, 5, function(v)
    killRange = v
end)

------------------------------------------------
-- ITEM MAGNET
local MagnetTab = Window:NewTab("Magnet")
local MagSec = MagnetTab:NewSection("🧲 ดูดของ")

local magnet = false
local magnetRange = 30

RunService.Stepped:Connect(function()
    if not magnet then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _,item in pairs(Workspace:GetDescendants()) do
        if item:IsA("BasePart") then
            if (item.Position - hrp.Position).Magnitude <= magnetRange then
                item.CFrame = hrp.CFrame
            end
        elseif item:IsA("Tool") then
            item.Parent = player.Backpack
        end
    end
end)

MagSec:NewToggle("Enable Magnet", "", function(v)
    magnet = v
end)

MagSec:NewSlider("Magnet Range", "", 150, 5, function(v)
    magnetRange = v
end)

------------------------------------------------
-- INFO
local Info = Window:NewTab("Info")
Info:NewSection("📢 About"):NewLabel("🔥 CHAIN HUB FREE")
Info:NewSection("⚙ UI"):NewKeybind("Toggle UI", "", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)
------------------------------------------------
-- ESP + NAME + TP (TOGGLE SYSTEM)
local EspTPTab = Window:NewTab("ESP + TP")
local E1 = EspTPTab:NewSection("👀 ESP + ชื่อ")

local Players = game:GetService("Players")

local espEnabled = false

local function clearESP(char)
    if char:FindFirstChild("CHAIN_ESP") then
        char.CHAIN_ESP:Destroy()
    end
    local head = char:FindFirstChild("Head")
    if head and head:FindFirstChild("NameESP") then
        head.NameESP:Destroy()
    end
end

local function applyESP(plr)
    if plr == player then return end
    if not espEnabled then return end

    local char = plr.Character
    if not char then return end
    if char:FindFirstChild("CHAIN_ESP") then return end

    local h = Instance.new("Highlight")
    h.Name = "CHAIN_ESP"
    h.FillTransparency = 0.3
    h.OutlineTransparency = 0
    h.Parent = char

    local head = char:FindFirstChild("Head")
    if head then
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "NameESP"
        bill.Size = UDim2.new(0,200,0,50)
        bill.AlwaysOnTop = true

        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = plr.Name
        txt.TextColor3 = Color3.fromRGB(255,0,0)
        txt.TextStrokeTransparency = 0
        txt.TextScaled = true
    end
end

-- Toggle ESP
E1:NewToggle("Enable ESP + Name", "", function(v)
    espEnabled = v

    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            if v then
                applyESP(plr)
            else
                clearESP(plr.Character)
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            applyESP(plr)
        end
    end)
end)

------------------------------------------------
-- TP BUTTONS
local TPSection = EspTPTab:NewSection("📍 TP ไปหาผู้เล่น")

local function addTP(plr)
    if plr == player then return end

    TPSection:NewButton("TP → "..plr.Name, "", function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame =
                plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    addTP(p)
end

Players.PlayerAdded:Connect(addTP)
------------------------------------------------
-- DEAD RAILS ITEM SPAWNER
local ItemTab = Window:NewTab("Spawn Items")
local I1 = ItemTab:NewSection("🎁 เสกของ")

local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local function spawnItem(itemName)
    local item = RS:FindFirstChild(itemName, true)

    if item then
        local clone = item:Clone()
        clone.Parent = player.Backpack
        print("เสกแล้ว:", itemName)
    else
        warn("ไม่พบของ:", itemName)
    end
end

-- ตัวอย่างของยอดนิยม (ปรับชื่อให้ตรงกับในเกม)
I1:NewButton("🗡 Weapon", "", function()
    spawnItem("Weapon")
end)

I1:NewButton("🔫 Gun", "", function()
    spawnItem("Gun")
end)

I1:NewButton("💊 Medkit", "", function()
    spawnItem("Medkit")
end)

I1:NewButton("📦 Supply", "", function()
    spawnItem("Supply")
end)

------------------------------------------------
-- กล่องใส่ชื่อของเอง
I1:NewTextBox("พิมพ์ชื่อไอเท็ม", "เช่น Rifle, Ammo, Food", function(txt)
    spawnItem(txt)
end)
