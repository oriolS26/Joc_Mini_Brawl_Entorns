local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 1. CONFIGURACIÓ DE L'ESTAT
_G.JocIniciat = false 

camera.CameraType = Enum.CameraType.Scriptable

-- 2. BUCLE DE CÀMERA (Es queda fixa fins que cliques el botó del menú)
RunService.RenderStepped:Connect(function()
	if _G.JocIniciat then
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		
		if root then
			-- Càmera 2D dinàmica (segueix al personatge)
			local targetPos = Vector3.new(root.Position.X, root.Position.Y + 2, 30)
			camera.CFrame = CFrame.new(targetPos, Vector3.new(root.Position.X, root.Position.Y + 2, 0))
		end
	else
		-- Càmera de menú (Vista al ring des de lluny)
		camera.CFrame = CFrame.new(Vector3.new(0, 10, 30), Vector3.new(0, 0, 0))
	end
end)

-- 3. LÒGICA 2D I CONTROL DE MOVIMENT
local function iniciarLogica(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	
	-- Bloqueig inicial: el jugador no es mou fins que el joc comenci
	humanoid.WalkSpeed = 0
	
	task.spawn(function()
		while not _G.JocIniciat do task.wait(0.1) end
		humanoid.WalkSpeed = 16 -- Velocitat normal un cop triada dificultat
	end)

	-- Bloqueig de l'eix Z (Manté el joc en 2D)
	local connexioZ = RunService.Heartbeat:Connect(function()
		if not character:IsDescendantOf(workspace) then return end
		local currentPos = rootPart.Position
		rootPart.CFrame = CFrame.new(Vector3.new(currentPos.X, currentPos.Y, 0)) * rootPart.CFrame.Rotation
	end)

	humanoid.Died:Connect(function()
		connexioZ:Disconnect()
	end)
end

player.CharacterAdded:Connect(iniciarLogica)
if player.Character then iniciarLogica(player.Character) end

-- 4. SISTEMA D'ATAC (TECLA F)
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or not _G.JocIniciat then return end -- No ataca si el menú està obert
	
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
			hitbox.CFrame = root.CFrame * CFrame.new(0, 0, -3)
			
			task.delay(0.2, function()
				hitbox:Destroy()
			end)
		end
	end
end)