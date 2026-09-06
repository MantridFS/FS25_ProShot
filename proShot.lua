--[[
Author: Mantrid
https://fs.mantrid.net/
Developed with assistance from ChatGPT, under strict sentient-monkey supervision. All planning, decisions, and testing were the responsibility of the monkey. ChatGPT takes no responsibility for any of that.
Copyright: All rights reserved
]]

proShot = {}

proShot.FAVOURITE_SLOT_COUNT = 10
proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT = 8
proShot.EFFECT_SLOT_COUNT = 10
proShot.EFFECT_BUILTIN_SLOT_COUNT = 7
proShot.EFFECT_GROUPS = { "global", "shadows", "midtones", "highlights" }
proShot.EFFECT_PROPERTIES = { "saturation", "contrast", "gamma", "gain" }
proShot.EFFECT_COMPONENTS = { "red", "green", "blue", "scale" }
proShot.EFFECT_BUILTIN_FILES = { "flat", "vibrant", "deep", "cold", "greyscale", "sepiaTone", "phantom" }
proShot.MAX_LOCAL_SNOW_HEIGHT = 1
proShot.MAX_SUN_SIZE = 50
proShot.MAX_MOON_SIZE = 5
proShot.MAX_SKY_GROUND_RGB = 5
proShot.MAX_SKY_GROUND_INTENSITY = 10
proShot.LIGHTING_FINE_INTENSITY_LIMIT = 0.5
proShot.SUN_SIZE_SCALE_BASE = 23000
proShot.MOON_SIZE_SCALE_BASE = 36
-- VehicleSystem reloads asynchronously. Keep ProShot locked for the complete
-- native transaction, then require a deliberate interval before another reload.
proShot.VEHICLE_RELOAD_COOLDOWN_MS = 5000
proShot.VEHICLE_RELOAD_CONTROL_TIMEOUT_MS = 5000
proShot.FOCUS_HOLD_DURATION_MS = 700
-- Photo subjects beyond these ranges are generally too small to compose and
-- make near-horizontal flight-plane intersections impractically distant.
proShot.WILDLIFE_MAX_SPAWN_DISTANCE = 50
proShot.BIRD_MAX_SPAWN_DISTANCE = 50
proShot.WILDLIFE_SURFACE_PROBE_HEIGHT = 2
proShot.WILDLIFE_SURFACE_CLEARANCE = 0.04
proShot.WILDLIFE_OFFSET_MIN = -2
proShot.WILDLIFE_OFFSET_MAX = 2
proShot.WILDLIFE_OFFSET_STEP = 0.01
proShot.FARM_ANIMAL_MAX_SPAWN_DISTANCE = 50
proShot.FARM_ANIMAL_SURFACE_PROBE_HEIGHT = 5
proShot.BIRD_OFFSET_MIN = -50
proShot.BIRD_OFFSET_MAX = 50
proShot.BIRD_MIN_GROUND_CLEARANCE = 0.1
proShot.WILDLIFE_ROTATION_STEP_DEGREES = 5
-- The blend-shape shader multiplies both time and animOffset by playback
-- speed, so an exact speed of zero collapses every crow onto frame zero. A
-- tiny compensated speed preserves a distinct, effectively stationary phase.
proShot.CROW_FROZEN_ANIMATION_SPEED = 0.001
-- SnowSystem converts metres to whole density-map layers, so a linear metre
-- slider contains many values that produce exactly the same edit. Adding and
-- removing also reach their useful limits at different values. Present five
-- honest speed levels and calibrate each direction independently instead.
proShot.LOCAL_SNOW_STRENGTH_LEVELS = {
	{ add = 0.065, remove = 0.030 },
	{ add = 0.080, remove = 0.035 },
	{ add = 0.095, remove = 0.070 },
	{ add = 0.110, remove = 0.105 },
	{ add = 0.130, remove = 0.145 }
}
proShot.LOCAL_SNOW_DEFAULT_STRENGTH_LEVEL = 1
proShot.LOCAL_SNOW_MIN_RADIUS = 1
proShot.LOCAL_SNOW_MAX_RADIUS = 100
proShot.TONE_MAPPING_FIELDS = { "slope", "toe", "shoulder", "blackClip", "whiteClip" }
proShot.GRID_AIDS = { "off", "thirds", "goldenRatio", "centre", "diagonals", "diagonalMethod", "goldenTriangles" }
proShot.GRID_AID_TEXT_KEYS = {
	off = "ui_off"
}
proShot.ASPECT_AIDS = {
	{ "off", nil },
	{ "16:9", 16 / 9 },
	{ "2.39:1", 2.39 },
	{ "1:1", 1 },
	{ "4:5", 4 / 5 },
	{ "2:3", 2 / 3 },
	{ "9:16", 9 / 16 }
}
proShot.FAVOURITE_FIELDS = {
	{ "viewDistance", "float" },
	{ "lodDistance", "float" },
	{ "terrainLodDistance", "float" },
	{ "foliageViewDistance", "float" },
	{ "fov", "float" },
	{ "sunRotX", "float" },
	{ "sunRotY", "float" },
	{ "sunRotZ", "float" },
	{ "sunRed", "float" },
	{ "sunGreen", "float" },
	{ "sunBlue", "float" },
	{ "sunIntensity", "float" },
	{ "sunColourTemp", "int" },
	{ "sunColourTempIsPreset", "bool" },
	{ "exposureKey", "float" },
	{ "exposureMin", "float" },
	{ "exposureMax", "float" },
	{ "sunSizeScale", "float" },
	{ "moonSizeScale", "float" },
	{ "atmosphere", "float" },
	{ "colourGradingSelection", "int" },
	{ "bloomMagnitude", "float" },
	{ "bloomThreshold", "float" },
	{ "bloomQuality", "float" },
	{ "ssaoQuality", "int" },
	{ "dofNearCoC", "float" },
	{ "dofNearBlurEnd", "float" },
	{ "dofFarCoC", "float" },
	{ "dofFarBlurStart", "float" },
	{ "dofFarBlurEnd", "float" },
	{ "dofApplyToSky", "bool" },
	{ "dayTime", "float" },
	{ "visualPeriod", "int" },
	{ "seasonTweak", "float" },
	{ "weatherName", "string" },
	{ "weatherVariation", "int" },
	{ "frost", "float" },
	{ "snowLevel", "float" },
	{ "flashVisible", "bool" },
	{ "flashConeAngle", "float" },
	{ "flashDropOff", "float" },
	{ "flashRange", "float" },
	{ "flashIntensity", "float" },
	{ "flashRed", "float" },
	{ "flashGreen", "float" },
	{ "flashBlue", "float" },
	{ "flashColourTemp", "int" },
	{ "flashColourTempIsPreset", "bool" },
	{ "toneSlope", "float" },
	{ "toneToe", "float" },
	{ "toneShoulder", "float" },
	{ "toneBlackClip", "float" },
	{ "toneWhiteClip", "float" },
	{ "fogDensity", "float" },
	{ "hazeDensity", "float" },
	{ "fogCoverageEdge0", "float" },
	{ "fogCoverageEdge1", "float" },
	{ "fogExtraHeight", "float" },
	{ "fogMinValleyDepth", "float" },
	{ "groundWetness", "float" },
	{ "skyRed", "float" },
	{ "skyGreen", "float" },
	{ "skyBlue", "float" },
	{ "skyIntensity", "float" },
	{ "skyColourTemp", "int" },
	{ "skyColourTempIsPreset", "bool" }
}
table.insert(proShot.FAVOURITE_FIELDS, { "effectShadowsMaxLuminance", "float" })
table.insert(proShot.FAVOURITE_FIELDS, { "effectHighlightsMinLuminance", "float" })
table.insert(proShot.FAVOURITE_FIELDS, { "effectEditorDirty", "bool" })
for _, group in ipairs(proShot.EFFECT_GROUPS) do
	for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
		for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
			table.insert(proShot.FAVOURITE_FIELDS, { string.format("effect_%s_%s_%s", group, property, component), "float" })
		end
	end
end

proShot.FAVOURITE_GROUPS = {
	{ key = "camera", textKey = "proShot_favourite_group_camera" },
	{ key = "quality", textKey = "setting_quality" },
	{ key = "sky", textKey = "proShot_favourite_group_sky" },
	{ key = "groundLight", textKey = "proShot_favourite_group_groundLight" },
	{ key = "effects", textKey = "proShot_favourite_group_effects" },
	{ key = "season", textKey = "proShot_favourite_group_season" },
	{ key = "weather", textKey = "proShot_favourite_group_weather" },
	{ key = "time", textKey = "introduction_timeInfo" }
}

proShot.FAVOURITE_FIELD_GROUP = {}
local function assignFavouriteFields(group, names)
	for _, name in ipairs(names) do
		proShot.FAVOURITE_FIELD_GROUP[name] = group
	end
end
assignFavouriteFields("quality", { "viewDistance", "lodDistance", "terrainLodDistance", "foliageViewDistance" })
assignFavouriteFields("camera", { "fov", "exposureKey", "exposureMin", "exposureMax" })
assignFavouriteFields("groundLight", { "sunRotX", "sunRotY", "sunRotZ", "sunRed", "sunGreen", "sunBlue", "sunIntensity", "sunColourTemp", "sunColourTempIsPreset" })
assignFavouriteFields("sky", { "sunSizeScale", "moonSizeScale", "atmosphere", "skyRed", "skyGreen", "skyBlue", "skyIntensity", "skyColourTemp", "skyColourTempIsPreset" })
assignFavouriteFields("effects", { "colourGradingSelection", "bloomMagnitude", "bloomThreshold", "bloomQuality", "ssaoQuality", "toneSlope", "toneToe", "toneShoulder", "toneBlackClip", "toneWhiteClip", "effectShadowsMaxLuminance", "effectHighlightsMinLuminance", "effectEditorDirty" })
assignFavouriteFields("dof", { "dofNearCoC", "dofNearBlurEnd", "dofFarCoC", "dofFarBlurStart", "dofFarBlurEnd", "dofApplyToSky" })
assignFavouriteFields("season", { "visualPeriod", "seasonTweak", "frost", "snowLevel" })
assignFavouriteFields("weather", { "weatherName", "weatherVariation", "fogDensity", "hazeDensity", "fogCoverageEdge0", "fogCoverageEdge1", "fogExtraHeight", "fogMinValleyDepth", "groundWetness" })
assignFavouriteFields("time", { "dayTime" })
assignFavouriteFields("flashlight", { "flashVisible", "flashConeAngle", "flashDropOff", "flashRange", "flashIntensity", "flashRed", "flashGreen", "flashBlue", "flashColourTemp", "flashColourTempIsPreset" })
for _, group in ipairs(proShot.EFFECT_GROUPS) do
	for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
		for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
			proShot.FAVOURITE_FIELD_GROUP[string.format("effect_%s_%s_%s", group, property, component)] = "effects"
		end
	end
end

proShot.INFO_COLOR = {
	ACTIVE = { 0.32, 0.83, 0.2, 1 },
	BLUE = { 0.36, 0.65, 1, 1 },
	RED = { 1, 0.35, 0.3, 1 },
	GREEN = { 0.35, 1, 0.4, 1 },
	HIGHLIGHT = { 1, 0.82, 0.16, 1 },
	WARM = { 1, 0.76, 0.3, 1 },
	MUTED = { 0.72, 0.76, 0.8, 1 }
}

function proShot:getHudVisible()
	local hud = g_currentMission ~= nil and g_currentMission.hud or nil
	return hud ~= nil and hud:getIsVisible() or false
end

function proShot:setHudVisible(isVisible, updateNoHudMode)
	local hud = g_currentMission ~= nil and g_currentMission.hud or nil
	if hud == nil then
		return false
	end
	hud:setIsVisible(isVisible)
	if updateNoHudMode then
		g_noHudModeEnabled = not isVisible
	end
	return true
end

function proShot:setDoFState(state)
	if type(state) ~= "table" or #state < 6 or g_depthOfFieldManager == nil then
		return false
	end
	proShot.DoFState = table.clone(state)
	-- FS25 renders foreground/near DoF only at quality level 2. Its own
	-- gsDepthOfFieldSetNearParams command makes the same switch.
	setDofQuality(2)
	-- FS25 owns active camera DoF through DepthOfFieldManager. Going through the
	-- manager keeps ProShot compatible with camera switches and camera reloads.
	g_depthOfFieldManager:setManipulatedParams(unpack(proShot.DoFState))
	return true
end

function proShot:setSnowShader(value)
	-- FS25 keeps user-forced frost separate from the simulated snow value.
	g_currentMission.snowSystem:consoleCommandSetSnowShader(math.clamp(value, 0, 1))
end

function proShot:clampSunSizeScale(scale)
	return math.max(scale, proShot.SUN_SIZE_SCALE_BASE / (proShot.MAX_SUN_SIZE * proShot.MAX_SUN_SIZE))
end

function proShot:clampMoonSizeScale(scale)
	return math.max(scale, proShot.MOON_SIZE_SCALE_BASE / (proShot.MAX_MOON_SIZE * proShot.MAX_MOON_SIZE))
end

function proShot:getCurrentWeatherName()
	local env = g_currentMission ~= nil and g_currentMission.environment or nil
	if env == nil or env.weather == nil then
		return "SUN"
	end
	local weatherType = env.weather:getWeatherTypeAtTime(env.currentMonotonicDay, env.dayTime)
	if weatherType == nil then
		return "SUN"
	end
	return WeatherType.getName(weatherType) or "SUN"
end

function proShot:getWeatherDisplayName(weatherName)
	local textKey = "proShot_weather_" .. tostring(weatherName)
	if g_i18n:hasText(textKey) then
		return g_i18n:getText(textKey)
	end
	-- Maps can expose weather types for which ProShot has no dedicated label.
	return tostring(weatherName)
end

function proShot:captureToneMapping()
	return {
		slope = getToneMappingCurveSlope(),
		toe = getToneMappingCurveToe(),
		shoulder = getToneMappingCurveShoulder(),
		blackClip = getToneMappingCurveBlackClip(),
		whiteClip = getToneMappingCurveWhiteClip()
	}
end

function proShot:applyToneMapping(state)
	if state == nil then
		return false
	end
	setToneMappingCurveSlope(state.slope)
	setToneMappingCurveToe(state.toe)
	setToneMappingCurveShoulder(state.shoulder)
	setToneMappingCurveBlackClip(state.blackClip)
	setToneMappingCurveWhiteClip(state.whiteClip)
	if proShot.toneMappingState ~= state then
		proShot.toneMappingState = table.clone(state)
	end
	return true
end

function proShot:getFogUpdater()
	local env = g_currentMission ~= nil and g_currentMission.environment or nil
	return env ~= nil and env.weather ~= nil and env.weather.fogUpdater or nil
end

local function debugNumber(value)
	return type(value) == "number" and string.format("%.6f", value) or tostring(value)
end

function proShot:getCurrentExposureRange()
	if type(getExposureRange) ~= "function" then
		return nil, nil, nil
	end
	-- FS25's getter returns the EV limits in max/min order even though
	-- setExposureRange and the Lighting classes use min/max order.
	local ok, keyValue, maxExposure, minExposure = pcall(getExposureRange)
	if not ok then
		return nil, nil, nil
	end
	return keyValue, minExposure, maxExposure
end

function proShot:debugLog(message, ...)
	if not proShot.debugEnabled then
		return
	end
	local formatted = select("#", ...) > 0 and string.format(message, ...) or tostring(message)
	Logging.info("ProShot Debug: %s", formatted)
end

function proShot:debugLogLiveState(label)
	if not proShot.debugEnabled then
		return
	end
	local mission = g_currentMission
	local env = mission ~= nil and mission.environment or nil
	if env == nil then
		proShot:debugLog("%s | no active environment", tostring(label))
		return
	end

	local exposureKey, exposureMin, exposureMax = proShot:getCurrentExposureRange()
	local tone = proShot:captureToneMapping()
	local sunRed, sunGreen, sunBlue
	if proShot.sun ~= nil and proShot.sun.lightNode ~= nil and proShot.sun.lightNode ~= 0
		and entityExists(proShot.sun.lightNode) then
		sunRed, sunGreen, sunBlue = getLightColor(proShot.sun.lightNode)
	end
	local sky = proShot.skyState
	local fog = proShot.fogState
	local weatherItem = env.weather ~= nil and env.weather.forecastItems ~= nil
		and env.weather.forecastItems[1] or nil

	proShot:debugLog(
		"%s | time=%s period=%s weather=%s variation=%s lighting=%s baseLighting=%s selection=%s dirty=%s",
		tostring(label), debugNumber(env.dayTime), tostring(env.currentVisualPeriod),
		proShot:getCurrentWeatherName(), tostring(weatherItem ~= nil and weatherItem.variationIndex or nil),
		tostring(env.lighting), tostring(env.baseLighting), tostring(proShot.colourGradingSelection),
		tostring(proShot.effectEditorDirty))
	proShot:debugLog(
		"%s | exposure live=(key=%s min=%s max=%s) tracked=(key=%s min=%s max=%s)",
		tostring(label), debugNumber(exposureKey), debugNumber(exposureMin), debugNumber(exposureMax),
		debugNumber(proShot.exposureKeyValue), debugNumber(proShot.exposureMinValue),
		debugNumber(proShot.exposureMaxValue))
	proShot:debugLog(
		"%s | tone=(slope=%s toe=%s shoulder=%s black=%s white=%s) bloom=(magnitude=%s threshold=%s quality=%s) ssao=%s",
		tostring(label), debugNumber(tone.slope), debugNumber(tone.toe), debugNumber(tone.shoulder),
		debugNumber(tone.blackClip), debugNumber(tone.whiteClip), debugNumber(getBloomMagnitude()),
		debugNumber(getBloomMaskThreshold()), debugNumber(getBloomQuality()), debugNumber(getSSAOQuality()))
	proShot:debugLog(
		"%s | groundLight=(rgb=%s,%s,%s intensity=%s) sky=(rgb=%s,%s,%s intensity=%s) fog=(density=%s haze=%s)",
		tostring(label), debugNumber(sunRed), debugNumber(sunGreen), debugNumber(sunBlue),
		debugNumber(proShot.sun ~= nil and proShot.sun.intensity or nil),
		debugNumber(sky ~= nil and sky.red or nil), debugNumber(sky ~= nil and sky.green or nil),
		debugNumber(sky ~= nil and sky.blue or nil), debugNumber(sky ~= nil and sky.intensity or nil),
		debugNumber(proShot.fogDensityValue), debugNumber(fog ~= nil and fog.heightFogGroundLevelDensity or nil))
	local snowSystem = g_currentMission ~= nil and g_currentMission.snowSystem or nil
	proShot:debugLog(
		"%s | snow=(weather=%s exact=%s physical=%s tracked=%s localEdited=%s applying=%s queued=%s)",
		tostring(label), debugNumber(env.weather ~= nil and env.weather.snowHeight or nil),
		debugNumber(snowSystem ~= nil and snowSystem.exactHeight or nil),
		debugNumber(snowSystem ~= nil and snowSystem.height or nil), debugNumber(proShot.snowLevel),
		tostring(proShot.localSnowEdited == true),
		debugNumber(snowSystem ~= nil and snowSystem.currentApplyingDelta or nil),
		debugNumber(snowSystem ~= nil and type(snowSystem.updateQueue) == "table" and #snowSystem.updateQueue or nil))
end

function proShot:debugLogSettings(label, settings)
	if not proShot.debugEnabled or type(settings) ~= "table" then
		return
	end
	local groups = {}
	for _, group in ipairs(proShot.FAVOURITE_GROUPS) do
		if proShot:snapshotIncludesGroup(settings, group.key) then
			table.insert(groups, group.key)
		end
	end
	proShot:debugLog(
		"%s | name='%s' groups=%s exposure=(key=%s min=%s max=%s) time=%s weather=%s/%s grading=%s dirty=%s",
		tostring(label), tostring(settings.name or ""), table.concat(groups, ","),
		debugNumber(settings.exposureKey), debugNumber(settings.exposureMin), debugNumber(settings.exposureMax),
		debugNumber(settings.dayTime), tostring(settings.weatherName), tostring(settings.weatherVariation),
		tostring(settings.colourGradingSelection), tostring(settings.effectEditorDirty))
end

function proShot:consoleCommandDebug(enabled)
	local argument = string.lower(tostring(enabled or ""))
	if argument == "" then
		proShot.debugEnabled = not proShot.debugEnabled
	elseif argument == "true" or argument == "1" or argument == "on" then
		proShot.debugEnabled = true
	elseif argument == "false" or argument == "0" or argument == "off" then
		proShot.debugEnabled = false
	else
		return "Usage: psDebug [true|false]"
	end

	if proShot.debugEnabled then
		proShot:debugLogLiveState("debug enabled")
		return "ProShot debug logging enabled"
	end
	return "ProShot debug logging disabled"
end

function proShot:applyFogEngine(state)
	if state == nil then
		return
	end
	setGroundFogGlobalCoverage(state.groundFogCoverageEdge0, state.groundFogCoverageEdge1)
	setGroundFogHeight(state.groundFogExtraHeight)
	setGroundFogGroundLevelDensity(state.groundFogGroundLevelDensity)
	setGroundFogMinimumValleyDepth(state.groundFogMinValleyDepth)
	setHeightFogGroundLevelDensity(state.heightFogGroundLevelDensity)
	setHeightFogMaxHeight(state.heightFogMaxHeight)
end

function proShot:applyFogState(state)
	local updater = proShot:getFogUpdater()
	if updater == nil or state == nil then
		return
	end
	-- FogUpdater normally rewrites these engine values as weather evolves. Debug
	-- mode is the native FS25 mechanism for holding a photographic override.
	updater.isDebugEnabled = true
	proShot.fogState = state:clone()
	proShot:applyFogEngine(proShot.fogState)
end

function proShot:createPausedFogState(updater)
	if updater == nil or updater.currentFog == nil then
		return nil
	end
	local state = updater.currentFog:clone()
	if not updater.isDebugEnabled then
		-- FS25 fades ground fog by moving its coverage thresholds towards 1; the
		-- configured density can remain non-zero while no fog is visible. Freeze
		-- the exact effective thresholds used by FogUpdater so pausing never
		-- reveals that latent weather configuration.
		local visibilityAlpha = math.clamp(updater.visibilityAlpha or 1, 0, 1)
		state.groundFogCoverageEdge0 = MathUtil.lerp(1, state.groundFogCoverageEdge0, visibilityAlpha)
		state.groundFogCoverageEdge1 = MathUtil.lerp(1, state.groundFogCoverageEdge1, visibilityAlpha)
	end
	return state
end

function proShot:resetFogMenuState()
	local fwyc = proShot.fromWhenceYouCame
	if fwyc == nil or fwyc.pausedFogState == nil or fwyc.fogState == nil then
		return
	end
	proShot.fogDensityValue = fwyc.pausedFogDensityValue
	proShot.fogOverrideCoverageEdge0 = fwyc.fogState.groundFogCoverageEdge0
	proShot.fogOverrideCoverageEdge1 = fwyc.fogState.groundFogCoverageEdge1
	proShot.fogOverrideActive = false
	proShot:applyFogState(fwyc.pausedFogState)
end

function proShot:applyGroundWetness(value)
	local weather = g_currentMission ~= nil and g_currentMission.environment ~= nil
		and g_currentMission.environment.weather or nil
	if weather == nil then
		return false
	end
	value = math.clamp(value, 0, 1)
	weather.groundWetness = value
	proShot.testingGroundWetness = value
	setWetness(value)
	-- Match Weather:update so the terrain displacement and surface shader remain
	-- visually consistent while the game simulation is paused.
	setTerrainDisplacementWetness(g_terrainNode, math.max(0, value - 0.15) / 0.85)
	return true
end

function proShot:restoreGroundWetness()
	local fwyc = proShot.fromWhenceYouCame
	local weather = g_currentMission ~= nil and g_currentMission.environment ~= nil
		and g_currentMission.environment.weather or nil
	if weather == nil or fwyc.groundWetness == nil then
		return
	end
	weather.groundWetness = fwyc.groundWetness
	local renderWetness = fwyc.renderWetness or fwyc.groundWetness
	setWetness(renderWetness)
	setTerrainDisplacementWetness(g_terrainNode, math.max(0, renderWetness - 0.15) / 0.85)
	proShot.testingGroundWetness = renderWetness
end

function proShot:getTrafficSystem()
	return g_currentMission ~= nil and g_currentMission.getTrafficSystem ~= nil
		and g_currentMission:getTrafficSystem() or nil
end

function proShot:getPedestrianSystem()
	return g_currentMission ~= nil and g_currentMission.getPedestrianSystem ~= nil
		and g_currentMission:getPedestrianSystem() or nil
end

function proShot:applyPedestrianTimeScale(pedestrians, timeScale)
	if pedestrians == nil or pedestrians.pedestrianSystemId == nil
		or setPedestrianSystemTimeScale == nil then
		return false
	end
	local ok, err = pcall(setPedestrianSystemTimeScale, pedestrians.pedestrianSystemId, timeScale)
	if not ok then
		Logging.warning("ProShot: Pedestrian time-scale change failed: %s", tostring(err))
	end
	return ok
end

function proShot:applyTrafficPaused(traffic, paused)
	if traffic == nil or traffic.trafficSystemId == nil or setTrafficSystemPaused == nil then
		return false
	end
	local ok, err = pcall(setTrafficSystemPaused, traffic.trafficSystemId, paused)
	if not ok then
		Logging.warning("ProShot: Traffic pause change failed: %s", tostring(err))
	end
	return ok
end

function proShot:setTestingTrafficEnabled(enabled)
	local traffic = proShot:getTrafficSystem()
	if traffic == nil then
		return false
	end
	proShot.testingTrafficEnabled = enabled
	traffic:setEnabled(enabled)
	if enabled and proShot.trafficPaused then
		proShot:applyTrafficPaused(traffic, true)
	end
	return true
end

function proShot:setTrafficPaused(paused)
	local traffic = proShot:getTrafficSystem()
	if traffic == nil then
		return false
	end
	if not proShot:applyTrafficPaused(traffic, paused) then
		return false
	end
	proShot.trafficPaused = paused
	return true
end

function proShot:setParkedCarsEnabled(enabled)
	local traffic = proShot:getTrafficSystem()
	if traffic == nil or traffic.trafficSystemId == nil or setTrafficSystemParkedCarsEnabled == nil then
		return false
	end
	local ok, err = pcall(setTrafficSystemParkedCarsEnabled, traffic.trafficSystemId, enabled)
	if not ok then
		Logging.warning("ProShot: Parked traffic visibility change failed: %s", tostring(err))
		return false
	end
	proShot.parkedCarsEnabled = enabled
	return true
end

function proShot:setTestingPedestriansEnabled(enabled)
	local pedestrians = proShot:getPedestrianSystem()
	if pedestrians == nil then
		return false
	end
	pedestrians:setEnabled(enabled)
	proShot.testingPedestriansEnabled = enabled
	if proShot.pedestriansPaused then
		proShot:applyPedestrianTimeScale(pedestrians, 0)
	end
	return true
end

function proShot:setPedestriansPaused(paused)
	local pedestrians = proShot:getPedestrianSystem()
	if not proShot:applyPedestrianTimeScale(pedestrians, paused and 0 or 1) then
		return false
	end
	proShot.pedestriansPaused = paused
	return true
end

function proShot:isFlyBySpecies(species)
	return species ~= nil and species.moveDistancePerMs ~= nil and species.graphics ~= nil
end

function proShot:isBirdSpecies(species)
	if species == nil then
		return false
	end
	-- This menu's bird category is specifically for the native fly-by species.
	-- Ground birds (including the dormant FS25 crow species adapted below) use
	-- the wildlife controls so they can be posed independently of flying flocks.
	if proShot:isFlyBySpecies(species) then
		return true
	end
	local name = string.lower(tostring(species.name or ""))
	return string.find(name, "flyby", 1, true) ~= nil
end

function proShot:getWildlifeDisplayName(species)
	if species == nil then
		return g_i18n:getText("proShot_testing_unavailable")
	end
	local name = tostring(species.name or "Wildlife")
	name = string.gsub(name, "FlyBy", "")
	name = string.gsub(name, "(%l)(%u)", "%1 %2")
	name = string.gsub(name, "_", " ")
	local displayName = string.gsub(name, "^%l", string.upper)
	return displayName
end

function proShot:getWildlifePluralName(species)
	local name = proShot:getWildlifeDisplayName(species)
	if species ~= nil and string.sub(name, -1) ~= "s" then
		name = name .. "s"
	end
	return name
end

-- Farm animals are map-owned data in FS25. Build the selector from the active
-- AnimalSystem so maps and DLC can add breeds without ProShot hard-coding any
-- model paths. Repeated adult entries that share the same visual are collapsed.
function proShot:getFarmAnimalStageDefinition(typeName, subTypeName, stageIndex, stageCount)
	typeName = string.upper(tostring(typeName or ""))
	subTypeName = string.upper(tostring(subTypeName or ""))
	local function selectStage(stages)
		local adjustedIndex = stageIndex
		if stageCount <= 1 then
			adjustedIndex = #stages
		elseif stageCount == 2 and #stages == 3 then
			adjustedIndex = stageIndex == 1 and 1 or 3
		end
		return unpack(stages[math.min(adjustedIndex, #stages)])
	end
	if typeName == "COW" then
		if string.find(subTypeName, "WATERBUFFALO", 1, true) ~= nil then
			local stages = {
				{ "buffaloCalf", "proShot_farm_buffaloCalf", "proShot_farm_menuBuffalo", 4 },
				{ "youngBuffalo", "proShot_farm_youngBuffalo", "proShot_farm_menuBuffalo", 5 },
				{ "waterBuffalo", "proShot_farm_waterBuffalo", "proShot_farm_menuBuffalo", 6 }
			}
			return selectStage(stages)
		end
		local stages = {
			{ "calf", "proShot_farm_calf", "proShot_farm_menuCow", 1 },
			{ "youngCow", "proShot_farm_youngCow", "proShot_farm_menuCow", 2 },
			{ "cow", "proShot_farm_cow", "proShot_farm_menuCow", 3 }
		}
		return selectStage(stages)
	elseif typeName == "PIG" then
		local stages = {
			{ "piglet", "proShot_farm_piglet", "proShot_farm_menuPig", 7 },
			{ "youngPig", "proShot_farm_youngPig", "proShot_farm_menuPig", 8 },
			{ "pig", "proShot_farm_pig", "proShot_farm_menuPig", 9 }
		}
		return selectStage(stages)
	elseif typeName == "SHEEP" then
		if subTypeName == "GOAT" or string.find(subTypeName, "GOAT", 1, true) ~= nil then
			local stages = {
				{ "kid", "proShot_farm_kid", "proShot_farm_menuGoat", 13 },
				{ "youngGoat", "proShot_farm_youngGoat", "proShot_farm_menuGoat", 14 },
				{ "goat", "proShot_farm_goat", "proShot_farm_menuGoat", 15 }
			}
			return selectStage(stages)
		end
		local stages = {
			{ "lamb", "proShot_farm_lamb", "proShot_farm_menuSheep", 10 },
			{ "youngSheep", "proShot_farm_youngSheep", "proShot_farm_menuSheep", 11 },
			{ "sheep", "proShot_farm_sheep", "proShot_farm_menuSheep", 12 }
		}
		return selectStage(stages)
	elseif typeName == "HORSE" then
		return "horse", "proShot_farm_horse", "proShot_farm_menuHorse", 16
	elseif typeName == "CHICKEN" then
		if string.find(subTypeName, "ROOSTER", 1, true) ~= nil then
			return "rooster", "proShot_farm_rooster", "proShot_farm_menuChicken", 19
		elseif stageIndex == 1 and stageCount > 1 then
			return "chick", "proShot_farm_chick", "proShot_farm_menuChicken", 17
		end
		return "hen", "proShot_farm_hen", "proShot_farm_menuChicken", 18
	end
	return string.format("%s_%d", typeName, stageIndex), nil, nil, 1000 + stageIndex
end

function proShot:getFarmAnimalBreedName(subType)
	if subType ~= nil and g_fillTypeManager ~= nil and subType.fillTypeIndex ~= nil then
		local fillType = g_fillTypeManager:getFillTypeByIndex(subType.fillTypeIndex)
		if fillType ~= nil and fillType.title ~= nil and fillType.title ~= "" then
			return fillType.title
		end
	end
	local name = tostring(subType ~= nil and subType.name or "Animal")
	name = string.gsub(string.lower(name), "_", " ")
	return string.gsub(name, "^%l", string.upper)
end

function proShot:buildFarmAnimalChoices()
	local animalSystem = g_currentMission ~= nil and g_currentMission.animalSystem or nil
	local choicesById = {}
	if animalSystem == nil then
		return {}
	end
	for _, animalType in ipairs(animalSystem.types or {}) do
		for _, subTypeIndex in ipairs(animalType.subTypes or {}) do
			local subType = animalSystem:getSubTypeByIndex(subTypeIndex)
			local uniqueVisuals = {}
			local visualKeys = {}
			for _, visual in ipairs(subType ~= nil and subType.visuals or {}) do
				local visualAnimal = visual.visualAnimal
				local filename = visualAnimal ~= nil and visualAnimal.filenamePosed or nil
				local visualKey = string.format("%s:%s", tostring(visual.visualAnimalIndex), tostring(filename))
				if filename ~= nil and filename ~= "" and not visualKeys[visualKey] then
					visualKeys[visualKey] = true
					table.insert(uniqueVisuals, visual)
				end
			end
			for stageIndex, visual in ipairs(uniqueVisuals) do
				local choiceId, textKey, menuTextKey, sortOrder = proShot:getFarmAnimalStageDefinition(
					animalType.name, subType.name, stageIndex, #uniqueVisuals)
				choiceId = string.format("%s:%s", tostring(animalType.name), choiceId)
				local choice = choicesById[choiceId]
				if choice == nil then
					local stageName
					local menuName
					if textKey ~= nil then
						stageName = g_i18n:getText(textKey)
						menuName = g_i18n:getText(menuTextKey)
					else
						local stageKey = stageIndex == #uniqueVisuals and "proShot_farm_stageAdult"
							or (stageIndex == 1 and "proShot_farm_stageBaby" or "proShot_farm_stageYoung")
						menuName = animalType.groupTitle or tostring(animalType.name)
						stageName = string.format(g_i18n:getText("proShot_farm_genericStage"),
							menuName, g_i18n:getText(stageKey))
					end
					choice = {
						id = choiceId,
						displayName = stageName,
						menuName = menuName,
						sortOrder = sortOrder,
						isPreferredDefault = choiceId == "COW:cow",
						variants = {}
					}
					choicesById[choiceId] = choice
				end
				table.insert(choice.variants, {
					subType = subType,
					subTypeIndex = subTypeIndex,
					age = visual.minAge or 0,
					visual = visual,
					breedName = proShot:getFarmAnimalBreedName(subType)
				})
			end
		end
	end
	local choices = {}
	for _, choice in pairs(choicesById) do
		table.sort(choice.variants, function(a, b)
			return tostring(a.breedName) < tostring(b.breedName)
		end)
		table.insert(choices, choice)
	end
	table.sort(choices, function(a, b)
		if a.sortOrder == b.sortOrder then
			return tostring(a.displayName) < tostring(b.displayName)
		end
		return a.sortOrder < b.sortOrder
	end)
	return choices
end

function proShot:initialiseFarmAnimalSelection()
	proShot.farmAnimalChoices = proShot:buildFarmAnimalChoices()
	proShot.selectedFarmAnimalChoiceIndex = math.clamp(proShot.selectedFarmAnimalChoiceIndex or 1,
		1, math.max(#proShot.farmAnimalChoices, 1))
	for index, choice in ipairs(proShot.farmAnimalChoices) do
		if choice.isPreferredDefault then
			proShot.selectedFarmAnimalChoiceIndex = index
			break
		end
	end
	proShot.selectedFarmAnimalVariantIndex = 1
end

function proShot:getSelectedFarmAnimal()
	if proShot.farmAnimalChoices == nil then
		proShot:initialiseFarmAnimalSelection()
	end
	local choices = proShot.farmAnimalChoices or {}
	if #choices == 0 then
		return nil, nil
	end
	proShot.selectedFarmAnimalChoiceIndex = math.clamp(proShot.selectedFarmAnimalChoiceIndex or 1, 1, #choices)
	local choice = choices[proShot.selectedFarmAnimalChoiceIndex]
	proShot.selectedFarmAnimalVariantIndex = math.clamp(proShot.selectedFarmAnimalVariantIndex or 1,
		1, math.max(#choice.variants, 1))
	return choice, choice.variants[proShot.selectedFarmAnimalVariantIndex]
end

function proShot:getSelectedFarmAnimalDetailedName()
	local choice, variant = proShot:getSelectedFarmAnimal()
	if choice == nil then
		return g_i18n:getText("proShot_testing_unavailable")
	end
	if #choice.variants > 1 and variant ~= nil then
		return string.format("%s - %s", choice.displayName, variant.breedName)
	end
	return choice.displayName
end

function proShot:setFarmAnimalPreview(filename)
	if filename == nil or filename == "" then
		if proShot.farmAnimalPreviewOverlay ~= nil then
			proShot.farmAnimalPreviewOverlay:setVisible(false)
		end
		return
	end
	if proShot.farmAnimalPreviewOverlay == nil then
		proShot.farmAnimalPreviewOverlay = Overlay.new(filename, 0, 0, 0.12, 0.22)
	else
		proShot.farmAnimalPreviewOverlay:setImage(filename)
	end
	proShot.farmAnimalPreviewOverlay:setVisible(true)
end

function proShot:drawFarmAnimalPreview()
	if not proShot.farmAnimalDialogOpen or proShot.farmAnimalPreviewOverlay == nil then
		return
	end
	local height = 0.22
	local width = height / g_screenAspectRatio
	local marginX = 8 * g_pixelSizeX
	local marginY = 8 * g_pixelSizeY
	local safeX = g_safeFrameOffsetX or 0.01
	local x = 1 - safeX - width - marginX
	local y = 0.5 - height * 0.5
	local dialog = OptionDialog ~= nil and OptionDialog.INSTANCE or nil
	local dialogElement = dialog ~= nil and dialog.dialogElement or nil
	if dialogElement ~= nil and dialogElement.absPosition ~= nil and dialogElement.absSize ~= nil then
		local right = dialogElement.absPosition[1] + dialogElement.absSize[1]
		local candidate = right + 20 * g_pixelSizeX
		if candidate + width + marginX <= 1 - safeX then
			x = candidate
		else
			local leftCandidate = dialogElement.absPosition[1] - 20 * g_pixelSizeX - width
			if leftCandidate >= safeX + marginX then
				x = leftCandidate
			end
		end
	end
	drawFilledRect(x - marginX, y - marginY, width + marginX * 2, height + marginY * 2,
		0.025, 0.03, 0.035, 0.95)
	drawFilledRect(x - 2 * g_pixelSizeX, y - 2 * g_pixelSizeY,
		width + 4 * g_pixelSizeX, height + 4 * g_pixelSizeY, 0.7, 0.72, 0.74, 1)
	proShot.farmAnimalPreviewOverlay:setPosition(x, y)
	proShot.farmAnimalPreviewOverlay:setDimension(width, height)
	proShot.farmAnimalPreviewOverlay:render()
end

function proShot:restoreFarmAnimalDialogOptionHook()
	local element = proShot.farmAnimalDialogOptionElement
	if element ~= nil then
		element.onClickCallback = proShot.farmAnimalDialogOriginalOptionCallback
	end
	proShot.farmAnimalDialogOptionElement = nil
	proShot.farmAnimalDialogOriginalOptionCallback = nil
end

function proShot:configureFarmAnimalDialogPreview(previewItems, selectedIndex)
	local dialog = OptionDialog ~= nil and OptionDialog.INSTANCE or nil
	if dialog == nil or dialog.optionElement == nil then
		return
	end
	if not dialog.proShotFarmAnimalPreviewHooked then
		dialog.proShotFarmAnimalPreviewHooked = true
		dialog.proShotOriginalDraw = dialog.draw
		dialog.draw = function(dialogSelf, ...)
			dialogSelf.proShotOriginalDraw(dialogSelf, ...)
			proShot:drawFarmAnimalPreview()
		end
	end
	proShot:restoreFarmAnimalDialogOptionHook()
	local element = dialog.optionElement
	local original = element.onClickCallback
	local hasTarget = element.target ~= nil
	proShot.farmAnimalDialogOptionElement = element
	proShot.farmAnimalDialogOriginalOptionCallback = original
	element.onClickCallback = function(...)
		if original ~= nil then
			original(...)
		end
		local first, second = ...
		local state = hasTarget and second or first
		local item = previewItems[state]
		local visual = item ~= nil and item.visual or nil
		proShot:setFarmAnimalPreview(visual ~= nil and visual.store ~= nil and visual.store.imageFilename or nil)
	end
	local item = previewItems[selectedIndex or 1]
	local visual = item ~= nil and item.visual or nil
	proShot:setFarmAnimalPreview(visual ~= nil and visual.store ~= nil and visual.store.imageFilename or nil)
end

function proShot:finishFarmAnimalDialog()
	proShot:restoreFarmAnimalDialogOptionHook()
	proShot.farmAnimalDialogOpen = false
	proShot.favouriteDialogOpen = false
	proShot.captureKeyReleaseRequired = true
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	proShot.menuDesired = "wildlife"
	if proShot.farmAnimalPreviewOverlay ~= nil then
		proShot.farmAnimalPreviewOverlay:delete()
		proShot.farmAnimalPreviewOverlay = nil
	end
	proShot:refreshWildlifeMenu()
end

function proShot:showFarmAnimalChoiceDialog()
	local choices = proShot.farmAnimalChoices or {}
	if #choices == 0 or OptionDialog == nil or OptionDialog.INSTANCE == nil then
		proShot:finishFarmAnimalDialog()
		proShot:showToast(g_i18n:getText("proShot_farm_unavailable"))
		return
	end
	proShot:restoreFarmAnimalDialogOptionHook()
	proShot.farmAnimalDialogOpen = true
	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	local texts = {}
	local previewItems = {}
	for index, choice in ipairs(choices) do
		texts[index] = choice.displayName
		previewItems[index] = choice.variants[1]
	end
	local defaultIndex = math.clamp(proShot.selectedFarmAnimalChoiceIndex or 1, 1, #choices)
	OptionDialog.show(function(selected)
		if selected == nil or selected == 0 then
			proShot:finishFarmAnimalDialog()
			return
		end
		proShot:restoreFarmAnimalDialogOptionHook()
		local choice = choices[selected]
		if choice == nil or #choice.variants == 0 then
			proShot:finishFarmAnimalDialog()
			return
		elseif #choice.variants == 1 then
			proShot.selectedFarmAnimalChoiceIndex = selected
			proShot.selectedFarmAnimalVariantIndex = 1
			proShot.animalAdjustmentMode = "farm"
			proShot:finishFarmAnimalDialog()
			return
		end
		proShot:showFarmAnimalBreedDialog(selected)
	end,
		g_i18n:getText("proShot_farm_selectText"),
		g_i18n:getText("proShot_farm_selectTitle"), texts, defaultIndex)
	proShot:configureFarmAnimalDialogPreview(previewItems, defaultIndex)
end

function proShot:showFarmAnimalBreedDialog(choiceIndex)
	local choice = (proShot.farmAnimalChoices or {})[choiceIndex]
	if choice == nil or #choice.variants == 0 or OptionDialog == nil or OptionDialog.INSTANCE == nil then
		proShot:finishFarmAnimalDialog()
		return
	end
	proShot:restoreFarmAnimalDialogOptionHook()
	local texts = {}
	for index, variant in ipairs(choice.variants) do
		texts[index] = variant.breedName
	end
	local defaultIndex = choiceIndex == proShot.selectedFarmAnimalChoiceIndex
		and math.clamp(proShot.selectedFarmAnimalVariantIndex or 1, 1, #choice.variants) or 1
	OptionDialog.show(function(selected)
		proShot:restoreFarmAnimalDialogOptionHook()
		if selected == nil or selected == 0 then
			proShot:showFarmAnimalChoiceDialog()
			return
		end
		proShot.selectedFarmAnimalChoiceIndex = choiceIndex
		proShot.selectedFarmAnimalVariantIndex = selected
		proShot.animalAdjustmentMode = "farm"
		proShot:finishFarmAnimalDialog()
	end,
		g_i18n:getText("proShot_farm_breedText"),
		g_i18n:getText("proShot_farm_breedTitle"), texts, defaultIndex)
	proShot:configureFarmAnimalDialogPreview(choice.variants, defaultIndex)
end

function proShot:showFarmAnimalSelectionDialog()
	if OptionDialog == nil or OptionDialog.INSTANCE == nil then
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
		return
	end
	proShot.farmAnimalChoices = proShot:buildFarmAnimalChoices()
	if #proShot.farmAnimalChoices == 0 then
		proShot:showToast(g_i18n:getText("proShot_farm_unavailable"))
		return
	end
	proShot:showFarmAnimalChoiceDialog()
end

-- The standard FS25 wildlife list registers only the crow fly-by. The game
-- also ships a complete ground-crow species used by the normal wildlife
-- system, so load it for the photo session and remove it cleanly afterwards.
-- If a map already registered that species, use the map-owned instance.
function proShot:ensureGroundCrowSpecies()
	local manager = g_wildlifeManager
	if manager == nil or manager.loadSpecies == nil or manager.nameToSpecies == nil then
		return nil
	end
	if manager.nameToSpecies.CROW ~= nil then
		return manager.nameToSpecies.CROW
	end

	-- GIANTS ships crow.xml, but it still uses the pre-FS25 animation layout and
	-- cannot be consumed by WildlifeSpeciesSimple in the current game. Load the
	-- equivalent mod-owned FS25 schema adaptation while continuing to reference
	-- the game's crow model and animation opcodes.
	local filename = proShot.modDir .. "xml/wildlife/crow.xml"
	local originalGraphicsLoader = WildlifeInstanceGraphics.loadAttributesTable
	WildlifeInstanceGraphics.loadAttributesTable = function(xmlFile, key)
		return originalGraphicsLoader(xmlFile, key or "species")
	end
	local ok, species = pcall(manager.loadSpecies, manager, filename, proShot.modDir)
	WildlifeInstanceGraphics.loadAttributesTable = originalGraphicsLoader
	if not ok or species == nil then
		Logging.warning("ProShot: Could not load the adapted FS25 ground-crow species: %s",
			not ok and tostring(species) or "the wildlife loader rejected the config")
		return nil
	end
	for animationName, animation in pairs(species.graphicalAttributes.animations or {}) do
		-- Current WildlifeInstanceGraphics transitions refer to stateName, while
		-- its XML loader records the dictionary key as name.
		animation.stateName = animationName
	end

	if species.initialise ~= nil then
		species:initialise()
	end
	manager.speciesToGroups[species] = manager.speciesToGroups[species] or {}
	proShot.sessionGroundCrowSpecies = species
	return species
end

function proShot:removeSessionGroundCrowSpecies()
	local species = proShot.sessionGroundCrowSpecies
	local manager = g_wildlifeManager
	if species == nil or manager == nil then
		proShot.sessionGroundCrowSpecies = nil
		return
	end
	-- WildlifeManager may already have deleted every registered species during
	-- mission teardown. Do not delete the session species a second time.
	if not table.hasElement(manager.species or {}, species) then
		proShot.sessionGroundCrowSpecies = nil
		return
	end

	for _, group in ipairs(manager.speciesToGroups[species] or {}) do
		table.removeElement(group.species, species)
	end
	manager.speciesToGroups[species] = nil
	if manager.nameToSpecies ~= nil and manager.nameToSpecies[string.upper(species.name or "")] == species then
		manager.nameToSpecies[string.upper(species.name)] = nil
	end
	table.removeElement(manager.species, species)
	species:delete()
	proShot.sessionGroundCrowSpecies = nil
end

function proShot:isTrackedWildlifeInstance(species, instance)
	for _, tracked in ipairs(proShot.spawnedWildlife or {}) do
		if tracked.species == species and tracked.instance == instance then
			return true
		end
	end
	return false
end

function proShot:getTrackedWildlifeInstance(species, instance)
	for _, tracked in ipairs(proShot.spawnedWildlife or {}) do
		if tracked.species == species and tracked.instance == instance then
			return tracked
		end
	end
	return nil
end

function proShot:getAnimationShaderTime()
	if getShaderTimeSec ~= nil then
		local ok, shaderTime = pcall(getShaderTimeSec)
		if ok and type(shaderTime) == "number" then
			return shaderTime
		end
	end
	return (g_time or 0) * 0.001
end

function proShot:getSelectableWildlife(isBird)
	local result = {}
	if g_wildlifeManager ~= nil then
		for _, species in ipairs(g_wildlifeManager.species or {}) do
			if species.debugSpawn ~= nil and proShot:isBirdSpecies(species) == isBird then
				table.insert(result, species)
			end
		end
	end
	return result
end

function proShot:getSelectedWildlife(isBird)
	local speciesList = proShot:getSelectableWildlife(isBird)
	if #speciesList == 0 then
		return nil
	end
	local indexField = isBird and "selectedBirdIndex" or "selectedWildlifeIndex"
	proShot[indexField] = math.clamp(proShot[indexField] or 1, 1, #speciesList)
	return speciesList[proShot[indexField]]
end

function proShot:getNextWildlife(isBird)
	local speciesList = proShot:getSelectableWildlife(isBird)
	if #speciesList == 0 then
		return nil
	end
	local indexField = isBird and "selectedBirdIndex" or "selectedWildlifeIndex"
	local currentIndex = math.clamp(proShot[indexField] or 1, 1, #speciesList)
	return speciesList[currentIndex % #speciesList + 1]
end

function proShot:cycleSelectedWildlife(isBird)
	local speciesList = proShot:getSelectableWildlife(isBird)
	if #speciesList == 0 then
		proShot:showToast(g_i18n:getText(isBird and "proShot_testing_birdUnavailable" or "proShot_wildlife_unavailable"))
		return false
	end
	local indexField = isBird and "selectedBirdIndex" or "selectedWildlifeIndex"
	proShot[indexField] = (proShot[indexField] or 1) % #speciesList + 1
	if isBird then
		proShot.animalAdjustmentMode = "bird"
	else
		proShot.animalAdjustmentMode = proShot:isGroundCrowSpecies(proShot:getSelectedWildlife(false)) and "crow" or "wildlife"
	end
	proShot.wildlifeOffsetMode = proShot.animalAdjustmentMode
	proShot.wildlifeRotationMode = proShot.animalAdjustmentMode
	proShot:refreshWildlifeMenu()
	return true
end

function proShot:applyCompanionPaused(paused)
	if setCompanionPaused == nil or g_wildlifeManager == nil then
		return false
	end
	local success = true
	for _, species in ipairs(g_wildlifeManager.species or {}) do
		for _, instance in ipairs(species.instances or {}) do
			if instance.companionId ~= nil then
				local ok, err = pcall(setCompanionPaused, instance.companionId, paused)
				if not ok then
					success = false
					Logging.warning("ProShot: Companion animal pause change failed: %s", tostring(err))
				end
			end
		end
	end
	return success
end

function proShot:applyBirdAnimationPaused(paused)
	if g_wildlifeManager == nil then
		return false
	end
	for _, species in ipairs(g_wildlifeManager.species or {}) do
		if proShot:isBirdSpecies(species) then
			for _, instance in ipairs(species.instances or {}) do
				local animals = instance.animals or { instance }
				for _, animal in ipairs(animals) do
					local graphics = animal.graphics
					if graphics ~= nil and graphics.shaderNode ~= nil then
						local speed1, speed2 = 0, 0
						if not paused then
							speed1 = graphics.currentAnimation ~= nil and graphics.currentAnimation.speed or 0
							speed2 = graphics.nextStateAnimation ~= nil and graphics.nextStateAnimation.speed or 0
						end
						setShaderParameter(graphics.shaderNode,
							WildlifeInstanceGraphics.SHADER_SPEED_NAME, speed1, speed2, 0, 0, false)
					end
				end
			end
		end
	end
	return true
end

function proShot:applyWildlifeAnimationPaused(paused)
	if g_wildlifeManager == nil then
		return false
	end
	for _, species in ipairs(g_wildlifeManager.species or {}) do
		if not proShot:isBirdSpecies(species) then
			for _, instance in ipairs(species.instances or {}) do
				local graphics = instance.graphics
				if graphics ~= nil and graphics.shaderNode ~= nil then
					local tracked = proShot:getTrackedWildlifeInstance(species, instance)
					local isPhotoCrow = tracked ~= nil and proShot:isGroundCrowSpecies(species)
					local speed1, speed2 = 0, 0
					if paused and isPhotoCrow then
						local shaderTime = proShot:getAnimationShaderTime()
						local liveOffset = tracked.liveAnimationOffset or 0
						if tracked.frozenAnimationPhase == nil then
							local liveSpeed = graphics.currentAnimation ~= nil
								and graphics.currentAnimation.speed or 1
							tracked.frozenAnimationPhase = ((shaderTime + 0.1 * liveOffset)
								* liveSpeed) % 1
						end
						-- blendShapeAnimationShader evaluates
						-- (shaderTime + 0.1 * animOffset) * speed. Recalculate
						-- animOffset against the live shader clock so the chosen phase
						-- remains still without forcing every crow to frame zero.
						local frozenSpeed = proShot.CROW_FROZEN_ANIMATION_SPEED
						local frozenOffset = 10 * (tracked.frozenAnimationPhase / frozenSpeed - shaderTime)
						graphics:setAnimationOffset(frozenOffset)
						speed1, speed2 = frozenSpeed, frozenSpeed
					elseif not paused then
						speed1 = graphics.currentAnimation ~= nil and graphics.currentAnimation.speed or 0
						speed2 = graphics.nextStateAnimation ~= nil and graphics.nextStateAnimation.speed or 0
						if isPhotoCrow then
							graphics:setAnimationOffset(tracked.liveAnimationOffset or 0)
							tracked.frozenAnimationPhase = nil
						end
					end
					setShaderParameter(graphics.shaderNode,
						WildlifeInstanceGraphics.SHADER_SPEED_NAME, speed1, speed2, 0, 0, false)
				end
			end
		end
	end
	return true
end

function proShot:setBirdsPaused(paused)
	proShot.birdsPaused = paused
	proShot:applyBirdAnimationPaused(paused)
end

function proShot:setWildlifePaused(paused)
	proShot.wildlifePaused = paused
	proShot:applyCompanionPaused(paused)
	proShot:applyWildlifeAnimationPaused(paused)
end

function proShot:isGroundCrowSpecies(species)
	return species ~= nil and not proShot:isFlyBySpecies(species)
		and string.lower(tostring(species.name or "")) == "crow"
end

function proShot:getWildlifeOffsetMode()
	local mode = proShot.animalAdjustmentMode or proShot.wildlifeOffsetMode
	if mode == "crow"
		and proShot:isGroundCrowSpecies(proShot:getSelectedWildlife(false)) then
		return "crow"
	end
	if mode == "farm" or mode == "wildlife" then
		return mode
	end
	return "bird"
end

function proShot:getWildlifeRotationMode()
	local mode = proShot.animalAdjustmentMode or proShot.wildlifeRotationMode
	if mode == "farm" or mode == "wildlife" or mode == "crow" then
		return mode
	end
	return "bird"
end

function proShot:getLastTrackedWildlife(isBird)
	for index = #(proShot.spawnedWildlife or {}), 1, -1 do
		local tracked = proShot.spawnedWildlife[index]
		if tracked.isBird == isBird
			and table.hasElement(tracked.species.instances or {}, tracked.instance) then
			return tracked
		end
	end
	return nil
end

function proShot:getAnimalPlacementBasis(camera)
	if camera == nil or camera == 0 or not entityExists(camera) then
		return 1, 0, 0, 1
	end
	local rightX, _, rightZ = localDirectionToWorld(camera, 1, 0, 0)
	local forwardX, _, forwardZ = localDirectionToWorld(camera, 0, 0, -1)
	local rightLength = math.sqrt(rightX * rightX + rightZ * rightZ)
	local forwardLength = math.sqrt(forwardX * forwardX + forwardZ * forwardZ)
	if rightLength < 0.0001 or forwardLength < 0.0001 then
		local _, rotationY = getWorldRotation(camera)
		forwardX, forwardZ = MathUtil.getDirectionFromYRotation(rotationY)
		rightX, rightZ = forwardZ, -forwardX
	else
		rightX, rightZ = rightX / rightLength, rightZ / rightLength
		forwardX, forwardZ = forwardX / forwardLength, forwardZ / forwardLength
	end
	return rightX, rightZ, forwardX, forwardZ
end

function proShot:getAnimalOffsetWorldPosition(tracked, offsetZ)
	return tracked.baseX + (tracked.worldOffsetX or 0),
		tracked.baseY + offsetZ,
		tracked.baseZ + (tracked.worldOffsetZ or 0)
end

function proShot:applyCrowPlacementOffset(tracked)
	local instance = tracked ~= nil and tracked.instance or nil
	if instance == nil or instance.rootNode == nil or instance.rootNode == 0
		or not entityExists(instance.rootNode) then
		return false
	end
	local x, y, z = proShot:getAnimalOffsetWorldPosition(tracked,
		tracked.placementOffsetZ or tracked.placementOffset or 0)
	setWorldTranslation(instance.rootNode, x, y, z)
	return true
end

function proShot:applyBirdPlacementOffsets(tracked, newOffsetX, newOffsetY, newOffsetZ,
	newWorldOffsetX, newWorldOffsetZ)
	local instance = tracked ~= nil and tracked.instance or nil
	if instance == nil then
		return false
	end
	local oldOffsetX = tracked.placementOffsetX or 0
	local oldOffsetY = tracked.placementOffsetY or 0
	local oldOffsetZ = tracked.placementOffsetZ or tracked.placementOffset or 0
	newOffsetX = newOffsetX or oldOffsetX
	newOffsetY = newOffsetY or oldOffsetY
	newOffsetZ = newOffsetZ or oldOffsetZ
	local oldWorldOffsetX = tracked.worldOffsetX or 0
	local oldWorldOffsetZ = tracked.worldOffsetZ or 0
	newWorldOffsetX = newWorldOffsetX or oldWorldOffsetX
	newWorldOffsetZ = newWorldOffsetZ or oldWorldOffsetZ
	local deltaX = newWorldOffsetX - oldWorldOffsetX
	local deltaY = newOffsetZ - oldOffsetZ
	local deltaZ = newWorldOffsetZ - oldWorldOffsetZ
	local adjusted = false
	for _, animal in ipairs(instance.animals or {}) do
		if animal.rootNode ~= nil and animal.rootNode ~= 0 and entityExists(animal.rootNode) then
			local x, y, z = getWorldTranslation(animal.rootNode)
			setWorldTranslation(animal.rootNode, x + deltaX, y + deltaY, z + deltaZ)
			adjusted = true
		end
	end
	if adjusted then
		tracked.placementOffsetX = newOffsetX
		tracked.placementOffsetY = newOffsetY
		tracked.placementOffsetZ = newOffsetZ
		tracked.placementOffset = newOffsetZ
		tracked.worldOffsetX = newWorldOffsetX
		tracked.worldOffsetZ = newWorldOffsetZ
	end
	return adjusted
end

function proShot:getBirdMinimumClearance(tracked)
	local instance = tracked ~= nil and tracked.instance or nil
	if instance == nil then
		return nil
	end
	local minimumClearance = math.huge
	for _, animal in ipairs(instance.animals or {}) do
		if animal.rootNode ~= nil and animal.rootNode ~= 0 and entityExists(animal.rootNode) then
			local x, y, z = getWorldTranslation(animal.rootNode)
			local groundY = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z)
			minimumClearance = math.min(minimumClearance, y - groundY)
		end
	end
	return minimumClearance ~= math.huge and minimumClearance or nil
end

function proShot:getBirdSafeMinimumOffset(tracked, species)
	if tracked ~= nil and tracked.instance ~= nil then
		local safeMinimum = proShot.BIRD_OFFSET_MIN
		local foundAnimal = false
		for _, animal in ipairs(tracked.instance.animals or {}) do
			if animal.rootNode ~= nil and animal.rootNode ~= 0 and entityExists(animal.rootNode) then
				local x, y, z = getWorldTranslation(animal.rootNode)
				local baseY = y - (tracked.placementOffset or 0)
				local groundY = getTerrainHeightAtWorldPos(g_terrainNode, x, 0, z)
				safeMinimum = math.max(safeMinimum,
					groundY + proShot.BIRD_MIN_GROUND_CLEARANCE - baseY)
				foundAnimal = true
			end
		end
		if foundAnimal then
			return math.clamp(safeMinimum, proShot.BIRD_OFFSET_MIN, proShot.BIRD_OFFSET_MAX)
		end
	end

	species = species or proShot:getSelectedWildlife(true)
	local normalHeight = species ~= nil and (species.minDistanceToGround or 18) or 18
	return math.clamp(proShot.BIRD_MIN_GROUND_CLEARANCE - normalHeight,
		proShot.BIRD_OFFSET_MIN, proShot.BIRD_OFFSET_MAX)
end

function proShot:getBirdPlacementOffsetStep(tracked, species)
	local clearance = proShot:getBirdMinimumClearance(tracked)
	if clearance == nil then
		species = species or proShot:getSelectedWildlife(true)
		clearance = (species ~= nil and (species.minDistanceToGround or 18) or 18)
			+ (proShot.birdPlacementOffset or 0)
	end
	if clearance <= 5 then
		return 0.1
	elseif clearance <= 10 then
		return 0.5
	end
	return 1
end

function proShot:applyTrackedWildlifeRotation(tracked)
	local instance = tracked ~= nil and tracked.instance or nil
	if instance == nil then
		return false
	end
	local rotationY = (tracked.baseRotationY or 0) + math.rad(tracked.rotationOffset or 0)
	local directionX, directionZ = MathUtil.getDirectionFromYRotation(rotationY)
	if tracked.isBird and instance.setFlyDirection ~= nil then
		-- WildlifeInstanceFlyByGroup:setFlyDirection only pivots each animal in
		-- place. Rotate the live flock layout about its centroid first, then set
		-- the common heading so this control turns the formation as a whole.
		local validAnimals = {}
		local centreX, centreZ = 0, 0
		for _, animal in ipairs(instance.animals or {}) do
			if animal.rootNode ~= nil and animal.rootNode ~= 0 and entityExists(animal.rootNode) then
				local x, _, z = getWorldTranslation(animal.rootNode)
				centreX = centreX + x
				centreZ = centreZ + z
				table.insert(validAnimals, animal)
			end
		end
		if #validAnimals == 0 then
			return false
		end
		centreX = centreX / #validAnimals
		centreZ = centreZ / #validAnimals
		local appliedOffset = tracked.appliedRotationOffset or tracked.rotationOffset or 0
		local delta = math.rad((tracked.rotationOffset or 0) - appliedOffset)
		local cosDelta, sinDelta = math.cos(delta), math.sin(delta)
		if math.abs(delta) > 0.000001 then
			for _, animal in ipairs(validAnimals) do
				local x, y, z = getWorldTranslation(animal.rootNode)
				local relativeX, relativeZ = x - centreX, z - centreZ
				setWorldTranslation(animal.rootNode,
					centreX + relativeX * cosDelta + relativeZ * sinDelta,
					y,
					centreZ - relativeX * sinDelta + relativeZ * cosDelta)
			end
		end
		instance:setFlyDirection(directionX, directionZ)
		tracked.appliedRotationOffset = tracked.rotationOffset or 0
		return true
	elseif instance.companionId ~= nil then
		if isCompanionReady ~= nil and not isCompanionReady(instance.companionId) then
			return false
		end
		local ok, nodes = pcall(getCompanionNodes, instance.companionId)
		if not ok or nodes == nil or #nodes == 0 then
			return false
		end
		for _, node in ipairs(nodes) do
			if node ~= nil and node ~= 0 and entityExists(node) then
				-- Companion nodes can report the same orientation through different
				-- Euler triples near a wrap point. Feeding their returned pitch and
				-- roll into the next yaw adjustment makes deer flip and eventually
				-- reverses the controls. FS25 steers wildlife with a world direction;
				-- use that stable representation for an upright photo subject too.
				setWorldDirection(node, directionX, 0, directionZ, 0, 1, 0)
			end
		end
		return true
	elseif instance.rootNode ~= nil and instance.rootNode ~= 0 and entityExists(instance.rootNode) then
		setWorldDirection(instance.rootNode, directionX, 0, directionZ, 0, 1, 0)
		return true
	end
	return false
end

function proShot:applyPendingWildlifeRotations()
	for _, tracked in ipairs(proShot.spawnedWildlife or {}) do
		if tracked.rotationNeedsApply
			and table.hasElement(tracked.species.instances or {}, tracked.instance)
			and proShot:applyTrackedWildlifeRotation(tracked) then
			tracked.rotationNeedsApply = false
		end
	end
end

function proShot:applyPendingAnimalPlacementOffsets()
	for _, tracked in ipairs(proShot.spawnedWildlife or {}) do
		local offsets = tracked.pendingPlacementOffsets
		if offsets ~= nil and tracked.isBird
			and table.hasElement(tracked.species.instances or {}, tracked.instance)
			and proShot:applyBirdPlacementOffsets(tracked, offsets[1], offsets[2], offsets[3],
				offsets[4], offsets[5]) then
			tracked.pendingPlacementOffsets = nil
			local safeMinimum = proShot:getBirdSafeMinimumOffset(tracked, tracked.species)
			if tracked.placementOffset < safeMinimum then
				if tracked == proShot:getLastTrackedWildlife(true) then
					proShot.birdPlacementOffset = safeMinimum
				end
				proShot:applyBirdPlacementOffsets(tracked, nil, nil, safeMinimum)
			end
		end
	end
end

function proShot:adjustWildlifeRotation(direction)
	local mode = proShot:getWildlifeRotationMode()
	if mode == "farm" then
		local rotation = (proShot.farmAnimalRotationDegrees or 0)
			+ direction * proShot.WILDLIFE_ROTATION_STEP_DEGREES
		proShot.farmAnimalRotationDegrees = (rotation + 180) % 360 - 180
		local tracked = proShot:getLastTrackedFarmAnimal()
		if tracked ~= nil then
			tracked.rotationOffset = proShot.farmAnimalRotationDegrees
			proShot:applyFarmAnimalPlacement(tracked)
		end
		return
	end
	local isBird = mode == "bird"
	local field = isBird and "birdRotationDegrees" or "wildlifeRotationDegrees"
	local rotation = (proShot[field] or 0) + direction * proShot.WILDLIFE_ROTATION_STEP_DEGREES
	rotation = (rotation + 180) % 360 - 180
	proShot[field] = rotation
	local tracked = proShot:getLastTrackedWildlife(isBird)
	if tracked ~= nil then
		tracked.rotationOffset = rotation
		tracked.rotationNeedsApply = true
		if proShot:applyTrackedWildlifeRotation(tracked) then
			tracked.rotationNeedsApply = false
		end
	end
end

function proShot:getAnimalPlacementOffsets(mode)
	if mode == "farm" then
		return proShot.farmAnimalPlacementOffsetX or 0,
			proShot.farmAnimalPlacementOffsetY or 0, proShot.farmAnimalPlacementOffset or 0
	elseif mode == "crow" then
		return proShot.crowPlacementOffsetX or 0,
			proShot.crowPlacementOffsetY or 0, proShot.crowPlacementOffset or 0
	elseif mode == "bird" then
		return proShot.birdPlacementOffsetX or 0,
			proShot.birdPlacementOffsetY or 0, proShot.birdPlacementOffset or 0
	end
	return 0, 0, 0
end

function proShot:getAnimalPlacementWorldOffsets(mode)
	if mode == "farm" then
		return proShot.farmAnimalWorldOffsetX or 0, proShot.farmAnimalWorldOffsetZ or 0
	elseif mode == "crow" then
		return proShot.crowWorldOffsetX or 0, proShot.crowWorldOffsetZ or 0
	elseif mode == "bird" then
		return proShot.birdWorldOffsetX or 0, proShot.birdWorldOffsetZ or 0
	end
	return 0, 0
end

function proShot:getLastTrackedCrow()
	for index = #(proShot.spawnedWildlife or {}), 1, -1 do
		local tracked = proShot.spawnedWildlife[index]
		if not tracked.isBird and proShot:isGroundCrowSpecies(tracked.species)
			and table.hasElement(tracked.species.instances or {}, tracked.instance) then
			return tracked
		end
	end
	return nil
end

function proShot:setAnimalPlacementOffsets(mode, offsetX, offsetY, offsetZ,
	worldOffsetX, worldOffsetZ)
	local currentWorldOffsetX, currentWorldOffsetZ = proShot:getAnimalPlacementWorldOffsets(mode)
	worldOffsetX = worldOffsetX or currentWorldOffsetX
	worldOffsetZ = worldOffsetZ or currentWorldOffsetZ
	if mode == "farm" then
		proShot.farmAnimalPlacementOffsetX = offsetX
		proShot.farmAnimalPlacementOffsetY = offsetY
		proShot.farmAnimalPlacementOffset = offsetZ
		proShot.farmAnimalWorldOffsetX = worldOffsetX
		proShot.farmAnimalWorldOffsetZ = worldOffsetZ
		local tracked = proShot:getLastTrackedFarmAnimal()
		if tracked ~= nil then
			tracked.placementOffsetX = offsetX
			tracked.placementOffsetY = offsetY
			tracked.placementOffsetZ = offsetZ
			tracked.placementOffset = offsetZ
			tracked.worldOffsetX = worldOffsetX
			tracked.worldOffsetZ = worldOffsetZ
			proShot:applyFarmAnimalPlacement(tracked)
		end
	elseif mode == "crow" then
		proShot.crowPlacementOffsetX = offsetX
		proShot.crowPlacementOffsetY = offsetY
		proShot.crowPlacementOffset = offsetZ
		proShot.crowWorldOffsetX = worldOffsetX
		proShot.crowWorldOffsetZ = worldOffsetZ
		local tracked = proShot:getLastTrackedCrow()
		if tracked ~= nil then
			tracked.placementOffsetX = offsetX
			tracked.placementOffsetY = offsetY
			tracked.placementOffsetZ = offsetZ
			tracked.placementOffset = offsetZ
			tracked.worldOffsetX = worldOffsetX
			tracked.worldOffsetZ = worldOffsetZ
			proShot:applyCrowPlacementOffset(tracked)
		end
	elseif mode == "bird" then
		proShot.birdPlacementOffsetX = offsetX
		proShot.birdPlacementOffsetY = offsetY
		proShot.birdPlacementOffset = offsetZ
		proShot.birdWorldOffsetX = worldOffsetX
		proShot.birdWorldOffsetZ = worldOffsetZ
		local tracked = proShot:getLastTrackedWildlife(true)
		if tracked ~= nil then
			if not proShot:applyBirdPlacementOffsets(tracked, offsetX, offsetY, offsetZ,
				worldOffsetX, worldOffsetZ) then
				tracked.pendingPlacementOffsets = {
					offsetX, offsetY, offsetZ, worldOffsetX, worldOffsetZ
				}
			end
			local safeMinimum = proShot:getBirdSafeMinimumOffset(tracked, tracked.species)
			if offsetZ < safeMinimum then
				offsetZ = safeMinimum
				proShot.birdPlacementOffset = offsetZ
				if not proShot:applyBirdPlacementOffsets(tracked, nil, nil, offsetZ) then
					tracked.pendingPlacementOffsets = {
						offsetX, offsetY, offsetZ, worldOffsetX, worldOffsetZ
					}
				end
			end
		end
	end
end

function proShot:adjustAnimalPlanarOffset(axis, direction)
	local mode = proShot:getWildlifeOffsetMode()
	if mode == "wildlife" then
		proShot:showToast(g_i18n:getText("proShot_wildlife_groundOnly"))
		return
	end
	local offsetX, offsetY, offsetZ = proShot:getAnimalPlacementOffsets(mode)
	local worldOffsetX, worldOffsetZ = proShot:getAnimalPlacementWorldOffsets(mode)
	local minimum = mode == "bird" and proShot.BIRD_OFFSET_MIN or proShot.WILDLIFE_OFFSET_MIN
	local maximum = mode == "bird" and proShot.BIRD_OFFSET_MAX or proShot.WILDLIFE_OFFSET_MAX
	local step = proShot.WILDLIFE_OFFSET_STEP
	if mode == "bird" then
		local tracked = proShot:getLastTrackedWildlife(true)
		step = proShot:getBirdPlacementOffsetStep(tracked,
			tracked ~= nil and tracked.species or proShot:getSelectedWildlife(true))
	end
	if axis == "x" then
		local newOffsetX = math.clamp(offsetX + direction * step, minimum, maximum)
		local delta = newOffsetX - offsetX
		offsetX = newOffsetX
		local rightX, rightZ = proShot:getAnimalPlacementBasis(proShot.ourCamera)
		worldOffsetX = worldOffsetX + rightX * delta
		worldOffsetZ = worldOffsetZ + rightZ * delta
	else
		local newOffsetY = math.clamp(offsetY + direction * step, minimum, maximum)
		local delta = newOffsetY - offsetY
		offsetY = newOffsetY
		local _, _, forwardX, forwardZ = proShot:getAnimalPlacementBasis(proShot.ourCamera)
		worldOffsetX = worldOffsetX + forwardX * delta
		worldOffsetZ = worldOffsetZ + forwardZ * delta
	end
	proShot:setAnimalPlacementOffsets(mode, offsetX, offsetY, offsetZ,
		worldOffsetX, worldOffsetZ)
end

function proShot:adjustWildlifePlacementOffset(direction)
	local mode = proShot:getWildlifeOffsetMode()
	if mode == "wildlife" then
		proShot:showToast(g_i18n:getText("proShot_wildlife_groundOnly"))
		return
	end
	local offsetX, offsetY, currentOffset = proShot:getAnimalPlacementOffsets(mode)
	local step = proShot.WILDLIFE_OFFSET_STEP
	local minimum = proShot.WILDLIFE_OFFSET_MIN
	local maximum = proShot.WILDLIFE_OFFSET_MAX
	if mode == "bird" then
		local tracked = proShot:getLastTrackedWildlife(true)
		local species = tracked ~= nil and tracked.species or proShot:getSelectedWildlife(true)
		step = proShot:getBirdPlacementOffsetStep(tracked, species)
		local clearance = proShot:getBirdMinimumClearance(tracked)
		if direction < 0 and clearance ~= nil then
			-- Land exactly on the 10 m and 5 m step boundaries rather than
			-- overshooting them with the previous, coarser increment.
			if clearance > 10 and clearance - step < 10 then
				step = clearance - 10
			elseif clearance > 5 and clearance - step < 5 then
				step = clearance - 5
			end
		end
		minimum = proShot:getBirdSafeMinimumOffset(tracked, species)
		maximum = proShot.BIRD_OFFSET_MAX
	end
	local newOffset = math.clamp(currentOffset + direction * step, minimum, maximum)
	proShot:setAnimalPlacementOffsets(mode, offsetX, offsetY, newOffset)
end

function proShot:resetAnimalPlacementOffsets()
	local mode = proShot:getWildlifeOffsetMode()
	if mode == "wildlife" then
		proShot:showToast(g_i18n:getText("proShot_wildlife_groundOnly"))
		return
	end
	proShot:setAnimalPlacementOffsets(mode, 0, 0, 0, 0, 0)
end

function proShot:getWildlifeTargetMask()
	return CollisionFlag.TERRAIN
		+ CollisionFlag.TERRAIN_DELTA
		+ CollisionFlag.ROAD
		+ CollisionFlag.STATIC_OBJECT
		+ CollisionFlag.BUILDING
		+ CollisionFlag.DYNAMIC_OBJECT
		+ CollisionFlag.VEHICLE
		+ CollisionFlag.VEHICLE_FORK
		+ CollisionFlag.TRAFFIC_VEHICLE
		+ CollisionFlag.TREE
end

function proShot:isGroundWildlifeTarget(nodeId)
	if nodeId == nil or nodeId == 0 then
		return false
	end
	if nodeId == g_terrainNode then
		return true
	end
	return CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.TERRAIN)
		or CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.TERRAIN_DELTA)
		or CollisionFlag.getHasGroupFlagSet(nodeId, CollisionFlag.ROAD)
end

-- Aim temporary photo subjects from the centre of the ProShot camera. Deer and
-- other companion-based wildlife are accepted only on terrain/roads: their
-- navigation layer otherwise snaps them through roofs and props to the ground.
-- The adapted ground crow can perch on objects, with a downward probe resolving
-- the upper surface selected from its side. Fly-by birds use a ground target
-- when one is under the reticle; otherwise the camera ray is intersected with
-- the species' normal height above local terrain.
function proShot:getWildlifeSpawnPosition(species, isBird)
	local camera = proShot.ourCamera
	local cameraX, _, cameraZ = getWorldTranslation(camera)
	local rayX, rayY, rayZ, dirX, dirY, dirZ = RaycastUtil.getCameraPickingRay(0.5, 0.5, camera)
	local isFlyBy = proShot:isFlyBySpecies(species)

	if isFlyBy then
		local normalHeight = species.minDistanceToGround or 18
		local safeMinimumOffset = proShot.BIRD_MIN_GROUND_CLEARANCE - normalHeight
		proShot.birdPlacementOffset = math.max(proShot.birdPlacementOffset or 0, safeMinimumOffset)
		local flightClearance = normalHeight + proShot.birdPlacementOffset
		local groundMask = CollisionFlag.TERRAIN + CollisionFlag.TERRAIN_DELTA + CollisionFlag.ROAD
		local hitId, hitX, hitY, hitZ = RaycastUtil.raycastClosest(
			rayX, rayY, rayZ, dirX, dirY, dirZ, proShot.BIRD_MAX_SPAWN_DISTANCE, groundMask)
		if hitId ~= nil then
			return hitX, hitY + flightClearance, hitZ, "birdAboveTarget"
		end

		-- A view direction does not by itself contain a depth. Intersect it with
		-- the species' regular flight height and iterate against the terrain below
		-- the candidate point so slopes do not turn the nominal plane into a low
		-- or underground spawn. Near-parallel or rearward intersections are
		-- rejected rather than producing tiny birds kilometres away.
		if math.abs(dirY) < 0.0001 then
			return nil, nil, nil, "tooFar"
		end
		local terrainY = getTerrainHeightAtWorldPos(g_terrainNode, cameraX, 0, cameraZ)
		local distance = (terrainY + flightClearance - rayY) / dirY
		for _ = 1, 4 do
			if distance <= 0 or distance > proShot.BIRD_MAX_SPAWN_DISTANCE then
				return nil, nil, nil, "tooFar"
			end
			local candidateX = rayX + dirX * distance
			local candidateZ = rayZ + dirZ * distance
			terrainY = getTerrainHeightAtWorldPos(g_terrainNode, candidateX, 0, candidateZ)
			local nextDistance = (terrainY + flightClearance - rayY) / dirY
			if math.abs(nextDistance - distance) < 0.01 then
				distance = nextDistance
				break
			end
			distance = nextDistance
		end
		if distance <= 0 or distance > proShot.BIRD_MAX_SPAWN_DISTANCE then
			return nil, nil, nil, "tooFar"
		end
		return rayX + dirX * distance, rayY + dirY * distance, rayZ + dirZ * distance, "birdSky"
	end

	local targetMask = proShot:getWildlifeTargetMask()
	local hitId, hitX, hitY, hitZ = RaycastUtil.raycastClosest(
		rayX, rayY, rayZ, dirX, dirY, dirZ, proShot.WILDLIFE_MAX_SPAWN_DISTANCE, targetMask)
	if hitId == nil then
		if not proShot:isGroundCrowSpecies(species) then
			local groundMask = CollisionFlag.TERRAIN + CollisionFlag.TERRAIN_DELTA + CollisionFlag.ROAD
			local distantGroundId = RaycastUtil.raycastClosest(
				rayX, rayY, rayZ, dirX, dirY, dirZ, 2500, groundMask)
			return nil, nil, nil, distantGroundId ~= nil and "tooFar" or "groundOnly"
		end
		return nil, nil, nil, "tooFar"
	end

	local placement = proShot:isGroundWildlifeTarget(hitId) and "wildlifeGround" or "wildlifeObject"
	if placement == "wildlifeObject" and not proShot:isGroundCrowSpecies(species) then
		return nil, nil, nil, "groundOnly"
	end
	if placement == "wildlifeObject" then
		-- Resolve the top of the selected object's collision at the crosshair's
		-- horizontal position. This lets a side hit on a car, fence or building
		-- become a usable perch rather than embedding the animal in its surface.
		local probeHeight = proShot.WILDLIFE_SURFACE_PROBE_HEIGHT
		local topId, topX, topY, topZ = RaycastUtil.raycastClosest(
			hitX, hitY + probeHeight, hitZ, 0, -1, 0, probeHeight * 2, targetMask)
		if topId ~= nil then
			hitX, hitY, hitZ = topX, topY, topZ
			placement = proShot:isGroundWildlifeTarget(topId) and "wildlifeGround" or "wildlifeObject"
		end
	end

	local placementOffset = proShot:isGroundCrowSpecies(species) and (proShot.crowPlacementOffset or 0) or 0
	return hitX, hitY + proShot.WILDLIFE_SURFACE_CLEARANCE + placementOffset, hitZ, placement
end

function proShot:getFarmAnimalSpawnPosition()
	local camera = proShot.ourCamera
	if camera == nil or camera == 0 or not entityExists(camera) then
		return nil, nil, nil, "tooFar"
	end
	local rayX, rayY, rayZ, dirX, dirY, dirZ = RaycastUtil.getCameraPickingRay(0.5, 0.5, camera)
	local targetMask = proShot:getWildlifeTargetMask()
	local hitId, hitX, hitY, hitZ = RaycastUtil.raycastClosest(
		rayX, rayY, rayZ, dirX, dirY, dirZ, proShot.FARM_ANIMAL_MAX_SPAWN_DISTANCE, targetMask)
	if hitId == nil then
		return nil, nil, nil, "tooFar"
	end
	local placement = proShot:isGroundWildlifeTarget(hitId) and "animalGround" or "animalObject"
	if placement == "animalObject" then
		-- Posed livestock have no navigation component, so unlike deer they can
		-- safely stay on a roof, vehicle or prop. Resolve the top surface at the
		-- reticle before adding the user-controlled fine offset.
		local probeHeight = proShot.FARM_ANIMAL_SURFACE_PROBE_HEIGHT
		local topId, topX, topY, topZ = RaycastUtil.raycastClosest(
			hitX, hitY + probeHeight, hitZ, 0, -1, 0, probeHeight * 2, targetMask)
		if topId ~= nil then
			hitX, hitY, hitZ = topX, topY, topZ
			placement = proShot:isGroundWildlifeTarget(topId) and "animalGround" or "animalObject"
		end
	end
	return hitX, hitY + proShot.WILDLIFE_SURFACE_CLEARANCE, hitZ, placement
end

function proShot:getLastTrackedFarmAnimal()
	for index = #(proShot.spawnedFarmAnimals or {}), 1, -1 do
		local tracked = proShot.spawnedFarmAnimals[index]
		if not tracked.deleted and tracked.rootNode ~= nil and tracked.rootNode ~= 0
			and entityExists(tracked.rootNode) then
			return tracked
		end
	end
	return nil
end

function proShot:applyFarmAnimalPlacement(tracked)
	if tracked == nil or tracked.deleted or tracked.rootNode == nil or tracked.rootNode == 0
		or not entityExists(tracked.rootNode) then
		return false
	end
	local x, y, z = proShot:getAnimalOffsetWorldPosition(tracked,
		tracked.placementOffsetZ or tracked.placementOffset or 0)
	setWorldTranslation(tracked.rootNode, x, y, z)
	setWorldRotation(tracked.rootNode, 0,
		tracked.baseRotationY + math.rad(tracked.rotationOffset or 0), 0)
	return true
end

function proShot:deleteTrackedFarmAnimal(tracked)
	if tracked == nil or tracked.deleted then
		return false
	end
	tracked.deleted = true
	if tracked.sharedLoadRequestId ~= nil and g_i3DManager ~= nil then
		g_i3DManager:releaseSharedI3DFile(tracked.sharedLoadRequestId)
		tracked.sharedLoadRequestId = nil
	end
	if tracked.loadedNode ~= nil and tracked.loadedNode ~= 0 and entityExists(tracked.loadedNode) then
		delete(tracked.loadedNode)
	end
	tracked.loadedNode = nil
	if tracked.rootNode ~= nil and tracked.rootNode ~= 0 and entityExists(tracked.rootNode) then
		delete(tracked.rootNode)
	end
	tracked.rootNode = nil
	return true
end

function proShot:onFarmAnimalLoaded(i3dNode, failedReason, args)
	local tracked = args ~= nil and args.tracked or nil
	if tracked == nil or tracked.deleted then
		if i3dNode ~= nil and i3dNode ~= 0 and entityExists(i3dNode) then
			delete(i3dNode)
		end
		return
	end
	if i3dNode == nil or i3dNode == 0 or tracked.rootNode == nil or tracked.rootNode == 0
		or not entityExists(tracked.rootNode) then
		Logging.warning("ProShot: Farm animal model failed to load: %s", tostring(failedReason))
		table.removeElement(proShot.spawnedFarmAnimals, tracked)
		proShot:deleteTrackedFarmAnimal(tracked)
		proShot:showToast(g_i18n:getText("proShot_farm_loadFailed"))
		proShot:refreshWildlifeMenu()
		return
	end
	link(tracked.rootNode, i3dNode)
	tracked.loadedNode = i3dNode
	local visualAnimal = tracked.visual ~= nil and tracked.visual.visualAnimal or nil
	local variation = visualAnimal ~= nil and (visualAnimal.variations or {})[1] or nil
	if variation ~= nil then
		local numTilesU = math.max(variation.numTilesU or 1, 1)
		local numTilesV = math.max(variation.numTilesV or 1, 1)
		I3DUtil.setShaderParameterRec(i3dNode, "atlasInvSizeAndOffsetUV",
			1 / numTilesU, 1 / numTilesV,
			(variation.tileUIndex or 0) / numTilesU,
			(variation.tileVIndex or 0) / numTilesV)
	end
	I3DUtil.setShaderParameterRec(i3dNode, "dirt", 0, nil, nil, nil)
end

function proShot:spawnSelectedFarmAnimal()
	local choice, variant = proShot:getSelectedFarmAnimal()
	local visual = variant ~= nil and variant.visual or nil
	local visualAnimal = visual ~= nil and visual.visualAnimal or nil
	local filename = visualAnimal ~= nil and visualAnimal.filenamePosed or nil
	if choice == nil or variant == nil or filename == nil or filename == ""
		or g_i3DManager == nil then
		proShot:showToast(g_i18n:getText("proShot_farm_unavailable"))
		return false
	end
	local spawnX, spawnY, spawnZ, placement = proShot:getFarmAnimalSpawnPosition()
	if spawnX == nil then
		proShot:showToast(g_i18n:getText("proShot_wildlife_tooFar"))
		return false
	end
	local rootNode = createTransformGroup("proShotFarmAnimal")
	if rootNode == nil or rootNode == 0 then
		proShot:showToast(g_i18n:getText("proShot_farm_loadFailed"))
		return false
	end
	link(getRootNode(), rootNode)
	local cameraRotationY = 0
	if proShot.ourCamera ~= nil and proShot.ourCamera ~= 0 and entityExists(proShot.ourCamera) then
		local _, rotationY = getWorldRotation(proShot.ourCamera)
		cameraRotationY = rotationY
	end
	local tracked = {
		rootNode = rootNode,
		visual = visual,
		choice = choice,
		variant = variant,
		baseX = spawnX,
		baseY = spawnY,
		baseZ = spawnZ,
		baseRotationY = cameraRotationY,
		placementOffsetX = proShot.farmAnimalPlacementOffsetX or 0,
		placementOffsetY = proShot.farmAnimalPlacementOffsetY or 0,
		placementOffsetZ = proShot.farmAnimalPlacementOffset or 0,
		placementOffset = proShot.farmAnimalPlacementOffset or 0,
		worldOffsetX = proShot.farmAnimalWorldOffsetX or 0,
		worldOffsetZ = proShot.farmAnimalWorldOffsetZ or 0,
		rotationOffset = proShot.farmAnimalRotationDegrees or 0,
		deleted = false
	}
	proShot:applyFarmAnimalPlacement(tracked)
	proShot.spawnedFarmAnimals = proShot.spawnedFarmAnimals or {}
	table.insert(proShot.spawnedFarmAnimals, tracked)
	proShot.animalAdjustmentMode = "farm"
	proShot.wildlifeOffsetMode = "farm"
	proShot.wildlifeRotationMode = "farm"
	tracked.sharedLoadRequestId = g_i3DManager:loadSharedI3DFileAsync(
		filename, false, false, proShot.onFarmAnimalLoaded, proShot, { tracked = tracked })
	if tracked.sharedLoadRequestId == nil then
		table.removeElement(proShot.spawnedFarmAnimals, tracked)
		proShot:deleteTrackedFarmAnimal(tracked)
		proShot:showToast(g_i18n:getText("proShot_farm_loadFailed"))
		return false
	end
	proShot:refreshWildlifeMenu()
	proShot:showToast(g_i18n:getText(placement == "animalObject"
		and "proShot_farm_placedObject" or "proShot_farm_placedGround"))
	return true
end

function proShot:getTrackedFarmAnimalCount()
	local count = 0
	for _, tracked in ipairs(proShot.spawnedFarmAnimals or {}) do
		if not tracked.deleted and tracked.rootNode ~= nil and tracked.rootNode ~= 0
			and entityExists(tracked.rootNode) then
			count = count + 1
		end
	end
	return count
end

function proShot:despawnTrackedFarmAnimals()
	local removed = 0
	for index = #(proShot.spawnedFarmAnimals or {}), 1, -1 do
		if proShot:deleteTrackedFarmAnimal(proShot.spawnedFarmAnimals[index]) then
			removed = removed + 1
		end
		table.remove(proShot.spawnedFarmAnimals, index)
	end
	return removed
end

function proShot:despawnLastTrackedFarmAnimal()
	for index = #(proShot.spawnedFarmAnimals or {}), 1, -1 do
		local tracked = proShot.spawnedFarmAnimals[index]
		table.remove(proShot.spawnedFarmAnimals, index)
		if proShot:deleteTrackedFarmAnimal(tracked) then
			local previous = proShot:getLastTrackedFarmAnimal()
			proShot.farmAnimalPlacementOffsetX = previous ~= nil and (previous.placementOffsetX or 0) or 0
			proShot.farmAnimalPlacementOffsetY = previous ~= nil and (previous.placementOffsetY or 0) or 0
			proShot.farmAnimalPlacementOffset = previous ~= nil
				and (previous.placementOffsetZ or previous.placementOffset or 0) or 0
			proShot.farmAnimalWorldOffsetX = previous ~= nil and (previous.worldOffsetX or 0) or 0
			proShot.farmAnimalWorldOffsetZ = previous ~= nil and (previous.worldOffsetZ or 0) or 0
			proShot.farmAnimalRotationDegrees = previous ~= nil and (previous.rotationOffset or 0) or 0
			proShot:refreshWildlifeMenu()
			proShot:showToast(g_i18n:getText("proShot_farm_removedLast"))
			return true
		end
	end
	proShot:showToast(g_i18n:getText("proShot_farm_noneToRemove"))
	return false
end

function proShot:spawnWildlife(species, isBird)
	local camera = proShot.ourCamera
	if species == nil or species.debugSpawn == nil or camera == nil or camera == 0 or not entityExists(camera) then
		proShot:showToast(g_i18n:getText(isBird and "proShot_testing_birdUnavailable" or "proShot_wildlife_unavailable"))
		return false
	end

	local spawnX, spawnY, spawnZ, placement = proShot:getWildlifeSpawnPosition(species, isBird)
	if spawnX == nil then
		proShot:showToast(g_i18n:getText(placement == "groundOnly"
			and "proShot_wildlife_groundOnly" or "proShot_wildlife_tooFar"))
		return false
	end
	proShot.animalAdjustmentMode = isBird and "bird"
		or (proShot:isGroundCrowSpecies(species) and "crow" or "wildlife")
	proShot.wildlifeOffsetMode = proShot.animalAdjustmentMode
	proShot.wildlifeRotationMode = proShot.animalAdjustmentMode
	local _, rotationY = getWorldRotation(camera)
	local rotationOffset = isBird and (proShot.birdRotationDegrees or 0)
		or (proShot.wildlifeRotationDegrees or 0)
	local spawnRotationY = rotationY + math.rad(rotationOffset)
	local previousInstances = {}
	for _, instance in ipairs(species.instances or {}) do
		previousInstances[instance] = true
	end
	local birdCount = math.clamp(5, species.minNumAnimalsPerInstance or 1, species.maxNumAnimalsPerInstance or 5)
	-- WildlifeSpeciesCrow applies a random 0.5-10 m horizontal group offset
	-- after receiving the already-resolved Y coordinate. On sloping terrain that
	-- embeds or floats a lone photo crow. Disable only that spread for ProShot's
	-- explicit ground spawn, then restore the species immediately.
	local originalGroupMinRadius, originalGroupMaxRadius
	if not isBird and species.groupMinRadius ~= nil and species.groupMaxRadius ~= nil then
		originalGroupMinRadius = species.groupMinRadius
		originalGroupMaxRadius = species.groupMaxRadius
		species.groupMinRadius = 0
		species.groupMaxRadius = 0
	end
	local ok, err = pcall(species.debugSpawn, species, spawnX, spawnY, spawnZ,
		isBird and birdCount or 1, spawnRotationY)
	if originalGroupMinRadius ~= nil then
		species.groupMinRadius = originalGroupMinRadius
		species.groupMaxRadius = originalGroupMaxRadius
	end
	if not ok then
		Logging.warning("ProShot: Wildlife test spawn failed: %s", tostring(err))
		proShot:showToast(g_i18n:getText("proShot_testing_spawnFailed"))
		return false
	end
	for _, instance in ipairs(species.instances or {}) do
		if not previousInstances[instance] then
			local placementOffset = isBird and (proShot.birdPlacementOffset or 0)
				or (proShot:isGroundCrowSpecies(species) and (proShot.crowPlacementOffset or 0) or 0)
			local placementOffsetX = isBird and (proShot.birdPlacementOffsetX or 0)
				or (proShot:isGroundCrowSpecies(species) and (proShot.crowPlacementOffsetX or 0) or 0)
			local placementOffsetY = isBird and (proShot.birdPlacementOffsetY or 0)
				or (proShot:isGroundCrowSpecies(species) and (proShot.crowPlacementOffsetY or 0) or 0)
			local worldOffsetX = isBird and (proShot.birdWorldOffsetX or 0)
				or (proShot:isGroundCrowSpecies(species) and (proShot.crowWorldOffsetX or 0) or 0)
			local worldOffsetZ = isBird and (proShot.birdWorldOffsetZ or 0)
				or (proShot:isGroundCrowSpecies(species) and (proShot.crowWorldOffsetZ or 0) or 0)
			local tracked = {
				species = species,
				instance = instance,
				isBird = isBird,
				baseX = spawnX,
				baseY = spawnY - placementOffset,
				baseZ = spawnZ,
				placementOffsetX = isBird and 0 or placementOffsetX,
				placementOffsetY = isBird and 0 or placementOffsetY,
				placementOffsetZ = placementOffset,
				placementOffset = placementOffset,
				worldOffsetX = isBird and 0 or worldOffsetX,
				worldOffsetZ = isBird and 0 or worldOffsetZ,
				baseRotationY = rotationY,
				rotationOffset = rotationOffset,
				appliedRotationOffset = rotationOffset,
				rotationNeedsApply = true
			}
			if not isBird and proShot:isGroundCrowSpecies(species)
				and instance.graphics ~= nil and instance.graphics.setAnimationOffset ~= nil then
				-- Native fly-by birds randomise this shader phase, but the dormant
				-- ground-crow path does not. Give every photo crow an independent
				-- phase so they neither animate nor freeze in lockstep.
				tracked.liveAnimationOffset = math.random() * 10
				if proShot.wildlifePaused then
					-- A newly placed paused crow has no visible pose to preserve yet;
					-- seed the whole animation cycle rather than the smaller range that
					-- the shader's documented 0-10 live offset can cover at low speed.
					tracked.frozenAnimationPhase = math.max(math.random(), 0.001)
				end
				instance.graphics:setAnimationOffset(tracked.liveAnimationOffset)
			end
			table.insert(proShot.spawnedWildlife, tracked)
			if isBird then
				if not proShot:applyBirdPlacementOffsets(tracked,
					placementOffsetX, placementOffsetY, placementOffset,
					worldOffsetX, worldOffsetZ) then
					tracked.pendingPlacementOffsets = {
						placementOffsetX, placementOffsetY, placementOffset,
						worldOffsetX, worldOffsetZ
					}
				end
				local safeMinimum = proShot:getBirdSafeMinimumOffset(tracked, species)
				if tracked.placementOffset < safeMinimum then
					proShot.birdPlacementOffset = safeMinimum
					if not proShot:applyBirdPlacementOffsets(tracked, nil, nil, safeMinimum) then
						tracked.pendingPlacementOffsets = {
							placementOffsetX, placementOffsetY, safeMinimum,
							worldOffsetX, worldOffsetZ
						}
					end
				end
			elseif proShot:isGroundCrowSpecies(species) then
				proShot:applyCrowPlacementOffset(tracked)
			end
		end
	end
	Logging.info("ProShot: Spawned %s at %.1f %.1f %.1f (%s); tracked instances: %d",
		proShot:getWildlifeDisplayName(species), spawnX, spawnY, spawnZ, placement,
		proShot:getTrackedWildlifeCount(isBird))
	if isBird and proShot.birdsPaused then
		proShot:applyBirdAnimationPaused(true)
	elseif not isBird and proShot.wildlifePaused then
		proShot:applyCompanionPaused(true)
		proShot:applyWildlifeAnimationPaused(true)
	end
	proShot:applyPendingWildlifeRotations()
	proShot:refreshWildlifeMenu()
	local toastKey = {
		birdAboveTarget = "proShot_wildlife_birdsPlacedAboveTarget",
		birdSky = "proShot_wildlife_birdsPlaced",
		wildlifeGround = "proShot_wildlife_placedGround",
		wildlifeObject = "proShot_wildlife_placedObject"
	}
	proShot:showToast(g_i18n:getText(toastKey[placement] or "proShot_testing_spawnFailed"))
	return true
end

function proShot:getTrackedWildlifeCount(isBird)
	local count = 0
	for _, tracked in ipairs(proShot.spawnedWildlife or {}) do
		if isBird == nil or tracked.isBird == isBird then
			for _, instance in ipairs(tracked.species.instances or {}) do
				if instance == tracked.instance then
					count = count + 1
					break
				end
			end
		end
	end
	return count
end

function proShot:despawnLastTrackedWildlife(isBird)
	for index = #(proShot.spawnedWildlife or {}), 1, -1 do
		local tracked = proShot.spawnedWildlife[index]
		if tracked.isBird == isBird then
			local stillExists = table.hasElement(tracked.species.instances or {}, tracked.instance)
			table.remove(proShot.spawnedWildlife, index)
			if stillExists then
				local ok, err = pcall(tracked.species.despawn, tracked.species, tracked.instance)
				if not ok then
					Logging.warning("ProShot: Wildlife cleanup failed: %s", tostring(err))
					proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
					return false
				end
				proShot:refreshWildlifeMenu()
				proShot:showToast(g_i18n:getText(isBird and "proShot_wildlife_birdRemoved" or "proShot_wildlife_animalRemoved"))
				return true
			end
		end
	end
	proShot:refreshWildlifeMenu()
	proShot:showToast(g_i18n:getText(isBird and "proShot_wildlife_noBird" or "proShot_wildlife_noAnimal"))
	return false
end

function proShot:despawnTrackedWildlife(showToast)
	local removed = 0
	for index = #(proShot.spawnedWildlife or {}), 1, -1 do
		local tracked = proShot.spawnedWildlife[index]
		local stillExists = false
		for _, instance in ipairs(tracked.species.instances or {}) do
			if instance == tracked.instance then
				stillExists = true
				break
			end
		end
		if stillExists then
			local ok, err = pcall(tracked.species.despawn, tracked.species, tracked.instance)
			if ok then
				removed = removed + 1
			else
				Logging.warning("ProShot: Wildlife cleanup failed: %s", tostring(err))
			end
		end
		table.remove(proShot.spawnedWildlife, index)
	end
	removed = removed + proShot:despawnTrackedFarmAnimals()
	if showToast then
		proShot:showToast(string.format(g_i18n:getText("proShot_testing_wildlifeRemoved"), removed))
	end
	proShot:refreshWildlifeMenu()
	return removed
end

function proShot:refreshWildlifeMenu()
	if proShot.menus ~= nil then
		proShot.menus.wildlife = proShot:buildWildlifeMenu()
		if proShot.menuDesired == "wildlife" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:refreshSceneControlsMenu()
	if proShot.menus ~= nil then
		proShot.menus.sceneControls = proShot:buildSceneControlsMenu()
		if proShot.menuDesired == "sceneControls" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:resetSceneControlsState()
	proShot:setTestingTrafficEnabled(false)
	proShot.trafficPaused = true
	proShot:applyTrafficPaused(proShot:getTrafficSystem(), true)
	proShot:setTestingPedestriansEnabled(false)
	proShot.pedestriansPaused = true
	proShot:applyPedestrianTimeScale(proShot:getPedestrianSystem(), 0)
	proShot:setParkedCarsEnabled(true)
	proShot:refreshSceneControlsMenu()
end

function proShot:updateLocalSnowTarget()
	local camera = proShot.ourCamera
	if camera == nil or camera == 0 or not entityExists(camera) then
		return false
	end
	local x, y, z, dx, dy, dz = RaycastUtil.getCameraPickingRay(0.5, 0.5, camera)
	local hitId, hitX, hitY, hitZ = RaycastUtil.raycastClosest(x, y, z, dx, dy, dz, 2500, CollisionFlag.TERRAIN)
	if hitId == nil then
		proShot.localSnowTarget = nil
		return false
	end
	proShot.localSnowTarget = { x = hitX, y = hitY, z = hitZ }
	return true
end

function proShot:getLocalSnowHeight()
	local target = proShot.localSnowTarget
	local snowSystem = g_currentMission ~= nil and g_currentMission.snowSystem or nil
	if target == nil or snowSystem == nil then
		return nil
	end
	local radius = 1
	return snowSystem:getSnowHeightAtArea(
		target.x - radius, target.z - radius,
		target.x + radius, target.z - radius,
		target.x - radius, target.z + radius)
end

function proShot:applyLocalSnow(direction)
	proShot:updateLocalSnowTarget()
	local target = proShot.localSnowTarget
	local snowSystem = g_currentMission ~= nil and g_currentMission.snowSystem or nil
	if target == nil or snowSystem == nil then
		proShot:showToast(g_i18n:getText("proShot_testing_snowNoTarget"))
		return false
	end

	-- SnowSystem only exposes parallelogram writes. Terrain-width strips give a
	-- close circular approximation while preserving the local height of each
	-- part of the selected area before raising or lowering it.
	local radius = proShot.localSnowRadius
	local stripCount = 32
	local stripHeight = radius * 2 / stripCount
	local strength = proShot.LOCAL_SNOW_STRENGTH_LEVELS[proShot.localSnowStrengthLevel]
		or proShot.LOCAL_SNOW_STRENGTH_LEVELS[proShot.LOCAL_SNOW_DEFAULT_STRENGTH_LEVEL]
	local didEdit = false
	for strip = 1, stripCount do
		local z0 = target.z - radius + (strip - 1) * stripHeight
		local z1 = z0 + stripHeight
		local middleZ = (z0 + z1) * 0.5
		local offsetZ = middleZ - target.z
		local halfWidth = math.sqrt(math.max(radius * radius - offsetZ * offsetZ, 0))
		local x0 = target.x - halfWidth
		local x1 = target.x + halfWidth
		local currentHeight = snowSystem:getSnowHeightAtArea(x0, z0, x1, z0, x0, z1)
		local delta = direction > 0 and strength.add or strength.remove
		local newHeight = math.clamp(currentHeight + direction * delta, 0, proShot.MAX_LOCAL_SNOW_HEIGHT)
		if math.abs(newHeight - currentHeight) > 0.0001 then
			local physicalHeight = newHeight
			if newHeight > 0 and snowSystem.layerHeight ~= nil then
				physicalHeight = newHeight + snowSystem.layerHeight * 0.001
			end
			snowSystem:setSnowHeightAtArea(x0, z0, x1, z0, x0, z1, physicalHeight)
			didEdit = true
		end
	end
	if didEdit then
		proShot.localSnowEdited = true
		proShot:debugLog("local snow edited at %.2f %.2f with radius %.2f", target.x, target.z, radius)
	end
	proShot:showToast(g_i18n:getText(direction < 0 and "proShot_testing_snowLowered" or "proShot_testing_snowRaised"))
	return didEdit
end

function proShot:drawLocalSnowPreview()
	local cursor = proShot.localSnowCursor
	local shouldShow = proShot.menuDesired == "localSnow" and proShot:getHudVisible()
	if not shouldShow then
		if cursor ~= nil then
			cursor:setVisible(false)
		end
		return
	end

	if cursor == nil and GuiTopDownCursor ~= nil then
		-- Use FS25's construction/sculpting cursor rather than debug lines. Its
		-- shader conforms the circle to the terrain and offsets it far enough to
		-- remain visible over roads and snow.
		cursor = GuiTopDownCursor.new()
		cursor:setTerrainOnly(true)
		cursor:setRotationEnabled(false)
		cursor:setVisible(false)
		cursor:loadShapes()
		proShot.localSnowCursor = cursor
	end
	if cursor == nil then
		return
	end

	proShot:updateLocalSnowTarget()
	local target = proShot.localSnowTarget
	if target == nil then
		cursor:setVisible(false)
		return
	end
	if not cursor.shapesLoaded then
		return
	end

	cursor:setShape(GuiTopDownCursor.SHAPES.CIRCLE)
	cursor:setShapeSize(proShot.localSnowRadius * 2)
	cursor:setColorMode(GuiTopDownCursor.SHAPES_COLORS.SUCCESS, 0.4)
	-- GuiTopDownCursor normally floats 0.5 m above the terrain. Add the local
	-- snow depth so deep piles cannot cover the sculpting highlight.
	cursor.terrainBrushOffset = 0.5 + math.max(proShot:getLocalSnowHeight() or 0, 0)
	cursor.currentHitId = g_terrainNode
	cursor.currentHitX = target.x
	cursor.currentHitY = target.y
	cursor.currentHitZ = target.z
	cursor:setPosition(target.x, target.y, target.z)
	cursor:setVisible(true)
end

function proShot:activateGroundFogOverride()
	if not proShot.fogOverrideActive then
		-- Manual ground fog should use the weather profile's real coverage area,
		-- rather than the visibility-faded snapshot captured on entry.
		proShot.fogState.groundFogCoverageEdge0 = proShot.fogOverrideCoverageEdge0 or proShot.fogState.groundFogCoverageEdge0
		proShot.fogState.groundFogCoverageEdge1 = proShot.fogOverrideCoverageEdge1 or proShot.fogState.groundFogCoverageEdge1
		proShot.fogOverrideActive = true
	end
end

function proShot:createSkyState()
	return {
		-- Neutral multipliers preserve FS25's native time-varying sky colour.
		red = 1,
		green = 1,
		blue = 1,
		intensity = 1,
		colourTemp = 6600,
		colourTempIsPreset = false
	}
end

function proShot:getNextColourTemperature(current, axisComponent)
	current = math.clamp(tonumber(current) or 6600, 1000, 40000)
	if axisComponent < 0 then
		return math.min(math.floor(current + current / 10), 40000)
	end
	return math.max(math.floor(current - current / 10), 1000)
end

function proShot:shiftColourTemperature(red, green, blue, oldKelvin, newKelvin, maximum)
	local oldRed, oldGreen, oldBlue = proShot:colourTempToRGB(oldKelvin, 1)
	local newRed, newGreen, newBlue = proShot:colourTempToRGB(newKelvin, 1)
	local limit = maximum or 1
	local function shift(component, oldWhite, newWhite)
		-- Preserve the map's existing tint and night-time brightness by applying
		-- only the relative white-balance change. Replacing the colour with a
		-- bare Kelvin RGB value turns native moonlight into daylight colouring.
		if oldWhite > 0.000001 then
			return math.clamp(component * newWhite / oldWhite, 0, limit)
		end
		return math.clamp(component + newWhite - oldWhite, 0, limit)
	end
	return shift(red, oldRed, newRed), shift(green, oldGreen, newGreen),
		shift(blue, oldBlue, newBlue)
end

function proShot:applySkyState()
	local state = proShot.skyState
	if state == nil then
		return
	end
	local env = g_currentMission.environment
	local lighting = env.lighting
	local dayMinutes = env.dayTime / 60000
	local primaryRot, secondaryRot
	local primaryBaseR, primaryBaseG, primaryBaseB
	local secondaryBaseR, secondaryBaseG, secondaryBaseB
	if lighting.lightScatteringRotCurve ~= nil then
		primaryRot, secondaryRot = lighting.lightScatteringRotCurve:get(dayMinutes)
		primaryBaseR, primaryBaseG, primaryBaseB = lighting.primaryExtraterrestrialColor:get(dayMinutes)
		secondaryBaseR, secondaryBaseG, secondaryBaseB = lighting.secondaryExtraterrestrialColor:get(dayMinutes)
	else
		primaryRot, secondaryRot = unpack(lighting.lightScatteringRotation)
		primaryBaseR, primaryBaseG, primaryBaseB = unpack(lighting.primaryExtraterrestrialColor)
		secondaryBaseR, secondaryBaseG, secondaryBaseB = unpack(lighting.secondaryExtraterrestrialColor)
	end
	local primaryX, primaryY, primaryZ = mathEulerRotateVector(lighting.sunHeightAngle, 0, primaryRot, 0, 0, 1)
	local secondaryX, secondaryY, secondaryZ = mathEulerRotateVector(lighting.sunHeightAngle, 0, secondaryRot, 0, 0, 1)
	setLightScatteringDirection(lighting.sunLightId, primaryX, primaryY, primaryZ)
	setLightScatteringColor(lighting.sunLightId,
		primaryBaseR * state.red * state.intensity,
		primaryBaseG * state.green * state.intensity,
		primaryBaseB * state.blue * state.intensity)
	setAtmosphereSecondaryLightSource(secondaryX, secondaryY, secondaryZ,
		secondaryBaseR * state.red * state.intensity,
		secondaryBaseG * state.green * state.intensity,
		secondaryBaseB * state.blue * state.intensity)
end

function proShot:changeSkyColourTemperature(axisComponent)
	if axisComponent == 0 or proShot.skyState == nil then
		return
	end
	local state = proShot.skyState
	local oldKelvin = state.colourTemp or 6600
	local newKelvin = proShot:getNextColourTemperature(oldKelvin, axisComponent)
	state.red, state.green, state.blue = proShot:shiftColourTemperature(
		state.red, state.green, state.blue, oldKelvin, newKelvin,
		proShot.MAX_SKY_GROUND_RGB)
	state.colourTemp = newKelvin
	state.colourTempIsPreset = true
	proShot:applySkyState()
end

function proShot:changeSkyIntensity(axisComponent)
	if axisComponent ~= 0 and proShot.skyState ~= nil then
		local current = proShot.skyState.intensity
		local step = current <= proShot.LIGHTING_FINE_INTENSITY_LIMIT and 0.01 or 0.05
		if axisComponent < 0 and current > proShot.LIGHTING_FINE_INTENSITY_LIMIT and current - step < proShot.LIGHTING_FINE_INTENSITY_LIMIT then
			step = current - proShot.LIGHTING_FINE_INTENSITY_LIMIT
		end
		proShot.skyState.intensity = math.clamp(current + axisComponent * step, 0, proShot.MAX_SKY_GROUND_INTENSITY)
		proShot:applySkyState()
	end
end

function proShot:changeGroundLightColourTemperature(axisComponent)
	if axisComponent == 0 or proShot.sun == nil then
		return
	end
	local red, green, blue = proShot:getGroundLightComponents()
	if red == nil then
		return
	end
	local oldKelvin = proShot.sun.colourTemp or 6600
	local newKelvin = proShot:getNextColourTemperature(oldKelvin, axisComponent)
	red, green, blue = proShot:shiftColourTemperature(red, green, blue,
		oldKelvin, newKelvin, proShot.MAX_SKY_GROUND_RGB)
	proShot.sun.colourTemp = newKelvin
	setLightColor(proShot.sun.lightNode, red * proShot.sun.intensity,
		green * proShot.sun.intensity, blue * proShot.sun.intensity)
	proShot.sun.colourTempIsPreset = true
end

function proShot:changeGroundLightIntensity(axisComponent)
	if axisComponent == 0 then
		return
	end
	local current = proShot.sun.intensity
	local step = current <= proShot.LIGHTING_FINE_INTENSITY_LIMIT and 0.01 or 0.05
	if axisComponent < 0 and current > proShot.LIGHTING_FINE_INTENSITY_LIMIT and current - step < proShot.LIGHTING_FINE_INTENSITY_LIMIT then
		step = current - proShot.LIGHTING_FINE_INTENSITY_LIMIT
	end
	proShot:lightIntensityChange(axisComponent * step, proShot.sun, proShot.MAX_SKY_GROUND_INTENSITY)
end

function proShot:changeLinkedLightingTemperature(axisComponent)
	proShot:changeSkyColourTemperature(axisComponent)
	proShot:changeGroundLightColourTemperature(axisComponent)
end

function proShot:changeLinkedLightingIntensity(axisComponent)
	proShot:changeSkyIntensity(axisComponent)
	proShot:changeGroundLightIntensity(axisComponent)
end

function proShot:getFocusWorldPosition()
	local focus = proShot.focusAssist
	if focus == nil then
		return nil
	end
	if focus.node ~= nil and focus.node ~= 0 and entityExists(focus.node) then
		return localToWorld(focus.node, focus.localX, focus.localY, focus.localZ)
	end
	return focus.worldX, focus.worldY, focus.worldZ
end

function proShot:applyFocusAssist()
	local x, y, z = proShot:getFocusWorldPosition()
	if x == nil then
		return
	end
	local camX, camY, camZ = getWorldTranslation(proShot.ourCamera)
	local distance = MathUtil.vector3Length(x - camX, y - camY, z - camZ)
	-- Keep the near and far widths independent. The near side can bottom out at
	-- the camera while the far side continues widening, without accumulating an
	-- invisible overrun that must be unwound before Narrow responds again.
	local nearWidth = math.clamp(proShot.focusAssist.nearWidth or 0.5, 0.1, math.max(distance - 0.1, 0.1))
	local farWidth = math.clamp(proShot.focusAssist.farWidth or 0.5, 0.1, math.max(2499 - distance, 0.1))
	local state = table.clone(proShot.DoFState)
	-- Focus assist deliberately uses the strongest FS25 CoC levels so it remains
	-- visible even when the user's previous manual DoF preset was very subtle.
	state[1] = 10
	state[2] = math.max(distance - nearWidth, 0.1)
	state[3] = 20
	state[4] = math.min(math.max(distance + farWidth, state[2] + 0.1), 2499)
	state[2] = math.min(state[2], state[4] - 0.1)
	state[5] = math.min(state[4] + math.max(1, farWidth), 2500)
	proShot:setDoFState(state)
	proShot.focusAssist.distance = distance
	proShot.focusAssist.nearWidth = nearWidth
	proShot.focusAssist.farWidth = farWidth
	proShot.focusAssist.effectiveNearWidth = distance - state[2]
	proShot.focusAssist.effectiveFarWidth = state[4] - distance
end

function proShot:adjustFocusRange(direction)
	if proShot.focusAssist == nil then
		return
	end
	local step = math.max(0.1, proShot.focusAssist.distance * 0.01)
	local nearMaximum = math.max(proShot.focusAssist.distance - 0.1, 0.1)
	local farMaximum = math.max(2499 - proShot.focusAssist.distance, 0.1)
	proShot.focusAssist.nearWidth = math.clamp(proShot.focusAssist.nearWidth + direction * step, 0.1, nearMaximum)
	proShot.focusAssist.farWidth = math.clamp(proShot.focusAssist.farWidth + direction * step, 0.1, farMaximum)
	proShot:applyFocusAssist()
end

function proShot:setCentreFocus()
	-- RaycastUtil wraps FS25's reordered raycastClosest signature and returns the
	-- hit node plus world position, which also lets moving targets stay tracked.
	local x, y, z, dx, dy, dz = RaycastUtil.getCameraPickingRay(0.5, 0.5, proShot.ourCamera)
	local mask = CollisionFlag.TERRAIN + CollisionFlag.CAMERA_BLOCKING + CollisionFlag.WATER
	local node, hitX, hitY, hitZ, distance = RaycastUtil.raycastClosest(x, y, z, dx, dy, dz, 2500, mask)
	if node == nil then
		proShot.focusAssist = nil
		proShot:refreshFocusMenus()
		proShot:showToast(g_i18n:getText("proShot_focus_noTarget"))
		return false
	end
	local localX, localY, localZ = worldToLocal(node, hitX, hitY, hitZ)
	proShot.focusAssist = {
		node = node,
		localX = localX,
		localY = localY,
		localZ = localZ,
		worldX = hitX,
		worldY = hitY,
		worldZ = hitZ,
		distance = distance,
		nearWidth = math.max(0.5, distance * 0.05),
		farWidth = math.max(0.5, distance * 0.05)
	}
	proShot:applyFocusAssist()
	proShot:refreshFocusMenus()
	return true
end

function proShot:setEverythingInFocus()
	-- Match the useful no-blur baseline observed in FS25. Near CoC must remain
	-- non-zero (0 produces a black frame), while Far CoC 0 is valid and disables
	-- background blur. The distance values retain FS25's normal long-range limits.
	proShot.focusAssist = nil
	proShot:setDoFState({ 0.8, 0.5, 0, 1000, 1400, false })
	proShot:refreshFocusMenus()
end

function proShot:getFocusActionKeyText()
	if g_inputDisplayManager ~= nil and g_inputDisplayManager.getKeyboardInputActionKey ~= nil then
		local positiveAxis = Binding ~= nil and Binding.AXIS_COMPONENT ~= nil
			and Binding.AXIS_COMPONENT.POSITIVE or 1
		local ok, keyText = pcall(g_inputDisplayManager.getKeyboardInputActionKey,
			g_inputDisplayManager, "PRO_SHOT_0", positiveAxis)
		if ok and keyText ~= nil and keyText ~= "" then
			return keyText
		end
	end
	return "0"
end

function proShot:handleCentreFocusInput(axisComponent)
	if axisComponent == 0 then
		-- Removing and rebuilding the action menu generates synthetic releases.
		-- Preserve the timer through those so holding 0 can still be recognised.
		if not proShot.menuRebuilding then
			proShot.focusHoldStartTime = nil
			proShot.focusHoldTriggered = false
			proShot.keyLockout.PRO_SHOT_0 = nil
		end
		return
	end

	if proShot.focusHoldStartTime == nil then
		proShot.focusHoldStartTime = g_time
		proShot.focusHoldTriggered = false
		proShot:disarmFlashlightReset("PRO_SHOT_0")
		if proShot:setCentreFocus() then
			proShot:showToast(string.format(g_i18n:getText("proShot_focus_holdClear"),
				proShot:getFocusActionKeyText()), 2500)
		end
	elseif not proShot.focusHoldTriggered
		and g_time - proShot.focusHoldStartTime >= proShot.FOCUS_HOLD_DURATION_MS then
		proShot.focusHoldTriggered = true
		proShot:setEverythingInFocus()
	end
end

function proShot:clearFocusAssist()
	proShot.focusAssist = nil
	proShot:refreshFocusMenus()
end

function proShot:isHighQualityPreset()
	return math.abs(getViewDistanceCoeff() - 10) < 0.001
		and math.abs(getLODDistanceCoeff() - 10) < 0.001
		and math.abs(getTerrainLODDistanceCoeff() - 10) < 0.001
		and math.abs(getFoliageViewDistanceCoeff() - 5) < 0.001
end

function proShot:updateMainDynamicText()
	if proShot.dynamicMenuNames == nil then
		return
	end
	proShot.dynamicMenuNames.qualityToggle = g_i18n:getText(proShot:isHighQualityPreset() and "proShot_menu_qualLow" or "proShot_menu_qualHigh")
	proShot.dynamicMenuNames.mainReset = g_i18n:getText(proShot.resetFlashlightsArmed and "proShot_menu_resetFlashlightsToo" or "proShot_menu_resetAll")
	proShot.dynamicMenuNames.focusAssist = g_i18n:getText("proShot_focus_set")
	-- The action help describes what pressing the cycle key will select; the
	-- information box separately reports the aids that are active right now.
	local gridIndex = proShot.gridAidIndex or 1
	local gridName = proShot.GRID_AIDS[gridIndex % #proShot.GRID_AIDS + 1]
	local gridKey = proShot.GRID_AID_TEXT_KEYS[gridName] or ("proShot_grid_" .. gridName)
	proShot.dynamicMenuNames.gridAid = string.format(g_i18n:getText("proShot_composition_grid"), g_i18n:getText(gridKey))
	local aspectIndex = proShot.aspectAidIndex or 1
	local nextAspect = proShot.ASPECT_AIDS[aspectIndex % #proShot.ASPECT_AIDS + 1]
	proShot.dynamicMenuNames.aspectAid = string.format(g_i18n:getText("proShot_composition_aspect"), nextAspect[1])
end

function proShot:buildMainMenu()
	local menu = {
		{ "PRO_SHOT_BACKSLASH", "callbackMenu_main", {"mainReset"}, 1 },
		{ "PRO_SHOT_1", "callbackMenu_main", {"qualityToggle"}, 2 },
		{ "PRO_SHOT_2", "callbackMenu_main", {"gridAid"}, 2 },
		{ "PRO_SHOT_3", "callbackMenu_main", {"aspectAid"}, 2 },
		{ "PRO_SHOT_4", "callbackMenu_main", g_i18n:getText("proShot_menu_environment"), 2 },
		{ "PRO_SHOT_5", "callbackMenu_main", g_i18n:getText("proShot_menu_advLightMenu"), 2 },
		{ "PRO_SHOT_6", "callbackMenu_main", g_i18n:getText("proShot_menu_advMenus"), 2 },
		{ "PRO_SHOT_7", "callbackMenu_main", g_i18n:getText("proShot_menu_favourites"), 2 },
		{ "PRO_SHOT_MINUSEQUALS", "callbackMenu_main", g_i18n:getText("proShot_menu_exposure"), 3 },
		{ "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_main", g_i18n:getText("proShot_menu_FoV"), 3 },
		{ "PRO_SHOT_DIVMUL", "callbackMenu_main", g_i18n:getText("proShot_menu_lightingTemperature"), 3 },
		{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_main", g_i18n:getText("proShot_menu_lightingIntensity"), 3 },
		{ "PRO_SHOT_0", "callbackMenu_main", {"focusAssist"}, 4 }
	}
	-- Number keys 8 and 9 only become focus-range controls after a target exists.
	if proShot.focusAssist ~= nil then
		table.insert(menu, { "PRO_SHOT_8", "callbackMenu_main", g_i18n:getText("proShot_focus_narrow"), 4 })
		table.insert(menu, { "PRO_SHOT_9", "callbackMenu_main", g_i18n:getText("proShot_focus_widen"), 4 })
	end
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 5 })
	table.insert(menu, { "PRO_SHOT_F", "callbackMenu_main", g_i18n:getText("input_TOGGLE_LIGHTS_FPS"), 6 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 6 })
	return menu
end

function proShot:buildWildlifeMenu()
	local wildlife = proShot:getSelectedWildlife(false)
	local bird = proShot:getSelectedWildlife(true)
	local farmAnimal = proShot:getSelectedFarmAnimal()
	local wildlifeName = proShot:getWildlifeDisplayName(wildlife)
	local nextWildlifeName = proShot:getWildlifeDisplayName(proShot:getNextWildlife(false))
	local nextBirdName = proShot:getWildlifeDisplayName(proShot:getNextWildlife(true))
	local birdName = proShot:getWildlifePluralName(bird)
	local menu = {
		{ "PRO_SHOT_1", "callbackMenu_wildlife", string.format(g_i18n:getText("proShot_wildlife_spawn"), wildlifeName), 2 },
		{ "PRO_SHOT_2", "callbackMenu_wildlife", string.format(g_i18n:getText("proShot_wildlife_selectAnimal"), nextWildlifeName), 2 },
		{ "PRO_SHOT_3", "callbackMenu_wildlife", g_i18n:getText(proShot.wildlifePaused and "proShot_wildlife_resumeAnimals" or "proShot_wildlife_pauseAnimals"), 2 },
		{ "PRO_SHOT_4", "callbackMenu_wildlife", g_i18n:getText("proShot_wildlife_removeLastAnimal"), 2 },
		{ "PRO_SHOT_5", "callbackMenu_wildlife", string.format(g_i18n:getText("proShot_wildlife_spawnFlying"), birdName), 2 },
		{ "PRO_SHOT_6", "callbackMenu_wildlife", string.format(g_i18n:getText("proShot_wildlife_selectBird"), nextBirdName), 2 },
		{ "PRO_SHOT_7", "callbackMenu_wildlife", g_i18n:getText(proShot.birdsPaused and "proShot_wildlife_resumeBirds" or "proShot_wildlife_pauseBirds"), 2 },
		{ "PRO_SHOT_8", "callbackMenu_wildlife", g_i18n:getText("proShot_wildlife_removeLastBird"), 2 },
		{ "PRO_SHOT_9", "callbackMenu_wildlife", g_i18n:getText("proShot_farm_select"), 2 },
		{ "PRO_SHOT_0", "callbackMenu_wildlife", string.format(g_i18n:getText("proShot_farm_place"),
			farmAnimal ~= nil and farmAnimal.menuName or g_i18n:getText("proShot_testing_unavailable")), 3 },
		{ "PRO_SHOT_KP_PERIOD", "callbackMenu_wildlife", g_i18n:getText("proShot_farm_removeLast"), 5 },
		{ "PRO_SHOT_KP_0", "callbackMenu_wildlife", g_i18n:getText("proShot_animals_resetOffsets"), 5 },
		{ "PRO_SHOT_BACKSLASH", "callbackMenu_wildlife", g_i18n:getText("proShot_wildlife_removeAll"), 6 },
		{ "PRO_SHOT_BACKSPACE", "callbackMenu_wildlife", g_i18n:getText("proShot_menu_returnToAdvanced"), 7 },
		{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 8 },
		{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 8 }
	}
	table.insert(menu, { "PRO_SHOT_DIVMUL", "callbackMenu_wildlife", g_i18n:getText("proShot_animals_offsetX"), 4 })
	table.insert(menu, { "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_wildlife", g_i18n:getText("proShot_animals_offsetY"), 4 })
	table.insert(menu, { "PRO_SHOT_MINUSEQUALS", "callbackMenu_wildlife", g_i18n:getText("proShot_animals_offsetZ"), 4 })
	table.insert(menu, { "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_wildlife", g_i18n:getText("proShot_animals_rotation"), 4 })
	return menu
end

function proShot:buildSceneControlsMenu()
	local traffic = proShot:getTrafficSystem()
	local pedestrians = proShot:getPedestrianSystem()
	local trafficKey = traffic ~= nil and proShot.testingTrafficEnabled and "proShot_testing_disableTraffic" or "proShot_testing_enableTraffic"
	local pedestrianKey = pedestrians ~= nil and proShot.testingPedestriansEnabled and "proShot_testing_disablePedestrians" or "proShot_testing_enablePedestrians"
	local menu = {
		{ "PRO_SHOT_1", "callbackMenu_sceneControls", g_i18n:getText(trafficKey), 2 },
		{ "PRO_SHOT_2", "callbackMenu_sceneControls", g_i18n:getText(pedestrianKey), 2 },
		{ "PRO_SHOT_3", "callbackMenu_sceneControls", g_i18n:getText(proShot.trafficPaused and "proShot_testing_resumeTraffic" or "proShot_testing_pauseTraffic"), 2 },
		{ "PRO_SHOT_4", "callbackMenu_sceneControls", g_i18n:getText(proShot.pedestriansPaused and "proShot_testing_resumePedestrians" or "proShot_testing_pausePedestrians"), 2 },
		{ "PRO_SHOT_5", "callbackMenu_sceneControls", g_i18n:getText(proShot.parkedCarsEnabled and "proShot_scene_hideParked" or "proShot_scene_showParked"), 2 },
		{ "PRO_SHOT_0", "callbackMenu_sceneControls", g_i18n:getText("proShot_testing_removeTyreTracks"), 3 },
		{ "PRO_SHOT_BACKSLASH", "callbackMenu_sceneControls", g_i18n:getText("proShot_scene_reset"), 4 },
		{ "PRO_SHOT_BACKSPACE", "callbackMenu_sceneControls", g_i18n:getText("proShot_menu_returnToAdvanced"), 5 },
		{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 6 },
		{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 6 }
	}
	return menu
end

function proShot:refreshMainMenu()
	proShot:updateMainDynamicText()
	if proShot.menus ~= nil then
		proShot.menus.main = proShot:buildMainMenu()
		if proShot.menuDesired == "main" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:refreshFocusMenus()
	proShot:refreshMainMenu()
	if proShot.menus ~= nil and proShot.buildDoFMenu ~= nil then
		proShot.menus.DoF = proShot:buildDoFMenu()
		if proShot.menuDesired == "DoF" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:getGroundLightComponents()
	if proShot.sun == nil or proShot.sun.lightNode == nil or proShot.sun.lightNode == 0 then
		return nil
	end
	local r, g, b = getLightColor(proShot.sun.lightNode)
	if proShot.sun.intensity ~= 0 then
		r, g, b = r / proShot.sun.intensity, g / proShot.sun.intensity, b / proShot.sun.intensity
	end
	return r, g, b
end

function proShot:areSkyAndGroundInSync()
	local sky = proShot.skyState
	local r, g, b = proShot:getGroundLightComponents()
	if sky == nil or r == nil then
		return true
	end
	local epsilon = 0.0005
	local valuesMatch = math.abs(sky.red - r) <= epsilon
		and math.abs(sky.green - g) <= epsilon
		and math.abs(sky.blue - b) <= epsilon
		and math.abs(sky.intensity - proShot.sun.intensity) <= epsilon
	local temperaturesMatch = sky.colourTempIsPreset == proShot.sun.colourTempIsPreset
		and (not sky.colourTempIsPreset or sky.colourTemp == proShot.sun.colourTemp)
	return valuesMatch and temperaturesMatch
end

function proShot:syncSkyToGround()
	local r, g, b = proShot:getGroundLightComponents()
	if proShot.skyState == nil or r == nil then
		return
	end
	-- Ground is the reference: it always has engine-valid RGB values, while the
	-- independent sky multipliers are deliberately allowed to exceed 1.
	proShot.skyState.red = math.clamp(r, 0, proShot.MAX_SKY_GROUND_RGB)
	proShot.skyState.green = math.clamp(g, 0, proShot.MAX_SKY_GROUND_RGB)
	proShot.skyState.blue = math.clamp(b, 0, proShot.MAX_SKY_GROUND_RGB)
	proShot.skyState.intensity = math.clamp(proShot.sun.intensity, 0, proShot.MAX_SKY_GROUND_INTENSITY)
	proShot.skyState.colourTemp = proShot.sun.colourTemp
	proShot.skyState.colourTempIsPreset = proShot.sun.colourTempIsPreset
	proShot:applySkyState()
end

function proShot:buildSkyAndGroundMenu()
	local menu = {
		{ "PRO_SHOT_DIVMUL", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_colourTemperature"), 2 },
		{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_intensity"), 2 },
		{ "PRO_SHOT_47", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_red"), 3 },
		{ "PRO_SHOT_58", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_green"), 3 },
		{ "PRO_SHOT_69", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_blue"), 3 }
	}
	if not proShot:areSkyAndGroundInSync() then
		table.insert(menu, { "PRO_SHOT_KP_0", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_syncSkyToGround"), 3 })
	end
	table.insert(menu, { "PRO_SHOT_BACKSLASH", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_resetThis"), 4 })
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_skyAndGround", g_i18n:getText("proShot_menu_returnToSky"), 4 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 })
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 })
	return menu
end

function proShot:refreshSkyAndGroundMenu()
	if proShot.menus ~= nil then
		proShot.menus.skyAndGround = proShot:buildSkyAndGroundMenu()
		if proShot.menuDesired == "skyAndGround" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:drawCompositionAids()
	local grid = proShot.GRID_AIDS[proShot.gridAidIndex or 1]
	local aspect = proShot.ASPECT_AIDS[proShot.aspectAidIndex or 1]
	local left, bottom, right, top = 0, 0, 1, 1
	local function snapX(value)
		return math.round(value / g_pixelSizeX) * g_pixelSizeX
	end
	local function snapY(value)
		return math.round(value / g_pixelSizeY) * g_pixelSizeY
	end
	local function drawVerticalRule(x, y1, y2, alpha)
		x = snapX(x)
		drawFilledRect(x - g_pixelSizeX, y1, 2 * g_pixelSizeX, y2 - y1, 1, 1, 1, alpha)
	end
	local function drawHorizontalRule(y, x1, x2, alpha)
		y = snapY(y)
		drawFilledRect(x1, y - g_pixelSizeY, x2 - x1, 2 * g_pixelSizeY, 1, 1, 1, alpha)
	end
	local function drawCompositionLine(x1, y1, x2, y2, alpha)
		-- FS25 can clip a rotated HUD line submitted from the lower edge of an
		-- inset aspect frame. Always send the high-Y endpoint first. This matters
		-- most for 1:1, where the missing rising line made both Diagonals and
		-- Golden Triangles appear as a single diagonal.
		if y1 < y2 then
			x1, x2 = x2, x1
			y1, y2 = y2, y1
		end
		drawLine2D(x1, y1, x2, y2, g_pixelSizeX, 1, 1, 1, alpha)
	end
	if aspect[2] ~= nil then
		-- Establish the exact target rectangle first, including its normal
		-- letterbox/pillarbox mask, then move the visible guide inward. FS25 HUD
		-- coordinates are normalized rather than physical pixels, so the inset is
		-- scaled per axis to preserve the selected aspect ratio while keeping every
		-- side at least ten physical pixels from a viewport or mask edge.
		local targetAspect = aspect[2]
		if g_screenAspectRatio > targetAspect then
			local width = targetAspect / g_screenAspectRatio
			left = 0.5 - width * 0.5
			right = 0.5 + width * 0.5
			drawFilledRect(0, 0, left, 1, 0, 0, 0, 0.55)
			drawFilledRect(right, 0, 1 - right, 1, 0, 0, 0, 0.55)
		else
			local height = g_screenAspectRatio / targetAspect
			bottom = 0.5 - height * 0.5
			top = 0.5 + height * 0.5
			drawFilledRect(0, 0, 1, bottom, 0, 0, 0, 0.55)
			drawFilledRect(0, top, 1, 1 - top, 0, 0, 0, 0.55)
		end
		local insetYPixels = 10 * math.max(1, 1 / targetAspect)
		local insetXPixels = targetAspect * insetYPixels
		left = left + insetXPixels * g_pixelSizeX
		right = right - insetXPixels * g_pixelSizeX
		bottom = bottom + insetYPixels * g_pixelSizeY
		top = top - insetYPixels * g_pixelSizeY
		-- Every supported aspect frame is centred, so derive the far edges from
		-- the snapped near edges. This guarantees identical physical margins even
		-- when the calculated frame size lands on a half pixel.
		left, bottom = snapX(left), snapY(bottom)
		right, top = 1 - left, 1 - bottom
		local borderWidth = 2 * g_pixelSizeX
		local borderHeight = 2 * g_pixelSizeY
		drawFilledRect(left, bottom, right - left, borderHeight, 1, 1, 1, 0.8)
		drawFilledRect(left, top - borderHeight, right - left, borderHeight, 1, 1, 1, 0.8)
		drawFilledRect(left, bottom, borderWidth, top - bottom, 1, 1, 1, 0.8)
		drawFilledRect(right - borderWidth, bottom, borderWidth, top - bottom, 1, 1, 1, 0.8)
	end

	local width = right - left
	local height = top - bottom
	if grid == "thirds" then
		for i = 1, 2 do
			drawVerticalRule(left + width * i / 3, bottom, top, 0.7)
			drawHorizontalRule(bottom + height * i / 3, left, right, 0.7)
		end
	elseif grid == "goldenRatio" then
		local inversePhi = 2 / (1 + math.sqrt(5))
		for _, ratio in ipairs({ 1 - inversePhi, inversePhi }) do
			drawVerticalRule(left + width * ratio, bottom, top, 0.7)
			drawHorizontalRule(bottom + height * ratio, left, right, 0.7)
		end
	elseif grid == "centre" then
		local cx, cy = (left + right) * 0.5, (bottom + top) * 0.5
		drawVerticalRule(cx, bottom, top, 0.7)
		drawHorizontalRule(cy, left, right, 0.7)
	elseif grid == "diagonals" then
		drawCompositionLine(left, bottom, right, top, 0.7)
		drawCompositionLine(left, top, right, bottom, 0.7)
	elseif grid == "diagonalMethod" then
		-- Westhoff Diagonal Method: project one physical 45-degree line from
		-- every corner. On a landscape frame these form overlapping X shapes
		-- across the sides; on a portrait frame the X shapes stack vertically.
		local physicalWidth = width * g_screenAspectRatio
		local physicalHeight = height
		local diagonalLength = math.min(physicalWidth, physicalHeight)
		local diagonalWidth = diagonalLength / g_screenAspectRatio
		local diagonalHeight = diagonalLength

		if math.abs(physicalWidth - physicalHeight) < 0.001 then
			-- Opposing corner projections coincide in a square frame.
			drawCompositionLine(left, top, right, bottom, 0.7)
			drawCompositionLine(right, top, left, bottom, 0.7)
		else
			drawCompositionLine(left + diagonalWidth, bottom + diagonalHeight, left, bottom, 0.7)
			drawCompositionLine(left, top, left + diagonalWidth, top - diagonalHeight, 0.7)
			drawCompositionLine(right - diagonalWidth, bottom + diagonalHeight, right, bottom, 0.7)
			drawCompositionLine(right, top, right - diagonalWidth, top - diagonalHeight, 0.7)
		end
	elseif grid == "goldenTriangles" then
		-- A Golden Triangles overlay: one frame diagonal plus perpendiculars
		-- from the other two corners. Calculate the projection in physical screen
		-- space because normalized HUD X and Y units have different pixel sizes.
		local physicalWidth = width * g_screenAspectRatio
		local physicalHeight = height
		local denominator = physicalWidth * physicalWidth + physicalHeight * physicalHeight
		local topLeftT = physicalHeight * physicalHeight / denominator
		local bottomRightT = physicalWidth * physicalWidth / denominator
		local topLeftFootX = left + topLeftT * width
		local topLeftFootY = bottom + topLeftT * height
		local bottomRightFootX = left + bottomRightT * width
		local bottomRightFootY = bottom + bottomRightT * height

		drawCompositionLine(left, bottom, right, top, 0.7)
		drawCompositionLine(left, top, topLeftFootX, topLeftFootY, 0.7)
		drawCompositionLine(right, bottom, bottomRightFootX, bottomRightFootY, 0.7)
	end
end

function proShot:drawCameraReticle()
	local centreX, centreY = 0.5, 0.5
	local gapX, gapY = 5 * g_pixelSizeX, 5 * g_pixelSizeY
	local armX, armY = 18 * g_pixelSizeX, 18 * g_pixelSizeY
	local bracketX, bracketY = 11 * g_pixelSizeX, 11 * g_pixelSizeY
	local cornerX, cornerY = 5 * g_pixelSizeX, 5 * g_pixelSizeY
	local shadowX, shadowY = g_pixelSizeX, -g_pixelSizeY
	local function drawParts(offsetX, offsetY, r, g, b, a, thickness)
		local x, y = centreX + offsetX, centreY + offsetY
		drawLine2D(x - armX, y, x - gapX, y, thickness, r, g, b, a)
		drawLine2D(x + gapX, y, x + armX, y, thickness, r, g, b, a)
		drawLine2D(x, y - armY, x, y - gapY, thickness, r, g, b, a)
		drawLine2D(x, y + gapY, x, y + armY, thickness, r, g, b, a)

		-- Four interrupted focus-frame corners give the centre mark the same
		-- visual language as a DSLR autofocus point without obscuring the subject.
		drawLine2D(x - bracketX, y + bracketY, x - bracketX + cornerX, y + bracketY, thickness, r, g, b, a)
		drawLine2D(x - bracketX, y + bracketY, x - bracketX, y + bracketY - cornerY, thickness, r, g, b, a)
		drawLine2D(x + bracketX, y + bracketY, x + bracketX - cornerX, y + bracketY, thickness, r, g, b, a)
		drawLine2D(x + bracketX, y + bracketY, x + bracketX, y + bracketY - cornerY, thickness, r, g, b, a)
		drawLine2D(x - bracketX, y - bracketY, x - bracketX + cornerX, y - bracketY, thickness, r, g, b, a)
		drawLine2D(x - bracketX, y - bracketY, x - bracketX, y - bracketY + cornerY, thickness, r, g, b, a)
		drawLine2D(x + bracketX, y - bracketY, x + bracketX - cornerX, y - bracketY, thickness, r, g, b, a)
		drawLine2D(x + bracketX, y - bracketY, x + bracketX, y - bracketY + cornerY, thickness, r, g, b, a)
	end

	drawParts(shadowX, shadowY, 0, 0, 0, 0.85, 2 * g_pixelSizeX)
	drawParts(0, 0, 1, 1, 1, 0.9, g_pixelSizeX)
end

function proShot:removeActionEvents()
	proShot.menuRebuilding = true
	for key, eventId in pairs(proShot.buttonId) do
		g_inputBinding:removeActionEvent(eventId)
		proShot.buttonId[key] = nil
	end
	proShot.menuRebuilding = false
end

function proShot:restoreEnvironment()
	local env = g_currentMission.environment
	local snowSystem = g_currentMission.snowSystem
	local fwyc = proShot.fromWhenceYouCame
	local rebuildNativeSnow = proShot.localSnowEdited == true

	-- The FS25 environment save data contains time and weather, but fixed visual
	-- season and debug shader overrides are runtime state and must be restored too.
	env.mission.missionInfo.fixedSeasonalVisuals = fwyc.fixedSeasonalVisuals
	if rebuildNativeSnow then
		-- Local density-map writes are intentionally independent of SnowSystem.height:
		-- a lowered-to-zero patch loses its snow fill type, while a raised patch can
		-- exceed the native height. Queue FS25's unconditional remove-all delta first;
		-- loading the saved environment immediately afterwards queues native, masked
		-- repopulation to the original level.
		proShot.pendingSnowAreaHeight = nil
		proShot.snowAreaRestore = nil
		snowSystem:removeAll(true)
		proShot:debugLog("queued native snow rebuild after local editing")
	end
	env:loadFromXMLFile(fwyc.environment, "environment")
	env.visualPeriodLocked = fwyc.visualPeriodLocked
	env.currentVisualPeriod = fwyc.currentVisualPeriod
	env.currentVisualSeason = fwyc.currentVisualSeason
	env.currentVisualDayInSeason = fwyc.currentVisualDayInSeason
	env.currentDayInSeason = fwyc.currentDayInSeason
	env.mission.missionInfo.fixedSeasonalVisuals = fwyc.fixedSeasonalVisuals
	env:consoleCommandSetSeasonalShader(fwyc.forcedSeasonShaderValue)
	env:updateJulianDay()
	env.environmentMaskSystem:setDayOfYear(Environment.PERIOD_DAY_MAPPING[env.currentVisualPeriod], env.currentVisualSeason)
	env.lighting:setVisualSeason(env.currentVisualSeason)
	proShot.seasonTweak = 0

	-- Environment:loadFromXMLFile restores the native weather snow height through
	-- SnowSystem itself. Do not reconstruct an area unless ProShot actually used its
	-- above-native extension, and then touch existing snow cells only.
	if not rebuildNativeSnow and proShot.snowAreaRestore ~= nil then
		proShot.snowAreaRestore.height = fwyc.snowLevel
			or math.min(tonumber(snowSystem.exactHeight) or 0, SnowSystem.MAX_HEIGHT)
		proShot.pendingSnowAreaHeight = proShot.snowAreaRestore
		proShot:applyPendingSnowAreaHeight()
	else
		proShot.pendingSnowAreaHeight = nil
	end
	snowSystem.debug_forcedSnowShaderValue = fwyc.forcedSnowShaderValue
	snowSystem:updateSnowShader()
	env:update(g_currentDt)
end

function proShot:setInputHelpWide(isWide)
	local inputHelp = g_currentMission ~= nil and g_currentMission.hud ~= nil and g_currentMission.hud.inputHelp or nil
	if inputHelp == nil then
		proShot.inputHelpIsWide = false
		return
	end

	if isWide then
		-- FS25 truncates help text against lineBg.width. Keep this change on the
		-- live ProShot display only; storeScaledValues restores every native value.
		local width = inputHelp:scalePixelToScreenWidth(520)
		inputHelp.lineBg:setDimension(width, nil)
		inputHelp.comboBg:setDimension(width, nil)
		inputHelp.separatorHorizontal:setDimension(width, nil)
		inputHelp.helpAnchorOffsetX = inputHelp:scalePixelToScreenWidth(530)
		proShot.inputHelpIsWide = true
	elseif proShot.inputHelpIsWide then
		inputHelp:storeScaledValues()
		proShot.inputHelpIsWide = false
	end
end

function proShot:showToast(text, durationMs)
	proShot.toastText = text
	proShot.toastEndTime = g_time + (durationMs or 1000)
end

function proShot:addInfoLine(box, key, value, color)
	box:addLine(key, value)
	-- InfoDisplayKeyValueBox reuses line tables, so always overwrite this field.
	local line = box.lines[box.currentLineIndex]
	line.proShotColor = color
	line.proShotSectionHeading = nil
	line.proShotEffectHeading = nil
	line.proShotEffectValues = nil
	line.proShotRGBValues = nil
	line.proShotEffectThresholdText = nil
	line.proShotLineHeight = nil
	line.proShotLineOffsetY = nil
end

function proShot:addInfoRGBLine(box, key, red, green, blue, keyColor)
	proShot:addInfoLine(box, key, "", keyColor)
	local line = box.lines[box.currentLineIndex]
	line.proShotRGBValues = {
		string.format("R %.2f", red),
		string.format("G %.2f", green),
		string.format("B %.2f", blue)
	}
end

function proShot:addInfoSectionHeading(box, text)
	box:addLine(text, "")
	local line = box.lines[box.currentLineIndex]
	line.proShotColor = nil
	line.proShotSectionHeading = true
	line.proShotEffectHeading = nil
	line.proShotEffectValues = nil
	line.proShotRGBValues = nil
	line.proShotEffectThresholdText = nil
	line.proShotLineHeight = box.lineHeight * 1.08
	line.proShotLineOffsetY = box.lineToLineOffsetY * 1.08
end

function proShot:addEffectSummaryHeading(box, group, isHighlighted)
	box:addLine(g_i18n:getText("proShot_effect_" .. group), "")
	local line = box.lines[box.currentLineIndex]
	line.proShotColor = isHighlighted and proShot.INFO_COLOR.HIGHLIGHT or nil
	line.proShotSectionHeading = nil
	line.proShotEffectHeading = true
	line.proShotEffectValues = nil
	line.proShotRGBValues = nil
	line.proShotEffectThresholdText = nil
	if group == "shadows" then
		line.proShotEffectThresholdText = string.format(g_i18n:getText("proShot_effect_maxLuminance"), proShot.effectEditorState.shadowsMaxLuminance)
	elseif group == "highlights" then
		line.proShotEffectThresholdText = string.format(g_i18n:getText("proShot_effect_minLuminance"), proShot.effectEditorState.highlightsMinLuminance)
	end
	line.proShotLineHeight = box.lineHeight * 0.82
	line.proShotLineOffsetY = box.lineToLineOffsetY * 0.82
end

function proShot:addEffectSummaryValue(box, property, value, isHighlighted)
	box:addLine(g_i18n:getText("proShot_effect_" .. property), "")
	local line = box.lines[box.currentLineIndex]
	line.proShotColor = isHighlighted and proShot.INFO_COLOR.HIGHLIGHT or nil
	line.proShotSectionHeading = nil
	line.proShotEffectHeading = false
	line.proShotEffectThresholdText = nil
	line.proShotRGBValues = nil
	line.proShotEffectValues = {
		string.format("%.2f", value.red),
		string.format("%.2f", value.green),
		string.format("%.2f", value.blue),
		string.format("%.2f", value.scale)
	}
	line.proShotLineHeight = box.lineHeight * 0.76
	line.proShotLineOffsetY = box.lineToLineOffsetY * 0.76
end

function proShot:addEffectSummary(box, activeGroup, activeProperty)
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		proShot:addEffectSummaryHeading(box, group, group == activeGroup)
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			proShot:addEffectSummaryValue(box, property, proShot.effectEditorState[group][property], group == activeGroup and property == activeProperty)
		end
	end
end

function proShot:drawInfoBox(box, posX, posY)
	-- FS25's addLine no longer accepts a per-line colour. This is the current
	-- FS25 renderer with one local, optional colour field; no game class or other
	-- HUD instance is overwritten.
	local boxLeft = posX - box.boxWidth
	local boxHeight = box.titleAndBoxHeight
	for _, line in ipairs(box.lines) do
		if line.isActive then
			boxHeight = boxHeight + (line.proShotLineHeight or box.lineHeight)
			if line.isWarning then
				boxHeight = boxHeight + math.abs(box.warningOffsetY)
			end
		end
	end

	box.bgScale:setDimension(nil, boxHeight - box.bgBottom.height - box.bgTop.height)
	box.bgBottom:setPosition(boxLeft, posY)
	box.bgBottom:render()
	box.bgScale:setPosition(boxLeft, box.bgBottom.y + box.bgBottom.height)
	box.bgScale:render()
	box.bgTop:setPosition(boxLeft, box.bgScale.y + box.bgScale.height)
	box.bgTop:render()

	local titleX = boxLeft + box.titleOffsetX
	local titleY = box.bgTop.y + box.bgTop.height + box.titleOffsetY
	setTextAlignment(RenderText.ALIGN_LEFT)
	local titleColor = box.proShotTitleColor or { 1, 1, 1, 1 }
	setTextColor(titleColor[1], titleColor[2], titleColor[3], titleColor[4] or 1)
	setTextBold(true)
	renderText(titleX, titleY, box.titleTextSize, box.title)
	setTextBold(false)

	local keyX = boxLeft + box.keyOffsetX
	local warningX = boxLeft + box.warningOffsetX
	local warningIconX = boxLeft + box.warningIconOffsetX
	local valueX = posX + box.valueOffsetX
	local lineY = titleY + box.titleToLineOffsetY
	local activeColor = HUD.COLOR.ACTIVE
	local inactiveColor = HUD.COLOR.INACTIVE

	for _, line in ipairs(box.lines) do
		if line.isActive then
			local key = line.key
			local value = line.value
			local keyWidth
			local color = line.proShotColor

			if line.proShotSectionHeading then
				color = color or { 1, 1, 1, 1 }
				setTextColor(color[1], color[2], color[3], color[4] or 1)
				setTextAlignment(RenderText.ALIGN_LEFT)
				setTextBold(true)
				-- Match the main info-box title size so this reads as a true section.
				renderText(titleX, lineY, box.titleTextSize, key)
				setTextBold(false)
			elseif line.proShotEffectHeading ~= nil then
				color = color or { 1, 1, 1, 1 }
				setTextColor(color[1], color[2], color[3], color[4] or 1)
				setTextAlignment(RenderText.ALIGN_LEFT)
				setTextBold(line.proShotEffectHeading)
				renderText(keyX, lineY, box.keyTextSize * (line.proShotEffectHeading and 0.92 or 0.84), key)
				setTextBold(false)

				local columnWidth = (valueX - keyX) * 0.11
				if line.proShotEffectThresholdText ~= nil then
					-- Begin threshold text at the left edge of the red component column.
					setTextAlignment(RenderText.ALIGN_LEFT)
					setTextColor(1, 1, 1, 1)
					renderText(valueX - 4 * columnWidth, lineY, box.valueTextSize * 0.7, line.proShotEffectThresholdText)
				elseif line.proShotEffectValues ~= nil then
					-- Right-aligned fixed columns keep proportional-font values lined up.
					local colors = {
						proShot.INFO_COLOR.RED,
						proShot.INFO_COLOR.GREEN,
						proShot.INFO_COLOR.BLUE,
						{ 1, 1, 1, 1 }
					}
					setTextAlignment(RenderText.ALIGN_RIGHT)
					for index, text in ipairs(line.proShotEffectValues) do
						local componentColor = colors[index]
						setTextColor(componentColor[1], componentColor[2], componentColor[3], componentColor[4])
						renderText(valueX - (#line.proShotEffectValues - index) * columnWidth, lineY, box.valueTextSize * 0.76, text)
					end
				end
			elseif line.isWarning then
				color = color or activeColor
				setTextAlignment(RenderText.ALIGN_LEFT)
				setTextColor(color[1], color[2], color[3], color[4] or 1)
				setTextBold(true)
				lineY = lineY + box.warningOffsetY
				renderText(warningX, lineY, box.keyTextSize, key)
				keyWidth = getTextWidth(box.keyTextSize, key)
				setTextBold(false)
				box.warningIcon:setPosition(warningIconX, lineY + box.warningIconOffsetY)
				box.warningIcon:render()
			else
				color = color or { 1, 1, 1, 1 }
				setTextColor(color[1], color[2], color[3], color[4] or 1)
				setTextAlignment(RenderText.ALIGN_LEFT)
				renderText(keyX, lineY, box.keyTextSize, key)
				keyWidth = getTextWidth(box.keyTextSize, key)
			end

			if line.proShotRGBValues ~= nil then
				local componentColors = {
					proShot.INFO_COLOR.RED,
					proShot.INFO_COLOR.GREEN,
					proShot.INFO_COLOR.BLUE
				}
				local gap = 7 * g_pixelSizeX
				local widths = {}
				local totalWidth = gap * (#line.proShotRGBValues - 1)
				for index, text in ipairs(line.proShotRGBValues) do
					widths[index] = getTextWidth(box.valueTextSize, text)
					totalWidth = totalWidth + widths[index]
				end

				local componentX = valueX - totalWidth
				local firstComponentX = componentX
				setTextAlignment(RenderText.ALIGN_LEFT)
				for index, text in ipairs(line.proShotRGBValues) do
					local componentColor = componentColors[index]
					setTextColor(componentColor[1], componentColor[2], componentColor[3], componentColor[4] or 1)
					renderText(componentX, lineY, box.valueTextSize, text)
					componentX = componentX + widths[index] + gap
				end

				local dashStartX = keyX + keyWidth + 3 * g_pixelSizeX
				local dashWidth = firstComponentX - dashStartX - 3 * g_pixelSizeX
				if dashWidth > 0 then
					drawDashedLine(dashStartX, lineY, dashWidth, box.dashedLineHeight, box.dashWidth, box.dashGapWidth, inactiveColor[1], inactiveColor[2], inactiveColor[3], inactiveColor[4], true)
				end
			elseif value ~= nil and value ~= "" then
				setTextColor(color[1], color[2], color[3], color[4] or 1)
				setTextAlignment(RenderText.ALIGN_RIGHT)
				renderText(valueX, lineY, box.valueTextSize, value)
				local valueWidth = getTextWidth(box.valueTextSize, value)
				local dashStartX = keyX + keyWidth + 3 * g_pixelSizeX
				local dashWidth = valueX - valueWidth - dashStartX - 3 * g_pixelSizeX
				if dashWidth > 0 then
					drawDashedLine(dashStartX, lineY, dashWidth, box.dashedLineHeight, box.dashWidth, box.dashGapWidth, inactiveColor[1], inactiveColor[2], inactiveColor[3], inactiveColor[4], true)
				end
			end

			lineY = lineY + (line.proShotLineOffsetY or box.lineToLineOffsetY)
		end
	end

	local topY = box.bgTop.y + box.bgTop.height
	setTextAlignment(RenderText.ALIGN_LEFT)
	setTextColor(1, 1, 1, 1)
	box.doShowNextFrame = false
	return posX, topY
end

function proShot:getQualityDisplayName()
	local view = getViewDistanceCoeff()
	local lod = getLODDistanceCoeff()
	local terrain = getTerrainLODDistanceCoeff()
	local foliage = getFoliageViewDistanceCoeff()
	if math.abs(view - 1) < 0.001 and math.abs(lod - 1) < 0.001 and math.abs(terrain - 1) < 0.001 and math.abs(foliage - 1) < 0.001 then
		return g_i18n:getText("proShot_value_qualityLow")
	elseif math.abs(view - 10) < 0.001 and math.abs(lod - 10) < 0.001 and math.abs(terrain - 10) < 0.001 and math.abs(foliage - 5) < 0.001 then
		return g_i18n:getText("proShot_value_qualityHigh")
	end
	return g_i18n:getText("setting_custom")
end

function proShot:getColourGradingDisplayName()
	if proShot.effectEditorDirty then
		return g_i18n:getText("setting_custom")
	end
	local slot = proShot.colourGradingSelection
	if slot ~= nil then
		local customSlot = proShot.effectSlots[slot]
		if customSlot ~= nil then
			return customSlot.name
		end
		local keys = {
			"proShot_menu_effects_preset_flat",
			"proShot_menu_effects_preset_vibrant",
			"proShot_menu_effects_preset_deep",
			"proShot_menu_effects_preset_cold",
			"proShot_menu_effects_preset_greyscale",
			"proShot_menu_effects_preset_sepiaTone",
			"proShot_menu_effects_preset_phantom"
		}
		local key = keys[slot]
		if key ~= nil then
			return g_i18n:getText(key)
		end
	end
	return g_i18n:getText("proShot_value_original")
end

function proShot:createDefaultEffectState()
	local state = {
		-- Neutral FS25 defaults from data/maps/default_colorGrading.xml.
		shadowsMaxLuminance = 0.25,
		highlightsMinLuminance = 0.35
	}
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		state[group] = {}
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			state[group][property] = { red = 1, green = 1, blue = 1, scale = 1 }
		end
	end
	return state
end

function proShot:cloneEffectState(source)
	local state = proShot:createDefaultEffectState()
	if source == nil then
		return state
	end
	state.shadowsMaxLuminance = source.shadowsMaxLuminance or state.shadowsMaxLuminance
	state.highlightsMinLuminance = source.highlightsMinLuminance or state.highlightsMinLuminance
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			local from = source[group] ~= nil and source[group][property] or nil
			if from ~= nil then
				local to = state[group][property]
				for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
					to[component] = Utils.getNoNil(from[component], to[component])
				end
			end
		end
	end
	return state
end

function proShot:effectStatesEqual(first, second)
	if first == nil or second == nil then
		return false
	end
	local epsilon = 0.00001
	if math.abs(first.shadowsMaxLuminance - second.shadowsMaxLuminance) > epsilon
		or math.abs(first.highlightsMinLuminance - second.highlightsMinLuminance) > epsilon then
		return false
	end
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
				if math.abs(first[group][property][component] - second[group][property][component]) > epsilon then
					return false
				end
			end
		end
	end
	return true
end

function proShot:readEffectStateFromXML(xmlFile, baseKey)
	local state = proShot:createDefaultEffectState()
	state.shadowsMaxLuminance = xmlFile:getFloat(baseKey .. "#shadowsMaxLuminance", state.shadowsMaxLuminance)
	state.highlightsMinLuminance = xmlFile:getFloat(baseKey .. "#highlightsMinLuminance", state.highlightsMinLuminance)
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			local key = string.format("%s.%s.%s", baseKey, group, property)
			local rgb = xmlFile:getVector(key .. "#rgb", { 1, 1, 1 }, 3)
			state[group][property] = {
				red = rgb[1],
				green = rgb[2],
				blue = rgb[3],
				scale = xmlFile:getFloat(key .. "#scale", 1)
			}
		end
	end
	return state
end

function proShot:readEffectStateFromFile(filename)
	if filename == nil or filename == "" then
		return nil
	end
	local xmlFile = XMLFile.load("ProShot active colour grading", filename)
	if xmlFile == nil then
		Logging.warning("ProShot: Could not read active colour grading '%s'", tostring(filename))
		return nil
	end
	local state = proShot:readEffectStateFromXML(xmlFile, "colorGrading")
	xmlFile:delete()
	return state
end

function proShot:interpolateEffectStates(first, second, alpha)
	if first == nil then
		return second ~= nil and proShot:cloneEffectState(second) or proShot:createDefaultEffectState()
	elseif second == nil or alpha == nil or alpha <= 0 then
		return proShot:cloneEffectState(first)
	elseif alpha >= 1 then
		return proShot:cloneEffectState(second)
	end
	local state = proShot:createDefaultEffectState()
	local function blend(a, b)
		return a + (b - a) * alpha
	end
	state.shadowsMaxLuminance = blend(first.shadowsMaxLuminance, second.shadowsMaxLuminance)
	state.highlightsMinLuminance = blend(first.highlightsMinLuminance, second.highlightsMinLuminance)
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
				state[group][property][component] = blend(first[group][property][component], second[group][property][component])
			end
		end
	end
	return state
end

function proShot:captureCurrentEffectState(lighting, dayTime)
	local env = g_currentMission ~= nil and g_currentMission.environment or nil
	lighting = lighting or (env ~= nil and env.lighting or nil)
	if lighting == nil then
		return proShot:createDefaultEffectState()
	end

	local firstFilename, secondFilename, alpha
	if lighting.colorGradingFileCurve ~= nil then
		local currentDayTime = dayTime or (env ~= nil and env.dayTime or 0)
		firstFilename, secondFilename, alpha = lighting.colorGradingFileCurve:get(currentDayTime / 60000)
	else
		firstFilename = lighting.colorGrading
		secondFilename = firstFilename
		alpha = 0
	end
	local first = proShot:readEffectStateFromFile(firstFilename)
	if firstFilename == secondFilename then
		return first or proShot:createDefaultEffectState()
	end
	local second = proShot:readEffectStateFromFile(secondFilename)
	return proShot:interpolateEffectStates(first, second, math.clamp(alpha or 0, 0, 1))
end

function proShot:writeEffectStateToXML(xmlFile, baseKey, state)
	xmlFile:setFloat(baseKey .. "#shadowsMaxLuminance", state.shadowsMaxLuminance)
	xmlFile:setFloat(baseKey .. "#highlightsMinLuminance", state.highlightsMinLuminance)
	for _, group in ipairs(proShot.EFFECT_GROUPS) do
		for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
			local key = string.format("%s.%s.%s", baseKey, group, property)
			local value = state[group][property]
			xmlFile:setVector(key .. "#rgb", { value.red, value.green, value.blue })
			xmlFile:setFloat(key .. "#scale", value.scale)
		end
	end
end

function proShot:getBuiltinEffectName(slot)
	local keys = {
		"proShot_menu_effects_preset_flat",
		"proShot_menu_effects_preset_vibrant",
		"proShot_menu_effects_preset_deep",
		"proShot_menu_effects_preset_cold",
		"proShot_menu_effects_preset_greyscale",
		"proShot_menu_effects_preset_sepiaTone",
		"proShot_menu_effects_preset_phantom"
	}
	return keys[slot] ~= nil and g_i18n:getText(keys[slot]) or nil
end

function proShot:getBuiltinEffectState(slot)
	if slot < 1 or slot > proShot.EFFECT_BUILTIN_SLOT_COUNT then
		return nil
	end
	if proShot.effectBuiltinStates[slot] == nil then
		local filename = proShot.modDir .. "xml/colorGrading/" .. proShot.EFFECT_BUILTIN_FILES[slot] .. ".xml"
		local xmlFile = XMLFile.load("ProShot built-in effect", filename)
		if xmlFile ~= nil then
			proShot.effectBuiltinStates[slot] = proShot:readEffectStateFromXML(xmlFile, "colorGrading")
			xmlFile:delete()
		else
			Logging.error("ProShot: Could not load built-in effect '%s'", filename)
			proShot.effectBuiltinStates[slot] = proShot:createDefaultEffectState()
		end
	end
	return proShot:cloneEffectState(proShot.effectBuiltinStates[slot])
end

function proShot:refreshEffectMenuNames()
	if proShot.dynamicMenuNames == nil then
		return
	end
	for slot = 1, proShot.EFFECT_SLOT_COUNT do
		local custom = proShot.effectSlots[slot]
		local name = custom ~= nil and custom.name or proShot:getBuiltinEffectName(slot) or g_i18n:getText("configuration_valueEmpty")
		proShot.dynamicMenuNames["effect" .. slot] = string.format(g_i18n:getText("proShot_effect_slotEntry"), slot, name)
		proShot.dynamicMenuNames["effectSave" .. slot] = string.format(g_i18n:getText("proShot_effect_saveSlot"), slot, name)
		proShot.dynamicMenuNames["effectReset" .. slot] = string.format(g_i18n:getText("proShot_effect_resetSlotEntry"), slot, name)
	end
	if proShot.menus ~= nil then
		proShot.menus.effects = proShot:buildEffectsMenu()
		if proShot.menuDesired == "effects" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:loadEffectSlots()
	proShot.effectSlots = {}
	local xmlFile = XMLFile.loadIfExists("ProShot effects", proShot.effectsFilename)
	if xmlFile ~= nil then
		for slot = 1, proShot.EFFECT_SLOT_COUNT do
			local key = string.format("proShotEffects.slot(%d)", slot - 1)
			if xmlFile:getBool(key .. "#custom", false) then
				proShot.effectSlots[slot] = {
					name = xmlFile:getString(key .. "#name", string.format(g_i18n:getText("proShot_effect_defaultName"), slot)),
					state = proShot:readEffectStateFromXML(xmlFile, key .. ".colorGrading"),
					bloomMagnitude = xmlFile:getFloat(key .. "#bloomMagnitude"),
					bloomThreshold = xmlFile:getFloat(key .. "#bloomThreshold"),
					bloomQuality = xmlFile:getInt(key .. "#bloomQuality"),
					ssaoQuality = xmlFile:getInt(key .. "#ssaoQuality")
				}
			end
		end
		xmlFile:delete()
	end
	proShot:refreshEffectMenuNames()
end

function proShot:saveEffectSlots()
	createFolder(proShot.settingsDirectory)
	local xmlFile = XMLFile.create("ProShot effects", proShot.effectsFilename, "proShotEffects")
	if xmlFile == nil then
		return false
	end
	xmlFile:setInt("proShotEffects#version", 1)
	for slot = 1, proShot.EFFECT_SLOT_COUNT do
		local key = string.format("proShotEffects.slot(%d)", slot - 1)
		local custom = proShot.effectSlots[slot]
		xmlFile:setInt(key .. "#index", slot)
		xmlFile:setBool(key .. "#custom", custom ~= nil)
		if custom ~= nil then
			xmlFile:setString(key .. "#name", custom.name)
			if custom.bloomMagnitude ~= nil then
				xmlFile:setFloat(key .. "#bloomMagnitude", custom.bloomMagnitude)
			end
			if custom.bloomThreshold ~= nil then
				xmlFile:setFloat(key .. "#bloomThreshold", custom.bloomThreshold)
			end
			if custom.bloomQuality ~= nil then
				xmlFile:setInt(key .. "#bloomQuality", custom.bloomQuality)
			end
			if custom.ssaoQuality ~= nil then
				xmlFile:setInt(key .. "#ssaoQuality", custom.ssaoQuality)
			end
			proShot:writeEffectStateToXML(xmlFile, key .. ".colorGrading", custom.state)
		end
	end
	local saved = xmlFile:save(false)
	xmlFile:delete()
	return saved
end

function proShot:writeEffectPreview(state)
	createFolder(proShot.settingsDirectory)
	proShot.effectPreviewIndex = proShot.effectPreviewIndex % 2 + 1
	local filename = proShot.settingsDirectory .. "effectPreview" .. proShot.effectPreviewIndex .. ".xml"
	local xmlFile = XMLFile.create("ProShot effect preview", filename, "colorGrading")
	if xmlFile == nil then
		return nil
	end
	proShot:writeEffectStateToXML(xmlFile, "colorGrading", state)
	local saved = xmlFile:save(false)
	xmlFile:delete()
	return saved and filename or nil
end

function proShot:applyEffectEditorState(markDirty)
	local filename = proShot:writeEffectPreview(proShot.effectEditorState)
	if filename == nil then
		proShot:showToast(g_i18n:getText("proShot_effect_saveFailed"))
		return false
	end
	if not proShot:setColorGradingFilename(filename) then
		return false
	end
	if markDirty then
		proShot.effectEditorDirty = true
		proShot.colourGradingSelection = nil
	end
	return true
end

function proShot:applyEffectSlot(slot, showEmptyMessage)
	local custom = proShot.effectSlots[slot]
	if custom ~= nil or slot <= proShot.EFFECT_BUILTIN_SLOT_COUNT then
		proShot:colorGradingSet(slot)
		return true
	end
	if showEmptyMessage then
		proShot:showToast(string.format(g_i18n:getText("proShot_effect_emptySlot"), slot))
	end
	return false
end

function proShot:buildEffectResetMenu()
	local menu = {}
	for slot = 1, proShot.EFFECT_SLOT_COUNT do
		if proShot.effectSlots[slot] ~= nil then
			local actionSlot = slot == 10 and 0 or slot
			table.insert(menu, { "PRO_SHOT_" .. actionSlot, "callbackMenu_effectResetSlot", { "effectReset" .. slot }, slot == 10 and 2 or 1 })
		end
	end
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_effectResetSlot", g_i18n:getText("ui_ingameMenuPrev"), 3 })
	proShot.menus.effectResetSlot = menu
	return #menu > 1
end

function proShot:buildEffectsMenu()
	local menu = {}
	for slot = 1, proShot.EFFECT_SLOT_COUNT do
		if slot <= proShot.EFFECT_BUILTIN_SLOT_COUNT or proShot.effectSlots[slot] ~= nil then
			local actionSlot = slot == 10 and 0 or slot
			table.insert(menu, { "PRO_SHOT_" .. actionSlot, "callbackMenu_effects", { "effect" .. slot }, slot == 10 and 2 or 1 })
		end
	end
	table.insert(menu, { "PRO_SHOT_47", "callbackMenu_effects", g_i18n:getText("proShot_menu_effects_bloomThreshold"), 3 })
	table.insert(menu, { "PRO_SHOT_58", "callbackMenu_effects", g_i18n:getText("proShot_menu_effects_bloomMagnitude"), 3 })
	table.insert(menu, { "PRO_SHOT_69", "callbackMenu_effects", g_i18n:getText("proShot_menu_effects_bloomQuality"), 3 })
	table.insert(menu, { "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_effects", g_i18n:getText("setting_ssaoQuality"), 3 })
	table.insert(menu, { "PRO_SHOT_EQUALS", "callbackMenu_effects", g_i18n:getText("proShot_effect_customise"), 4 })
	table.insert(menu, { "PRO_SHOT_BACKSLASH", "callbackMenu_effects", g_i18n:getText("proShot_menu_resetThis"), 4 })
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_subMenu", g_i18n:getText("proShot_menu_returnToAdvanced"), 5 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 5 })
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 5 })
	return menu
end

function proShot:buildDoFMenu()
	local menu = {}
	for slot = 1, 6 do
		table.insert(menu, { "PRO_SHOT_" .. slot, "callbackMenu_DoF", g_i18n:getText("ui_preset") .. " " .. slot, 2 })
	end
	table.insert(menu, { "PRO_SHOT_DIVMUL", "callbackMenu_DoF", g_i18n:getText("proShot_menu_DoF_nearBlurAmount"), 2 })
	table.insert(menu, { "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_DoF", g_i18n:getText("proShot_menu_DoF_nearBlurEnd"), 2 })
	table.insert(menu, { "PRO_SHOT_47", "callbackMenu_DoF", g_i18n:getText("proShot_menu_DoF_farBlurAmount"), 2 })
	table.insert(menu, { "PRO_SHOT_58", "callbackMenu_DoF", g_i18n:getText("proShot_menu_DoF_farBlurStart"), 2 })
	table.insert(menu, { "PRO_SHOT_69", "callbackMenu_DoF", g_i18n:getText("proShot_menu_DoF_farBlurEnd"), 2 })
	table.insert(menu, { "PRO_SHOT_KP_0", "callbackMenu_DoF", g_i18n:getText("proShot_DoF_applyToSky"), 2 })
	table.insert(menu, { "PRO_SHOT_0", "callbackMenu_DoF", g_i18n:getText("proShot_focus_set"), 3 })
	if proShot.focusAssist ~= nil then
		table.insert(menu, { "PRO_SHOT_8", "callbackMenu_DoF", g_i18n:getText("proShot_focus_narrow"), 3 })
		table.insert(menu, { "PRO_SHOT_9", "callbackMenu_DoF", g_i18n:getText("proShot_focus_widen"), 3 })
	end
	table.insert(menu, { "PRO_SHOT_BACKSLASH", "callbackMenu_DoF", g_i18n:getText("proShot_menu_resetThis"), 4 })
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_subMenu", g_i18n:getText("proShot_menu_returnToAdvanced"), 5 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 5 })
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 5 })
	return menu
end

function proShot:hasAnyFavourite()
	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		if proShot.favourites[slot] ~= nil then
			return true
		end
	end
	return false
end

function proShot:buildFavouritesMenu()
	local menu = {}
	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		if proShot.favourites[slot] ~= nil then
			local actionSlot = slot == 10 and 0 or slot
			table.insert(menu, { "PRO_SHOT_" .. actionSlot, "callbackMenu_favourites", { "favourite" .. slot }, slot == 10 and 4 or 3 })
		end
	end
	table.insert(menu, { "PRO_SHOT_EQUALS", "callbackMenu_favourites", g_i18n:getText("proShot_favourite_saveCurrent"), 2 })
	if proShot:hasAnyFavourite() then
		table.insert(menu, { "PRO_SHOT_MINUS", "callbackMenu_favourites", g_i18n:getText("proShot_favourite_remove"), 2 })
	end
	table.insert(menu, { "PRO_SHOT_BACKSLASH", "callbackMenu_favourites", g_i18n:getText("proShot_favourite_revertPreview"), 1 })
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_favourites", g_i18n:getText("proShot_menu_returnToMain"), 5 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 5 })
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 5 })
	return menu
end

function proShot:buildFavouriteDeleteMenu()
	local menu = {}
	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		if proShot.favourites[slot] ~= nil then
			local actionSlot = slot == 10 and 0 or slot
			table.insert(menu, { "PRO_SHOT_" .. actionSlot, "callbackMenu_favouriteDeleteSlot", { "favouriteDelete" .. slot }, slot == 10 and 4 or 3 })
		end
	end
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_favouriteDeleteSlot", g_i18n:getText("proShot_favourite_cancel"), 5 })
	return menu
end

function proShot:hasAnyFlashlightFavourite()
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		if proShot.flashlightFavourites[slot] ~= nil then
			return true
		end
	end
	return false
end

function proShot:buildFlashLightMenu()
	local menu = {
		{ "PRO_SHOT_47", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_red"), 1 },
		{ "PRO_SHOT_58", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_green"), 1 },
		{ "PRO_SHOT_69", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_blue"), 1 },
		{ "PRO_SHOT_DIVMUL", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_light_temp"), 1 },
		{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_intensity"), 1 },
		{ "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_distance"), 1 },
		{ "PRO_SHOT_DOT3", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_coneAngle"), 1 },
		{ "PRO_SHOT_MINUSEQUALS", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_dropOff"), 1 }
	}
	-- Keep immediate light actions together above the favourite controls.
	table.insert(menu, { "PRO_SHOT_KP_0", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_resetDefaults"), 2 })
	-- Keep keypad Enter active, but hide its duplicate help row. Main Enter is
	-- the single visible prompt and both bindings still call the same action.
	table.insert(menu, { "PRO_SHOT_KP_ENTER", "callbackMenu_flashLight", { "flashLightEnter" }, 3, false })
	table.insert(menu, { "PRO_SHOT_ENTER", "callbackMenu_flashLight", { "flashLightEnter" }, 3 })
	table.insert(menu, { "PRO_SHOT_BACKSLASH", "callbackMenu_flashLight", g_i18n:getText("proShot_menu_flashLight_removeLast"), 3 })
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		if proShot.flashlightFavourites[slot] ~= nil then
			table.insert(menu, { "PRO_SHOT_" .. slot, "callbackMenu_flashLight", { "flashlightFavourite" .. slot }, 4 })
		end
	end
	table.insert(menu, { "PRO_SHOT_0", "callbackMenu_flashLight", g_i18n:getText("proShot_flashFavourite_save"), 5 })
	if proShot:hasAnyFlashlightFavourite() then
		table.insert(menu, { "PRO_SHOT_9", "callbackMenu_flashLight", g_i18n:getText("proShot_flashFavourite_remove"), 5 })
	end
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_main", g_i18n:getText("proShot_menu_returnToMain"), 6 })
	table.insert(menu, { "PRO_SHOT_F", "callbackMenu_main", g_i18n:getText("input_TOGGLE_LIGHTS_FPS"), 6 })
	table.insert(menu, { "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 6 })
	return menu
end

function proShot:buildFlashlightFavouriteSaveMenu()
	local menu = {}
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		table.insert(menu, { "PRO_SHOT_" .. slot, "callbackMenu_flashlightFavouriteSaveSlot", { "flashlightFavouriteSave" .. slot }, 3 })
	end
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_flashlightFavouriteSaveSlot", g_i18n:getText("proShot_flashFavourite_cancel"), 4 })
	return menu
end

function proShot:buildFlashlightFavouriteDeleteMenu()
	local menu = {}
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		if proShot.flashlightFavourites[slot] ~= nil then
			table.insert(menu, { "PRO_SHOT_" .. slot, "callbackMenu_flashlightFavouriteDeleteSlot", { "flashlightFavouriteDelete" .. slot }, 3 })
		end
	end
	table.insert(menu, { "PRO_SHOT_BACKSPACE", "callbackMenu_flashlightFavouriteDeleteSlot", g_i18n:getText("proShot_flashFavourite_cancel"), 4 })
	return menu
end

function proShot:refreshFlashlightFavouriteNames()
	if proShot.dynamicMenuNames == nil then
		return
	end
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		local favourite = proShot.flashlightFavourites[slot]
		local name = favourite ~= nil and favourite.name or g_i18n:getText("configuration_valueEmpty")
		proShot.dynamicMenuNames["flashlightFavourite" .. slot] = string.format(g_i18n:getText("proShot_flashFavourite_restoreSlot"), slot, name)
		proShot.dynamicMenuNames["flashlightFavouriteSave" .. slot] = string.format(g_i18n:getText("proShot_flashFavourite_saveSlot"), slot, name)
		proShot.dynamicMenuNames["flashlightFavouriteDelete" .. slot] = string.format(g_i18n:getText("proShot_flashFavourite_deleteSlot"), slot, name)
	end
	if proShot.menus ~= nil then
		proShot.menus.flashLight = proShot:buildFlashLightMenu()
		proShot.menus.flashlightFavouriteSaveSlot = proShot:buildFlashlightFavouriteSaveMenu()
		proShot.menus.flashlightFavouriteDeleteSlot = proShot:buildFlashlightFavouriteDeleteMenu()
		if proShot.menuDesired == "flashLight" or proShot.menuDesired == "flashlightFavouriteSaveSlot" or proShot.menuDesired == "flashlightFavouriteDeleteSlot" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:loadFlashlightFavourites()
	proShot.flashlightFavourites = {}
	local xmlFile = XMLFile.loadIfExists("ProShot flashlight favourites", proShot.flashlightFavouritesFilename)
	if xmlFile ~= nil then
		for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
			local key = string.format("proShotFlashlightFavourites.slot(%d)", slot - 1)
			if xmlFile:getBool(key .. "#occupied", false) then
				proShot.flashlightFavourites[slot] = {
					name = xmlFile:getString(key .. "#name", string.format(g_i18n:getText("proShot_flashFavourite_defaultName"), slot)),
					coneAngle = xmlFile:getFloat(key .. "#coneAngle", 60),
					dropOff = xmlFile:getFloat(key .. "#dropOff", 3),
					range = xmlFile:getFloat(key .. "#range", 20),
					intensity = xmlFile:getFloat(key .. "#intensity", 1),
					red = xmlFile:getFloat(key .. "#red", 1),
					green = xmlFile:getFloat(key .. "#green", 1),
					blue = xmlFile:getFloat(key .. "#blue", 1),
					colourTemp = xmlFile:getInt(key .. "#colourTemp", 6600),
					colourTempIsPreset = xmlFile:getBool(key .. "#colourTempIsPreset", true)
				}
			end
		end
		xmlFile:delete()
	end
	proShot:refreshFlashlightFavouriteNames()
end

function proShot:saveFlashlightFavourites()
	createFolder(proShot.settingsDirectory)
	local xmlFile = XMLFile.create("ProShot flashlight favourites", proShot.flashlightFavouritesFilename, "proShotFlashlightFavourites")
	if xmlFile == nil then
		return false
	end
	xmlFile:setInt("proShotFlashlightFavourites#version", 1)
	for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
		local key = string.format("proShotFlashlightFavourites.slot(%d)", slot - 1)
		local favourite = proShot.flashlightFavourites[slot]
		xmlFile:setBool(key .. "#occupied", favourite ~= nil)
		if favourite ~= nil then
			xmlFile:setString(key .. "#name", favourite.name)
			for _, field in ipairs({ "coneAngle", "dropOff", "range", "intensity", "red", "green", "blue" }) do
				xmlFile:setFloat(key .. "#" .. field, favourite[field])
			end
			xmlFile:setInt(key .. "#colourTemp", favourite.colourTemp)
			xmlFile:setBool(key .. "#colourTempIsPreset", favourite.colourTempIsPreset)
		end
	end
	local saved = xmlFile:save(false)
	xmlFile:delete()
	return saved
end

function proShot:refreshFavouriteMenuNames()
	if proShot.dynamicMenuNames == nil then
		return
	end

	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		local favourite = proShot.favourites[slot]
		local name = favourite ~= nil and favourite.name or g_i18n:getText("configuration_valueEmpty")
		proShot.dynamicMenuNames["favourite" .. slot] = string.format(g_i18n:getText("proShot_favourite_restoreSlot"), slot, name)
		proShot.dynamicMenuNames["favouriteSave" .. slot] = string.format(g_i18n:getText("proShot_favourite_saveSlot"), slot, name)
		proShot.dynamicMenuNames["favouriteDelete" .. slot] = string.format(g_i18n:getText("proShot_favourite_deleteSlot"), slot, name)
	end
	if proShot.menus ~= nil then
		proShot.menus.favourites = proShot:buildFavouritesMenu()
		proShot.menus.favouriteDeleteSlot = proShot:buildFavouriteDeleteMenu()
		if proShot.menuDesired == "favourites" or proShot.menuDesired == "favouriteDeleteSlot" then
			proShot.menuCurrent = "noneAtAll"
		end
	end
end

function proShot:createAllFavouriteGroups()
	local selected = {}
	for _, group in ipairs(proShot.FAVOURITE_GROUPS) do
		selected[group.key] = true
	end
	return selected
end

function proShot:refreshFavouriteGroupNames()
	if proShot.dynamicMenuNames == nil then
		return
	end
	for index, group in ipairs(proShot.FAVOURITE_GROUPS) do
		local checked = proShot.pendingFavouriteGroups ~= nil and proShot.pendingFavouriteGroups[group.key]
		proShot.dynamicMenuNames["favouriteGroup" .. index] = string.format("[%s] %s", checked and "x" or " ", g_i18n:getText(group.textKey))
	end
end

function proShot:loadFavourites()
	proShot.favourites = {}
	local xmlFile = XMLFile.loadIfExists("ProShot favourites", proShot.favouritesFilename)
	if xmlFile == nil then
		proShot:refreshFavouriteMenuNames()
		return
	end

	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		local key = string.format("proShotFavourites.slot(%d)", slot - 1)
		if xmlFile:getBool(key .. "#occupied", false) then
			local favourite = { name = xmlFile:getString(key .. "#name", string.format("Preset %d", slot)) }
			for _, field in ipairs(proShot.FAVOURITE_FIELDS) do
				local path = key .. "#" .. field[1]
				if field[2] == "float" then
					favourite[field[1]] = xmlFile:getFloat(path)
				elseif field[2] == "int" then
					favourite[field[1]] = xmlFile:getInt(path)
				elseif field[2] == "bool" then
					favourite[field[1]] = xmlFile:getBool(path)
				else
					favourite[field[1]] = xmlFile:getString(path)
				end
			end
			proShot.favourites[slot] = favourite
		end
	end

	xmlFile:delete()
	proShot:refreshFavouriteMenuNames()
end

function proShot:saveFavourites()
	createFolder(proShot.settingsDirectory)
	local xmlFile = XMLFile.create("ProShot favourites", proShot.favouritesFilename, "proShotFavourites")
	if xmlFile == nil then
		Logging.error("ProShot: Could not create favourites file '%s'", tostring(proShot.favouritesFilename))
		return false
	end

	xmlFile:setInt("proShotFavourites#version", 1)
	for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
		local key = string.format("proShotFavourites.slot(%d)", slot - 1)
		local favourite = proShot.favourites[slot]
		xmlFile:setInt(key .. "#index", slot)
		xmlFile:setBool(key .. "#occupied", favourite ~= nil)
		if favourite ~= nil then
			xmlFile:setString(key .. "#name", favourite.name)
			for _, field in ipairs(proShot.FAVOURITE_FIELDS) do
				local value = favourite[field[1]]
				local path = key .. "#" .. field[1]
				if value ~= nil then
					if field[2] == "float" then
						xmlFile:setFloat(path, value)
					elseif field[2] == "int" then
						xmlFile:setInt(path, value)
					elseif field[2] == "bool" then
						xmlFile:setBool(path, value)
					else
						xmlFile:setString(path, value)
					end
				end
			end
		end
	end

	local saved = xmlFile:save(false)
	xmlFile:delete()
	return saved
end

function proShot:captureFavourite(name, includedGroups)
	local env = g_currentMission ~= nil and g_currentMission.environment or nil
	if env == nil or g_currentMission.snowSystem == nil or proShot.sun == nil
		or proShot.sun.lightNode == nil or proShot.sun.lightNode == 0
		or proShot.heldLight == nil or proShot.DoFState == nil then
		Logging.error("ProShot: Cannot capture settings because the photo session is incomplete")
		return nil
	end
	local weatherItem = env.weather ~= nil and env.weather.forecastItems ~= nil
		and env.weather.forecastItems[1] or nil
	local sunRotX, sunRotY, sunRotZ = getRotation(proShot.sun.lightNode)
	local sunRed, sunGreen, sunBlue = getLightColor(proShot.sun.lightNode)
	local flashSettings = proShot.flashLightMenuSettings or proShot:captureHeldLightSettings()
	local nearCoC, nearBlurEnd, farCoC, farBlurStart, farBlurEnd, applyToSky = unpack(proShot.DoFState)
	local tone = proShot.toneMappingState or proShot:captureToneMapping()
	local fogUpdater = proShot:getFogUpdater()
	local fog = proShot.fogState or (fogUpdater ~= nil and fogUpdater.currentFog or nil)
	local sky = proShot.skyState or proShot:createSkyState()

	local snapshot = {
		name = name,
		viewDistance = getViewDistanceCoeff(),
		lodDistance = getLODDistanceCoeff(),
		terrainLodDistance = getTerrainLODDistanceCoeff(),
		foliageViewDistance = getFoliageViewDistanceCoeff(),
		fov = proShot.FoV,
		sunRotX = sunRotX,
		sunRotY = sunRotY,
		sunRotZ = sunRotZ,
		sunRed = sunRed,
		sunGreen = sunGreen,
		sunBlue = sunBlue,
		sunIntensity = proShot.sun.intensity,
		sunColourTemp = proShot.sun.colourTemp,
		sunColourTempIsPreset = proShot.sun.colourTempIsPreset,
		exposureKey = proShot.exposureKeyValue,
		exposureMin = proShot.exposureMinValue,
		exposureMax = proShot.exposureMaxValue,
		sunSizeScale = getSunSizeScale(),
		moonSizeScale = getMoonSizeScale(),
		atmosphere = getAtmosphereCornetteShankAsymmetryFactor(),
		colourGradingSelection = proShot.colourGradingSelection or 0,
		bloomMagnitude = getBloomMagnitude(),
		bloomThreshold = getBloomMaskThreshold(),
		bloomQuality = getBloomQuality(),
		ssaoQuality = getSSAOQuality(),
		dofNearCoC = nearCoC,
		dofNearBlurEnd = nearBlurEnd,
		dofFarCoC = farCoC,
		dofFarBlurStart = farBlurStart,
		dofFarBlurEnd = farBlurEnd,
		dofApplyToSky = applyToSky,
		dayTime = env.dayTime,
		visualPeriod = env.currentVisualPeriod,
		seasonTweak = proShot.seasonTweak,
		weatherName = proShot:getCurrentWeatherName(),
		weatherVariation = weatherItem ~= nil and weatherItem.variationIndex or 1,
		frost = g_currentMission.snowSystem:getSnowShaderValue(),
		snowLevel = proShot:snowBusiness("getHeight"),
		flashVisible = proShot:isHeldLightVisible(),
		flashConeAngle = flashSettings.coneAngle,
		flashDropOff = flashSettings.dropOff,
		flashRange = flashSettings.range,
		flashIntensity = flashSettings.intensity,
		flashRed = flashSettings.red,
		flashGreen = flashSettings.green,
		flashBlue = flashSettings.blue,
		flashColourTemp = flashSettings.colourTemp,
		flashColourTempIsPreset = flashSettings.colourTempIsPreset,
		toneSlope = tone.slope,
		toneToe = tone.toe,
		toneShoulder = tone.shoulder,
		toneBlackClip = tone.blackClip,
		toneWhiteClip = tone.whiteClip,
		groundWetness = math.clamp(proShot.testingGroundWetness or getWetness(), 0, 1),
		skyRed = sky.red,
		skyGreen = sky.green,
		skyBlue = sky.blue,
		skyIntensity = sky.intensity,
		skyColourTemp = sky.colourTemp,
		skyColourTempIsPreset = sky.colourTempIsPreset,
		effectEditorDirty = proShot.effectEditorDirty
	}
	if fog ~= nil then
		snapshot.fogDensity = proShot.fogDensityValue or fog.groundFogGroundLevelDensity
		snapshot.hazeDensity = fog.heightFogGroundLevelDensity
		snapshot.fogCoverageEdge0 = fog.groundFogCoverageEdge0
		snapshot.fogCoverageEdge1 = fog.groundFogCoverageEdge1
		snapshot.fogExtraHeight = fog.groundFogExtraHeight
		snapshot.fogMinValleyDepth = fog.groundFogMinValleyDepth
	end
	local effectState = proShot.effectEditorState
	if effectState ~= nil then
		snapshot.effectShadowsMaxLuminance = effectState.shadowsMaxLuminance
		snapshot.effectHighlightsMinLuminance = effectState.highlightsMinLuminance
		for _, group in ipairs(proShot.EFFECT_GROUPS) do
			for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
				for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
					snapshot[string.format("effect_%s_%s_%s", group, property, component)] = effectState[group][property][component]
				end
			end
		end
	end
	if includedGroups ~= nil then
		for _, field in ipairs(proShot.FAVOURITE_FIELDS) do
			local group = proShot.FAVOURITE_FIELD_GROUP[field[1]]
			if group ~= nil and not includedGroups[group] then
				snapshot[field[1]] = nil
			end
		end
	end
	return snapshot
end

function proShot:snapshotIncludesGroup(settings, group)
	if type(settings) ~= "table" then
		return false
	end
	for _, field in ipairs(proShot.FAVOURITE_FIELDS) do
		if proShot.FAVOURITE_FIELD_GROUP[field[1]] == group and settings[field[1]] ~= nil then
			return true
		end
	end
	return false
end

function proShot:applySettingsSnapshot(settings, excludeTransientGroups)
	if type(settings) ~= "table" or g_currentMission == nil
		or g_currentMission.environment == nil or g_currentMission.snowSystem == nil
		or proShot.sun == nil or proShot.tripod == nil or proShot.tripod == 0 then
		return false
	end
	local function value(name, default)
		return settings[name] ~= nil and settings[name] or default
	end

	local env = g_currentMission.environment
	local snowSystem = g_currentMission.snowSystem
	local hasQuality = proShot:snapshotIncludesGroup(settings, "quality")
	local hasCamera = proShot:snapshotIncludesGroup(settings, "camera")
	local hasSeason = proShot:snapshotIncludesGroup(settings, "season")
	local hasWeather = proShot:snapshotIncludesGroup(settings, "weather")
	local hasTime = proShot:snapshotIncludesGroup(settings, "time")
	local hasEnvironment = hasSeason or hasWeather or hasTime
	local hasSky = proShot:snapshotIncludesGroup(settings, "sky")
	local hasGroundLight = proShot:snapshotIncludesGroup(settings, "groundLight")
	local hasEffects = proShot:snapshotIncludesGroup(settings, "effects")
	local hasDoF = not excludeTransientGroups and proShot:snapshotIncludesGroup(settings, "dof")
	local hasFlashlight = not excludeTransientGroups and proShot:snapshotIncludesGroup(settings, "flashlight")

	if hasQuality then
		setViewDistanceCoeff(value("viewDistance", getViewDistanceCoeff()))
		setLODDistanceCoeff(value("lodDistance", getLODDistanceCoeff()))
		setTerrainLODDistanceCoeff(value("terrainLodDistance", getTerrainLODDistanceCoeff()))
		setFoliageViewDistanceCoeff(value("foliageViewDistance", getFoliageViewDistanceCoeff()))
	end

	-- Apply environment first because its update changes sunlight and lighting
	-- state. Preserve any unchecked Ground light group across that native update.
	local preservedGround
	if (hasEnvironment or hasEffects) and not hasGroundLight then
		local x, y, z = getRotation(proShot.sun.lightNode)
		local r, g, b = getLightColor(proShot.sun.lightNode)
		preservedGround = { x = x, y = y, z = z, red = r, green = g, blue = b, intensity = proShot.sun.intensity, colourTemp = proShot.sun.colourTemp, colourTempIsPreset = proShot.sun.colourTempIsPreset }
	end
	local preservedWeather
	if hasSeason and not hasWeather then
		local weatherItem = env.weather.forecastItems ~= nil and env.weather.forecastItems[1] or nil
		local currentFog = proShot.fogState
		preservedWeather = {
			name = proShot:getCurrentWeatherName(),
			variation = weatherItem ~= nil and weatherItem.variationIndex or 1,
			fog = currentFog ~= nil and currentFog:clone() or nil,
			fogDensity = proShot.fogDensityValue,
			fogCoverageEdge0 = proShot.fogOverrideCoverageEdge0,
			fogCoverageEdge1 = proShot.fogOverrideCoverageEdge1,
			fogOverrideActive = proShot.fogOverrideActive,
			groundWetness = getWetness()
		}
	end
	if hasSeason then
		local visualPeriod = math.clamp(value("visualPeriod", env.currentVisualPeriod), 1, 12)
		proShot.seasonTweak = math.clamp(value("seasonTweak", proShot.seasonTweak), -1, 1)
		env:setFixedPeriod(visualPeriod)
		local periodToShader = { 3.11, 3.33, 3.67, 3.95, 0.6, 0.85, 1.08, 1.42, 1.75, 2, 2.25, 2.65 }
		local shaderParam = periodToShader[visualPeriod] + proShot.seasonTweak
		if shaderParam > 4 then
			shaderParam = shaderParam - 4
		elseif shaderParam < 0 then
			shaderParam = shaderParam + 4
		end
		env:consoleCommandSetSeasonalShader(shaderParam)
		proShot:setSnowShader(value("frost", snowSystem:getSnowShaderValue()))
		proShot:snowBusiness(value("snowLevel", proShot:snowBusiness("getHeight")))
		proShot:seasonChange("init")
	end
	if preservedWeather ~= nil then
		proShot:weatherChange(preservedWeather.name, false, preservedWeather.variation)
		proShot:weatherChange(proShot:getCurrentWeatherName(), true)
		if preservedWeather.fog ~= nil then
			proShot.fogDensityValue = preservedWeather.fogDensity
			proShot.fogOverrideCoverageEdge0 = preservedWeather.fogCoverageEdge0
			proShot.fogOverrideCoverageEdge1 = preservedWeather.fogCoverageEdge1
			proShot.fogOverrideActive = preservedWeather.fogOverrideActive
			proShot:applyFogState(preservedWeather.fog)
		end
		proShot:applyGroundWetness(preservedWeather.groundWetness)
	end
	if hasWeather then
		proShot:weatherChange(value("weatherName", proShot:getCurrentWeatherName()), false, value("weatherVariation", 1))
		proShot:weatherChange(proShot:getCurrentWeatherName(), true)
		local fogUpdater = proShot:getFogUpdater()
		local fogSource = proShot.fogState or (fogUpdater ~= nil and fogUpdater.currentFog or nil)
		if fogSource ~= nil then
			local fogState = fogSource:clone()
			local fogDensity = math.clamp(value("fogDensity", proShot.fogDensityValue or fogState.groundFogGroundLevelDensity), 0, 1)
			fogState.groundFogCoverageEdge0 = math.clamp(value("fogCoverageEdge0", fogState.groundFogCoverageEdge0), 0, 1)
			fogState.groundFogCoverageEdge1 = math.clamp(value("fogCoverageEdge1", fogState.groundFogCoverageEdge1), 0, 1)
			fogState.groundFogExtraHeight = math.clamp(value("fogExtraHeight", fogState.groundFogExtraHeight), 0, 50)
			fogState.groundFogMinValleyDepth = math.clamp(value("fogMinValleyDepth", fogState.groundFogMinValleyDepth), 0.5, 20)
			fogState.groundFogGroundLevelDensity = fogDensity
			fogState.heightFogGroundLevelDensity = math.clamp(value("hazeDensity", fogState.heightFogGroundLevelDensity), 0, 1)
			proShot.fogDensityValue = fogDensity
			proShot.fogOverrideCoverageEdge0 = fogState.groundFogCoverageEdge0
			proShot.fogOverrideCoverageEdge1 = fogState.groundFogCoverageEdge1
			proShot.fogOverrideActive = true
			proShot:applyFogState(fogState)
		end
		if settings.groundWetness ~= nil then
			proShot:applyGroundWetness(settings.groundWetness)
		end
	end
	if hasTime then
		proShot:timeChange(value("dayTime", env.dayTime))
	end
	if hasEnvironment then
		proShot:debugLogLiveState("snapshot after environment")
	end

	if hasEffects then
		local toneMapping = {
			slope = math.clamp(value("toneSlope", getToneMappingCurveSlope()), 0, 1),
			toe = math.clamp(value("toneToe", getToneMappingCurveToe()), 0, 1),
			shoulder = math.clamp(value("toneShoulder", getToneMappingCurveShoulder()), 0, 1),
			blackClip = math.clamp(value("toneBlackClip", getToneMappingCurveBlackClip()), 0, 1),
			whiteClip = math.clamp(value("toneWhiteClip", getToneMappingCurveWhiteClip()), 0, 1)
		}

		local gradingSelection = math.clamp(value("colourGradingSelection", 0), 0, proShot.EFFECT_SLOT_COUNT)
		local gradingSelectionAvailable = gradingSelection > 0 and (gradingSelection <= proShot.EFFECT_BUILTIN_SLOT_COUNT or proShot.effectSlots[gradingSelection] ~= nil)
		if gradingSelectionAvailable then
			proShot:colorGradingSet(gradingSelection)
		else
			proShot:colorGradingSet()
		end
		local storedEffectDirty = value("effectEditorDirty", false)
		-- An unselected, clean state represents the map's native time-varying
		-- grade, so do not turn it into a frozen preview file.
		if settings.effectShadowsMaxLuminance ~= nil and (gradingSelection > 0 or storedEffectDirty) then
			local effectState = proShot:createDefaultEffectState()
			effectState.shadowsMaxLuminance = value("effectShadowsMaxLuminance", effectState.shadowsMaxLuminance)
			effectState.highlightsMinLuminance = value("effectHighlightsMinLuminance", effectState.highlightsMinLuminance)
			for _, group in ipairs(proShot.EFFECT_GROUPS) do
				for _, property in ipairs(proShot.EFFECT_PROPERTIES) do
					for _, component in ipairs(proShot.EFFECT_COMPONENTS) do
						local key = string.format("effect_%s_%s_%s", group, property, component)
						effectState[group][property][component] = value(key, effectState[group][property][component])
					end
				end
			end
			proShot.effectEditorState = effectState
			proShot:applyEffectEditorState(false)
			-- A favourite can outlive a custom effect slot. Its embedded grading state
			-- still restores exactly, but is presented as an unsaved custom grade.
			local wasDirty = storedEffectDirty
			proShot.effectEditorDirty = wasDirty or (gradingSelection > 0 and not gradingSelectionAvailable)
			proShot.colourGradingSelection = proShot.effectEditorDirty and nil or (gradingSelectionAvailable and gradingSelection or nil)
		end
		-- Installing a colour-grading Lighting object reapplies the map's tone
		-- curve, so restore the favourite's curve afterwards.
		proShot:applyToneMapping(toneMapping)
		setBloomMagnitude(value("bloomMagnitude", getBloomMagnitude()))
		setBloomMaskThreshold(value("bloomThreshold", getBloomMaskThreshold()))
		setBloomQuality(math.clamp(math.floor(value("bloomQuality", getBloomQuality()) + 0.5), 0, 5))
		setSSAOQuality(math.clamp(value("ssaoQuality", getSSAOQuality()), 1, 4))
		proShot:debugLogLiveState("snapshot after effects")
	end

	if hasCamera then
		proShot.exposureKeyValue = value("exposureKey", proShot.exposureKeyValue)
		local exposureMin = value("exposureMin", proShot.exposureMinValue)
		-- FS25 auto exposure has separate minimum and maximum EV limits. Collapsing
		-- an untouched favourite to its minimum is visibly much darker, so retain
		-- the complete native range. A manually fixed exposure naturally stores the
		-- same value for both limits.
		local _, _, currentMaxExposure = proShot:getCurrentExposureRange()
		local exposureMax = value("exposureMax", currentMaxExposure or proShot.exposureMaxValue or exposureMin)
		-- Reject an inverted range as invalid regardless of how it reached the
		-- snapshot. This also makes already-saved affected favourites safe to load.
		if exposureMin > exposureMax then
			exposureMin, exposureMax = exposureMax, exposureMin
		end
		proShot.exposureMinValue = exposureMin
		proShot.exposureMaxValue = exposureMax
		setExposureRange(proShot.exposureKeyValue, proShot.exposureMinValue, proShot.exposureMaxValue)
		proShot.FoV = math.clamp(value("fov", proShot.FoV), 1, 170)
		setFovY(getChildAt(proShot.tripod, 0), math.rad(proShot.FoV))
		proShot:debugLogLiveState("snapshot after camera")
	end

	if hasGroundLight then
		local currentSunRotX, currentSunRotY, currentSunRotZ = getRotation(proShot.sun.lightNode)
		setRotation(proShot.sun.lightNode, value("sunRotX", currentSunRotX), value("sunRotY", currentSunRotY), value("sunRotZ", currentSunRotZ))
		proShot.sun.intensity = math.clamp(value("sunIntensity", proShot.sun.intensity), 0.0001, proShot.MAX_SKY_GROUND_INTENSITY)
		proShot.sun.colourTemp = value("sunColourTemp", proShot.sun.colourTemp)
		proShot.sun.colourTempIsPreset = value("sunColourTempIsPreset", proShot.sun.colourTempIsPreset)
		local currentSunRed, currentSunGreen, currentSunBlue = getLightColor(proShot.sun.lightNode)
		local sunRed = math.clamp(value("sunRed", currentSunRed) / proShot.sun.intensity, 0, proShot.MAX_SKY_GROUND_RGB) * proShot.sun.intensity
		local sunGreen = math.clamp(value("sunGreen", currentSunGreen) / proShot.sun.intensity, 0, proShot.MAX_SKY_GROUND_RGB) * proShot.sun.intensity
		local sunBlue = math.clamp(value("sunBlue", currentSunBlue) / proShot.sun.intensity, 0, proShot.MAX_SKY_GROUND_RGB) * proShot.sun.intensity
		setLightColor(proShot.sun.lightNode, sunRed, sunGreen, sunBlue)
	elseif preservedGround ~= nil then
		setRotation(proShot.sun.lightNode, preservedGround.x, preservedGround.y, preservedGround.z)
		setLightColor(proShot.sun.lightNode, preservedGround.red, preservedGround.green, preservedGround.blue)
		proShot.sun.intensity = preservedGround.intensity
		proShot.sun.colourTemp = preservedGround.colourTemp
		proShot.sun.colourTempIsPreset = preservedGround.colourTempIsPreset
	end

	if hasSky then
		setSunSizeScale(proShot:clampSunSizeScale(value("sunSizeScale", getSunSizeScale())))
		setMoonSizeScale(proShot:clampMoonSizeScale(value("moonSizeScale", getMoonSizeScale())))
		setAtmosphereCornetteShankAsymmetryFactor(math.clamp(value("atmosphere", getAtmosphereCornetteShankAsymmetryFactor()), 0, 0.8))
		local sky = proShot.skyState or proShot:createSkyState()
		sky.red = math.clamp(value("skyRed", sky.red), 0, proShot.MAX_SKY_GROUND_RGB)
		sky.green = math.clamp(value("skyGreen", sky.green), 0, proShot.MAX_SKY_GROUND_RGB)
		sky.blue = math.clamp(value("skyBlue", sky.blue), 0, proShot.MAX_SKY_GROUND_RGB)
		sky.intensity = math.clamp(value("skyIntensity", sky.intensity), 0, proShot.MAX_SKY_GROUND_INTENSITY)
		sky.colourTemp = value("skyColourTemp", sky.colourTemp)
		sky.colourTempIsPreset = value("skyColourTempIsPreset", sky.colourTempIsPreset)
		proShot.skyState = sky
	end
	-- Environment updates rewrite scattering, so reapply even when the favourite
	-- deliberately omitted the Sky group.
	proShot:applySkyState()
	if hasGroundLight or hasSky then
		proShot:debugLogLiveState("snapshot after lighting")
	end

	if hasDoF then
		proShot:setDoFState({ value("dofNearCoC", proShot.DoFState[1]), value("dofNearBlurEnd", proShot.DoFState[2]), value("dofFarCoC", proShot.DoFState[3]), value("dofFarBlurStart", proShot.DoFState[4]), value("dofFarBlurEnd", proShot.DoFState[5]), value("dofApplyToSky", proShot.DoFState[6]) })
		proShot.focusAssist = nil
		proShot:refreshFocusMenus()
	end

	if hasFlashlight then
		local currentFlashSettings = proShot.flashLightMenuSettings or proShot:captureHeldLightSettings()
		local restoredFlashSettings = {
			coneAngle = value("flashConeAngle", currentFlashSettings.coneAngle), dropOff = value("flashDropOff", currentFlashSettings.dropOff),
			intensity = value("flashIntensity", currentFlashSettings.intensity), range = value("flashRange", currentFlashSettings.range),
			colourTemp = value("flashColourTemp", currentFlashSettings.colourTemp), colourTempIsPreset = value("flashColourTempIsPreset", currentFlashSettings.colourTempIsPreset),
			red = value("flashRed", currentFlashSettings.red), green = value("flashGreen", currentFlashSettings.green), blue = value("flashBlue", currentFlashSettings.blue)
		}
		local flashVisible = value("flashVisible", proShot:isHeldLightVisible())
		proShot.flashLightMenuSettings = restoredFlashSettings
		if proShot.menuDesired == "flashLight" then
			proShot:applyHeldLightSettings(restoredFlashSettings, flashVisible)
		else
			proShot:applyHeldLightSettings(proShot:getDefaultFlashLightSettings(), flashVisible)
		end
	end

	proShot:refreshMainMenu()
	proShot.menuCurrent = "noneAtAll"
	return true
end

function proShot:applyFavourite(slot)
	local favourite = proShot.favourites[slot]
	if favourite == nil then
		proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_emptyStatus"), slot)
		return
	end

	-- Main favourites deliberately exclude DoF and flashlight state.
	proShot:debugLogSettings(string.format("restore slot %d saved", slot), favourite)
	proShot:debugLogLiveState(string.format("restore slot %d before", slot))
	if proShot:applySettingsSnapshot(favourite, true) then
		proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_restoredStatus"), slot)
		proShot.menuCurrent = "noneAtAll"
		proShot:debugLogLiveState(string.format("restore slot %d complete", slot))
	else
		Logging.error("ProShot: Could not restore favourite slot %d", slot)
	end
end

function proShot:getFavouriteSlotFromAction(action)
	local number = string.match(tostring(action), "PRO_SHOT_(%d)$")
	if number == nil then
		return nil
	end
	local slot = tonumber(number)
	return slot == 0 and 10 or slot
end

function proShot:showFavouriteNameDialog(slot)
	if TextInputDialog == nil or TextInputDialog.INSTANCE == nil then
		proShot.favouriteStatus = g_i18n:getText("proShot_favourite_saveFailed")
		return
	end
	local existing = proShot.favourites[slot]
	local defaultName = existing ~= nil and existing.name or string.format(g_i18n:getText("proShot_favourite_defaultName"), slot)
	proShot.favouriteDialogOpen = true
	-- The pause-context action is rebuilt after the dialog closes. Require the
	-- confirming Return key to be released before it can take a screenshot.
	proShot.captureKeyReleaseRequired = true
	TextInputDialog.show(
		proShot.onFavouriteNameEntered,
		proShot,
		defaultName,
		string.format(g_i18n:getText("proShot_favourite_namePrompt"), slot),
		string.format(g_i18n:getText("proShot_favourite_namePrompt"), slot),
		32,
		g_i18n:getText("button_save"),
		slot)
end

function proShot:onFavouriteNameEntered(text, clickOk, slot)
	proShot.favouriteDialogOpen = false
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	if not clickOk then
		proShot.menuDesired = "favouriteSaveGroups"
		return
	end

	local name = string.gsub(text or "", "^%s*(.-)%s*$", "%1")
	if name == "" then
		name = string.format(g_i18n:getText("proShot_favourite_defaultName"), slot)
	end
	local previousFavourite = proShot.favourites[slot]
	local favourite = proShot:captureFavourite(name, proShot.pendingFavouriteGroups)
	if favourite == nil then
		proShot.favouriteStatus = g_i18n:getText("proShot_favourite_saveFailed")
		proShot.menuDesired = "favouriteSaveGroups"
		return
	end
	proShot:debugLogSettings(string.format("save slot %d", slot), favourite)
	proShot.favourites[slot] = favourite
	if proShot:saveFavourites() then
		proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_savedStatus"), slot, name)
		proShot.menuDesired = "favourites"
		proShot.pendingFavouriteSlot = nil
		proShot.pendingFavouriteGroups = nil
	else
		proShot.favourites[slot] = previousFavourite
		proShot.favouriteStatus = g_i18n:getText("proShot_favourite_saveFailed")
		proShot.menuDesired = "favouriteSaveGroups"
	end
	proShot:refreshFavouriteMenuNames()
end

function proShot:showFavouriteDeleteDialog(slot)
	local favourite = proShot.favourites[slot]
	if favourite == nil then
		proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_emptyStatus"), slot)
		return
	end
	if YesNoDialog == nil or YesNoDialog.INSTANCE == nil then
		proShot.favouriteStatus = g_i18n:getText("proShot_favourite_saveFailed")
		return
	end

	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	YesNoDialog.show(
		proShot.onFavouriteDeleteConfirmed,
		proShot,
		string.format(g_i18n:getText("proShot_favourite_deletePrompt"), slot, favourite.name),
		g_i18n:getText("proShot_favourite_deleteTitle"),
		g_i18n:getText("button_delete"),
		g_i18n:getText("button_cancel"),
		nil, nil, nil, slot)
end

function proShot:onFavouriteDeleteConfirmed(confirmed, slot)
	proShot.favouriteDialogOpen = false
	proShot.keyLockout = {}
	proShot.menuDesired = "favourites"
	proShot.menuCurrent = "noneAtAll"
	if not confirmed then
		return
	end

	local favourite = proShot.favourites[slot]
	local name = favourite ~= nil and favourite.name or ""
	proShot.favourites[slot] = nil
	if proShot:saveFavourites() then
		proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_deletedStatus"), slot, name)
	else
		proShot.favourites[slot] = favourite
		proShot.favouriteStatus = g_i18n:getText("proShot_favourite_saveFailed")
	end
	proShot:refreshFavouriteMenuNames()
end

function proShot:getFlashlightFavouriteSlotFromAction(action)
	local number = string.match(tostring(action), "PRO_SHOT_([1-8])$")
	return number ~= nil and tonumber(number) or nil
end

function proShot:applyFlashlightFavourite(slot)
	local favourite = proShot.flashlightFavourites[slot]
	if favourite == nil then
		return
	end
	proShot:applyHeldLightSettings(favourite, true)
	proShot.flashLightMenuSettings = proShot:captureHeldLightSettings()
	proShot:updateFlashLightEnterText()
	proShot.flashlightFavouriteStatus = string.format(g_i18n:getText("proShot_flashFavourite_restored"), slot, favourite.name)
	proShot:showToast(proShot.flashlightFavouriteStatus)
end

function proShot:showFlashlightFavouriteNameDialog(slot)
	if TextInputDialog == nil or TextInputDialog.INSTANCE == nil then
		proShot:showToast(g_i18n:getText("proShot_favourite_saveFailed"))
		return
	end
	local existing = proShot.flashlightFavourites[slot]
	local defaultName = existing ~= nil and existing.name or string.format(g_i18n:getText("proShot_flashFavourite_defaultName"), slot)
	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	TextInputDialog.show(
		proShot.onFlashlightFavouriteNameEntered,
		proShot,
		defaultName,
		string.format(g_i18n:getText("proShot_flashFavourite_namePrompt"), slot),
		string.format(g_i18n:getText("proShot_flashFavourite_namePrompt"), slot),
		32,
		g_i18n:getText("button_save"),
		slot)
end

function proShot:onFlashlightFavouriteNameEntered(text, clickOk, slot)
	proShot.favouriteDialogOpen = false
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	if not clickOk then
		proShot.menuDesired = "flashlightFavouriteSaveSlot"
		return
	end
	local name = string.gsub(text or "", "^%s*(.-)%s*$", "%1")
	if name == "" then
		name = string.format(g_i18n:getText("proShot_flashFavourite_defaultName"), slot)
	end
	local previous = proShot.flashlightFavourites[slot]
	local favourite = table.clone(proShot.flashLightMenuSettings or proShot:captureHeldLightSettings())
	favourite.name = name
	proShot.flashlightFavourites[slot] = favourite
	if proShot:saveFlashlightFavourites() then
		proShot.flashlightFavouriteStatus = string.format(g_i18n:getText("proShot_flashFavourite_saved"), slot, name)
		proShot:showToast(proShot.flashlightFavouriteStatus)
		proShot.menuDesired = "flashLight"
	else
		proShot.flashlightFavourites[slot] = previous
		proShot:showToast(g_i18n:getText("proShot_favourite_saveFailed"))
		proShot.menuDesired = "flashlightFavouriteSaveSlot"
	end
	proShot:refreshFlashlightFavouriteNames()
end

function proShot:showFlashlightFavouriteDeleteDialog(slot)
	local favourite = proShot.flashlightFavourites[slot]
	if favourite == nil or YesNoDialog == nil or YesNoDialog.INSTANCE == nil then
		return
	end
	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	YesNoDialog.show(
		proShot.onFlashlightFavouriteDeleteConfirmed,
		proShot,
		string.format(g_i18n:getText("proShot_flashFavourite_deletePrompt"), slot, favourite.name),
		g_i18n:getText("proShot_flashFavourite_deleteTitle"),
		g_i18n:getText("button_delete"),
		g_i18n:getText("button_cancel"),
		nil, nil, nil, slot)
end

function proShot:onFlashlightFavouriteDeleteConfirmed(confirmed, slot)
	proShot.favouriteDialogOpen = false
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	proShot.menuDesired = "flashLight"
	if not confirmed then
		return
	end
	local previous = proShot.flashlightFavourites[slot]
	proShot.flashlightFavourites[slot] = nil
	if proShot:saveFlashlightFavourites() then
		proShot.flashlightFavouriteStatus = string.format(g_i18n:getText("proShot_flashFavourite_deleted"), slot, previous.name)
		proShot:showToast(proShot.flashlightFavouriteStatus)
	else
		proShot.flashlightFavourites[slot] = previous
		proShot:showToast(g_i18n:getText("proShot_favourite_saveFailed"))
	end
	proShot:refreshFlashlightFavouriteNames()
end

function proShot:showEffectNameDialog(slot)
	if TextInputDialog == nil or TextInputDialog.INSTANCE == nil then
		proShot:showToast(g_i18n:getText("proShot_effect_saveFailed"))
		return
	end
	local existing = proShot.effectSlots[slot]
	local defaultName = existing ~= nil and existing.name or proShot:getBuiltinEffectName(slot) or string.format(g_i18n:getText("proShot_effect_defaultName"), slot)
	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	TextInputDialog.show(
		proShot.onEffectNameEntered,
		proShot,
		defaultName,
		string.format(g_i18n:getText("proShot_effect_namePrompt"), slot),
		string.format(g_i18n:getText("proShot_effect_namePrompt"), slot),
		32,
		g_i18n:getText("button_save"),
		slot)
end

function proShot:onEffectNameEntered(text, clickOk, slot)
	proShot.favouriteDialogOpen = false
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	if not clickOk then
		proShot.menuDesired = "effectSaveSlot"
		return
	end

	local name = string.gsub(text or "", "^%s*(.-)%s*$", "%1")
	if name == "" then
		name = string.format(g_i18n:getText("proShot_effect_defaultName"), slot)
	end
	local previousSlot = proShot.effectSlots[slot]
	proShot.effectSlots[slot] = {
		name = name,
		state = proShot:cloneEffectState(proShot.effectEditorState),
		bloomMagnitude = getBloomMagnitude(),
		bloomThreshold = getBloomMaskThreshold(),
		bloomQuality = getBloomQuality(),
		ssaoQuality = getSSAOQuality()
	}
	if proShot:saveEffectSlots() then
		proShot.colourGradingSelection = slot
		proShot.effectEditorDirty = false
		proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
		proShot.effectEditorBaselineSelection = slot
		proShot:showToast(string.format(g_i18n:getText("proShot_effect_saved"), slot, name))
	else
		-- Keep the live slot table in sync with disk if persistence fails.
		proShot.effectSlots[slot] = previousSlot
		proShot:showToast(g_i18n:getText("proShot_effect_saveFailed"))
	end
	proShot:refreshEffectMenuNames()
	proShot.menuDesired = "effectsCustomise"
end

function proShot:resetEffectSlot(slot)
	local old = proShot.effectSlots[slot]
	if old == nil then
		return
	end
	proShot.effectSlots[slot] = nil
	if not proShot:saveEffectSlots() then
		proShot.effectSlots[slot] = old
		proShot:showToast(g_i18n:getText("proShot_effect_saveFailed"))
		return
	end

	if proShot.colourGradingSelection == slot and not proShot.effectEditorDirty then
		if slot <= proShot.EFFECT_BUILTIN_SLOT_COUNT then
			proShot:colorGradingSet(slot)
		else
			proShot:colorGradingSet()
		end
	end
	proShot:refreshEffectMenuNames()
	proShot:showToast(string.format(g_i18n:getText("proShot_effect_resetDone"), slot))
	proShot.menuDesired = "effectsCustomise"
	proShot.menuCurrent = "noneAtAll"
end

function initMod()
	proShot.isActive = false
	proShot.isSet = false
	proShot.debugEnabled = false
	proShot.debugConsoleRegistered = false
	proShot.invertRotY = false
	proShot.reEnableHUD = false
	proShot.previousCamera = 0
	proShot.captureCoolDown = 0
	proShot.captureMode = "png"
	proShot.captureTimestamp = nil
	proShot.lastCaptureTimestamp = nil
	proShot.captureQueue = {}
	proShot.captureActionHeld = {}
	proShot.F1throttle = 0
	proShot.vehicleReloadKeyWasDown = false
	proShot.vehicleReloadCooldownUntil = 0
	proShot.vehicleReloadPending = false
	proShot.vehicleReloadReturnUniqueId = nil
	proShot.vehicleReloadControlRefreshPending = false
	proShot.vehicleReloadControlRefreshStartedAt = nil
	proShot.vehicleReloadReentryRequested = false
	proShot.vehicleReloadCleanupFailureLogged = false
	proShot.placeableReloadThrottle = 0
	proShot.modDir = g_currentModDirectory
	proShot.settingsDirectory = g_currentModSettingsDirectory or ((g_modSettingsDirectory or (getUserProfileAppPath() .. "modSettings/")) .. tostring(g_currentModName or "ProShot") .. "/")
	proShot.favouritesFilename = proShot.settingsDirectory .. "favourites.xml"
	proShot.flashlightFavouritesFilename = proShot.settingsDirectory .. "flashlightFavourites.xml"
	proShot.effectsFilename = proShot.settingsDirectory .. "effects.xml"
	proShot.favouriteStatus = ""
	proShot.flashlightFavouriteStatus = ""
	proShot.favouriteDialogOpen = false
	proShot.captureKeyReleaseRequired = false
	proShot.sessionInitialSettings = nil
	proShot.favouritesEntrySettings = nil
	proShot.pendingFavouriteSlot = nil
	proShot.pendingFavouriteGroups = nil
	proShot.snowLevel = nil
	proShot.pendingSnowAreaHeight = nil
	proShot.snowAreaRestore = nil
	proShot.localSnowEdited = false
	proShot.flashLightMenuSettings = nil
	proShot.flashlightFavourites = {}
	proShot.toastText = nil
	proShot.toastEndTime = 0
	proShot.effectSlots = {}
	proShot.effectBuiltinStates = {}
	proShot.effectEditorState = nil
	proShot.effectEditorBaselineState = nil
	proShot.effectEditorBaselineSelection = nil
	proShot.effectEditorGroup = nil
	proShot.effectEditorProperty = nil
	proShot.effectPropertyEntryState = nil
	proShot.effectPropertyEntryDirty = nil
	proShot.effectPropertyEntrySelection = nil
	proShot.effectPreviewIndex = 0
	proShot.effectEditorDirty = false
	proShot.inputHelpIsWide = false
	proShot.colourGradingSelection = nil
	proShot.toneMappingState = nil
	proShot.fogState = nil
	proShot.fogDensityValue = nil
	proShot.fogOverrideCoverageEdge0 = nil
	proShot.fogOverrideCoverageEdge1 = nil
	proShot.fogOverrideActive = false
	proShot.testingGroundWetness = nil
	proShot.testingTrafficEnabled = false
	proShot.testingPedestriansEnabled = false
	proShot.trafficPaused = false
	proShot.pedestriansPaused = false
	proShot.parkedCarsEnabled = true
	proShot.birdsPaused = false
	proShot.wildlifePaused = false
	proShot.selectedBirdIndex = 1
	proShot.selectedWildlifeIndex = 1
	proShot.crowPlacementOffset = 0
	proShot.birdPlacementOffset = 0
	proShot.farmAnimalPlacementOffset = 0
	proShot.crowPlacementOffsetX = 0
	proShot.crowPlacementOffsetY = 0
	proShot.birdPlacementOffsetX = 0
	proShot.birdPlacementOffsetY = 0
	proShot.farmAnimalPlacementOffsetX = 0
	proShot.farmAnimalPlacementOffsetY = 0
	proShot.crowWorldOffsetX = 0
	proShot.crowWorldOffsetZ = 0
	proShot.birdWorldOffsetX = 0
	proShot.birdWorldOffsetZ = 0
	proShot.farmAnimalWorldOffsetX = 0
	proShot.farmAnimalWorldOffsetZ = 0
	proShot.wildlifeOffsetMode = "bird"
	proShot.wildlifeRotationDegrees = 0
	proShot.birdRotationDegrees = 0
	proShot.farmAnimalRotationDegrees = 0
	proShot.wildlifeRotationMode = "bird"
	proShot.animalAdjustmentMode = "bird"
	proShot.spawnedWildlife = {}
	proShot.spawnedFarmAnimals = {}
	proShot.farmAnimalChoices = nil
	proShot.selectedFarmAnimalChoiceIndex = 1
	proShot.selectedFarmAnimalVariantIndex = 1
	proShot.farmAnimalDialogOpen = false
	proShot.farmAnimalPreviewOverlay = nil
	proShot.farmAnimalDialogOptionElement = nil
	proShot.farmAnimalDialogOriginalOptionCallback = nil
	proShot.sessionGroundCrowSpecies = nil
	proShot.localSnowRadius = 10
	proShot.localSnowStrengthLevel = proShot.LOCAL_SNOW_DEFAULT_STRENGTH_LEVEL
	proShot.localSnowTarget = nil
	proShot.localSnowCursor = nil
	proShot.skyState = nil
	proShot.focusAssist = nil
	proShot.focusHoldStartTime = nil
	proShot.focusHoldTriggered = false
	proShot.gridAidIndex = 1
	proShot.aspectAidIndex = 1
	proShot.resetFlashlightsArmed = false
	proShot.resetFlashlightsReleaseRequired = false
	proShot.pauseSetupFailureLogged = false

	proShot.mouseButtonDown = {}
	proShot.fromWhenceYouCame = {}
	proShot.buttonId = {}
	proShot.keyLockout = {}
	proShot.menuRebuilding = false

	proShot.lightI3D = g_currentModDirectory .. "lights.i3d"
	proShot.cameraSound = createSample("cameraSound")
	if proShot.cameraSound ~= nil and proShot.cameraSound ~= 0 then
		loadSample(proShot.cameraSound, g_currentModDirectory .. "cameraSound.ogg", false)
	else
		Logging.warning("ProShot: Camera shutter sound could not be created")
	end

	-- Override some base-game functions
	GamePausedDisplay.draw = Utils.overwrittenFunction(GamePausedDisplay.draw, proShot.insteadof_GamePausedDisplay_draw)
	if WildlifeSpecies ~= nil and WildlifeSpecies.update ~= nil then
		WildlifeSpecies.update = Utils.overwrittenFunction(WildlifeSpecies.update, proShot.insteadof_WildlifeSpecies_update)
	end
	if WildlifeSpecies ~= nil and WildlifeSpecies.getCanDespawnInstance ~= nil then
		WildlifeSpecies.getCanDespawnInstance = Utils.overwrittenFunction(
			WildlifeSpecies.getCanDespawnInstance, proShot.insteadof_WildlifeSpecies_getCanDespawnInstance)
	end
	-- FS25 still ships WildlifeSpeciesSimple and the ground-crow asset, but the
	-- simple graphics lifecycle is incomplete in the current scripts. Supply the
	-- missing spawn hook and correct its transition timer only for this dormant
	-- path; native fly-by graphics never enter the transition branch.
	if WildlifeInstanceGraphics ~= nil and WildlifeInstanceGraphics.onInstanceSpawned == nil then
		WildlifeInstanceGraphics.onInstanceSpawned = proShot.WildlifeInstanceGraphics_onInstanceSpawned
	end
	if WildlifeInstanceGraphics ~= nil and WildlifeInstanceGraphics.update ~= nil then
		WildlifeInstanceGraphics.update = Utils.overwrittenFunction(
			WildlifeInstanceGraphics.update, proShot.insteadof_WildlifeInstanceGraphics_update)
	end
	-- The dormant FS25 WildlifeInstanceSimple implementation calls
	-- mover:delete(), but WildlifeInstanceMover does not define that lifecycle
	-- method. Without it, removing ProShot's adapted ground crows aborts the
	-- entire unpause restoration. Cancel pending movement/raycasts and release
	-- the instance reference, matching the mover's table-only ownership model.
	if WildlifeInstanceMover ~= nil and WildlifeInstanceMover.delete == nil then
		WildlifeInstanceMover.delete = proShot.WildlifeInstanceMover_delete
	end
	if WildlifeManager ~= nil and WildlifeManager.trySpawnWildlife ~= nil then
		WildlifeManager.trySpawnWildlife = Utils.overwrittenFunction(WildlifeManager.trySpawnWildlife, proShot.insteadof_WildlifeManager_trySpawnWildlife)
	end

	proShot.dynamicMenuNames = {
		["spring"] = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")",
		["summer"] = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")",
		["autumn"] = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")",
		["winter"] = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")",
		["sunny"] = g_i18n:getText("proShot_weather_SUN") .. " (1)",
		["cloudy"] = g_i18n:getText("proShot_weather_CLOUDY") .. " (1)",
		["rainy"] = g_i18n:getText("proShot_weather_RAIN") .. " (1)",
		["hail"] = g_i18n:getText("proShot_weather_HAIL") .. " (1)",
		["snowy"] = g_i18n:getText("proShot_weather_SNOW") .. " (1)",
		["flashLightEnter"] = g_i18n:getText("proShot_menu_flashLight_turnOn"),
		["focusAssist"] = g_i18n:getText("proShot_focus_set"),
		["mainReset"] = g_i18n:getText("proShot_menu_resetAll"),
		["gridAid"] = "",
		["aspectAid"] = ""
	}
	proShot:updateMainDynamicText()
	proShot:refreshFavouriteGroupNames()
	proShot:loadFavourites()
	proShot:loadEffectSlots()
	proShot:loadFlashlightFavourites()

	proShot.menus = {
		["main"] = proShot:buildMainMenu(),
		["advMenu"] = {
			{ "PRO_SHOT_1", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_DoF"), 4 },
			{ "PRO_SHOT_2", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_advSunMenu"), 4 },
			{ "PRO_SHOT_3", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_effects"), 4 },
			{ "PRO_SHOT_4", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_toneMapping"), 4 },
			{ "PRO_SHOT_5", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_advQualityMenu"), 4 },
			{ "PRO_SHOT_6", "callbackMenu_advMenu", g_i18n:getText("proShot_menu_fogAdvanced"), 4 },
			{ "PRO_SHOT_7", "callbackMenu_advMenu", g_i18n:getText("proShot_testing_localSnow"), 4 },
			{ "PRO_SHOT_8", "callbackMenu_advMenu", g_i18n:getText("proShot_wildlife_menu"), 4 },
			{ "PRO_SHOT_9", "callbackMenu_advMenu", g_i18n:getText("proShot_scene_menu"), 4 },
			{ "PRO_SHOT_F", "callbackMenu_main", g_i18n:getText("input_TOGGLE_LIGHTS_FPS"), 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_main", g_i18n:getText("proShot_menu_returnToMain"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["environment"] = {
			{ "PRO_SHOT_1", "callbackMenu_enviro", {"spring"}, 2 },
			{ "PRO_SHOT_2", "callbackMenu_enviro", {"summer"}, 2 },
			{ "PRO_SHOT_3", "callbackMenu_enviro", {"autumn"}, 2 },
			{ "PRO_SHOT_4", "callbackMenu_enviro", {"winter"}, 2 },
			{ "PRO_SHOT_5", "callbackMenu_enviro", {"sunny"}, 2 },
			{ "PRO_SHOT_6", "callbackMenu_enviro", {"cloudy"}, 2 },
			{ "PRO_SHOT_7", "callbackMenu_enviro", {"rainy"}, 2 },
			{ "PRO_SHOT_8", "callbackMenu_enviro", {"hail"}, 2 },
			{ "PRO_SHOT_9", "callbackMenu_enviro", {"snowy"}, 2 },
			{ "PRO_SHOT_0", "callbackMenu_enviro", g_i18n:getText("proShot_menu_snowShader"), 3 },
			{ "PRO_SHOT_DOT3", "callbackMenu_enviro", g_i18n:getText("proShot_seasonTweak"), 4 },
			{ "PRO_SHOT_DIVMUL", "callbackMenu_enviro", g_i18n:getText("proShot_menu_timeHorly"), 4 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_enviro", g_i18n:getText("proShot_menu_timeMins"), 4 },
			{ "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_enviro", g_i18n:getText("proShot_infoBox_snowLevel"), 4 },
			{ "PRO_SHOT_47", "callbackMenu_enviro", g_i18n:getText("proShot_menu_fog"), 4 },
			{ "PRO_SHOT_58", "callbackMenu_enviro", g_i18n:getText("proShot_menu_haze"), 4 },
			{ "PRO_SHOT_MINUSEQUALS", "callbackMenu_enviro", g_i18n:getText("proShot_testing_groundWetness"), 4 },

			{ "PRO_SHOT_BACKSLASH", "callbackMenu_enviro", g_i18n:getText("proShot_menu_resetThis"), 1 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_main", g_i18n:getText("proShot_menu_returnToMain"), 5 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 6 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 7 }
		},
		["DoF"] = proShot:buildDoFMenu(),
		["effects"] = proShot:buildEffectsMenu(),
		["effectsCustomise"] = {
			{ "PRO_SHOT_1", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_global"), 3 },
			{ "PRO_SHOT_2", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_shadows"), 3 },
			{ "PRO_SHOT_3", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_midtones"), 3 },
			{ "PRO_SHOT_4", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_highlights"), 3 },
			{ "PRO_SHOT_47", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_shadowsMax"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_highlightsMin"), 3 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_resetLuminance"), 3 },
			{ "PRO_SHOT_MINUS", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_resetSlot"), 3 },
			{ "PRO_SHOT_EQUALS", "callbackMenu_effectsCustomise", g_i18n:getText("proShot_effect_saveSlotMenu"), 3 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_effectsCustomise", g_i18n:getText("ui_ingameMenuPrev"), 4 }
		},
		["effectGroup"] = {
			{ "PRO_SHOT_1", "callbackMenu_effectGroup", g_i18n:getText("proShot_effect_saturation"), 3 },
			{ "PRO_SHOT_2", "callbackMenu_effectGroup", g_i18n:getText("proShot_effect_contrast"), 3 },
			{ "PRO_SHOT_3", "callbackMenu_effectGroup", g_i18n:getText("proShot_effect_gamma"), 3 },
			{ "PRO_SHOT_4", "callbackMenu_effectGroup", g_i18n:getText("proShot_effect_gain"), 3 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_effectGroup", g_i18n:getText("ui_ingameMenuPrev"), 4 }
		},
		["effectValue"] = {
			{ "PRO_SHOT_47", "callbackMenu_effectValue", g_i18n:getText("ui_colorRed"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_effectValue", g_i18n:getText("ui_colorGreen"), 3 },
			{ "PRO_SHOT_69", "callbackMenu_effectValue", g_i18n:getText("ui_colorBlue"), 3 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_effectValue", g_i18n:getText("proShot_effect_scale"), 3 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_effectValue", g_i18n:getText("proShot_menu_revertThisScreen"), 3 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_effectValue", g_i18n:getText("ui_ingameMenuPrev"), 4 }
		},
		["effectSaveSlot"] = {
			{ "PRO_SHOT_1", "callbackMenu_effectSaveSlot", {"effectSave1"}, 1 },
			{ "PRO_SHOT_2", "callbackMenu_effectSaveSlot", {"effectSave2"}, 1 },
			{ "PRO_SHOT_3", "callbackMenu_effectSaveSlot", {"effectSave3"}, 1 },
			{ "PRO_SHOT_4", "callbackMenu_effectSaveSlot", {"effectSave4"}, 1 },
			{ "PRO_SHOT_5", "callbackMenu_effectSaveSlot", {"effectSave5"}, 1 },
			{ "PRO_SHOT_6", "callbackMenu_effectSaveSlot", {"effectSave6"}, 1 },
			{ "PRO_SHOT_7", "callbackMenu_effectSaveSlot", {"effectSave7"}, 1 },
			{ "PRO_SHOT_8", "callbackMenu_effectSaveSlot", {"effectSave8"}, 1 },
			{ "PRO_SHOT_9", "callbackMenu_effectSaveSlot", {"effectSave9"}, 1 },
			{ "PRO_SHOT_0", "callbackMenu_effectSaveSlot", {"effectSave10"}, 2 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_effectSaveSlot", g_i18n:getText("ui_ingameMenuPrev"), 3 }
		},
		["effectResetSlot"] = {},
		["advQuality"] = {
			{ "PRO_SHOT_47", "callbackMenu_advQuality", g_i18n:getText("proShot_menu_advQ_VD"), 4 },
			{ "PRO_SHOT_58", "callbackMenu_advQuality", g_i18n:getText("proShot_menu_advQ_LOD"), 4 },
			{ "PRO_SHOT_69", "callbackMenu_advQuality", g_i18n:getText("proShot_menu_advQ_TLOD"), 4 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_advQuality", g_i18n:getText("proShot_menu_advQ_FVD"), 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_subMenu", g_i18n:getText("proShot_menu_returnToAdvanced"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["fog"] = {
			{ "PRO_SHOT_47", "callbackMenu_fog", g_i18n:getText("proShot_fog_groundDensity"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_fog", g_i18n:getText("proShot_fog_extraHeight"), 3 },
			{ "PRO_SHOT_69", "callbackMenu_fog", g_i18n:getText("proShot_fog_coverage"), 3 },
			{ "PRO_SHOT_DIVMUL", "callbackMenu_fog", g_i18n:getText("proShot_fog_softness"), 3 },
			{ "PRO_SHOT_DOT3", "callbackMenu_fog", g_i18n:getText("proShot_fog_minValleyDepth"), 4 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_fog", g_i18n:getText("proShot_menu_haze"), 5 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_fog", g_i18n:getText("proShot_menu_resetThis"), 6 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_fog", g_i18n:getText("proShot_menu_returnToAdvanced"), 7 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 8 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 8 }
		},
		["localSnow"] = {
			{ "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_localSnow", g_i18n:getText("proShot_testing_snowRadius"), 2 },
			{ "PRO_SHOT_MINUSEQUALS", "callbackMenu_localSnow", g_i18n:getText("proShot_testing_snowHeight"), 2 },
			{ "PRO_SHOT_DIVMUL", "callbackMenu_localSnow", g_i18n:getText("proShot_snow_strength"), 2 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_localSnow", g_i18n:getText("proShot_snow_globalLevel"), 2 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_localSnow", g_i18n:getText("proShot_menu_returnToAdvanced"), 3 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["wildlife"] = proShot:buildWildlifeMenu(),
		["sceneControls"] = proShot:buildSceneControlsMenu(),
		["toneMapping"] = {
			{ "PRO_SHOT_47", "callbackMenu_toneMapping", g_i18n:getText("proShot_tone_slope"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_toneMapping", g_i18n:getText("proShot_tone_toe"), 3 },
			{ "PRO_SHOT_69", "callbackMenu_toneMapping", g_i18n:getText("proShot_tone_shoulder"), 3 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_toneMapping", g_i18n:getText("proShot_tone_blackClip"), 3 },
			{ "PRO_SHOT_DIVMUL", "callbackMenu_toneMapping", g_i18n:getText("proShot_tone_whiteClip"), 3 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_toneMapping", g_i18n:getText("proShot_menu_resetThis"), 3 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_subMenu", g_i18n:getText("proShot_menu_returnToAdvanced"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["sun"] = {
			{ "PRO_SHOT_1", "callbackMenu_sun", g_i18n:getText("proShot_menu_skyBrightness"), 1 },
			{ "PRO_SHOT_2", "callbackMenu_sun", g_i18n:getText("proShot_menu_groundLight"), 1 },
			{ "PRO_SHOT_3", "callbackMenu_sun", g_i18n:getText("proShot_menu_skyAndGround"), 1 },
			{ "PRO_SHOT_MINUSEQUALS", "callbackMenu_sun", g_i18n:getText("proShot_menu_atmosRefraction"), 2 },
			{ "PRO_SHOT_SQUAREBRACKETS", "callbackMenu_sun", g_i18n:getText("proShot_menu_sunSize"), 3 },
			{ "PRO_SHOT_DOT3", "callbackMenu_sun", g_i18n:getText("proShot_menu_moonSize"), 4 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_sun", g_i18n:getText("proShot_menu_resetThis"), 5 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_subMenu", g_i18n:getText("proShot_menu_returnToAdvanced"), 6 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 7 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 8 }
		},
		["skyBrightness"] = {
			{ "PRO_SHOT_DIVMUL", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_colourTemperature"), 2 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_intensity"), 2 },
			{ "PRO_SHOT_47", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_red"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_green"), 3 },
			{ "PRO_SHOT_69", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_blue"), 3 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_resetThis"), 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_skyBrightness", g_i18n:getText("proShot_menu_returnToSky"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["groundLight"] = {
			{ "PRO_SHOT_DIVMUL", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_colourTemperature"), 2 },
			{ "PRO_SHOT_KP_MINUSPLUS", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_intensity"), 2 },
			{ "PRO_SHOT_47", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_red"), 3 },
			{ "PRO_SHOT_58", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_green"), 3 },
			{ "PRO_SHOT_69", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_blue"), 3 },
			{ "PRO_SHOT_BACKSLASH", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_resetThis"), 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_groundLight", g_i18n:getText("proShot_menu_returnToSky"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 },
			{ "PRO_SHOT_ENTER", "callbackMenu_capture", g_i18n:getText("proShot_takePicture"), 4 }
		},
		["skyAndGround"] = proShot:buildSkyAndGroundMenu(),
		["flashLight"] = proShot:buildFlashLightMenu(),
		["flashlightFavouriteSaveSlot"] = proShot:buildFlashlightFavouriteSaveMenu(),
		["flashlightFavouriteDeleteSlot"] = proShot:buildFlashlightFavouriteDeleteMenu(),
		["favourites"] = proShot:buildFavouritesMenu(),
		["favouriteSaveSlot"] = {
			{ "PRO_SHOT_1", "callbackMenu_favouriteSaveSlot", {"favouriteSave1"}, 3 },
			{ "PRO_SHOT_2", "callbackMenu_favouriteSaveSlot", {"favouriteSave2"}, 3 },
			{ "PRO_SHOT_3", "callbackMenu_favouriteSaveSlot", {"favouriteSave3"}, 3 },
			{ "PRO_SHOT_4", "callbackMenu_favouriteSaveSlot", {"favouriteSave4"}, 3 },
			{ "PRO_SHOT_5", "callbackMenu_favouriteSaveSlot", {"favouriteSave5"}, 3 },
			{ "PRO_SHOT_6", "callbackMenu_favouriteSaveSlot", {"favouriteSave6"}, 3 },
			{ "PRO_SHOT_7", "callbackMenu_favouriteSaveSlot", {"favouriteSave7"}, 3 },
			{ "PRO_SHOT_8", "callbackMenu_favouriteSaveSlot", {"favouriteSave8"}, 3 },
			{ "PRO_SHOT_9", "callbackMenu_favouriteSaveSlot", {"favouriteSave9"}, 3 },
			{ "PRO_SHOT_0", "callbackMenu_favouriteSaveSlot", {"favouriteSave10"}, 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_favouriteSaveSlot", g_i18n:getText("proShot_favourite_cancel"), 5 }
		},
		["favouriteSaveGroups"] = {
			{ "PRO_SHOT_1", "callbackMenu_favouriteSaveGroups", {"favouriteGroup1"}, 3 },
			{ "PRO_SHOT_2", "callbackMenu_favouriteSaveGroups", {"favouriteGroup2"}, 3 },
			{ "PRO_SHOT_3", "callbackMenu_favouriteSaveGroups", {"favouriteGroup3"}, 3 },
			{ "PRO_SHOT_4", "callbackMenu_favouriteSaveGroups", {"favouriteGroup4"}, 3 },
			{ "PRO_SHOT_5", "callbackMenu_favouriteSaveGroups", {"favouriteGroup5"}, 3 },
			{ "PRO_SHOT_6", "callbackMenu_favouriteSaveGroups", {"favouriteGroup6"}, 3 },
			{ "PRO_SHOT_7", "callbackMenu_favouriteSaveGroups", {"favouriteGroup7"}, 3 },
			{ "PRO_SHOT_8", "callbackMenu_favouriteSaveGroups", {"favouriteGroup8"}, 3 },
			{ "PRO_SHOT_ENTER", "callbackMenu_favouriteSaveGroups", g_i18n:getText("proShot_favourite_continueName"), 4 },
			{ "PRO_SHOT_BACKSPACE", "callbackMenu_favouriteSaveGroups", g_i18n:getText("proShot_favourite_backToSlots"), 4 },
			{ "PRO_SHOT_F1", "callbackMenu_void", g_i18n:getText("proShot_hideHUD"), 4 }
		},
		["favouriteDeleteSlot"] = proShot:buildFavouriteDeleteMenu()
	}

end

function proShot:callbackMenu_flashLight(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local light = proShot.heldLight
		local r, g, b = getLightColor(light.lightNode)
		local favouriteSlot = proShot:getFlashlightFavouriteSlotFromAction(what)

		if favouriteSlot ~= nil and proShot.flashlightFavourites[favouriteSlot] ~= nil and axisComponent == 1 then
			proShot:applyFlashlightFavourite(favouriteSlot)
		elseif what == "PRO_SHOT_0" and axisComponent == 1 then
			-- The favourite slot screens are part of the flashlight editor. Keep a
			-- current logical copy for the name-dialog rebuild without replacing the
			-- visible light with the outside-menu default.
			proShot.flashLightMenuSettings = proShot:captureHeldLightSettings()
			proShot.menuDesired = "flashlightFavouriteSaveSlot"
		elseif what == "PRO_SHOT_9" and axisComponent == 1 then
			proShot.flashLightMenuSettings = proShot:captureHeldLightSettings()
			proShot.menuDesired = "flashlightFavouriteDeleteSlot"
		elseif what == "PRO_SHOT_47" and axisComponent == -1 then
			proShot:lightColourChange({-0.1, 0, 0}, light)
		elseif what == "PRO_SHOT_47" and axisComponent == 1 then
			proShot:lightColourChange({0.1, 0, 0}, light)
		elseif what == "PRO_SHOT_58" and axisComponent == -1 then
			proShot:lightColourChange({0, -0.1, 0}, light)
		elseif what == "PRO_SHOT_58" and axisComponent == 1 then
			proShot:lightColourChange({0, 0.1, 0}, light)
		elseif what == "PRO_SHOT_69" and axisComponent == -1 then
			proShot:lightColourChange({0, 0, -0.1}, light)
		elseif what == "PRO_SHOT_69" and axisComponent == 1 then
			proShot:lightColourChange({0, 0, 0.1}, light)
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent == -1 then
			light.colourTemp = math.min(math.floor(light.colourTemp + light.colourTemp / 10), 40000)
			setLightColor(light.lightNode, self:colourTempToRGB(light.colourTemp, light.intensity))
			light.colourTempIsPreset = true
		elseif what == "PRO_SHOT_DIVMUL"  and axisComponent == 1 then
			light.colourTemp = math.max(math.floor(light.colourTemp - light.colourTemp / 10), 1000)
			setLightColor(light.lightNode, self:colourTempToRGB(light.colourTemp, light.intensity))
			light.colourTempIsPreset = true
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == -1 then
			proShot:lightIntensityChange(-0.1, light)
		elseif what == "PRO_SHOT_KP_MINUSPLUS"	and axisComponent == 1 then
			proShot:lightIntensityChange(0.1, light)
		elseif what == "PRO_SHOT_DOT3" and axisComponent == -1 then
			proShot:lightFauxSet(light.coneAngle - 10, light.dropOff)
		elseif what == "PRO_SHOT_DOT3"	and axisComponent == 1 then
			proShot:lightFauxSet(light.coneAngle + 10, light.dropOff)
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent == -1 then
			proShot:lightFauxSet(light.coneAngle, light.dropOff - 1)
		elseif what == "PRO_SHOT_MINUSEQUALS"  and axisComponent == 1 then
			proShot:lightFauxSet(light.coneAngle, light.dropOff + 1)
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == -1 then
			light.range = math.max(getLightRange(light.lightNode) - 1, 0)
			setLightRange(light.lightNode, light.range)
		elseif what == "PRO_SHOT_SQUAREBRACKETS"  and axisComponent == 1 then
			light.range = math.min(getLightRange(light.lightNode) + 1, 500)
			setLightRange(light.lightNode, light.range)
		elseif what == "PRO_SHOT_KP_0" and axisComponent == 1 then
			proShot:applyHeldLightSettings(proShot:getDefaultFlashLightSettings(), getVisibility(light.lightNode))
		elseif (what == "PRO_SHOT_KP_ENTER" or what == "PRO_SHOT_ENTER") and axisComponent == 1 then
			if proShot:lightPlace(light) then
				proShot:showToast(string.format(g_i18n:getText("proShot_flashLight_placed"), #proShot.placedLights))
			end
			proShot:updateFlashLightEnterText()
		elseif what == "PRO_SHOT_BACKSLASH" then
			local lightToRemove = 0
			local indexToRemove = 0
			for k, lightId in ipairs(proShot.placedLights) do
				lightToRemove = lightId
				indexToRemove = k
			end
			if lightToRemove ~= 0 then
				delete(lightToRemove)
				table.remove(proShot.placedLights, indexToRemove)
			end
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_flashlightFavouriteSaveSlot(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFlashlightFavouriteSlotFromAction(what)
		if slot ~= nil and axisComponent == 1 then
			proShot:showFlashlightFavouriteNameDialog(slot)
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "flashLight"
		end
	end
end

function proShot:callbackMenu_flashlightFavouriteDeleteSlot(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFlashlightFavouriteSlotFromAction(what)
		if slot ~= nil and proShot.flashlightFavourites[slot] ~= nil and axisComponent == 1 then
			proShot:showFlashlightFavouriteDeleteDialog(slot)
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "flashLight"
		end
	end
end

function proShot:callbackMenu_main(what, axisComponent)
	if what == "PRO_SHOT_BACKSLASH" and axisComponent == 0 and not proShot.menuRebuilding then
		proShot.resetFlashlightsReleaseRequired = false
	end
	if what == "PRO_SHOT_0" then
		proShot:handleCentreFocusInput(axisComponent)
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		if what == "PRO_SHOT_1" then -- Toggle the two one-key quality presets.
			local isHigh = proShot:isHighQualityPreset()
			setViewDistanceCoeff(isHigh and 1 or 10)
			setLODDistanceCoeff(isHigh and 1 or 10)
			setTerrainLODDistanceCoeff(isHigh and 1 or 10)
			setFoliageViewDistanceCoeff(isHigh and 1 or 5)
			proShot:refreshMainMenu()
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
			proShot:changeLinkedLightingTemperature(axisComponent)
		elseif what == "PRO_SHOT_8" and proShot.focusAssist ~= nil then
			proShot:adjustFocusRange(-1)
		elseif what == "PRO_SHOT_9" and proShot.focusAssist ~= nil then
			proShot:adjustFocusRange(1)
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent == -1 then -- Lower Exposure
			proShot.exposureMinValue = math.max(proShot.exposureMinValue - 0.1, -5)
			proShot.exposureMaxValue = proShot.exposureMinValue
			setExposureRange(proShot.exposureKeyValue, proShot.exposureMinValue, proShot.exposureMaxValue)
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent == 1 then -- Raise Exposure
			proShot.exposureMinValue = math.min(proShot.exposureMinValue + 0.1, 5)
			proShot.exposureMaxValue = proShot.exposureMinValue
			setExposureRange(proShot.exposureKeyValue, proShot.exposureMinValue, proShot.exposureMaxValue)
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == -1 then -- Lower FoV
			proShot.FoV = math.max(proShot.FoV - 1, 1)
			setFovY(getChildAt(proShot.tripod, 0), math.rad(proShot.FoV))
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == 1 then -- Raise FoV
			proShot.FoV = math.min(proShot.FoV + 1, 170)
			setFovY(getChildAt(proShot.tripod, 0), math.rad(proShot.FoV))
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
			proShot:changeLinkedLightingIntensity(axisComponent)
		elseif what == "PRO_SHOT_F" then -- Toggle flashlight
			self:toggleFlashLight()
		elseif what == "PRO_SHOT_2" and axisComponent == 1 then
			proShot.gridAidIndex = proShot.gridAidIndex % #proShot.GRID_AIDS + 1
			proShot:updateMainDynamicText()
			proShot.menuCurrent = "noneAtAll"
		elseif what == "PRO_SHOT_3" and axisComponent == 1 then
			proShot.aspectAidIndex = proShot.aspectAidIndex % #proShot.ASPECT_AIDS + 1
			proShot:updateMainDynamicText()
			proShot.menuCurrent = "noneAtAll"
		elseif what == "PRO_SHOT_4" then
			proShot.menuDesired = "environment"
		elseif what == "PRO_SHOT_5" then
			proShot.menuDesired = "flashLight"
		elseif what == "PRO_SHOT_7" then -- Named favourite presets
			-- Keep one immutable baseline while the user previews any number of
			-- presets. Backslash in Favourites restores this exact entry state.
			proShot.favouritesEntrySettings = proShot:captureFavourite("")
			proShot.menuDesired = "favourites"
		elseif what == "PRO_SHOT_6" then
			proShot.menuDesired = "advMenu"
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			if proShot.resetFlashlightsArmed and not proShot.resetFlashlightsReleaseRequired then
				proShot:clearPlacedLights()
				proShot.resetFlashlightsArmed = false
				proShot.resetFlashlightsReleaseRequired = false
				proShot:refreshMainMenu()
			elseif not proShot.resetFlashlightsArmed and proShot.sessionInitialSettings ~= nil then
				proShot:applySettingsSnapshot(proShot.sessionInitialSettings)
				proShot:restoreGroundWetness()
				proShot.gridAidIndex = 1
				proShot.aspectAidIndex = 1
				proShot.resetFlashlightsArmed = #proShot.placedLights > 0
				proShot.resetFlashlightsReleaseRequired = proShot.resetFlashlightsArmed
				proShot:refreshMainMenu()
			end
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.pendingFavouriteSlot = nil
			proShot.pendingFavouriteGroups = nil
			proShot.menuDesired = "main"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_advMenu(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		if what == "PRO_SHOT_1" then -- Depth of Field
			proShot.menuDesired = "DoF"
		elseif what == "PRO_SHOT_2" then -- Sky menu
			proShot.menuDesired = "sun"
		elseif what == "PRO_SHOT_3" then -- Colour grading and post effects
			if proShot.colourGradingSelection == nil and not proShot.effectEditorDirty and proShot.customLighting == nil then
				proShot.effectEditorState = proShot:captureCurrentEffectState()
				proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
				proShot.effectEditorBaselineSelection = nil
			end
			proShot.menuDesired = "effects"
		elseif what == "PRO_SHOT_4" then -- Tone mapping
			proShot.menuDesired = "toneMapping"
		elseif what == "PRO_SHOT_5" then -- Advanced Quality
			proShot.menuDesired = "advQuality"
		elseif what == "PRO_SHOT_6" then -- Expanded ground-fog and haze controls
			proShot.menuDesired = "fog"
		elseif what == "PRO_SHOT_7" then -- Local snow sculpting
			proShot.localSnowTarget = nil
			proShot:updateLocalSnowTarget()
			proShot.menuDesired = "localSnow"
		elseif what == "PRO_SHOT_8" then -- Wildlife and bird posing
			proShot:refreshWildlifeMenu()
			proShot.menuDesired = "wildlife"
		elseif what == "PRO_SHOT_9" then -- Traffic, pedestrians and scene details
			proShot:refreshSceneControlsMenu()
			proShot.menuDesired = "sceneControls"
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "main"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_fog(what, axisComponent)
	local oneShot = what == "PRO_SHOT_BACKSLASH"
	local accepted = oneShot and proShot:keyPressOnce(what, axisComponent)
		or (not oneShot and proShot:keyRepeatThrottle(false, what, axisComponent, 30))
	if not accepted then
		return
	end

	local fog = proShot.fogState
	if fog == nil then
		return
	end
	if what == "PRO_SHOT_47" and axisComponent ~= 0 then
		proShot:activateGroundFogOverride()
		fog.groundFogGroundLevelDensity = math.clamp(fog.groundFogGroundLevelDensity + axisComponent * 0.01, 0, 1)
		proShot.fogDensityValue = fog.groundFogGroundLevelDensity
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_58" and axisComponent ~= 0 then
		fog.groundFogExtraHeight = math.clamp(fog.groundFogExtraHeight + axisComponent * 0.5, 0, 50)
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_69" and axisComponent ~= 0 then
		-- FS25's two coverage edges are the transition thresholds rather than
		-- independent photographic controls. Move them together so Coverage has
		-- an intuitive direction: increasing it reveals more of the fog profile.
		local edge0 = math.min(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		local edge1 = math.max(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		local halfSoftness = (edge1 - edge0) * 0.5
		local middle = math.clamp((edge0 + edge1) * 0.5 - axisComponent * 0.01, halfSoftness, 1 - halfSoftness)
		fog.groundFogCoverageEdge0 = middle - halfSoftness
		fog.groundFogCoverageEdge1 = middle + halfSoftness
		proShot.fogOverrideCoverageEdge0 = fog.groundFogCoverageEdge0
		proShot.fogOverrideCoverageEdge1 = fog.groundFogCoverageEdge1
		proShot.fogOverrideActive = true
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
		local edge0 = math.min(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		local edge1 = math.max(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		local middle = (edge0 + edge1) * 0.5
		local maxHalfSoftness = math.min(middle, 1 - middle)
		local halfSoftness = math.clamp((edge1 - edge0) * 0.5 + axisComponent * 0.005, 0, maxHalfSoftness)
		fog.groundFogCoverageEdge0 = middle - halfSoftness
		fog.groundFogCoverageEdge1 = middle + halfSoftness
		proShot.fogOverrideCoverageEdge0 = fog.groundFogCoverageEdge0
		proShot.fogOverrideCoverageEdge1 = fog.groundFogCoverageEdge1
		proShot.fogOverrideActive = true
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_DOT3" and axisComponent ~= 0 then
		fog.groundFogMinValleyDepth = math.clamp(fog.groundFogMinValleyDepth + axisComponent * 0.5, 0.5, 20)
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
		fog.heightFogGroundLevelDensity = math.clamp(fog.heightFogGroundLevelDensity + axisComponent * 0.01, 0, 1)
		proShot:applyFogState(fog)
	elseif what == "PRO_SHOT_BACKSLASH" then
		proShot:resetFogMenuState()
	elseif what == "PRO_SHOT_BACKSPACE" then
		proShot.menuDesired = "advMenu"
	else
		Logging.info("Unknown menuCallback: " .. tostring(what))
	end
end

function proShot:showTyreTrackRemovalDialog()
	if OptionDialog == nil or OptionDialog.INSTANCE == nil then
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
		return
	end
	proShot.favouriteDialogOpen = true
	proShot.captureKeyReleaseRequired = true
	OptionDialog.show(function(selected)
		proShot:onTyreTrackScopeSelected(selected)
	end,
		g_i18n:getText("proShot_testing_removeTyreTracksChoose"),
		g_i18n:getText("proShot_testing_removeTyreTracksTitle"),
		{
			g_i18n:getText("proShot_testing_tyreTracks100m"),
			g_i18n:getText("proShot_testing_tyreTracksWholeMap"),
			g_i18n:getText("button_cancel")
		}, 1)
end

function proShot:onTyreTrackScopeSelected(selected)
	if selected == nil or selected == 0 or selected == 3 then
		proShot.favouriteDialogOpen = false
		proShot.captureKeyReleaseRequired = true
		proShot.keyLockout = {}
		proShot.menuCurrent = "noneAtAll"
		proShot.menuDesired = "sceneControls"
		return
	end
	if YesNoDialog == nil or YesNoDialog.INSTANCE == nil then
		proShot.favouriteDialogOpen = false
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
		return
	end
	local scope = selected == 1 and "local" or "all"
	local promptKey = scope == "local" and "proShot_testing_removeTyreTracksPrompt100m"
		or "proShot_testing_removeTyreTracksPromptAll"
	YesNoDialog.show(
		proShot.onTyreTrackRemovalConfirmed,
		proShot,
		g_i18n:getText(promptKey),
		g_i18n:getText("proShot_testing_removeTyreTracksTitle"),
		g_i18n:getText("button_delete"),
		g_i18n:getText("button_cancel"), nil, nil, nil, { scope = scope })
end

function proShot:onTyreTrackRemovalConfirmed(confirmed, args)
	proShot.favouriteDialogOpen = false
	proShot.captureKeyReleaseRequired = true
	proShot.keyLockout = {}
	proShot.menuCurrent = "noneAtAll"
	proShot.menuDesired = "sceneControls"
	if not confirmed then
		return
	end
	local tireTrackSystem = g_currentMission ~= nil and g_currentMission.tireTrackSystem or nil
	if tireTrackSystem == nil then
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
		return
	end
	local scope = args ~= nil and args.scope or "all"
	local ok, err = pcall(function()
		if scope == "local" then
			local camera = proShot.ourCamera
			local x, _, z = getWorldTranslation(camera)
			local vertices = {}
			for index = 0, 47 do
				local angle = index / 48 * math.pi * 2
				table.insert(vertices, x + math.cos(angle) * 100)
				table.insert(vertices, z + math.sin(angle) * 100)
			end
			tireTrackSystem:erasePolygon(vertices)
			executeConsoleCommand("vtRedrawAll")
		else
			tireTrackSystem:consoleCommandRemoveAllTireTracks()
		end
	end)
	if not ok then
		Logging.warning("ProShot: Removing tyre tracks failed: %s", tostring(err))
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
	else
		proShot:showToast(g_i18n:getText(scope == "local" and "proShot_testing_tyreTracksRemoved100m"
			or "proShot_testing_tyreTracksRemovedAll"))
	end
end

function proShot:callbackMenu_wildlife(what, axisComponent)
	local oneShot = what == "PRO_SHOT_1" or what == "PRO_SHOT_2" or what == "PRO_SHOT_3"
		or what == "PRO_SHOT_4" or what == "PRO_SHOT_5" or what == "PRO_SHOT_6"
		or what == "PRO_SHOT_7" or what == "PRO_SHOT_8" or what == "PRO_SHOT_9"
		or what == "PRO_SHOT_0" or what == "PRO_SHOT_KP_0" or what == "PRO_SHOT_KP_PERIOD"
		or what == "PRO_SHOT_BACKSLASH"
		or what == "PRO_SHOT_BACKSPACE"
	local accepted = oneShot and proShot:keyPressOnce(what, axisComponent)
		or (not oneShot and proShot:keyRepeatThrottle(false, what, axisComponent, 30))
	if not accepted then
		return
	end

	if what == "PRO_SHOT_1" then
		proShot:spawnWildlife(proShot:getSelectedWildlife(false), false)
	elseif what == "PRO_SHOT_2" then
		proShot:cycleSelectedWildlife(false)
	elseif what == "PRO_SHOT_3" then
		proShot:setWildlifePaused(not proShot.wildlifePaused)
		proShot:refreshWildlifeMenu()
	elseif what == "PRO_SHOT_4" then
		proShot:despawnLastTrackedWildlife(false)
	elseif what == "PRO_SHOT_5" then
		proShot:spawnWildlife(proShot:getSelectedWildlife(true), true)
	elseif what == "PRO_SHOT_6" then
		proShot:cycleSelectedWildlife(true)
	elseif what == "PRO_SHOT_7" then
		proShot:setBirdsPaused(not proShot.birdsPaused)
		proShot:refreshWildlifeMenu()
	elseif what == "PRO_SHOT_8" then
		proShot:despawnLastTrackedWildlife(true)
	elseif what == "PRO_SHOT_9" then
		proShot:showFarmAnimalSelectionDialog()
	elseif what == "PRO_SHOT_0" then
		proShot:spawnSelectedFarmAnimal()
	elseif what == "PRO_SHOT_KP_PERIOD" then
		proShot:despawnLastTrackedFarmAnimal()
	elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
		proShot:adjustAnimalPlanarOffset("x", axisComponent)
	elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
		-- In this menu keypad minus means farther from the current camera and
		-- keypad plus means nearer, the inverse of the shared adjustment axis.
		proShot:adjustAnimalPlanarOffset("y", -axisComponent)
	elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent ~= 0 then
		proShot:adjustWildlifePlacementOffset(axisComponent)
	elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent ~= 0 then
		proShot:adjustWildlifeRotation(axisComponent)
	elseif what == "PRO_SHOT_KP_0" then
		proShot:resetAnimalPlacementOffsets()
	elseif what == "PRO_SHOT_BACKSLASH" then
		proShot:despawnTrackedWildlife(true)
	elseif what == "PRO_SHOT_BACKSPACE" then
		proShot.menuDesired = "advMenu"
	else
		Logging.info("Unknown menuCallback: " .. tostring(what))
	end
end

function proShot:callbackMenu_sceneControls(what, axisComponent)
	local oneShot = what == "PRO_SHOT_1" or what == "PRO_SHOT_2" or what == "PRO_SHOT_3"
		or what == "PRO_SHOT_4" or what == "PRO_SHOT_5" or what == "PRO_SHOT_0"
		or what == "PRO_SHOT_BACKSLASH" or what == "PRO_SHOT_BACKSPACE"
	local accepted = oneShot and proShot:keyPressOnce(what, axisComponent)
		or (not oneShot and proShot:keyRepeatThrottle(false, what, axisComponent, 30))
	if not accepted then
		return
	end

	if what == "PRO_SHOT_1" then
		local traffic = proShot:getTrafficSystem()
		if traffic == nil then
			proShot:showToast(g_i18n:getText("proShot_testing_trafficUnavailable"))
		else
			proShot:setTestingTrafficEnabled(not proShot.testingTrafficEnabled)
			proShot:refreshSceneControlsMenu()
		end
	elseif what == "PRO_SHOT_2" then
		local pedestrians = proShot:getPedestrianSystem()
		if pedestrians == nil then
			proShot:showToast(g_i18n:getText("proShot_testing_pedestriansUnavailable"))
		else
			proShot:setTestingPedestriansEnabled(not proShot.testingPedestriansEnabled)
			proShot:refreshSceneControlsMenu()
		end
	elseif what == "PRO_SHOT_3" then
		if not proShot:setTrafficPaused(not proShot.trafficPaused) then
			proShot:showToast(g_i18n:getText("proShot_testing_trafficUnavailable"))
		end
		proShot:refreshSceneControlsMenu()
	elseif what == "PRO_SHOT_4" then
		if not proShot:setPedestriansPaused(not proShot.pedestriansPaused) then
			proShot:showToast(g_i18n:getText("proShot_testing_pedestrianPauseUnavailable"))
		end
		proShot:refreshSceneControlsMenu()
	elseif what == "PRO_SHOT_5" then
		if not proShot:setParkedCarsEnabled(not proShot.parkedCarsEnabled) then
			proShot:showToast(g_i18n:getText("proShot_scene_parkedUnavailable"))
		end
		proShot:refreshSceneControlsMenu()
	elseif what == "PRO_SHOT_0" then
		proShot:showTyreTrackRemovalDialog()
	elseif what == "PRO_SHOT_BACKSLASH" then
		proShot:resetSceneControlsState()
	elseif what == "PRO_SHOT_BACKSPACE" then
		proShot.menuDesired = "advMenu"
	else
		Logging.info("Unknown menuCallback: " .. tostring(what))
	end
end

function proShot:callbackMenu_localSnow(what, axisComponent)
	if not proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		return
	end
	if what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent ~= 0 then
		local radiusStep = (proShot.localSnowRadius < 20 or (axisComponent < 0 and proShot.localSnowRadius <= 20)) and 1 or 5
		proShot.localSnowRadius = math.clamp(
			proShot.localSnowRadius + axisComponent * radiusStep,
			proShot.LOCAL_SNOW_MIN_RADIUS, proShot.LOCAL_SNOW_MAX_RADIUS)
	elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent ~= 0 then
		proShot:applyLocalSnow(axisComponent)
	elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
		proShot.localSnowStrengthLevel = math.clamp(
			proShot.localSnowStrengthLevel + axisComponent,
			1, #proShot.LOCAL_SNOW_STRENGTH_LEVELS)
	elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
		proShot:snowBusiness(proShot:snowBusiness("getHeight") + axisComponent * 0.1)
	elseif what == "PRO_SHOT_BACKSPACE" then
		proShot.menuDesired = "advMenu"
	else
		Logging.info("Unknown menuCallback: " .. tostring(what))
	end
end

function proShot:callbackMenu_subMenu(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) and what == "PRO_SHOT_BACKSPACE" then
		proShot.menuDesired = "advMenu"
	end
end

function proShot:callbackMenu_favourites(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot >= 1 and slot <= proShot.FAVOURITE_SLOT_COUNT then
			proShot:applyFavourite(slot)
		elseif what == "PRO_SHOT_EQUALS" then
			proShot.menuDesired = "favouriteSaveSlot"
			proShot.favouriteStatus = g_i18n:getText("proShot_favourite_chooseSaveSlot")
		elseif what == "PRO_SHOT_MINUS" then
			proShot.menuDesired = "favouriteDeleteSlot"
			proShot.favouriteStatus = g_i18n:getText("proShot_favourite_chooseDeleteSlot")
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			if proShot.favouritesEntrySettings ~= nil then
				proShot:applySettingsSnapshot(proShot.favouritesEntrySettings)
				proShot.favouriteStatus = g_i18n:getText("proShot_favourite_revertedStatus")
			end
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.pendingFavouriteSlot = nil
			proShot.pendingFavouriteGroups = nil
			proShot.menuDesired = "main"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_favouriteSaveSlot(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot >= 1 and slot <= proShot.FAVOURITE_SLOT_COUNT then
			proShot.pendingFavouriteSlot = slot
			proShot.pendingFavouriteGroups = proShot:createAllFavouriteGroups()
			proShot:refreshFavouriteGroupNames()
			proShot.favouriteStatus = string.format(g_i18n:getText("proShot_favourite_chooseGroups"), slot)
			proShot.menuDesired = "favouriteSaveGroups"
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.pendingFavouriteSlot = nil
			proShot.pendingFavouriteGroups = nil
			proShot.menuDesired = "favourites"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_favouriteSaveGroups(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
			-- A dialog can finish on the same frame as a stale menu action. Rebuild the
			-- selection state instead of indexing a cleared pending table.
		if proShot.pendingFavouriteGroups == nil or proShot.pendingFavouriteSlot == nil then
			proShot.pendingFavouriteGroups = nil
			proShot.pendingFavouriteSlot = nil
			proShot.menuDesired = "favouriteSaveSlot"
			proShot.menuCurrent = "noneAtAll"
			return
		end
		local index = proShot:getFavouriteSlotFromAction(what)
		if index ~= nil and index >= 1 and index <= #proShot.FAVOURITE_GROUPS then
			local key = proShot.FAVOURITE_GROUPS[index].key
			proShot.pendingFavouriteGroups[key] = not proShot.pendingFavouriteGroups[key]
			proShot:refreshFavouriteGroupNames()
			proShot.menuCurrent = "noneAtAll"
		elseif what == "PRO_SHOT_ENTER" and axisComponent == 1 then
			local anySelected = false
			for _, group in ipairs(proShot.FAVOURITE_GROUPS) do
				anySelected = anySelected or proShot.pendingFavouriteGroups[group.key]
			end
			if anySelected then
				proShot:showFavouriteNameDialog(proShot.pendingFavouriteSlot)
			else
				proShot:showToast(g_i18n:getText("proShot_favourite_selectOneGroup"))
			end
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "favouriteSaveSlot"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_favouriteDeleteSlot(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot >= 1 and slot <= proShot.FAVOURITE_SLOT_COUNT then
			proShot:showFavouriteDeleteDialog(slot)
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "favourites"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_enviro(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		if what == "PRO_SHOT_1" then
			proShot:seasonChange("spring")
		elseif what == "PRO_SHOT_2" then
			proShot:seasonChange("summer")
		elseif what == "PRO_SHOT_3" then
			proShot:seasonChange("autumn")
		elseif what == "PRO_SHOT_4" then
			proShot:seasonChange("winter")
		elseif what == "PRO_SHOT_5" then
			proShot:weatherChange("SUN")
		elseif what == "PRO_SHOT_6" then
			proShot:weatherChange("CLOUDY")
		elseif what == "PRO_SHOT_7" then
			proShot:weatherChange("RAIN")
		elseif what == "PRO_SHOT_8" then
			proShot:weatherChange("HAIL")
		elseif what == "PRO_SHOT_9" then
			proShot:weatherChange("SNOW")
		elseif what == "PRO_SHOT_0" and axisComponent == 1 then
			local frost = g_currentMission.snowSystem:getSnowShaderValue()
			proShot:setSnowShader(frost >= 0.5 and 0 or 1)

		elseif what == "PRO_SHOT_DIVMUL" and axisComponent == 1 then
			-- Jump time by hour
			proShot:timeChange(g_currentMission.environment.dayTime + 3600000)
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent == -1 then
			proShot:timeChange(g_currentMission.environment.dayTime - 3600000)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == 1 then
			-- Jump time by minute
			proShot:timeChange(g_currentMission.environment.dayTime + 60000)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == -1 then
			-- Jump time by minute
			proShot:timeChange(g_currentMission.environment.dayTime - 60000)
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == 1 then
			-- Increase snow level
			proShot:snowBusiness(proShot:snowBusiness("getHeight") + 0.1)
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == -1 then
			proShot:snowBusiness(proShot:snowBusiness("getHeight") - 0.1)
		elseif what == "PRO_SHOT_DOT3" and axisComponent == 1 then
			proShot:seasonChange("tweakUp")
		elseif what == "PRO_SHOT_DOT3" and axisComponent == -1 then
			proShot:seasonChange("tweakDown")
		elseif what == "PRO_SHOT_47" and axisComponent ~= 0 then
			proShot:activateGroundFogOverride()
			proShot.fogDensityValue = math.clamp((proShot.fogDensityValue or 0) + axisComponent * 0.01, 0, 1)
			proShot.fogState.groundFogGroundLevelDensity = proShot.fogDensityValue
			proShot:applyFogState(proShot.fogState)
		elseif what == "PRO_SHOT_58" and axisComponent ~= 0 then
			proShot.fogState.heightFogGroundLevelDensity = math.clamp(proShot.fogState.heightFogGroundLevelDensity + axisComponent * 0.01, 0, 1)
			proShot:applyFogState(proShot.fogState)
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent ~= 0 then
			proShot:applyGroundWetness(getWetness() + axisComponent * 0.05)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:restoreEnvironment()
			proShot:restoreGroundWetness()
			proShot.fogDensityValue = proShot.fromWhenceYouCame.pausedFogDensityValue
			proShot.fogOverrideActive = false
			proShot:applyFogState(proShot.fromWhenceYouCame.pausedFogState)
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_DoF(what, axisComponent)
	if what == "PRO_SHOT_0" then
		proShot:handleCentreFocusInput(axisComponent)
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		if what == "PRO_SHOT_8" and proShot.focusAssist ~= nil then
			proShot:adjustFocusRange(-1)
			return
		elseif what == "PRO_SHOT_9" and proShot.focusAssist ~= nil then
			proShot:adjustFocusRange(1)
			return
		end

		-- A manual DoF edit takes ownership back from the continuously tracked
		-- centre-focus helper, otherwise the next draw would overwrite the edit.
		if proShot.focusAssist ~= nil then
			proShot:clearFocusAssist()
		end
		local nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = unpack(proShot.DoFState)

		if what == "PRO_SHOT_1" and axisComponent == 1 then
			-- Gentle foreground blur.
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 0.1, 3, 20, 2, 2500, true
		elseif what == "PRO_SHOT_2" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 3, 3, 20, 2, 2500, true
		elseif what == "PRO_SHOT_3" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 2.5, 5, 14, 9, 2500, true
		elseif what == "PRO_SHOT_4" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 1, 10, 22, 20, 2500, false
		elseif what == "PRO_SHOT_5" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 4, 11, 6, 10, 2500, false
		elseif what == "PRO_SHOT_6" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = 10, 0.1, 9, 1, 2500, false
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == 1 then
			nearBlurEnd = math.min(nearBlurEnd + 0.1, 99)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == -1 then
			nearBlurEnd = math.max(nearBlurEnd - 0.1, 0.1)
		elseif what == "PRO_SHOT_58" and axisComponent == 1 then
			farBlurStart = math.ceil(math.min(farBlurStart + math.clamp(farBlurStart / 100, 1, 50), 2000))
			if farBlurStart >= farBlurEnd then
				-- Keep the one-unit transition by pushing the full-blur point away.
				farBlurEnd = math.min(farBlurStart + 1, 2500)
			end
		elseif what == "PRO_SHOT_58" and axisComponent == -1 then
			farBlurStart = math.floor(math.max(farBlurStart - math.clamp(farBlurStart / 100, 1, 50), 1))
		elseif what == "PRO_SHOT_69" and axisComponent == 1 then
			farBlurEnd = math.ceil(math.min(farBlurEnd + math.clamp(farBlurEnd / 100, 1, 50), 2500))
		elseif what == "PRO_SHOT_69" and axisComponent == -1 then
			farBlurEnd = math.floor(math.max(farBlurEnd - math.clamp(farBlurEnd / 100, 1, 50), 2))
			if farBlurEnd <= farBlurStart then
				-- Likewise, lowering full blur pulls the start point towards camera.
				farBlurStart = math.max(farBlurEnd - 1, 1)
			end
		elseif what == "PRO_SHOT_47" and axisComponent == 1 then
			farCoCRadius = math.min(farCoCRadius + 0.1, 20)
		elseif what == "PRO_SHOT_47" and axisComponent == -1 then
			farCoCRadius = math.max(farCoCRadius - 0.1, 0)
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent == 1 then
			nearCoCRadius = math.min(nearCoCRadius + 0.1, 10)
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent == -1 then
			nearCoCRadius = math.max(nearCoCRadius - 0.1, 0.1)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = unpack(proShot.fromWhenceYouCame.DoF)
		elseif what == "PRO_SHOT_KP_0" and axisComponent == 1 then
			applyToSky =  not applyToSky
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end

		proShot:setDoFState({ nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky })
	end
end

function proShot:callbackMenu_effects(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot <= proShot.EFFECT_SLOT_COUNT and axisComponent == 1 then
			proShot:applyEffectSlot(slot, true)
		elseif what == "PRO_SHOT_47" and axisComponent == 1 then
			setBloomMaskThreshold(math.min(getBloomMaskThreshold() + 0.1, 50))
		elseif what == "PRO_SHOT_47" and axisComponent == -1 then
			setBloomMaskThreshold(math.max(getBloomMaskThreshold() - 0.1, 0.1))
		elseif what == "PRO_SHOT_58" and axisComponent == 1 then
			setBloomMagnitude(math.min(getBloomMagnitude() + math.clamp(getBloomMagnitude() / 100, 0.1, 10), 900))
		elseif what == "PRO_SHOT_58" and axisComponent == -1 then
			setBloomMagnitude(math.max(getBloomMagnitude() - math.clamp(getBloomMagnitude() / 100, 0.1, 10), 0.1))
		elseif what == "PRO_SHOT_69" and axisComponent == 1 then
			setBloomQuality(math.min(getBloomQuality() + 1, 5))
		elseif what == "PRO_SHOT_69" and axisComponent == -1 then
			-- Bloom quality is a discrete engine level, so adjust it in whole steps.
			setBloomQuality(math.max(math.floor(getBloomQuality() + 0.5) - 1, 0))

		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == 1 then
			setSSAOQuality(math.min(getSSAOQuality() + 1, 4))
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == -1 then
			setSSAOQuality(math.max(getSSAOQuality() - 1, 1))
		elseif what == "PRO_SHOT_EQUALS" and axisComponent == 1 then
			if proShot.effectEditorState == nil then
				proShot.effectEditorState = proShot:captureCurrentEffectState()
				proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
				proShot.effectEditorBaselineSelection = nil
			end
			proShot.menuDesired = "effectsCustomise"

		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:colorGradingSet()
			local fwyc = proShot.fromWhenceYouCame
			setBloomMagnitude(fwyc.bloom[1])
			setBloomMaskThreshold(fwyc.bloom[2])
			setBloomQuality(fwyc.bloom[3])
			setSSAOQuality(fwyc.SSAOQuality)
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_effectsCustomise(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local groupIndex = tonumber(string.match(tostring(what), "PRO_SHOT_([1-4])$"))
		if groupIndex ~= nil and axisComponent == 1 then
			proShot.effectEditorGroup = proShot.EFFECT_GROUPS[groupIndex]
			proShot.menuDesired = "effectGroup"
		elseif (what == "PRO_SHOT_47" or what == "PRO_SHOT_58") and axisComponent ~= 0 then
			local state = proShot.effectEditorState
			local key = what == "PRO_SHOT_47" and "shadowsMaxLuminance" or "highlightsMinLuminance"
			state[key] = math.clamp(state[key] + axisComponent * 0.01, 0, 1)
			if key == "shadowsMaxLuminance" and state[key] >= state.highlightsMinLuminance then
				state.highlightsMinLuminance = math.min(state[key] + 0.01, 1)
				state[key] = math.min(state[key], state.highlightsMinLuminance - 0.01)
			elseif key == "highlightsMinLuminance" and state[key] <= state.shadowsMaxLuminance then
				state.shadowsMaxLuminance = math.max(state[key] - 0.01, 0)
				state[key] = math.max(state[key], state.shadowsMaxLuminance + 0.01)
			end
			proShot:applyEffectEditorState(true)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			local defaults = proShot.effectEditorBaselineState or proShot:createDefaultEffectState()
			proShot.effectEditorState.shadowsMaxLuminance = defaults.shadowsMaxLuminance
			proShot.effectEditorState.highlightsMinLuminance = defaults.highlightsMinLuminance
			if proShot:effectStatesEqual(proShot.effectEditorState, proShot.effectEditorBaselineState) then
				-- If thresholds were the only edits, restore the source grade itself.
				-- This is exact even while FS25 is blending day/night grading files.
				local selection = proShot.effectEditorBaselineSelection
				if selection == nil or (selection <= proShot.EFFECT_BUILTIN_SLOT_COUNT and proShot.effectSlots[selection] == nil) then
					proShot:colorGradingSet(selection)
				else
					-- A named custom slot also stores Bloom/SSAO. Restore only its
					-- grading here so a luminance reset cannot change those effects.
					proShot.effectEditorState = proShot:cloneEffectState(proShot.effectEditorBaselineState)
					proShot:applyEffectEditorState(false)
					proShot.colourGradingSelection = selection
					proShot.effectEditorDirty = false
				end
			else
				proShot:applyEffectEditorState(true)
			end
		elseif what == "PRO_SHOT_MINUS" and axisComponent == 1 then
			if proShot:buildEffectResetMenu() then
				proShot.menuDesired = "effectResetSlot"
			else
				proShot:showToast(g_i18n:getText("proShot_effect_allSlotsDefault"))
			end
		elseif what == "PRO_SHOT_EQUALS" and axisComponent == 1 then
			proShot.menuDesired = "effectSaveSlot"
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "effects"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_effectGroup(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local propertyIndex = tonumber(string.match(tostring(what), "PRO_SHOT_([1-4])$"))
		if propertyIndex ~= nil and axisComponent == 1 then
			proShot.effectEditorProperty = proShot.EFFECT_PROPERTIES[propertyIndex]
			local value = proShot.effectEditorState[proShot.effectEditorGroup][proShot.effectEditorProperty]
			proShot.effectPropertyEntryState = {
				red = value.red,
				green = value.green,
				blue = value.blue,
				scale = value.scale
			}
			proShot.effectPropertyEntryDirty = proShot.effectEditorDirty
			proShot.effectPropertyEntrySelection = proShot.colourGradingSelection
			proShot.menuDesired = "effectValue"
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "effectsCustomise"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_effectValue(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local value = proShot.effectEditorState[proShot.effectEditorGroup][proShot.effectEditorProperty]
		local component
		if what == "PRO_SHOT_47" then
			component = "red"
		elseif what == "PRO_SHOT_58" then
			component = "green"
		elseif what == "PRO_SHOT_69" then
			component = "blue"
		end

		if component ~= nil and axisComponent ~= 0 then
			value[component] = math.clamp(value[component] + axisComponent * 0.05, 0, 20)
			proShot:applyEffectEditorState(true)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
			value.scale = math.clamp(value.scale + axisComponent * 0.1, 0, 20)
			proShot:applyEffectEditorState(true)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			local original = proShot.effectPropertyEntryState
			value.red, value.green, value.blue, value.scale = original.red, original.green, original.blue, original.scale
			proShot:applyEffectEditorState(false)
			proShot.effectEditorDirty = proShot.effectPropertyEntryDirty
			proShot.colourGradingSelection = proShot.effectPropertyEntrySelection
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "effectGroup"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_effectSaveSlot(what, axisComponent)
	if proShot.favouriteDialogOpen then
		return
	end
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot <= proShot.EFFECT_SLOT_COUNT and axisComponent == 1 then
			proShot:showEffectNameDialog(slot)
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "effectsCustomise"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_effectResetSlot(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 40) then
		local slot = proShot:getFavouriteSlotFromAction(what)
		if slot ~= nil and slot <= proShot.EFFECT_SLOT_COUNT and proShot.effectSlots[slot] ~= nil and axisComponent == 1 then
			proShot:resetEffectSlot(slot)
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "effectsCustomise"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_toneMapping(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local field
		if what == "PRO_SHOT_47" then
			field = "slope"
		elseif what == "PRO_SHOT_58" then
			field = "toe"
		elseif what == "PRO_SHOT_69" then
			field = "shoulder"
		elseif what == "PRO_SHOT_KP_MINUSPLUS" then
			field = "blackClip"
		elseif what == "PRO_SHOT_DIVMUL" then
			field = "whiteClip"
		end
		if field ~= nil and axisComponent ~= 0 then
			proShot.toneMappingState[field] = math.clamp(proShot.toneMappingState[field] + axisComponent * 0.01, 0, 1)
			proShot:applyToneMapping(proShot.toneMappingState)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:applyToneMapping(proShot.fromWhenceYouCame.toneMapping)
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_advQuality(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		if what == "PRO_SHOT_47" and axisComponent == -1 then
			setViewDistanceCoeff(math.max(getViewDistanceCoeff() - 1, 1e-06))
		elseif what == "PRO_SHOT_47" and axisComponent == 1 then
			setViewDistanceCoeff(math.min(getViewDistanceCoeff() + 1, 10))
		elseif what == "PRO_SHOT_58" and axisComponent == -1 then
			setLODDistanceCoeff(math.max(getLODDistanceCoeff() - 1, 1e-06))
		elseif what == "PRO_SHOT_58" and axisComponent == 1 then
			setLODDistanceCoeff(math.min(getLODDistanceCoeff() + 1, 10))
		elseif what == "PRO_SHOT_69" and axisComponent == -1 then
			setTerrainLODDistanceCoeff(math.max(getTerrainLODDistanceCoeff() - 1, 1e-06))
		elseif what == "PRO_SHOT_69" and axisComponent == 1 then
			setTerrainLODDistanceCoeff(math.min(getTerrainLODDistanceCoeff() + 1, 10))
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == -1 then
			setFoliageViewDistanceCoeff(math.max(getFoliageViewDistanceCoeff() - 0.5, 1e-06))
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent == 1 then
			setFoliageViewDistanceCoeff(math.min(getFoliageViewDistanceCoeff() + 0.5, 5))
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
		proShot:updateMainDynamicText()
	end
end

function proShot:resetSkyBrightness()
	proShot.skyState = table.clone(proShot.fromWhenceYouCame.skyState)
	proShot:applySkyState()
end

function proShot:resetGroundLight()
	local original = proShot.fromWhenceYouCame.sun
	setRotation(proShot.sun.lightNode, original.xR, original.yR, original.zR)
	setLightColor(proShot.sun.lightNode, unpack(original.color))
	proShot.sun.intensity = original.intensity
	proShot.sun.colourTemp = original.colourTemp
	proShot.sun.colourTempIsPreset = original.colourTempIsPreset
end

function proShot:callbackMenu_sun(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		if what == "PRO_SHOT_1" then
			proShot.menuDesired = "skyBrightness"
		elseif what == "PRO_SHOT_2" then
			proShot.menuDesired = "groundLight"
		elseif what == "PRO_SHOT_3" then
			proShot:refreshSkyAndGroundMenu()
			proShot.menuDesired = "skyAndGround"
		elseif what == "PRO_SHOT_DOT3" and axisComponent == 1 then
			setMoonSizeScale(proShot:clampMoonSizeScale(getMoonSizeScale() - math.max(getMoonSizeScale() / 100, 0.01)))
		elseif what == "PRO_SHOT_DOT3" and axisComponent == -1 then
			setMoonSizeScale(math.min(getMoonSizeScale() +  math.max(getMoonSizeScale() / 100, 0.01), 224))
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent == 1 then
			setAtmosphereCornetteShankAsymmetryFactor(math.min(getAtmosphereCornetteShankAsymmetryFactor() + 0.01, 0.8))
		elseif what == "PRO_SHOT_MINUSEQUALS" and axisComponent == -1 then
			setAtmosphereCornetteShankAsymmetryFactor(math.max(getAtmosphereCornetteShankAsymmetryFactor() - 0.01, 0))

		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == 1 then
			setSunSizeScale(proShot:clampSunSizeScale(getSunSizeScale() - math.max(getSunSizeScale() / 100, 0.01)))
		elseif what == "PRO_SHOT_SQUAREBRACKETS" and axisComponent == -1 then
			setSunSizeScale(math.min(getSunSizeScale() + math.max(getSunSizeScale() / 100, 0.01), 2200000))
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			local fwyc = proShot.fromWhenceYouCame
			proShot:resetSkyBrightness()
			proShot:resetGroundLight()
			setSunSizeScale(proShot:clampSunSizeScale(fwyc.sunSizeScale))
			setAtmosphereCornetteShankAsymmetryFactor(math.clamp(fwyc.atmosRefraction, 0, 0.8))
			setMoonSizeScale(proShot:clampMoonSizeScale(fwyc.moonSizeScale))
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_skyBrightness(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local component = what == "PRO_SHOT_47" and "red" or (what == "PRO_SHOT_58" and "green" or (what == "PRO_SHOT_69" and "blue" or nil))
		if component ~= nil and axisComponent ~= 0 then
			proShot.skyState[component] = math.clamp(proShot.skyState[component] + axisComponent * 0.05, 0, proShot.MAX_SKY_GROUND_RGB)
			proShot.skyState.colourTempIsPreset = false
			proShot:applySkyState()
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
			proShot:changeSkyColourTemperature(axisComponent)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
			proShot:changeSkyIntensity(axisComponent)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:resetSkyBrightness()
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "sun"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_groundLight(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		if what == "PRO_SHOT_47" and axisComponent ~= 0 then
			proShot:lightColourChange({axisComponent * 0.05, 0, 0}, proShot.sun, proShot.MAX_SKY_GROUND_RGB)
		elseif what == "PRO_SHOT_58" and axisComponent ~= 0 then
			proShot:lightColourChange({0, axisComponent * 0.05, 0}, proShot.sun, proShot.MAX_SKY_GROUND_RGB)
		elseif what == "PRO_SHOT_69" and axisComponent ~= 0 then
			proShot:lightColourChange({0, 0, axisComponent * 0.05}, proShot.sun, proShot.MAX_SKY_GROUND_RGB)
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
			proShot:changeGroundLightColourTemperature(axisComponent)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
			proShot:changeGroundLightIntensity(axisComponent)
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:resetGroundLight()
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "sun"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
	end
end

function proShot:callbackMenu_skyAndGround(what, axisComponent)
	if proShot:keyRepeatThrottle(false, what, axisComponent, 30) then
		local wasSynced = proShot:areSkyAndGroundInSync()
		local component = what == "PRO_SHOT_47" and "red" or (what == "PRO_SHOT_58" and "green" or (what == "PRO_SHOT_69" and "blue" or nil))
		if component ~= nil and axisComponent ~= 0 then
			proShot.skyState[component] = math.clamp(proShot.skyState[component] + axisComponent * 0.05, 0, proShot.MAX_SKY_GROUND_RGB)
			proShot.skyState.colourTempIsPreset = false
			local change = { 0, 0, 0 }
			local componentIndex = component == "red" and 1 or (component == "green" and 2 or 3)
			change[componentIndex] = axisComponent * 0.05
			proShot:lightColourChange(change, proShot.sun, proShot.MAX_SKY_GROUND_RGB)
			proShot:applySkyState()
		elseif what == "PRO_SHOT_DIVMUL" and axisComponent ~= 0 then
			proShot:changeLinkedLightingTemperature(axisComponent)
		elseif what == "PRO_SHOT_KP_MINUSPLUS" and axisComponent ~= 0 then
			proShot:changeLinkedLightingIntensity(axisComponent)
		elseif what == "PRO_SHOT_KP_0" and axisComponent == 1 then
			proShot:syncSkyToGround()
		elseif what == "PRO_SHOT_BACKSLASH" and axisComponent == 1 then
			proShot:resetSkyBrightness()
			proShot:resetGroundLight()
		elseif what == "PRO_SHOT_BACKSPACE" then
			proShot.menuDesired = "sun"
		else
			Logging.info("Unknown menuCallback: " .. tostring(what))
		end
		if wasSynced ~= proShot:areSkyAndGroundInSync() then
			proShot:refreshSkyAndGroundMenu()
		end
	end
end

function proShot:callbackMenu_void(what)
end

function proShot:incrementCaptureTimestamp(timestamp)
	local year, month, day, hour, minute, second = string.match(
		tostring(timestamp), "^(%d%d%d%d)%-(%d%d)%-(%d%d)_(%d%d)%-(%d%d)%-(%d%d)$")
	year, month, day = tonumber(year), tonumber(month), tonumber(day)
	hour, minute, second = tonumber(hour), tonumber(minute), tonumber(second)
	if year == nil or month == nil or day == nil or hour == nil or minute == nil or second == nil then
		return getDate("%Y-%m-%d_%H-%M-%S")
	end

	second = second + 1
	if second >= 60 then
		second = 0
		minute = minute + 1
	end
	if minute >= 60 then
		minute = 0
		hour = hour + 1
	end
	if hour >= 24 then
		hour = 0
		day = day + 1
	end

	local leapYear = year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
	local daysInMonth = { 31, leapYear and 29 or 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
	if day > daysInMonth[month] then
		day = 1
		month = month + 1
	end
	if month > 12 then
		month = 1
		year = year + 1
	end

	return string.format("%04d-%02d-%02d_%02d-%02d-%02d", year, month, day, hour, minute, second)
end

function proShot:allocateCaptureTimestamp()
	local currentTimestamp = getDate("%Y-%m-%d_%H-%M-%S")
	if proShot.lastCaptureTimestamp ~= nil and currentTimestamp <= proShot.lastCaptureTimestamp then
		currentTimestamp = proShot:incrementCaptureTimestamp(proShot.lastCaptureTimestamp)
	end
	proShot.lastCaptureTimestamp = currentTimestamp
	return currentTimestamp
end

function proShot:processCaptureQueue()
	if proShot.captureCoolDown > 0 or proShot.captureQueue == nil or #proShot.captureQueue == 0 then
		return false
	end

	local captureMode = table.remove(proShot.captureQueue, 1)
	proShot.captureMode = captureMode
	proShot.captureTimestamp = proShot:allocateCaptureTimestamp()
	if proShot:getHudVisible() then
		proShot.reEnableHUD = true
		proShot:setHudVisible(false, false)
	end

	if captureMode == "png" then
		-- saveScreenshot is the established lightweight path and remains delayed
		-- until the pause HUD has completed several hidden frames.
		proShot.captureCoolDown = 40
	else
		-- renderScreenshot performs a complete render of its own, so HDR captures
		-- can run as soon as their queued press reaches the front of the pipeline.
		proShot.captureCoolDown = 24
		proShot:captureScreen()
	end
	return true
end

function proShot:callbackMenu_capture(what, axisComponent)
	proShot.captureActionHeld = proShot.captureActionHeld or {}
	if axisComponent ~= 1 then
		-- Removing and rebuilding pause-menu actions emits synthetic key-up events.
		-- They must not re-arm capture while the physical key is still being held.
		if not proShot.menuRebuilding then
			proShot.captureActionHeld[what] = nil
		end
		return
	end
	if proShot.favouriteDialogOpen or proShot.captureKeyReleaseRequired then
		return
	end

	local captureMode
	if what == "PRO_SHOT_HDR_CAPTURE" then
		captureMode = "hdr"
	elseif what == "PRO_SHOT_HDR_DEPTH_CAPTURE" then
		captureMode = "hdrDepth"
	elseif what == "PRO_SHOT_ENTER" then
		-- A plain Enter action can coexist with the two modifier chords. Ignore
		-- it defensively if an input configuration reports both events, but latch
		-- this press so releasing Ctrl while Enter remains down cannot create a PNG.
		if Input.isKeyPressed(Input.KEY_lctrl) or Input.isKeyPressed(Input.KEY_rctrl) then
			proShot.captureActionHeld[what] = true
			return
		end
		captureMode = "png"
	end

	if captureMode ~= nil and not proShot.captureActionHeld[what] then
		-- Action events may repeat while a key remains down. Re-arm only when the
		-- corresponding release event arrives, so every queued image is one press.
		proShot.captureActionHeld[what] = true
		proShot.captureQueue = proShot.captureQueue or {}
		table.insert(proShot.captureQueue, captureMode)
		proShot:processCaptureQueue()
	end
end

function proShot:keyRepeatThrottle(isTick, action, axis, lockoutTime)
	if isTick then
		-- Decrease/remove all counters
		for k, v in pairs(proShot.keyLockout) do
			if v.lockoutTime < -10 then
				proShot.keyLockout[k] = nil
			else
				proShot.keyLockout[k].lockoutTime = v.lockoutTime - 1
			end
		end
	else

		-- Locking checking
		if axis == 0 then
			-- keyUp event (Clear any locks, unless we're rebuilding the menu... then it's false keyUps)
			if not proShot.menuRebuilding then
				proShot.keyLockout[action] = nil
			end
			return false
		else
			-- keyDown event
			if proShot.keyLockout[action] == nil then
				-- No lockout present, so let it through, but add new lockout
				proShot.keyLockout[action] = {}
				proShot.keyLockout[action].lockoutTime = lockoutTime
				proShot:disarmFlashlightReset(action)
				return true
			else
				if proShot.keyLockout[action].lockoutTime < 1 then
					-- Recent lockout was present
					if proShot.keyLockout[action].repeats then
						-- 2nd+ repeat
						proShot.keyLockout[action].repeats = proShot.keyLockout[action].repeats + 1
						proShot.keyLockout[action].lockoutTime = lockoutTime / proShot.keyLockout[action].repeats
						proShot:disarmFlashlightReset(action)
						return true
					else
						-- First repeat
						proShot.keyLockout[action].repeats = 1
						proShot.keyLockout[action].lockoutTime = lockoutTime / 2
						proShot:disarmFlashlightReset(action)
						return true
					end
				else
					-- Lockout is active
					return false
				end
			end
		end
	end
end

function proShot:keyPressOnce(action, axis)
	if axis == 0 then
		if not proShot.menuRebuilding then
			proShot.keyLockout[action] = nil
		end
		return false
	end
	if proShot.keyLockout[action] ~= nil then
		return false
	end
	-- An infinite counter is intentionally never converted into key-repeat by
	-- keyRepeatThrottle's per-frame tick; releasing the physical key clears it.
	proShot.keyLockout[action] = { lockoutTime = math.huge }
	proShot:disarmFlashlightReset(action)
	return true
end


function proShot:colourTempToRGB(kelvin, intensity)
-- Based on: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
	local r, g, b
	local temp = kelvin / 100
	if temp <= 66 then
		r = 255
		g = math.clamp(99.4708025861 * math.log(temp) - 161.1195681661, 0, 255)
	else
		r = math.clamp(329.698727446 * math.pow(temp - 60, -0.1332047592), 0, 255)
		g = math.clamp(288.1221695283 * ((temp - 60) ^ -0.0755148492), 0, 255)
	end

	if temp >= 66 then
		b = 255
	else
		if temp <= 19 then
			b = 0
		else
			b = temp - 10
			b = math.clamp(138.5177312231 * math.log(b) - 305.0447927307, 0, 255)
		end
	end

	return (r / 255) * intensity, (g / 255) * intensity, (b / 255) * intensity
end

function proShot:lightColourChange(change, light, maxComponent)
	local r, g, b = getLightColor(light.lightNode)
	if light.intensity ~= 0 then
		r, g, b = r / light.intensity, g / light.intensity, b / light.intensity
	end
	local limit = maxComponent or 1
	r, g, b = math.clamp((r + change[1]), 0, limit) * light.intensity, math.clamp((g + change[2]), 0, limit) * light.intensity, math.clamp((b + change[3]), 0, limit) * light.intensity
	setLightColor(light.lightNode, r, g, b)
	light.colourTempIsPreset = false
end

function proShot:lightIntensityChange(change, light, maxIntensity)
	local r, g, b = getLightColor(light.lightNode)
	if light.intensity ~= 0 then -- just in case
		r, g, b = r / light.intensity, g / light.intensity, b / light.intensity
	end
	light.intensity = math.clamp(light.intensity + change, 0.0001, maxIntensity or 20) -- Don't let it get to 0... or it 0s the rgb
	setLightColor(light.lightNode, r * light.intensity, g * light.intensity, b * light.intensity)
end

function proShot:getDefaultFlashLightSettings()
	local r, g, b = proShot:colourTempToRGB(6600, 1)
	return {
		intensity = 1,
		range = 20,
		coneAngle = 60,
		dropOff = 3,
		colourTemp = 6600,
		colourTempIsPreset = true,
		red = r,
		green = g,
		blue = b
	}
end

function proShot:isHeldLightLoaded()
	local light = proShot.heldLight
	return light ~= nil and light.lightNode ~= nil and light.lightNode ~= 0
		and entityExists(light.lightNode)
		and proShot.lightLibrary ~= nil and proShot.lightLibrary ~= 0
		and entityExists(proShot.lightLibrary)
end

function proShot:isHeldLightVisible()
	return proShot:isHeldLightLoaded() and getVisibility(proShot.heldLight.lightNode)
end

function proShot:ensureHeldLightLoaded()
	if proShot:isHeldLightLoaded() then
		return true
	end
	local light = proShot.heldLight
	if light == nil or proShot.tripod == nil or proShot.tripod == 0
		or not entityExists(proShot.tripod) or g_i3DManager == nil then
		return false
	end

	local lightLibrary = g_i3DManager:loadI3DFile(proShot.lightI3D, false, false)
	local coneAngle = math.clamp(light.coneAngle or 60, 30, 120)
	local dropOff = math.clamp(light.dropOff or 3, 0, 5)
	local variation = math.floor(((coneAngle - 30) / 10) + dropOff * 10 + 0.5)
	local lightNode = lightLibrary ~= nil and lightLibrary ~= 0
		and getChildAt(lightLibrary, variation) or 0
	if lightLibrary == nil or lightLibrary == 0 or lightNode == nil or lightNode == 0 then
		if lightLibrary ~= nil and lightLibrary ~= 0 and entityExists(lightLibrary) then
			delete(lightLibrary)
		end
		Logging.error("ProShot: Failed to load the bundled flashlight scene")
		proShot:showToast(g_i18n:getText("proShot_testing_actionUnavailable"))
		return false
	end

	proShot.lightLibrary = lightLibrary
	light.lightNode = lightNode
	light.variation = variation
	light.coneAngle = coneAngle
	light.dropOff = dropOff
	link(proShot.tripod, lightNode)
	local colour = light.colour or { 1, 1, 1 }
	setLightColor(lightNode, colour[1] or 1, colour[2] or 1, colour[3] or 1)
	setLightRange(lightNode, light.range or 20)
	setVisibility(lightNode, light.isVisible == true)
	return true
end

function proShot:captureHeldLightSettings()
	local light = proShot.heldLight
	local colour = light ~= nil and light.colour or nil
	local r, g, b = 1, 1, 1
	if proShot:isHeldLightLoaded() then
		r, g, b = getLightColor(light.lightNode)
	elseif colour ~= nil then
		r, g, b = colour[1] or 1, colour[2] or 1, colour[3] or 1
	end
	return {
		intensity = light ~= nil and light.intensity or 1,
		range = light ~= nil and light.range or 20,
		coneAngle = light ~= nil and light.coneAngle or 60,
		dropOff = light ~= nil and light.dropOff or 3,
		colourTemp = light ~= nil and light.colourTemp or 6600,
		colourTempIsPreset = light == nil or light.colourTempIsPreset ~= false,
		red = r,
		green = g,
		blue = b
	}
end


function proShot:applyHeldLightSettings(settings, isVisible)
	local light = proShot.heldLight
	if light == nil or settings == nil then
		return false
	end
	local wasLoaded = proShot:isHeldLightLoaded()
	isVisible = Utils.getNoNil(isVisible, wasLoaded and getVisibility(light.lightNode)
		or light.isVisible == true)
	light.isVisible = isVisible
	light.intensity = settings.intensity
	light.range = settings.range
	light.coneAngle = settings.coneAngle
	light.dropOff = settings.dropOff
	light.colourTemp = settings.colourTemp
	light.colourTempIsPreset = settings.colourTempIsPreset
	light.colour = { settings.red, settings.green, settings.blue }
	if not wasLoaded then
		if not isVisible then
			return true
		end
		if not proShot:ensureHeldLightLoaded() then
			light.isVisible = false
			return false
		end
	else
		proShot:lightFauxSet(settings.coneAngle, settings.dropOff)
	end

	light = proShot.heldLight
	setLightColor(light.lightNode, settings.red, settings.green, settings.blue)
	setLightRange(light.lightNode, light.range)
	setVisibility(light.lightNode, isVisible)
	light.isVisible = isVisible
	return true
end

function proShot:updateFlashLightEnterText()
	local isVisible = proShot:isHeldLightVisible()
	local text = g_i18n:getText(isVisible and "proShot_menu_flashLight_place" or "proShot_menu_flashLight_turnOn")
	proShot.dynamicMenuNames.flashLightEnter = text
	for _, action in ipairs({ "PRO_SHOT_ENTER", "PRO_SHOT_KP_ENTER" }) do
		local eventId = proShot.buttonId[action]
		if eventId ~= nil then
			g_inputBinding:setActionEventText(eventId, text)
		end
	end
end

function proShot:enterFlashLightMenu()
	if not proShot:ensureHeldLightLoaded() then
		proShot.menuDesired = "main"
		return false
	end
	local isVisible = proShot:isHeldLightVisible()
	proShot:applyHeldLightSettings(proShot.flashLightMenuSettings or proShot:getDefaultFlashLightSettings(), isVisible)
	proShot:updateFlashLightEnterText()
	return true
end

function proShot:isFlashLightMenu(menu)
	return menu == "flashLight" or menu == "flashlightFavouriteSaveSlot"
		or menu == "flashlightFavouriteDeleteSlot"
end

function proShot:leaveFlashLightMenu()
	local isVisible = proShot:isHeldLightVisible()
	proShot.flashLightMenuSettings = proShot:captureHeldLightSettings()
	-- Outside the editor, the movable/unplaced light is always the predictable
	-- default flashlight. Placed lights retain the settings they were given.
	proShot:applyHeldLightSettings(proShot:getDefaultFlashLightSettings(), isVisible)
end

function proShot:toggleFlashLight()
	if not proShot:ensureHeldLightLoaded() then
		return false
	end
	local heldLight = proShot.heldLight
	local light = heldLight.lightNode

	if getVisibility(light) then
		setVisibility(light, false)
		heldLight.isVisible = false
	else
		if proShot.menuDesired ~= "flashLight" then
			proShot:applyHeldLightSettings(proShot:getDefaultFlashLightSettings(), false)
			heldLight = proShot.heldLight
			light = heldLight.lightNode
		end
		setVisibility(light, true)
		heldLight.isVisible = true
	end
	proShot:updateFlashLightEnterText()
	return true
end

function proShot:clearPlacedLights()
	for index = #proShot.placedLights, 1, -1 do
		local lightNode = proShot.placedLights[index]
		if lightNode ~= nil and lightNode ~= 0 and entityExists(lightNode) then
			delete(lightNode)
		end
		table.remove(proShot.placedLights, index)
	end
end

function proShot:disarmFlashlightReset(action)
	if proShot.resetFlashlightsArmed
		and not (proShot.menuDesired == "main" and action == "PRO_SHOT_BACKSLASH") then
		proShot.resetFlashlightsArmed = false
		proShot.resetFlashlightsReleaseRequired = false
		proShot:refreshMainMenu()
	end
end

function proShot:lightPlace(light)
	if getVisibility(light.lightNode) then
		local r, g, b = getLightColor(light.lightNode)
		local xR, yR, zR = getWorldRotation(light.lightNode)
		local xT, yT, zT = getWorldTranslation(light.lightNode)
		table.insert(proShot.placedLights, light.lightNode)
		link(proShot.lightStand, light.lightNode) -- Place the light on the stand
		-- Restore world coords
		setWorldRotation(light.lightNode, xR, yR, zR)
		setWorldTranslation(light.lightNode, xT, yT, zT)
		-- Rebuild the library, since it's missing a light now
		delete(proShot.lightLibrary)
		proShot.lightLibrary = g_i3DManager:loadI3DFile(proShot.lightI3D, false, false)
		-- Grab a new light, same as the old one
		light.lightNode = getChildAt(proShot.lightLibrary, light.variation)
		link(proShot.tripod, light.lightNode)
		-- Set new light to same settings as before
		setWorldRotation(light.lightNode, xR, yR, zR)
		setWorldTranslation(light.lightNode, xT, yT, zT)
		setLightColor(light.lightNode, r, g, b)
		setLightRange(light.lightNode, light.range)
		setVisibility(light.lightNode, false) -- Turn off the new light
		light.isVisible = false
		return true
	else
		-- Just set the light visible and don't drop an invisible light (or one the player hasn't seen)
		setVisibility(light.lightNode, true)
		light.isVisible = true
		return false
	end
end

function proShot:lightFauxSet(coneAngle, dropOff) -- coneAngle must be in multiples of 10
	local light = proShot.heldLight
	local r, g, b = getLightColor(light.lightNode)
	coneAngle = math.clamp(coneAngle, 30, 120)
	dropOff = math.clamp(dropOff, 0, 5)
	link(proShot.lightLibrary, light.lightNode, light.variation) -- Return the light to the librarian
	light.variation = ((coneAngle - 30) / 10) + (dropOff * 10) --  Calculate the light we'd like to check out
	light.lightNode = getChildAt(proShot.lightLibrary, light.variation)
	link(proShot.tripod, light.lightNode) -- Borrow the light
	-- Store changed values
	light.coneAngle = coneAngle
	light.dropOff = dropOff
	-- Apply previous settings to new light
	setVisibility(light.lightNode, light.isVisible)
	setLightColor(light.lightNode, r, g, b)
	setLightRange(light.lightNode, light.range)
	proShot:lightIntensityChange(0, light)
end

function proShot:setColorGradingFilename(filename)
	local mission = g_currentMission
	local env = mission ~= nil and mission.environment or nil
	if env == nil or env.xmlFilename == nil or filename == nil then
		Logging.error("ProShot: Colour grading is unavailable in the current mission state")
		return false
	end
	local xmlFile = XMLFile.load("Environment", env.xmlFilename)
	if xmlFile == nil then
		Logging.error("ProShot: Could not load environment lighting from '%s'", tostring(env.xmlFilename))
		return false
	end

	local lighting = Lighting.new()
	lighting:load(xmlFile, "environment.lighting", mission.baseDirectory)
	xmlFile:delete()

	-- FS25 replaced colorGradingDay/Night with a time-based file curve.
	lighting.colorGradingData = {
		{ 0, filename },
		{ 24, filename }
	}
	lighting:updateCurves()
	env:setCustomLighting(lighting)
	proShot.customLighting = lighting
	return true
end

function proShot:colorGradingSet(selection)
	local env = g_currentMission.environment
	local fwyc = proShot.fromWhenceYouCame

	if selection == nil then
		-- Restore the exact lighting object that was active before ProShot. This
		-- also preserves map- or mod-specific FS25 lighting curves.
		env:setCustomLighting(fwyc.lighting == env.baseLighting and nil or fwyc.lighting)
		proShot.customLighting = nil
		proShot.colourGradingSelection = nil
		proShot.effectEditorState = proShot:captureCurrentEffectState(env.lighting, env.dayTime)
		proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
		proShot.effectEditorBaselineSelection = nil
		proShot.effectEditorDirty = false
		return
	end

	local custom = proShot.effectSlots[selection]
	if custom ~= nil then
		proShot.effectEditorState = proShot:cloneEffectState(custom.state)
		if not proShot:applyEffectEditorState(false) then
			return
		end
		-- Custom effect slots include the post-effect settings that were active
		-- when the colour grading was saved. Apply each field independently so an
		-- incomplete settings file cannot blank unrelated render values.
		if custom.bloomMagnitude ~= nil then
			setBloomMagnitude(math.clamp(custom.bloomMagnitude, 0.1, 900))
		end
		if custom.bloomThreshold ~= nil then
			setBloomMaskThreshold(math.clamp(custom.bloomThreshold, 0.1, 50))
		end
		if custom.bloomQuality ~= nil then
			setBloomQuality(math.clamp(custom.bloomQuality, 0, 5))
		end
		if custom.ssaoQuality ~= nil then
			setSSAOQuality(math.clamp(custom.ssaoQuality, 1, 4))
		end
	elseif selection <= proShot.EFFECT_BUILTIN_SLOT_COUNT then
		proShot.effectEditorState = proShot:getBuiltinEffectState(selection)
		local filename = proShot.modDir .. "xml/colorGrading/" .. proShot.EFFECT_BUILTIN_FILES[selection] .. ".xml"
		if not proShot:setColorGradingFilename(filename) then
			return
		end
	else
		return
	end
	proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
	proShot.effectEditorBaselineSelection = selection
	proShot.colourGradingSelection = selection
	proShot.effectEditorDirty = false
end

function proShot:seasonChange(season)
	local cvp = g_currentMission.environment.currentVisualPeriod
	local id = cvp

	if season ~= "init" then
		if season == "tweakUp" then
			proShot.seasonTweak = math.clamp(proShot.seasonTweak + 0.01, -1, 1)
		elseif season =="tweakDown" then
			proShot.seasonTweak = math.clamp(proShot.seasonTweak - 0.01, -1, 1)
		else
			proShot.seasonTweak = 0
			if season == "spring" then
				if cvp == 1 then
					id = 2
				elseif cvp == 2 then
					id = 3
				else
					id = 1
				end
			elseif season == "summer" then
				if cvp == 4 then
					id = 5
				elseif cvp == 5 then
					id = 6
				else
					id = 4
				end
			elseif season == "autumn" then
				if cvp == 7 then
					id = 8
				elseif cvp == 8 then
					id = 9
				else
					id = 7
				end
			elseif season == "winter" then
				if cvp == 10 then
					id = 11
				elseif cvp == 11 then
					id = 12
				else
					id = 10
				end
			end

		end

		-- setFixedPeriod is the FS25 path: it updates the 1-based season, daylight
		-- data, mission setting and weather forecast as one coherent operation.
		g_currentMission.environment:setFixedPeriod(id)

		local periodToShader = { 3.11, 3.33, 3.67, 3.95, 0.6, 0.85, 1.08, 1.42, 1.75, 2, 2.25, 2.65 }
		local shaderParam = periodToShader[id] + proShot.seasonTweak
		if shaderParam > 4 then
			shaderParam = shaderParam - 4
		elseif shaderParam < 0 then
			shaderParam = shaderParam + 4
		end

		g_currentMission.environment:consoleCommandSetSeasonalShader(shaderParam)
		g_currentMission.environment:update(g_currentDt)
		proShot.menuCurrent = "updateTextOnly"
	else
		proShot.menuCurrent = "noneAtAll"
	end

	-- Update dynamic menu
	if id == 3 or id == 6 or id == 9 or id == 12 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 1 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_mid") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 2 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_late") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 4 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_mid") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 5 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_late") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 7 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_mid") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 8 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_late") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_early") .. ")"
	elseif id == 10 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_mid") .. ")"
	elseif id == 11 then
		proShot.dynamicMenuNames.spring = g_i18n:getText("proShot_spring") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.summer = g_i18n:getText("proShot_summer") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.autumn = g_i18n:getText("proShot_autumn") .. " (" .. g_i18n:getText("proShot_early") .. ")"
		proShot.dynamicMenuNames.winter = g_i18n:getText("proShot_winter") .. " (" .. g_i18n:getText("proShot_late") .. ")"
	end
end

function proShot:weatherChange(weatherName, isInit, requestedVariationIndex)
	local env = g_currentMission.environment
	local weather = env.weather
	local currentSeason = env.currentSeason
	local currentWeatherInstance = weather.forecastItems ~= nil and weather.forecastItems[1] or nil
	local variationIndex = 1
	local nextVariationIndex = 2
	local currentWeatherObject

	if currentWeatherInstance ~= nil then
		currentWeatherObject = weather:getWeatherObjectByIndex(currentWeatherInstance.season, currentWeatherInstance.objectIndex)
	end

	if currentWeatherInstance ~= nil and currentWeatherObject ~= nil and weatherName == proShot:getCurrentWeatherName() then
		local numVariations = #currentWeatherObject.variations
		if isInit == true then
			variationIndex = currentWeatherInstance.variationIndex
		else
			variationIndex = currentWeatherInstance.variationIndex + 1
		end
		if variationIndex > numVariations then
			variationIndex = 1
		end
		nextVariationIndex = variationIndex + 1
		if nextVariationIndex > numVariations then
			nextVariationIndex = 1
		end
	end

	if requestedVariationIndex ~= nil then
		variationIndex = math.max(math.floor(requestedVariationIndex), 1)
		nextVariationIndex = variationIndex + 1
	end

	local menuWeatherTypes = {
		SUN = "sunny",
		CLOUDY = "cloudy",
		RAIN = "rainy",
		HAIL = "hail",
		SNOW = "snowy"
	}
	for name, menuKey in pairs(menuWeatherTypes) do
		local displayedVariation = name == weatherName and nextVariationIndex or 1
		proShot.dynamicMenuNames[menuKey] = proShot:getWeatherDisplayName(name) .. " (" .. displayedVariation .. ")"
	end

	if isInit == true then
		return
	end

	proShot.menuCurrent = "updateTextOnly"

	local weatherType = WeatherType.getByName(weatherName)
	if weatherType == nil then
		Logging.warning("ProShot: Unknown FS25 weather type '%s'", tostring(weatherName))
		return
	end

	local seasonWeatherObjects = weather.typeToWeatherObject ~= nil
		and weather.typeToWeatherObject[currentSeason] or nil
	local weatherObject = seasonWeatherObjects ~= nil and seasonWeatherObjects[weatherType] or nil
	if weatherObject == nil then
		-- ProShot intentionally permits precipitation outside its normal season.
		-- FS25 stores those weather objects by season, so borrow the supported
		-- season's definition while keeping the selected visual season unchanged.
		if weatherName == "SNOW" then
			local winterObjects = weather.typeToWeatherObject ~= nil and weather.typeToWeatherObject[Season.WINTER] or nil
			weatherObject = winterObjects ~= nil and winterObjects[weatherType] or nil
			currentSeason = Season.WINTER
		elseif weatherName == "RAIN" then
			local summerObjects = weather.typeToWeatherObject ~= nil and weather.typeToWeatherObject[Season.SUMMER] or nil
			weatherObject = summerObjects ~= nil and summerObjects[weatherType] or nil
			currentSeason = Season.SUMMER
		end
	end
	if weatherObject == nil and weatherName == "HAIL" then
		-- Hail is commonly defined for only spring/summer. Retain the selected
		-- visual season but borrow this map's first available native definition,
		-- just as ProShot already does for rain and snow.
		for _, fallbackSeason in ipairs({ Season.SPRING, Season.SUMMER, Season.AUTUMN, Season.WINTER }) do
			local seasonObjects = weather.typeToWeatherObject ~= nil and weather.typeToWeatherObject[fallbackSeason] or nil
			if seasonObjects ~= nil and seasonObjects[weatherType] ~= nil then
				weatherObject = seasonObjects[weatherType]
				currentSeason = fallbackSeason
				break
			end
		end
	end

	if weatherObject ~= nil then
		weather.forecastItems = {}
		local variation = weatherObject:getVariationByIndex(variationIndex)

		if variation == nil then
			variation = weatherObject:getVariationByIndex(weatherObject:getRandomVariationIndex())
		end
		if variation == nil then
			Logging.warning("ProShot: Weather type '%s' has no usable variation on this map", tostring(weatherName))
			return
		end

		local duration = MathUtil.hoursToMs(math.random(variation.minHours, variation.maxHours))
		local index = 3
		local currentInstance = weather.forecastItems[2]

		if currentInstance == nil then
			currentInstance = weather.forecastItems[1]
			index = 2

			if currentInstance == nil then
				index = 1
			end
		end

		local startDay = weather.owner.currentMonotonicDay
		local startDayTime = weather.owner.dayTime

		if currentInstance ~= nil then
			startDayTime = currentInstance.startDayTime
			startDay = currentInstance.startDay
		end

		startDay, startDayTime = weather.owner:getDayAndDayTime(startDayTime + duration, startDay)
		local instance = WeatherInstance.createInstance(weatherObject.index, variation.index, startDay, startDayTime, duration, currentSeason)

		table.insert(weather.forecastItems, index, instance)
		weather:fillWeatherForecast()

		if currentWeatherObject ~= nil then
			currentWeatherObject:deactivate(1)
			currentWeatherObject:update(9999999)
		end

		weather:init()
		if weatherName == "HAIL" then
			-- Native FS25 hail can modify crop density maps when disaster damage is
			-- enabled. ProShot only wants the photographic precipitation and cloud
			-- effects, so stop this instance's destruction scheduler explicitly;
			-- relying on pause time alone would be unnecessarily risky.
			weatherObject.nextDestructionTime = nil
		end
	else
		Logging.warning("ProShot: Weather type '%s' is unavailable", tostring(weatherName))
	end

	env:update(g_currentDt)
end

function proShot:timeChange(ms)
	local env = g_currentMission.environment

	if ms > 86400000 then
		ms = ms - 86400000
	elseif ms < 0 then
		ms = ms + 86400000
	end

	env:setEnvironmentTime(env.currentMonotonicDay, env.currentDay, ms, env.daysPerPeriod, false)
	env:update(g_currentDt)
end

function proShot:applyPendingSnowAreaHeight()
	local pending = proShot.pendingSnowAreaHeight
	local snowSystem = g_currentMission ~= nil and g_currentMission.snowSystem or nil
	if pending == nil or snowSystem == nil then
		return
	end

	-- Native snow changes are density-map jobs. Wait until they finish so an
	-- above-native photographic height is applied to the resulting snow cells.
	if snowSystem.currentApplyingDelta ~= nil
		or (type(snowSystem.updateQueue) == "table" and #snowSystem.updateQueue > 0) then
		return
	end

	local physicalHeight = pending.height
	if physicalHeight > 0 and snowSystem.layerHeight ~= nil then
		physicalHeight = physicalHeight + snowSystem.layerHeight * 0.001
		if pending.height == proShot.MAX_LOCAL_SNOW_HEIGHT then
			physicalHeight = math.ceil(pending.height / snowSystem.layerHeight)
				* snowSystem.layerHeight + snowSystem.layerHeight * 0.001
		end
	end

	if physicalHeight <= 0 then
		-- Zero does not create fill types; the native helper also clears the snow
		-- fill type from cells whose height reaches zero.
		snowSystem:setSnowHeightAtArea(
			pending.startWorldX, pending.startWorldZ,
			pending.widthWorldX, pending.widthWorldZ,
			pending.heightWorldX, pending.heightWorldZ, 0)
	else
		local heightModifiers = snowSystem.modifiers ~= nil and snowSystem.modifiers.height or nil
		local modifier = heightModifiers ~= nil and heightModifiers.modifierHeight or nil
		local filter = heightModifiers ~= nil and heightModifiers.filterType or nil
		if modifier == nil or filter == nil or snowSystem.layerHeight == nil then
			Logging.warning("ProShot: Cannot extend snow above the native height because the density-map modifiers are unavailable")
			proShot.pendingSnowAreaHeight = nil
			return
		end

		-- Change existing snow only. Unlike SnowSystem:setSnowHeightAtArea, this
		-- deliberately does not turn bare road, indoor or object-mask cells into snow.
		modifier:setParallelogramWorldCoords(
			pending.startWorldX, pending.startWorldZ,
			pending.widthWorldX, pending.widthWorldZ,
			pending.heightWorldX, pending.heightWorldZ,
			DensityCoordType.POINT_POINT_POINT)
		filter:setValueCompareParams(DensityValueCompareType.EQUAL, snowSystem.snowHeightTypeIndex)
		modifier:executeSet(math.floor(physicalHeight / snowSystem.layerHeight), filter)
	end

	proShot:debugLog("applied masked snow area height %.3f", pending.height)
	proShot.pendingSnowAreaHeight = nil
end

function proShot:snowBusiness(height)
	local snowSystem = g_currentMission ~= nil and g_currentMission.snowSystem or nil
	if snowSystem == nil then
		return height == "getHeight" and 0 or false
	end

	if height == "getHeight" then
		if proShot.snowLevel == nil then
			-- FS25's exactHeight is the requested global weather level. Sampling a
			-- terrain square understates it whenever roads or masks correctly contain
			-- no snow, which made an untouched 0.5 m map appear as roughly 0.44 m.
			local nativeHeight = tonumber(snowSystem.exactHeight)
			if nativeHeight == nil and g_currentMission.environment ~= nil
				and g_currentMission.environment.weather ~= nil then
				nativeHeight = tonumber(g_currentMission.environment.weather.snowHeight)
			end
			proShot.snowLevel = math.clamp(nativeHeight or 0, 0, proShot.MAX_LOCAL_SNOW_HEIGHT)
		end
		return proShot.snowLevel
	end

	local requestedHeight = tonumber(height)
	if requestedHeight == nil or proShot.tripod == nil or proShot.tripod == 0
		or not entityExists(proShot.tripod) then
		return false
	end

	local clampedHeight = math.clamp(requestedHeight, 0, proShot.MAX_LOCAL_SNOW_HEIGHT)
	local previousHeight = proShot:snowBusiness("getHeight")
	local nativeHeight = math.min(clampedHeight, SnowSystem.MAX_HEIGHT)
	local actualNativeHeight = tonumber(snowSystem.exactHeight)
	local sameTrackedHeight = math.abs(previousHeight - clampedHeight) < 0.0001
	local sameNativeHeight = actualNativeHeight == nil or math.abs(actualNativeHeight - nativeHeight) < 0.0001
	if sameTrackedHeight and sameNativeHeight and proShot.pendingSnowAreaHeight == nil then
		return false
	end

	local environment = g_currentMission.environment
	if environment ~= nil and environment.weather ~= nil then
		environment.weather.snowHeight = nativeHeight
	end
	-- This is the same native FS25 path used by weather and EasyDevControls. It
	-- respects indoor, road, object and tyre-track masks instead of filling a square.
	snowSystem:setSnowHeight(nativeHeight)

	local x, _, z = getWorldTranslation(proShot.tripod)
	if clampedHeight > SnowSystem.MAX_HEIGHT or previousHeight > SnowSystem.MAX_HEIGHT then
		local radius = 100
		local area = {
			height = clampedHeight,
			startWorldX = x - radius,
			startWorldZ = z - radius,
			widthWorldX = x + radius,
			widthWorldZ = z - radius,
			heightWorldX = x - radius,
			heightWorldZ = z + radius
		}
		if proShot.snowAreaRestore == nil then
			local initialHeight = proShot.fromWhenceYouCame ~= nil
				and proShot.fromWhenceYouCame.snowLevel or nil
			proShot.snowAreaRestore = {
				height = initialHeight or math.min(previousHeight, SnowSystem.MAX_HEIGHT),
				startWorldX = area.startWorldX,
				startWorldZ = area.startWorldZ,
				widthWorldX = area.widthWorldX,
				widthWorldZ = area.widthWorldZ,
				heightWorldX = area.heightWorldX,
				heightWorldZ = area.heightWorldZ
			}
		end
		proShot.pendingSnowAreaHeight = area
	else
		proShot.pendingSnowAreaHeight = nil
	end

	proShot.snowLevel = clampedHeight
	proShot:debugLog("snow changed from %.3f to %.3f (native %.3f)", previousHeight, clampedHeight, nativeHeight)
	return true
end



function proShot:updateControlsMenu()
	if proShot.menuCurrent ~= proShot.menuDesired then
		local currentIsFlashLight = proShot:isFlashLightMenu(proShot.menuCurrent)
		local desiredIsFlashLight = proShot:isFlashLightMenu(proShot.menuDesired)
		if currentIsFlashLight and not desiredIsFlashLight then
			proShot:leaveFlashLightMenu()
		elseif not currentIsFlashLight and desiredIsFlashLight then
			proShot:enterFlashLightMenu()
		end

		-- Remove events only if doing a full rebuild
		if proShot.menuCurrent ~= "updateTextOnly" then
			proShot:removeActionEvents()
		end

		g_inputBinding:beginActionEventsModification(BaseMission.INPUT_CONTEXT_PAUSE)
		local count = 0
		local supportsScreenshotCapture = false

		-- Loop through desired menu items
		for _, item in ipairs(proShot.menus[proShot.menuDesired]) do
			count = count + 1
			if item[1] == "PRO_SHOT_ENTER" and item[2] == "callbackMenu_capture" then
				supportsScreenshotCapture = true
			end
			local eventId = 0
			if proShot.buttonId[item[1]] == nil then -- Add new
				_, eventId = g_inputBinding:registerActionEvent(InputAction[item[1]], self, self[item[2]], true, true, true, true)
				proShot.buttonId[item[1]] = eventId
				g_inputBinding:setActionEventActive(eventId, true)
				g_inputBinding:setActionEventTextPriority(eventId, item[4])
			else
				eventId = proShot.buttonId[item[1]] -- Use existing
			end

			-- Set/update text
			if type(item[3]) == "table" then
				g_inputBinding:setActionEventText(eventId, proShot.dynamicMenuNames[item[3][1]])
			else
				g_inputBinding:setActionEventText(eventId, item[3])
			end
			-- Some physical keys intentionally share one visible action description.
			g_inputBinding:setActionEventTextVisibility(eventId, item[5] ~= false)
		end

		-- These advanced chords remain configurable in the game's key-binding
		-- screen, but deliberately stay out of ProShot's already busy help menu.
		if supportsScreenshotCapture then
			for _, actionName in ipairs({ "PRO_SHOT_HDR_CAPTURE", "PRO_SHOT_HDR_DEPTH_CAPTURE" }) do
				local eventId = proShot.buttonId[actionName]
				if eventId == nil then
					_, eventId = g_inputBinding:registerActionEvent(
						InputAction[actionName], self, self.callbackMenu_capture, true, true, true, true)
					proShot.buttonId[actionName] = eventId
				end
				g_inputBinding:setActionEventActive(eventId, true)
				g_inputBinding:setActionEventTextVisibility(eventId, false)
			end
		end

		if proShot.menuDesired == "main" then
			count = count + 2 -- Display the unpause and menu options, for the main menu only
		end
		-- FS25 replaced ENTRY_COUNT_PC with this configurable normal-priority cap.
		InputHelpDisplay.MAX_NUM_ELEMENTS = math.max(proShot.fromWhenceYouCame.maxInputHelpElements, count)

		g_inputBinding:endActionEventsModification()

		proShot.menuCurrent = proShot.menuDesired
	end
end

function proShot:updateInfoBox()
	if not proShot:getHudVisible() or g_localPlayer == nil then
		return
	end

	local box = g_localPlayer.hudUpdater.fieldBox
	local menu = proShot.menuCurrent
	box.proShotTitleColor = nil
	if menu == "main" then
		local r, g, b = getLightColor(proShot.sun.lightNode)
		if proShot.sun.intensity ~= 0 then
			r, g, b = r / proShot.sun.intensity, g / proShot.sun.intensity, b / proShot.sun.intensity
		end
		local sunK
		if proShot.sun.colourTempIsPreset then
			sunK = proShot.sun.colourTemp .. "K"
		elseif math.floor(r * 100) / 100 == math.floor(g * 100) / 100 and math.floor(g * 100) / 100 == math.floor(b * 100) / 100 then
			sunK = "6600K"
		else
			sunK = g_i18n:getText("info_transmission_manual")
		end
		local sunX, sunY = getRotation(proShot.sun.lightNode)

		box:clear()
		box:setTitle(g_i18n:getText("ui_inGameMenuControls"))
		proShot:addInfoLine(box, g_i18n:getText("button_move"), g_i18n:getText("proShot_infoBox_help1b"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_help2a"), g_i18n:getText("proShot_infoBox_help2b"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_help3a"), g_i18n:getText("proShot_infoBox_help3b"), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_help4a"), g_i18n:getText("proShot_infoBox_help4b"), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("action_rotate"), g_i18n:getText("proShot_infoBox_help5b"), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_help6a"), g_i18n:getText("proShot_infoBox_help6b"), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("input_AXIS_CONSTRUCTION_CAMERA_TILT_1"), g_i18n:getText("proShot_infoBox_help7b"), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_help8a"), g_i18n:getText("proShot_infoBox_help8b"), proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_quality"), proShot:getQualityDisplayName(), proShot.INFO_COLOR.ACTIVE)
		local flashLightVisible = proShot:isHeldLightVisible()
		proShot:addInfoLine(box, g_i18n:getText("storeItem_flashlight"), flashLightVisible and g_i18n:getText("ui_on") or g_i18n:getText("ui_off"), flashLightVisible and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		local skyK = proShot.skyState.colourTempIsPreset and (proShot.skyState.colourTemp .. "K") or g_i18n:getText("info_transmission_manual")
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyTemp"), skyK, proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyIntensity"), string.format("%.2f", proShot.skyState.intensity), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundTemp"), sunK, proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundIntensity"), string.format("%.2f", proShot.sun.intensity), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_sunDirection"), string.format("%.0f / %.0f deg", math.deg(sunX), math.deg(sunY)), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_exposure"), string.format("%+.1f", proShot.exposureMinValue), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_FoV"), tostring(proShot.FoV), proShot.INFO_COLOR.BLUE)
		local focusWidth = proShot.focusAssist ~= nil and ((proShot.focusAssist.effectiveNearWidth or 0) + (proShot.focusAssist.effectiveFarWidth or 0)) or 0
		proShot:addInfoLine(box, g_i18n:getText("proShot_focus_status"), proShot.focusAssist ~= nil and string.format(g_i18n:getText("proShot_focus_distance"), proShot.focusAssist.distance, focusWidth) or g_i18n:getText("ui_off"), proShot.focusAssist ~= nil and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		local gridName = proShot.GRID_AIDS[proShot.gridAidIndex]
		local gridKey = proShot.GRID_AID_TEXT_KEYS[gridName] or ("proShot_grid_" .. gridName)
		proShot:addInfoLine(box, g_i18n:getText("proShot_composition_status"), string.format("%s / %s", g_i18n:getText(gridKey), proShot.ASPECT_AIDS[proShot.aspectAidIndex][1]))
	elseif menu == "advQuality" then
		box:clear()
		box:setTitle(g_i18n:getText("button_currentSettings"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_quality"), proShot:getQualityDisplayName(), proShot.INFO_COLOR.ACTIVE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_VD"), string.format("%.2f", getViewDistanceCoeff()))
		proShot:addInfoLine(box, g_i18n:getText("setting_LODDistance"), string.format("%.2f", getLODDistanceCoeff()))
		proShot:addInfoLine(box, g_i18n:getText("setting_terrainLODDistance"), string.format("%.2f", getTerrainLODDistanceCoeff()))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_FVD"), string.format("%.2f", getFoliageViewDistanceCoeff()))
	elseif menu == "sun" then
		local r, g, b = getLightColor(proShot.sun.lightNode)
		if proShot.sun.intensity ~= 0 then
			r, g, b = r / proShot.sun.intensity, g / proShot.sun.intensity, b / proShot.sun.intensity
		end
		local sunK = proShot.sun.colourTempIsPreset and (proShot.sun.colourTemp .. "K") or g_i18n:getText("info_transmission_manual")
		local sunX, sunY = getRotation(proShot.sun.lightNode)
		local sunScale = math.max(getSunSizeScale(), 0.000001)
		local moonScale = math.max(getMoonSizeScale(), 0.000001)
		local moonSize = math.sqrt(proShot.MOON_SIZE_SCALE_BASE / moonScale)
		if moonSize < 0.7 then
			moonSize = moonSize - (0.7 - moonSize)
		end

		box:clear()
		local sky = proShot.skyState
		local skyK = sky.colourTempIsPreset and (sky.colourTemp .. "K") or g_i18n:getText("info_transmission_manual")
		box:setTitle(g_i18n:getText("proShot_menu_advSunMenu"))
		proShot:addInfoRGBLine(box, g_i18n:getText("proShot_menu_skyBrightness"), sky.red, sky.green, sky.blue, proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyTemp"), skyK, proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyIntensity"), string.format("%.2f", sky.intensity), proShot.INFO_COLOR.BLUE)
		proShot:addInfoRGBLine(box, g_i18n:getText("proShot_menu_groundLight"), r, g, b, proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundTemp"), sunK, proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundIntensity"), string.format("%.2f", proShot.sun.intensity), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_sunDirection"), string.format("%.0f / %.0f deg", math.deg(sunX), math.deg(sunY)), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_atmosRefraction"), string.format("%.2f", getAtmosphereCornetteShankAsymmetryFactor()))
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_sunSize"), string.format("%.2f", math.sqrt(proShot.SUN_SIZE_SCALE_BASE / sunScale)))
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_moonSize"), string.format("%.2f", moonSize))
	elseif menu == "skyBrightness" then
		local sky = proShot.skyState
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_skyBrightness"))
		box.proShotTitleColor = proShot.INFO_COLOR.HIGHLIGHT
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_colourTemperature"), sky.colourTempIsPreset and (sky.colourTemp .. "K") or g_i18n:getText("info_transmission_manual"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_intensity"), string.format("%.2f", sky.intensity))
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), string.format("%.2f", sky.red), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), string.format("%.2f", sky.green), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), string.format("%.2f", sky.blue), proShot.INFO_COLOR.BLUE)
	elseif menu == "groundLight" then
		local r, g, b = getLightColor(proShot.sun.lightNode)
		if proShot.sun.intensity ~= 0 then
			r, g, b = r / proShot.sun.intensity, g / proShot.sun.intensity, b / proShot.sun.intensity
		end
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_groundLight"))
		box.proShotTitleColor = proShot.INFO_COLOR.HIGHLIGHT
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_colourTemperature"), proShot.sun.colourTempIsPreset and (proShot.sun.colourTemp .. "K") or g_i18n:getText("info_transmission_manual"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_intensity"), string.format("%.2f", proShot.sun.intensity))
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), string.format("%.2f", r), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), string.format("%.2f", g), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), string.format("%.2f", b), proShot.INFO_COLOR.BLUE)
	elseif menu == "skyAndGround" then
		local sky = proShot.skyState
		local r, g, b = getLightColor(proShot.sun.lightNode)
		if proShot.sun.intensity ~= 0 then
			r, g, b = r / proShot.sun.intensity, g / proShot.sun.intensity, b / proShot.sun.intensity
		end
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_skyAndGround"))
		box.proShotTitleColor = proShot.INFO_COLOR.HIGHLIGHT
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_skyBrightness"), "", proShot.INFO_COLOR.HIGHLIGHT)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), string.format("%.2f", sky.red), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), string.format("%.2f", sky.green), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), string.format("%.2f", sky.blue), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyTemp"), sky.colourTempIsPreset and (sky.colourTemp .. "K") or g_i18n:getText("info_transmission_manual"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_skyIntensity"), string.format("%.2f", sky.intensity))
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_groundLight"), "", proShot.INFO_COLOR.HIGHLIGHT)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), string.format("%.2f", r), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), string.format("%.2f", g), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), string.format("%.2f", b), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundTemp"), proShot.sun.colourTempIsPreset and (proShot.sun.colourTemp .. "K") or g_i18n:getText("info_transmission_manual"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_groundIntensity"), string.format("%.2f", proShot.sun.intensity))
	elseif menu == "flashLight" then
		local light = proShot.heldLight
		local r, g, b = getLightColor(light.lightNode)
		if light.intensity ~= 0 then
			r, g, b = r / light.intensity, g / light.intensity, b / light.intensity
		end
		local lightK = light.colourTempIsPreset and (light.colourTemp .. "K") or g_i18n:getText("info_transmission_manual")
		local isVisible = getVisibility(light.lightNode)

		box:clear()
		box:setTitle(g_i18n:getText("storeItem_flashlight"))
		proShot:addInfoLine(box, g_i18n:getText("storeItem_flashlight"), isVisible and g_i18n:getText("ui_on") or g_i18n:getText("ui_off"), isVisible and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_flashlightTemp"), lightK, proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_flashlightIntensity"), string.format("%.1f", light.intensity), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_flashlightRange"), tostring(light.range))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_flashlightCone"), tostring(light.coneAngle))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_flashlightDropOff"), tostring(light.dropOff))
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), math.floor(r * 100 + 0.5) .. "%", proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), math.floor(g * 100 + 0.5) .. "%", proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), math.floor(b * 100 + 0.5) .. "%", proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_flashLight_placedCount"), tostring(#proShot.placedLights))
	elseif menu == "environment" then
		local env = g_currentMission.environment
		local seasonPartIndex = (env.currentVisualPeriod - 1) % 3 + 1
		local seasonParts = { "proShot_early", "proShot_mid", "proShot_late" }
		local seasonKeys = {
			[Season.SPRING] = "proShot_spring",
			[Season.SUMMER] = "proShot_summer",
			[Season.AUTUMN] = "proShot_autumn",
			[Season.WINTER] = "proShot_winter"
		}
		local seasonName = g_i18n:getText(seasonKeys[env.currentVisualSeason]) .. " (" .. g_i18n:getText(seasonParts[seasonPartIndex]) .. ")"
		local weatherItem = env.weather.forecastItems[1]

		box:clear()
		box:setTitle(g_i18n:getText("proShot_infoBox_title_environment"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_season"), seasonName, proShot.INFO_COLOR.ACTIVE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_seasonTweak"), string.format("%+.2f", proShot.seasonTweak))
		proShot:addInfoLine(box, g_i18n:getText("ui_ingameMenuWeather"), proShot:getWeatherDisplayName(proShot:getCurrentWeatherName()), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("ui_ingameMenuWeather") .. " " .. g_i18n:getText("proShot_variation"), tostring(weatherItem ~= nil and weatherItem.variationIndex or 1))
		proShot:addInfoLine(box, g_i18n:getText("introduction_timeInfo"), string.format("%d:%02d", env.currentHour, env.currentMinute), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_frost"), g_i18n:getText(g_currentMission.snowSystem:getSnowShaderValue() >= 0.5 and "ui_on" or "ui_off"), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_snowLevel"), string.format("%.2f", proShot:snowBusiness("getHeight")), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_fog"), string.format("%.2f", proShot.fogDensityValue or proShot.fogState.groundFogGroundLevelDensity), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_haze"), string.format("%.2f", proShot.fogState.heightFogGroundLevelDensity), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_groundWetnessInfo"), string.format("%.2f", getWetness()), proShot.INFO_COLOR.BLUE)
	elseif menu == "fog" then
		local fog = proShot.fogState
		local edge0 = math.min(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		local edge1 = math.max(fog.groundFogCoverageEdge0, fog.groundFogCoverageEdge1)
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_fogAdvanced"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_fog_groundDensityInfo"), string.format("%.2f", fog.groundFogGroundLevelDensity), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_fog_extraHeightInfo"), string.format("%.1f m", fog.groundFogExtraHeight))
		proShot:addInfoLine(box, g_i18n:getText("proShot_fog_coverageInfo"), string.format("%.2f", 1 - (edge0 + edge1) * 0.5), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_fog_softnessInfo"), string.format("%.2f", edge1 - edge0), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_fog_minValleyDepthInfo"), string.format("%.1f m", fog.groundFogMinValleyDepth))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_haze"), string.format("%.2f", fog.heightFogGroundLevelDensity), proShot.INFO_COLOR.WARM)
	elseif menu == "sceneControls" then
		local traffic = proShot:getTrafficSystem()
		local pedestrians = proShot:getPedestrianSystem()
		box:clear()
		box:setTitle(g_i18n:getText("proShot_scene_menu"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_traffic"), traffic == nil and g_i18n:getText("proShot_testing_unavailable") or g_i18n:getText(proShot.testingTrafficEnabled and "ui_on" or "ui_off"), traffic ~= nil and proShot.testingTrafficEnabled and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_trafficMotion"), traffic == nil and g_i18n:getText("proShot_testing_unavailable") or g_i18n:getText(proShot.trafficPaused and "proShot_testing_paused" or "proShot_testing_running"), traffic == nil and proShot.INFO_COLOR.MUTED or (proShot.trafficPaused and proShot.INFO_COLOR.WARM or proShot.INFO_COLOR.ACTIVE))
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_pedestrians"), pedestrians == nil and g_i18n:getText("proShot_testing_unavailable") or g_i18n:getText(proShot.testingPedestriansEnabled and "ui_on" or "ui_off"), pedestrians ~= nil and proShot.testingPedestriansEnabled and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_pedestrianMotion"), pedestrians == nil and g_i18n:getText("proShot_testing_unavailable") or g_i18n:getText(proShot.pedestriansPaused and "proShot_testing_paused" or "proShot_testing_running"), pedestrians == nil and proShot.INFO_COLOR.MUTED or (proShot.pedestriansPaused and proShot.INFO_COLOR.WARM or proShot.INFO_COLOR.ACTIVE))
		proShot:addInfoLine(box, g_i18n:getText("proShot_scene_parkedVehicles"), traffic == nil and g_i18n:getText("proShot_testing_unavailable") or g_i18n:getText(proShot.parkedCarsEnabled and "ui_on" or "ui_off"), traffic ~= nil and proShot.parkedCarsEnabled and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_tyreTracks"), g_i18n:getText("proShot_testing_irreversible"), proShot.INFO_COLOR.RED)
	elseif menu == "wildlife" then
		box:clear()
		box:setTitle(g_i18n:getText("proShot_wildlife_menu"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_selectedAnimal"), proShot:getWildlifeDisplayName(proShot:getSelectedWildlife(false)), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_animalMotion"), g_i18n:getText(proShot.wildlifePaused and "proShot_testing_paused" or "proShot_testing_running"), proShot.wildlifePaused and proShot.INFO_COLOR.WARM or proShot.INFO_COLOR.ACTIVE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_spawnedAnimals"), tostring(proShot:getTrackedWildlifeCount(false)))
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_selectedBird"), proShot:getWildlifeDisplayName(proShot:getSelectedWildlife(true)), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_birdMotion"), g_i18n:getText(proShot.birdsPaused and "proShot_testing_paused" or "proShot_testing_running"), proShot.birdsPaused and proShot.INFO_COLOR.WARM or proShot.INFO_COLOR.ACTIVE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_wildlife_spawnedBirds"), tostring(proShot:getTrackedWildlifeCount(true)))
		proShot:addInfoLine(box, g_i18n:getText("proShot_farm_selected"), proShot:getSelectedFarmAnimalDetailedName(), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_farm_spawned"), tostring(proShot:getTrackedFarmAnimalCount()))
		local offsetMode = proShot:getWildlifeOffsetMode()
		local offsetX, offsetY, offsetZ = proShot:getAnimalPlacementOffsets(offsetMode)
		local format = offsetMode == "bird" and "%+.1f m" or "%+.2f m"
		local unavailable = offsetMode == "wildlife"
		proShot:addInfoLine(box, g_i18n:getText("proShot_animals_offsetX"),
			unavailable and "-" or string.format(format, offsetX), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_animals_offsetY"),
			unavailable and "-" or string.format(format, offsetY), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_animals_offsetZ"),
			unavailable and "-" or string.format(format, offsetZ), proShot.INFO_COLOR.BLUE)
		local rotationMode = proShot:getWildlifeRotationMode()
		local rotation = rotationMode == "farm" and (proShot.farmAnimalRotationDegrees or 0)
			or (rotationMode == "bird" and (proShot.birdRotationDegrees or 0)
				or (proShot.wildlifeRotationDegrees or 0))
		proShot:addInfoLine(box, g_i18n:getText("proShot_animals_rotation"), string.format("%+.0f deg", rotation), proShot.INFO_COLOR.BLUE)
	elseif menu == "localSnow" then
		proShot:updateLocalSnowTarget()
		local target = proShot.localSnowTarget
		local snowHeight = proShot:getLocalSnowHeight()
		box:clear()
		box:setTitle(g_i18n:getText("proShot_testing_localSnow"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_snowTarget"), target == nil and g_i18n:getText("proShot_testing_noTarget") or string.format("%.0f, %.0f", target.x, target.z), target ~= nil and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_snowRadiusInfo"), string.format("%.0f m", proShot.localSnowRadius), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_snow_strengthInfo"),
			string.format("%d / %d", proShot.localSnowStrengthLevel, #proShot.LOCAL_SNOW_STRENGTH_LEVELS),
			proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_testing_snowHeightInfo"), snowHeight == nil and "-" or string.format("%.2f m", snowHeight), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_snow_globalLevelInfo"), string.format("%.2f m", proShot:snowBusiness("getHeight")), proShot.INFO_COLOR.BLUE)
	elseif menu == "DoF" then
		local nearCoCRadius, nearBlurEnd, farCoCRadius, farBlurStart, farBlurEnd, applyToSky = unpack(proShot.DoFState)
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_DoF"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_nearCoCRadius"), string.format("%.1f", nearCoCRadius), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_nearBlurEnd"), string.format("%.1f", nearBlurEnd), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_farCoCRadius"), string.format("%.1f", farCoCRadius), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_farBlurStart"), string.format("%.0f", farBlurStart), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_farBlurEnd"), string.format("%.0f", farBlurEnd), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_DoF_applyToSky"), applyToSky and g_i18n:getText("ui_on") or g_i18n:getText("ui_off"), applyToSky and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		if proShot.focusAssist ~= nil then
			local width = (proShot.focusAssist.effectiveNearWidth or 0) + (proShot.focusAssist.effectiveFarWidth or 0)
			proShot:addInfoLine(box, g_i18n:getText("proShot_focus_status"), string.format(g_i18n:getText("proShot_focus_distance"), proShot.focusAssist.distance, width), proShot.INFO_COLOR.ACTIVE)
		end
	elseif menu == "effects" then
		if proShot.effectEditorState == nil then
			proShot.effectEditorState = proShot:captureCurrentEffectState()
			proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
			proShot.effectEditorBaselineSelection = nil
		end
		box:clear()
		box:setTitle(g_i18n:getText("proShot_infoBox_title_effects"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_infoBox_colourGrading"), proShot:getColourGradingDisplayName(), proShot.INFO_COLOR.ACTIVE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_effects_bloomThreshold"), string.format("%.1f", getBloomMaskThreshold()), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_effects_bloomMagnitude"), string.format("%.1f", getBloomMagnitude()), proShot.INFO_COLOR.WARM)
		proShot:addInfoLine(box, g_i18n:getText("proShot_menu_effects_bloomQuality"), string.format("%.0f", getBloomQuality()))
		local ssaoNames = {
			g_i18n:getText("setting_low"),
			g_i18n:getText("setting_medium"),
			g_i18n:getText("setting_high"),
			g_i18n:getText("setting_veryHigh")
		}
		local ssaoQuality = math.clamp(getSSAOQuality(), 1, 4)
		proShot:addInfoLine(box, g_i18n:getText("setting_ssaoQuality"), ssaoNames[ssaoQuality], proShot.INFO_COLOR.BLUE)
		proShot:addInfoSectionHeading(box, g_i18n:getText("proShot_infoBox_colourGradingHeading"))
		proShot:addEffectSummary(box, nil, nil)
	elseif menu == "effectsCustomise" or menu == "effectGroup" then
		box:clear()
		box:setTitle(g_i18n:getText("proShot_infoBox_colourGradingHeading"))
		proShot:addInfoLine(box, g_i18n:getText("proShot_effect_editing"), proShot:getColourGradingDisplayName())
		proShot:addEffectSummary(box, menu == "effectGroup" and proShot.effectEditorGroup or nil, nil)
	elseif menu == "effectValue" then
		local value = proShot.effectEditorState[proShot.effectEditorGroup][proShot.effectEditorProperty]
		box:clear()
		box:setTitle(string.format("%s - %s", g_i18n:getText("proShot_effect_" .. proShot.effectEditorGroup), g_i18n:getText("proShot_effect_" .. proShot.effectEditorProperty)))
		box.proShotTitleColor = proShot.INFO_COLOR.HIGHLIGHT
		proShot:addInfoLine(box, g_i18n:getText("ui_colorRed"), string.format("%.2f", value.red), proShot.INFO_COLOR.RED)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorGreen"), string.format("%.2f", value.green), proShot.INFO_COLOR.GREEN)
		proShot:addInfoLine(box, g_i18n:getText("ui_colorBlue"), string.format("%.2f", value.blue), proShot.INFO_COLOR.BLUE)
		proShot:addInfoLine(box, g_i18n:getText("proShot_effect_scale"), string.format("%.2f", value.scale))
		proShot:addEffectSummary(box, proShot.effectEditorGroup, proShot.effectEditorProperty)
	elseif menu == "toneMapping" then
		local tone = proShot.toneMappingState
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_toneMapping"))
		for _, field in ipairs(proShot.TONE_MAPPING_FIELDS) do
			proShot:addInfoLine(box, g_i18n:getText("proShot_tone_" .. field), string.format("%.2f", tone[field]))
		end
	elseif menu == "effectSaveSlot" or menu == "effectResetSlot" then
		box:clear()
		box:setTitle(g_i18n:getText(menu == "effectSaveSlot" and "proShot_effect_saveSlotMenu" or "proShot_effect_resetSlot"))
		for slot = 1, proShot.EFFECT_SLOT_COUNT do
			if menu == "effectSaveSlot" or proShot.effectSlots[slot] ~= nil then
				local custom = proShot.effectSlots[slot]
				local name = custom ~= nil and custom.name or proShot:getBuiltinEffectName(slot) or g_i18n:getText("configuration_valueEmpty")
				proShot:addInfoLine(box, string.format(g_i18n:getText("proShot_effect_slotLabel"), slot), name)
			end
		end
	elseif menu == "favouriteSaveGroups" then
		box:clear()
		box:setTitle(g_i18n:getText("proShot_favourite_groupsTitle"))
		for _, group in ipairs(proShot.FAVOURITE_GROUPS) do
			local selected = proShot.pendingFavouriteGroups ~= nil and proShot.pendingFavouriteGroups[group.key]
			proShot:addInfoLine(box, selected and "[x]" or "[ ]", g_i18n:getText(group.textKey), selected and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
		end
		proShot:addInfoLine(box, g_i18n:getText("ui_missionStatusTitle"), proShot.favouriteStatus, proShot.INFO_COLOR.BLUE)
	elseif menu == "favourites" or menu == "favouriteSaveSlot" or menu == "favouriteDeleteSlot" then
		box:clear()
		box:setTitle(g_i18n:getText("proShot_menu_favourites"))
		for slot = 1, proShot.FAVOURITE_SLOT_COUNT do
			local favourite = proShot.favourites[slot]
			if menu == "favouriteSaveSlot" or favourite ~= nil then
				local name = favourite ~= nil and favourite.name or g_i18n:getText("configuration_valueEmpty")
				proShot:addInfoLine(box, string.format(g_i18n:getText("proShot_favourite_slotLabel"), slot), name, favourite ~= nil and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
			end
		end
		if proShot.favouriteStatus ~= "" then
			proShot:addInfoLine(box, g_i18n:getText("ui_missionStatusTitle"), proShot.favouriteStatus, proShot.INFO_COLOR.BLUE)
		end
	elseif menu == "flashlightFavouriteSaveSlot" or menu == "flashlightFavouriteDeleteSlot" then
		box:clear()
		box:setTitle(g_i18n:getText("proShot_flashFavourite_title"))
		for slot = 1, proShot.FLASHLIGHT_FAVOURITE_SLOT_COUNT do
			local favourite = proShot.flashlightFavourites[slot]
			if menu == "flashlightFavouriteSaveSlot" or favourite ~= nil then
				local name = favourite ~= nil and favourite.name or g_i18n:getText("configuration_valueEmpty")
				proShot:addInfoLine(box, string.format(g_i18n:getText("proShot_favourite_slotLabel"), slot), name, favourite ~= nil and proShot.INFO_COLOR.ACTIVE or proShot.INFO_COLOR.MUTED)
			end
		end
	else
		return
	end

	proShot:drawInfoBox(box, 1 - g_safeFrameOffsetX, g_safeFrameOffsetY)
end

function proShot:captureScreen()
	local proShotScreenshotDir = g_screenshotsDirectory.."ProShot"
	createFolder(proShotScreenshotDir)
	local captureMode = proShot.captureMode or "png"
	proShot.captureMode = "png"
	local captureTimestamp = proShot.captureTimestamp or proShot:allocateCaptureTimestamp()
	proShot.captureTimestamp = nil
	local screenshotBase = proShotScreenshotDir.."/proShot_"..captureTimestamp
	if proShot.cameraSound ~= nil and proShot.cameraSound ~= 0 then
		playSample(proShot.cameraSound, 1, 1, 0, 0, 0)
	end

	if captureMode == "hdr" or captureMode == "hdrDepth" then
		local colorScreenshotName = screenshotBase .. ".hdr"
		local depthScreenshotName = screenshotBase .. "_depth.hdr"
		if renderScreenshot == nil or setDebugRenderingMode == nil or DebugRendering == nil then
			Logging.error("ProShot: HDR screenshot bindings are unavailable")
			return
		end

		-- Match FS25's proven console-render paths exactly. raw_hdr selects the
		-- HDR render/output path on its own, so no global HDR flag is touched.
		-- Ctrl+Enter stops after the explicitly restored colour pass,
		-- while Ctrl+Shift+Enter adds the native DEPTH pass before restoration.
		local rendered, renderError = pcall(function()
			local screenMode = getScreenMode()
			local width, height = getScreenModeInfo(screenMode)

			setDebugRenderingMode(DebugRendering.NONE)
			print("Saving color screenshot: " .. colorScreenshotName)
			renderScreenshot(colorScreenshotName, width, height, width / height,
				"raw_hdr", 1, 0, 0, 0, 0, 0, 15, false)

			if captureMode == "hdrDepth" then
				setDebugRenderingMode(DebugRendering.DEPTH)
				print("Saving depth screenshot: " .. depthScreenshotName)
				renderScreenshot(depthScreenshotName, width, height, width / height,
					"raw_hdr", 1, 0, 0, 0, 0, 0, 15, false)
			end
			setDebugRenderingMode(DebugRendering.NONE)
		end)

		-- Also restore NONE when either native render raises a Lua-visible error.
		pcall(setDebugRenderingMode, DebugRendering.NONE)
		if not rendered then
			Logging.error("ProShot: Failed to save HDR screenshot%s: %s",
				captureMode == "hdrDepth" and " pair" or "", tostring(renderError))
		end
	else
		local screenshotName = screenshotBase .. ".png"
		print("Saving screenshot: " .. screenshotName)
		if not saveScreenshot(screenshotName) then
			Logging.error("ProShot: Failed to save screenshot '%s'", screenshotName)
		end
	end
end

function proShot:camMoveKeys(cam)
	local speed = 0.1
	local rotspeed = 0.015
	local didChange = false
	if Input.isKeyPressed(Input.KEY_lshift) or Input.isKeyPressed(Input.KEY_rshift) then
		speed = speed * 10
		rotspeed = rotspeed * 5
	elseif Input.isKeyPressed(Input.KEY_lctrl) or Input.isKeyPressed(Input.KEY_rctrl) then
		speed = speed * 0.1
		rotspeed = rotspeed * 0.1
	end

	-- Keypad 1/2/0 are raw camera controls rather than action events. Restrict
	-- the entire set to Main so every submenu can safely own those keys.
	if proShot.menuCurrent == "main" and proShot.menuDesired == "main" then
		local _, _, zR = getRotation(cam)
		if Input.isKeyPressed(Input.KEY_KP_1) then
			_, _, zR = getRotation(getChildAt(cam, 0))
			setRotation(getChildAt(cam, 0), 0, 0, zR + rotspeed)
			didChange = true
		elseif Input.isKeyPressed(Input.KEY_KP_2) then
			_, _, zR = getRotation(getChildAt(cam, 0))
			setRotation(getChildAt(cam, 0), 0, 0, zR - rotspeed)
			didChange = true
		elseif Input.isKeyPressed(Input.KEY_KP_0) then
			setRotation(getChildAt(cam, 0), 0, 0, 0)
			didChange = true
		end
	end

	-- Translation control
	local xD, yD, zD = 0, 0, 0
	-- Height
	if Input.isKeyPressed(Input.KEY_q) then
		yD = 1
	elseif Input.isKeyPressed(Input.KEY_e) then
		yD = -1
	end
	-- Left/Right Forwards/Back
	if Input.isKeyPressed(Input.KEY_w) then
		zD = -1
	elseif Input.isKeyPressed(Input.KEY_s) then
		zD = 1
	end
	if Input.isKeyPressed(Input.KEY_a) then
		xD = -1
	elseif Input.isKeyPressed(Input.KEY_d) then
		xD = 1
	end
	local xL, yL ,zL = localDirectionToWorld(cam, xD, yD, zD)
	local x, y, z = getTranslation(cam)
	setTranslation(cam, x + (speed * xL), y + (speed * yL), z + (speed * zL))
	if xD ~= 0 or yD ~= 0 or zD ~= 0 then
		didChange = true
	end
	if didChange then
		proShot:disarmFlashlightReset()
	end
end

function proShot:camMoveMouse(cam, posX, posY, mouseButtonDown)
	proShot:disarmFlashlightReset()
	posX = math.clamp(posX, 0.4, 0.6)
	posY = math.clamp(posY, 0.4, 0.6)

	local speed = 1
	if Input.isKeyPressed(Input.KEY_lshift) or Input.isKeyPressed(Input.KEY_rshift) then
		speed = speed * 10
	elseif Input.isKeyPressed(Input.KEY_lctrl) or Input.isKeyPressed(Input.KEY_rctrl) then
		speed = speed * 0.1
	end

	local xChange = (posX - 0.5)
	local yChange = (posY - 0.5)

	-- Rotate
	if mouseButtonDown[3] then
		local xR, yR, zR = getRotation(cam)
		if proShot.invertRotY then
			setRotation(cam, xR + yChange, yR - xChange, zR)
		else
			setRotation(cam, xR + yChange, yR + xChange, zR)
		end
	end

	-- Height
	if mouseButtonDown[4] or mouseButtonDown[5] then
		local xT, yT, zT = getTranslation(cam)
		local xL, yL ,zL
		if mouseButtonDown[5] then
			xL, yL ,zL = localDirectionToWorld(cam, 0, -0.05, 0)
		else
			xL, yL ,zL = localDirectionToWorld(cam, 0, 0.05, 0)
		end
		setTranslation(cam, xT + (speed * xL), yT + (speed * yL), zT + (speed * zL))
	end

	-- Rotate the sun
	if mouseButtonDown[2] then
		setRotation(proShot.calc1, 0, 0, 0) -- Zero
		setWorldRotation(proShot.calc2, getWorldRotation(proShot.sun.lightNode)) -- Take reading and calibrate calculator
		setRotation(proShot.calc1, yChange, 0 - xChange, 0) -- Apply transform to calc
		setWorldRotation(proShot.sun.lightNode, getWorldRotation(proShot.calc2)) -- Read the result and apply to the sun
	end

	-- Move
	if mouseButtonDown[1] then
		local xT, yT, zT = getTranslation(cam)
		local xL, yL ,zL = localDirectionToWorld(cam, xChange, 0, 0 - yChange)
		setTranslation(cam, xT + (speed * xL), yT + (speed * yL), zT + (speed * zL))
	end
end

function proShot:getVehicleReloadUniqueId(vehicle)
	if vehicle == nil or vehicle.getUniqueId == nil then
		return nil
	end
	local ok, uniqueId = pcall(vehicle.getUniqueId, vehicle)
	return ok and uniqueId or nil
end

function proShot:finishVehicleReloadCommand(vehicleSystem, returnUniqueId, ok, result)
	if not ok then
		Logging.error("ProShot: Vehicle reload failed: %s", tostring(result))
	elseif result ~= nil then
		Logging.info("ProShot: %s", result)
	end

	if vehicleSystem ~= nil and vehicleSystem.isReloadRunning == true then
		proShot.vehicleReloadPending = true
		proShot.vehicleReloadReturnUniqueId = returnUniqueId
		proShot.vehicleReloadControlRefreshPending = false
		proShot.vehicleReloadControlRefreshStartedAt = nil
		proShot.vehicleReloadReentryRequested = false
		proShot.vehicleReloadCleanupFailureLogged = false
		proShot:debugLog("vehicle reload started; returnVehicle=%s", tostring(returnUniqueId))
	else
		-- Failed/no-op commands also get a quiet period so repeated key presses do
		-- not hammer a mission that cannot currently perform a reload.
		proShot.vehicleReloadPending = false
		proShot.vehicleReloadCooldownUntil = (g_time or 0) + proShot.VEHICLE_RELOAD_COOLDOWN_MS
		proShot.vehicleReloadReturnUniqueId = nil
		proShot.vehicleReloadControlRefreshPending = false
		proShot.vehicleReloadControlRefreshStartedAt = nil
		proShot.vehicleReloadReentryRequested = false
		proShot.vehicleReloadCleanupFailureLogged = false
	end
end

function proShot:finishPausedVehicleDeletion(vehicleSystem)
	if vehicleSystem == nil or vehicleSystem.vehiclesToDelete == nil
		or next(vehicleSystem.vehiclesToDelete) == nil then
		return true
	end
	if vehicleSystem.deleteMarkedVehicles == nil then
		if not proShot.vehicleReloadCleanupFailureLogged then
			Logging.warning("ProShot: Paused vehicle cleanup is unavailable")
			proShot.vehicleReloadCleanupFailureLogged = true
		end
		return false
	end

	-- VehicleSystem's reload callback deliberately queues the old instances for
	-- end-of-frame deletion. That normal end-of-frame step does not run while the
	-- game is paused, so complete the same native cleanup here before another
	-- reload can see both the old and replacement generations.
	local ok, err = pcall(vehicleSystem.deleteMarkedVehicles, vehicleSystem)
	if not ok then
		if not proShot.vehicleReloadCleanupFailureLogged then
			Logging.warning("ProShot: Could not finish paused vehicle cleanup: %s", tostring(err))
			proShot.vehicleReloadCleanupFailureLogged = true
		end
		return false
	end
	proShot.vehicleReloadCleanupFailureLogged = false
	proShot:debugLog("finished paused vehicle deletion queue")
	return next(vehicleSystem.vehiclesToDelete) == nil
end

function proShot:updateVehicleReloadTransaction()
	local mission = g_currentMission
	local vehicleSystem = mission ~= nil and mission.vehicleSystem or nil
	local now = g_time or 0

	if proShot.vehicleReloadPending then
		if vehicleSystem == nil then
			proShot.vehicleReloadPending = false
			proShot.vehicleReloadReturnUniqueId = nil
			proShot.vehicleReloadControlRefreshPending = false
			proShot.vehicleReloadControlRefreshStartedAt = nil
			proShot.vehicleReloadReentryRequested = false
			proShot.vehicleReloadCooldownUntil = now + proShot.VEHICLE_RELOAD_COOLDOWN_MS
			Logging.warning("ProShot: Vehicle reload tracking ended because the vehicle system is unavailable")
		elseif vehicleSystem.isReloadRunning ~= true
			and proShot:finishPausedVehicleDeletion(vehicleSystem) then
			proShot.vehicleReloadPending = false
			proShot.vehicleReloadCooldownUntil = now + proShot.VEHICLE_RELOAD_COOLDOWN_MS
			proShot.vehicleReloadControlRefreshPending = proShot.vehicleReloadReturnUniqueId ~= nil
			proShot.vehicleReloadControlRefreshStartedAt = nil
			proShot.vehicleReloadReentryRequested = false
			proShot:debugLog("vehicle reload completed; cooldownUntil=%s controlRefresh=%s",
				tostring(proShot.vehicleReloadCooldownUntil),
				tostring(proShot.vehicleReloadControlRefreshPending))
		end
	end

	if not proShot.vehicleReloadControlRefreshPending or vehicleSystem == nil
		or vehicleSystem.isReloadRunning == true or mission.paused == true
		or proShot.isActive or (g_gui ~= nil and g_gui:getIsGuiVisible()) then
		return
	end

	-- The native reload can enter the replacement while PAUSE is the active
	-- input context. Wait until FSBaseMission has removed PAUSE, then rebuild the
	-- replacement vehicle's normal FS25 action events in the live context.
	local contextName = g_inputBinding ~= nil and g_inputBinding:getContextName() or nil
	if contextName == BaseMission.INPUT_CONTEXT_PAUSE
		or contextName == BaseMission.INPUT_CONTEXT_SYNCHRONIZING then
		return
	end

	if proShot.vehicleReloadControlRefreshStartedAt == nil then
		proShot.vehicleReloadControlRefreshStartedAt = now
		proShot:debugLog("beginning post-reload control check; returnVehicle=%s context=%s",
			tostring(proShot.vehicleReloadReturnUniqueId), tostring(contextName))
	end
	local uniqueId = proShot.vehicleReloadReturnUniqueId
	local targetVehicle = uniqueId ~= nil and vehicleSystem:getVehicleByUniqueId(uniqueId) or nil
	if targetVehicle ~= nil and targetVehicle.getIsBeingDeleted ~= nil
		and targetVehicle:getIsBeingDeleted() then
		targetVehicle = nil
	end

	local localPlayer = g_localPlayer
	local currentVehicle = localPlayer ~= nil and localPlayer:getCurrentVehicle() or nil
	local currentUniqueId = proShot:getVehicleReloadUniqueId(currentVehicle)
	if targetVehicle ~= nil and currentUniqueId ~= uniqueId then
		if localPlayer ~= nil and not proShot.vehicleReloadReentryRequested
			and localPlayer.requestToEnterVehicle ~= nil then
			localPlayer:requestToEnterVehicle(targetVehicle, true)
			proShot.vehicleReloadReentryRequested = true
			proShot:debugLog("requested post-reload vehicle re-entry for %s", tostring(uniqueId))
		end
		currentVehicle = nil
	end

	if currentVehicle ~= nil and currentUniqueId == uniqueId then
		local vehicleContext = Vehicle ~= nil and Vehicle.INPUT_CONTEXT_NAME or "VEHICLE"
		local playerContext = PlayerInputComponent ~= nil
			and PlayerInputComponent.INPUT_CONTEXT_NAME or "PLAYER"
		local animalContext = PlayerInputComponent ~= nil
			and PlayerInputComponent.INPUT_CONTEXT_NAME_ANIMAL_RIDING or "ANIMAL_LOAD_EMPTY"
		local rootContext = InputBinding ~= nil and InputBinding.ROOT_CONTEXT_NAME or "ROOT"

		if g_inputBinding ~= nil then
			-- Match PlayerStateDriving:onStateEntered so the repaired stack has the
			-- same shape as an ordinary FS25 vehicle entry.
			if contextName ~= playerContext then
				g_inputBinding:replaceContextInStack(playerContext, vehicleContext)
			end
			if contextName == rootContext or contextName == playerContext or contextName == animalContext then
				g_inputBinding:setContext(vehicleContext, true, false)
			end
		end

		local rootVehicle = currentVehicle.rootVehicle or currentVehicle
		local refreshOk, refreshError = pcall(function()
			if rootVehicle.requestActionEventUpdate ~= nil then
				rootVehicle:requestActionEventUpdate()
			end
			if rootVehicle.updateActionEvents ~= nil then
				rootVehicle:updateActionEvents()
			end
		end)
		if not refreshOk then
			Logging.warning("ProShot: Could not refresh controls after vehicle reload: %s", tostring(refreshError))
		else
			proShot:debugLog("post-reload controls refreshed for %s; context=%s",
				tostring(uniqueId), tostring(g_inputBinding ~= nil and g_inputBinding:getContextName() or nil))
		end
		proShot.vehicleReloadControlRefreshPending = false
		proShot.vehicleReloadReturnUniqueId = nil
		proShot.vehicleReloadControlRefreshStartedAt = nil
		proShot.vehicleReloadReentryRequested = false
	elseif now - proShot.vehicleReloadControlRefreshStartedAt
		>= proShot.VEHICLE_RELOAD_CONTROL_TIMEOUT_MS then
		Logging.warning("ProShot: Replacement vehicle controls could not be refreshed within the timeout")
		proShot.vehicleReloadControlRefreshPending = false
		proShot.vehicleReloadReturnUniqueId = nil
		proShot.vehicleReloadControlRefreshStartedAt = nil
		proShot.vehicleReloadReentryRequested = false
	end
end

function proShot:inputKeyboardUpdate()
	proShot:updateVehicleReloadTransaction()

	if proShot.captureKeyReleaseRequired and not Input.isKeyPressed(Input.KEY_return) then
		proShot.captureKeyReleaseRequired = false
	end

	if proShot.F1throttle > 1 then
		proShot.F1throttle = proShot.F1throttle - 1
	else
		if Input.isKeyPressed(Input.KEY_f1) then
			proShot:disarmFlashlightReset()
			proShot:setHudVisible(not proShot:getHudVisible(), true)
			proShot.F1throttle = 10
		end
	end

	proShot:camMoveKeys(proShot.tripod)

	-- Vehicle reload is edge-triggered. The transaction lock lasts until FS25's
	-- asynchronous reload callback completes, with a further cooldown afterward.
	local altDown = Input.isKeyPressed(Input.KEY_lalt) or Input.isKeyPressed(Input.KEY_ralt)
	local reloadKeyDown = altDown and Input.isKeyPressed(Input.KEY_r)
	if reloadKeyDown and not proShot.vehicleReloadKeyWasDown then
		local shiftDown = Input.isKeyPressed(Input.KEY_lshift) or Input.isKeyPressed(Input.KEY_rshift)
		local localPlayer = g_localPlayer
		local vehicleSystem = g_currentMission ~= nil and g_currentMission.vehicleSystem or nil
		if localPlayer == nil or vehicleSystem == nil then
			Logging.warning("ProShot: Vehicle reload is unavailable in the current mission state")
		elseif proShot.vehicleReloadPending or vehicleSystem.isReloadRunning == true then
			Logging.info("ProShot: Vehicle reload ignored because a reload is already in progress")
		elseif (g_time or 0) < (proShot.vehicleReloadCooldownUntil or 0) then
			Logging.info("ProShot: Vehicle reload is cooling down")
		elseif shiftDown then
			local returnUniqueId = proShot:getVehicleReloadUniqueId(localPlayer:getCurrentVehicle())
			local radius
			if Input.isKeyPressed(Input.KEY_lctrl) or Input.isKeyPressed(Input.KEY_rctrl) then
				Logging.info("ProShot: Reloading all vehicles within 100m of camera")
				radius = "100"
			else
				Logging.info("ProShot: Reloading all vehicles within 10m of camera")
				radius = "10"
			end

			-- VehicleSystem takes its radius origin from g_localPlayer in FS25. Use a
			-- temporary position override so the command still measures from the
			-- detached ProShot camera without mutating player or vehicle scene nodes.
			local originalGetPosition = rawget(localPlayer, "getPosition")
			localPlayer.getPosition = function()
				return getWorldTranslation(proShot.tripod)
			end
			local ok, result = pcall(vehicleSystem.consoleCommandReloadVehicle, vehicleSystem, "false", radius)
			localPlayer.getPosition = originalGetPosition
			proShot:finishVehicleReloadCommand(vehicleSystem, returnUniqueId, ok, result)
		elseif localPlayer:getCurrentVehicle() ~= nil then
			Logging.info("Reloading active vehicle")
			local returnUniqueId = proShot:getVehicleReloadUniqueId(localPlayer:getCurrentVehicle())
			local ok, result = pcall(vehicleSystem.consoleCommandReloadVehicle, vehicleSystem)
			proShot:finishVehicleReloadCommand(vehicleSystem, returnUniqueId, ok, result)
		else
			Logging.info("You're not in a vehicle. Try shift+alt+R")
			proShot.vehicleReloadCooldownUntil = (g_time or 0) + proShot.VEHICLE_RELOAD_COOLDOWN_MS
		end
	end
	proShot.vehicleReloadKeyWasDown = reloadKeyDown

	-- Placeable reset
	if proShot.placeableReloadThrottle > 1 then
		proShot.placeableReloadThrottle = proShot.placeableReloadThrottle - 1
	else
		if (Input.isKeyPressed(Input.KEY_lalt) or Input.isKeyPressed(Input.KEY_ralt)) and Input.isKeyPressed(Input.KEY_p) then
			Logging.info("ProShot: Reloading all placeables")
			local placeableSystem = g_currentMission ~= nil and g_currentMission.placeableSystem or nil
			if placeableSystem ~= nil and placeableSystem.consoleCommandReloadAllPlaceables ~= nil then
				placeableSystem:consoleCommandReloadAllPlaceables()
			else
				Logging.warning("ProShot: Placeable reload is unavailable in the current mission state")
			end
			proShot.placeableReloadThrottle = 50
		end
	end
end

function proShot:checkInvertRotY()
	if proShot.previousCamera == nil or proShot.previousCamera == 0
		or not entityExists(proShot.previousCamera) then
		return false
	end
	local _, _, zRotation = getWorldRotation(proShot.previousCamera)
	return zRotation < 1 and zRotation > -1
end


-- Setup when entering pause state
function proShot:setOnPause()
	local mission = g_currentMission
	local env = mission ~= nil and mission.environment or nil
	local snowSystem = mission ~= nil and mission.snowSystem or nil
	local fwyc = proShot.fromWhenceYouCame
	local lighting = env ~= nil and env.lighting or nil
	local baseLighting = env ~= nil and env.baseLighting or nil
	local missionInfo = env ~= nil and env.mission ~= nil and env.mission.missionInfo or nil
	local previousCamera = g_cameraManager ~= nil and g_cameraManager:getActiveCamera() or nil
	local fogUpdater = env ~= nil and env.weather ~= nil and env.weather.fogUpdater or nil
	if env == nil or snowSystem == nil or lighting == nil or lighting.autoExposureCurve == nil
		or env.environmentMaskSystem == nil or baseLighting == nil
		or baseLighting.sunLightId == nil or baseLighting.sunLightId == 0
		or not entityExists(baseLighting.sunLightId)
		or env.weather == nil or fogUpdater == nil or fogUpdater.currentFog == nil
		or missionInfo == nil or g_depthOfFieldManager == nil
		or previousCamera == nil or previousCamera == 0 or not entityExists(previousCamera) then
		if not proShot.pauseSetupFailureLogged then
			Logging.error("ProShot: Cannot start because the active mission is missing a required environment or camera object")
			proShot.pauseSetupFailureLogged = true
		end
		return
	end
	-- Capture the environment before changing any live game state. A failed
	-- snapshot can then return without needing a partial restoration pass.
	local environmentBackup = createXMLFile("proShotEnvironmentXML", "", "environment")
	if environmentBackup == 0 then
		if not proShot.pauseSetupFailureLogged then
			Logging.error("ProShot: Failed to create the in-memory environment backup")
		end
		proShot.pauseSetupFailureLogged = true
		return
	end
	env:saveToXMLFile(environmentBackup, "environment")
	Logging.info("ProShot: Game paused. Saving necessary state info.")
	fwyc.environment = environmentBackup
	proShot.lightLibrary = 0
	local defaultFlashLight = proShot:getDefaultFlashLightSettings()
	proShot.heldLight = {
		["lightNode"] = 0,
		["variation"] = 33,
		["intensity"] = defaultFlashLight.intensity,
		["isVisible"] = false,
		["colourTemp"] = defaultFlashLight.colourTemp,
		["colourTempIsPreset"] = defaultFlashLight.colourTempIsPreset,
		["coneAngle"] = defaultFlashLight.coneAngle,
		["dropOff"] = defaultFlashLight.dropOff,
		["range"] = defaultFlashLight.range,
		["colour"] = {
			defaultFlashLight.red, defaultFlashLight.green, defaultFlashLight.blue
		}
	}
	proShot.flashLightMenuSettings = table.clone(defaultFlashLight)
	proShot.sun = {
		["lightNode"] = 0,
		["intensity"] = 1,
		["colourTemp"] = 6600,
		["colourTempIsPreset"] = false,
		["colour"] = {1, 1, 1}
	}

	-- Set some starting values
	proShot.sun.colourTemp = 6600
	proShot.sun.lightNode = env.baseLighting.sunLightId
	local rSun, gSun, bSun = getLightColor(proShot.sun.lightNode)
	proShot.sun.intensity = (rSun + gSun + bSun) / 3 -- Close enough, probably
	proShot.menuCurrent = "noneAtAll"
	proShot.menuDesired = "main"
	proShot.captureCoolDown = 0
	proShot.captureMode = "png"
	proShot.captureTimestamp = nil
	proShot.captureQueue = {}
	proShot.captureActionHeld = {}
	proShot.reEnableHUD = false
	proShot.seasonTweak = 0
	proShot.colourGradingSelection = nil
	proShot.effectEditorState = proShot:createDefaultEffectState()
	proShot.effectEditorBaselineState = nil
	proShot.effectEditorBaselineSelection = nil
	proShot.effectEditorDirty = false
	proShot.effectEditorGroup = nil
	proShot.effectEditorProperty = nil
	proShot.effectPropertyEntryState = nil
	proShot.effectPropertyEntryDirty = nil
	proShot.effectPropertyEntrySelection = nil
	proShot.snowLevel = nil
	proShot.pendingSnowAreaHeight = nil
	proShot.snowAreaRestore = nil
	proShot.localSnowEdited = false
	proShot.toastText = nil
	proShot.toastEndTime = 0
	proShot.focusAssist = nil
	proShot.focusHoldStartTime = nil
	proShot.focusHoldTriggered = false
	proShot.gridAidIndex = 1
	proShot.aspectAidIndex = 1
	proShot.resetFlashlightsArmed = false
	proShot.resetFlashlightsReleaseRequired = false
	proShot:refreshMainMenu()


	local keyValue, minExposure, maxExposure = env.lighting.autoExposureCurve:get(env.dayTime / 60000)
	local liveKeyValue, liveMinExposure, liveMaxExposure = proShot:getCurrentExposureRange()
	-- Capture the range that is actually driving the renderer. In particular,
	-- FS25's automatic exposure normally has different min/max limits.
	proShot.exposureKeyValue = liveKeyValue or env.lighting.fixedKeyValue or keyValue
	proShot.exposureMinValue = liveMinExposure or env.lighting.fixedMinExposure or minExposure
	proShot.exposureMaxValue = liveMaxExposure or env.lighting.fixedMaxExposure or maxExposure or proShot.exposureMinValue
	proShot.previousCamera = previousCamera
	proShot.FoV = math.floor(math.deg(getFovY(proShot.previousCamera)) + 0.5)

	-- Backup things we'll bugger up
	fwyc.distanceCoeff = { ['View'] = getViewDistanceCoeff(), ['LOD'] = getLODDistanceCoeff(), ['TerrainLOD'] = getTerrainLODDistanceCoeff(), ['FoliageView'] = getFoliageViewDistanceCoeff() }
	fwyc.sun = {}
	fwyc.sun['xR'], fwyc.sun['yR'], fwyc.sun['zR'] = getRotation(proShot.sun.lightNode)
	fwyc.sun.color = { rSun, gSun, bSun }
	fwyc.sun.intensity = proShot.sun.intensity
	fwyc.sun.colourTemp = proShot.sun.colourTemp
	fwyc.sun.colourTempIsPreset = proShot.sun.colourTempIsPreset
	fwyc.hudVisible = proShot:getHudVisible()
	fwyc.noHudModeEnabled = g_noHudModeEnabled
	fwyc.lighting = env.lighting
	-- Start the custom editor from the map's active colour grade so the first edit
	-- preserves its contrast, gamma and gain settings.
	proShot.effectEditorState = proShot:captureCurrentEffectState(fwyc.lighting, env.dayTime)
	proShot.effectEditorBaselineState = proShot:cloneEffectState(proShot.effectEditorState)
	proShot.effectEditorBaselineSelection = nil
	fwyc.visualPeriodLocked = env.visualPeriodLocked
	fwyc.currentVisualPeriod = env.currentVisualPeriod
	fwyc.currentVisualSeason = env.currentVisualSeason
	fwyc.currentVisualDayInSeason = env.currentVisualDayInSeason
	fwyc.currentDayInSeason = env.currentDayInSeason
	fwyc.fixedSeasonalVisuals = env.mission.missionInfo.fixedSeasonalVisuals
	fwyc.forcedSeasonShaderValue = env.forcedSeasonShaderValue
	fwyc.DoF = { getDoFparams() }
	proShot.DoFState = table.clone(fwyc.DoF)
	-- getDofQuality is not documented, but use it when present so future engine
	-- builds can restore exactly. Current FS25 normally uses level 1 outside the
	-- near-DoF console mode.
	fwyc.DoFQuality = getDofQuality ~= nil and getDofQuality() or 1
	setDofQuality(2)
	fwyc.bloom = { getBloomMagnitude(), getBloomMaskThreshold(), getBloomQuality() }
	fwyc.SSAOQuality = getSSAOQuality()
	fwyc.toneMapping = proShot:captureToneMapping()
	proShot.toneMappingState = table.clone(fwyc.toneMapping)
	if fogUpdater ~= nil and fogUpdater.currentFog ~= nil then
		fwyc.fogDebugEnabled = fogUpdater.isDebugEnabled
		fwyc.fogState = fogUpdater.currentFog:clone()
		fwyc.pausedFogState = proShot:createPausedFogState(fogUpdater)
		fwyc.pausedFogDensityValue = fwyc.fogState.groundFogGroundLevelDensity
	else
		fwyc.fogDebugEnabled = nil
		fwyc.fogState = nil
		fwyc.pausedFogState = nil
		fwyc.pausedFogDensityValue = nil
	end
	if fogUpdater ~= nil and fwyc.pausedFogState ~= nil and not fogUpdater.isDebugEnabled then
		local visibilityAlpha = math.clamp(fogUpdater.visibilityAlpha or 1, 0, 1)
		local coverageClosed = fwyc.pausedFogState.groundFogCoverageEdge0 >= 0.999
			and fwyc.pausedFogState.groundFogCoverageEdge1 >= 0.999
		-- A partially faded native profile can retain e.g. 0.08 density while
		-- its coverage produces no visible fog. Treat only a fully active native
		-- profile as an editable non-zero baseline; ProShot still freezes the
		-- exact pre-pause appearance before the user touches this control.
		if not fogUpdater:getIsFogPossible() or visibilityAlpha < 0.999 or coverageClosed then
			fwyc.pausedFogDensityValue = 0
			fwyc.pausedFogState.groundFogGroundLevelDensity = 0
		end
	end
	proShot.fogState = fwyc.pausedFogState ~= nil and fwyc.pausedFogState:clone() or nil
	proShot.fogDensityValue = fwyc.pausedFogDensityValue
	proShot.fogOverrideCoverageEdge0 = fwyc.fogState ~= nil and fwyc.fogState.groundFogCoverageEdge0 or nil
	proShot.fogOverrideCoverageEdge1 = fwyc.fogState ~= nil and fwyc.fogState.groundFogCoverageEdge1 or nil
	proShot.fogOverrideActive = false
	local traffic = proShot:getTrafficSystem()
	local pedestrians = proShot:getPedestrianSystem()
	-- BaseMission deliberately hides traffic and pedestrians on pause. Keep that
	-- as ProShot's starting state; Scene Controls can reveal stationary
	-- subjects when wanted, while BaseMission restores gameplay on unpause.
	proShot.testingTrafficEnabled = false
	proShot.testingPedestriansEnabled = false
	proShot.trafficPaused = true
	proShot.pedestriansPaused = true
	proShot.parkedCarsEnabled = true
	proShot.birdsPaused = true
	proShot.wildlifePaused = true
	proShot.crowPlacementOffset = 0
	proShot.birdPlacementOffset = 0
	proShot.farmAnimalPlacementOffset = 0
	proShot.crowPlacementOffsetX = 0
	proShot.crowPlacementOffsetY = 0
	proShot.birdPlacementOffsetX = 0
	proShot.birdPlacementOffsetY = 0
	proShot.farmAnimalPlacementOffsetX = 0
	proShot.farmAnimalPlacementOffsetY = 0
	proShot.crowWorldOffsetX = 0
	proShot.crowWorldOffsetZ = 0
	proShot.birdWorldOffsetX = 0
	proShot.birdWorldOffsetZ = 0
	proShot.farmAnimalWorldOffsetX = 0
	proShot.farmAnimalWorldOffsetZ = 0
	proShot.wildlifeOffsetMode = "bird"
	proShot.wildlifeRotationDegrees = 0
	proShot.birdRotationDegrees = 0
	proShot.farmAnimalRotationDegrees = 0
	proShot.wildlifeRotationMode = "bird"
	proShot.animalAdjustmentMode = "bird"
	proShot.spawnedWildlife = {}
	proShot.spawnedFarmAnimals = {}
	proShot:ensureGroundCrowSpecies()
	proShot.selectedBirdIndex = 1
	proShot.selectedWildlifeIndex = 1
	proShot.selectedFarmAnimalChoiceIndex = 1
	proShot.selectedFarmAnimalVariantIndex = 1
	proShot:initialiseFarmAnimalSelection()
	proShot:refreshWildlifeMenu()
	proShot.localSnowRadius = 10
	proShot.localSnowStrengthLevel = proShot.LOCAL_SNOW_DEFAULT_STRENGTH_LEVEL
	proShot.localSnowTarget = nil
	proShot:applyTrafficPaused(traffic, true)
	proShot:applyPedestrianTimeScale(pedestrians, 0)
	proShot:setBirdsPaused(true)
	proShot:setWildlifePaused(true)
	fwyc.groundWetness = env.weather.groundWetness
	fwyc.renderWetness = getWetness()
	proShot.testingGroundWetness = fwyc.renderWetness
	proShot.skyState = proShot:createSkyState()
	fwyc.skyState = table.clone(proShot.skyState)
	fwyc.maxInputHelpElements = InputHelpDisplay.MAX_NUM_ELEMENTS

	-- The temporary environment snapshot remains in memory so zipped mods stay
	-- read-only.
	proShot:applyFogState(proShot.fogState)


	-- Enable HUD if it's not visible
	if not fwyc.hudVisible then
		proShot:setHudVisible(true, true)
	end

	-- Set up our camera
	local cam = createCamera("proShotCam", getFovY(proShot.previousCamera), getNearClip(proShot.previousCamera), getFarClip(proShot.previousCamera))
	proShot.tripod = createTransformGroup("tripod")
	link(proShot.tripod, cam)
	link(getRootNode(), proShot.tripod)
	setWorldTranslation(proShot.tripod, getWorldTranslation(proShot.previousCamera))
	setWorldRotation(proShot.tripod, getWorldRotation(proShot.previousCamera))
	proShot.ourCamera = cam
	local dofInfo = g_depthOfFieldManager:createInfo(unpack(proShot.DoFState))
	-- Raw setCamera calls are no longer supported in FS25; every active camera
	-- must be registered so camera-dependent systems follow the switch.
	g_cameraManager:addCamera(cam, nil, false, false, dofInfo)
	g_cameraManager:setActiveCamera(cam)
	proShot.iconOverlay = Overlay.new(proShot.modDir .. "icon_ProShot.dds", 0, 0, 0.1 / g_screenAspectRatio, 0.1)

	proShot.invertRotY = proShot:checkInvertRotY()

	-- Set up the light parent only. The comparatively large light library stays
	-- unloaded until the flashlight is first used.
	proShot.lightStand = createTransformGroup("lightStand")
	link(getRootNode(), proShot.lightStand)
	proShot.placedLights = {} -- A record of placed lights
	proShot:updateFlashLightEnterText()

	-- Sun rotation calculator (beats doing quaternion math myself)
	proShot.calc1 = createTransformGroup("sunCalc1")
	proShot.calc2 = createTransformGroup("sunCalc2")
	link(proShot.calc1, proShot.calc2)
	link(proShot.tripod, proShot.calc1, 1)
	setRotation(proShot.calc1, 0, 0, 0)
	setTranslation(proShot.calc1, 0, 0, 0)
	setTranslation(proShot.calc2, 0, 0, 0)

	-- Backup environment state that is not serialized by Environment itself.
	fwyc.forcedSnowShaderValue = snowSystem.debug_forcedSnowShaderValue
	fwyc.snowLevel = proShot:snowBusiness("getHeight")

	fwyc.sunSizeScale = getSunSizeScale()
	-- Preserve the live atmosphere asymmetry value exactly for restoration.
	fwyc.atmosRefraction = getAtmosphereCornetteShankAsymmetryFactor()
	fwyc.moonSizeScale = getMoonSizeScale()


	-- Update season menu, to reflect current season
	proShot:seasonChange("init")
	-- Set weather to current weather... to update the dynamic menu
	proShot:weatherChange(proShot:getCurrentWeatherName(), true)
	-- This is also the main-menu Reset All baseline. Capture it only after the
	-- FS25 camera, light and environment objects used by the snapshot exist.
	proShot.sessionInitialSettings = proShot:captureFavourite("")
	proShot.favouritesEntrySettings = nil
	proShot:debugLogLiveState("pause setup complete")

	proShot.pauseSetupFailureLogged = false
	proShot.isSet = true
end

-- Called by EventListener when mouse event happens
function proShot:mouseEvent(posX, posY, isDown, isUp, button)
	if proShot.isActive and not proShot.favouriteDialogOpen then
		-- Update mouse button states
		if isDown then
			proShot.mouseButtonDown[button] = true
		elseif isUp then
			proShot.mouseButtonDown[button] = false
		end

		-- See if any mouse buttons are down
		local anyMouseButtonDown = false
		-- Sparse array! Run away...
		for key in pairs(proShot.mouseButtonDown) do
			if proShot.mouseButtonDown[key] then
				anyMouseButtonDown = true
			end
		end

		-- If any button is down, update the camera
		if anyMouseButtonDown then
		proShot:camMoveMouse(proShot.tripod, posX, posY, proShot.mouseButtonDown)
		end
	end
end

-- Pause each category independently. WildlifeManager still performs its normal
-- bookkeeping, while this species-level hook prevents only the selected class
-- from moving or despawning.
function proShot.insteadof_WildlifeSpecies_update(self, superFunc, dt)
	if proShot.isActive then
		local isBird = proShot:isBirdSpecies(self)
		local paused = (isBird and proShot.birdsPaused) or (not isBird and proShot.wildlifePaused)
		if paused then
			return
		end
	end
	return superFunc(self, dt)
end

-- Explicit photo subjects are positioned from the detached ProShot camera.
-- FS25 normally despawns wildlife by its distance from the player, which can
-- be far away from that camera. Protect only instances placed by this session;
-- naturally spawned wildlife retains the standard distance lifecycle.
function proShot.insteadof_WildlifeSpecies_getCanDespawnInstance(self, superFunc, instance, ...)
	if proShot.isActive and proShot:isTrackedWildlifeInstance(self, instance) then
		return false
	end
	return superFunc(self, instance, ...)
end

function proShot.WildlifeInstanceGraphics_onInstanceSpawned(self, species)
	if self.rootNode ~= nil then
		return
	end
	-- WildlifeInstanceSimple constructs graphics with the owning instance in
	-- this field; the missing FS25 hook is responsible for replacing it with the
	-- species' loaded graphics attributes and attaching the shared I3D asset.
	local instance = self.attributes
	if instance == nil or instance.rootNode == nil or species == nil or species.graphicalAttributes == nil then
		Logging.warning("ProShot: Ground-crow graphics could not be attached to its wildlife instance")
		return
	end
	self.attributes = species.graphicalAttributes
	self:load(instance.rootNode)
end

function proShot.WildlifeInstanceMover_delete(self)
	self:cancelTarget()
	self.instance = nil
end

function proShot.insteadof_WildlifeInstanceGraphics_update(self, superFunc, dt)
	if self.nextStateAnimation == nil then
		return superFunc(self, dt)
	end
	if self.shaderNode == nil then
		return
	end
	local nextAnimation = self.nextStateAnimation
	local currentAnimation = self.currentAnimation
	if currentAnimation == nil then
		self:setAnimation(nextAnimation.stateName or nextAnimation.name, true)
		return
	end
	local elapsed = g_time - (self.timeOfLastTransition or g_time)
	local transitionTime = nextAnimation.transitionTime or 0
	if elapsed < transitionTime and transitionTime > 0 then
		local alpha = math.clamp(elapsed / transitionTime, 0, 1)
		setShaderParameter(self.shaderNode, WildlifeInstanceGraphics.SHADER_OPCODE_NAME,
			currentAnimation.opcode, nextAnimation.opcode, alpha, 0, false)
	else
		self:setAnimation(nextAnimation.stateName or nextAnimation.name)
	end
end

-- Do not let the normal wildlife budget create unrequested animals while the
-- photo session is active; explicit ProShot spawns still call the species API.
function proShot.insteadof_WildlifeManager_trySpawnWildlife(self, superFunc, ...)
	if proShot.isActive then
		return
	end
	return superFunc(self, ...)
end

-- Called repeatedly while paused
function proShot:insteadof_GamePausedDisplay_draw(superFunc, drawBackground)
	if self:getVisible() then
		proShot.isActive = true
		if not proShot.isSet then
			proShot:setOnPause()
			if not proShot.isSet then
				proShot.isActive = false
				return
			end
		end
		proShot:setInputHelpWide(true)

		-- Check camera hasn't been lost due to vehicle reload
		local activeCamera = g_cameraManager:getActiveCamera()
		if proShot.ourCamera ~= activeCamera then
			if activeCamera ~= nil and activeCamera ~= proShot.ourCamera then
				Logging.info("Resetting return camera after vehicle reload")
				proShot.previousCamera = activeCamera
			end
			Logging.info("Switching back to ProShot camera, after vehicle reload")
			g_cameraManager:setActiveCamera(proShot.ourCamera)
			setDofQuality(2)
			g_depthOfFieldManager:setManipulatedParams(unpack(proShot.DoFState))
		end
		if proShot.focusAssist ~= nil then
			proShot:applyFocusAssist()
		end
		if proShot.birdsPaused then
			-- Bird assets load asynchronously; repeat the frozen shader update so a
			-- newly loaded or newly spawned flock is held as well.
			proShot:applyBirdAnimationPaused(true)
		end
		if proShot.wildlifePaused then
			-- The adapted ground crow also loads asynchronously and uses the same
			-- shader-driven animation system as flying birds.
			proShot:applyWildlifeAnimationPaused(true)
		end
		-- Companion render nodes become available asynchronously. Retry only
		-- requested rotations until the spawned subject is ready.
		proShot:applyPendingWildlifeRotations()
		proShot:applyPendingAnimalPlacementOffsets()
		-- Environment and custom-lighting updates own these values, so reapply the
		-- intentionally photographic scattering overrides after those updates.
		proShot:applyToneMapping(proShot.toneMappingState)
		proShot:applySkyState()
		proShot:applyPendingSnowAreaHeight()
		proShot:processCaptureQueue()

		if proShot.captureCoolDown < 1 then
			if not proShot:getHudVisible() and proShot.reEnableHUD then
				proShot:setHudVisible(true, false)
				proShot.reEnableHUD = false
			end

			proShot:updateControlsMenu()
			proShot:updateInfoBox()
		end

		if proShot.captureCoolDown > 0 then
			if proShot.captureCoolDown == 25 then
				proShot:captureScreen()
			end
			proShot.captureCoolDown = proShot.captureCoolDown - 1
		end

		if not proShot.favouriteDialogOpen then
			proShot:keyRepeatThrottle(true)
			proShot:inputKeyboardUpdate()
		end

		-- The terrain cursor manages its own visibility when this menu or the HUD
		-- is left, so update it even on the frame that hides the interface.
		proShot:drawLocalSnowPreview()

		-- Render paused text and icon
		if proShot:getHudVisible() then
			proShot:drawCompositionAids()
			proShot:drawCameraReticle()
			local posX, posY = self:getPosition()
			posY = posY - self.height * 0.5 + self.textOffsetY + 38 * g_pixelSizeY
			local textSize = self.textSize
			local shadowOffset = 0.05 * textSize
			setTextBold(true)
			setTextAlignment(RenderText.ALIGN_CENTER)

			setTextColor(0, 0, 0, 0.9)
			renderText(posX + shadowOffset, posY - shadowOffset, textSize, self.pauseText)

			setTextColor(1, 1, 1, 1)
			renderText(posX, posY, textSize, self.pauseText)

			if proShot.toastText ~= nil then
				if g_time < proShot.toastEndTime then
					-- Toasts use the camera reticle as their anchor, so moving the
					-- pause label cannot push notifications back over the centre mark.
					local toastX = 0.5
					local toastY = 0.5 - 28 * g_pixelSizeY - textSize
					setTextColor(0, 0, 0, 0.9)
					renderText(toastX + shadowOffset, toastY - shadowOffset, textSize, proShot.toastText)
					setTextColor(0.32, 0.83, 0.2, 1)
					renderText(toastX, toastY, textSize, proShot.toastText)
				else
					proShot.toastText = nil
				end
			end

			if proShot.iconOverlay ~= nil then
				proShot.iconOverlay:render()
			end
			setTextAlignment(RenderText.ALIGN_LEFT)
			setTextBold(false)
			setTextColor(1, 1, 1, 1)
		end

	end
end

-- Called repeatedly by EventListener when unpaused
function proShot:update(dt)
	proShot:updateVehicleReloadTransaction()

	-- An FS25 snow density-map job may still be completing when the pause menu
	-- closes. Finish only the queued masked-height restoration once it is safe.
	if not proShot.isActive and proShot.pendingSnowAreaHeight ~= nil then
		proShot:applyPendingSnowAreaHeight()
	end

	if proShot.isActive then
		proShot.isActive = false
		if not proShot.isSet then
			return
		end

		Logging.info("ProShot: Game unpaused. Restoring world state.")
		-- Restore the game state captured on entry.
		local fwyc = proShot.fromWhenceYouCame
		if fwyc.maxInputHelpElements ~= nil then
			InputHelpDisplay.MAX_NUM_ELEMENTS = fwyc.maxInputHelpElements
		end
		proShot:setInputHelpWide(false)
		proShot:removeActionEvents()
		setViewDistanceCoeff(fwyc.distanceCoeff.View)
		setLODDistanceCoeff(fwyc.distanceCoeff.LOD)
		setTerrainLODDistanceCoeff(fwyc.distanceCoeff.TerrainLOD)
		setFoliageViewDistanceCoeff(fwyc.distanceCoeff.FoliageView)

		proShot:colorGradingSet()
		-- BaseMission owns traffic/pedestrian visibility restoration during
		-- doUnpauseGame. Remove only ProShot's motion pauses here; rewriting the
		-- enabled states caused both systems to disappear after quick sessions.
		proShot:setTrafficPaused(false)
		proShot:setPedestriansPaused(false)
		proShot:setParkedCarsEnabled(true)
		proShot:setBirdsPaused(false)
		proShot:setWildlifePaused(false)
		proShot:despawnTrackedWildlife(false)
		proShot:removeSessionGroundCrowSpecies()
		if fwyc.environment ~= nil and fwyc.environment ~= 0 then
			proShot:restoreEnvironment()
		end
		proShot:restoreGroundWetness()
		local fogUpdater = proShot:getFogUpdater()
		proShot:applyFogEngine(fwyc.fogState)
		if fogUpdater ~= nil and fwyc.fogDebugEnabled ~= nil then
			fogUpdater.isDebugEnabled = fwyc.fogDebugEnabled
			fogUpdater.isDirty = not fwyc.fogDebugEnabled
		end
		local env = g_currentMission.environment
		if env ~= nil and env.lighting ~= nil then
			env.lighting:updateAtmosphere(env.dayTime / 60000)
		end
		if proShot.sun ~= nil and proShot.sun.lightNode ~= nil and fwyc.sun ~= nil then
			setRotation(proShot.sun.lightNode, fwyc.sun.xR, fwyc.sun.yR, fwyc.sun.zR)
			setLightColor(proShot.sun.lightNode, unpack(fwyc.sun.color))
		end

		setBloomMagnitude(fwyc.bloom[1])
		setBloomMaskThreshold(fwyc.bloom[2])
		setBloomQuality(fwyc.bloom[3])
		setSSAOQuality(fwyc.SSAOQuality)
		proShot:applyToneMapping(fwyc.toneMapping)

		setSunSizeScale(fwyc.sunSizeScale)
		setAtmosphereCornetteShankAsymmetryFactor(fwyc.atmosRefraction)
		setMoonSizeScale(fwyc.moonSizeScale)

		g_noHudModeEnabled = fwyc.noHudModeEnabled
		proShot:setHudVisible(fwyc.hudVisible, false)

		-- Clean up in aisle 4
		if proShot.previousCamera ~= nil and proShot.previousCamera ~= 0 and entityExists(proShot.previousCamera) then
			g_cameraManager:setActiveCamera(proShot.previousCamera)
		else
			g_cameraManager:setDefaultCamera()
		end
		if g_depthOfFieldManager ~= nil and fwyc.DoF ~= nil then
			g_depthOfFieldManager:setManipulatedParams(unpack(fwyc.DoF))
		end
		setDofQuality(fwyc.DoFQuality or 1)
		if g_cameraManager ~= nil and proShot.ourCamera ~= nil and proShot.ourCamera ~= 0 then
			g_cameraManager:removeCamera(proShot.ourCamera)
		end
		proShot.previousCamera = 0
		proShot.captureCoolDown = 0
		proShot.captureMode = "png"
		proShot.captureTimestamp = nil
		proShot.captureQueue = {}
		proShot.captureActionHeld = {}
		proShot.reEnableHUD = false
		proShot.mouseButtonDown = {}
		proShot.keyLockout = {}
		proShot.favouriteDialogOpen = false
		proShot.captureKeyReleaseRequired = false
		proShot.sessionInitialSettings = nil
		proShot.favouritesEntrySettings = nil
		proShot.pendingFavouriteSlot = nil
		proShot.pendingFavouriteGroups = nil
		proShot.snowLevel = nil
		proShot.snowAreaRestore = nil
		proShot.localSnowEdited = false
		proShot.flashLightMenuSettings = nil
		proShot.toastText = nil
		proShot.toastEndTime = 0
		proShot.effectEditorState = nil
		proShot.effectEditorBaselineState = nil
		proShot.effectEditorBaselineSelection = nil
		proShot.effectEditorGroup = nil
		proShot.effectEditorProperty = nil
		proShot.effectPropertyEntryState = nil
		proShot.effectPropertyEntryDirty = nil
		proShot.effectPropertyEntrySelection = nil
		proShot.effectEditorDirty = false
		proShot.toneMappingState = nil
		proShot.fogState = nil
		proShot.fogDensityValue = nil
		proShot.fogOverrideCoverageEdge0 = nil
		proShot.fogOverrideCoverageEdge1 = nil
		proShot.fogOverrideActive = false
		proShot.testingGroundWetness = nil
		proShot.testingTrafficEnabled = false
		proShot.testingPedestriansEnabled = false
		proShot.trafficPaused = false
		proShot.pedestriansPaused = false
		proShot.parkedCarsEnabled = true
		proShot.birdsPaused = false
		proShot.wildlifePaused = false
		proShot.crowPlacementOffset = 0
		proShot.birdPlacementOffset = 0
		proShot.farmAnimalPlacementOffset = 0
		proShot.crowPlacementOffsetX = 0
		proShot.crowPlacementOffsetY = 0
		proShot.birdPlacementOffsetX = 0
		proShot.birdPlacementOffsetY = 0
		proShot.farmAnimalPlacementOffsetX = 0
		proShot.farmAnimalPlacementOffsetY = 0
		proShot.crowWorldOffsetX = 0
		proShot.crowWorldOffsetZ = 0
		proShot.birdWorldOffsetX = 0
		proShot.birdWorldOffsetZ = 0
		proShot.farmAnimalWorldOffsetX = 0
		proShot.farmAnimalWorldOffsetZ = 0
		proShot.wildlifeOffsetMode = "bird"
		proShot.wildlifeRotationDegrees = 0
		proShot.birdRotationDegrees = 0
		proShot.farmAnimalRotationDegrees = 0
		proShot.wildlifeRotationMode = "bird"
		proShot.animalAdjustmentMode = "bird"
		proShot.spawnedWildlife = {}
		proShot.spawnedFarmAnimals = {}
		proShot.farmAnimalChoices = nil
		proShot.selectedFarmAnimalChoiceIndex = 1
		proShot.selectedFarmAnimalVariantIndex = 1
		proShot.farmAnimalDialogOpen = false
		proShot:restoreFarmAnimalDialogOptionHook()
		if proShot.farmAnimalPreviewOverlay ~= nil then
			proShot.farmAnimalPreviewOverlay:delete()
			proShot.farmAnimalPreviewOverlay = nil
		end
		proShot.sessionGroundCrowSpecies = nil
		proShot.localSnowRadius = 10
		proShot.localSnowStrengthLevel = proShot.LOCAL_SNOW_DEFAULT_STRENGTH_LEVEL
		proShot.localSnowTarget = nil
		if proShot.localSnowCursor ~= nil then
			proShot.localSnowCursor:delete()
			proShot.localSnowCursor = nil
		end
		proShot.skyState = nil
		proShot.focusAssist = nil
		proShot.focusHoldStartTime = nil
		proShot.focusHoldTriggered = false
		proShot.gridAidIndex = 1
		proShot.aspectAidIndex = 1
		proShot.resetFlashlightsArmed = false
		proShot.resetFlashlightsReleaseRequired = false
		proShot.pauseSetupFailureLogged = false
		proShot.F1throttle = 0
		proShot.vehicleReloadKeyWasDown = false
		if proShot.iconOverlay ~= nil then
			proShot.iconOverlay:delete()
			proShot.iconOverlay = nil
		end
		for _, node in pairs({ tripod = proShot.tripod, lightStand = proShot.lightStand, lightLibrary = proShot.lightLibrary }) do
			if node ~= nil and node ~= 0 and entityExists(node) then
				delete(node)
			end
		end
		if fwyc.environment ~= nil and fwyc.environment ~= 0 then
			delete(fwyc.environment)
		end
		fwyc.environment = nil
		proShot.isSet = false

		if env ~= nil and env.lighting ~= nil then
			env.lighting:updateExposureSettings()
		end

	end

	-- The first unpaused update performs ProShot cleanup and restores the game
	-- camera. Refresh vehicle input only after that restoration is complete.
	proShot:updateVehicleReloadTransaction()
end

function proShot:loadMap()
	if not proShot.debugConsoleRegistered then
		addConsoleCommand("psDebug", "Toggle ProShot diagnostic logging", "consoleCommandDebug", proShot, "[true|false]")
		proShot.debugConsoleRegistered = true
	end
end

function proShot:deleteMap()
	proShot.vehicleReloadKeyWasDown = false
	proShot.vehicleReloadCooldownUntil = 0
	proShot.vehicleReloadPending = false
	proShot.vehicleReloadReturnUniqueId = nil
	proShot.vehicleReloadControlRefreshPending = false
	proShot.vehicleReloadControlRefreshStartedAt = nil
	proShot.vehicleReloadReentryRequested = false
	proShot.vehicleReloadCleanupFailureLogged = false
	if proShot.isSet and proShot.fromWhenceYouCame.maxInputHelpElements ~= nil then
		InputHelpDisplay.MAX_NUM_ELEMENTS = proShot.fromWhenceYouCame.maxInputHelpElements
	end
	if proShot.isSet then
		proShot:setTrafficPaused(false)
		proShot:setPedestriansPaused(false)
		proShot:setParkedCarsEnabled(true)
		proShot:setBirdsPaused(false)
		proShot:setWildlifePaused(false)
		proShot:despawnTrackedWildlife(false)
		if g_cameraManager ~= nil and proShot.ourCamera ~= nil and proShot.ourCamera ~= 0 then
			g_cameraManager:removeCamera(proShot.ourCamera)
		end
	end
	-- Also cover teardown during an asynchronous load or partially completed
	-- pause setup; this is harmless after the normal cleanup above emptied it.
	proShot:despawnTrackedFarmAnimals()
	proShot:removeSessionGroundCrowSpecies()
	proShot:setInputHelpWide(false)
	proShot.isActive = false
	proShot.isSet = false
	proShot.favouriteDialogOpen = false
	proShot.farmAnimalDialogOpen = false
	proShot:restoreFarmAnimalDialogOptionHook()
	if proShot.farmAnimalPreviewOverlay ~= nil then
		proShot.farmAnimalPreviewOverlay:delete()
		proShot.farmAnimalPreviewOverlay = nil
	end
	if proShot.localSnowCursor ~= nil then
		proShot.localSnowCursor:delete()
		proShot.localSnowCursor = nil
	end
	if proShot.iconOverlay ~= nil then
		proShot.iconOverlay:delete()
		proShot.iconOverlay = nil
	end
	for _, node in pairs({ tripod = proShot.tripod, lightStand = proShot.lightStand, lightLibrary = proShot.lightLibrary }) do
		if node ~= nil and node ~= 0 and entityExists(node) then
			delete(node)
		end
	end
	local environmentBackup = proShot.fromWhenceYouCame ~= nil and proShot.fromWhenceYouCame.environment or nil
	if environmentBackup ~= nil and environmentBackup ~= 0 then
		delete(environmentBackup)
		proShot.fromWhenceYouCame.environment = nil
	end
	if proShot.cameraSound ~= nil and proShot.cameraSound ~= 0 then
		delete(proShot.cameraSound)
		proShot.cameraSound = nil
	end
	if proShot.debugConsoleRegistered then
		removeConsoleCommand("psDebug")
		proShot.debugConsoleRegistered = false
	end
end

initMod()
addModEventListener(proShot)
