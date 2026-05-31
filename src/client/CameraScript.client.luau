local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
-- Assegura't que el RemoteEvent s'anomena exactament així
local remoteAtac = ReplicatedStorage:WaitForChild("AtacEnemic")

-- Variable global per controlar si el joc ha començat
_G.JocIniciat = _G.JocIniciat or false

-- Funció per bloquejar el personatge al pla 2D (Eix Z = 0)
local function bloquejarPla2D(char)
    local root = char:WaitForChild("HumanoidRootPart")
    RunService.Heartbeat:Connect(function()
        if not char or not char.Parent then return end
        -- Fixem la posició Z a 0 i mantenim la rotació original
        root.CFrame = CFrame.new(Vector3.new(root.Position.X, root.Position.Y, 0)) * root.CFrame.Rotation
    end)
end

-- Configuració de la càmera fixa (RenderStepped)
RunService.RenderStepped:Connect(function()
    camera.CameraType = Enum.CameraType.Scriptable
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        
        -- Bloqueig d'eix per moure's només en el pla 2D
        root.CFrame = CFrame.new(Vector3.new(root.Position.X, root.Position.Y, 0)) * root.CFrame.Rotation
        
        if _G.JocIniciat then
            -- Aquesta línia és la que determina la vista. 
            -- Z = 30 fa que es vegi des de lluny, posa-ho a 20 si vols veure-ho més a prop.
            -- El Vector3.new(root.Position.X, root.Position.Y, 0) fa que el focus sigui el personatge.
            camera.CFrame = CFrame.new(Vector3.new(root.Position.X, 10, 30), Vector3.new(root.Position.X, 0, 0))
        else
            -- Vista inicial de menú
            camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
        end
    end
end)

-- Detectar l'inici del personatge
if player.Character then bloquejarPla2D(player.Character) end
player.CharacterAdded:Connect(bloquejarPla2D)

-- Lògica d'atac amb tecla F
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F and _G.JocIniciat then
        remoteAtac:FireServer()
    end
end)