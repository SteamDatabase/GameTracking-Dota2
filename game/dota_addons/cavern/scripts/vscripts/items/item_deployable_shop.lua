
item_deployable_shop = class({})

--------------------------------------------------------------------------------

function item_deployable_shop:OnSpellStart()
	if IsServer() then
		local vPos = self:GetCursorPosition()

		--EmitSoundOn( "Hero_Techies.RemoteMine.Plant", self:GetCaster() );

		local hShop = CreateUnitByName( "npc_dota_cavern_shop", vPos, true, nil, nil, DOTA_TEAM_NEUTRALS )
		if hShop ~= nil then
			hShop:SetAbsOrigin( GetGroundPosition( vPos, hShop ) )
			hShop:SetShopType( DOTA_SHOP_HOME )
			local Trigger = SpawnDOTAShopTriggerRadiusApproximate( hShop:GetOrigin(), CAVERN_SHOP_RADIUS )
			if Trigger then
				Trigger:SetShopType( DOTA_SHOP_HOME )
			end
		end

		self:SpendCharge()
	end
end