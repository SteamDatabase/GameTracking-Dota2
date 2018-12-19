winter_wyvern_arctic_burn_nb2017 = class({})
LinkLuaModifier( "modifier_winter_wyvern_arctic_burn_nb2017", "modifiers/modifier_winter_wyvern_arctic_burn_nb2017", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_winter_wyvern_arctic_burn_debuff_dark_moon", "modifiers/modifier_winter_wyvern_arctic_burn_debuff_dark_moon", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function winter_wyvern_arctic_burn_nb2017:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL;
	end

	return self.BaseClass.GetBehavior( self )
end


--------------------------------------------------------------------------------

function winter_wyvern_arctic_burn_nb2017:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return 0
	end

	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function winter_wyvern_arctic_burn_nb2017:OnToggle()
	if self:GetToggleState() == true then
		self:CreateStartFX( self:GetCaster() )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_arctic_burn_nb2017", { duration = -1 } )	
	else
		self:GetCaster():RemoveModifierByName( "modifier_winter_wyvern_arctic_burn_nb2017" );
	end
end

--------------------------------------------------------------------------------

function winter_wyvern_arctic_burn_nb2017:OnSpellStart()
	local kv = 
	{
		duration = self:GetSpecialValueFor( "duration" ),
	}

	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		self:CreateStartFX( hTarget )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_arctic_burn_nb2017", kv )
	end
end

function winter_wyvern_arctic_burn_nb2017:CreateStartFX( hTarget )
	EmitSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", hTarget )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end