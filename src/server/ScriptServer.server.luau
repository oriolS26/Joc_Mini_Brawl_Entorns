local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Creació dels RemoteEvents
local remoteAtac = Instance.new("RemoteEvent", ReplicatedStorage)
remoteAtac.Name = "AtacEnemic"
local remoteDificultat = ReplicatedStorage:FindFirstChild("SetDifficulty") or Instance.new("RemoteEvent", ReplicatedStorage)
remoteDificultat.Name = "SetDifficulty"

local function crearCubEnemic()
    if Workspace:FindFirstChild("EnemicIA") then Workspace.EnemicIA:Destroy() end
    local model = Instance.new("Model", Workspace)
    model.Name = "EnemicIA"
    local cub = Instance.new("Part", model)
    cub.Name = "HumanoidRootPart"
    cub.Size = Vector3.new(4, 5, 4)
    cub.Color = Color3.fromRGB(255, 0, 0)
    cub.Position = Vector3.new(20, 10, 0)
    cub.Anchored = false
    cub.CanCollide = true
    cub.Massless = false
    
    local hum = Instance.new("Humanoid", model)
    model.PrimaryPart = cub
    
    -- Moviment 2D (persecució)
    RunService.Heartbeat:Connect(function()
        if not model.Parent then return end
        local p = Players:GetPlayers()[1]
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            hum:MoveTo(Vector3.new(p.Character.HumanoidRootPart.Position.X, cub.Position.Y, 0))
        end
    end)
    return cub
end

remoteDificultat.OnServerEvent:Connect(function(player, diff)
    local cub = crearCubEnemic()
    cub.Parent.Humanoid.WalkSpeed = (diff == "Facil" and 8) or (diff == "Normal" and 14) or 22
end)

remoteAtac.OnServerEvent:Connect(function(player)
    local enemic = Workspace:FindFirstChild("EnemicIA")
    if enemic and enemic:FindFirstChild("HumanoidRootPart") then
        local vel = Instance.new("LinearVelocity", enemic.HumanoidRootPart)
        vel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        vel.VectorVelocity = Vector3.new(60, 20, 0)
        vel.Attachment0 = Instance.new("Attachment", enemic.HumanoidRootPart)
        Debris:AddItem(vel, 0.2)
        Debris:AddItem(vel.Attachment0, 0.2)
    end
end)