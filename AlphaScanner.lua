-- Alpha Scanner v2.6 (Enhanced)
-- Made by CeoOfDims + ChatGPT Enhancement

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AlphaScannerGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundTransparency = 1
title.Text = "Alpha Scanner v2.6"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0.5, 0)
status.Position = UDim2.new(0, 10, 0.25, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.new(1, 1, 1)
status.TextScaled = true
status.TextWrapped = true
status.Text = "Scanning..."
status.Parent = frame

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0.2, 0)
footer.Position = UDim2.new(0, 0, 0.8, 0)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Code
footer.TextColor3 = Color3.fromRGB(140, 140, 140)
footer.TextScaled = true
footer.Text = "Made by CeoOfDims"
footer.Parent = frame

TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0.4, 0, 0.25, 0)
}):Play()

-- List keyword berbahaya
local keywords = {
	"require%(", -- Load module by ID
	"getfenv", "setfenv", -- Environment hijack
	"loadstring", -- Executing raw Lua
	"HttpGet", "HttpPost", -- Remote code execution
	"getrawmetatable", "setreadonly", -- Metatable exploits
	"game%.HttpService", "HttpService", -- Remote server comms
	"insertService", -- Deprecated insert use
	"coregui", "CoreGui", -- UI spoofing
	"RunService%.RenderStepped", -- Client-only execution
	"RemoteEvent", "RemoteFunction", -- Unprotected remote usage
	"BindableEvent", "BindableFunction",
	"FireServer", "InvokeServer", -- Common remote calls
	"Lighting", "ReplicatedStorage", "ServerStorage", -- Misused locations
	"Instance%.new%(['\"]Sound['\"])", -- Hidden script in Sound
	"Instance%.new%(['\"]Decal['\"])",
	"Instance%.new%(['\"]BillboardGui['\"])",
	"while true do", -- Potential infinite loop
}

-- Fungsi deteksi
local function isSuspicious(sourceCode)
	local lower = sourceCode:lower()
	for _, word in ipairs(keywords) do
		if lower:find(word:lower()) then
			return true
		end
	end
	return false
end

-- Scanner utama
local function scanGame()
	local suspicious = {}
	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("Script") or obj:IsA("ModuleScript") or obj:IsA("LocalScript") then
			pcall(function()
				local src = obj.Source
				if isSuspicious(src) then
					table.insert(suspicious, obj:GetFullName())
				end
			end)
		end
	end

	if #suspicious > 0 then
		status.TextColor3 = Color3.fromRGB(255, 0, 0)
		status.Text = "Backdoor FOUND!\n" .. table.concat(suspicious, "\n")
	else
		status.TextColor3 = Color3.fromRGB(0, 255, 0)
		status.Text = "Safe: No suspicious backdoors detected."
	end

	task.wait(4)
	TweenService:Create(frame, TweenInfo.new(0.5), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	task.wait(0.5)
	gui:Destroy()
end

task.delay(0.5, scanGame)
