local p=game.Players.LocalPlayer
_G.key=_G.key or false
_G.data=_G.data or{p=0}

local g=Instance.new("ScreenGui",p.PlayerGui)

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,220,0,170)
f.Position=UDim2.new(0.5,-110,0.5,-85)
f.BackgroundColor3=Color3.fromRGB(15,15,15)
f.Active=true
Instance.new("UICorner",f)

local s=Instance.new("UIStroke",f)

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,0,0,30)
t.BackgroundTransparency=1
t.Text="Gerbang Monster"
t.TextScaled=true
t.Font=Enum.Font.GothamBold

local m=Instance.new("TextLabel",f)
m.Size=UDim2.new(1,0,0,40)
m.Position=UDim2.new(0,0,0,30)
m.BackgroundTransparency=1
m.Text=_G.data.p.."/2"
m.TextScaled=true
m.Font=Enum.Font.GothamBold

local b=Instance.new("TextButton",f)
b.Size=UDim2.new(1,-20,0,40)
b.Position=UDim2.new(0,10,1,-50)
b.Text="Buka Gerbang"
b.TextScaled=true
Instance.new("UICorner",b)

local dragging,ds,sp
f.InputBegan:Connect(function(i)
if i.UserInputType.Name:find("Mouse") or i.UserInputType==Enum.UserInputType.Touch then
dragging=true ds=i.Position sp=f.Position end end)

game:GetService("UserInputService").InputChanged:Connect(function(i)
if dragging then local d=i.Position-ds
f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)

game:GetService("UserInputService").InputEnded:Connect(function() dragging=false end)

task.spawn(function()
local h=0
while g.Parent do
h=(h+0.002)%1
local c=Color3.fromHSV(h,0.8,1)
t.TextColor3=c s.Color=c
b.BackgroundColor3=c:Lerp(Color3.new(),0.7)
task.wait()
end end)

local function mainhub()

local rs=game:GetService("RunService")
local UIS=game:GetService("UserInputService")

local g2=Instance.new("ScreenGui",p.PlayerGui)

local f2=Instance.new("Frame",g2)
f2.Size=UDim2.new(0,260,0,230)
f2.Position=UDim2.new(0.5,-130,0.6,0)
f2.BackgroundColor3=Color3.fromRGB(15,15,15)
f2.Active=true
Instance.new("UICorner",f2)

local s2=Instance.new("UIStroke",f2)

local t2=Instance.new("TextLabel",f2)
t2.Size=UDim2.new(1,0,0,30)
t2.BackgroundTransparency=1
t2.Text="Animon Hub"
t2.TextScaled=true
t2.Font=Enum.Font.GothamBold

local b1=Instance.new("TextButton",f2)
b1.Size=UDim2.new(1,-20,0,35)
b1.Position=UDim2.new(0,10,0,35)
b1.Text="AUTO COLLECT: OFF"
b1.TextScaled=true
Instance.new("UICorner",b1)

local b2=Instance.new("TextButton",f2)
b2.Size=UDim2.new(1,-20,0,35)
b2.Position=UDim2.new(0,10,0,75)
b2.Text="MODE: TELEPORT"
b2.TextScaled=true
Instance.new("UICorner",b2)

local b3=Instance.new("TextButton",f2)
b3.Size=UDim2.new(1,-20,0,35)
b3.Position=UDim2.new(0,10,0,115)
b3.Text="GOD MODE: OFF"
b3.TextScaled=true
Instance.new("UICorner",b3)

local b4=Instance.new("TextButton",f2)
b4.Size=UDim2.new(1,-20,0,35)
b4.Position=UDim2.new(0,10,0,155)
b4.Text="BRING: OFF"
b4.TextScaled=true
Instance.new("UICorner",b4)

local d=false local ds,sp
f2.InputBegan:Connect(function(i)
if i.UserInputType.Name:find("Mouse") or i.UserInputType==Enum.UserInputType.Touch then
d=true ds=i.Position sp=f2.Position end end)

UIS.InputChanged:Connect(function(i)
if d then local dl=i.Position-ds
f2.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y) end end)

UIS.InputEnded:Connect(function() d=false end)

task.spawn(function()
local h=0
while true do
h=(h+0.002)%1
local c=Color3.fromHSV(h,0.8,1)
t2.TextColor3=c s2.Color=c
b1.BackgroundColor3=c:Lerp(Color3.new(),0.7)
b2.BackgroundColor3=c:Lerp(Color3.new(),0.7)
b3.BackgroundColor3=c:Lerp(Color3.new(),0.7)
b4.BackgroundColor3=c:Lerp(Color3.new(),0.7)
task.wait()
end end)

local on=false
local mode="TP"
local god=false
local bring=false
local cache={}

b1.MouseButton1Click:Connect(function()
on=not on
b1.Text=on and "AUTO COLLECT: ON" or "AUTO COLLECT: OFF"
end)

b2.MouseButton1Click:Connect(function()
mode=mode=="TP" and "ORBIT" or "TP"
b2.Text=mode=="TP" and "MODE: TELEPORT" or "MODE: ORBIT"
end)

b3.MouseButton1Click:Connect(function()
god=not god
b3.Text=god and "GOD MODE: ON" or "GOD MODE: OFF"
end)

b4.MouseButton1Click:Connect(function()
bring=not bring
b4.Text=bring and "BRING: ON" or "BRING: OFF"
end)

task.spawn(function()
while true do
if on or bring then
table.clear(cache)
local f3=workspace:FindFirstChild("ActiveSpirits")
if f3 then
for _,v in ipairs(f3:GetChildren()) do
local hrp=v:FindFirstChild("HumanoidRootPart")
if hrp then table.insert(cache,hrp) end
end end end
task.wait(0.3)
end end)

local a=0

rs.Heartbeat:Connect(function(dt)
local ch=p.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then return end

if god then
local hum=ch:FindFirstChildOfClass("Humanoid")
if hum then hum.Health=hum.MaxHealth end
end

if bring then
for i,v in ipairs(cache) do
if v and v.Parent then
local pos=hrp.CFrame*CFrame.new(0,0,-2)
v.CFrame=v.CFrame:Lerp(pos,0.4)
firetouchinterest(hrp,v,0)
firetouchinterest(hrp,v,1)
end end
return end

if not on then return end

if mode=="TP" then
for _,v in ipairs(cache) do
if v and v.Parent then
hrp.CFrame=v.CFrame+Vector3.new(0,3,0)
task.wait(0.15)
firetouchinterest(hrp,v,0)
firetouchinterest(hrp,v,1)
end end
else
a+=dt*2
local c=hrp.CFrame*CFrame.new(0,0,-3)
for i,v in ipairs(cache) do
if v and v.Parent then
local o=CFrame.new(math.cos(a+i)*2,0,math.sin(a+i)*2)
v.CFrame=v.CFrame:Lerp(c*o,0.25)
v.AssemblyLinearVelocity=Vector3.zero
v.AssemblyAngularVelocity=Vector3.zero
firetouchinterest(hrp,v,0)
firetouchinterest(hrp,v,1)
end end
end
end)
end

local s=false

local function spin()
if s or _G.key then return end
s=true
b.Text="..."
for i=1,20 do
m.Text=math.random(0,2).."/2"
task.wait(0.03)
end
if math.random()<0.5 then _G.data.p+=1 end
if _G.data.p>2 then _G.data.p=2 end
m.Text=_G.data.p.."/2"
if _G.data.p>=2 then
_G.key=true
m.Text="✔"
task.wait(0.3)
g:Destroy()
mainhub()
return end
task.wait(0.3)
b.Text="SPIN"
s=false
end

b.MouseButton1Click:Connect(spin)
