-- SHIFT LOCK BUTTON (DELTA ANDROID)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShiftButton"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,40,0,40)
btn.Position = UDim2.new(0.82,0,0.72,0)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.Text = "SHIFT"
btn.TextScaled = true
btn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

local shiftlock = false

btn.MouseButton1Click:Connect(function()
	shiftlock = not shiftlock
	
	if shiftlock then
		btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	else
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	end
end)

RunService.RenderStepped:Connect(function()
	if shiftlock and char and hrp then
		local cam = workspace.CurrentCamera
		local look = cam.CFrame.LookVector
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X,0,look.Z))
	end
end)

-- fix respawn
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
end)
