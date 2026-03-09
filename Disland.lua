local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameRemoteEvents"):WaitForChild("ItemHitEvent")
local item = workspace:WaitForChild("Main"):WaitForChild("Item"):WaitForChild("Angklung")

for i = 1,1000 do
    remote:FireServer(item)
end
