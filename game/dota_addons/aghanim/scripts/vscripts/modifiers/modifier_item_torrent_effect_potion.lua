
modifier_item_torrent_effect_potion = class({})

------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:GetTexture()
	return "item_tome_of_torrents"
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:OnCreated( kv )
	if IsServer() then
		self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.movespeed_bonus = self:GetAbility():GetSpecialValueFor( "movespeed_bonus" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.torrent_damage = self:GetAbility():GetSpecialValueFor( "torrent_damage" )
		self.torrent_cooldown = self:GetAbility():GetSpecialValueFor( "torrent_cooldown" )
	end
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_torrent_effect_potion:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() and params.attacker ~= nil then
			if RollPercentage( self.proc_chance ) then
				if self.fLastTorrentTime == nil or ( GameRules:GetGameTime() >= ( self.fLastTorrentTime + self.torrent_cooldown ) ) then
					-- Create a torrent at the attacker's feet
					local kv =
					{
						radius = self.radius,
						movespeed_bonus = self.movespeed_bonus,
						slow_duration = self.slow_duration,
						stun_duration = self.stun_duration,
						duration = self.delay,
						torrent_damage = self.torrent_damage,
					}

					CreateModifierThinker( self:GetCaster(), self, "modifier_aghsfort_torrent_effect_potion_thinker", kv, params.attacker:GetOrigin(), self:GetCaster():GetTeamNumber(), false )

					self.fLastTorrentTime = GameRules:GetGameTime()
				end
			end
		end
	end

	return 1
end

--------------------------------------------------------------------------------
