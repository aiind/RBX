--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local tool
for _,v in pairs(player:GetDescendants()) do
	if v.Name == "SyncAPI" then
		tool = v.Parent
		break
	end
end

if not tool then
	for _,v in pairs(ReplicatedStorage:GetDescendants()) do
		if v.Name == "SyncAPI" then
			tool = v.Parent
			break
		end
	end
end

if not tool or not tool:FindFirstChild("SyncAPI") then
	error("SyncAPI not found")
end

local remote = tool.SyncAPI.ServerEndpoint

local function invoke(cmd, data)
	pcall(function()
		remote:InvokeServer(cmd, data)
	end)
end

local function createPart(cf)
	return remote:InvokeServer("CreatePart", "Normal", cf, workspace)
end

local function setup(part, size, color, material, trans)
	invoke("SyncResize", {{ Part = part, CFrame = part.CFrame, Size = size }})
	invoke("SyncColor", {{ Part = part, Color = color, UnionColoring = true }})
	invoke("SyncMaterial", {{ Part = part, Material = material, Transparency = trans }})
	invoke("SyncCollision", {{ Part = part, CanCollide = false }})
	invoke("SyncAnchor", {{ Part = part, Anchored = true }})
end

local function mesh(part, meshId, scale)
	invoke("CreateMeshes", {{ Part = part }})
	invoke("SyncMesh", {{
		Part = part,
		MeshId = meshId,
		TextureId = "",
		Scale = scale
	}})
end

local startCF = CFrame.new(root.Position - Vector3.new(0, 60, 0))

local outer = createPart(startCF)
local inner = createPart(startCF)

setup(outer, Vector3.new(0.06,0.06,0.06), Color3.fromRGB(0,170,255), Enum.Material.Plastic, 0.5)
setup(inner, Vector3.new(1,1,1), Color3.new(1,1,1), Enum.Material.Neon, 0)

mesh(outer, "rbxassetid://9274044128", Vector3.new(0.06,0.06,0.06))
mesh(inner, "rbxassetid://12800536037", Vector3.new(1,1,1))

local textPart = Instance.new("Part")
textPart.Size = Vector3.new(1,1,1)
textPart.Transparency = 1
textPart.Anchored = true
textPart.CanCollide = false
textPart.Parent = workspace

local billboard = Instance.new("BillboardGui")
billboard.Size = UDim2.new(0, 260, 0, 40)
billboard.StudsOffset = Vector3.new(0, 3, 0)
billboard.AlwaysOnTop = true
billboard.Parent = textPart

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.Text = "You an admin! Level: 4"
label.Font = Enum.Font.Arial
label.TextSize = 20
label.TextColor3 = Color3.fromRGB(22, 96, 148)
label.TextStrokeTransparency = 0
label.Parent = billboard

local clickProxy = Instance.new("Part")
clickProxy.Size = Vector3.new(2,2,2)
clickProxy.Transparency = 1
clickProxy.Anchored = true
clickProxy.CanCollide = false
clickProxy.Parent = workspace

local click = Instance.new("ClickDetector")
click.MaxActivationDistance = 32
click.Parent = clickProxy

local RADIUS = 5
local HEIGHT = 2
local SPEED = 0.4
local SMOOTH = 0.25

local angle = 0
local orbiting = true
local lastCF = startCF
local orbitConn

local function deleteBlock()
	if not orbiting then return end
	orbiting = false

	if orbitConn then
		orbitConn:Disconnect()
	end

	task.wait()

	invoke("Remove", { outer })
	invoke("Remove", { inner })

	clickProxy:Destroy()
	textPart:Destroy()
end

click.MouseClick:Connect(deleteBlock)

orbitConn = RunService.Heartbeat:Connect(function(dt)
	if not orbiting then return end

	angle += SPEED * dt

	local pos = root.Position + Vector3.new(
		math.cos(angle) * RADIUS,
		HEIGHT,
		math.sin(angle) * RADIUS
	)

	local cf = CFrame.new(pos) * CFrame.Angles(angle*0.5, angle*0.5, angle*0.5)
	lastCF = lastCF:Lerp(cf, SMOOTH)

	invoke("SyncResize", {{ Part = outer, CFrame = lastCF, Size = Vector3.new(0.06,0.06,0.06) }})
	invoke("SyncResize", {{ Part = inner, CFrame = lastCF, Size = Vector3.new(1,1,1) }})

	clickProxy.CFrame = lastCF
	textPart.CFrame = lastCF
end)


local gui = Instance.new("ScreenGui")
gui.Name = "mr Bean admin update"
gui.Parent = game.CoreGui

local Frame_160579 = Instance.new("Frame")
Frame_160579.Name = "Frame"
Frame_160579.Parent = gui
Frame_160579.BackgroundColor3 = Color3.new(0, 0, 0)
Frame_160579.Position = UDim2.new(0.20000000298023224, 63, 0.20000000298023224, -29)
Frame_160579.Size = UDim2.new(0, 500, 0, 300)
Frame_160579.Visible = true
Frame_160579.BackgroundTransparency = 0.5
Frame_160579.BorderColor3 = Color3.fromRGB(1, 1, 1)
Frame_160579.BorderSizePixel = 3

local UIDragdetector = Instance.new("UIDragDetector")
UIDragdetector.Parent = Frame_160579

local ScrollingFrame_154627 = Instance.new("ScrollingFrame")
ScrollingFrame_154627.Name = "ScrollingFrame"
ScrollingFrame_154627.Parent = Frame_160579
ScrollingFrame_154627.BackgroundColor3 = Color3.new(0.1568627506494522, 0.1568627506494522, 0.1568627506494522)
ScrollingFrame_154627.Position = UDim2.new(0, 0, 0.14000000059604645, -4)
ScrollingFrame_154627.Size = UDim2.new(0.9300000071525574, 37, 0.7699999809265137, 35)
ScrollingFrame_154627.BorderSizePixel = 0
ScrollingFrame_154627.BackgroundTransparency = 0.5
ScrollingFrame_154627.Visible = true


local TextLabel_288272 = Instance.new("TextLabel")
TextLabel_288272.Name = "TextLabel"
TextLabel_288272.Parent = ScrollingFrame_154627
TextLabel_288272.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_288272.Position = UDim2.new(0, 0, 0, 30)
TextLabel_288272.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_288272.Visible = true
TextLabel_288272.Text = "AK47 [PLAYER] - gives you ak47 [MOD]"
TextLabel_288272.TextScaled = true
TextLabel_288272.BackgroundTransparency = 1
TextLabel_288272.BorderSizePixel = 0
TextLabel_288272.Font = Enum.Font.SourceSansSemibold
TextLabel_288272.TextColor3 = Color3.new(255, 255, 255)
TextLabel_288272.TextSize = 16
TextLabel_288272.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel_263877 = Instance.new("TextLabel")
TextLabel_263877.Name = "TextLabel"
TextLabel_263877.Parent = ScrollingFrame_154627
TextLabel_263877.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_263877.Position = UDim2.new(0, 0, 0, 9)
TextLabel_263877.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_263877.Visible = true
TextLabel_263877.Text = "THOMAS THE TRAIN [PLAYER] - makes you Thomas train [MOD]"
TextLabel_263877.Font = Enum.Font.SourceSansSemibold
TextLabel_263877.TextColor3 = Color3.new(255, 255, 255)
TextLabel_263877.TextSize = 16
TextLabel_263877.TextScaled = true
TextLabel_263877.BorderSizePixel = 0
TextLabel_263877.BackgroundTransparency = 1
TextLabel_263877.TextXAlignment = Enum.TextXAlignment.Left


local TextLabel_660843 = Instance.new("TextLabel")
TextLabel_660843.Name = "TextLabel"
TextLabel_660843.Parent = ScrollingFrame_154627
TextLabel_660843.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_660843.Position = UDim2.new(0, 0, 0, 50)
TextLabel_660843.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_660843.Visible = true
TextLabel_660843.Text = "JohnDoe [PLAYER] - makes you John doe [MOD]"
TextLabel_660843.Font = Enum.Font.SourceSansSemibold
TextLabel_660843.TextColor3 = Color3.new(255, 255, 255)
TextLabel_660843.TextSize = 16
TextLabel_660843.TextScaled = true
TextLabel_660843.BorderSizePixel = 0
TextLabel_660843.BackgroundTransparency = 1
TextLabel_660843.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel_270677 = Instance.new("TextLabel")
TextLabel_270677.Name = "TextLabel"
TextLabel_270677.Parent = ScrollingFrame_154627
TextLabel_270677.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_270677.Position = UDim2.new(0, 0, 0, 70)
TextLabel_270677.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_270677.Visible = true
TextLabel_270677.Text = "Duck [PLAYER] - makes you duck/everyone duck [MOD]"
TextLabel_270677.Font = Enum.Font.SourceSansSemibold
TextLabel_270677.TextColor3 = Color3.new(255, 255, 255)
TextLabel_270677.TextSize = 16
TextLabel_270677.BackgroundTransparency = 1
TextLabel_270677.TextScaled = true
TextLabel_270677.BorderSizePixel = 0
TextLabel_270677.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel_872176 = Instance.new("TextLabel")
TextLabel_872176.Name = "TextLabel"
TextLabel_872176.Parent = ScrollingFrame_154627
TextLabel_872176.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_872176.Position = UDim2.new(0, 0, 0, 90)
TextLabel_872176.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_872176.Visible = true
TextLabel_872176.Text = "KFC [PLAYER] - changes map to kfc [MOD]"
TextLabel_872176.Font = Enum.Font.SourceSansSemibold
TextLabel_872176.TextColor3 = Color3.new(255, 255, 255)
TextLabel_872176.TextSize = 16
TextLabel_872176.TextScaled = true
TextLabel_872176.BackgroundTransparency = 1
TextLabel_872176.BorderSizePixel = 0
TextLabel_872176.TextXAlignment = Enum.TextXAlignment.Left




local TextLabel_717723 = Instance.new("TextLabel")
TextLabel_717723.Name = "TextLabel"
TextLabel_717723.Parent = ScrollingFrame_154627
TextLabel_717723.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_717723.Position = UDim2.new(0, 0, 0, 110)
TextLabel_717723.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_717723.TextScaled = true
TextLabel_717723.Visible = true
TextLabel_717723.Text = "GRAB KNIFE V4 [PLAYER] - gives u grab knife V4  [MOD]"
TextLabel_717723.Font = Enum.Font.SourceSansSemibold
TextLabel_717723.TextColor3 = Color3.new(255, 255, 255)
TextLabel_717723.TextSize = 16
TextLabel_717723.BackgroundTransparency = 1
TextLabel_717723.BorderSizePixel = 0
TextLabel_717723.TextXAlignment = Enum.TextXAlignment.Left



local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 130)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "RAIN TACOS [PLAYER] - makes it rain tacos  [MOD]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 150)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "ServerMessage [TEXT] - makes a message for all players [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 170)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Gear [PLAYER] [ID] - gives player a specific gear [MOD]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 190)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "R6 [PLAYER] - Changes player character from r15 to r6 [MOD]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 210)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "F3X [PLAYER] - Gives player a F3X Btools. [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 230)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "SWORD [PLAYER] - Gives player a Sword. [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 250)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Countdown [NUMBER] - Makes countdown for everyone [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 270)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Kill [PLAYER] - Kills selected player. [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 290)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Kick [PLAYER] - Kicks selected player. [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 310)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "c00lgui [PLAYER] - gives you c00lgui [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 330)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "refresh [PLAYER] - refreshes player [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 350)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "R15 [PLAYER] - changes character from r6 to r15 [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 370)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "PoliceCar [PLAYER] - spawns police car [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 390)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "music [ID] - plays the sound you typed [ADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 410)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "StarMan [Player] - Make Player Turn Into Star Man [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 430)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "DevUzi [Player] - Give you a uzi gun [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 450)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Dex [Player] - Give you a Dex Explorer [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 470)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Rc7 [Player] - Give You Rc7 Executor [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 490)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Rc7Cloud [Player] - Make a gold cloud with a Rc7 Rain [SUPERADMIN]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left
local TextLabel_357711 = Instance.new("TextLabel")
TextLabel_357711.Name = "TextLabel"
TextLabel_357711.Parent = ScrollingFrame_154627
TextLabel_357711.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_357711.Position = UDim2.new(0, 0, 0, 510)
TextLabel_357711.Size = UDim2.new(0.8999999761581421, 0, 0, 19)
TextLabel_357711.Visible = true
TextLabel_357711.Text = "Fire [Player] - Spawn a Fire at Body [MOD]"
TextLabel_357711.TextScaled = true
TextLabel_357711.Font = Enum.Font.SourceSansSemibold
TextLabel_357711.TextColor3 = Color3.new(255, 255, 255)
TextLabel_357711.TextSize = 16
TextLabel_357711.BackgroundTransparency = 1
TextLabel_357711.BorderSizePixel = 0
TextLabel_357711.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel_111421 = Instance.new("TextLabel")
TextLabel_111421.Name = "TextLabel"
TextLabel_111421.Parent = Frame_160579
TextLabel_111421.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel_111421.Position = UDim2.new(-0.03999999910593033, 20, 0, 0)
TextLabel_111421.Size = UDim2.new(1, 0, 0.10000000149011612, 2)
TextLabel_111421.Visible = true
TextLabel_111421.Text = "Commands"
TextLabel_111421.Font = Enum.Font.SourceSansSemibold
TextLabel_111421.TextColor3 = Color3.new(255, 255, 255)
TextLabel_111421.TextSize = 15
TextLabel_111421.TextScaled = true
TextLabel_111421.BorderSizePixel = 0
TextLabel_111421.BackgroundTransparency = 1
local TextButton_950997 = Instance.new("TextButton")
TextButton_950997.Name = "TextButton"
TextButton_950997.Parent = Frame_160579
TextButton_950997.BackgroundColor3 = Color3.new(0, 0, 0)
TextButton_950997.Position = UDim2.new(0.800000011920929, 38, 0, -2)
TextButton_950997.Size = UDim2.new(0.10000000149011612, 0, 0.10000000149011612, 5)
TextButton_950997.Visible = true
TextButton_950997.Text = "X"
TextButton_950997.BorderSizePixel = 0
TextButton_950997.BackgroundTransparency = 1
TextButton_950997.Font = Enum.Font.SourceSansSemibold
TextButton_950997.TextColor3 = Color3.new(255, 0, 0)
TextButton_950997.TextSize = 30
TextButton_950997.MouseButton1Click:Connect(function()
Frame_160579.Visible = false
end)

local command = Instance.new("TextBox")

local mr = Instance.new("ImageButton")
mr.Size = UDim2.new(0.0, 75, 0.0, 75)
mr.Position = UDim2.new(1, -91, 1, -91)
mr.BackgroundColor3 = Color3.new(0, 0, 0)
mr.ImageColor3 = Color3.new(1, 1, 1)
mr.Image = "rbxassetid://123852508876370"
mr.ImageTransparency = 0
mr.Parent = gui
mr.Name = "Wheel"
mr.BackgroundTransparency = 1
prefix = [[

Welcome to Mr.Bean Admin Use the Program to execute scripts Status Enabled! type cmds in textbox to see commands.
]]
local debug = Instance.new("TextLabel")
debug.Size = UDim2.new(6, 4, 1, 0)
debug.Position = UDim2.new(-2.5, 0, -3.5, 0)
debug.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
debug.BackgroundTransparency = 1
debug.Rotation = 450
debug.Parent = mr
debug.BorderSizePixel = 10
debug.TextColor3 = Color3.fromRGB(255, 255, 0)
debug.Text = prefix
debug.TextScaled = true
debug.TextTransparency = 1
debug.TextSize = 20
---2.5, 0, 0, -280

mr.MouseButton1Click:Connect(function() 
if mr.Image == "rbxassetid://123852508876370" then
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(mr, tweenInfo, {Rotation = -90})
		tween:Play()
mr.Image = "rbxassetid://5025639356"

		local tween = TweenService:Create(debug, tweenInfo, {BackgroundTransparency = 0.25})
		tween:Play()

local tween = TweenService:Create(debug, tweenInfo, {TextTransparency = 0})
		tween:Play()

elseif mr.Image == "rbxassetid://5025639356" then
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(mr, tweenInfo, {Rotation = 0})
		tween:Play()

mr.Image = "rbxassetid://123852508876370"
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(debug, tweenInfo, {BackgroundTransparency = 1})
		tween:Play()

local tween = TweenService:Create(debug, tweenInfo, {TextTransparency = 1})
		tween:Play()
  end
end)




command.Size = UDim2.new(0.9, 99, 0.0, 20)
command.Position = UDim2.new(0.0, 0, 0.0, -46)
command.BackgroundColor3 = Color3.new(0, 0, 0)
command.BorderColor3 = Color3.new(0, 0, 0)
command.BorderSizePixel = 0
command.Text = ":"
command.TextColor3 = Color3.new(1, 1, 1)
command.BackgroundTransparency = 0.5
command.Font = Enum.Font.Code 
command.TextSize = 20
command.Parent = gui
command.ClearTextOnFocus = true
command.TextXAlignment = Enum.TextXAlignment.Left
command.PlaceholderText = ":"

command.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local cmdText = command.Text
        local player = game.Players.LocalPlayer
        local character = player.Character

        if cmdText == ":kill all" or cmdText == "kill all"
then
            RequestCommand:InvokeServer(";kill all")

        elseif cmdText == ":kick me" or cmdText == "kick me" or cmdText == "kick"
then
            player:Kick("Mr bean admin has kicked you...")

        elseif cmdText == ":JohnDoe me" or cmdText == "john" or cmdText == "john doe"
then
            local player = game.Players.LocalPlayer
    local char = player.Character
    local tool
    for i,v in player:GetDescendants() do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end
    for i,v in game.ReplicatedStorage:GetDescendants() do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end
   
    remote = tool.SyncAPI.ServerEndpoint
    function _(args)
        remote:InvokeServer(unpack(args))
    end


local function Color(part, color)
	local args = {
		"SyncColor",
		{
			{
				Part = part,
				Color = color,
				UnionColoring = false
			}
		}
	}
	_(args)
end

local function applyDecorationToPart(part) 
    
    local argsCreate = {
        [1] = "CreateDecorations",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Fire"
            }
        }
    }

   
    local argsSync = {
        [1] = "SyncDecorate",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Fire",
                ["Size"] = 3,
                ["Heat"] = 25,
                ["Color"] = Color3.fromRGB(255, 0, 0), 
                ["SecondaryColor"] = Color3.fromRGB(255, 0, 0) 
            } 
        } 
    }

    
    _(argsCreate)
    _(argsSync)
end

local function Parter(part) 
    
    local argsCreate = {
        [1] = "CreateDecorations",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Smoke"
            }
        }
    }

   
    local argsSync = {
        [1] = "SyncDecorate",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Smoke",
                ["Size"] = 3,
                ["Color"] = Color3.fromRGB(255, 0, 0),  
            } 
        } 
    }

    
    _(argsCreate)
    _(argsSync)
end
local function eyePart(part) 
    
    local argsCreate = {
        [1] = "CreateDecorations",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Fire"
            }
        }
    }

   
    local argsSync = {
        [1] = "SyncDecorate",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Fire",
                ["Size"] = 1,
                ["Heat"] = 12,
                ["Color"] = Color3.fromRGB(155, 0, 0), 
                ["SecondaryColor"] = Color3.fromRGB(255, 0, 0) 
            } 
        } 
    }

    
    _(argsCreate)
    _(argsSync)
end



local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")

local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandModification




local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

    
RequestCommand:InvokeServer(";removeaccessories")
RequestCommand:InvokeServer(";titlebk me John Doe")

wait(1)
RequestCommand:InvokeServer(";hat me 107676946962151")
wait(0.5)
RequestCommand:InvokeServer(";hat me 18196403126")
wait(0.5)
RequestCommand:InvokeServer(";hat me 18801497637")
wait(0.5)
 RequestCommand:InvokeServer(";shirt me 100276101149100")
 RequestCommand:InvokeServer(";pants me 109662040845019")
RequestCommand:InvokeServer(";head me 0")
RequestCommand:InvokeServer(";face me 144075659")


wait(1)

local eye = char:FindFirstChild("Accessory (JohnEye)").Handle
local arm = char:FindFirstChild("Right Arm")
local tor = char:FindFirstChild("Torso")
local ar2 = char:FindFirstChild("Left Arm")

local RLeg = char:FindFirstChild("Right Leg")
local head = char:FindFirstChild("Head")
local LLeg = char:FindFirstChild("Left Leg")
applyDecorationToPart(arm)
applyDecorationToPart(ar2)
eyePart(eye)
Parter(tor)

Color(arm, Color3.fromRGB(252, 255, 150))
Color(ar2, Color3.fromRGB(252, 255, 150))
Color(head, Color3.fromRGB(252, 255, 150))
Color(tor, Color3.fromRGB(255, 255, 0))
Color(RLeg, Color3.fromRGB(0, 200, 255))
Color(LLeg, Color3.fromRGB(0, 200, 255))



local arm = character:FindFirstChild("Right Arm") 
local humanoid = character:FindFirstChildOfClass("Humanoid")


local isDead = false

humanoid.Died:Connect(function()
	isDead = true
end)


local animator = humanoid:FindFirstChildOfClass("Animator")

local attackAnim = Instance.new("Animation")
attackAnim.AnimationId = "rbxassetid://186934658"
local attackTrack = animator:LoadAnimation(attackAnim)

function KillTarget(target)
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            local args = {
                [1] = "SetLocked",
                [2] = {
                    [1] = head
                },

                [3] = false
            }
            remote:InvokeServer(unpack(args))
            task.wait(0.1) 
            local args2 = {
                [1] = "Remove",
                [2] = {
                    [1] = head
                }
            }
            remote:InvokeServer(unpack(args2))
        end
    end
end


local function attack()
    attackTrack:Play() 
    local hitPlayer = nil
    local touchedConnection

    local function onTouch(other)
        local otherPlayer = Players:GetPlayerFromCharacter(other.Parent)
        if otherPlayer and otherPlayer ~= player then
            hitPlayer = otherPlayer
        end
    end

    touchedConnection = arm.Touched:Connect(onTouch)
    task.wait(0.5)
    if touchedConnection then
        touchedConnection:Disconnect()
    end
    if hitPlayer then
               RequestCommand:InvokeServer(" ")
  
KillTarget(hitPlayer)
        task.wait(1)
        
    end

end


local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AttackButtonGui"

local attackButton = Instance.new("TextButton")
attackButton.Name = "AttackButton"
attackButton.Parent = screenGui
attackButton.Size = UDim2.new(0, 160, 0, 50)
attackButton.Position = UDim2.new(0.5, -80, 1, -90)
attackButton.AnchorPoint = Vector2.new(0.5, 0)
attackButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
attackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
attackButton.Font = Enum.Font.GothamBold
attackButton.Text = "attack"
attackButton.TextSize = 22
attackButton.AutoButtonColor = true
attackButton.ZIndex = 999


attackButton.MouseButton1Click:Connect(function()
    if not isDead then
        attack()
    end
end)

        elseif cmdText == ":THOMAS THE TRAIN me" or cmdText == "thomas" or cmdText == ":thomas" or cmdText == "thomas" or cmdText == "train"
 then
            loadstring(game:HttpGet("https://gist.github.com/Kotyara19k-Doorsspawner/a2681fd903736f2a875b08f6e7649e4c/raw/ca80888f51a5b794a6d229f2e1e7f13d9cc07280/thomasV2"))()

        elseif cmdText == ":THOMAS THE TRAIN all" or cmdText == "Thomas all" or cmdText == ":Thomas all"
 then
            loadstring(game:HttpGet("https://gist.github.com/Kotyara19k-Doorsspawner/562cde11969b4431de8583ddc5ab1677/raw/c2fe2b299d45d5a77cedb7c3d2f0a3c57eee4e3d/thomas%2520all"))()

        elseif cmdText == ":kick all" or cmdText == "kick all"
 then
            RequestCommand:InvokeServer(";kick all Mr bean admin kicked you.")

        elseif cmdText == ":kill me" or cmdText == "kill"
then
            character.Humanoid.Health = 0

        elseif cmdText == ":PoliceCar" or cmdText == "police"
then
            RequestCommand:InvokeServer(";Insert 6418230807")

        elseif cmdText == ":duck me" or cmdText == "duck" or cmdText == "duck me"
 then
            loadstring(game:HttpGet("https://gist.github.com/Kotyara19k-Doorsspawner/1a9645468431e7ef12a3a0f239771a3b/raw/ac9ce7c2d696e4f385c255b3485374ea8f69db0e/Duck"))()

        elseif cmdText == ":duck all" or cmdText == "duck all" then
            loadstring(game:HttpGet("https://gist.github.com/Kotyara19k-Doorsspawner/3c283ac5f1ff249eb28a575dd7658f71/raw/08ee4f4f77d38a27d5aa86cc4fca3e8c90ec3936/duck%2520all"))()

        elseif cmdText == ":RAIN TACOS" or cmdText == ":rain tacos" or cmdText == ":taco" or cmdText == "taco"
then 
            loadstring(game:HttpGet("https://gist.github.com/Kotyara19k-Doorsspawner/6cbfd32d1cd33a6fde00369eb29715c2/raw/b5f3833bd01fd3b1a60fbded584e05edb28245d0/taco"))()

        elseif cmdText == ":cmds" or cmdText == "cmds"
then
            Frame_160579.Visible = true

        elseif cmdText == ":c00lgui" or cmdText == "c00lgui" or cmdText == ":c00l" or cmdText == "c00l"
then
            loadstring(game:HttpGet("https://files.catbox.moe/ozzg5c.txt"))()

        elseif cmdText == ":sword" or cmdText == ":sword me" or cmdText == "sword"
then
            e(";sword me")

        elseif cmdText == ":sword all" or cmdText == "sword all" then
            e(";sword all")

        elseif cmdText == ":AK47" or cmdText == ":ak47" or cmdText == ":AK47 me" or cmdText == ":ak47 me" or cmdText == "ak47" or cmdText == "ak"
then
            RequestCommand:InvokeServer(";gear me 116693764")

        elseif cmdText == ":f3x" or cmdText == ":btools" or cmdText == "btools" or cmdText == "f3x"
then
            RequestCommand:InvokeServer(";btools")

        elseif cmdText == ":r6" or cmdText == ":r6 me" or cmdText == ":R6 me" or cmdText == ":R6" or cmdText == "r6" then
            RequestCommand:InvokeServer(";R6 me")

        elseif cmdText == ":refresh" or cmdText == ":refresh me" or cmdText == "refresh" then
            e(";refresh me")

        elseif cmdText == ":r15" or cmdText == "r15" then
            e(";r15 me")

         elseif cmdText == ":kfc" or cmdText == ":KFC" or cmdText == "kfc" then
            loadstring(game:HttpGet("https://pastefy.app/AWJkWABQ/raw"))()

          elseif cmdText == ":GRAB KNIFE V4" or cmdText == ":Grab knife" or cmdText == "gk" or cmdText == "knife" or cmdText == "grab knife" then
            loadstring(game:HttpGet("https://files.catbox.moe/grehul.txt"))()

         elseif cmdText == ":StarMan me" or cmdText == ":Starman me" or cmdText == "star man" then

        local char = player.Character or player.CharacterAdded:Wait()

local tool

for i, v in pairs(player:GetDescendants()) do

    if v.Name == "SyncAPI" then

        tool = v.Parent

    end

end

for i, v in pairs(game.ReplicatedStorage:GetDescendants()) do

    if v.Name == "SyncAPI" then

        tool = v.Parent

    end

end

local remote = tool.SyncAPI.ServerEndpoint

function _(args)

    remote:InvokeServer(unpack(args))

end

local RunService = game:GetService("RunService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

character.Humanoid.WalkSpeed='80'

local function light(part,color)

	local createArgs = {		"CreateLights",

		{

			{

				Part = part,

				LightType = "PointLight"

			}

		}

	}

	local syncArgs = {

		"SyncLighting",

		{

			{

				Part = part,

				LightType = "PointLight",

				Color = color,

        Brightness = 8,

				Range = 20,

			}

		}

	}

	_(createArgs)

	_(syncArgs)

end

function SetCollision(part, boolean)

    local args = {

        [1] = "SyncCollision",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["CanCollide"] = boolean

            }

        }

    }

    _(args)

end

function SetAnchor(boolean, part)

    local args = {

        [1] = "SyncAnchor",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Anchored"] = boolean

            }

        }

    }

    _(args)

end

function CreatePart(cf, parent)

    local args = {

        [1] = "CreatePart",

        [2] = "Normal",

        [3] = cf,

        [4] = parent

    }

    _(args)

end

function Resize(part, size, cf)

    local args = {

        [1] = "SyncResize",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["CFrame"] = cf,

                ["Size"] = size

            }

        }

    }

    _(args)

end

function AddMesh(part)

    local args = {

        [1] = "CreateMeshes",

        [2] = {

            [1] = {

                ["Part"] = part

            }

        }

    }

    _(args)

end

function SetMesh(part, meshid)

    local args = {

        [1] = "SyncMesh",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["MeshId"] = "rbxassetid://" .. meshid

            }

        }

    }

    _(args)

end

function DestroyPart(part)

    local args = {

        [1] = "Remove",

        [2] = {

            [1] = part

        }

    }

    remote:InvokeServer(unpack(args))

end

function SetTexture(part, texid)

    local args = {

        [1] = "SyncMesh",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["TextureId"] = "rbxassetid://" .. texid

            }

        }

    }

    _(args)

end

function SetTrans(part,int)

    local args = {

        [1] = "SyncMaterial",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Transparency"] = int

            }

        }

    }

    _(args)

end

function SetMaterial(part,int)

    local args = {

        [1] = "SyncMaterial",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Material"] = int

            }

        }

    }

    _(args)

end

function MeshResize(part, size)

    local args = {

        [1] = "SyncMesh",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Scale"] = size

            }

        }

    }

    _(args)

end

function SpawnDecal(part,side)

    local args = {

        [1] = "CreateTextures",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Face"] = side,

                ["TextureType"] = "Decal"

            }

        }

    }

    _(args)

end

function AddDecal(part,asset,side)

    local args = {

        [1] = "SyncTexture",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Face"] = side,

                ["TextureType"] = "Decal",

                ["Texture"] = "rbxassetid://".. asset

            }

        }

    }

    _(args)

end

function SetName(part, stringg)

    local args = {

        [1] = "SetName",

        [2] = {

            [1] = workspace.Part

        },

        [3] = stringg

    }

    _(args)

end

function Color(part, color3)

    local args = {

        [1] = "SyncColor",

        [2] = {

            [1] = {

                ["Part"] = part,

                ["Color"] = color3

            }

        }

    }

    _(args)

end

audio=Instance.new('Sound',game.Workspace)

audio.SoundId='rbxassetid://182755256'

audio.Volume=3

audio:Play()

spawn(function()

wait(3)

audio:Destroy()

end)

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent

local KILL_RANGE = 10 

local FLING_RANGE = 10 

    local player = game.Players.LocalPlayer

    local char = player.Character

    local tool

for _, v in player:GetDescendants() do

    if v.Name == "SyncAPI" then

        tool = v.Parent

    end

end

for _, v in game.ReplicatedStorage:GetDescendants() do

    if v.Name == "SyncAPI" then

        tool = v.Parent

    end

end

local remote = tool.SyncAPI.ServerEndpoint

function _(args)

    remote:InvokeServer(unpack(args))

end

function KillTarget(target)

    if target and target.Character then

        local head = target.Character:FindFirstChild("Head")

        if head then

            local args = {

                [1] = "SetLocked",

                [2] = { [1] = head },

                [3] = false

            }

            _(args)

            task.wait(0.1)

            local args2 = {

                [1] = "Remove",

                [2] = { [1] = head }

            }

            _(args2)

        end

    end

end

local function checkNearbyPlayers()

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

        return

    end

    

    local myPosition = LocalPlayer.Character.HumanoidRootPart.Position

    

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

            local distance = (player.Character.HumanoidRootPart.Position - myPosition).Magnitude

            

            if distance <= KILL_RANGE then

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent

                RequestCommand:InvokeServer(";fling "..player.Name)

                KillTarget(player)

                audio=Instance.new('Sound',game.Workspace)

audio.SoundId='rbxassetid://138702491'

audio.Volume=3

audio:Play()

spawn(function()

wait(1)

audio:Destroy()

end)

            end

        end

    end

end

spawn(function()

while true do

    local success, err = pcall(checkNearbyPlayers)

    if not success then

        warn("Error in checkNearbyPlayers: "..tostring(err))

    end

    task.wait(0.5)

end

end)

local colorOptions = {

    Color3.fromRGB(255, 0, 255),

    Color3.fromRGB(0, 0, 255),

    Color3.fromRGB(255, 0, 0),

    Color3.fromRGB(0, 255, 0),

    Color3.fromRGB(255, 255, 0)

}

while true do

    local character = player.Character or player.CharacterAdded:Wait()

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

    local arm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")

    local arm2 = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")

    local leg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")

    local leg2 = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

    local head = character:FindFirstChild("Head")

    

    if torso and arm and arm2 and leg and leg2 and head then

        local currentColor = colorOptions[math.random(1, #colorOptions)]

        

        -- Base effects always apply

        spawn(function()

        light(torso, currentColor)

         end)

        spawn(function() Color(arm, currentColor) end)

        spawn(function() Color(arm2, currentColor) end)

        spawn(function() Color(leg, currentColor) end)

        spawn(function() Color(leg2, currentColor) end)

        spawn(function() Color(torso, currentColor) end)

        -- SIMPLE BUT EFFECTIVE MOVEMENT CHECK

        if humanoid and (humanoid.MoveDirection.Magnitude > 0 or torso.AssemblyLinearVelocity.Magnitude > 1) then

            -- Left arm trail (original code)

            spawn(function()

                heh = CFrame.new(0, 0, 0)

                local leftClone = remote:InvokeServer("CreatePart", "Normal", heh, character)

                leftClone.CanCollide = false

                spawn(function() Resize(leftClone, arm2.Size, arm2.CFrame) end)

                spawn(function() Color(leftClone, currentColor) end)

                spawn(function() SetMaterial(leftClone, Enum.Material.Neon) end)

                spawn(function() SetCollision(leftClone, false) end)

                SetTrans(leftClone, 0.3)

                wait(0.05)

                SetTrans(leftClone, 0.4)

                wait(0.05)

                SetTrans(leftClone, 0.5)

                wait(0.05)

                SetTrans(leftClone, 0.6)

                wait(0.05)

                SetTrans(leftClone, 0.8)

                wait(0.05)

                SetTrans(leftClone, 1)

                wait(0.05)

                DestroyPart(leftClone)

            end)

            

            -- Left leg trail (original code)

            spawn(function()

                heh = CFrame.new(0, 0, 0)

                local leftClone = remote:InvokeServer("CreatePart", "Normal", heh, character)

                leftClone.CanCollide = false

                spawn(function() Resize(leftClone, leg.Size, leg.CFrame) end)

                spawn(function() Color(leftClone, currentColor) end)

                spawn(function() SetMaterial(leftClone, Enum.Material.Neon) end)

                spawn(function() SetCollision(leftClone, false) end)

                SetTrans(leftClone, 0.3)

                wait(0.05)

                SetTrans(leftClone, 0.4)

                wait(0.05)

                SetTrans(leftClone, 0.5)

                wait(0.05)

                SetTrans(leftClone, 0.6)

                wait(0.05)

                SetTrans(leftClone, 0.8)

                wait(0.05)

                SetTrans(leftClone, 1)

                wait(0.05)

                DestroyPart(leftClone)

            end)

            

 

            spawn(function()

                heh = CFrame.new(0, 0, 0)

                local leftClone = remote:InvokeServer("CreatePart", "Normal", heh, character)

                leftClone.CanCollide = false

                spawn(function() Resize(leftClone, torso.Size, torso.CFrame) end)

                spawn(function() Color(leftClone, currentColor) end)

                spawn(function() SetMaterial(leftClone, Enum.Material.Neon) end)

                spawn(function() SetCollision(leftClone, false) end)

                SetTrans(leftClone, 0.3)

                wait(0.05)

                SetTrans(leftClone, 0.4)

                wait(0.05)

                SetTrans(leftClone, 0.5)

                wait(0.05)

                SetTrans(leftClone, 0.6)

                wait(0.05)

                SetTrans(leftClone, 0.8)

                wait(0.05)

                SetTrans(leftClone, 1)

                wait(0.05)

                DestroyPart(leftClone)

            end)

            

            spawn(function()

                heh = CFrame.new(0, 0, 0)

                local leftClone = remote:InvokeServer("CreatePart", "Normal", heh, character)

                leftClone.CanCollide = false

                spawn(function() Resize(leftClone, leg2.Size, leg2.CFrame) end)

                spawn(function() Color(leftClone, currentColor) end)

                spawn(function() SetMaterial(leftClone, Enum.Material.Neon) end)

                spawn(function() SetCollision(leftClone, false) end)

                SetTrans(leftClone, 0.3)

                wait(0.05)

                SetTrans(leftClone, 0.4)

                wait(0.05)

                SetTrans(leftClone, 0.5)

                wait(0.05)

                SetTrans(leftClone, 0.6)

                wait(0.05)

                SetTrans(leftClone, 0.8)

                wait(0.05)

                SetTrans(leftClone, 1)

                wait(0.05)

                DestroyPart(leftClone)

            end)

            

            spawn(function()

                heh = CFrame.new(0, 0, 0)

                local right = remote:InvokeServer("CreatePart", "Normal", heh, character)

                right.CanCollide = false

                spawn(function() Resize(right, arm.Size, arm.CFrame) end)

                spawn(function()

                Color(right, currentColor)

                end)

                spawn(function() 

                SetMaterial(right, Enum.Material.Neon) 

                end)

                spawn(function() 

                 SetCollision(right, false)

                  end)

                SetTrans(right, 0.3)

                wait(0.05)

                SetTrans(right, 0.4)

                wait(0.05)

                SetTrans(right, 0.5)

                wait(0.05)

                SetTrans(right, 0.6)

                wait(0.05)

                SetTrans(right, 0.8)

                wait(0.05)

                SetTrans(right, 1)

                wait(0.05)

                DestroyPart(right)

            end)

        end

    end

    wait(0.01)

end 

         elseif cmdText == ":DevUzi me" or cmdText == ":devuzi " or cmdText == "uzi" or cmdText == "devuzi"
 then

           local ReplicatedStorage = game:GetService("ReplicatedStorage")  
  
local rq = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent  
  
local player = game.Players.LocalPlayer  
  
local mouse = player:GetMouse()  
  
local holding = false  
  
local equipped = false  
  
local char = player.Character  
  
local hum = char.Humanoid  
  
local hed = char.Head  
  
local tool  
  
for i,v in player:GetDescendants() do  
  
if v.Name == "SyncAPI" then      
  
    tool = v.Parent      
  
end  
  
end  
  
for i,v in game.ReplicatedStorage:GetDescendants() do  
  
if v.Name == "SyncAPI" then      
  
    tool = v.Parent      
  
end  
  
end  
  
--craaa  
  
remote = tool.SyncAPI.ServerEndpoint  
  
function _(args)  
  
remote:InvokeServer(unpack(args))  
  
end  
  
function SetCollision(part,boolean)  
  
local args = {      
  
    [1] = "SyncCollision",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["CanCollide"] = boolean      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function SetAnchor(boolean,part)  
  
local args = {      
  
    [1] = "SyncAnchor",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Anchored"] = boolean      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function CreatePart(cf,parent)  
  
local args = {      
  
    [1] = "CreatePart",      
  
    [2] = "Normal",      
  
    [3] = cf,      
  
    [4] = parent      
  
}      
  
_(args)  
  
end  
  
function DestroyPart(part)  
  
local args = {      
  
    [1] = "Remove",      
  
    [2] = {      
  
        [1] = part      
  
    }      
  
}      
  
_(args)  
  
end  
  
function MovePart(part,cf)  
  
local args = {      
  
    [1] = "SyncMove",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["CFrame"] = cf      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
local TweenService = game:GetService("TweenService")  
  
function smoothMove(part, cf)  
  
tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)  
  
local tween = TweenService:Create(part, tweenInfo, {CFrame = cf})  
  
tween:Play()  
  
tween.Completed:Connect(function()  
  
local args = {      
  
    [1] = "SyncMove",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["CFrame"] = cf      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end)  
  
end  
  
function Resize(part,size,cf)  
  
local args = {      
  
    [1] = "SyncResize",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["CFrame"] = cf,      
  
            ["Size"] = size      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function AddMesh(part)  
  
local args = {      
  
    [1] = "CreateMeshes",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function reflect(part,int)  
  
local args = {      
  
    [1] = "SyncMaterial",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Reflectance"] = int      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function SetMesh(part,meshid,offset)  
  
local args = {      
  
    [1] = "SyncMesh",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["MeshId"] = "rbxassetid://"..meshid,      
  
            ["Offset"] = offset      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function SetTexture(part, texid)  
  
local args = {      
  
    [1] = "SyncMesh",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["TextureId"] = "rbxassetid://"..texid      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function breakWelds(part)  
  
local welds = {}  
  
for _, weld in ipairs(part:GetDescendants()) do  
  
if weld:IsA("WeldConstraint") or weld:IsA("Weld") or weld:IsA("Motor6D") then      
  
    table.insert(welds, weld)      
  
end  
  
end  
  
if #welds == 0 then  
  
return false  
  
end  
  
local args = {  
  
"RemoveWelds",      
  
welds  
  
}  
  
_(args)  
  
return true  
  
end  
  
function SetName(part, stringg)  
  
local args = {      
  
    [1] = "SetName",      
  
    [2] = {      
  
        [1] = part      
  
    },      
  
    [3] = stringg      
  
}      
  
_(args)  
  
end  
  
function MeshResize(part,size)  
  
local args = {      
  
    [1] = "SyncMesh",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Scale"] = size      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
local function light(part,color)  
  
local createArgs = {		"CreateLights",  
  
{      
  
	{      
  
		Part = part,      
  
		LightType = "PointLight"      
  
	}      
  
}  
  
}  
  
local syncArgs = {  
  
"SyncLighting",      
  
{      
  
	{      
  
		Part = part,      
  
		LightType = "PointLight",      
  
		Color = Color3.new(1,1,0),      
  
Brightness = 10000000,      
  
		Range = 2,      
  
	}      
  
}  
  
}  
  
spawn(function()  
  
_(createArgs)  
  
end)  
  
spawn(function()  
  
_(syncArgs)  
  
end)  
  
end  
  
function Weld(part1, part2,lead)  
  
local args = {      
  
    [1] = "CreateWelds",      
  
    [2] = {      
  
        [1] = part1,      
  
        [2] = part2      
  
    },      
  
    [3] = lead      
  
}      
  
_(args)  
  
end  
  
function SetLocked(part,boolean)  
  
local args = {      
  
    [1] = "SetLocked",      
  
    [2] = {      
  
        [1] = part      
  
    },      
  
    [3] = boolean      
  
}      
  
_(args)  
  
end  
  
function SetTrans(part,int)  
  
local args = {      
  
    [1] = "SyncMaterial",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Transparency"] = int      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function CreateSpotlight(part)  
  
local args = {      
  
    [1] = "CreateLights",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["LightType"] = "SpotLight"      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function playSFX(id,parent)  
  
local SFX = Instance.new('Sound',parent)  
  
SFX.Volume = 10  
  
SFX.SoundId = "rbxassetid://" ..id  
  
SFX:Play()  
  
end  
  
function SyncLighting(part,brightness)  
  
local args = {      
  
    [1] = "SyncLighting",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["LightType"] = "SpotLight",      
  
            ["Brightness"] = brightness      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function Color(part,color)  
  
local args = {      
  
    [1] = "SyncColor",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Color"] = color --[[Color3]],      
  
            ["UnionColoring"] = false      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function SpawnDecal(part,side)  
  
local args = {      
  
    [1] = "CreateTextures",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Face"] = side,      
  
            ["TextureType"] = "Decal"      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function AddDecal(part,asset,side)  
  
local args = {      
  
    [1] = "SyncTexture",      
  
    [2] = {      
  
        [1] = {      
  
            ["Part"] = part,      
  
            ["Face"] = side,      
  
            ["TextureType"] = "Decal",      
  
            ["Texture"] = "rbxassetid://".. asset      
  
        }      
  
    }      
  
}      
  
_(args)  
  
end  
  
function KillTarget(target)  
  
if target and target.Character then  
  
local head = target.Character:FindFirstChild("Head")      
  
if head then      
  
    local args = {      
  
        [1] = "SetLocked",      
  
        [2] = { [1] = head },      
  
        [3] = false      
  
    }      
  
    _(args)      
  
    task.wait(0.1)      
  
    local args2 = {      
  
        [1] = "Remove",      
  
        [2] = { [1] = head }      
  
    }      
  
    _(args2)  
  
spawn(function()  
  
local blood = remote:InvokeServer("CreatePart","Normal",head.CFrame,head)  
  
spawn(function()  
  
Resize(blood,Vector3(.2,.2,.2),blood.CFrame)  
  
end)  
  
spawn(function()  
  
Color(blood,Color3.new(1,0,0))  
  
end)  
  
spawn(function()  
  
SetAnchor(false,blood)  
  
end)  
  
end)  
  
spawn(function()  
  
local blood = remote:InvokeServer("CreatePart","Normal",head.CFrame,head)  
  
spawn(function()  
  
Resize(blood,Vector3(.2,.2,.2),blood.CFrame)  
  
end)  
  
spawn(function()  
  
Color(blood,Color3.new(1,0,0))  
  
end)  
  
spawn(function()  
  
SetAnchor(false,blood)  
  
end)  
  
end)  
  
spawn(function()  
  
local blood = remote:InvokeServer("CreatePart","Normal",head.CFrame,head)  
  
spawn(function()  
  
Resize(blood,Vector3(.2,.2,.2),blood.CFrame)  
  
end)  
  
spawn(function()  
  
Color(blood,Color3.new(1,0,0))  
  
end)  
  
spawn(function()  
  
SetAnchor(false,blood)  
  
end)  
  
end)  
  
spawn(function()  
  
local blood = remote:InvokeServer("CreatePart","Normal",head.CFrame,head)  
  
spawn(function()  
  
Resize(blood,Vector3(.2,.2,.2),blood.CFrame)  
  
end)  
  
spawn(function()  
  
Color(blood,Color3.new(1,0,0))  
  
end)  
  
spawn(function()  
  
SetAnchor(false,blood)  
  
end)  
  
end)  
  
end  
  
end  
  
end  
  
local gun = remote:InvokeServer("CreatePart","Normal",CFrame.new(0,0,0),char)  
  
spawn(function()  
  
AddMesh(gun)  
  
end)  
  
spawn(function()  
  
SetMesh(gun,"4711605382", Vector3.new(0, 0.3, -1.3))  
  
end)  
  
spawn(function()  
  
SetTexture(gun,"4711605902")  
  
end)  
  
spawn(function()  
  
SetName(gun,"dev uzi")  
  
end)  
  
spawn(function()  
  
SetCollision(gun,false)  
  
end)  
  
spawn(function()  
  
MeshResize(gun, Vector3.new(0.05,0.05,0.05))  
  
end)  
  
spawn(function()  
  
MovePart(gun, char["Right Arm"].CFrame * CFrame.Angles(math.rad(90), math.rad(180), math.rad(-90)))  
  
end)  
  
spawn(function()  
  
Weld(gun,char["Right Arm"],gun)  
  
end)  
  
spawn(function()  
  
SetAnchor(false,gun)  
  
end)  
  
spawn(function()  
  
SetTrans(gun,1)  
  
end)  
  
local dev = Instance.new('Tool',player.Backpack)  
  
dev.Name = "Dev Uzi"  
  
dev.RequiresHandle = false  
  
hold=Instance.new('Animation')  
  
hold.AnimationId='rbxassetid://182393478'  
  
hoId=char.Humanoid:LoadAnimation(hold)  
  
hoId.Looped=true  
  
dev.Equipped:Connect(function()  
  
SetTrans(gun,0)  
  
hoId:Play()  
  
equipped = true  
  
end)  
  
dev.Unequipped:Connect(function()  
  
SetTrans(gun,1)  
  
hoId:Stop()      
  
      equipped = false      
  
  	holding = false  
  
end)  
  
mouse.Button1Down:Connect(function()  
  
if not equipped then return end  
  
holding = true  
  
while holding and equipped do  
  
local char = player.Character      
  
if char and char:FindFirstChild("HumanoidRootPart") and mouse.Hit then      
  
	local hrp = char.HumanoidRootPart      
  
	local targetPos = Vector3.new(mouse.Hit.p.X, hrp.Position.Y, mouse.Hit.p.Z)  
  
spawn(function()  
  
light(gun)  
  
wait(0.01)  
  
for i,v in gun:GetDescendants() do  
  
if v:IsA("PointLight") then  
  
DestroyPart(v)  
  
end  
  
end  
  
end)  
  
hrp.CFrame = CFrame.new(hrp.Position, targetPos)      
  
end      
  
task.wait(0.1)  
  
end  
  
end)  
  
mouse.Button1Up:Connect(function()  
  
holding = false  
  
end)  
  
while true do  
  
if hum.Health == 0 then  
  
holding = false  
  
end  
  
wait(0.005)  
  
end  
  
local Players = game:GetService("Players")  
  
local UserInputService = game:GetService("UserInputService")  
  
local player = Players.LocalPlayer  
  
local character = player.Character or player.CharacterAdded:Wait()  
  
local function onCharacterAdded(newCharacter)  
  
character = newCharacter  
  
end  
  
player.CharacterAdded:Connect(onCharacterAdded)  
  
local function onMouseClick()  
  
if equipped == false then return end  
  
if not character then return end  
  
local mouse = player:GetMouse()  
  
local target = mouse.Target  
  
if not target then return end  
  
local model = target:FindFirstAncestorOfClass("Model")  
  
if not model then return end  
  
local targetPlayer = Players:GetPlayerFromCharacter(model)  
  
if targetPlayer then  
  
KillTarget(targetPlayer)  
  
end  
  
end  
  
UserInputService.InputBegan:Connect(function(input, gameProcessed)  
  
if gameProcessed then return end  
  
onMouseClick()  
  
end)  

        
         elseif cmdText == ":Dex me" or cmdText == ":dex " or cmdText == "dex" 
then
          
         loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
         
         elseif cmdText == ":Rc7 me" or cmdText == ":Rc7 " or cmdText == "rc7"
 then
           
           loadstring(game:HttpGet("https://pastebin.com/raw/zkeLwfT6"))()
        
        elseif cmdText == ":Rc7Cloud " or cmdText == ":Rc7Cloud me " or cmdText == "cloud" 
then

          loadstring(game:HttpGet("https://pastebin.com/raw/anuKZunN"))()

        elseif cmdText:lower():sub(1,7) == ":gear " or cmdText:lower():sub(1,8) == "gear " then
            local parts = cmdText:split(" ")
            if #parts >= 3 then
                local target = parts[2]
                local gearId = parts[3]
                if target and gearId then
                    RequestCommand:InvokeServer(";gear "..target.." "..gearId)
                end
            end

        elseif cmdText:lower():sub(1,8) == ":music " or cmdText:lower():sub(1,8) == "music "then
            local parts = cmdText:split(" ")
            if #parts >= 2 then
                local id = parts[2]
                RequestCommand:InvokeServer(";music "..id)
            end

        elseif cmdText:lower():sub(1,5) == ":sm " or cmdText:lower():sub(1,8) == "sm " then
            local parts = cmdText:split(" ")
            if #parts >= 2 then
                local msg = table.concat(parts, " ", 2)
                RequestCommand:InvokeServer(";sm "..msg)
            end
            
        elseif cmdText:lower():sub(1,5) == ":refresh " or cmdText:lower():sub(1,8) == "refresh " then
            local parts = cmdText:split(" ")
            if #parts >= 2 then
                local playersname = table.concat(parts, " ", 2)
                RequestCommand:InvokeServer(";refresh "..playersname)
            end
        
         elseif cmdText:lower():sub(1,5) == ":Fire " or cmdText:lower():sub(1,8) == "fire " or cmdText:lower():sub(1,8) == "Fire " or cmdText:lower():sub(1,8) == ":fire " then
            local parts = cmdText:split(" ")
            if #parts >= 2 then
                local playersname = table.concat(parts, " ", 2)
                RequestCommand:InvokeServer(";fire "..playersname)
            end
         end

        command.Text = ""
    end
end)
