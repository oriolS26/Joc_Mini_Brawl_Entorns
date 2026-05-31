local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Remote Events
local setDifficultyEvent = ReplicatedStorage:WaitForChild("SetDifficulty")
local atacEnemicEvent = ReplicatedStorage:WaitForChild("AtacEnemic")

-- UI Setup (2D Side-Scroller Style)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.Parent = pgui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromScale(1, 1)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Parent = screenGui

local barraFons = Instance.new("Frame")
barraFons.Name = "BarraFons"
barraFons.Size = UDim2.fromOffset(400, 40)
barraFons.Position = UDim2.fromScale(0.5, 0.5)
barraFons.AnchorPoint = Vector2.new(0.5, 0.5)
barraFons.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barraFons.Parent = mainFrame

local barraProgres = Instance.new("Frame")
barraProgres.Name = "BarraProgres"
barraProgres.Size = UDim2.fromScale(0, 1)
barraProgres.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
barraProgres.BorderSizePixel = 0
barraProgres.Parent = barraFons

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.fromScale(0.8, 0.2)
buttonContainer.Position = UDim2.fromScale(0.5, 0.5)
buttonContainer.AnchorPoint = Vector2.new(0.5, 0.5)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Visible = false
buttonContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 30)
layout.Parent = buttonContainer

local function createDifficultyButton(name, difficultyValue)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = name
    button.Size = UDim2.fromOffset(150, 60)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 28
    button.Parent = buttonContainer
    
    button.Activated:Connect(function()
        setDifficultyEvent:FireServer(difficultyValue)
        screenGui:Destroy()
    end)
    
    return button
end

createDifficultyButton("Facil", "Facil")
createDifficultyButton("Normal", "Normal")
createDifficultyButton("Dificil", "Dificil")

-- Loading Logic
local tween = TweenService:Create(barraProgres, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(1, 1)})
tween:Play()
tween.Completed:Connect(function()
    if barraFons then barraFons:Destroy() end
    buttonContainer.Visible = true
end)

-- CORE COMBAT (F KEY FIX)
local lastAttack = 0
local debounceTime = 0.5

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        local currentTime = tick()
        if currentTime - lastAttack >= debounceTime then
            lastAttack = currentTime
            print("[Combat] Attack key 'F' pressed!")
            atacEnemicEvent:FireServer()
        end
    end
end)
