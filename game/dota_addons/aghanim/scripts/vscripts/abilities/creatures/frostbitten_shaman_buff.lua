
frostbitten_shaman_buff = class({})
LinkLuaModifier( "modifier_frostbitten_shaman_buff", "modifiers/creatures/modifier_frostbitten_shaman_buff", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function frostbitten_shaman_buff:OnSpellStart()
	if IsServer() then
		self.hBuffedAllies = {}

		self:CheckForAlliesToBuff()
	end
end

-----------------------------------------------------------------------------

function frostbitten_shaman_buff:OnChannelThink( fInterval )
	if IsServer() then
		self:CheckForAlliesToBuff()
	end
end

-----------------------------------------------------------------------------

function frostbitten_shaman_buff:OnChannelFinish( bInterrupted )
	if IsServer() then
		if bInterrupted then
			self:StartCooldown( self:GetSpecialValueFor( "interrupted_cooldown" ) )
		end

		for _, hBuffedAlly in pairs ( self.hBuffedAllies ) do
			if hBuffedAlly ~= nil and hBuffedAlly:IsNull() == false and hBuffedAlly:IsAlive() then
				local hMyBuff = hBuffedAlly:FindModifierByNameAndCaster( "modifier_frostbitten_shaman_buff", self:GetCaster() ) 
				if hMyBuff then
					hMyBuff:Destroy()
				end
				StopSoundOn( "OgreMagi.Bloodlust.Loop", self:GetCaster() )
				hBuffedAlly = nil
			end
		end
	end
end

-----------------------------------------------------------------------------

function frostbitten_shaman_buff:CheckForAlliesToBuff()
	local nBuffableAllies = 0
	local hAllies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 850, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, hAlly in pairs ( hAllies ) do
		if hAlly ~= nil and hAlly:GetUnitName() == "npc_dota_creature_frostbitten_melee" then
			nBuffableAllies = nBuffableAllies + 1
			if ( not hAlly:HasModifier( "modifier_frostbitten_shaman_buff" ) ) then
				table.insert( self.hBuffedAllies, hAlly )

				hAlly:AddNewModifier( self:GetCaster(), self, "modifier_frostbitten_shaman_buff", { duration = -1 } )

				EmitSoundOn( "OgreMagi.Bloodlust.Target", hAlly )
				EmitSoundOn( "OgreMagi.Bloodlust.Target.FP", hAlly )
				EmitSoundOn( "OgreMagi.Bloodlust.Loop", self:GetCaster() )
			end
		end
	end

	if nBuffableAllies <= 0 then
		self:GetCaster():InterruptChannel()
	end
end

-----------------------------------------------------------------------------

