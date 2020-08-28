item_small_scepter_fragment = class({})

--------------------------------------------------------------------------------

function item_small_scepter_fragment:Precache( hContext )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", hContext )
end

--------------------------------------------------------------------------------

function item_small_scepter_fragment:OnSpellStart()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsRealHero() then
			local UpgradeTable = MINOR_ABILITY_UPGRADES[ self:GetCaster():GetUnitName() ]
			if UpgradeTable then
			
				local szUpgradeName = string.sub( self:GetAbilityName(), 6, string.len( self:GetAbilityName() ) )
				local Upgrade = nil
				for _,CurUpgrade in pairs( UpgradeTable ) do
					if CurUpgrade[ "description" ] == szUpgradeName then
						Upgrade = CurUpgrade
						break
					end
				end
				
				if Upgrade then
					-- local gameEvent = {}
					-- gameEvent[ "string_replace_token" ] = Upgrade [ "description" ]
					-- gameEvent[ "ability_name" ] = Upgrade[ "ability_name" ]	
					-- gameEvent[ "value" ] = tonumber( Upgrade[ "value" ] )
					-- gameEvent[ "player_id" ] = self:GetCaster():GetPlayerID()
					-- gameEvent[ "teamnumber" ] = -1
					-- gameEvent[ "message" ] = "#DOTA_HUD_REWARD_TYPE_MINOR_ABILITY_UPGRADE_Toast"

					-- FireGameEvent( "dota_combat_event_message", gameEvent )

					CAghanim:AddMinorAbilityUpgrade( self:GetCaster(), Upgrade )
					EmitSoundOn( "Item.MoonShard.Consume", self:GetCaster() )
				end
			
			end		
		end
		self:SpendCharge()
	end
end

