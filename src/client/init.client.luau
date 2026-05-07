local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
    camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

RunService.Heartbeat:Connect(function()
    -- Forcem que la posició Z sigui sempre 0
    local currentPos = rootPart.Position
    rootPart.CFrame = CFrame.new(Vector3.new(currentPos.X, currentPos.Y, 0)) * rootPart.CFrame.Rotation
end)
