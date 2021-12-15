
modifier_thunder_mountain_zeus_cloud_thinker = class({})

-----------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_thinker:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bolt_speed = self:GetAbility():GetSpecialValueFor( "bolt_speed" )

	self.hCloudUnit = CreateUnitByName( "npc_dota_zeus_cloud", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
	if self.hCloudUnit then 
		EmitSoundOn( "Hero_Zuus.Cloud.Cast", self.hCloudUnit )
		self.hCloudUnit:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
		self.hCloudUnit:SetOwner( self:GetCaster() )
		self.hCloudUnit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_rooted", {} )
		self.hCloudUnit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_hero_statue_pedestal", {} )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, self.hCloudUnit )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hCloudUnit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.hCloudUnit:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, -self.radius ) );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self.hCloudUnit, PATTACH_POINT_FOLLOW, "flame_attachment", self.hCloudUnit:GetAbsOrigin(), true )
		ParticleManager:SetParticleFoWProperties( nFXIndex, 0, -1, self.radius )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

-----------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_thinker:OnDestroy()
	if IsServer() == false then
		return	
	end

	local vStartPos = self:GetParent():GetAbsOrigin()
	vStartPos.z = vStartPos.z + 4000.0

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, self.hCloudUnit );
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos );
	ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local nFXIndexGlow = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_CUSTOMORIGIN, self.hCloudUnit );
	ParticleManager:SetParticleControl( nFXIndexGlow, 0, vStartPos );
	ParticleManager:SetParticleControl( nFXIndexGlow, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXIndexGlow )

	EmitSoundOn( "Hero_Zuus.LightningBolt", self.hCloudUnit )

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, self.hCloudUnit );
			ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndexGlow = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_CUSTOMORIGIN, self.hCloudUnit );
			ParticleManager:SetParticleControl( nFXIndexGlow, 0, vStartPos );
			ParticleManager:SetParticleControlEnt( nFXIndexGlow, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndexGlow )

			local damageInfo =
			{
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetSpecialValueFor( "bolt_damage" ),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			}
			ApplyDamage( damageInfo )

			EmitSoundOn( "Hero_Zuus.LightningBolt", enemy )
		end
	end

	if self.hCloudUnit and self.hCloudUnit:IsNull() == false then 
		self.hCloudUnit:ForceKill( false )
	end

	UTIL_Remove( self:GetParent() )
end

-----------------------------------------------------------------------------

