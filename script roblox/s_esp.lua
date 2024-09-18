local p = game.Players.LocalPlayer
local c = p.Character
local h = c and c:FindFirstChildWhichIsA("Humanoid")
local uiEnabled = false
local espOn = false
local gui = Instance.new("ScreenGui", p.PlayerGui)
local buttonsFrame = Instance.new("Frame", gui)
local hideButton = Instance.new("TextButton", gui)
local showButton = Instance.new("TextButton", gui)
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local espObjects = {}

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ENHANCED DEMO | 15.09.2024",
    Text = "By XIE",
    Icon = "rbxthumb://type=Asset&id=139089428167914&w=150&h=150"
})

gui.Name = "ESP_GUI"
buttonsFrame.Size = UDim2.new(0, 300, 0, 150)
buttonsFrame.Position = UDim2.new(0, 50, 0, 50)
buttonsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
buttonsFrame.Visible = true

hideButton.Text = "Hide"
hideButton.Size = UDim2.new(0, 80, 0, 30)
hideButton.Position = UDim2.new(0, 220, 0, 0)
hideButton.Parent = buttonsFrame
hideButton.MouseButton1Click:Connect(function()
    buttonsFrame.Visible = false
    showButton.Visible = true
end)

showButton.Text = "Show"
showButton.Size = UDim2.new(0, 80, 0, 30)
showButton.Position = UDim2.new(0, 50, 0, 50)
showButton.Visible = false
showButton.MouseButton1Click:Connect(function()
    buttonsFrame.Visible = true
    showButton.Visible = false
end)

local onOffButton = Instance.new("TextButton", buttonsFrame)
onOffButton.Text = "ESP: OFF"
onOffButton.Size = UDim2.new(0, 120, 0, 30)
onOffButton.Position = UDim2.new(0, 20, 0, 50)

local resetButton = Instance.new("TextButton", buttonsFrame)
resetButton.Text = "Reset"
resetButton.Size = UDim2.new(0, 120, 0, 30)
resetButton.Position = UDim2.new(0, 160, 0, 50)

local function clearESP()
    for _, espData in pairs(espObjects) do
        if espData.box then espData.box:Destroy() end
        if espData.distLabel then espData.distLabel:Destroy() end
        if espData.nameLabel then espData.nameLabel:Destroy() end
        if espData.line then espData.line:Remove() end
    end
    espObjects = {}
end

local function createLine(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = p.Character.HumanoidRootPart
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 0, 0)

        espObjects[p] = espObjects[p] or {}
        espObjects[p].line = line

        runService.RenderStepped:Connect(function()
            if espOn and hrp and p.Character then
                local camPos = workspace.CurrentCamera.CFrame.Position
                line.From = Vector2.new(workspace.CurrentCamera:WorldToViewportPoint(camPos).X, workspace.CurrentCamera:WorldToViewportPoint(camPos).Y)
                line.To = Vector2.new(workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).X, workspace.CurrentCamera:WorldToViewportPoint(hrp.Position).Y)
                line.Visible = true
            else
                line.Visible = false
            end
        end)
    end
end

local function createESP(p)
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

        runService.RenderStepped:Connect(function()
            if p.Character and p.Character.PrimaryPart then
                distText.Text = "Dist: " .. math.floor((p.Character.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude) .. "m"
            end
        end)

        local nameLabel = Instance.new("BillboardGui", hrp)
        nameLabel.Size = UDim2.new(0, 200, 0, 50)
        nameLabel.StudsOffset = Vector3.new(0, 3, 0)
        nameLabel.AlwaysOnTop = true

        local nameText = Instance.new("TextLabel", nameLabel)
        nameText.Size = UDim2.new(1, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.TextColor3 = Color3.fromRGB(0, 255, 0)

        runService.RenderStepped:Connect(function()
            if p and p.DisplayName and p.Name then
                nameText.Text = p.Name .. " | " .. p.DisplayName
            end
        end)

        espObjects[p] = espObjects[p] or {}
        espObjects[p].box = box
        espObjects[p].distLabel = distLabel
        espObjects[p].nameLabel = nameLabel

        createLine(p)
    end
end

onOffButton.MouseButton1Click:Connect(function()
    espOn = not espOn
    onOffButton.Text = espOn and "ESP: ON" or "ESP: OFF"
    if not espOn then
        clearESP()
    else
        for _, player in pairs(players:GetPlayers()) do
            if player ~= p and player.Character then
                createESP(player)
            end
        end
    end
end)

resetButton.MouseButton1Click:Connect(function()
    clearESP()
    onOffButton.Text = "ESP: OFF"
    espOn = false
end)

players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espOn then
            createESP(player)
        end
    end)
end)

for _, player in pairs(players:GetPlayers()) do
    if player ~= p then
        player.CharacterAdded:Connect(function()
            if espOn then
                createESP(player)
            end
        end)
        if player.Character then
            createESP(player)
        end
    end
end
