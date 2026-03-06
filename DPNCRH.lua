-- DELTA GUI PREVIEW OBJECT CAMERA

local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local folder = workspace:WaitForChild("Event"):WaitForChild("LyricPosition")

local objects = folder:GetChildren()
local index = 1

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PreviewObjects"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,170)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Object Camera"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- INFO
local info = Instance.new("TextLabel",frame)
info.Size = UDim2.new(1,0,0,25)
info.Position = UDim2.new(0,0,0.18,0)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true

-- BUTTON PREVIEW
local preview = Instance.new("TextButton",frame)
preview.Size = UDim2.new(0.8,0,0,30)
preview.Position = UDim2.new(0.1,0,0.38,0)
preview.Text = "Preview"
preview.BackgroundColor3 = Color3.fromRGB(45,45,45)
preview.TextColor3 = Color3.new(1,1,1)

-- NEXT
local nextBtn = Instance.new("TextButton",frame)
nextBtn.Size = UDim2.new(0.35,0,0,30)
nextBtn.Position = UDim2.new(0.55,0,0.6,0)
nextBtn.Text = "Next >"
nextBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
nextBtn.TextColor3 = Color3.new(1,1,1)

-- BACK
local backBtn = Instance.new("TextButton",frame)
backBtn.Size = UDim2.new(0.35,0,0,30)
backBtn.Position = UDim2.new(0.1,0,0.6,0)
backBtn.Text = "< Back"
backBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
backBtn.TextColor3 = Color3.new(1,1,1)

-- NORMAL
local normal = Instance.new("TextButton",frame)
normal.Size = UDim2.new(0.8,0,0,30)
normal.Position = UDim2.new(0.1,0,0.8,0)
normal.Text = "Normal Camera"
normal.BackgroundColor3 = Color3.fromRGB(45,45,45)
normal.TextColor3 = Color3.new(1,1,1)

-- CLOSE
local close = Instance.new("TextButton",frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-28,0,3)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(0,0,0)
close.TextColor3 = Color3.new(1,1,1)

-- MINIMIZE
local mini = Instance.new("TextButton",frame)
mini.Size = UDim2.new(0,25,0,25)
mini.Position = UDim2.new(1,-56,0,3)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(0,0,0)
mini.TextColor3 = Color3.new(1,1,1)

-- UPDATE INFO
local function updateInfo()
	info.Text = "Object : "..index.." / "..#objects
end

-- CAMERA VIEW
local function viewObject()
	local obj = objects[index]
	if obj and obj:IsA("BasePart") then
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,8), obj.Position)
	end
end

preview.MouseButton1Click:Connect(viewObject)

-- NEXT
nextBtn.MouseButton1Click:Connect(function()
	index = index + 1
	if index > 25 then
		index = 1
	end
	updateInfo()
	viewObject()
end)

-- BACK
backBtn.MouseButton1Click:Connect(function()
	index = index - 1
	if index < 1 then
		index = 25
	end
	updateInfo()
	viewObject()
end)

-- NORMAL CAMERA
normal.MouseButton1Click:Connect(function()
	cam.CameraType = Enum.CameraType.Custom
end)

-- MINIMIZE
local minimized = false
mini.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	for _,v in pairs(frame:GetChildren()) do
		if v:IsA("TextButton") and v ~= mini and v ~= close then
			v.Visible = not minimized
		end
	end
	
	if minimized then
		frame.Size = UDim2.new(0,230,0,30)
	else
		frame.Size = UDim2.new(0,230,0,170)
	end
end)

-- CLOSE
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

updateInfo()
