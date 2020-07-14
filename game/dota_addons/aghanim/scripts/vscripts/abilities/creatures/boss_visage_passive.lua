boss_visage_passive = class({})

LinkLuaModifier( "modifier_boss_visage_passive", "modifiers/creatures/modifier_boss_visage_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function boss_visage_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_earth_spirit_petrify.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/storegga_channel.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_visage.vsndevts", context )
end

----------------------------------------------------------------------------------------

function boss_visage_passive:GetIntrinsicModifierName()
	return "modifier_boss_visage_passive"
end

-------------------------------------------------------------------------------

function boss_visage_passive:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() and self:GetCaster() ~= nil then
		self.soul_assumption_radius = self:GetSpecialValueFor( "soul_assumption_radius" )
		local vLocation = ProjectileManager:GetTrackingProjectileLocation( nProjectileHandle )
		local hFamiliars = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.soul_assumption_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		for _,Familiar in pairs ( hFamiliars ) do
			if Familiar ~= nil and Familiar:GetUnitName() == "npc_dota_boss_visage_familiar" then
				self:WakeFamiliar( Familiar )
				ProjectileManager:DestroyTrackingProjectile( nProjectileHandle )
			end
		end 
	end
end

--------------------------------------------------------------------------------

function boss_visage_passive:WakeFamiliar( hFamiliar )
	if IsServer() then
		print( "Waking familiar!" )
		hFamiliar:RemoveModifierByName( "modifier_boss_visage_familiar_stone_form_buff" )
	end
end

--------------------------------------------------------------------------------

function boss_visage_passive:OnProjectileHit( hTarget, vLocation )
	if IsServer() == false or hTarget == nil then
		return true
	end

	if hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
		local damageInfo = 
		{
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor( "soul_assumption_damage" ),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( damageInfo )
	
		EmitSoundOn( "Hero_Visage.SoulAssumption.Target", hTarget )
	end

	return true
end