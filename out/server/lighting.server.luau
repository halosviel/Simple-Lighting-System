-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- Imports
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local LightingState = {
	on = "on",
	off = "off",
}
-- Functions
local LightingSystem
do
	LightingSystem = setmetatable({}, {
		__tostring = function()
			return "LightingSystem"
		end,
	})
	LightingSystem.__index = LightingSystem
	function LightingSystem.new(...)
		local self = setmetatable({}, LightingSystem)
		return self:constructor(...) or self
	end
	function LightingSystem:constructor(system)
		self.state = LightingState.off
		self.lastToggleTimestamp = os.clock()
		local lightModel = system:FindFirstChild("Light")
		self.source = lightModel:FindFirstChild("Source")
		self.light = self.source:FindFirstChild("Light")
		local switchModel = system:FindFirstChild("Switch")
		local clickbox = switchModel:FindFirstChild("Clickbox")
		self.sound = clickbox:FindFirstChild("Sound")
		local clickDetector = clickbox:FindFirstChild("ClickDetector")
		clickDetector.MouseClick:Connect(function()
			self:toggle()
		end)
	end
	function LightingSystem:on()
		self.source.Material = Enum.Material.Neon
		self.light.Enabled = true
	end
	function LightingSystem:off()
		self.source.Material = Enum.Material.Plastic
		self.light.Enabled = false
	end
	function LightingSystem:toggle()
		if os.clock() - self.lastToggleTimestamp < LightingSystem.DEBOUNCE_TIME then
			return nil
		end
		self.lastToggleTimestamp = os.clock()
		self.state = if self.state == LightingState.on then LightingState.off else LightingState.on
		--print(this.state);
		if self.state == "on" then
			self:on()
		else
			self:off()
		end
		local _result = self.sound
		if _result ~= nil then
			_result:Play()
		end
	end
	LightingSystem.DEBOUNCE_TIME = 0.25
	LightingSystem.INDEX_NAME = "System"
end
-- Main
local function initialize(obj)
	if obj:IsA("Model") and obj.Name == LightingSystem.INDEX_NAME then
		LightingSystem.new(obj)
	end
end
Workspace.DescendantAdded:Connect(initialize)
for _, obj in Workspace:GetDescendants() do
	initialize(obj)
end
