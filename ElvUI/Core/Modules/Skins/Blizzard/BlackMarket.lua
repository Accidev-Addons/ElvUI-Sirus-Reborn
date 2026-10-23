local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SkinItemRows()
	local scrollFrame = _G.BlackMarketScrollFrame
	if not scrollFrame then return end

	for _, button in pairs(scrollFrame.buttons or {}) do
		if button and not button.ElvSkinned then

			local iconTex = button.Item and button.Item.IconTexture
			local iconPath = iconTex and iconTex.GetTexture and iconTex:GetTexture()

			button:StripTextures()
			S:HandleButton(button)

			if button.Item then
				S:HandleItemButton(button.Item)
				if iconTex and iconPath then
					iconTex:SetTexture(iconPath)
				end
			end

			button.ElvSkinned = true
		end
	end
end

local function SkinMoneyFrame(mf)
	if not mf or mf.ElvSkinned then return end
	mf.ElvSkinned = true

	mf:StripTextures()
	mf:CreateBackdrop("Transparent")
	mf.backdrop:SetAllPoints()
end

local function LoadSkin()
	if not E.private.skins.blizzard.enable then return end

	local frame = _G.BlackMarketFrame
	frame:StripTextures()
	frame:SetTemplate("Transparent")

	frame.Inset:StripTextures()
	frame.Inset:SetTemplate("Transparent")

	S:HandleCloseButton(frame.CloseButton)

	frame.MoneyFrameBorder:StripTextures()
	frame.MoneyFrameBorder:SetTemplate("Transparent")

	SkinMoneyFrame(_G.BlackMarketMoneyFrame)

	S:HandleButton(frame.BidButton)

	local bidGold = _G.BlackMarketBidPriceGold
	if bidGold then
		S:HandleEditBox(bidGold)
		bidGold.backdrop:ClearAllPoints()
		bidGold.backdrop:Point("TOPLEFT", -4, 0)
		bidGold.backdrop:Point("BOTTOMRIGHT", 4, 0)
	end

	local bidPrice = _G.BlackMarketBidPrice
	if bidPrice then
		bidPrice:StripTextures()
		bidPrice:CreateBackdrop("Transparent")
	end

	for _, colName in pairs({"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}) do
		local col = frame[colName]
		col:StripTextures()
		col:SetTemplate("Transparent")
	end

	local scrollFrame = _G.BlackMarketScrollFrame
	if scrollFrame then
		scrollFrame:StripTextures()
		S:HandleSirusScrollBar(_G.BlackMarketScrollFrameScrollBar)

		hooksecurefunc("BlackMarketScrollFrame_Update", SkinItemRows)
		SkinItemRows()
	end

	if frame.HotDeal then
		local hotDeal = frame.HotDeal

		local iconTex = hotDeal.Item and hotDeal.Item.IconTexture
		local iconPath = iconTex and iconTex.GetTexture and iconTex:GetTexture()

		hotDeal:StripTextures()

		if hotDeal.Item then
			S:HandleItemButton(hotDeal.Item)
			if iconTex and iconPath then
				iconTex:SetTexture(iconPath)
			end
		end

		SkinMoneyFrame(hotDeal.BlackMarketHotItemBidPrice)
	end
end

S:AddCallbackForAddon("Blizzard_BlackMarketUI", "Skin_BlackMarket", LoadSkin)