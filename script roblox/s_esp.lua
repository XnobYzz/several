-- name: esp player
-- author: XIE 
-- description: Displays the player's name and distance from the current player's character. The script also updates information when new players join, leave, or change characters.

-- local screenGui = Instance.new("ScreenGui")
-- screenGui.Name = "TestGui"

-- local textLabel = Instance.new("TextLabel")
-- textLabel.Parent = screenGui
-- textLabel.Size = UDim2.new(0, 300, 0, 100)  
-- textLabel.Position = UDim2.new(0.5, -150, 0.5, -50)  
-- textLabel.Text = "XIE TEST"  
-- textLabel.TextColor3 = Color3.new(1, 1, 0)  
-- textLabel.TextScaled = true  
-- textLabel.Font = Enum.Font.SourceSansBold  
-- textLabel.BackgroundTransparency = 1  

-- screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local players = game:GetService("Players")
local runService = game:GetService("RunService")

function upstatus()
    print("\nServer Status:")
    print("Players: " .. #players:GetPlayers() .. "/" .. players.MaxPlayers)

    for _, player in pairs(players:GetPlayers()) do
        print("Username: " .. player.Name .. ", Display Name: " .. player.DisplayName)
    end
end

function createBox(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = p.Character.HumanoidRootPart

        local box = Instance.new("SelectionBox")
        box.Adornee = p.Character
        box.Color3 = Color3.fromRGB(0, 255, 0)  
        box.Parent = p.Character

        local distLabel = Instance.new("BillboardGui", hrp)
        distLabel.Size = UDim2.new(0, 200, 0, 50)
        distLabel.StudsOffset = Vector3.new(0, -1.5, 0)
        distLabel.AlwaysOnTop = true

        local distText = Instance.new("TextLabel", distLabel)
        distText.Size = UDim2.new(1, 0, 1, 0)
        distText.BackgroundTransparency = 1
        distText.TextColor3 = Color3.fromRGB(255, 255, 255) 
        distText.Text = "Distance: " .. math.floor((p.Character.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude) .. " m"

        local nameLabel = Instance.new("BillboardGui", hrp)
        nameLabel.Size = UDim2.new(0, 200, 0, 50)
        nameLabel.StudsOffset = Vector3.new(0, 3, 0)
        nameLabel.AlwaysOnTop = true

        local nameText = Instance.new("TextLabel", nameLabel)
        nameText.Size = UDim2.new(1, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.TextColor3 = Color3.fromRGB(0, 255, 0) 
        nameText.Text = p.Name
    end
end

function track()
    while true do
        for _, p in pairs(players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                createBox(p)  
            end
        end
    end
end

spawn(track)

players.PlayerAdded:Connect(function(player)
    print("New player joined: " .. player.Name)
    upstatus()

    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " has spawned their character.")
        createBox(player) 
    end)
end)

players.PlayerRemoving:Connect(function(player)
    print("Player left the server: " .. player.Name)
    upstatus()
end)

function creset(player)
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " has reset their character.")
        createBox(player)  
    end)
end

for _, player in pairs(players:GetPlayers()) do
    creset(player)
end
 
players.PlayerAdded:Connect(creset)
