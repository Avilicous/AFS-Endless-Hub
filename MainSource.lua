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
