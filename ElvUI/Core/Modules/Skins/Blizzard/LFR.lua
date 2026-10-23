local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

S:AddCallback("Skin_LFR", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfr then return end

	S:HandlePortraitFrame(RaidParentFrame)
	S:HandleSirusTab(RaidParentFrameTab1)
	S:HandleSirusTab(RaidParentFrameTab2, RaidParentFrameTab1)

	LFRParentFrame:StripTextures()

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():SetAlpha(0)
		tab:SetTemplate()
		tab:StyleButton(nil, true)
		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoords()
	end

	LFRQueueFrame:StripTextures()
	LFRBrowseFrame:StripTextures()

	local buttons = {
		LFRQueueFrameFindGroupButton,
		LFRQueueFrameAcceptCommentButton,
		LFRBrowseFrameSendMessageButton,
		LFRBrowseFrameInviteButton,
		LFRBrowseFrameRefreshButton,
		LFRQueueFrameNoLFRWhileLFDLeaveQueueButton
	}
	for i = 1, #buttons do
		S:HandleButton(buttons[i], true)
	end

	S:HandleDropDownBox(LFRBrowseFrameRaidDropDown)
	S:HandleSirusScrollBar(LFRQueueFrameSpecificListScrollFrameScrollBar)

	LFRQueueFrameCommentTextButton:CreateBackdrop("Default")

	S:HandleCheckBox((LFRQueueFrameRoleButtonTank:GetChildren()))
	S:HandleCheckBox((LFRQueueFrameRoleButtonHealer:GetChildren()))
	S:HandleCheckBox((LFRQueueFrameRoleButtonDPS:GetChildren()))
	LFRQueueFrameRoleButtonTank:GetChildren():OffsetFrameLevel(2)
	LFRQueueFrameRoleButtonHealer:GetChildren():OffsetFrameLevel(2)
	LFRQueueFrameRoleButtonDPS:GetChildren():OffsetFrameLevel(2)

	LFRQueueFrameSpecificListScrollFrame:StripTextures()

	for i = 1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i
		_G[button.."Left"]:Kill()
		_G[button.."Middle"]:Kill()
		_G[button.."Right"]:Kill()
		_G[button]:StyleButton()
	end

	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		local button = _G["LFRQueueFrameSpecificListButton"..i]
		S:HandleCheckBox(button.enableButton)
		S:HandleCollapseExpandButton(button.expandOrCollapseButton, "+")
	end

	LFRQueueFrameSpecificListScrollFrameScrollBar:Point("TOPLEFT", LFRQueueFrameSpecificListScrollFrame, "TOPRIGHT", 5, -17)
	LFRQueueFrameSpecificListScrollFrameScrollBar:Point("BOTTOMLEFT", LFRQueueFrameSpecificListScrollFrame, "BOTTOMRIGHT", 5, 17)

	LFRQueueFrameNoLFRWhileLFD:Size(325, 271)
	LFRQueueFrameNoLFRWhileLFD:Point("BOTTOMRIGHT", -11, 41)

	LFRQueueFrameFindGroupButton:Point("BOTTOMLEFT", 19, 12)
	LFRQueueFrameAcceptCommentButton:Point("BOTTOMRIGHT", -11, 12)
	LFRBrowseFrameSendMessageButton:Point("BOTTOMLEFT", 19, 12)
	LFRBrowseFrameInviteButton:Point("LEFT", LFRBrowseFrameSendMessageButton, "RIGHT", 4, 0)
	LFRBrowseFrameRefreshButton:Point("LEFT", LFRBrowseFrameInviteButton, "RIGHT", 4, 0)
end)