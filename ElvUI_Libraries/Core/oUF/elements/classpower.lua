local _, ns = ...
local oUF = ns.oUF

if oUF.myclass ~= 'MONK' then return end

local min = math.min

local UnitHasVehicleUI = UnitHasVehicleUI
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax

local SPELL_POWER_CHI = SPELL_POWER_CHI

local function UpdateColor(self)
	local element = self.ClassPower
	local color = self.colors.power.CHI
	local r, g, b = color[1], color[2], color[3]

	for i = 1, #element do
		local bar = element[i]
		bar:SetStatusBarColor(r, g, b)

		if(bar.bg) then
			local mu = bar.bg.multiplier or 1
			bar.bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
end

local function Update(self, event, unit, powerType)
	if(powerType and powerType ~= 'CHI') then return end

	local element = self.ClassPower

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local cur, max = 0, 0
	if(not UnitHasVehicleUI('player')) then
		cur = UnitPower('player', SPELL_POWER_CHI)
		max = min(UnitPowerMax('player', SPELL_POWER_CHI), #element)
	end

	UpdateColor(self)

	for i = 1, #element do
		local bar = element[i]
		if(i <= max) then
			bar:SetValue(i <= cur and 1 or 0)
			bar:Show()
		else
			bar:Hide()
		end
	end

	local oldMax = element.__max
	element.__max = max

	if(element.PostUpdate) then
		return element:PostUpdate(cur, max, oldMax ~= max)
	end
end

local function Path(self, ...)
	return (self.ClassPower.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.ClassPower
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		for i = 1, #element do
			local bar = element[i]
			if(bar:IsObjectType('StatusBar') and not bar:GetStatusBarTexture()) then
				bar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end

			bar:SetMinMaxValues(0, 1)
		end

		self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
		self:RegisterEvent('UNIT_MAXPOWER', Path)
		self:RegisterEvent('UNIT_ENTERED_VEHICLE', Path)
		self:RegisterEvent('UNIT_EXITED_VEHICLE', Path)

		return true
	end
end

local function Disable(self)
	local element = self.ClassPower
	if(element) then
		for i = 1, #element do
			element[i]:Hide()
		end

		element.__max = nil

		self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
		self:UnregisterEvent('UNIT_MAXPOWER', Path)
		self:UnregisterEvent('UNIT_ENTERED_VEHICLE', Path)
		self:UnregisterEvent('UNIT_EXITED_VEHICLE', Path)
	end
end

oUF:AddElement('ClassPower', Path, Enable, Disable)
