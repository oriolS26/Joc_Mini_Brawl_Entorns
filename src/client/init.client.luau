local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

-- 1. CONFIGURACIÓ DE LA CÀMERA
camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
    -- Càmera fixa mirant al centre
    camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
end)

-- 2. RESTRICCIÓ DE MOVIMENT (EIX Z)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

RunService.Heartbeat:Connect(function()
    -- Forcem que la posició Z sigui sempre 0 per mantenir el 2D
    local currentPos = rootPart.Position
    rootPart.CFrame = CFrame.new(Vector3.new(currentPos.X, currentPos.Y, 0)) * rootPart.CFrame.Rotation
end)

-- 3. SISTEMA D'ATAC (Per a les proves de la Fase 4)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        print("PROVA: Atac executat amb la tecla F")
        
        -- Creem una Hitbox visual temporal
        local hitbox = Instance.new("Part")
        hitbox.Size = Vector3.new(4, 4, 2)
        hitbox.Transparency = 0.5
        hitbox.Color = Color3.fromRGB(255, 0, 0) -- Vermell
        hitbox.CanCollide = false
        hitbox.Anchored = true -- La posem manualment
        hitbox.Parent = workspace
        
        -- La col·loquem davant del jugador
        hitbox.CFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
        
        -- La borrem al cap d'un moment
        task.delay(0.2, function()
            hitbox:Destroy()
        end)
    end
end)