local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

-- Referències als elements de la interfície
local framePrincipal = script.Parent 
local barraFons = framePrincipal:WaitForChild("BarraFons")
local barraProgres = barraFons:WaitForChild("BarraProgres")

-- RemoteEvent per enviar la dificultat al servidor
local remote = ReplicatedStorage:WaitForChild("SetDifficulty")

local botons = {
    Facil = framePrincipal:WaitForChild("BotoFacil"),
    Normal = framePrincipal:WaitForChild("BotoNormal"),
    Dificil = framePrincipal:WaitForChild("BotoDificil")
}

-- 1. Configuració inicial (amaguem botons, mostrem barra)
barraFons.Visible = true
barraProgres.Size = UDim2.new(0, 0, 1, 0)
for _, boto in pairs(botons) do boto.Visible = false end

-- 2. Animació de càrrega
task.wait(0.5)
local infoTween = TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tween = TweenService:Create(barraProgres, infoTween, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

tween.Completed:Connect(function()
    barraFons.Visible = false
    for _, boto in pairs(botons) do
        boto.Visible = true
    end
end)

-- 3. Connexió dels botons per iniciar el joc
for dificultat, boto in pairs(botons) do
    boto.MouseButton1Click:Connect(function()
        -- Avisem al servidor quina dificultat hem triat
        remote:FireServer(dificultat)
        
        -- Activem la variable global per iniciar la lògica del joc
        _G.JocIniciat = true 
        
        -- Animació de sortida del menú (el fem baixar)
        local infoSortida = TweenInfo.new(0.5, Enum.EasingStyle.Back)
        local fadeOut = TweenService:Create(framePrincipal, infoSortida, {Position = UDim2.new(0, 0, 1.5, 0)})
        fadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            -- Amaguem tot el ScreenGui pare per no tapar la pantalla
            local screenGui = framePrincipal.Parent
            if screenGui:IsA("ScreenGui") then
                screenGui.Enabled = false
            end
        end)
    end)
end