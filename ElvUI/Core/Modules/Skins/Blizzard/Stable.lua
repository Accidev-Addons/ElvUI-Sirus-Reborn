local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

--Lua functions
local _G = _G

S:AddCallback("Skin_Stable", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.stable then return end

	S:HandleSirusFrame(PetStableFrame)

	S:HandleRotateButton(PetStableModelRotateLeftButton)
	S:HandleRotateButton(PetStableModelRotateRightButton)

	PetStableModelRotateLeftButton:Point("TOPLEFT", PetStableModel, "TOPLEFT", 4, -4)
	PetStableModelRotateRightButton:Point("TOPLEFT", PetStableModelRotateLeftButton, "TOPRIGHT", 3, 0)

	S:HandleNextPrevButton(PetStablePrevPageButton)
	S:HandleNextPrevButton(PetStableNextPageButton)

	local function UpdateSlot(self, r, g, b)
		if g ~= 1 then
			self:SetTexture(.8, .2, .2, .3)
		else
			self:SetTexture(0, 0, 0, 0)
		end
	end

	local function SkinSlot(button)
		S:HandleItemButton(button, true)
		_G[button:GetName().."IconTexture"]:SetDrawLayer("OVERLAY")

		button.Checked:SetTexture(1, 1, 1, .3)
		button.Checked:SetInside()

		local bg = button.Background
		bg:SetDrawLayer("BORDER")
		bg:SetInside()
		hooksecurefunc(bg, "SetVertexColor", UpdateSlot)
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		SkinSlot(_G["PetStableActivePet"..i])
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		SkinSlot(_G["PetStableStabledPet"..i])
	end
end)
