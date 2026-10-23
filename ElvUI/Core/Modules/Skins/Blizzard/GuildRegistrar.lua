local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

S:AddCallback("Skin_GuildRegistrar", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guildregistrar then return end

	S:HandlePortraitFrame(GuildRegistrarFrame)

	GuildRegistrarGreetingFrame:StripTextures()

	for i = 1, 2 do
		S:HandleButtonHighlight(_G["GuildRegistrarButton"..i])
	end

	S:HandleButton(GuildRegistrarFrameGoodbyeButton)
	S:HandleButton(GuildRegistrarFrameCancelButton)
	S:HandleButton(GuildRegistrarFramePurchaseButton)

	S:HandleEditBox(GuildRegistrarFrameEditBox)

	local leftBG, rightBG = select(6, GuildRegistrarFrameEditBox:GetRegions())
	leftBG:Kill()
	rightBG:Kill()

	AvailableServicesText:SetTextColor(1, 1, 0)
	GuildRegistrarPurchaseText:SetTextColor(1, 1, 1)
	GuildRegistrarButton1:GetFontString():SetTextColor(1, 1, 1)
	GuildRegistrarButton2:GetFontString():SetTextColor(1, 1, 1)

	GuildRegistrarFrameEditBox:Height(20)
end)