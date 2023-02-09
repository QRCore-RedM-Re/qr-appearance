BucketId = GetRandomIntInRange(0, 0xffffff)
ComponentsMale = {}
ComponentsFemale = {}
LoadedComponents = {}
CreatorCache = {}
local SpawnedPeds = {}
MenuData = {}
TriggerEvent("qr_menu:getData", function(call)
    MenuData = call
end)
local MainMenus = {
    ["body"] = function()
        OpenBodyMenu()
    end,
    ["face"] = function()
        OpenFaceMenu()
    end,
    ["hair"] = function()
        OpenHairMenu()
    end,
    ["makeup"] = function()
        OpenMakeupMenu()
    end,
    ["save"] = function()
		TriggerServerEvent("qr_appearance:SetPlayerBucket" , 0)
        EndCharacterCreatorCam()
        MenuData.CloseAll()
        LoadedComponents = CreatorCache
        TriggerServerEvent("qr_appearance:SaveSkin", CreatorCache)
    end
}
local BodyFunctions = {
    ["head"] = function(target, data)
        LoadHead(target, data)
        LoadOverlays(target, data)
    end,
    ["face_width"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["skin_tone"] = function(target, data)
        LoadBody(target, data)
        LoadOverlays(target, data)
    end,
    ["body_size"] = function(target, data)
        LoadBodySize(target, data)
        LoadBody(target, data)
    end,
    ["body_waist"] = function(target, data)
        LoadBodyWaist(target, data)
    end,
    ["height"] = function(target, data)
        LoadHeight(target, data)
    end
}
local FaceFunctions = {
    ["eyes"] = function()
        OpenEyesMenu()
    end,
    ["eyelids"] = function()
        OpenEyelidsMenu()
    end,
    ["eyebrows"] = function()
        OpenEyebrowsMenu()
    end,
    ["nose"] = function()
        OpenNoseMenu()
    end,
    ["mouth"] = function()
        OpenMouthMenu()
    end,
    ["cheekbones"] = function()
        OpenCheekbonesMenu()
    end,
    ["jaw"] = function()
        OpenJawMenu()
    end,
    ["ears"] = function()
        OpenEarsMenu()
    end,
    ["chin"] = function()
        OpenChinMenu()
    end,
    ["defects"] = function()
        OpenDefectsMenu()
    end
}
local HairFunctions = {
    ["hair"] = function(target, data)
        LoadHair(target, data)
    end,
    ["beard"] = function(target, data)
        LoadBeard(target, data)
    end

}
local EyesFunctions = {
    ["eyes_color"] = function(target, data)
        LoadEyes(target, data)
    end,
    ["eyes_depth"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyes_angle"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyes_distance"] = function(target, data)
        LoadFeatures(target, data)
    end
}
local EyelidsFunctions = {
    ["eyelid_height"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyelid_width"] = function(target, data)
        LoadFeatures(target, data)
    end
}
local EyebrowsFunctions = {
    ["eyebrows_t"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_op"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_id"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_c1"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrow_height"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyebrow_width"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyebrow_depth"] = function(target, data)
        LoadFeatures(target, data)
    end
}
CreateThread(function()
    for i, v in pairs(cloth_hash_names) do
        if v.category_hashname == "BODIES_LOWER" or v.category_hashname == "BODIES_UPPER" or v.category_hashname ==
            "heads" or v.category_hashname == "hair" or v.category_hashname == "teeth" or v.category_hashname == "eyes" then
            if v.ped_type == "female" and v.is_multiplayer and v.hashname ~= "" then
                if ComponentsFemale[v.category_hashname] == nil then
                    ComponentsFemale[v.category_hashname] = {}
                end
                table.insert(ComponentsFemale[v.category_hashname], v.hash)
            elseif v.ped_type == "male" and v.is_multiplayer and v.hashname ~= "" then
                if ComponentsMale[v.category_hashname] == nil then
                    ComponentsMale[v.category_hashname] = {}
                end

                table.insert(ComponentsMale[v.category_hashname], v.hash)
            end
        end
    end
    if not IsImapActive(183712523) then
        RequestImap(183712523) -- CharacterCreator
    end
    if not IsImapActive(-1699673416) then
        RequestImap(-1699673416) -- CharacterCreator
    end
    if not IsImapActive(1679934574) then
        RequestImap(1679934574) -- CharacterCreator
    end
end)

RegisterNetEvent('qr_appearance:ApplySkin', function(SkinData, Target, ClothesData)
    CreateThread(function()
        local _Target = Target or PlayerPedId()
        local _SkinData = SkinData
        if _Target == PlayerPedId() then
            local model = GetPedModel(tonumber(_SkinData.sex))
            LoadModel(PlayerPedId(), model)
            _Target = PlayerPedId()
            SetEntityAlpha(_Target, 0)
            LoadedComponents = _SkinData
        end
        FixIssues(_Target, _SkinData)
        LoadHeight(_Target, _SkinData)
        LoadBody(_Target, _SkinData)
        LoadHead(_Target, _SkinData)
        LoadHair(_Target, _SkinData)
        LoadBeard(_Target, _SkinData)
        LoadEyes(_Target, _SkinData)
        LoadFeatures(_Target, _SkinData)
        LoadBodySize(_Target, _SkinData)
        LoadBodyWaist(_Target, _SkinData)
        LoadOverlays(_Target, _SkinData)
        SetEntityAlpha(_Target, 255)
        TriggerEvent("qr_appearance:SkinLoaded", _SkinData, _Target, ClothesData)
        if _Target == PlayerPedId() then
            TriggerServerEvent("qr_clothes:LoadClothes", 1)
        else
            TriggerEvent("qr_clothes:ApplyClothes", ClothesData, _Target)
            for i, m in pairs(overlay_all_layers) do
                overlay_all_layers[i] =
                {name = m.name, visibility = 0, tx_id = 1, tx_normal = 0, tx_material = 0, tx_color_type = 0, tx_opacity = 1.0, tx_unk = 0, palette = 0, palette_color_primary = 0, palette_color_secondary = 0, palette_color_tertiary = 0, var = 0, opacity = 0.0}
            end
        end
    end)
end)

RegisterNetEvent('qr_appearance:OpenCreator', function()
    StartCreator()
end)

RegisterNetEvent('qr_appearance:LoadSkinClient', function()
    TriggerServerEvent("qr_appearance:LoadSkin")
end)

RegisterCommand('loadskin', function()
    TriggerServerEvent("qr_appearance:LoadSkin")
end)

RegisterCommand('creator', function()
    StartCreator()
end)

function StartCreator()
    TriggerServerEvent("qr_appearance:SetPlayerBucket" , BucketId)
    Wait(1)
    for i, m in pairs(overlay_all_layers) do
        overlay_all_layers[i] =
        {name = m.name, visibility = 0, tx_id = 1, tx_normal = 0, tx_material = 0, tx_color_type = 0, tx_opacity = 1.0, tx_unk = 0, palette = 0, palette_color_primary = 0, palette_color_secondary = 0, palette_color_tertiary = 0, var = 0, opacity = 0.0}
    end
    MenuData.CloseAll()
    SpawnedPeds = SpawnPeds()
    local selectedSex = StartSelectCam()
    CreatorCache["sex"] = selectedSex
    local model = GetPedModel(selectedSex)
    LoadModel(PlayerPedId(), model)
    FixIssues(PlayerPedId())
    SetEntityVisible(PlayerPedId(), true)
    DeletePeds(SpawnedPeds)
    MainMenu()
end

function MainMenu(Target)
    MenuData.CloseAll()
    local _Target = Target or PlayerPedId()
    local elements = {
        {label = QR.Texts.Body, value = 'body', desc = ""},
        {label = QR.Texts.Face, value = 'face', desc = ""},
        {label = QR.Texts.Hair_beard, value = 'hair', desc = ""},
        {label = QR.Texts.Makeup, value = 'makeup', desc = ""},
        {label = QR.Texts.save, value = 'save', desc = ""}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'main_character_creator_menu',
        {title = QR.Texts.Appearance, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
        MainMenus[data.current.value]() end, function(data, menu)
    end)
end
function OpenBodyMenu()
    MenuData.CloseAll()
    local BodySizeOptions = {QR.Texts.Slim, QR.Texts.Sporty, QR.Texts.Medium, QR.Texts.Fat,QR.Texts.Strong}
    local BodyWaistOptions = {}
    for i, v in ipairs(WAIST_TYPES) do
        table.insert(BodyWaistOptions, "+ " .. (i / 2) .. " kg")
    end

    local HeightOptions = {}
    for i = 88, 106 do
        table.insert(HeightOptions, i .. "")
    end
    local SkinToneOptions = {QR.Texts.Color1,QR.Texts.Color2,QR.Texts.Color3,QR.Texts.Color4,QR.Texts.Color5,QR.Texts.Color6}
    local elements = {
        {label = QR.Texts.Face, value = CreatorCache["head"] or 1, category = "head", desc = "", type = "slider", min = 1, max = 120, hop = 6},
        {label = QR.Texts.Width, value = CreatorCache["face_width"] or 0, category = "face_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.SkinTone, value = CreatorCache["skin_tone"] or 1, category = "skin_tone", desc = "", type = "slider", min = 1, max = 6, options = SkinToneOptions},
        {label = QR.Texts.Size, value = CreatorCache["body_size"] or 3, category = "body_size", desc = "", type = "slider", min = 1, max = 5, options = BodySizeOptions},
        {label = QR.Texts.Waist, value = CreatorCache["body_waist"] or 7, category = "body_waist", desc = "", type = "slider", min = 1, max = 21, options = BodyWaistOptions},
        { label = QR.Texts.Height,   value = CreatorCache["height"] or 94,    category = "height",     desc = "Change height", type = "slider", min = 88,   max = 106, options = HeightOptions }
    }
    MenuData.Open('default', GetCurrentResourceName(), 'body_character_creator_menu',
        {title = QR.Texts.Appearance, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        MainMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            BodyFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end
function OpenFaceMenu()
    MoveCharacterCreatorCamera(-558.97, -3780.95, 239.18)
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Eyes, value = 'eyes', desc = ""},
        {label = QR.Texts.Eyelids, value = 'eyelids', desc = ""},
        {label = QR.Texts.Eyebrows, value = 'eyebrows', desc = ""},
        {label = QR.Texts.Nose, value = 'nose', desc = ""},
        {label = QR.Texts.Mouth, value = 'mouth', desc = ""},
        {label = QR.Texts.Cheekbones, value = 'cheekbones', desc = ""},
        {label = QR.Texts.Jaw, value = 'jaw', desc = ""},
        {label = QR.Texts.Ears, value = 'ears', desc = ""},
        {label = QR.Texts.Chin, value = 'chin', desc = ""},
        {label = QR.Texts.Defects, value = 'defects', desc = ""}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'face_main_character_creator_menu',
        {title = QR.Texts.Face, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
        FaceFunctions[data.current.value]()
    end, function(data, menu)
        MoveCharacterCreatorCamera(-560.133, -3780.92, 238.6)
        MainMenu()
    end)
end
function OpenHairMenu()
    MoveCharacterCreatorCamera(-558.97, -3780.95, 239.18)
    MenuData.CloseAll()
    local elements = {}
    if IsPedMale(PlayerPedId()) then
        local a = 1
		if CreatorCache["hair"] == nil or type(CreatorCache["hair"]) ~= "table" then
            CreatorCache["hair"] = {}
            CreatorCache["hair"].model = 0
            CreatorCache["hair"].texture = 1
        end
		if CreatorCache["beard"] == nil or type(CreatorCache["beard"]) ~= "table" then
            CreatorCache["beard"] = {}
            CreatorCache["beard"].model = 0
            CreatorCache["beard"].texture = 1

        end
        local options = {}
		-- male hair selection
		local category = hairs_list["male"]["hair"]
        for k, v in pairs(category) do
            table.insert(options, QR.Texts.Style .. k)
        end
        table.insert(elements, {label = QR.Texts.HairStyle, value = CreatorCache["hair"].model or 0, category = "hair", desc = "", type = "slider", min = 0, max = #category, change_type = "model", id = a, options = options})
        a = a + 1
        options = {}
        for i = 1, GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1), 1 do
            table.insert(options, QR.Texts.Color .. i)
        end
        table.insert(elements, {label = QR.Texts.HairColor, value = CreatorCache["hair"].texture or 1, category = "hair", desc = "", type = "slider", min = 1, max = GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1), change_type = "texture", id = a, options = options})
        options = {}
        a = a + 1
		-- male beard selection
		local category = hairs_list["male"]["beard"]
        for k, v in pairs(category) do
            table.insert(options, QR.Texts.Style .. k)
        end
        table.insert(elements, { label = QR.Texts.BeardStyle, value = CreatorCache["beard"].model or 0, category = "beard", desc = "", type = "slider", min = 0, max = #category, change_type = "model", id = a, options = options})
        a = a + 1
        options = {}
        for i = 1, GetMaxTexturesForModel("beard", CreatorCache["beard"].model or 1), 1 do
            table.insert(options, QR.Texts.Color .. i)
        end
        table.insert(elements, {label = QR.Texts.BeardColor, value = CreatorCache["beard"].texture or 1, category = "beard", desc = "", type = "slider", min = 1, max = GetMaxTexturesForModel("beard", CreatorCache["beard"].model or 1), change_type = "texture", id = a, options = options})
        options = {}
        a = a + 1
    else
        local a = 1
        if CreatorCache["hair"] == nil or type(CreatorCache["hair"]) ~= "table" then
            CreatorCache["hair"] = {}
            CreatorCache["hair"].model = 0
            CreatorCache["hair"].texture = 1
        end
        local options = {}
		-- female hair options
        local category = hairs_list["female"]["hair"]
		for k, v in pairs(category) do
            table.insert(options, QR.Texts.Style .. k)
        end
        table.insert(elements,
            {label = QR.Texts.Hair, value = CreatorCache["hair"].model or 0, category = "hair", desc = "", type = "slider", min = 0, max = #category, change_type = "model", id = a, options = options}
        )
        a = a + 1
        options = {}
        for i = 1, GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1), 1 do
            table.insert(options, QR.Texts.HairColor .. i)
        end
        table.insert(elements,
            {label = QR.Texts.Hair, value = CreatorCache["hair"].texture or 1, category = "hair", desc = "", type = "slider", min = 1, max = GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1), change_type = "texture", id = a, options = options}
        )
        options = {}
        a = a + 1
    end
    MenuData.Open('default', GetCurrentResourceName(), 'hair_main_character_creator_menu',
        {title = QR.Texts.Hair_beard, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        MoveCharacterCreatorCamera(-560.133, -3780.92, 238.6)
        MainMenu()
    end, function(data, menu)
        if data.current.change_type == "model" then
            if CreatorCache[data.current.category].model ~= data.current.value then
                CreatorCache[data.current.category].texture = 1
                CreatorCache[data.current.category].model = data.current.value
                if data.current.value > 0 then
                    local options = {}
                    if GetMaxTexturesForModel(data.current.category, data.current.value) > 1 then
                        for i = 1, GetMaxTexturesForModel(data.current.category, data.current.value), 1 do
                            table.insert(options, QR.Texts.Color .. i)
                        end
                    else
                        table.insert(options, "Brak")
                    end
                    menu.setElement(data.current.id + 1, "options", options)
                    menu.setElement(data.current.id + 1, "max", GetMaxTexturesForModel(data.current.category, data.current.value))
                    menu.setElement(data.current.id + 1, "min", 1)
                    menu.setElement(data.current.id + 1, "value", 1)
                    menu.refresh()
                else
                    menu.setElement(data.current.id + 1, "max", 0)
                    menu.setElement(data.current.id + 1, "min", 0)
                    menu.setElement(data.current.id + 1, "value", 0)
                    menu.refresh()
                end
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
         elseif data.current.change_type == "texture" then
            if CreatorCache[data.current.category].texture ~= data.current.value then
                CreatorCache[data.current.category].texture = data.current.value
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
        else
            if CreatorCache[data.current.category] ~= data.current.value then
                CreatorCache[data.current.category] = data.current.value
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
        end
    end)
end

function OpenEyesMenu()
    MenuData.CloseAll()
    local EyesColorOptions = {QR.Texts.EyesTone1,QR.Texts.EyesTone2,QR.Texts.EyesTone3,QR.Texts.EyesTone4,QR.Texts.EyesTone5,QR.Texts.EyesTone5}                      
    local elements = {
        {label = QR.Texts.Color, value = CreatorCache["eyes_color"] or 1, category = "eyes_color", desc = "", type = "slider", min = 1,max = 18},
        {label = QR.Texts.Depth, value = CreatorCache["eyes_depth"] or 0, category = "eyes_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Angle, value = CreatorCache["eyes_angle"] or 0, category = "eyes_angle", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Distance, value = CreatorCache["eyes_distance"] or 0, category = "eyes_distance", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyes_character_creator_menu', 
    {title = QR.Texts.Eyes, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyesFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEyelidsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Height, value = CreatorCache["eyelid_height"] or 0, category = "eyelid_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Width, value = CreatorCache["eyelid_width"] or 0, category = "eyelid_width", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyelid_character_creator_menu',
        {title = QR.Texts.Eyelids, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyelidsFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEyebrowsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Height, value = CreatorCache["eyebrow_height"] or 0, category = "eyebrow_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Width, value = CreatorCache["eyebrow_width"] or 0, category = "eyebrow_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Depth, value = CreatorCache["eyebrow_depth"] or 0, category = "eyebrow_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Type, value = CreatorCache["eyebrows_t"] or 1, category = "eyebrows_t", desc = "", type = "slider", min = 1, max = 15},
        {label = QR.Texts.Visibility, value = CreatorCache["eyebrows_op"] or 100, category = "eyebrows_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.ColorPalette, value = CreatorCache["eyebrows_id"] or 10, category = "eyebrows_id", desc = "", type = "slider", min = 1, max = 25},
        {label = QR.Texts.ColorFirstrate, value = CreatorCache["eyebrows_c1"] or 0, category = "eyebrows_c1", desc = "", type = "slider", min = 0, max = 64}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyebrows_character_creator_menu',
        {title = QR.Texts.Eyebrows, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyebrowsFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenNoseMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Width, value = CreatorCache["nose_width"] or 0, category = "nose_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Size, value = CreatorCache["nose_size"] or 0, category = "nose_size", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Height, value = CreatorCache["nose_height"] or 0, category = "nose_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Angle, value = CreatorCache["nose_angle"] or 0, category = "nose_angle", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.NoseCurvature, value = CreatorCache["nose_curvature"] or 0, category = "nose_curvature", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Distance, value = CreatorCache["nostrils_distance"] or 0, category = "nostrils_distance", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'nose_character_creator_menu',
        {title = QR.Texts.Nose, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenMouthMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Width, value = CreatorCache["mouth_width"] or 0, category = "mouth_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Depth, value = CreatorCache["mouth_depth"] or 0, category = "mouth_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.UP_DOWN, value = CreatorCache["mouth_x_pos"] or 0, category = "mouth_x_pos", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.left_right, value = CreatorCache["mouth_y_pos"] or 0, category = "mouth_y_pos", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.UpperLipHeight, value = CreatorCache["upper_lip_height"] or 0, category = "upper_lip_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.UpperLipWidth, value = CreatorCache["upper_lip_width"] or 0, category = "upper_lip_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.UpperLipDepth, value = CreatorCache["upper_lip_depth"] or 0, category = "upper_lip_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.LowerLipHeight, value = CreatorCache["lower_lip_height"] or 0, category = "lower_lip_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.LowerLipWidth, value = CreatorCache["lower_lip_width"] or 0, category = "lower_lip_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.LowerLipDepth, value = CreatorCache["lower_lip_depth"] or 0, category = "lower_lip_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'mouth_character_creator_menu',
        {title = QR.Texts.Mouth, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenCheekbonesMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Height, value = CreatorCache["cheekbones_height"] or 0, category = "cheekbones_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Width, value = CreatorCache["cheekbones_width"] or 0, category = "cheekbones_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Depth, value = CreatorCache["cheekbones_depth"] or 0, category = "cheekbones_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }

    MenuData.Open('default', GetCurrentResourceName(), 'cheekbones_character_creator_menu',
        {title = 'Cheek Bones', subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenJawMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Height, value = CreatorCache["jaw_height"] or 0, category = "jaw_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Width, value = CreatorCache["jaw_width"] or 0, category = "jaw_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Depth, value = CreatorCache["jaw_depth"] or 0, category = "jaw_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'jaw_character_creator_menu',
        {title = QR.Texts.Jaw, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEarsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Width, value = CreatorCache["ears_width"] or 0, category = "ears_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Angle, value = CreatorCache["ears_angle"] or 0, category = "ears_angle", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Height, value = CreatorCache["ears_height"] or 0, category = "ears_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Size, value = CreatorCache["earlobe_size"] or 0, category = "earlobe_size", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'ears_character_creator_menu',
        {title = QR.Texts.Ears, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenChinMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Size, value = CreatorCache["chin_height"] or 0, category = "chin_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Size, value = CreatorCache["chin_width"] or 0, category = "chin_width", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = QR.Texts.Size, value = CreatorCache["chin_depth"] or 0, category = "chin_depth", desc = "", type = "slider", min = -100, max = 100, hop = 5}}
    MenuData.Open('default', GetCurrentResourceName(), 'chin_character_creator_menu',
        {title = QR.Texts.Chin, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenDefectsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Scars, value = CreatorCache["scars_t"] or 1, category = "scars_t", desc = "", type = "slider", min = 1, max = 16, options = nil},
        {label = QR.Texts.Clarity, value = CreatorCache["scars_op"] or 0, category = "scars_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.Older, value = CreatorCache["ageing_t"] or 1, category = "ageing_t", desc = "", type = "slider", min = 1, max = 24, options = nil},
        {label = QR.Texts.Clarity, value = CreatorCache["ageing_op"] or 0, category = "ageing_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.Freckles, value = CreatorCache["freckles_t"] or 1, category = "freckles_t", desc = "", type = "slider", min = 1, max = 15, options = nil},
        {label = QR.Texts.Clarity, value = CreatorCache["freckles_op"] or 0, category = "freckles_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.Moles, value = CreatorCache["moles_t"] or 1, category = "moles_t", desc = "", type = "slider", min = 1, max = 16, options = nil},
        {label = QR.Texts.Clarity, value = CreatorCache["moles_op"] or 0, category = "moles_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.Spots, value = CreatorCache["spots_t"] or 1, category = "spots_t", desc = "", type = "slider", min = 1, max = 16, options = nil},
        {label = QR.Texts.Clarity, value = CreatorCache["spots_op"] or 0, category = "spots_op", desc = "", type = "slider", min = 0, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'defects_character_creator_menu',
        {title = QR.Texts.Disadvantages, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadOverlays(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenMakeupMenu()
    MoveCharacterCreatorCamera(-558.97, -3780.95, 239.18)
    MenuData.CloseAll()
    local elements = {
        {label = QR.Texts.Shadow, value = CreatorCache["shadows_t"] or 1, category = "shadows_t", desc = "", type = "slider", min = 1, max = 5},
        {label = QR.Texts.Clarity, value = CreatorCache["shadows_op"] or 0, category = "shadows_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.ColorShadow, value = CreatorCache["shadows_id"] or 1, category = "shadows_id", desc = "", type = "slider", min = 1, max = 25},
        {label = QR.Texts.ColorFirst_Class, value = CreatorCache["shadows_c1"] or 0, category = "shadows_c1", desc = "", type = "slider", min = 0, max = 64},
        {label = QR.Texts.Blushing_Cheek, value = CreatorCache["blush_t"] or 1, category = "blush_t", desc = "", type = "slider", min = 1, max = 4},
        {label = QR.Texts.Clarity, value = CreatorCache["blush_op"] or 0, category = "blush_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.blush_id, value = CreatorCache["blush_id"] or 1, category = "blush_id", desc = "", type = "slider", min = 1, max = 25},
        {label = QR.Texts.blush_c1, value = CreatorCache["blush_c1"] or 0, category = "blush_c1", desc = "", type = "slider", min = 0, max = 64},
        {label = QR.Texts.Lipstick,value = CreatorCache["lipsticks_t"] or 1, category = "lipsticks_t", desc = "", type = "slider", min = 1, max = 7},
        {label = QR.Texts.Clarity, value = CreatorCache["lipsticks_op"] or 0, category = "lipsticks_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.ColorLipstick, value = CreatorCache["lipsticks_id"] or 1, category = "lipsticks_id", desc = "", type = "slider", min = 1, max = 25},
        {label = QR.Texts.lipsticks_c1, value = CreatorCache["lipsticks_c1"] or 0, category = "lipsticks_c1", desc = "", type = "slider", min = 0, max = 64},
        {label = QR.Texts.lipsticks_c2, value = CreatorCache["lipsticks_c2"] or 0, category = "lipsticks_c2", desc = "", type = "slider", min = 0, max = 64},
        {label = QR.Texts.Eyeliners, value = CreatorCache["eyeliners_t"] or 1, category = "eyeliners_t", desc = "", type = "slider", min = 1, max = 15},
        {label = QR.Texts.Clarity, value = CreatorCache["eyeliners_op"] or 0, category = "eyeliners_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = QR.Texts.eyeliners_id, value = CreatorCache["eyeliners_id"] or 1, category = "eyeliners_id", desc = "", type = "slider", min = 1, max = 25},
        {label = QR.Texts.eyeliners_c1, value = CreatorCache["eyeliners_c1"] or 0, category = "eyeliners_c1", desc = "", type = "slider", min = 0, max = 64}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'makeup_character_creator_menu',
        {title = QR.Texts.Make_up, subtext = QR.Texts.Options, align = QR.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        MoveCharacterCreatorCamera(-560.133, -3780.92, 238.6)
        MainMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadOverlays(PlayerPedId(), CreatorCache)
        end
    end)
end

exports('GetComponentId', function(name)
    return LoadedComponents[name]
end)
exports('GetBodyComponents', function()
    return {ComponentsMale, ComponentsFemale}
end)
exports('GetBodyCurrentComponentHash', function(name)
    local hash
    if name == "hair" or name == "beard" then
        local info = LoadedComponents[name]
        local texture = info.texture
        local model = info.model
        if model == 0 or texture == 0 then
            return
        end
        if type(info) == "table" then
            if IsPedMale(PlayerPedId()) then
                if hairs_list["male"][name][model][texture] ~= nil then
                    hash = hairs_list["male"][name][model][texture].hash
                end
            else
                if hairs_list["female"][name][model][texture] ~= nil then
                    hash = hairs_list["female"][name][model][texture].hash
                end
            end
        end
    else
        local id = LoadedComponents[name]
        if not id then
            return
        end
        if IsPedMale(PlayerPedId()) then
            if ComponentsMale[name] ~= nil then
                hash = ComponentsMale[name][id]
            end
        else
            if ComponentsFemale[name] ~= nil then
                hash = ComponentsFemale[name][id]
            end
        end
    end
    return hash
end)
exports('SetFaceOverlays', function(target, data)
    LoadOverlays(target, data)
end)
exports('SetHair', function(target, data)
    LoadHair(target, data)
end)
exports('SetBeard', function(target, data)
    LoadBeard(target, data)
end)
exports('GetComponentsMax', function(name)
    if name == "hair" or name == "beard" then
        if IsPedMale(PlayerPedId()) then
            if hairs_list["male"][name] ~= nil then
                return #hairs_list["male"][name]
            end
        else
            if hairs_list["female"][name] ~= nil then
                return #hairs_list["female"][name]
            end
        end
    else
        if IsPedMale(PlayerPedId()) then
            if ComponentsMale[name] ~= nil then
                return #ComponentsMale[name]
            end
        else
            if ComponentsFemale[name] ~= nil then
                return #ComponentsFemale[name]
            end
        end
    end
end)
exports('GetMaxTexturesForModel', function(category , model)
    return GetMaxTexturesForModel(category,model)
end)