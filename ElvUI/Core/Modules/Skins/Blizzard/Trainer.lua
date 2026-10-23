local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local ipairs = ipairs

local function SkinSkillButton(button)
	button:DisableDrawLayer("ARTWORK")
	button:StyleButton()

	button:CreateBackdrop()
	button.backdrop:SetOutside(button.icon)
	button.icon:SetTexCoords()
	button.icon:SetParent(button.backdrop)

	button.selectedTex:SetTexture(1, 1, 1, 0.3)
	button.selectedTex:SetInside()
end

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer then return end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	S:HandleSirusFrame(ClassTrainerFrame)

	ClassTrainerFrame.bottomInset:StripTextures()

	S:HandleDropDownBox(ClassTrainerFrameFilterDropDown, 150)

	S:HandleSirusScrollFrame(ClassTrainerFrame.scrollFrame)

	for _, button in ipairs(ClassTrainerFrame.scrollFrame.buttons) do
		SkinSkillButton(button)
	end

	SkinSkillButton(ClassTrainerFrame.skillStepButton)

	S:HandleSirusStatusBar(ClassTrainerStatusBar)
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:Point("CENTER")

	S:HandleSirusButton(ClassTrainerTrainButton)
end

S:AddCallbackForAddon("Blizzard_TrainerUI", "Skin_Blizzard_TrainerUI", LoadSkin)
