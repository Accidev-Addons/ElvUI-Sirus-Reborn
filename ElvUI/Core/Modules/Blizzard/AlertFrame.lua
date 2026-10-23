local E, L = unpack(ElvUI)
local BL = E:GetModule('Blizzard')
local M = E:GetModule('Misc')

local _G = _G
local next, select, unpack = next, select, unpack
local CreateFrame = CreateFrame

local POSITION, ANCHOR_POINT, Y_OFFSET, BASE_YOFFSET = 'TOP', 'BOTTOM', -5, 0 -- should match in PostAlertMove

local alertGroups = {
	AlertFrame_SetLootAnchors = function() return _G.MissingLootFrame, _G.GroupLootContainer end,
	AlertFrame_SetStorePurchaseAnchors = function() return _G.StorePurchaseAlertFrame end,
	AlertFrame_SetLootWonAnchors = function() return unpack(_G.LOOT_WON_ALERT_FRAMES) end,
	AlertFrame_SetMoneyWonAnchors = function() return unpack(_G.MONEY_WON_ALERT_FRAMES) end,
	AlertFrame_SetAchievementAnchors = function() return _G.AchievementAlertFrame1, _G.AchievementAlertFrame2 end,
	AlertFrame_SetCriteriaAnchors = function() return _G.CriteriaAlertFrame1, _G.CriteriaAlertFrame2 end,
	AlertFrame_SetChallengeModeAnchors = function() return _G.ChallengeModeAlertFrame1 end,
	AlertFrame_SetDungeonCompletionAnchors = function() return _G.DungeonCompletionAlertFrame1 end,
	AlertFrame_SetScenarioAnchors = function() return _G.ScenarioAlertFrame1 end,
	AlertFrame_SetGuildChallengeAnchors = function() return _G.GuildChallengeAlertFrame end,
	AlertFrame_SetDigsiteCompleteToastFrameAnchors = function() return _G.DigsiteCompleteToastFrame end,
}

local function AnchorAlerts(alertAnchor, ...)
	for i = 1, select('#', ...) do
		local frame = select(i, ...)
		if frame and frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, alertAnchor == _G.AlertFrame and BASE_YOFFSET or Y_OFFSET)
			alertAnchor = frame
		end
	end
end

function E:PostAlertMove()
	local AlertFrame = _G.AlertFrame
	local AlertFrameMover = _G.AlertFrameMover

	local _, y = AlertFrameMover:GetCenter()
	local growUp = y < (E.UIParent:GetTop() * 0.5)

	if growUp then
		POSITION, ANCHOR_POINT, Y_OFFSET = 'BOTTOM', 'TOP', 5
	else -- should match above in the cache
		POSITION, ANCHOR_POINT, Y_OFFSET = 'TOP', 'BOTTOM', -5
	end

	AlertFrameMover:SetFormattedText('%s %s', AlertFrameMover.textString, growUp and L['(Grow Up)'] or L['(Grow Down)'])

	AlertFrame:ClearAllPoints()
	AlertFrame:SetAllPoints((E.private.general.lootRoll and M:UpdateLootRollAnchors(POSITION)) or _G.AlertFrameHolder)
end

function BL:AlertMovers()
	local AlertFrameHolder = CreateFrame('Frame', 'AlertFrameHolder', E.UIParent)
	AlertFrameHolder:Size(250, 20)
	AlertFrameHolder:Point('TOP', E.UIParent, 'TOP', 0, -20)

	self:SecureHook('AlertFrame_FixAnchors', E.PostAlertMove)

	for name, frames in next, alertGroups do
		self:SecureHook(name, function(alertAnchor) AnchorAlerts(alertAnchor, frames()) end)
	end

	E:CreateMover(AlertFrameHolder, 'AlertFrameMover', L['Loot / Alert Frames'], nil, nil, E.PostAlertMove, nil, nil, 'general,blizzardImprovements')
end