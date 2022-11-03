
if modifier_building_candy_bucket == nil then
	modifier_building_candy_bucket = class({})
end

------------------------------------------------------------------------------

function modifier_building_candy_bucket:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetTexture()
	return "candy_carry_debuff"
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetEffectName()
	return "particles/hw_fx/candy_well_idle.vpcf"
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:OnCreated( kv )
	if IsServer() == true then
		self.model_scale_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_per_charge" )
		self.model_scale_max = self:GetAbility():GetSpecialValueFor( "model_scale_max" )
	
		self.nCurCandy = 0
	else
		self.nParticleFX = -1
		self.nRangeFX = nil
	end
	self.nPrevCount = 0
	local fInterval = 0.05
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:OnRefresh( kv )
	if IsServer() == true then
		if self.model_scale_per_charge == nil then
			self.model_scale_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_per_charge" )
			self.model_scale_max = self:GetAbility():GetSpecialValueFor( "model_scale_max" )
		end
	else
		if self.nParticleFX == nil then
			self.nParticleFX = -1
		end
	end

	if self.nPrevCount == nil then
		self.nPrevCount = 0
	end

	local fInterval = 0.01
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		--MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}

	return funcs
end



--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetModifierExtraHealthBonus( params )
	local nBonus = 0
	if IsServer() then
		nBonus = _G.WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_1
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" );
		if serverConstants ~= nil then
			nBonus = serverConstants[ "WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_1" ]
		end
	end
	return nBonus
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		--[MODIFIER_STATE_NOT_ON_MINIMAP] = self:GetParent():IsInvulnerable()
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetAbsoluteNoDamagePhysical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetAbsoluteNoDamageMagical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetAbsoluteNoDamagePure( params )
	return 1
end

-----------------------------------------------------------------------------

function modifier_building_candy_bucket:OnAttackLanded( params )
	if IsServer() == false then
		return
	end

	local hVictim = params.target
	if hVictim == nil or hVictim:IsNull() or ( hVictim ~= self:GetParent() ) then
		return
	end

	local hAttacker = params.attacker
	if ( hAttacker == nil ) or hAttacker:IsNull() or ( hAttacker ~= GameRules.Winter2022.hRoshan ) then
		return
	end

	if self:GetParent():FindModifierByName( "modifier_fountain_glyph" ) ~= nil then
		return
	end

	GameRules.Winter2022.hRoshan.bCanAttackWell = false

	self:GetParent():AddNewModifier( GameRules.Winter2022.hRoshan, self:GetAbility(), "modifier_building_roshan_attacking", nil )

	local nCandy = self:GetStackCount()

	if nCandy <= 0 then
		printf( "ERROR! Building %s has zero candy but was attacked by Roshan!", self:GetParent():GetUnitName() )
		return
	end

	local nMaxCandy = self.nMaxCandy or nCandy
	if nCandy > nMaxCandy then
		nMaxCandy = nCandy
	end
	self.nMaxCandy = nMaxCandy

	local nCandyToRemove = math.ceil( nMaxCandy / 4 )
	if nCandy < nCandyToRemove then
		nCandyToRemove = nCandy
	end

	self:SetStackCount( nCandy - nCandyToRemove )

	-- doing this on target, not on attack GameRules.Winter2022:CandyWellAttackedByRoshan( self:GetParent() )

	-- Our health will be 1 if we are at our absolute candy limit
	if self:GetStackCount() == 0 and self:GetParent():GetHealth() <= 1 then
		local hDummy = self:GetParent().hDummy
		if hDummy ~= nil and hDummy:IsNull() == false then
			hDummy:ForceKill( false )
		end
		if GameRules.Winter2022:OnLastWellMaybeDestroyed( self:GetParent() ) == false then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:OnIntervalThink()
	--printf( "OnIntervalThink; self:GetAbility():GetCurrentCharges(): %d", self:GetAbility():GetCurrentCharges() )
	if IsServer() == true then
		return
	end

	local nCandy = self:GetStackCount()
	if nCandy == 0 then
		self.nPrevCount = 0
		if self.nParticleFX ~= -1 then
			ParticleManager:DestroyParticle( self.nParticleFX, true )
			self.nParticleFX = -1
		end
	elseif self.nPrevCount ~= nCandy then
		local nStack = nCandy % 10
		local nTensStack = math.floor( nCandy / 10 ) 
		if self.nParticleFX == -1 then
			self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_building_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			--printf( "candy count: %d; created overhead particle", nCandy )
			--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
		end
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( ( 255 / 255 ), ( 255 / 255 ), ( 255 / 255 ) ) )

		self.nPrevCount = nCandy
	end

	hController = Entities:GetLocalPlayerController()
	local bShouldShowRange = IsDotaAltPressed() or ( hController ~= nil and ( hController:ShouldDisplayInWorldUIElements() or hController:GetQueryUnit() == self:GetParent() ) )

	if hController ~= nil then
		local hActiveAbility = hController:GetActiveAbility()
		if hController:GetClickBehaviors() == DOTA_CLICK_BEHAVIOR_CAST and hActiveAbility ~= nil then
			bShouldShowRange = hActiveAbility:GetAbilityName() == "item_ward_observer" or hActiveAbility:GetAbilityName() == "item_ward_sentry" or hActiveAbility:GetAbilityName() == "item_ward_dispenser" or hActiveAbility:GetAbilityName() == "item_ward_maker"     
		end	
	end

	if bShouldShowRange then
		if ( self.nRangeFX == nil ) then
			self.nRangeFX = ParticleManager:CreateParticle( "particles/ui_mouseactions/range_finder_tower_aoe.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
			ParticleManager:SetParticleControl( self.nRangeFX, 0, self:GetParent():GetAbsOrigin() );
			ParticleManager:SetParticleControlEnt( self.nRangeFX, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false );
			ParticleManager:SetParticleControlEnt( self.nRangeFX, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false );
			ParticleManager:SetParticleControl( self.nRangeFX, 3, Vector( 700, 100, 0 ) ); -- Unit radius
			ParticleManager:SetParticleControl( self.nRangeFX, 4, Vector( 250, 0, 60 ) );	-- Color
			ParticleManager:SetParticleControlEnt( self.nRangeFX, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false );	-- unit pos
			ParticleManager:SetParticleControl( self.nRangeFX, 6, Vector( 0, 0, 0 ) ); -- enable predicted target?
			ParticleManager:SetParticleControl( self.nRangeFX, 7, Vector( 0, 0, 0 ) ); -- predicted target pos
			ParticleManager:SetParticleControl( self.nRangeFX, 8, Vector( 100, 0, 0 ) ); -- Target radius
			ParticleManager:SetParticleControlEnt( self.nRangeFX, 10, Entities:GetLocalPlayerPawn(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false );
			ParticleManager:SetParticleControl( self.nRangeFX, 11, Vector( 0, 0, 0 ) ); -- skin
		end
		ParticleManager:SetParticleControl(self.nRangeFX, 4, Vector( 60, 60, 250 ) );	-- Color
	else
		self:DestroyRangeFX()
	end

end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:DestroyRangeFX()
	if self.nRangeFX ~= nil then
		ParticleManager:DestroyParticle( self.nRangeFX, true )
		self.nRangeFX = nil
	end
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:CreateNewTierParticle( szParticleName )
	local vPos = self:GetParent():GetAbsOrigin()
	local nDamagedFX = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( nDamagedFX, 0, vPos )
	ParticleManager:ReleaseParticleIndex( nDamagedFX )
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:GetModifierModelScale( params )
	local fScale = self.model_scale_per_charge * self:GetStackCount()
	if fScale > self.model_scale_max then
		fScale = self.model_scale_max
	end

	return fScale
end

--------------------------------------------------------------------------------

function modifier_building_candy_bucket:OnDestroy()
	if IsServer() == true then
		return
	end

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
	end

	self:DestroyRangeFX()
end