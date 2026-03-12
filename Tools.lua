local ToolGUI = Instance.new("ScreenGui")
local ScrollingFrame = Instance.new("ScrollingFrame")
local StealTools = Instance.new("TextButton")
local CloneTool = Instance.new("TextButton")
local DropTool = Instance.new("TextButton")
local EquipTool = Instance.new("TextButton")
local SaveTool = Instance.new("TextButton")
local LoadTool = Instance.new("TextButton")
local GrabTool = Instance.new("TextButton")
local UngrabTool = Instance.new("TextButton")
local ToolOrbit = Instance.new("TextButton")
local NoToolScript = Instance.new("TextButton")
local NoTool = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local guiVisible = true

ToolGUI.Name = "Tool GUI"
ToolGUI.Parent = game.CoreGui
ToolGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Parent = ToolGUI
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BackgroundTransparency = 0
ScrollingFrame.Position = UDim2.new(0.0809101239, 0, 0.203790441, 0)
ScrollingFrame.Size = UDim2.new(0, 150, 0, 450)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ScrollingFrame.Active = true
ScrollingFrame.Draggable = true

local grabActive = false
local grabConnection = nil

CloseButton.Name = "CloseButton"
CloseButton.Parent = ToolGUI
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(0.01, 0, 0.05, 0)
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.TextSize = 14.000
CloseButton.TextWrapped = true
CloseButton.Draggable = true
CloseButton.BackgroundTransparency = 0.3
CloseButton.Active = true

CloseButton.MouseButton1Down:Connect(function()
    ToolGUI:Destroy()
end)

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToolGUI
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Position = UDim2.new(0.01, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.TextSize = 14.000
ToggleButton.TextWrapped = true
ToggleButton.Draggable = true
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Active = true

local function toggleGUI()
    guiVisible = not guiVisible
    ScrollingFrame.Visible = guiVisible
    
    if guiVisible then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ToggleButton.Text = "⚡"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        ToggleButton.Text = "⏺"
    end
end

ToggleButton.MouseButton1Down:Connect(toggleGUI)

StealTools.Name = "StealTools"
StealTools.Parent = ScrollingFrame
StealTools.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StealTools.Position = UDim2.new(0.0597826242, 0, 0.02, 0)
StealTools.Size = UDim2.new(0, 130, 0, 30)
StealTools.Font = Enum.Font.SourceSans
StealTools.Text = "Steal Tool"
StealTools.TextColor3 = Color3.fromRGB(0, 0, 0)
StealTools.TextScaled = true
StealTools.TextSize = 14.000
StealTools.TextWrapped = true
StealTools.MouseButton1Down:Connect(function()
    local player = game.Players.LocalPlayer
    local MAX_DISTANCE = math.huge
    
    local function stealTool(player, tool)
        if not player.Character or not tool or not tool:IsA("Tool") then
            return false
        end
        
        local character = player.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then
            return false
        end
        
        local toolPosition = tool:FindFirstChild("Handle")
        if toolPosition and MAX_DISTANCE then
            local distance = (rootPart.Position - toolPosition.Position).Magnitude
            if distance > MAX_DISTANCE then
                return false
            end
        end
        
        local success, errorMsg = pcall(function()
            firetouchinterest(rootPart, tool.Handle, 0)
            task.wait(0.1)
            firetouchinterest(rootPart, tool.Handle, 1)
        end)
        
        if success then
            return true
        else
            if player.Character then
                local oldParent = tool.Parent
                tool.Parent = player.Character
                task.wait(0.1)
                if player.Backpack then
                    tool.Parent = player.Backpack
                    return true
                else
                    tool.Parent = oldParent
                    return false
                end
            end
        end
    end
    
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool.Parent == workspace then
            local available = true
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer.Character and tool:IsDescendantOf(otherPlayer.Character) then
                    available = false
                    break
                end
                if otherPlayer.Backpack and tool:IsDescendantOf(otherPlayer.Backpack) then
                    available = false
                    break
                end
            end
            
            if available then
                task.wait(math.random(1, 3) * 0.1)
                stealTool(player, tool)
            end
        end
    end
end)

CloneTool.Name = "CloneTool"
CloneTool.Parent = ScrollingFrame
CloneTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloneTool.Position = UDim2.new(0.0597826242, 0, 0.09, 0)
CloneTool.Size = UDim2.new(0, 130, 0, 30)
CloneTool.Font = Enum.Font.SourceSans
CloneTool.Text = "Clone Tool"
CloneTool.TextColor3 = Color3.fromRGB(0, 0, 0)
CloneTool.TextScaled = true
CloneTool.TextSize = 14.000
CloneTool.TextWrapped = true
CloneTool.MouseButton1Down:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local toolClone = tool:Clone()
                toolClone.Parent = workspace
                toolClone.Handle.Position = character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                break
            end
        end
    end
end)

DropTool.Name = "DropTool"
DropTool.Parent = ScrollingFrame
DropTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DropTool.Position = UDim2.new(0.0597826242, 0, 0.16, 0)
DropTool.Size = UDim2.new(0, 130, 0, 30)
DropTool.Font = Enum.Font.SourceSans
DropTool.Text = "Drop Tool"
DropTool.TextColor3 = Color3.fromRGB(0, 0, 0)
DropTool.TextScaled = true
DropTool.TextSize = 14.000
DropTool.TextWrapped = true
DropTool.MouseButton1Down:Connect(function()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = game.Workspace
    end
end)

EquipTool.Name = "EquipTool"
EquipTool.Parent = ScrollingFrame
EquipTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
EquipTool.Position = UDim2.new(0.0597826242, 0, 0.23, 0)
EquipTool.Size = UDim2.new(0, 130, 0, 30)
EquipTool.Font = Enum.Font.SourceSans
EquipTool.Text = "Equip Tool"
EquipTool.TextColor3 = Color3.fromRGB(0, 0, 0)
EquipTool.TextScaled = true
EquipTool.TextSize = 14.000
EquipTool.TextWrapped = true
EquipTool.MouseButton1Down:Connect(function()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = game.Players.LocalPlayer.Character
    end
end)

SaveTool.Name = "SaveTool"
SaveTool.Parent = ScrollingFrame
SaveTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SaveTool.Position = UDim2.new(0.0597826242, 0, 0.30, 0)
SaveTool.Size = UDim2.new(0, 130, 0, 30)
SaveTool.Font = Enum.Font.SourceSans
SaveTool.Text = "Save Tool"
SaveTool.TextColor3 = Color3.fromRGB(0, 0, 0)
SaveTool.TextScaled = true
SaveTool.TextSize = 14.000
SaveTool.TextWrapped = true
SaveTool.MouseButton1Down:Connect(function()
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if (v:IsA("Tool")) then
            v.Parent = game.Players.LocalPlayer
        end
    end
end)

LoadTool.Name = "LoadTool"
LoadTool.Parent = ScrollingFrame
LoadTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LoadTool.Position = UDim2.new(0.0597826242, 0, 0.37, 0)
LoadTool.Size = UDim2.new(0, 130, 0, 30)
LoadTool.Font = Enum.Font.SourceSans
LoadTool.Text = "Load Tool"
LoadTool.TextColor3 = Color3.fromRGB(0, 0, 0)
LoadTool.TextScaled = true
LoadTool.TextSize = 14.000
LoadTool.TextWrapped = true
LoadTool.MouseButton1Down:Connect(function()
    for _,v in pairs(game.Players.LocalPlayer:GetChildren()) do
        if (v:IsA("Tool")) then
            v.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end)

GrabTool.Name = "GrabTool"
GrabTool.Parent = ScrollingFrame
GrabTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GrabTool.Position = UDim2.new(0.0597826242, 0, 0.44, 0)
GrabTool.Size = UDim2.new(0, 130, 0, 30)
GrabTool.Font = Enum.Font.SourceSans
GrabTool.Text = "Grab Tool"
GrabTool.TextColor3 = Color3.fromRGB(0, 0, 0)
GrabTool.TextScaled = true
GrabTool.TextSize = 14.000
GrabTool.TextWrapped = true
GrabTool.MouseButton1Down:Connect(function()
    local Character = game.Players.LocalPlayer.Character
    
    if grabConnection then
        grabConnection:Disconnect()
    end
    grabActive = true
    grabConnection = workspace.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            wait(0.1)
            child.Parent = Character
        end
    end)
end)

UngrabTool.Name = "UngrabTool"
UngrabTool.Parent = ScrollingFrame
UngrabTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
UngrabTool.Position = UDim2.new(0.0597826242, 0, 0.51, 0)
UngrabTool.Size = UDim2.new(0, 130, 0, 30)
UngrabTool.Font = Enum.Font.SourceSans
UngrabTool.Text = "Ungrab Tool"
UngrabTool.TextColor3 = Color3.fromRGB(0, 0, 0)
UngrabTool.TextScaled = true
UngrabTool.TextSize = 14.000
UngrabTool.TextWrapped = true
UngrabTool.MouseButton1Down:Connect(function()
    if grabConnection then
        grabConnection:Disconnect()
        grabConnection = nil
    end
    grabActive = false
    
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = game.Players.LocalPlayer.Character
    end
end)

ToolOrbit.Name = "ToolOrbit"
ToolOrbit.Parent = ScrollingFrame
ToolOrbit.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToolOrbit.Position = UDim2.new(0.0597826242, 0, 0.58, 0)
ToolOrbit.Size = UDim2.new(0, 130, 0, 30)
ToolOrbit.Font = Enum.Font.SourceSans
ToolOrbit.Text = "Tool Orbit"
ToolOrbit.TextColor3 = Color3.fromRGB(0, 0, 0)
ToolOrbit.TextScaled = true
ToolOrbit.TextSize = 14.000
ToolOrbit.TextWrapped = true
ToolOrbit.MouseButton1Down:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Gazer-Ha/Tool-orbit/refs/heads/main/Source'))()
end)

NoToolScript.Name = "NoToolScript"
NoToolScript.Parent = ScrollingFrame
NoToolScript.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
NoToolScript.Position = UDim2.new(0.0597826242, 0, 0.65, 0)
NoToolScript.Size = UDim2.new(0, 130, 0, 30)
NoToolScript.Font = Enum.Font.SourceSans
NoToolScript.Text = "No Tool Script"
NoToolScript.TextColor3 = Color3.fromRGB(0, 0, 0)
NoToolScript.TextScaled = true
NoToolScript.TextSize = 14.000
NoToolScript.TextWrapped = true
NoToolScript.MouseButton1Down:Connect(function()
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    local backpack = localPlayer.Backpack
    
    if character then
        for _, obj in pairs(character:GetChildren()) do
            if obj:IsA("Tool") then
                for _, toolObj in pairs(obj:GetChildren()) do
                    if toolObj:IsA("Script") or toolObj:IsA("LocalScript") or toolObj:IsA("ModuleScript") then
                        toolObj:Destroy()
                    end
                end
            end
        end
    end
    
    for _, obj in pairs(backpack:GetChildren()) do
        if obj:IsA("Tool") then
            for _, toolObj in pairs(obj:GetChildren()) do
                if toolObj:IsA("Script") or toolObj:IsA("LocalScript") or toolObj:IsA("ModuleScript") then
                    toolObj:Destroy()
                end
            end
        end
    end
end)

NoTool.Name = "NoTool"
NoTool.Parent = ScrollingFrame
NoTool.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
NoTool.Position = UDim2.new(0.0597826242, 0, 0.72, 0)
NoTool.Size = UDim2.new(0, 130, 0, 30)
NoTool.Font = Enum.Font.SourceSans
NoTool.Text = "No Tool"
NoTool.TextColor3 = Color3.fromRGB(0, 0, 0)
NoTool.TextScaled = true
NoTool.TextSize = 14.000
NoTool.TextWrapped = true
NoTool.MouseButton1Down:Connect(function()
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end
    
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool:Destroy()
        end
    end
end)
