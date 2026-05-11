-- [[ AFSE ENDLESS: ADMIN PANEL - UTILITY VERSION ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Global Settings
_G.Settings = {
    GodMode = false,
    SpeedEnabled = false,
    JumpEnabled = false,
    SpeedValue = 100,
    JumpValue = 100
}

-- 1. Create the UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AFSE_Hub"
ScreenGui.Parent = CoreGui 

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300) -- Made it slightly shorter
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AFSE UTILITY PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- 2. Toggle Function
local function addToggle(name, yPos, settingName, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    btn.MouseButton1Click:Connect(function()
        _G.Settings[settingName] = not _G.Settings[settingName]
        if _G.Settings[settingName] then
            btn.Text = name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.Text = name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        if callback then callback(_G.Settings[settingName]) end
    end)
end

-- 3. Features

-- God Mode
addToggle("God Mode", 60, "GodMode")

-- Speed Hack
addToggle("Super Speed", 105, "SpeedEnabled")

-- Infinite Jump (or just high jump)
addToggle("Super Jump", 150, "JumpEnabled")

-- addToggle("Chikara Farm", 195, "ChikaraFarm")
-- 4. The Loop (Checks every frame to apply stats)
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        
        -- God Mode Logic
        if _G.Settings.GodMode then
            hum.Health = hum.MaxHealth
        end
        
        -- Speed Logic
        if _G.Settings.SpeedEnabled then
            hum.WalkSpeed = _G.Settings.SpeedValue
        else
            hum.WalkSpeed = 16 -- Default Roblox speed
        end
        
        -- Jump Logic
        if _G.Settings.JumpEnabled then
            hum.JumpPower = _G.Settings.JumpValue
        else
            hum.JumpPower = 50 -- Default Roblox jump
        end
    end
end)

-- Destroy Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0.8, 0, 0, 30)
Close.Position = UDim2.new(0.1, 0, 1, -45)
Close.Text = "DESTROY PANEL"
Close.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [[ CHIKARA AUTO-FARM LOGIC ]] --
local TweenService = game:GetService("TweenService")
_G.Settings.ChikaraFarm = false

local function getClosestBox()
    local closestBox = nil
    local shortestDistance = math.huge
    
    -- Search specifically for boxes in the Workspace
    for _, v in pairs(workspace:GetDescendants()) do
        -- We check for 'Crate' or 'Chikara' in the name
        if v:IsA("BasePart") and (v.Name:find("Crate") or v.Name:find("Chikara")) then
            local distance = (player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if distance < shortestDistance then
                closestBox = v
                shortestDistance = distance
            end
        end
    end
    return closestBox
end

task.spawn(function()
    while task.wait(1) do
        if _G.Settings.ChikaraFarm and player.Character then
            local target = getClosestBox()
            if target then
                -- Tweening to the box
                local root = player.Character.HumanoidRootPart
                local dist = (root.Position - target.Position).Magnitude
                local info = TweenInfo.new(dist/45, Enum.EasingStyle.Linear) -- Speed of 45
                local tween = TweenService:Create(root, info, {CFrame = target.CFrame * CFrame.new(0, 3, 0)})
                
                tween:Play()
                tween.Completed:Wait()
                
                -- Collect the box
                -- Most AFSE boxes use ProximityPrompts
                if target:FindFirstChildOfClass("ProximityPrompt") then
                    fireproximityprompt(target:FindFirstChildOfClass("ProximityPrompt"))
                elseif target:FindFirstChildOfClass("ClickDetector") then
                    fireclickdetector(target:FindFirstChildOfClass("ClickDetector"))
                end
                task.wait(0.5)
            end
        end
    end
end)
