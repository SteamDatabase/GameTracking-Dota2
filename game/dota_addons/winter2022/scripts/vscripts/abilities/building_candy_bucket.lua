if building_candy_bucket == nil then
	building_candy_bucket = class({})
end

LinkLuaModifier( "modifier_building_candy_bucket", "modifiers/gameplay/modifier_building_candy_bucket", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eat_regen", "modifiers/gameplay/modifier_candy_eat_regen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_eaten_recently", "modifiers/gameplay/modifier_candy_eaten_recently", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_building_roshan_attacking", "modifiers/gameplay/modifier_building_roshan_attacking", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function building_candy_bucket:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function building_candy_bucket:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function building_candy_bucket:GetIntrinsicModifierName()
	return "modifier_building_candy_bucket"
end

--------------------------------------------------------------------------------

function building_candy_bucket:GetCandy()
	return self:GetCaster():GetModifierStackCount( "modifier_building_candy_bucket", nil )
end

--------------------------------------------------------------------------------

function building_candy_bucket:Precache( context )
	--CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), { candy_channel_time = 0.0 } )
	PrecacheResource( "particle", "particles/hw_fx/candy_carrying_building_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/ui_mouseactions/range_finder_tower_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/hw_candy_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/bottle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", context )
end

--------------------------------------------------------------------------------

function building_candy_bucket:GetCandyLimitRaw()
	local limitHome = 50
	local limitT1 = 20
	local limitT2 = 30
	if IsServer() then
		limitHome = _G.WINTER2022_OFFENSIVE_CANDY_LIMIT_HOME_BUCKET
		limitT1 = _G.WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_1
		limitT2 = _G.WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_2
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" );
		if serverConstants ~= nil then
			limitHome = serverConstants[ "WINTER2022_OFFENSIVE_CANDY_LIMIT_HOME_BUCKET" ]
			limitT1 = serverConstants[ "WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_1" ]
			limitT2 = serverConstants[ "WINTER2022_OFFENSIVE_CANDY_LIMIT_TIER_2" ]
		end
	end
	local nCandyLimit = limitHome
	if string.find( self:GetCaster():GetName(), "1" ) ~= nil then
		--print( 'CANDY INTO A TIER 1!' )
		nCandyLimit = limitT1
	elseif string.find( self:GetCaster():GetName(), "2" ) ~= nil then
		--print( 'CANDY INTO A TIER 2!' )
		nCandyLimit = limitT2
	end

	return nCandyLimit
end

--------------------------------------------------------------------------------

function building_candy_bucket:GetCandyLimit()
	local nCandyLimit = self:GetCaster():GetHealth() - 1 + self:GetCandy()

	return nCandyLimit
end

--------------------------------------------------------------------------------

function building_candy_bucket:SetCandy( nCandy )
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return nCandy
		end

		printf( "SetCandy to %d", nCandy )
		local nRemainder = 0
		local nOldCandy = self:GetCandy()

		--[[local nCandyLimit = self:GetCandyLimit()

		if nCandy > nCandyLimit then
			printf( "Building %s will have more candy than its candy limit (%d)!", self:GetCaster():GetName(), nCandyLimit )
			nRemainder = nCandy - nCandyLimit
			nCandy = nCandyLimit
		end--]]

		self:GetCaster():SetModifierStackCount( "modifier_building_candy_bucket", nil, nCandy )
		UpdateNetTableValueProperty( "candy_buckets", self:GetCaster():GetName(), "total_candy", nCandy )

		if nCandy > nOldCandy then
			local nCandyAdded = nCandy - nOldCandy
			--self:GetCaster():SetHealth( self:GetCaster():GetHealth() - nCandyAdded )
		end

		--[[if nCandy >= nCandyLimit then
			if GameRules.Winter2022:OnLastWellMaybeDestroyed( self:GetCaster() ) then
				return 0
			end
			GameRules.Winter2022:BucketFull()
		end--]]

		-- Don't run this when Roshan is attacking.
		-- This *also* doesn't run on round end if we decrease candy count,
		-- so we do it manually elsewhere.
		if nCandy > nOldCandy then
			self:PingCandyBucket()
			GameRules.Winter2022:RecordCandyScored( self:GetCaster(), nCandy )
		end

		GameRules.Winter2022:UpdateCandyLeaderBuilding( true )

		return nRemainder
	end
end

function building_candy_bucket:PingCandyBucket( hScoringHero )
	if self:GetCaster():GetUnitName() == "home_candy_bucket" then
		local bSpeak = false
		if self:GetCaster():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if GameRules.Winter2022._buildingHomeHurtTimerRadiant == nil or GameRules.Winter2022._buildingHomeHurtTimerRadiant < GameRules:GetGameTime() then
				GameRules:ExecuteTeamPing( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin().x, self:GetCaster():GetOrigin().y, self:GetCaster(), 0 )
				GameRules.Winter2022._buildingHomeHurtTimerRadiant = GameRules:GetGameTime() + _G.WINTER2022_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
				bSpeak = true
			end
		else
			if GameRules.Winter2022._buildingHomeHurtTimerDire == nil or GameRules.Winter2022._buildingHomeHurtTimerDire < GameRules:GetGameTime() then
				GameRules:ExecuteTeamPing( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin().x, self:GetCaster():GetOrigin().y, self:GetCaster(), 0 )
				GameRules.Winter2022._buildingHomeHurtTimerDire = GameRules:GetGameTime() + _G.WINTER2022_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
				bSpeak = true
			end
		end
		if bSpeak == true then
			GameRules.Winter2022:GetTeamAnnouncer( self:GetCaster():GetTeamNumber() ):OnBucketAttacked()
			FireGameEvent( "candy_bucket_attacked", {
				team = self:GetCaster():GetTeamNumber(),
			 } )
		end
	else
		-- outlying building
		local bPlay = false
		if self:GetCaster():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if GameRules.Winter2022._buildingHurtTimerRadiant == nil or GameRules.Winter2022._buildingHurtTimerRadiant < GameRules:GetGameTime() then
				GameRules.Winter2022._buildingHurtTimerRadiant = GameRules:GetGameTime() + _G.WINTER2022_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
				bPlay = true
			end
		else
			if GameRules.Winter2022._buildingHurtTimerDire == nil or GameRules.Winter2022._buildingHurtTimerDire < GameRules:GetGameTime() then
				GameRules.Winter2022._buildingHurtTimerDire = GameRules:GetGameTime() + _G.WINTER2022_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
				bPlay = true
			end
		end
		if bPlay == true then
			GameRules:ExecuteTeamPing( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin().x, self:GetCaster():GetOrigin().y, self:GetCaster(), 0 )
			GameRules.Winter2022:GetTeamAnnouncer( self:GetCaster():GetTeamNumber() ):OnWellAttacked()

			-- call well attacked enemy for each ally hero that is not the caster - if we're dunking the candy we don't need to know about it
			if hScoringHero ~= nil then
				local nFlippedTeam = FlipTeamNumber( self:GetCaster():GetTeamNumber() )
				for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
					if PlayerResource:GetTeam( nPlayerID ) == nFlippedTeam then
						local hTeammateHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
						if hTeammateHero ~= nil and hTeammateHero:IsNull() == false and hTeammateHero ~= hScoringHero then
							print( 'TEAMMATE FOUND - ' .. hTeammateHero:GetUnitName() )
							GameRules.Winter2022:GetTeamAnnouncer( nFlippedTeam ):OnWellAttackedEnemy( hTeammateHero:GetPlayerID() )
						end
					end
				end
			end
		end
	end
end
