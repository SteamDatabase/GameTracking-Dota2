
modifier_candy_bucket_invulnerable = class({})

--------------------------------------------------------------------------------

function modifier_candy_bucket_invulnerable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_invulnerable:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_invulnerable:OnCreated( kv )
    if IsServer() then
        print( '^^^CANDY BUCKET INVULNERABLE MOD APPLIED!' )
        local nFXGlyph = ParticleManager:CreateParticle( "particles/items_fx/glyph.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXGlyph, 1, Vector( self:GetParent():GetModelRadius(), 0, 0 ) )
        self:AddParticle( nFXGlyph, false, false, -1, false, false )
		UpdateNetTableValueProperty( "candy_buckets", self:GetParent():GetName(), "is_invulnerable", true )
    end
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_invulnerable:OnDestroy()
    if IsServer() then
		UpdateNetTableValueProperty( "candy_buckets", self:GetParent():GetName(), "is_invulnerable", false )
    end
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_invulnerable:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
	}

	return state
end
