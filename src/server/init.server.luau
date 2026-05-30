local killPart = workspace:WaitForChild("KillPart")

killPart.Touched:Connect(function(hit)
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoid then
        print("SISTEMA: Jugador ha caigut! Mort detectada.")
        humanoid.Health = 0 -- Mata el personatge
    end
end)