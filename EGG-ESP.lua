local folder = workspace:WaitForChild("Temp")

-- GUI
pcall(function()
	game.CoreGui:FindFirstChild("EggESP_GUI"):Destroy()
end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EggESP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(40,20,60)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "🥚 ESP EGG"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,120,200)

local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.new(0.8,0,0,35)
btn.Position = UDim2.new(0.1,0,0.45,0)
btn.Text = "ESP: OFF"
btn.BackgroundColor3 = Color3.fromRGB(255,120,200)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner",btn)

local espEnabled = false

btn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	btn.Text = "ESP: "..(espEnabled and "ON" or "OFF")

	if not espEnabled then
		for _,v in pairs(workspace:GetDescendants()) do
			if v.Name == "ESP_TAG" then
				v:Destroy()
			end
		end
	end
end)

-- 🔍 cari part apapun
local function findPart(obj)
	if obj:IsA("BasePart") then
		return obj
	end
	return obj:FindFirstChildWhichIsA("BasePart", true)
end

-- 🔍 SCAN TOTAL (kunci utama)
local function getEggs()
	local list = {}
	for _,v in pairs(folder:GetDescendants()) do
		if string.lower(v.Name) == "easteregg" then
			local part = findPart(v)
			if part then
				table.insert(list, part)
			end
		end
	end
	return list
end

-- buat ESP
local function createESP(part)
	if not espEnabled then return end
	if not part then return end
	if part:FindFirstChild("ESP_TAG") then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "ESP_TAG"
	bill.Size = UDim2.new(0,100,0,40)
	bill.AlwaysOnTop = true
	bill.Adornee = part
	bill.Parent = part

	local txt = Instance.new("TextLabel", bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = "🥚 EGG"
	txt.TextColor3 = Color3.fromRGB(255,120,200)
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.TextScaled = true
end

-- LOOP
task.spawn(function()
	while true do
		task.wait(0.5)
		if espEnabled then
			for _,part in pairs(getEggs()) do
				createESP(part)
			end
		end
	end
end)
