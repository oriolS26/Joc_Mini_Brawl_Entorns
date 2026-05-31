local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local PathfindingService = game:GetService("PathfindingService")

local setDifficultyEvent = ReplicatedStorage:WaitForChild("SetDifficulty")
local atacEnemicEvent = ReplicatedStorage:WaitForChild("AtacEnemic")

local difficulties = {
	Facil = {speed = 10, sprintSpeed = 14, knockback = 30, resistance = 2.0},
	Normal = {speed = 14, sprintSpeed = 18, knockback = 50, resistance = 1.0},
	Dificil = {speed = 18, sprintSpeed = 24, knockback = 80, resistance = 0.5}
}

local currentEnemy = nil
local isSpawning = false
local config = difficulties.Normal

-- Knockback Utility
local function applyKnockback(targetPart, sourcePart, force)
	if not targetPart or not sourcePart then return end
	
	targetPart.Anchored = false
	local character = targetPart.Parent
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
	end
	
	local attachment = Instance.new("Attachment")
	attachment.Parent = targetPart
	
	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.MaxForce = 10^6
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VectorVelocity = (targetPart.Position - sourcePart.Position).Unit * force
	linearVelocity.Attachment0 = attachment
	linearVelocity.Parent = targetPart
	
	task.wait(0.2)
	if linearVelocity then linearVelocity:Destroy() end
	if attachment then attachment:Destroy() end
end

-- NPC AI & Logic
local function spawnBoss(difficultyName)
	if isSpawning then return end
	isSpawning = true
	
	config = difficulties[difficultyName] or difficulties.Normal
	
	-- Cleanup Old Boss and any "Cube" parts that might be lying around
	if currentEnemy then currentEnemy:Destroy() end
	for _, obj in workspace:GetChildren() do
		if obj.Name == "BossNPC" or obj.Name == "EnemyCube" or (obj:IsA("BasePart") and obj.Name == "Boss") then
			obj:Destroy()
		end
	end
	
	-- Spawn New R15 Rig Boss
	local bossTemplate = ServerStorage:WaitForChild("BossNPC")
	local model = bossTemplate:Clone()
	model.Name = "BossNPC"
	
	local hrp = model:WaitForChild("HumanoidRootPart")
	local humanoid = model:WaitForChild("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
	
	-- Spawn at SpawnLocation
	local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
	if spawnLocation then
		model:PivotTo(spawnLocation.CFrame * CFrame.new(10, 5, 0))
	else
		model:PivotTo(CFrame.new(20, 10, 0))
	end
	
	-- Ensure physics are enabled
	hrp.Anchored = false
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.CanCollide = true
		end
	end
	
	humanoid.WalkSpeed = config.speed
	model:SetAttribute("KnockbackResistance", config.resistance)
	
	model.Parent = workspace
	currentEnemy = model
	
	-- AI Pathfinding and Combat Loop
	task.spawn(function()
		local path = PathfindingService:CreatePath({
			AgentRadius = 3,
			AgentHeight = 6,
			AgentCanJump = true
		})
		
		local lastAttack = 0
		
		while model and model.Parent and humanoid.Health > 0 do
			local player = Players:GetPlayers()[1]
			local playerChar = player and player.Character
			local playerHrp = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
			
			if playerHrp then
				local dist = (hrp.Position - playerHrp.Position).Magnitude
				
				-- Aggressive Sprinting
				humanoid.WalkSpeed = (dist < 15) and config.sprintSpeed or config.speed
				
				-- Attack Logic
				if dist < 6 and tick() - lastAttack > 1.5 then
					lastAttack = tick()
					
					-- Apply Knockback
					applyKnockback(playerHrp, hrp, config.knockback)
					print("[AI] Boss attacked player!")
				end
				
				-- Path calculation
				local success, _ = pcall(function()
					path:ComputeAsync(hrp.Position, playerHrp.Position)
				end)
				
				if success and path.Status == Enum.PathStatus.Success then
					local waypoints = path:GetWaypoints()
					if #waypoints >= 2 then
						humanoid:MoveTo(waypoints[2].Position)
					end
				else
					humanoid:MoveTo(playerHrp.Position)
				end
				
				-- Orientation & 2D constraint
				local lookTarget = Vector3.new(playerHrp.Position.X, hrp.Position.Y, playerHrp.Position.Z)
				hrp.CFrame = CFrame.lookAt(hrp.Position, lookTarget)
			end
			
			-- Strict Z-plane lock for 2D feel
			hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y, 0) * (hrp.CFrame - hrp.Position)
			
			task.wait(0.2)
		end
	end)
	
	isSpawning = false
end

setDifficultyEvent.OnServerEvent:Connect(function(player, difficulty)
	spawnBoss(difficulty)
end)

atacEnemicEvent.OnServerEvent:Connect(function(player)
	if not currentEnemy then return end
	local enemyHrp = currentEnemy:FindFirstChild("HumanoidRootPart")
	local playerHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	
	if playerHrp and enemyHrp then
		local dist = (playerHrp.Position - enemyHrp.Position).Magnitude
		if dist < 10 then
			local resistance = currentEnemy:GetAttribute("KnockbackResistance") or 1.0
			applyKnockback(enemyHrp, playerHrp, 120 * resistance)
		end
	end
end)