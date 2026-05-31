local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService") -- AFEGIT: Necessari per al Heartbeat

-- 1. Configuració de la KillPart
local killPart = workspace:WaitForChild("KillPart")
killPart.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end)

-- 2. Configuració del RemoteEvent (Segur)
local remote = ReplicatedStorage:FindFirstChild("SetDifficulty")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "SetDifficulty"
	remote.Parent = ReplicatedStorage
end

-- 3. Lògica de l'Enemic IA
remote.OnServerEvent:Connect(function(player, dificultat)
	print("SISTEMA: Iniciant enemic en mode: " .. dificultat)
	
	-- Creem un bloc que et persegueix (Enemic temporal)
	local enemic = Instance.new("Part")
	enemic.Name = "EnemicIA"
	enemic.Size = Vector3.new(4, 6, 1)
	enemic.Color = Color3.fromRGB(255, 0, 0)
	enemic.Position = Vector3.new(20, 5, 0) -- Apareix una mica lluny
	enemic.Anchored = true -- Perquè no caigui si no té Humanoid
	enemic.CanCollide = false
	enemic.Parent = workspace
	
	-- Ajustem la velocitat segons dificultat
	local velocitat = 0.05
	if dificultat == "Normal" then velocitat = 0.1 end
	if dificultat == "Dificil" then velocitat = 0.2 end
	
	-- Moviment en 2D cap al jugador
	RunService.Heartbeat:Connect(function()
		if enemic.Parent then -- Comprovem que l'enemic encara existeixi
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			
			if root then
				local targetX = root.Position.X
				local actualX = enemic.Position.X
				
				-- Si el jugador està a la dreta, suma; si està a l'esquerra, resta
				if targetX > actualX then
					enemic.Position = enemic.Position + Vector3.new(velocitat, 0, 0)
				else
					enemic.Position = enemic.Position - Vector3.new(velocitat, 0, 0)
				end
			end
		end
	end)
end)