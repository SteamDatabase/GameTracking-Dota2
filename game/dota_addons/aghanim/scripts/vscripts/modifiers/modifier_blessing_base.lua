
require( "blessings" )

modifier_blessing_base = class({})

-----------------------------------------------------------------------------------------

function modifier_blessing_base:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_blessing_base:IsPermanent()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_blessing_base:IsBlessing()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_base:GetTexture()
	return self:GetName()
end

----------------------------------------

function modifier_blessing_base:OnCreated( kv )
	self:SetHasCustomTransmitterData( true )
	if IsServer() == true then
		self.nBlessingLevel = kv.blessing_level
		self:InvokeBlessingOnCreated()
	end
end

----------------------------------------

function modifier_blessing_base:InvokeBlessingOnCreated( )

--	local kv = BLESSING_MODIFIERS[ self:GetName() ].keys
--
--	-- Allow you to specify different keys for each claim level
--	if #kv > 0 then
--		local nIndex = self.nBlessingLevel
--		if nIndex > #kv then
--			nIndex = #kv
--		end	
--		kv = kv[ nIndex ]
--	end

	self:OnBlessingCreated( kv )

end

----------------------------------------

function modifier_blessing_base:OnBlessingCreated( kv )
	-- Derived classes should modify this
end

--------------------------------------------------------------------------------

function modifier_blessing_base:AddCustomTransmitterData( )
	return
	{
		armor = self.nBlessingLevel
	}
end

--------------------------------------------------------------------------------

function modifier_blessing_base:HandleCustomTransmitterData( data )
	if data.armor ~= nil and self.nBlessingLevel ~= data.armor then
		self.nBlessingLevel = data.armor
		self:InvokeBlessingOnCreated()
	end
end
