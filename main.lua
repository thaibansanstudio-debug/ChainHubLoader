-- 🔥 CHAIN HUB PRO FULL

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 FREE  🔥", "DarkTheme")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

------------------------------------------------
-- 💾 SAVE

local file = "chainhub.json"
local function save(t)
    if writefile then writefile(file, HttpService:JSONEncode(t)) end
end
local function load()
    if isfile and isfile(file) then
        return HttpService:JSONDecode(readfile(file))
    end
    return {}
end
local settings = load()

settings.fly = settings.fly or false
settings.god = settings.god or false
settings.noclip = settings.noclip or false
settings.esp = settings.esp or false

------------------------------------------------
-- 🕊 FLY

local flying = settings.fly
local flySpeed = 80
local bv, bg

local function startFly()
    local hrp = char.HumanoidRootPart
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e9,1e9,1e9)

    RunService.RenderStepped:Connect(function()
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
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

------------------------------------------------
-- 🚪 NOCLIP

local noclip = settings.noclip
RunService.Stepped:Connect(function()
    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

------------------------------------------------
-- 🛡 GODMODE

local god = settings.god
RunService.Stepped:Connect(function()
    if god and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = math.huge
        char.Humanoid.Health = math.huge
    end
end)

------------------------------------------------
-- 👀 ESP PRO

local espEnabled = settings.esp

local function clearESP(c)
    if c:FindFirstChild("CHAIN_ESP") then c.CHAIN_ESP:Destroy() end
    if c:FindFirstChild("Head") and c.Head:FindFirstChild("ESP_INFO") then
        c.Head.ESP_INFO:Destroy()
    end
end

local function applyESP(plr)
    if plr == player or not espEnabled then return end
    local c = plr.Character
    if not c or c:FindFirstChild("CHAIN_ESP") then return end

    local h = Instance.new("Highlight", c)
    h.Name = "CHAIN_ESP"
    h.FillTransparency = 0.3

    local head = c:FindFirstChild("Head")
    if not head then return end

    local gui = Instance.new("BillboardGui", head)
    gui.Name = "ESP_INFO"
    gui.Size = UDim2.new(0,220,0,60)
    gui.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", gui)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255,0,0)
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true

    RunService.RenderStepped:Connect(function()
        if not espEnabled then gui.Enabled = false return end
        if not c:FindFirstChild("HumanoidRootPart") then return end
        local dist = math.floor(
            (c.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
        )
        txt.Text = plr.Name.." | "..dist.."m"
        gui.Enabled = true
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    if p.Character then applyESP(p) end
    p.CharacterAdded:Connect(function() task.wait(1) applyESP(p) end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1) applyESP(p) end)
end)

------------------------------------------------
-- 📍 TP MENU

local function getNames()
    local t = {}
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(t, p.Name) end
    end
    return t
end

local targetName

------------------------------------------------
-- UI

local Main = Window:NewTab("Movement")
local M = Main:NewSection("🕊 Fly / Noclip")

M:NewToggle("Fly", "", function(v)
    flying = v
    settings.fly = v
    save(settings)
    if v then startFly() else stopFly() end
end)

M:NewToggle("Noclip", "", function(v)
    noclip = v
    settings.noclip = v
    save(settings)
end)

local GodTab = Window:NewTab("God")
GodTab:NewSection("🛡 Immortal"):NewToggle("GodMode", "", function(v)
    god = v
    settings.god = v
    save(settings)
end)

local EspTab = Window:NewTab("ESP")
EspTab:NewSection("👀 ESP PRO"):NewToggle("Enable ESP", "", function(v)
    espEnabled = v
    settings.esp = v
    save(settings)

    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            if v then applyESP(p) else clearESP(p.Character) end
        end
    end
end)

local TPTab = Window:NewTab("Teleport")
local TP = TPTab:NewSection("📍 TP Player")

local dropdown = TP:NewDropdown("Select Player", "", getNames(), function(v)
    targetName = v
end)

TP:NewButton("Refresh", "", function()
    dropdown:Refresh(getNames())
end)

TP:NewButton("TP NOW", "", function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame =
            t.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end)

local Settings = Window:NewTab("Settings")
Settings:NewSection("⚙ UI"):NewKeybind("Toggle UI", "", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)

print("🔥 CHAIN HUB PRO FULL LOADED 🔥")
