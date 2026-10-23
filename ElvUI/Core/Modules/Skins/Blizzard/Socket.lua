local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local ipairs = ipairs
--WoW API / Variables
local GetNumSockets = GetNumSockets
local GetSocketTypes = GetSocketTypes

S:AddCallbackForAddon("Blizzard_ItemSocketingUI", "Skin_Blizzard_ItemSocketingUI", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket then return end

	local minWidthBusy
	hooksecurefunc(ItemSocketingDescription, "SetMinimumWidth", function(tooltip, width, ...)
		if minWidthBusy or width < ITEM_SOCKETING_DESCRIPTION_MIN_WIDTH then return end
		minWidthBusy = true
		tooltip:SetMinimumWidth(width + 278 - ITEM_SOCKETING_DESCRIPTION_MIN_WIDTH, ...)
		minWidthBusy = nil
	end)

	ItemSocketingFrame:StripTextures()
	ItemSocketingFrame:SetTemplate("Transparent")

	S:SetUIPanelWindowInfo(ItemSocketingFrame, "width")

	ItemSocketingFramePortrait:Kill()

	S:HandleCloseButton(ItemSocketingFrame.CloseButton, ItemSocketingFrame)

	for _, region in ipairs({ItemSocketingFrame:GetRegions()}) do
		if region:IsObjectType("FontString") and region:GetText() == ITEM_SOCKETING then
			region:ClearAllPoints()
			region:Point("TOP", 0, -8)
		end
	end

	ItemSocketingScrollFrame:StripTextures()
	ItemSocketingScrollFrame:CreateBackdrop("Transparent")
	ItemSocketingScrollFrame.backdrop:Point("BOTTOMRIGHT", 3, -2)
	ItemSocketingScrollFrame:ClearAllPoints()
	ItemSocketingScrollFrame:Point("TOPLEFT", 10, -30)
	ItemSocketingScrollFrame:Height(300)

	S:HandleSirusScrollBar(ItemSocketingScrollFrameScrollBar)

	ItemSocketingScrollFrameScrollBar:Point("TOPLEFT", ItemSocketingScrollFrame, "TOPRIGHT", 6, -18)
	ItemSocketingScrollFrameScrollBar:Point("BOTTOMLEFT", ItemSocketingScrollFrame, "BOTTOMRIGHT", 6, 17)

	S:HandleButton(ItemSocketingSocketButton)
	ItemSocketingSocketButton:Point("BOTTOMRIGHT", -10, 10)

	for i = 1, MAX_NUM_SOCKETS do
		local button = _G["ItemSocketingSocket"..i]
		local bracket = _G["ItemSocketingSocket"..i.."BracketFrame"]
		local bg = _G["ItemSocketingSocket"..i.."Background"]
		local icon = _G["ItemSocketingSocket"..i.."IconTexture"]
		local shine = _G["ItemSocketingSocket"..i.."Shine"]

		button:StripTextures()
		button:StyleButton(false)
		button:SetTemplate("Default", true)

		bracket:Kill()
		bg:Kill()

		icon:SetTexCoords()
		icon:SetInside()

		shine:SetPoint("CENTER")
		shine:Size(40)
	end

	local GEM_TYPE_INFO = GEM_TYPE_INFO

	hooksecurefunc("ItemSocketingFrame_Update", function()
		local numSockets = GetNumSockets()

		for i = 1, numSockets do
			local button = _G["ItemSocketingSocket"..i]
			local color = GEM_TYPE_INFO[GetSocketTypes(i)]
			button:SetBackdropColor(color.r, color.g, color.b, 0.15)
			button:SetBackdropBorderColor(color.r, color.g, color.b)
		end

		if numSockets == 3 then
			ItemSocketingSocket1:SetPoint("BOTTOM", -80, 42)
		elseif numSockets == 2 then
			ItemSocketingSocket1:SetPoint("BOTTOM", -40, 42)
		else
			ItemSocketingSocket1:SetPoint("BOTTOM", 0, 42)
		end
	end)

	hooksecurefunc(ItemSocketingScrollFrame, "SetWidth", function(self, width)
		if width == 269 then
			self:Width(304)
			ItemSocketingScrollChild:Width(302)
		elseif width == 297 then
			self:Width(315)
			ItemSocketingScrollChild:Width(313)
		end
	end)
end)
