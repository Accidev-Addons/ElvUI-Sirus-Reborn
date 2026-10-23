local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

--Lua functions
--WoW API / Variables

S:AddCallback("Skin_Petition", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.petition then return end

	S:HandlePortraitFrame(PetitionFrame)

	S:HandleButton(PetitionFrameSignButton)
	S:HandleButton(PetitionFrameRequestButton)
	S:HandleButton(PetitionFrameRenameButton)
	S:HandleButton(PetitionFrameCancelButton)

	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)

	for i = 1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(1, 1, 1)
	end

	PetitionFrameInstructions:SetTextColor(1, 1, 1)

	PetitionFrameRenameButton:Point("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:Point("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
end)