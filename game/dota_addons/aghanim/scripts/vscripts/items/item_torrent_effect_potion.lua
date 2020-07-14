
item_torrent_effect_potion = class({})
LinkLuaModifier( "modifier_item_torrent_effect_potion", "modifiers/modifier_item_torrent_effect_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_torrent_effect_potion:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", context )
end

--------------------------------------------------------------------------------

function item_torrent_effect_potion:OnSpellStart()
	if IsServer() then
		self.proc_chance = self:GetSpecialValueFor( "proc_chance" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.movespeed_bonus = self:GetSpecialValueFor( "movespeed_bonus" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.delay = self:GetSpecialValueFor( "delay" )
		self.torrent_damage = self:GetSpecialValueFor( "torrent_damage" )

		local kv =
		{
			duration = -1,
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_torrent_effect_potion", kv )

		EmitSoundOn( "TorrentEffectPotion.Activate", self:GetCaster() )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
