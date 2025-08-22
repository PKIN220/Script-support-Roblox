local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Cross V.1",
    Desc = "Hunty Zombie",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Cross"
    }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local Event = game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable")
local Mouse = LocalPlayer:GetMouse()

------------------------------------------------
-- FUNCTIONS
------------------------------------------------
-- Find closest zombie
local function getClosestEntity()
    local closest, distance = nil, math.huge
    for _, entity in pairs(workspace.Entities:GetChildren()) do
        if entity:FindFirstChild("Head") then
            local mag = (entity.Head.Position - HRP.Position).Magnitude
            if mag < distance then
                closest, distance = entity, mag
            end
        end
    end
    return closest
end

-- KillAll function
local function KillAll()
    local args = {
        buffer.fromstring("\a\b\001"),
        { 1755799222.46763 }
    }
    Event:FireServer(unpack(args))
end

------------------------------------------------
-- MAIN TAB
------------------------------------------------
local MainTab = Window:Tab({Title = "Main", Icon = "star"})

-- Auto Teleport
local AutoTP = false
local AutoTPLoop
MainTab:Toggle({
    Title = "Auto Teleport Zombie",
    Desc = "วาปไปหัวซอมบี้ใกล้ที่สุด",
    Value = false,
    Callback = function(v)
        AutoTP = v
        if v then
            AutoTPLoop = task.spawn(function()
                while AutoTP do
                    local entity = getClosestEntity()
                    if entity and entity:FindFirstChild("Head") then
                        HRP.CFrame = entity.Head.CFrame + Vector3.new(0,5,0)
                    end
                    task.wait(0.1)
                end
            end)
            Window:Notify({Title="AutoTP", Desc="Auto Teleport เปิดแล้ว", Time=3})
        else
            if AutoTPLoop then task.cancel(AutoTPLoop) end
            Window:Notify({Title="AutoTP", Desc="Auto Teleport ปิดแล้ว", Time=3})
        end
    end
})

-- Kill All Toggle
local AutoKillAll = false
local AutoKillLoop
MainTab:Toggle({
    Title = "Kill All",
    Desc = "ฆ่าซอมบี้ทั้งหมดอัตโนมัติ",
    Value = false,
    Callback = function(v)
        AutoKillAll = v
        if v then
            AutoKillLoop = task.spawn(function()
                while AutoKillAll do
                    KillAll()
                    task.wait(1)
                end
            end)
            Window:Notify({Title="Kill All", Desc="Kill All เปิดแล้ว", Time=3})
        else
            if AutoKillLoop then task.cancel(AutoKillLoop) end
            Window:Notify({Title="Kill All", Desc="Kill All ปิดแล้ว", Time=3})
        end
    end
})

-- Auto Zombie
local AutoAim = false
local AutoAimLoop
MainTab:Toggle({
    Title = "Auto farm Zombie",
    Desc = "จะค่อยๆฆ่า",
    Value = false,
    Callback = function(v)
        AutoAim = v
        if v then
            AutoAimLoop = task.spawn(function()
                while AutoAim do
                    local target = getClosestEntity()
                    if target and target:FindFirstChild("Head") then
                        -- วาปไปหัว
                        HRP.CFrame = target.Head.CFrame + Vector3.new(0,5,0)
                        -- ยิง
                        KillAll()
                    end
                    task.wait(0.2)
                end
            end)
            Window:Notify({Title="Aimbot", Desc="Auto Aim เปิดแล้ว", Time=3})
        else
            if AutoAimLoop then task.cancel(AutoAimLoop) end
            Window:Notify({Title="Aimbot", Desc="Auto Aim ปิดแล้ว", Time=3})
        end
    end
})

------------------------------------------------
-- BASIC TAB
------------------------------------------------
local Basic = Window:Tab({Title = "Basic", Icon = "wrench"})

-- WalkSpeed
Basic:Slider({
    Title="WalkSpeed", Min=16, Max=200, Value=16,
    Callback=function(val)
        Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
})

-- JumpPower
Basic:Slider({
    Title="JumpPower", Min=50, Max=300, Value=50,
    Callback=function(val)
        Character:FindFirstChildOfClass("Humanoid").JumpPower = val
    end
})

-- Noclip
local Noclip = false
Basic:Toggle({
    Title="Noclip",
    Desc="ทะลุกำแพง",
    Value=false,
    Callback=function(v)
        Noclip=v
    end
})
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fullbright
Basic:Button({
    Title="Full Brightness",
    Desc="เพิ่มความสว่าง",
    Callback=function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Window:Notify({Title="Fullbright", Desc="เปิด Fullbright แล้ว!", Time=3})
    end
})
