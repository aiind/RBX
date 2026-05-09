

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--// Remote
local Events = RS:WaitForChild("Events"):WaitForChild("RemoteEvent")
local SapuEvent = Events:WaitForChild("Sapu")
local PanciEvent = Events:WaitForChild("Panci")
local TaliEvent = Events:WaitForChild("Tali")

local currentMode = "Sapu"

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AestheticMini"
gui.Parent = LP.PlayerGui
gui.ResetOnSpawn = false

-- MAIN
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,240,0,310)
main.Position = UDim2.new(0.5,-120,0.22,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(55,55,55)
stroke.Thickness = 1.2

-- TITLE
local titleBar = Instance.new("Frame")
titleBar.Parent = main
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,14,0,0)
title.BackgroundTransparency = 1
title.Text = "GTools ID"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local mini = Instance.new("TextButton")
mini.Parent = titleBar
mini.Size = UDim2.new(0,28,0,28)
mini.Position = UDim2.new(1,-34,0,5)
mini.BackgroundColor3 = Color3.fromRGB(35,35,35)
mini.Text = "-"
mini.TextColor3 = Color3.new(1,1,1)
mini.Font = Enum.Font.GothamBold
mini.TextSize = 17
mini.BorderSizePixel = 0
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

-- CONTENT
local content = Instance.new("Frame")
content.Parent = main
content.Position = UDim2.new(0,0,0,40)
content.Size = UDim2.new(1,0,1,-40)
content.BackgroundTransparency = 1

-- LIST
local list = Instance.new("UIListLayout")
list.Parent = content
list.Padding = UDim.new(0,10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder

-- FUNCTION BUTTON STYLE
local function styleBtn(btn)
	btn.Size = UDim2.new(0.88,0,0,34)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(50,50,50)
	s.Thickness = 1
end

-- PLAYER BOX
local playerBox = Instance.new("TextBox")
playerBox.Parent = content
playerBox.PlaceholderText = "target player..."
playerBox.Text = ""
playerBox.Size = UDim2.new(0.88,0,0,34)
playerBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
playerBox.TextColor3 = Color3.new(1,1,1)
playerBox.PlaceholderColor3 = Color3.fromRGB(120,120,120)
playerBox.Font = Enum.Font.Gotham
playerBox.TextSize = 13
playerBox.BorderSizePixel = 0
Instance.new("UICorner", playerBox).CornerRadius = UDim.new(0,10)

-- MODE BUTTON
local modeBtn = Instance.new("TextButton")
modeBtn.Parent = content
modeBtn.Text = "Mode : Sapu"
styleBtn(modeBtn)

-- MODE SCROLL
local modeScroll = Instance.new("ScrollingFrame")
modeScroll.Parent = content
modeScroll.Size = UDim2.new(0.88,0,0,0)
modeScroll.CanvasSize = UDim2.new(0,0,0,110)
modeScroll.ScrollBarThickness = 3
modeScroll.BackgroundTransparency = 1
modeScroll.BorderSizePixel = 0
modeScroll.ClipsDescendants = true

local modeLayout = Instance.new("UIListLayout")
modeLayout.Parent = modeScroll
modeLayout.Padding = UDim.new(0,6)

local function makeOption(parent,text)
	local b = Instance.new("TextButton")
	b.Parent = parent
	b.Size = UDim2.new(1,-4,0,30)
	b.BackgroundColor3 = Color3.fromRGB(38,38,38)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	local st = Instance.new("UIStroke", b)
	st.Color = Color3.fromRGB(55,55,55)

	return b
end

local modeSapu = makeOption(modeScroll,"Sapu")
local modePanci = makeOption(modeScroll,"Panci")
local modeTali = makeOption(modeScroll,"Tali")

-- SEARCH BUTTON
local searchBtn = Instance.new("TextButton")
searchBtn.Parent = content
searchBtn.Text = "Find Tool"
styleBtn(searchBtn)

-- SEARCH SCROLL
local searchScroll = Instance.new("ScrollingFrame")
searchScroll.Parent = content
searchScroll.Size = UDim2.new(0.88,0,0,0)
searchScroll.CanvasSize = UDim2.new(0,0,0,110)
searchScroll.ScrollBarThickness = 3
searchScroll.BackgroundTransparency = 1
searchScroll.BorderSizePixel = 0
searchScroll.ClipsDescendants = true

local searchLayout = Instance.new("UIListLayout")
searchLayout.Parent = searchScroll
searchLayout.Padding = UDim.new(0,6)

local cariSapu = makeOption(searchScroll,"Cari Sapu")
local cariPanci = makeOption(searchScroll,"Cari Panci")
local cariTali = makeOption(searchScroll,"Cari Tali")

-- HIT BUTTON
local hitBtn = Instance.new("TextButton")
hitBtn.Parent = content
hitBtn.Text = "HIT"
hitBtn.Size = UDim2.new(0.88,0,0,42)
hitBtn.BackgroundColor3 = Color3.fromRGB(85,70,160)
hitBtn.TextColor3 = Color3.new(1,1,1)
hitBtn.Font = Enum.Font.GothamBold
hitBtn.TextSize = 15
hitBtn.BorderSizePixel = 0
Instance.new("UICorner", hitBtn).CornerRadius = UDim.new(0,12)

-- STATUS
local status = Instance.new("TextLabel")
status.Parent = content
status.Size = UDim2.new(0.88,0,0,18)
status.BackgroundTransparency = 1
status.Text = "ready..."
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(150,150,150)

-- DROPDOWN
local modeOpen = false
local searchOpen = false

local function toggle(frame,open)
	TweenService:Create(frame,TweenInfo.new(0.22),{
		Size = open and UDim2.new(0.88,0,0,108)
			or UDim2.new(0.88,0,0,0)
	}):Play()
end

modeBtn.MouseButton1Click:Connect(function()
	modeOpen = not modeOpen
	toggle(modeScroll,modeOpen)
end)

searchBtn.MouseButton1Click:Connect(function()
	searchOpen = not searchOpen
	toggle(searchScroll,searchOpen)
end)

-- MODE
local function setMode(m)
	currentMode = m
	modeBtn.Text = "Mode : "..m
	status.Text = "mode "..m.." selected"
end

modeSapu.MouseButton1Click:Connect(function()
	setMode("Sapu")
end)

modePanci.MouseButton1Click:Connect(function()
	setMode("Panci")
end)

modeTali.MouseButton1Click:Connect(function()
	setMode("Tali")
end)

-- SEARCH
local function searchOwner(tool)
	for _,p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild(tool)
		or (p.Character and p.Character:FindFirstChild(tool)) then

			playerBox.Text = p.Name
			status.Text = tool.." owner : "..p.Name
			return
		end
	end

	status.Text = tool.." not found"
end

cariSapu.MouseButton1Click:Connect(function()
	searchOwner("Sapu")
end)

cariPanci.MouseButton1Click:Connect(function()
	searchOwner("Panci")
end)

cariTali.MouseButton1Click:Connect(function()
	searchOwner("Tali")
end)

-- HIT
hitBtn.MouseButton1Click:Connect(function()

	local target = Players:FindFirstChild(playerBox.Text)

	if not target then
		status.Text = "invalid player"
		return
	end

	local tool = target.Backpack:FindFirstChild(currentMode)
		or (target.Character and target.Character:FindFirstChild(currentMode))

	if not tool then
		status.Text = "tool not found"
		return
	end

	if currentMode == "Sapu" then
		SapuEvent:FireServer("Hit", tool)
		status.Text = "sapu sent"

	elseif currentMode == "Panci" then
		PanciEvent:FireServer("Hit", tool)
		status.Text = "panci sent"

	elseif currentMode == "Tali" then

		local ray = Mouse.UnitRay
		local result = workspace:Raycast(ray.Origin, ray.Direction * 100)

		if result then
			TaliEvent:FireServer("Click", result.Instance, result.Position)
			status.Text = "tali hooked"
		else
			TaliEvent:FireServer("ClickEmpty")
			status.Text = "tali missed"
		end
	end
end)

-- MINIMIZE
local minimized = false

mini.MouseButton1Click:Connect(function()

	minimized = not minimized
	content.Visible = not minimized

	TweenService:Create(main,TweenInfo.new(0.25),{
		Size = minimized and UDim2.new(0,240,0,40)
			or UDim2.new(0,240,0,310)
	}):Play()

	mini.Text = minimized and "+" or "-"
end)
