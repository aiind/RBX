-- DIP & CRUNCH GUI (Delta Executor)

local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local folder = workspace:WaitForChild("Event"):WaitForChild("LyricPosition")

local objects = folder:GetChildren()
local index = 1

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DIPCrunhGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,200)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🍕 DIP & CRUNCH 🍕"
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- warna animasi merah kuning
task.spawn(function()
	while true do
		title.TextColor3 = Color3.fromRGB(255,60,60)
		task.wait(0.8)
		title.TextColor3 = Color3.fromRGB(255,220,0)
		task.wait(0.8)
	end
end)

-- INFO
local info = Instance.new("TextLabel",frame)
info.Size = UDim2.new(1,0,0,25)
info.Position = UDim2.new(0,0,0.18,0)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true

-- BUTTON STYLE
local function createButton(text,pos)
	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0.38,0,0,30)
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(220,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
	return b
end

-- BUTTONS
local preview = createButton("Preview",UDim2.new(0.1,0,0.38,0))
local teleport = createButton("Teleport",UDim2.new(0.52,0,0.38,0))

local backBtn = createButton("< Back",UDim2.new(0.1,0,0.58,0))
local nextBtn = createButton("Next >",UDim2.new(0.52,0,0.58,0))

local normal = Instance.new("TextButton",frame)
normal.Size = UDim2.new(0.8,0,0,30)
normal.Position = UDim2.new(0.1,0,0.78,0)
normal.Text = "Normal Camera"
normal.BackgroundColor3 = Color3.fromRGB(255,200,0)
normal.TextColor3 = Color3.new(0,0,0)
normal.Font = Enum.Font.GothamBold
Instance.new("UICorner",normal)

-- CLOSE
local close = Instance.new("TextButton",frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(0,0,0)
close.TextColor3 = Color3.new(1,1,1)

-- MINIMIZE
local mini = Instance.new("TextButton",frame)
mini.Size = UDim2.new(0,25,0,25)
mini.Position = UDim2.new(1,-60,0,5)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(0,0,0)
mini.TextColor3 = Color3.new(1,1,1)

-- INFO UPDATE
local function updateInfo()
	info.Text = "Part : "..index.." / "..math.min(#objects,25)
end

-- CAMERA VIEW
local function viewObject()
	local obj = objects[index]
	if obj and obj:IsA("BasePart") then
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,8), obj.Position)
	end
end

-- TELEPORT
local function teleportTo()
	local obj = objects[index]
	if obj and obj:IsA("BasePart") then
		player.Character.HumanoidRootPart.CFrame =
			CFrame.new(obj.Position + Vector3.new(0,3,0))
	end
end

preview.MouseButton1Click:Connect(viewObject)
teleport.MouseButton1Click:Connect(teleportTo)

nextBtn.MouseButton1Click:Connect(function()
	index += 1
	if index > 25 then index = 1 end
	updateInfo()
	viewObject()
end)

backBtn.MouseButton1Click:Connect(function()
	index -= 1
	if index < 1 then index = 25 end
	updateInfo()
	viewObject()
end)

normal.MouseButton1Click:Connect(function()
	cam.CameraType = Enum.CameraType.Custom
end)

-- MINIMIZE
local minimized=false
mini.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _,v in pairs(frame:GetChildren()) do
		if v:IsA("TextButton") and v~=mini and v~=close then
			v.Visible = not minimized
		end
	end
	if minimized then
		frame.Size = UDim2.new(0,260,0,35)
	else
		frame.Size = UDim2.new(0,260,0,200)
	end
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

updateInfo()
