-- name: esp player enhanced
-- author: XIE
-- description: Enhanced ESP with UI controls, toggle functionality, and player line connectors.

local p = game.Players.LocalPlayer
local c = p.Character
local h = c and c:FindFirstChildWhichIsA("Humanoid")
local n = false
local uiEnabled = true
local espEnabled = false

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ENHANCED DEMO | 15.09.2024",
    Text = "By XIE",
    Icon = "rbxthumb://type=Asset&id=139089428167914&w=150&h=150"
})

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera
local trackLoop = nil
local lines = {}
local espObjects = {}

-- Create GUI
local ui = Instance.new("ScreenGui", game.CoreGui)
local toggleBtn = Instance.new("TextButton", ui)
local resetBtn = Instance.new("TextButton", ui)
local hideBtn = Instance.new("TextButton", ui)

toggleBtn.Size = UDim2.new(0, 100, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Toggle ESP"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

resetBtn.Size = UDim2.new(0, 100, 0, 50)
resetBtn.Position = UDim2.new(0, 120, 0, 10)
resetBtn.Text = "Reset ESP"
resetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

hideBtn.Size = UDim2.new(0, 100, 0, 50)
hideBtn.Position = UDim2.new(0, 230, 0, 10)
hideBtn.Text = "Hide UI"
hideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Functions
local function upstatus()
    print("\nStatus:")
    print("P: " .. #players:GetPlayers() .. "/" .. players.MaxPlayers)
    for _, player in pairs(players:GetPlayers()) do
        print("U: " .. player.Name .. ", D: " .. player.DisplayName)
    end
end

local function createBox(p)
    if not espEnabled then return end
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = p.Character.HumanoidRootPart

        local box = Instance.new("SelectionBox")
        box.Adornee = p.Character
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.Parent = p.Character
        espObjects[p.Name] = box

        local distLabel = Instance.new("BillboardGui", hrp)
        distLabel.Size = UDim2.new(0, 200, 0, 50)
        distLabel.StudsOffset = Vector3.new(0, -1.5, 0)
        distLabel.AlwaysOnTop = true
        local distText = Instance.new("TextLabel", distLabel)
        distText.Size = UDim2.new(1, 0, 1, 0)
        distText.BackgroundTransparency = 1
        distText.TextColor3 = Color3.fromRGB(255, 255, 255)
        distText.Text = "D: " .. math.floor((p.Character.PrimaryPart.Position - p.Character.PrimaryPart.Position).Magnitude) .. " m"

        local nameLabel = Instance.new("BillboardGui", hrp)
        nameLabel.Size = UDim2.new(0, 200, 0, 50)
        nameLabel.StudsOffset = Vector3.new(0, 3, 0)
        nameLabel.AlwaysOnTop = true
        local nameText = Instance.new("TextLabel", nameLabel)
        nameText.Size = UDim2.new(1, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.TextColor3 = Color3.fromRGB(0, 255, 0)
        nameText.Text = p.Name

        espObjects[p.Name .. "Label"] = { distLabel, nameLabel }
    end
end

local function drawLine(p)
    if not espEnabled or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    if not lines[p.Name] then
        local line = Drawing.new("Line")
        lines[p.Name] = line
    end
    local line = lines[p.Name]
    line.Visible = true
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    line.To = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        for _, v in pairs(obj) do
            v:Destroy()
        end
    end
    for _, line in pairs(lines) do
        line.Visible = false
    end
    espObjects = {}
end

local function resetESP()
    clearESP()
    espEnabled = false
end

-- Toggle ESP
toggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        if trackLoop == nil then
            trackLoop = game:GetService("RunService").RenderStepped:Connect(function()
                for _, player in pairs(players:GetPlayers()) do
                    if player ~= p then
                        createBox(player)
                        drawLine(player)
                    end
                end
            end)
        end
    else
        clearESP()
    end
end)

-- Reset ESP
resetBtn.MouseButton1Click:Connect(function()
    resetESP()
end)

-- Hide/Show UI
hideBtn.MouseButton1Click:Connect(function()
    uiEnabled = not uiEnabled
    ui.Enabled = uiEnabled
end)

-- Player connection logic
players.PlayerAdded:Connect(function(player)
    print("New player: " .. player.Name)
    upstatus()

    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " spawned.")
        if espEnabled then
            createBox(player)
        end
    end)
end)

players.PlayerRemoving:Connect(function(player)
    print("Player left: " .. player.Name)
    upstatus()
    clearESP()
end)

function creset(player)
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " reset.")
        createBox(player)
    end)
end

for _, player in pairs(players:GetPlayers()) do
    creset(player)
end

players.PlayerAdded:Connect(creset)
