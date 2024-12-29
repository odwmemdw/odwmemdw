local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function updateCharacter(newCharacter)
    character = newCharacter
end

player.CharacterAdded:Connect(updateCharacter)

local teleportButton = Instance.new("ImageButton")
teleportButton.Size = UDim2.new(0, 68, 0, 68)
teleportButton.Position = UDim2.new(1, -260, 1, -60)
teleportButton.AnchorPoint = Vector2.new(0.5, 0.5)
teleportButton.BackgroundTransparency = 1
teleportButton.Image = "rbxassetid://12345678"
teleportButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = teleportButton

local screenGui = player.PlayerGui:FindFirstChildOfClass("ScreenGui") or Instance.new("ScreenGui", player.PlayerGui)
teleportButton.Parent = screenGui

teleportButton.MouseButton1Click:Connect(function()
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        print("Character or HumanoidRootPart not found!")
        return
 end

local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
local teleportDistance = 200
local camera = workspace.CurrentCamera
local lookDirection = camera.CFrame.LookVector
local targetPosition = humanoidRootPart.Position + (lookDirection * teleportDistance)

local rayParams = RaycastParams.new()
      rayParams.FilterDescendantsInstances = {character}
      rayParams.FilterType = Enum.RaycastFilterType.Blacklist

local rayResult = workspace:Raycast(humanoidRootPart.Position, lookDirection * teleportDistance, rayParams)

        if rayResult then
            targetPosition = rayResult.Position - lookDirection * 2
        end

        humanoidRootPart.CFrame = CFrame.new(targetPosition)
        print("Teleported to:", targetPosition)
    else
        print("HumanoidRootPart not found!")
    end
end)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

local localPlayer = Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    
local allowedGameId = 6961824067
    if game.PlaceId == allowedGameId then
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X')))()
local Window = OrionLib:MakeWindow({Name = "鈴木んたま", HidePremium = false, IntoroEnabled = false,IntroText = "panpan!!♡" ,SaveConfig = true, ConfigFolder = "panpan!!♡"})

local w = game:GetService("Workspace")
local d = game:GetService("Debris")
    
local bodyvel_Name = "FlingVelocity"
local fling = true
local strength = 400
    
local function onChildAdded(model)
        if model.Name == "GrabParts" then
local part_to_impulse = model["GrabPart"]["WeldConstraint"].Part1
    
            if part_to_impulse then
                print("Part found!")
    
                local velocityObj = Instance.new("BodyVelocity", part_to_impulse)
    
                model:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not model.Parent then
                        if fling then
                            print("Launched!")
                            velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            velocityObj.Velocity = workspace.CurrentCamera.CFrame.lookVector * strength
                            d:AddItem(velocityObj, 1)
                        else
                            velocityObj.MaxForce = Vector3.new(0, 0, 0)
                            d:AddItem(velocityObj, 1)
                            print("Cancel Launch!")
                        end
                    end
                end)
            end
        end
    end
w.ChildAdded:Connect(onChildAdded)
    
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local strengthConnection
local _G = { rotationStrength = 50}
local GrabTab = Window:MakeTab({
      Name = "掴み",
    	Icon = "",
    	PremiumOnly = false
})

GrabTab:AddToggle({
    Name = "投げる力",
    Default = false,
    Callback = function(state)
         fling = state
           if fling then
               print("Super Fling: ON!")
           else
               print("Super Fling: OFF!")
           end
       end
})

GrabTab:AddSlider({
    Name = "",
    Min = 400, 
    Max = 2000,
    Default = strength,
    Color = Color3.fromRGB(0, 500,0),
    Increment = 100, 
    ValueName = "強さ",
    Callback = function(value)
          strength = value
            print("Fling Strength set to:", strength)
        end
})

local _G = { rotationStrength = 50}
GrabTab:AddToggle({
    Name = "回転掴み（掴んだまま）",
    Default = false,
    Color = Color3.fromRGB(0, 1000, 0),
    Save = true,
    Flag = "RotationToggle",
    Callback = function(enabled)
            if enabled then
                strengthConnection = workspace.ChildAdded:Connect(function(model)
                    if model.Name == "GrabParts" then
                        local partToRotate = model.GrabPart.WeldConstraint.Part1
                        if partToRotate then
                            local angularVelocityObj = Instance.new("BodyAngularVelocity", partToRotate)
                            angularVelocityObj.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            angularVelocityObj.AngularVelocity = Vector3.new(0, _G.rotationStrength, 0)
                            angularVelocityObj.P = 3000
                            model:GetPropertyChangedSignal("Parent"):Connect(function()
                                if not model.Parent then
                                    angularVelocityObj:Destroy()
                                end
                            end)
                            UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    angularVelocityObj.AngularVelocity = workspace.CurrentCamera.CFrame.LookVector * _G.rotationStrength
                                    Debris:AddItem(angularVelocityObj, 1)
                                end
                            end)
                        end
                    end
                end)
            elseif strengthConnection then
                strengthConnection:Disconnect()
                strengthConnection = nil
            end
        end
})

local _G = { rotationStrength = 50 }
GrabTab:AddToggle({
    Name = "回転掴み",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Save = true,
    Flag = "RotationToggle",
    Callback = function(enabled)
            if enabled then
                strengthConnection = workspace.ChildAdded:Connect(function(model)
                    if model.Name == "GrabParts" then
                        local partToRotate = model.GrabPart.WeldConstraint.Part1
                        if partToRotate then
                           local angularVelocityObj = partToRotate:FindFirstChild("BodyAngularVelocity")
                            if not angularVelocityObj then
                                angularVelocityObj = Instance.new("BodyAngularVelocity", partToRotate)
                                angularVelocityObj.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                angularVelocityObj.AngularVelocity = Vector3.new(0, _G.rotationStrength, 0)
                                angularVelocityObj.P = 3000
                            end
                            local function makeTransparent(obj)
                                for _, descendant in pairs(obj:GetDescendants()) do
                                    if descendant:IsA("BasePart") then
                                        descendant.Transparency = 1
                                    elseif descendant:IsA("Constraint") then
                                        descendant.Visible = false
                                    end
                                end
                            end
                            makeTransparent(model)
                            task.delay(0.0001, function()
                                if model.Parent then
                                    model:Destroy()
                                    print("Grab released instantly.")
                                end
                            end)
                            local function maintainRotation()
                                while angularVelocityObj and angularVelocityObj.Parent do
                                    angularVelocityObj.AngularVelocity = Vector3.new(0, _G.rotationStrength, 0)
                                    task.wait(0.00000000000000000001)
                                end
                            end
                            task.spawn(maintainRotation)
                        end
                    end
                end)
            elseif strengthConnection then
                strengthConnection:Disconnect()
                strengthConnection = nil
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BodyAngularVelocity") then
                        obj:Destroy()
                    end
                end
                print("Rotation stopped for all objects")
            end
        end
})

local strengthConnection
local _G = { strength = 200 }
GrabTab:AddToggle({
    Name = "掴んだ状態で飛ばす",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Save = true,
    Flag = "FlyStraightToggle",
    Callback = function(enabled)
            if enabled then
                strengthConnection = workspace.ChildAdded:Connect(function(model)
                    if model.Name == "GrabParts" then
                        local partToImpulse = model.GrabPart.WeldConstraint.Part1
                        if partToImpulse then
                            local velocityObj = Instance.new("BodyVelocity", partToImpulse)
                            velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            velocityObj.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.strength
                            velocityObj.P = 2000
                            model:GetPropertyChangedSignal("Parent"):Connect(function()
                                if not model.Parent then
                                    velocityObj:Destroy()
                                end
                            end)
                            UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    velocityObj.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.strength
                                end
                            end)
                            Debris:AddItem(velocityObj, 5)
                        end
                    end
                end)
            elseif strengthConnection then
                strengthConnection:Disconnect()
                strengthConnection = nil
            end
        end
})

GrabTab:AddToggle({
    Name = "上昇掴み",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Save = true,
    Flag = "LiftUpGrab",
    Callback = function(enabled)
        if enabled then
            liftConnection = workspace.ChildAdded:Connect(function(model)
                if model.Name == "GrabParts" then
                    local grabbedObject = model.GrabPart.WeldConstraint.Part1
                    if grabbedObject then
                        local bodyPosition = Instance.new("BodyPosition", grabbedObject)
                        bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyPosition.P = 3000 
                        bodyPosition.D = 100 
                        bodyPosition.Position = grabbedObject.Position 
                        local function liftUp()
                            while bodyPosition and bodyPosition.Parent do
                                bodyPosition.Position = bodyPosition.Position + Vector3.new(0, 0.5, 0) 
                                task.wait(0.02)
                            end
                        end
                        task.spawn(liftUp)
                        model:GetPropertyChangedSignal("Parent"):Connect(function()
                            if not model.Parent then
                                if bodyPosition then
                                    bodyPosition:Destroy()
                                end
                            end
                        end)
                        if grabbedObject:IsA("Model") and grabbedObject:FindFirstChild("Humanoid") then
                            print("Player is being lifted.")
                        else
                            print("Object is being lifted.")
                        end
                    end
                end
            end)
        elseif liftConnection then
            liftConnection:Disconnect()
            liftConnection = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BodyPosition") then
                    obj:Destroy()
                end
            end
            print("Lift-up effect disabled for all objects.")
        end
    end
})

GrabTab:AddToggle({
    Name = "キル掴み",
    Default = false,
    Color = Color3.fromRGB(0, 1000, 0),
    Save = true,
    Flag = "KillToggle",
    Callback = function(enabled)
        if enabled then
                strengthConnection = workspace.ChildAdded:Connect(function(model)
                    if model.Name == "GrabParts" then
                        local partToCheck = model.GrabPart.WeldConstraint.Part1
                        if partToCheck and partToCheck:IsDescendantOf(workspace) then
                            local character = partToCheck:FindFirstAncestorOfClass("Model")
                            local player = Players:GetPlayerFromCharacter(character)
                            if player and character:FindFirstChild("Humanoid") then
                                character.Humanoid.Health = 0
                            end
                        end
                    end
                end)
            elseif strengthConnection then
                strengthConnection:Disconnect()
                strengthConnection = nil
            end
        end
})


local running = false

GrabTab:AddToggle({
    Name = "ノークリップ掴み",
    Default = false,
    Color = Color3.fromRGB(0, 1000, 0),
    Save = true,
    Flag = "NoclipGrab",
    Callback = function(enabled)
        running = enabled
        while running do
            local success, err = pcall(function()
                local grabParts = workspace:FindFirstChild("GrabParts")
                if grabParts then
                    local grabPart = grabParts:FindFirstChild("GrabPart")
                    if grabPart then
                        local weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            local character = weld.Part1.Parent
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                for _, part in ipairs(character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if not success then
                warn(err)
            end
            wait()
        end

        local grabParts = workspace:FindFirstChild("GrabParts")
        if grabParts then
            local grabPart = grabParts:FindFirstChild("GrabPart")
            if grabPart then
                local weld = grabPart:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 then
                    local character = weld.Part1.Parent
                    if character then
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        end
    end
})



local blobman = nil
local selectedPlayer = nil
local function blobGrabPlayerRightHand(player, blobman)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local args = {
            [1] = blobman:FindFirstChild("RightDetector"),
            [2] = player.Character:FindFirstChild("HumanoidRootPart"),
            [3] = blobman:FindFirstChild("RightDetector"):FindFirstChild("RightWeld")
}
        blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(args))
        print("右手でプレイヤーを掴みました:", player.Name)
    else
        print("プレイヤーが有効なキャラクターを持っていません。")
    end
end
local function findBlobman()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "CreatureBlobman" then
            if v:FindFirstChild("VehicleSeat") and v.VehicleSeat:FindFirstChild("SeatWeld") and v.VehicleSeat.SeatWeld.Part1:IsDescendantOf(localPlayer.Character) then
                return v
            end
        end
    end
    return nil
end
local function getPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.DisplayName .. " (" .. player.Name .. ")")
        end
    end
    return playerList
end


local BlobmanTab = Window:MakeTab({
    Name = "ブロブマンこ",
    Icon = "",
    PremiumOnly = false
})
BlobmanTab:AddDropdown({
    Name = "プレイヤーを選ぶ",
    Default = "",
    Options = getPlayerList(),
    Callback = function(selected)
        for _, player in pairs(Players:GetPlayers()) do
            local displayNameWithUsername = player.DisplayName .. " (" .. player.Name .. ")"
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

BlobmanTab:AddButton({
    Name = "掴む",
    Callback = function()
        if not selectedPlayer then
            print("プレイヤーが選択されていません。")
            return
        end
        blobman = findBlobman()
        if not blobman then
            print("Blobmanが見つかりません。")
            return
        end
        blobGrabPlayerRightHand(selectedPlayer, blobman)
    end
})




_G.BlobmanDelay = 0
local blobmanCoroutine = nil
local blobman = nil
local handSelection = "両手"
local excludeFriends = false
local friendCache = {}

local function updateFriendCache()
    friendCache = {}
    for _, player in pairs(Players:GetPlayers()) do
        if localPlayer:IsFriendsWith(player.UserId) then
            friendCache[player.UserId] = true
        end
    end
    print("フレンドキャッシュ更新:", friendCache)
end

local function blobGrabPlayer(player, blobman)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if handSelection == "両手" or handSelection == "左手" then
            local argsLeft = {
                blobman:FindFirstChild("LeftDetector"),
                player.Character:FindFirstChild("HumanoidRootPart"),
                blobman:FindFirstChild("LeftDetector"):FindFirstChild("LeftWeld")
            }
            blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(argsLeft))
        end
        if handSelection == "両手" or handSelection == "右手" then
            local argsRight = {
                blobman:FindFirstChild("RightDetector"),
                player.Character:FindFirstChild("HumanoidRootPart"),
                blobman:FindFirstChild("RightDetector"):FindFirstChild("RightWeld")
            }
            blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(argsRight))
        end
    end
end

local function findBlobman()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "CreatureBlobman" then
            if v:FindFirstChild("VehicleSeat") and v.VehicleSeat:FindFirstChild("SeatWeld") and v.VehicleSeat.SeatWeld.Part1:IsDescendantOf(localPlayer.Character) then
                return v
            end
        end
    end
    return nil
end


_G.ToyToLoad = "CreatureBlobman"
_G.MaxBlobman = 1

local localPlayer = game.Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()

localPlayer.CharacterAdded:Connect(function(character)
    playerCharacter = character
end)

local toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
local autoBlobmanEnabled = false

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

local function findOwnedBlobman()
    if not toysFolder then
        toysFolder = workspace:FindFirstChild(localPlayer.Name .. "SpawnedInToys")
    end

    if toysFolder then
        for _, v in pairs(toysFolder:GetChildren()) do
            if v.Name == "CreatureBlobman" then
                return v
            end
        end
    end

    return nil
end

local function autoBlobman()
    local checkInterval = 0
    while autoBlobmanEnabled do
        pcall(function()
            local blobman = findOwnedBlobman()

            if not blobman then
                if localPlayer.CanSpawnToy and localPlayer.CanSpawnToy.Value and playerCharacter:FindFirstChild("Head") then
                    print("[INFO] Blobmanをスポーン中...")
                    spawnItemCf(_G.ToyToLoad, playerCharacter.Head.CFrame or playerCharacter.HumanoidRootPart.CFrame)
                end
            else
                local vehicleSeat = blobman:FindFirstChild("VehicleSeat")
                if vehicleSeat and not vehicleSeat:FindFirstChild("SeatWeld") then
                    localPlayer.Character:MoveTo(vehicleSeat.Position + Vector3.new(0, 2, 0))
                    local prompt = vehicleSeat:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        print("[INFO] 自分のBlobmanに座りました!")
                    else
                        print("[WARN] VehicleSeatにProximityPromptが見つかりませんでした")
                    end
                end
            end
        end)
        wait(checkInterval)
    end
end


local function toggleAutoBlobman(enabled)
    autoBlobmanEnabled = enabled
    if enabled then
        print("[INFO] 自動Blobman機能を有効化しました")
        task.spawn(autoBlobman)
    else
        print("[INFO] 自動Blobman機能を無効化しました")
    end
end

local function findBlobman()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "CreatureBlobman" then
            if v:FindFirstChild("VehicleSeat") and v.VehicleSeat:FindFirstChild("SeatWeld") and v.VehicleSeat.SeatWeld.Part1:IsDescendantOf(game.Players.LocalPlayer.Character) then
                return v 
            end
        end
    end
    return nil 
end

local Section = BlobmanTab:AddSection({
	Name = "オール"
})

BlobmanTab:AddDropdown({
    Name = "選ぶ",
    Default = "両手",
    Options = {"両手", "左手", "右手"},
    Callback = function(selected)
        handSelection = selected
        print("選択した手:", handSelection)
    end
})

BlobmanTab:AddToggle({
    Name = "キックオール",
    Default = false,
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(enabled)
        if enabled then
            print("キックオール開始")
            blobmanCoroutine = coroutine.create(function()
                local blobman = findBlobman()
                while enabled do
                    pcall(function()
                        for _, player in pairs(Players:GetPlayers()) do
                            if excludeFriends and friendCache[player.UserId] then
                                print(player.Name .. " はフレンドのため除外")
                            else
                                if player ~= localPlayer then
                                    blobGrabPlayer(player, blobman)
                                    print(player.Name .. " が対象")
                                    wait(_G.BlobmanDelay)
                                end
                            end
                        end
                    end)
                    wait()
                end
            end)
            coroutine.resume(blobmanCoroutine)
        else
            if blobmanCoroutine then
                coroutine.close(blobmanCoroutine)
                blobmanCoroutine = nil
                print("キックオール停止")
            end
        end
    end
})

BlobmanTab:AddToggle({
    Name = "ホワイトリストフレンド",
    Default = false,
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(enabled)
        excludeFriends = enabled
        if enabled then
            print("フレンド除外モード有効")
            updateFriendCache()
        else
            print("フレンド除外モード無効")
        end
    end
})

Players.PlayerAdded:Connect(updateFriendCache)
Players.PlayerRemoving:Connect(updateFriendCache)

updateFriendCache()



BlobmanTab:AddToggle({
    Name = "自動スポーンお座り",
    Default = false,
    Save = true,
    Flag = "AutoBlobman",
    Callback = function(enabled)
        toggleAutoBlobman(enabled)
    end
})



BlobmanTab:AddButton({
	Name = "空",
	Callback = function()
   local blobman = findBlobman()
        if blobman then
            if not blobman.PrimaryPart then
                blobman.PrimaryPart = blobman:FindFirstChild("HumanoidRootPart") or blobman:FindFirstChild("MainPart") or blobman:FindFirstChildWhichIsA("BasePart")
            end
            if blobman.PrimaryPart then
                local newPosition = Vector3.new(999, 60000000, 99)
                blobman:SetPrimaryPartCFrame(CFrame.new(newPosition))
                print("Blobmanを新しい位置にテレポートしました")
            else
                warn("BlobmanにPrimaryPartが設定されていません")
            end
        else
            warn("Blobmanに座っていません！")
        end
    end
})

local antiTab = Window:MakeTab({
    Name = "アンチ",
    Icon = "",
    PremiumOnly = false
})

local isFrozen = false
local function ForceFreeze()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

    while not character:FindFirstChild("HumanoidRootPart") do
        wait()
    end
local parts = {
      character:FindFirstChild("Left Arm"),
      character:FindFirstChild("Left Leg"),
      character:FindFirstChild("Right Arm"),
      character:FindFirstChild("Right Leg"),
      character:FindFirstChild("Head"),
      character:FindFirstChild("HumanoidRootPart")
}
while isFrozen do
        for _, part in pairs(parts) do
            if part and part.Anchored == false then
                part.Anchored = true
            end
        end
        wait()
    end
end
antiTab:AddToggle({
    Name = "無敵",
    Color = Color3.fromRGB(255, 165, 0),
    Default = false,
    Save = true,
    Flag = "FreezeToggle",
    Callback = function(value)
        isFrozen = value
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local parts = {
      character:FindFirstChild("Left Arm"),
      character:FindFirstChild("Left Leg"),
      character:FindFirstChild("Right Arm"),
      character:FindFirstChild("Right Leg"),
      character:FindFirstChild("Head"),
      character:FindFirstChild("HumanoidRootPart")
        }
if isFrozen then
            for _, part in pairs(parts) do
                if part then
                    part.Anchored = true
                end
            end
spawn(ForceFreeze)
        else
            for _, part in pairs(parts) do
                if part then
                    part.Anchored = false
                end
            end
        end
    end
})

local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local R = game:GetService("RunService")

local Player = PS.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local CE = RS:WaitForChild("CharacterEvents")
local BeingHeld = Player:WaitForChild("IsHeld")
local StruggleEvent = CE:WaitForChild("Struggle")

local AntiGrabEnabled = false
local CurrentConnection = nil

local function PreventBeingHeld()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart")

    if CurrentConnection then
        CurrentConnection:Disconnect()
        CurrentConnection = nil
    end

    CurrentConnection = R.RenderStepped:Connect(function()
        if AntiGrabEnabled and BeingHeld.Value == true then
            for _ = 1, 30 do
                StruggleEvent:FireServer(Player)
            end

            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0.000001, 0)
        elseif BeingHeld.Value == false then
            if CurrentConnection then
                CurrentConnection:Disconnect()
                CurrentConnection = nil
            end
        end
    end)
end

local function EnableAntiGrab()
    BeingHeld.Changed:Connect(function()
        if AntiGrabEnabled and BeingHeld.Value == true then
            PreventBeingHeld()
        end
    end)
end

local function DisableAntiGrab()
    if CurrentConnection then
        CurrentConnection:Disconnect()
        CurrentConnection = nil
    end
    print("アンチ掴み無効化")
end

Player.CharacterAdded:Connect(function(char)
    local Humanoid = char:WaitForChild("Humanoid")
    if Humanoid then
        Humanoid.Changed:Connect(function(property)
            if property == "Sit" and Humanoid.Sit == true then
                if Humanoid.SeatPart and tostring(Humanoid.SeatPart.Parent) == "CreatureBlobman" then
                else
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    Humanoid.Sit = false
                end
            end
        end)
    end
end)

antiTab:AddToggle({
    Name = "アンチ掴み",
    Default = false,
    Color = Color3.fromRGB(255, 165, 0),
    Callback = function(Value)
        AntiGrabEnabled = Value
        if Value then
            print("アンチ掴み有効化")
            EnableAntiGrab()
        else
            DisableAntiGrab()
        end
    end
})
local function setupAntiExplosion(character)
local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
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

antiTab:AddToggle({
    Name = "アンチ爆発",
    Default = false,
    Color = Color3.fromRGB(255, 165, 0),
    Flag = "AntiExplosion",
    Callback = function(enabled)
        if enabled then
            if localPlayer.Character then
                setupAntiExplosion(localPlayer.Character)
            end
                characterAddedConn = localPlayer.CharacterAdded:Connect(function(character)
                if antiExplosionConnection then
                    antiExplosionConnection:Disconnect()
                end
                setupAntiExplosion(character)
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
local leftLeg = playerCharacter:FindFirstChild("Left Leg") or torso
if torso and leftLeg then
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
            currentKunai.PrimaryPart.Anchored = false
local weld = Instance.new("WeldConstraint")
      weld.Part0 = currentKunai.PrimaryPart
      weld.Part1 = leftLeg
      weld.Parent = currentKunai.PrimaryPart
currentKunai.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    print("Kunai has been removed. Respawning...")
                    currentKunai = nil
                    attachKunaiToThigh()
                end
end)
          print("Kunai has been attached to the thigh (R6).")
        else
            warn("Kunai could not be spawned. Retrying...")
        end
    else
        warn("Torso or Left Leg not found!")
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
    Name = "アンチキック（Beta）",
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

local Toggle = playerTab:AddToggle({
    Name = "プレイヤーの速度",
    Default = false,
    Callback = function(state)
        ToggleActive = state
    end
})
playerTab:AddSlider({
    Name = "速度",
    Min = 16,
    Max = 1000,
    Default = 5,
    Color = Color3.fromRGB(150,122,240),
    Increment = 1,
    ValueName = "speed",
    Callback = function(speed)
        HackedWalkSpeed = speed

        local Plrs = game:GetService("Players")
        local MyPlr = Plrs.LocalPlayer
        
      
        local function setWalkSpeed(Humanoid)
            if ToggleActive then 
                Humanoid.WalkSpeed = HackedWalkSpeed
            end
        end

     
        local function updateCharacter(Char)
            local Humanoid = Char:WaitForChild("Humanoid")
            setWalkSpeed(Humanoid)

         
            while true do
                wait(0) 
                if not ToggleActive then break end  
                setWalkSpeed(Humanoid) 
            end

            Humanoid.Changed:connect(function()
                setWalkSpeed(Humanoid)
            end)
        end

     
        if MyPlr.Character then
            updateCharacter(MyPlr.Character)
        end
        
        MyPlr.CharacterAdded:connect(updateCharacter)
    end
})

local Toggle =  playerTab:AddToggle({
    Name = "プレイヤーのジャンプ力",
    Default = false,
    Callback = function(state)
        ToggleActive = state
    end
})

playerTab:AddSlider({
    Name = "ジャンプ力",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(150,122,240),
    Increment = 1,
    ValueName = "jumpPower",
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
    
local autoAimEnabled = false
local fov = 100
local maxDistance = 50
local maxTransparency = 0.1
local teamCheck = false
    
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera
local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2
    
local function updateDrawings()
local camViewportSize = Cam.ViewportSize
      FOVring.Position = camViewportSize / 2
end
    
local function lookAt(target)
local lookVector = (target - Cam.CFrame.Position).unit
local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
        Cam.CFrame = newCFrame
end

local function calculateTransparency(distance)
        local transparency = (1 - (distance / fov)) * maxTransparency
        return transparency
    end
local function isPlayerAlive(player)
local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            return character.Humanoid.Health > 0
    end
    return false
end

local function getClosestPlayerInFOV(trg_part)
local nearest = nil
local last = math.huge
local playerMousePos = Cam.ViewportSize / 2
local localPlayer = Players.LocalPlayer
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and (not teamCheck or player.Team ~= localPlayer.Team) then
                if isPlayerAlive(player) then
                    local part = player.Character and player.Character:FindFirstChild(trg_part)
                    if part then
                        local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                        local distance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude
    
                        if distance < last and isVisible and distance < fov and distance < maxDistance then
                            last = distance
                            nearest = player
                        end
                    end
                end
            end
        end
        return nearest
    end
local function toggleAutoAim(state)
autoAimEnabled = state
       if autoAimEnabled then
         RunService:BindToRenderStep("AutoAim", Enum.RenderPriority.Camera.Value, function()
                updateDrawings()
                local closest = getClosestPlayerInFOV("Head")
                if closest and closest.Character:FindFirstChild("Head") then
                    lookAt(closest.Character.Head.Position)
                end
                
                if closest then
                    local ePos, isVisible = Cam:WorldToViewportPoint(closest.Character.Head.Position)
                    local distance = (Vector2.new(ePos.X, ePos.Y) - (Cam.ViewportSize / 2)).Magnitude
                FOVring.Transparency = calculateTransparency(distance)
            else
                FOVring.Transparency = maxTransparency
            end
        end)
    else
        RunService:UnbindFromRenderStep("AutoAim")
        FOVring.Transparency = maxTransparency
    end
end
miscTab:AddToggle({
    Name = "オートエイム",
    Default = false,
    Callback = function(state)
    toggleAutoAim(state)
    end
})

local Players = game:GetService("Players")

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
