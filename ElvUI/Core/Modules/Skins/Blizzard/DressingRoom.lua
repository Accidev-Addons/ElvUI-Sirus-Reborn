local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

S:AddCallback("Skin_DressingRoom", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom then return end

	S:HandleSirusFrame(DressUpFrame, true)

	if DressUpFrameMaximizeMinimizeFrame then
		S:HandleMaxMinFrame(DressUpFrameMaximizeMinimizeFrame)
	end

	DressUpModel.ModelBackground:SetDesaturated(true)

	S:HandleControlFrame(DressUpModel.controlFrame)
	S:HandleCheckBox(DressUpModel.ShowMountCheckButton)

	S:HandleButton(DressUpFrameCancelButton)
	S:HandleButton(DressUpFrameResetButton)

	DressUpModel:CreateBackdrop("Default")
end)
