-- TurtleSpy V1.5.3, credits to Intrer#0421
-- Kompatibel dengan Delta Executor Android

local colorSettings =
{
    ["Main"] = {
        ["HeaderColor"] = Color3.fromRGB(0, 168, 255),
        ["HeaderShadingColor"] = Color3.fromRGB(0, 151, 230),
        ["HeaderTextColor"] = Color3.fromRGB(47, 54, 64),
        ["MainBackgroundColor"] = Color3.fromRGB(47, 54, 64),
        ["InfoScrollingFrameBgColor"] = Color3.fromRGB(47, 54, 64),
        ["ScrollBarImageColor"] = Color3.fromRGB(127, 143, 166)
    },
    ["RemoteButtons"] = {
        ["BorderColor"] = Color3.fromRGB(113, 128, 147),
        ["BackgroundColor"] = Color3.fromRGB(53, 59, 72),
        ["TextColor"] = Color3.fromRGB(220, 221, 225),
        ["NumberTextColor"] = Color3.fromRGB(203, 204, 207)
    },
    ["MainButtons"] = { 
        ["BorderColor"] = Color3.fromRGB(113, 128, 147),
        ["BackgroundColor"] = Color3.fromRGB(53, 59, 72),
        ["TextColor"] = Color3.fromRGB(220, 221, 225)
    },
    ['Code'] = {
        ['BackgroundColor'] = Color3.fromRGB(35, 40, 48),
        ['TextColor'] = Color3.fromRGB(220, 221, 225),
        ['CreditsColor'] = Color3.fromRGB(108, 108, 108)
    },
}

local settings = {
["Keybind"] = "P"
}

if PROTOSMASHER_LOADED then
    getgenv().isfile = newcclosure(function(File)
        local Suc, Er = pcall(readfile, File)
        if not Suc then
            return false
        end
        return true
    end)
end

local HttpService = game:GetService("HttpService")
if not isfile("TurtleSpySettings.json") then
    writefile("TurtleSpySettings.json", HttpService:JSONEncode(settings))
else
    if HttpService:JSONDecode(readfile("TurtleSpySettings.json"))["Main"] then
        writefile("TurtleSpySettings.json", HttpService:JSONEncode(settings))
    else
        settings = HttpService:JSONDecode(readfile("TurtleSpySettings.json"))
    end
end

function isSynapse()
    if PROTOSMASHER_LOADED then
        return false
    else
    return true
    end
end

function Parent(GUI)
    if syn and syn.protect_gui then
        syn.protect_gui(GUI)
        GUI.Parent = game:GetService("CoreGui")
    elseif PROTOSMASHER_LOADED then
        GUI.Parent = get_hidden_gui()
    else
        GUI.Parent = game:GetService("CoreGui")
    end
end

local client = game.Players.LocalPlayer
local function toUnicode(string)
    local codepoints = "utf8.char("
    for _i, v in utf8.codes(string) do
        codepoints = codepoints .. v .. ', '
    end
    return codepoints:sub(1, -3) .. ')'
end

local function GetFullPathOfAnInstance(instance)
    local name = instance.Name
    local head = (#name > 0 and '.' .. name) or "['']"
    if not instance.Parent and instance ~= game then
        return head .. " --[[ PARENTED TO NIL OR DESTROYED ]]"
    end
    if instance == game then
        return "game"
    elseif instance == workspace then
        return "workspace"
    else
        local _success, result = pcall(game.GetService, game, instance.ClassName)
        if result then
            head = ':GetService("' .. instance.ClassName .. '")'
        elseif instance == client then
            head = '.LocalPlayer' 
        else
            local nonAlphaNum = name:gsub('[%w_]', '')
            local noPunct = nonAlphaNum:gsub('[%s%p]', '')
            if tonumber(name:sub(1, 1)) or (#nonAlphaNum ~= 0 and #noPunct == 0) then
                head = '["' .. name:gsub('"', '\\"'):gsub('\\', '\\\\') .. '"]'
            elseif #nonAlphaNum ~= 0 and #noPunct > 0 then
                head = '[' .. toUnicode(name) .. ']'
            end
        end
    end
    return GetFullPathOfAnInstance(instance.Parent) .. head
end

local isA = game.IsA
local clone = game.Clone
local TextService = game:GetService("TextService")
local getTextSize = TextService.GetTextSize
game.StarterGui.ResetPlayerGuiOnSpawn = false
local mouse = game.Players.LocalPlayer:GetMouse()

if game.CoreGui:FindFirstChild("TurtleSpyGUI") then
    game.CoreGui.TurtleSpyGUI:Destroy()
end

local buttonOffset = -25
local scrollSizeOffset = 287
local functionImage = "http://www.roblox.com/asset/?id=413369623"
local eventImage = "http://www.roblox.com/asset/?id=413369506"
local remotes = {}
local remoteArgs = {}
local remoteButtons = {}
local remoteScripts = {}
local IgnoreList = {}
local BlockList = {}
local connections = {}
local unstacked = {}

local TurtleSpyGUI = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local HeaderShading = Instance.new("Frame")
local HeaderTextLabel = Instance.new("TextLabel")
local RemoteScrollFrame = Instance.new("ScrollingFrame")
local RemoteButton = Instance.new("TextButton")
local Number = Instance.new("TextLabel")
local RemoteName = Instance.new("TextLabel")
local RemoteIcon = Instance.new("ImageLabel")
local InfoFrame = Instance.new("Frame")
local InfoFrameHeader = Instance.new("Frame")
local CodeFrame = Instance.new("ScrollingFrame")
local Code = Instance.new("TextLabel")
local CodeComment = Instance.new("TextLabel")
local InfoHeaderText = Instance.new("TextLabel")
local InfoButtonsScroll = Instance.new("ScrollingFrame")
local CopyCode = Instance.new("TextButton")
local RunCode = Instance.new("TextButton")
local CopyScriptPath = Instance.new("TextButton")
local IgnoreRemote = Instance.new("TextButton")
local BlockRemote = Instance.new("TextButton")
local Clear = Instance.new("TextButton")
local OpenInfoFrame = Instance.new("TextButton")
local Minimize = Instance.new("TextButton")

TurtleSpyGUI.Name = "TurtleSpyGUI"
Parent(TurtleSpyGUI)

mainFrame.Name = "mainFrame"
mainFrame.Parent = TurtleSpyGUI
mainFrame.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
mainFrame.Position = UDim2.new(0.1, 0, 0.24, 0)
mainFrame.Size = UDim2.new(0, 207, 0, 35)
mainFrame.ZIndex = 8
mainFrame.Active = true
mainFrame.Draggable = true

Header.Name = "Header"
Header.Parent = mainFrame
Header.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
Header.Size = UDim2.new(0, 207, 0, 26)
Header.ZIndex = 9

HeaderTextLabel.Name = "HeaderTextLabel"
HeaderTextLabel.Parent = Header
HeaderTextLabel.BackgroundTransparency = 1.000
HeaderTextLabel.Size = UDim2.new(1, 0, 1, 0)
HeaderTextLabel.Font = Enum.Font.SourceSans
HeaderTextLabel.Text = "Turtle Spy"
HeaderTextLabel.TextColor3 = colorSettings["Main"]["HeaderTextColor"]
HeaderTextLabel.TextSize = 17.000

RemoteScrollFrame.Name = "RemoteScrollFrame"
RemoteScrollFrame.Parent = mainFrame
RemoteScrollFrame.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
RemoteScrollFrame.Position = UDim2.new(0, 0, 1, 0)
RemoteScrollFrame.Size = UDim2.new(0, 207, 0, 286)
RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 287)
RemoteScrollFrame.ScrollBarThickness = 8

RemoteButton.Name = "RemoteButton"
RemoteButton.Parent = RemoteScrollFrame
RemoteButton.BackgroundColor3 = colorSettings["RemoteButtons"]["BackgroundColor"]
RemoteButton.Size = UDim2.new(0, 182, 0, 26)
RemoteButton.Visible = false

Number.Name = "Number"
Number.Parent = RemoteButton
Number.BackgroundTransparency = 1
Number.Size = UDim2.new(0, 30, 0, 26)
Number.Text = "1"
Number.TextColor3 = colorSettings["RemoteButtons"]["NumberTextColor"]

RemoteName.Name = "RemoteName"
RemoteName.Parent = RemoteButton
RemoteName.BackgroundTransparency = 1
RemoteName.Position = UDim2.new(0, 35, 0, 0)
RemoteName.Size = UDim2.new(0, 120, 0, 26)
RemoteName.Text = "Remote"
RemoteName.TextColor3 = colorSettings["RemoteButtons"]["TextColor"]
RemoteName.TextXAlignment = Enum.TextXAlignment.Left

RemoteIcon.Name = "RemoteIcon"
RemoteIcon.Parent = RemoteButton
RemoteIcon.BackgroundTransparency = 1
RemoteIcon.Position = UDim2.new(0.85, 0, 0, 0)
RemoteIcon.Size = UDim2.new(0, 24, 0, 24)

InfoFrame.Name = "InfoFrame"
InfoFrame.Parent = mainFrame
InfoFrame.BackgroundColor3 = colorSettings["Main"]["MainBackgroundColor"]
InfoFrame.Position = UDim2.new(1, 5, 0, 0)
InfoFrame.Size = UDim2.new(0, 357, 0, 322)
InfoFrame.Visible = false

CodeFrame.Name = "CodeFrame"
CodeFrame.Parent = InfoFrame
CodeFrame.BackgroundColor3 = colorSettings["Code"]["BackgroundColor"]
CodeFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
CodeFrame.Size = UDim2.new(0, 320, 0, 60)
CodeFrame.CanvasSize = UDim2.new(2, 0, 2, 0)

Code.Parent = CodeFrame
Code.Size = UDim2.new(1, 0, 1, 0)
Code.TextColor3 = colorSettings["Code"]["TextColor"]
Code.TextXAlignment = Enum.TextXAlignment.Left
Code.TextYAlignment = Enum.TextYAlignment.Top

Clear.Parent = mainFrame
Clear.Position = UDim2.new(0, 0, 1, 286)
Clear.Size = UDim2.new(0, 207, 0, 30)
Clear.Text = "CLEAR LOGS"
Clear.MouseButton1Click:Connect(function()
    for i, v in pairs(RemoteScrollFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    remotes = {}
    buttonOffset = -25
    scrollSizeOffset = 0
    RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 287)
end)

local function FindRemote(remote, args)
    return table.find(remotes, remote)
end

function addToList(event, remote, ...)
    local args = {...}
    local i = FindRemote(remote, args)
    if not i then
        table.insert(remotes, remote)
        local rButton = clone(RemoteButton)
        rButton.Parent = RemoteScrollFrame
        rButton.Visible = true
        rButton.RemoteName.Text = remote.Name
        if not event then rButton.RemoteIcon.Image = functionImage end
        buttonOffset = buttonOffset + 35
        rButton.Position = UDim2.new(0.05, 0, 0, buttonOffset)
        
        rButton.MouseButton1Click:Connect(function()
            InfoFrame.Visible = true
            Code.Text = GetFullPathOfAnInstance(remote) .. (event and ":FireServer(" or ":InvokeServer(") .. "args...)"
        end)
    end
end

local OldEvent
OldEvent = hookfunction(Instance.new("RemoteEvent").FireServer, function(Self, ...)
    if not checkcaller() and not table.find(IgnoreList, Self) then
        addToList(true, Self, ...)
    end
    return OldEvent(Self, ...)
end)

local OldFunction
OldFunction = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(Self, ...)
    if not checkcaller() and not table.find(IgnoreList, Self) then
        addToList(false, Self, ...)
    end
    return OldFunction(Self, ...)
end)

print("TurtleSpy V1.5.3 Loaded!")
