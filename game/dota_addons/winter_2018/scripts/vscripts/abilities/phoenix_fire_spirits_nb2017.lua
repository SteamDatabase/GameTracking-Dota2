phoenix_fire_spirits_nb2017 = class({})
LinkLuaModifier( "modifier_phoenix_fire_spirits_nb2017", "modifiers/modifier_phoenix_fire_spirits_nb2017", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phoenix_fire_spirits_burn_nb2017", "modifiers/modifier_phoenix_fire_spirits_burn_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function phoenix_fire_spirits_nb2017:OnUpgrade()
	if IsServer() then
		if self:GetCaster() == nil then
			return
		end

		local hAbility = self:GetCaster():FindAbilityByName( "phoenix_launch_fire_spirit_nb2017" )
		if hAbility ~= nil and hAbility:GetLevel() ~= self:GetLevel()  then
			hAbility:SetLevel( self:GetLevel() )
		end
	end
end

--------------------------------------------------------------------------------

function phoenix_fire_spirits_nb2017:OnSpellStart()	
	if IsServer() then
		local hp_cost_perc = self:GetSpecialValueFor( "hp_cost_perc" )
		self:PayHealthCost( hp_cost_perc )

		self:GetCaster():SwapAbilities( "phoenix_fire_spirits_nb2017", "phoenix_launch_fire_spirit_nb2017", false, true )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_phoenix_fire_spirits_nb2017", { duration = self:GetSpecialValueFor( "spirit_duration"  ) } )

		EmitSoundOn( "Hero_Phoenix.FireSpirits.Cast", self:GetCaster() ) 
		self:GetCaster():EmitSoundParams( "Hero_Phoenix.FireSpirits.Loop", 100, 0.0, self:GetSpecialValueFor( "spirit_duration" ) )

		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
	end
end

--------------------------------------------------------------------------------

function phoenix_fire_spirits_nb2017:PayHealthCost( nPercent )
	local nHealth = self:GetCaster():GetHealth()
	local nHealthToRemove = nHealth * ( nPercent / 100.0 )
	if nHealthToRemove >  nHealth then
		nHealthToRemove = nHealthToRemove - 1
	end

	if nHealthToRemove > 0 then
		self:GetCaster():ModifyHealth( nHealth - nHealthToRemove, self, false, 0 )
	end
end
