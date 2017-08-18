
ogre_seal_surprise_smash = class({})

LinkLuaModifier( "modifier_ogre_seal_surprise_smash", "modifiers/modifier_ogre_seal_surprise_smash", LUA_MODIFIER_MOTION_BOTH )

-----------------------------------------------------------------------------

function ogre_seal_surprise_smash:OnAbilityPhaseStart()
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_ogre_seal_surprise_passive" ) ~= nil then
			self:GetCaster():RemoveModifierByName("modifier_ogre_seal_surprise_passive" )
			local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
			vToTarget = vToTarget:Normalized()
			local vLocation = self:GetCaster():GetOrigin() + vToTarget * 200
			local kv =
			{
				vLocX = vLocation.x,
				vLocY = vLocation.y,
				vLocZ = vLocation.z
			}
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ogre_seal_surprise_smash", kv)
		else
			return false
		end
		
	end
	return true
end

-----------------------------------------------------------------------------

function ogre_seal_surprise_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function ogre_seal_surprise_smash:GetPlaybackRateOverride()
	return 0.8
end

-----------------------------------------------------------------------------

function ogre_seal_surprise_smash:OnSpellStart()
	if IsServer() then
		
	end
end

-----------------------------------------------------------------------------

