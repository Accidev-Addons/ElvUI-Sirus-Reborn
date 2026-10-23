local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function AllStrip(self)
	self.TopLeft:Hide()
	self.TopRight:Hide()
	self.BottomLeft:Hide()
	self.BottomRight:Hide()
	self.TopMiddle:Hide()
	self.MiddleLeft:Hide()
	self.MiddleRight:Hide()
	self.BottomMiddle:Hide()
	self.MiddleMiddle:Hide()
end

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.legacyCollection then return end

	S:HandleDropDownBox(HeirloomsJournalClassDropDown)
	S:HandleSirusTab(CollectionsJournalTab4)
	HeirloomsJournalIconsFrameOverlayFrame:StripTextures()
	HeirloomsJournal:StripTextures()
	HeirloomsJournalIconsFrame:StripTextures()
	HeirloomsJournalIconsFrame:CreateBackdrop("Default")
	AllStrip(HeirloomsJournalFilterButton)
	S:HandleButton(HeirloomsJournalFilterButton)
	S:HandleEditBox(HeirloomsJournalSearchBox)
	S:HandleNextPrevButton(HeirloomsJournalNextPageButton, "right")
	S:HandleNextPrevButton(HeirloomsJournalPrevPageButton, "left")
	S:HandleStatusBar(HeirloomsJournalProgressBar)

	HeirloomsJournalIconsFrame:HookScript("OnShow", function(self)
		for i = 1, 18 do
			local button = _G["HeirloomSpellButton" .. i]
			if button and button.Cooldown then
				E:RegisterCooldown(button.Cooldown)
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_PetJournal", "Skin_LegacyCollection", LoadSkin)
