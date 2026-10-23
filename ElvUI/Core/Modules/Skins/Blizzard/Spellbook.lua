local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook then return end

	S:HandlePortraitFrame(SpellBookFrame)
	SpellBookPage1:SetAlpha(0)
	SpellBookPage2:SetAlpha(0)

	SpellButton1:ClearAllPoints()
	SpellButton1:Point("TOPLEFT", 62, -72)

	SpellBookSearchBox:ClearAllPoints()
	SpellBookSearchBox:Point("TOPLEFT", SpellBookFrame, "TOPLEFT", 66, -38)

	local spellbookTabs = {}
	for i = 1, 5 do
		local tab = _G["SpellBookFrameTab"..i]
		if tab then
			S:HandleSirusTab(tab)
			spellbookTabs[i] = tab
		end
	end
	S:HandleSirusTabFlow(spellbookTabs, "SpellBookFrame_Update")

	S:HandleCheckBox(SpellBookShowAllSpellRanksCheckBox)
	S:HandleCheckBox(SpellBookShowUnassignedSpellBorderCheckBox)
	SpellBookShowUnassignedSpellBorderCheckBox:SetPoint("BOTTOMLEFT", 62, 28)

	S:HandleEditBox(SpellBookSearchBox)

	SpellBookPageText:SetTextColor(1, 1, 1)
	SpellBookPageText:SetPoint("BOTTOMRIGHT", -110, 36)
	S:HandleNextPrevButton(SpellBookPrevPageButton, nil, nil, true)
	SpellBookPrevPageButton:Size(32)
	S:HandleNextPrevButton(SpellBookNextPageButton, nil, nil, true)
	SpellBookNextPageButton:Size(32)

	for i = 1, 12 do
		local button = _G["SpellButton"..i]
		local autoCast = _G["SpellButton"..i.."AutoCastable"]
		button:StripTextures()
		button:CreateBackdrop("Default", true)

		autoCast:SetOutside(button, 16, 16)

		_G["SpellButton"..i.."IconTexture"]:SetTexCoords()

		E:RegisterCooldown(_G["SpellButton"..i.."Cooldown"])
	end

	hooksecurefunc("SpellButton_UpdateButton", function()
		for i = 1, 12 do
			_G["SpellButton"..i.."SpellName"]:SetTextColor(1, 0.80, 0.10)
			_G["SpellButton"..i.."SubSpellName"]:SetTextColor(1, 1, 1)
			_G["SpellButton"..i.."RequiredLevelString"]:SetTextColor(1, 1, 1)
			_G["SpellButton"..i.."Highlight"]:SetTexture(1, 1, 1, 0.3)
		end
	end)
	local nt
	for i = 1, 10 do
		local button = _G["SpellBookSkillLineTab"..i]
		if button then
			button:GetRegions():SetAlpha(0)
			button:SetTemplate()
			button:StyleButton(nil, true)
			nt = button:GetNormalTexture()
			if nt then
				nt:SetInside()
				nt:SetTexCoords()
			end
		end

	end

	local function SkinProfessionButton(button)
		button:StripTextures()
		button:SetTemplate()
		button:StyleButton()

		button.iconTexture:SetInside()
		button.iconTexture:SetTexCoords()
	end

	local function StatusBarColor(self, value)
		local _, maxValue = self:GetMinMaxValues()
		S:StatusBarColorGradient(self, value, maxValue)
	end

	PrimaryProfession1:ClearAllPoints()
	PrimaryProfession1:Point("TOPLEFT", 62, -67)
	SecondaryProfession1:ClearAllPoints()
	SecondaryProfession1:Point("CENTER", 11, -82)

	local function ApplyProfessionTextColors()
		for i = 1, 4 do
			for _, prof in next, { _G["PrimaryProfession"..i], _G["SecondaryProfession"..i] } do
				prof.missingHeader:SetTextColor(1, 0.82, 0)
				prof.missingText:SetTextColor(1, 1, 1)
				prof.professionName:SetTextColor(1, 0.82, 0)
			end
		end
	end
	ApplyProfessionTextColors()
	hooksecurefunc("SpellBookFrame_Update", ApplyProfessionTextColors)

	for i = 1, 4 do
		local prof = _G["PrimaryProfession"..i]

		SkinProfessionButton(prof.button2)
		SkinProfessionButton(prof.button1)

		prof.statusBar:Size(188, 12)
		S:HandleSirusStatusBar(prof.statusBar)
		prof.statusBar.rankText:SetPoint("CENTER")
		hooksecurefunc(prof.statusBar, "SetValue", StatusBarColor)
	end

	for i = 1, 4 do
		local prof = _G["SecondaryProfession"..i]

		SkinProfessionButton(prof.button1)
		SkinProfessionButton(prof.button2)

		S:ApplyElvUIFont(prof)

		prof.statusBar:Size(123, 12)
		prof.statusBar:Point("TOPLEFT", prof.rank, "BOTTOMLEFT", 2, -5)
		S:HandleSirusStatusBar(prof.statusBar)
		prof.statusBar.rankText:SetPoint("CENTER")
		hooksecurefunc(prof.statusBar, "SetValue", StatusBarColor)
	end

	if _G.SpellFlyout then
		local flyout = _G.SpellFlyout

		flyout.BgEnd:SetAlpha(0)
		flyout.HorizBg:SetAlpha(0)
		flyout.VertBg:SetAlpha(0)
		flyout.BgStart:SetAlpha(0)
		flyout:SetTemplate("Transparent")

		local function SkinFlyoutButton(button)
			if not button or button.skinned then return end
			button.skinned = true

			local icon = button.icon or _G[button:GetName().."Icon"]
			local texture = icon and icon:GetTexture()

			button:StripTextures()
			button:SetTemplate()
			button:StyleButton()

			if icon then
				icon:SetTexture(texture)
				icon:SetInside()
				icon:SetTexCoords()
				icon:SetDrawLayer("BORDER")
			end

			local cooldown = button.cooldown or _G[button:GetName().."Cooldown"]
			if cooldown then
				E:RegisterCooldown(cooldown)
			end
		end

		local function SkinFlyoutButtons()
			local i = 1
			local button = _G["SpellFlyoutButton"..i]
			while button do
				SkinFlyoutButton(button)
				i = i + 1
				button = _G["SpellFlyoutButton"..i]
			end
		end

		SkinFlyoutButtons()

		hooksecurefunc(flyout, "Toggle", SkinFlyoutButtons)
	end

end

S:AddCallback("Skin_Spellbook", LoadSkin)
