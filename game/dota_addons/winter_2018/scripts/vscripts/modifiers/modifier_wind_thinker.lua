modifier_wind_thinker = class({})

--------------------------------------------------------------------------------

function modifier_wind_thinker:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_wind_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_wind_thinker:GetModifierAura()
	return "modifier_wind"
end

--------------------------------------------------------------------------------

function modifier_wind_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_wind_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_wind_thinker:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end


function modifier_wind_thinker:OnCreated( kv )
	self:StartIntervalThink( 0.5 )
	-- eww
	_G.GLOBAL_WIND_THINKER = self
	self.vWindDirection = Vector(1,1,0)
	self.flWindSpeed = 100	
	self.flLastWindTime = -9999
end

function modifier_wind_thinker:OnIntervalThink()
	if IsServer() then

		local flNow = GameRules:GetGameTime()
		if (flNow - self.flLastWindTime) > 30 then
			self.flWindSpeed = RandomInt(40, 120)
			self.vWindDirection = RandomVector(1)
			local vWindVector = 5*self.flWindSpeed * self.vWindDirection 
			--printf("setting vector to %s", vWindVector)
			GameRules:SetWeatherWindDirection( vWindVector )
			self.flLastWindTime = flNow
		end
		
		return 0.5
	end
end

--------------------------------------------------------------------------------

