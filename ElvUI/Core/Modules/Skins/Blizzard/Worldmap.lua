local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local next = next

S:AddCallback("Skin_WorldMap", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap then return end

	local map = _G.WorldMapFrame
	map:CreateBackdrop("Transparent")

	local border = map.BorderFrame
	border.NineSlice:Hide()
	border.Bg:Hide()
	border.InsetBorderTop:Hide()
	border.portrait:SetAlpha(0)
	border.portraitFrame:SetAlpha(0)

	border.TitleText:FontTemplate(nil, nil, "NONE")
	border.TitleText:SetTextColor(1, 1, 1)

	S:HandleCloseButton(border.CloseButton)
	S:HandleMaxMinFrame(border.MaximizeMinimizeFrame)

	map.ScrollContainer:CreateBackdrop()
	map.ScrollContainer.backdrop:OffsetFrameLevel(nil, map.ScrollContainer)

	S:HandleSirusNavBar(map.NavBar)

	for _, frame in next, map.overlayFrames do
		if frame.Arrow and frame.Background then
			frame.Background:SetAlpha(0)
			frame:CreateBackdrop()
			break
		end
	end
end)
