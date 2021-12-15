aghsfort_naga_siren_mirror_image = class({})

--------------------------------------------------------------------------------

function aghsfort_naga_siren_mirror_image:Precache( context )

end

--------------------------------------------------------------------------------

function aghsfort_naga_siren_mirror_image:OnSpellStart()
	print("Mirror Image")
	local caster = self:GetCaster()
	local vPos = caster:GetOrigin()

	local effect_name = "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
	local hEffects = ParticleManager:CreateParticle( effect_name, PATTACH_CUSTOMORIGIN, caster )
	caster:SetContextThink( "KillEffects", function() return self:KillEffects( hEffects ) end, 2 )
	EmitSoundOn( "Hero_NagaSiren.MirrorImage", self:GetCaster() )
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )

 	local illusion_name = "npc_dota_creature_naga_siren_illusion"
	local illusion_origin = vPos
	local illusion = CreateUnitByName(illusion_name, illusion_origin, true, caster, nil, DOTA_TEAM_BADGUYS)
 	illusion:SetInitialGoalEntity( enemies )

end

--------------------------------------------------------------------------------

function aghsfort_naga_siren_mirror_image:KillEffects( hEffects )
	if hEffects ~= nil then
		ParticleManager:DestroyParticle( hEffects, false )
	end
end

--------------------------------------------------------------------------------