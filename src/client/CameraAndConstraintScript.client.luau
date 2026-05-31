local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

camera.CameraType = Enum.CameraType.Scriptable

local function updateCamera()
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Find enemy if exists
            local enemy = workspace:FindFirstChild("EnemyCube")
            local targetPos = hrp.Position
            
            if enemy then
                local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                if enemyHrp then
                    targetPos = (hrp.Position + enemyHrp.Position) / 2
                end
            end
            
            -- Fixed Z offset for side view
            local cameraPos = Vector3.new(targetPos.X, targetPos.Y + 5, 25)
            camera.CFrame = CFrame.lookAt(cameraPos, Vector3.new(targetPos.X, targetPos.Y, 0))
        end
        
        -- Lock player to Z=0
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local currentCF = rootPart.CFrame
            rootPart.CFrame = CFrame.new(currentCF.Position.X, currentCF.Position.Y, 0)
        end
    end
end

RunService.Heartbeat:Connect(updateCamera)
