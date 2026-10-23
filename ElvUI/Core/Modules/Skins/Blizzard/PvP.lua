local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local hooksecurefunc = hooksecurefunc

local function StyleButton(button, icon)
	button:StripTextures()
	button:SetTemplate("Default", true)
	button:StyleButton()

	button:GetHighlightTexture():SetTexture(1, 1, 1, 0.1)
	button:GetHighlightTexture():SetInside()

	button.SelectedTexture:SetAlpha(0)

	hooksecurefunc(button.SelectedTexture, "Show", function()
		button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end)
	hooksecurefunc(button.SelectedTexture, "Hide", function()
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end)

	if icon then
		button.Icon:ClearAllPoints()
		button.Icon:Point("LEFT", 10, 0)
		button.Icon:SetTexCoord(unpack(E.TexCoords))
		button.Icon:CreateBackdrop()
		button.Icon:SetParent(button.Icon.backdrop)
		button.Icon.backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
	end
end

local function StyleRewardFrame(frame)
	frame.CurrencyReward:StripTextures()
	frame.CurrencyReward:SetTemplate()
	frame.LootReward.Background:SetAlpha(0)
end

local function SkinCapBar(capBar)
	capBar:StripTextures()

	local bar = capBar.StatusBar
	bar:CreateBackdrop()
	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)
	bar.Left:Kill()
	bar.Right:Kill()
	bar.Middle:Kill()
	bar.Background:Kill()

	hooksecurefunc(bar, "SetValue", function(self, value)
		local _, maxValue = self:GetMinMaxValues()
		S:StatusBarColorGradient(self, value, maxValue)
	end)
end

local function SkinStepBar(stepBar)
	stepBar:StripTextures()
	stepBar:CreateBackdrop()
	stepBar.backdrop:SetInside(stepBar.ShadowOverlay)
	stepBar.ShadowOverlay:StripTextures()
end

S:AddCallbackForAddon("Blizzard_PVPUI", "Skin_PvP", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp then return end

	for i = 1, 3 do
		local b = PVPQueueFrame["CategoryButton"..i]
		b.Ring:Kill()
		b.Background:Kill()
		S:HandleButton(b)
		b.Icon:Size(45)
		b.Icon:ClearAllPoints()
		b.Icon:Point("LEFT", 10, 0)
		b.Icon:SetTexCoord(unpack(E.TexCoords))
		b.Icon:CreateBackdrop()
		b.Icon:SetParent(b.Icon.backdrop)
		b.Icon.backdrop:SetFrameLevel(b:GetFrameLevel() + 2)
	end

	local battlePassButton = PVPQueueFrame.BattlePassToggleButton
	battlePassButton.Ring:Kill()
	battlePassButton.Background:Kill()
	S:HandleButton(battlePassButton)
	battlePassButton.Icon:Size(45)
	battlePassButton.Icon:ClearAllPoints()
	battlePassButton.Icon:Point("LEFT", 10, 0)
	battlePassButton.Icon:SetTexCoord(0.15, .85, .15, .85)
	battlePassButton.Icon:CreateBackdrop()
	battlePassButton.Icon:SetParent(battlePassButton.Icon.backdrop)
	battlePassButton.Name:SetParent(battlePassButton.Icon.backdrop)
	battlePassButton.Icon.backdrop:SetFrameLevel(battlePassButton:GetFrameLevel() + 2)
	battlePassButton.LevelFrame:SetFrameLevel(battlePassButton:GetFrameLevel() + 3)

	SkinCapBar(HonorFrame.CapBar)
	SkinCapBar(ConquestFrame.CapBar)
	SkinStepBar(HonorFrame.StepBar)
	SkinStepBar(ConquestFrame.StepBar)

	HonorFrame.RoleInset:StripTextures()
	for _, roleButton in next, { HonorFrame.RoleInset.TankIcon, HonorFrame.RoleInset.HealerIcon, HonorFrame.RoleInset.DPSIcon } do
		S:HandleCheckBox(roleButton.checkButton)
	end

	S:HandleButton(HonorFrame.SoloQueueButton, true)
	S:HandleButton(HonorFrame.GroupQueueButton, true)

	HonorFrame.Inset:StripTextures()
	S:HandleCheckBox(HonorFrameBonusRadioButton)
	S:HandleCheckBox(HonorFrameSpecificRadioButton)

	S:HandleDropDownBox(HonorFrameTypeDropDown)

	local BonusFrame = HonorFrame.BonusFrame
	BonusFrame:StripTextures()
	BonusFrame.ShadowOverlay:StripTextures()

	StyleRewardFrame(BonusFrame.BattlegroundRewardFrame)
	StyleRewardFrame(BonusFrame.WorldPVPRewardFrame)

	StyleButton(BonusFrame.RandomBGButton)
	StyleButton(BonusFrame.CallToArmsButton)
	StyleButton(BonusFrame.WorldPVP1Button)
	StyleButton(BonusFrame.WorldPVP2Button)

	HonorFrameSpecificFrame:StripTextures()
	S:HandleSirusScrollBar(HonorFrameSpecificFrameScrollBar)

	for i = 1, #HonorFrameSpecificFrame.buttons do
		local button = HonorFrameSpecificFrame.buttons[i]
		button:Width(309)
		if i == 1 then
			button:SetPoint("TOPLEFT", HonorFrameSpecificFrame.scrollChild, "TOPLEFT", E.Border, -E.Border)
		else
			button:SetPoint("TOPLEFT", HonorFrameSpecificFrame.buttons[i - 1], "BOTTOMLEFT", 0, -E.Border)
		end

		StyleButton(button, true)
	end

	HonorFrameSpecificFrame.buttonHeight = HonorFrameSpecificFrame.buttonHeight - 4
	HonorFrameSpecificFrame.scrollChild:SetHeight(#HonorFrameSpecificFrame.buttons * HonorFrameSpecificFrame.buttonHeight)
	HonorFrameSpecificFrame.scrollBar:SetMinMaxValues(0, #HonorFrameSpecificFrame.buttons * HonorFrameSpecificFrame.buttonHeight)

	local BottomInset = ConquestFrame.BottomInset
	BottomInset:StripTextures()
	BottomInset.ShadowOverlay:StripTextures()

	S:HandleCheckBox(ConquestFrameBottomInsetRatedRadioButton)
	S:HandleCheckBox(ConquestFrameBottomInsetSkirmishRadioButton)

	BottomInset.RatedContainer:StripTextures()
	BottomInset.RatedContainer.Header:StripTextures()
	StyleRewardFrame(BottomInset.RatedContainer.Header.Reward)

	StyleButton(BottomInset.RatedContainer.Arena2v2)
	BottomInset.RatedContainer.Arena2v2:Point("TOP", BottomInset.RatedContainer.Header, "BOTTOM", 0, 10)
	StyleButton(BottomInset.RatedContainer.Arena1v1)
	BottomInset.RatedContainer.Arena1v1:Point("TOP", BottomInset.RatedContainer.Arena2v2, "BOTTOM", 0, -(E.Border * 2))

	BottomInset.SoloContainer:StripTextures()
	BottomInset.SoloContainer.Header:StripTextures()
	StyleRewardFrame(BottomInset.SoloContainer.Header.Reward)

	StyleButton(BottomInset.SoloContainer.ArenaSolo)

	BottomInset.SkirmishContainer:StripTextures()
	BottomInset.SkirmishContainer.Header:StripTextures()
	StyleRewardFrame(BottomInset.SkirmishContainer.Header.Reward)

	StyleButton(BottomInset.SkirmishContainer.Skirmish2v2)
	StyleButton(BottomInset.SkirmishContainer.Skirmish1v1)

	S:HandleButton(ConquestFrame.JoinButton, true)

	RatedBattlegroundFrame.Inset:StripTextures()
	RatedBattlegroundFrame.Container:StripTextures()

	local progressBar = RatedBattlegroundFrame.Container.ProgressBar
	progressBar:CreateBackdrop()
	progressBar.Progress:SetTexture(E.media.normTex)
	E:RegisterStatusBar(progressBar.Progress)
	progressBar.backdrop:Point("TOPLEFT", progressBar.Progress, -1, 1)
	progressBar.backdrop:Point("BOTTOMRIGHT", progressBar.Background, -21, 0)
	progressBar.Frame:Kill()
	progressBar.Level:SetPoint("CENTER", 0, 1)
	progressBar.Background:Kill()

	RatedBattlegroundStatisticsScrollFrame:StripTextures()
	S:HandleSirusScrollBar(RatedBattlegroundStatisticsScrollFrameScrollBar)

	RatedBattlegroundStatisticsScrollFrame:HookScript("OnShow", function()
		for i = 1, #RatedBattlegroundStatisticsScrollFrame.buttons do
			local button = RatedBattlegroundStatisticsScrollFrame.buttons[i]
			if not button.isSkinned then
				button:SetTemplate("Transparent")

				button.Background:SetDrawLayer("BORDER")
				button.Background:SetInside()
				button.Background:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 1, 1, 1, 1)

				S:HandleSirusToggle(button.TogglePlus, E.Media.Textures.Plus)
				S:HandleSirusToggle(button.ToggleMinus, E.Media.Textures.Minus)

				button.isSkinned = true
			end
		end
	end)

	S:HandleButton(RatedBattlegroundFrame.StatisticsButton, true)

	WarGamesFrame.RightInset:StripTextures()
	WarGamesFrame.HorizontalBar:StripTextures()
	S:HandleSirusScrollBar(WarGamesFrameScrollFrameScrollBar)
	S:HandleSirusScrollBar(WarGamesFrameInfoScrollFrameScrollBar)
	S:HandleButton(WarGameStartButton, true)

	ConquestTooltip:SetTemplate("Transparent")
end)
S:AddCallback("Skin_BattlegroundInvite", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp then return end

	local frame = _G.BattlegroundInviteFrame
	if not frame then return end

	local popup = frame.PopupFrame
	popup.Body:SetTexture(E.ClearTexture)
	popup.Header:SetTexture(E.ClearTexture)
	popup.Bottom:SetTexture(E.ClearTexture)

	popup:CreateBackdrop("Transparent")
	popup.backdrop:Point("TOPLEFT", 0, -40)
	popup.backdrop:Point("BOTTOMRIGHT", 0, 40)

	popup.Title:FontTemplate(nil, 16, "OUTLINE")
	popup.Title:SetTextColor(1, 1, 1)
	popup.Timer:FontTemplate(nil, 24, "OUTLINE")

	local timerColorBusy
	hooksecurefunc(popup.Timer, "SetTextColor", function(fs, r, g, b, a)
		if timerColorBusy or r ~= 0 or g ~= 0 or b ~= 0 then return end
		timerColorBusy = true
		fs:SetTextColor(1, 1, 1, a)
		timerColorBusy = nil
	end)
	popup.Timer:SetTextColor(1, 1, 1)

	S:HandleButton(popup.EnterButton)
	S:HandleCloseButton(popup.CancelButton)
	S:HandleNextPrevButton(popup.HideButton, "down")
end)
