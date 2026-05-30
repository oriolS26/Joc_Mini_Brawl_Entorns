local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 1. CONFIGURACIÓ DE LA CÀMERA (Es manté activa sempre)
camera.CameraType = Enum.CameraType.Scriptable
RunService.RenderStepped:Connect(function()
    camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
end)

-- 2. FUNCIÓ PER ACTIVAR LA LÒGICA 2D CADA COP QUE APAREIX EL PERSONATGE
local function iniciarLogica(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Bloqueig de l'eix Z (2D)
    local connexioZ = RunService.Heartbeat:Connect(function()
        if not character:IsDescendantOf(workspace) then return end
        local currentPos = rootPart.Position
        rootPart.CFrame = CFrame.new(Vector3.new(currentPos.X, currentPos.Y, 0)) * rootPart.CFrame.Rotation
    end)

    -- Si el personatge mor, desconnectem el bucle antic per no gastar memòria
    character:WaitForChild("Humanoid").Died:Connect(function()
        connexioZ:Disconnect()
    end)
end

-- Escltem quan el jugador apareix per primer cop o reapareix
player.CharacterAdded:Connect(iniciarLogica)
if player.Character then iniciarLogica(player.Character) end

-- 3. SISTEMA D'ATAC (TECLA F)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            print("Atac executat!")
            local hitbox = Instance.new("Part")
            hitbox.Size = Vector3.new(4, 4, 2)
            hitbox.Transparency = 0.5
            hitbox.Color = Color3.fromRGB(255, 0, 0)
            hitbox.CanCollide = false
            hitbox.Anchored = true
            hitbox.Parent = workspace
            
            -- La hitbox apareix davant d'on mira el jugador
            hitbox.CFrame = root.CFrame * CFrame.new(0, 0, -3)
            
            task.delay(0.2, function()
                hitbox:Destroy()
            end)
        end
    end
end)