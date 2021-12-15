
treant_miniboss_petrified = class({})
LinkLuaModifier( "modifier_treant_miniboss_petrified", "modifiers/creatures/modifier_treant_miniboss_petrified", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function treant_miniboss_petrified:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_earth_spirit_petrify.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", context )
end

--------------------------------------------------------------------------------

function treant_miniboss_petrified:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function treant_miniboss_petrified:OnSpellStart()
	if IsServer() then
		local fDuration = self:GetSpecialValueFor( "duration" )

		self:GetCaster():RemoveModifierByName( "modifier_absolute_no_cc" )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_treant_miniboss_petrified", { duration = fDuration } )

		--EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
