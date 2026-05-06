local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
    camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
end)