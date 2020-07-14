ascension_flicker = class( {} )

LinkLuaModifier( "modifier_ascension_flicker_display", "modifiers/modifier_ascension_flicker_display", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_flicker:Precache( context )
	PrecacheResource( "particle", "particles/items_fx/blink_dagger_start.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/blink_dagger_end.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_flicker:Spawn()
	-- So the modifier can be seen
	if IsServer() == true then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_flicker_display", nil )
	end
end

--------------------------------------------------------------------------------

function ascension_flicker:OnSpellStart()

	if not IsServer() then
		return
	end

	local range = self:GetSpecialValueFor( "range" )
	local nAttempts = 0
	local vEndPos = self:GetCaster():GetAbsOrigin() + RandomVector( 1 ) * range;
	while ( ( not GridNav:CanFindPath( self:GetCaster():GetOrigin(), vEndPos ) ) and ( nAttempts < 5 ) ) do
		vEndPos = self:GetCaster():GetOrigin() +  RandomVector( 1 ) * range;
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vEndPos = self:GetCaster():GetAbsOrigin()
		end
	end

	

	local nFXStart = ParticleManager:CreateParticle( "particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXStart, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXStart )

	FindClearSpaceForUnit( self:GetCaster(), vEndPos, true )
	ProjectileManager:ProjectileDodge( self:GetCaster() )
	EmitSoundOn( "DOTA_Item.BlinkDagger.Activate", self:GetCaster() )
	self:GetCaster():Purge( false, true, false, false, false )

	local nFXEnd = ParticleManager:CreateParticle( "particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( nFXEnd )
end

