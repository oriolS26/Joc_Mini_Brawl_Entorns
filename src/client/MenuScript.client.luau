local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

-- Agafem el Frame on està ficat el script
local framePrincipal = script.Parent 
local barraFons = framePrincipal:WaitForChild("BarraFons")
local barraProgres = barraFons:WaitForChild("BarraProgres")

-- Busquem el RemoteEvent (si no existeix, esperem)
local remote = ReplicatedStorage:WaitForChild("SetDifficulty")

local botons = {
    Facil = framePrincipal:WaitForChild("BotoFacil"),
    Normal = framePrincipal:WaitForChild("BotoNormal"),
    Dificil = framePrincipal:WaitForChild("BotoDificil")
}

-- 1. Configuració inicial
barraFons.Visible = true
barraProgres.Size = UDim2.new(0, 0, 1, 0)
for _, boto in pairs(botons) do boto.Visible = false end

-- 2. Animació de càrrega
task.wait(0.5)
local tween = TweenService:Create(barraProgres, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

tween.Completed:Connect(function()
    barraFons.Visible = false
    for _, boto in pairs(botons) do
        boto.Visible = true
    end
end)

-- 3. Connexió de botons
for dificultat, boto in pairs(botons) do
    boto.MouseButton1Click:Connect(function()
        remote:FireServer(dificultat)
        _G.JocIniciat = true 
        
        -- Animació de sortida: lliscar cap avall
        local fadeOut = TweenService:Create(framePrincipal, TweenInfo.new(0.5), {Position = UDim2.new(0, 0, 1, 0)})
        fadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            -- Busquem el ScreenGui pare per apagar-lo
            local screenGui = framePrincipal.Parent
            if screenGui:IsA("ScreenGui") then
                screenGui.Enabled = false
            end
        end)
    end)
end