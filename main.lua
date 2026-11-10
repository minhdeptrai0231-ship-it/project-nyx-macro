-- // NYX MACRO v9 (UNIFIED TOP BAR + SEQUENTIAL WEBHOOK QUEUE + ULTRA LITE UI)
if not game:IsLoaded() then
    pcall(function() game.Loaded:Wait() end)
end

local Env = (getgenv and getgenv()) or _G
if Env.NyXDetectorEnv and type(Env.NyXDetectorEnv.Cleanup) == 'function' then
    pcall(Env.NyXDetectorEnv.Cleanup)
end

local function SafeService(name)
    local ok, svc = pcall(function() return game:GetService(name) end)
    if ok and svc then
        if type(cloneref) == 'function' then
            local cOk, cSvc = pcall(cloneref, svc)
            if cOk and cSvc then return cSvc end
        end
        return svc
    end
    return nil
end

local Svc = {
    Players = SafeService('Players'),
    ReplicatedStorage = SafeService('ReplicatedStorage'),
    HttpService = SafeService('HttpService'),
    VirtualUser = SafeService('VirtualUser'),
    VirtualInputManager = SafeService('VirtualInputManager'),
    GuiService = SafeService('GuiService'),
    Workspace = SafeService('Workspace'),
    CoreGui = SafeService('CoreGui'),
    UserInputService = SafeService('UserInputService'),
    TextChatService = SafeService('TextChatService'),
    Lighting = SafeService('Lighting'),
    RunService = SafeService('RunService'),
    TeleportService = SafeService('TeleportService'),
    PathfindingService = SafeService('PathfindingService'),
    SoundService = SafeService('SoundService'),
    LogService = SafeService('LogService')
}

local LocalPlayer = Svc.Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.2)
    LocalPlayer = Svc.Players.LocalPlayer
end

local AccountUsername = tostring(LocalPlayer.Name or 'Unknown')
local Notify = function() end

Env.NyXDetectorEnv = {
    Running = true,
    Connections = {}
}
local NyXEnv = Env.NyXDetectorEnv

local function TrackConnection(conn)
    if conn then
        table.insert(NyXEnv.Connections, conn)
    end
    return conn
end

local function ClearTable(t)
    if type(table.clear) == 'function' then
        table.clear(t)
    else
        for k in pairs(t) do t[k] = nil end
    end
end

-- // 19 Biomes & 4 Merchants Data
local DefaultIcon = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'
local BiomeData = {
    ['NORMAL'] = {Color = 0xAAAAAA, Hex = Color3.fromRGB(80, 250, 123), Image = 'https://static.wikia.nocookie.net/sol-rng/images/c/c9/Daytime_img.png/revision/latest/scale-to-width-down/1000?cb=20241116044859'}, 
    ['WINDY'] = {Color = 0x55FFFF, Hex = Color3.fromRGB(85, 255, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/b/b0/Windy03.10.26.gif/revision/latest?cb=20261003094316'}, 
    ['SNOWY'] = {Color = 0xAAFFFF, Hex = Color3.fromRGB(170, 255, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/1/1f/SnowyBiomeInGame.gif/revision/latest?cb=20261003145146'}, 
    ['RAINY'] = {Color = 0x4477FF, Hex = Color3.fromRGB(68, 119, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/6/65/Rainy03.10.2026.gif/revision/latest?cb=20261003094418'}, 
    ['SANDSTORM'] = {Color = 0xCC9955, Hex = Color3.fromRGB(235, 180, 90), Image = 'https://static.wikia.nocookie.net/sol-rng/images/7/7c/Sand_Storm.png/revision/latest/scale-to-width-down/1000?cb=20241229095728'}, 
    ['HELL'] = {Color = 0xFF3300, Hex = Color3.fromRGB(255, 65, 35), Image = 'https://static.wikia.nocookie.net/sol-rng/images/2/28/Hell_Updated_03.10.26.gif/revision/latest?cb=20261003093055'}, 
    ['STARFALL'] = {Color = 0x2266FF, Hex = Color3.fromRGB(80, 140, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/c/cd/0-3-10-26.Starfall.gif/revision/latest?cb=20261003091407'}, 
    ['HEAVEN'] = {Color = 0xFFEEAA, Hex = Color3.fromRGB(255, 238, 170), Image = 'https://static.wikia.nocookie.net/sol-rng/images/c/c3/Heaven03.10.26.gif/revision/latest?cb=20261003094940'}, 
    ['LOST FOREST'] = {Color = 0x33FF33, Hex = Color3.fromRGB(51, 255, 51), Image = 'https://static.wikia.nocookie.net/sol-rng/images/9/9c/LostForest.gif/revision/latest?cb=20261022114232'}, 
    ['CORRUPTION'] = {Color = 0x8833FF, Hex = Color3.fromRGB(165, 90, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/f/f9/CorruptionBiomeUpdated03.10.26.gif/revision/latest?cb=20261003094031'}, 
    ['NULL'] = {Color = 0x777777, Hex = Color3.fromRGB(160, 160, 160), Image = 'https://static.wikia.nocookie.net/sol-rng/images/6/66/NullBiome.gif/revision/latest?cb=20261003110602'}, 
    ['GLITCHED'] = {Color = 0x228855, Hex = Color3.fromRGB(60, 220, 140), Image = 'https://static.wikia.nocookie.net/sol-rng/images/5/58/GlitchedNew.png/revision/latest/scale-to-width-down/1000?cb=20260730105915'}, 
    ['DREAMSPACE'] = {Color = 0xFF66CC, Hex = Color3.fromRGB(255, 102, 204), Image = 'https://static.wikia.nocookie.net/sol-rng/images/4/48/Dreamspace_Biome.png/revision/latest/scale-to-width-down/1000?cb=20260730105754'}, 
    ['CYBERSPACE'] = {Color = 0x2255AA, Hex = Color3.fromRGB(70, 150, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/e/e9/CyberspaceNew.png/revision/latest/scale-to-width-down/1000?cb=20260730105943'}, 
    ['SINGULARITY'] = {Color = 0xFF9955, Hex = Color3.fromRGB(255, 153, 85), Image = 'https://static.wikia.nocookie.net/sol-rng/images/f/f7/SingularityBiome.png/revision/latest/scale-to-width-down/1000?cb=20260426050520'}, 
    ['THE RADIANT FOREST'] = {Color = 0xCC33FF, Hex = Color3.fromRGB(204, 51, 255), Image = 'https://static.wikia.nocookie.net/sol-rng/images/8/8b/RadiantForestTitle.png/revision/latest/scale-to-width-down/1000?cb=20261019232543'},
    ['PUMPKIN MOON'] = {Color = 0xFF7518, Hex = Color3.fromRGB(255, 130, 40), Image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDgCzF50SLarCAQvZtVR1akkeSXyZMnGNpLQdvbkP4GFZUN-rQIVficu0&s=10'}, 
    ['GRAVEYARD'] = {Color = 0x7F8C8D, Hex = Color3.fromRGB(165, 185, 200), Image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1HV0UIv5liHzxgu6T3J_FssdTGgpOeVfZQKzRuQmHOXYYq9dh17rCUgY&s=10'}, 
    ['BLOOD RAIN'] = {Color = 0x8B0000, Hex = Color3.fromRGB(220, 40, 55), Image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRilwE7ITj3ty_HWR7QmbEZRKEdBFVic58hAZt6RzarNg&s'}
}

local NormalizedBiomeLookup = {
    ['NORMAL'] = 'NORMAL', ['WINDY'] = 'WINDY', ['SNOWY'] = 'SNOWY', ['RAINY'] = 'RAINY',
    ['SANDSTORM'] = 'SANDSTORM', ['SANDY'] = 'SANDSTORM', ['HELL'] = 'HELL', ['STARFALL'] = 'STARFALL',
    ['HEAVEN'] = 'HEAVEN', ['LOSTFOREST'] = 'LOST FOREST', ['CORRUPTION'] = 'CORRUPTION', ['CORRUPTED'] = 'CORRUPTION',
    ['NULL'] = 'NULL', ['GLITCHED'] = 'GLITCHED', ['GLITCH'] = 'GLITCHED', ['DREAMSPACE'] = 'DREAMSPACE',
    ['CYBERSPACE'] = 'CYBERSPACE', ['SINGULARITY'] = 'SINGULARITY',
    ['THERADIANTFOREST'] = 'THE RADIANT FOREST', ['RADIANTFOREST'] = 'THE RADIANT FOREST',
    ['PUMPKINMOON'] = 'PUMPKIN MOON', ['GRAVEYARD'] = 'GRAVEYARD', ['BLOODRAIN'] = 'BLOOD RAIN'
}

local All19Biomes = {
    'NORMAL', 'WINDY', 'SNOWY', 'RAINY', 'SANDSTORM', 'HELL', 
    'STARFALL', 'HEAVEN', 'LOST FOREST', 'CORRUPTION', 'NULL', 
    'GLITCHED', 'DREAMSPACE', 'CYBERSPACE', 'SINGULARITY', 'THE RADIANT FOREST',
    'PUMPKIN MOON', 'GRAVEYARD', 'BLOOD RAIN'
}

local All4Merchants = {'Mari', 'Jester', 'Rin', 'Sinister S.'}
local MerchantData = {
    ['Mari'] = {Color = 0x2ECC71, Image = https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR58Oq3eDhzyAT-bzed3b_4Mp9ylpaSn8EhSDCvvZJvBg&s=10},
    ['Jester'] = {Color = 0x9B59B6, Image = https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRnYiHseVh0504lCdb6dOQXFBpteEH78GmEIirpIgnJw&s},
    ['Rin'] = {Color = 0x3498DB, Image = https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZshiymNKoc--z86qlunk6znxZj98EGfIviKWbi7FOxQ&s},
    ['Sinister S.'] = {Color = 0xE67E22, Image = https://static.wikia.nocookie.net/sol-rng/images/6/66/Sinister_S._Model.png/revision/latest?cb=20261031083112}
}

-- // Config & State
Env.NyXConfig = Env.NyXConfig or {
    WebhookURL = '',
    DiscordID = '',
    PrivateServerLink = '',
    MacroActive = false,
    AutoWalkToMerchant = false,
    RespawnIfMerchantLeft = false,
    AutoInteractMerchant = false,
    AutoCollectItems = false,
    AutoReconnect = true,
    BlackScreenSaver = false,
    AutoBiomeRandomizer = false,
    AutoStrangeController = false,
    UseInterval = 20,
    StopAutoBiomes = {
        ['GLITCHED'] = true, ['DREAMSPACE'] = true, ['CYBERSPACE'] = true,
        ['PUMPKIN MOON'] = false, ['BLOOD RAIN'] = false
    },
    PingBiomes = {
        ['GLITCHED'] = true, ['DREAMSPACE'] = true, ['CYBERSPACE'] = true,
        ['PUMPKIN MOON'] = false, ['GRAVEYARD'] = false, ['BLOOD RAIN'] = false
    },
    PingMerchants = {
        ['Mari'] = false, ['Jester'] = false, ['Rin'] = false, ['Sinister S.'] = false
    },
    CurrentDetectedBiome = 'NORMAL',
    CurrentMerchant = 'NONE',
    MerchantSpawnTimestamp = 0,
    MerchantDuration = 180,
    MerchantPosition = nil,
    GraveyardActive = false,
    GraveyardStartTimestamp = 0,
    GraveyardElapsed = 0,
    SinisterTriggeredInGraveyard = false,
    LogGlitchedTimestamp = 0,
    AntiAFK = true,
    Disable3DRendering = false,
    LockUIPosition = false,
    EnableSoundAlert = true,
    WalkSpeedBoost = false,
    CustomWalkSpeed = 24,
    UIAccentColor = Color3.fromRGB(110, 165, 255),
    GlassTransparency = 0.1,
    UIScalePercent = 90
}
local NyXConfig = Env.NyXConfig

for _, bName in ipairs(All19Biomes) do
    if NyXConfig.PingBiomes[bName] == nil then NyXConfig.PingBiomes[bName] = false end
    if NyXConfig.StopAutoBiomes[bName] == nil then NyXConfig.StopAutoBiomes[bName] = false end
end
for _, mName in ipairs(All4Merchants) do
    if NyXConfig.PingMerchants[mName] == nil then NyXConfig.PingMerchants[mName] = false end
end

local State = {
    MacroStartTime = 0,
    IsWalkingPath = false,
    CancelCurrentWalk = false,
    IsUsingInventory = false,
    CachedMerchantObj = nil,
    LastFullMerchantScan = 0,
    CachedBiomeLabels = {},
    LastGuiBiomeScan = 0,
    WebhookQueue = {},
    IsProcessingQueue = false,
    WebhookConfigFile = 'NyX_WebhookConfig.json',
    EmbedFooterText = 'Meowsollution Detector | Release Version 1'
}

local UI = {
    ScreenGui = nil,
    AccentObjects = {},
    DynamicAccentCallbacks = {},
    Pages = {},
    NavButtons = {}
}

local function PlayAlertSound()
    if not NyXConfig.EnableSoundAlert or not Svc.SoundService then return end
    pcall(function()
        local snd = Instance.new('Sound')
        snd.SoundId = 'rbxassetid://4590657391'
        snd.Volume = 2
        snd.Parent = Svc.SoundService
        snd:Play()
        task.delay(3, function()
            if snd and snd.Parent then snd:Destroy() end
        end)
    end)
end

-- // Save / Load Config
local function SaveWebhookConfig()
    if type(writefile) == 'function' then
        pcall(function()
            local data = {
                WebhookURL = NyXConfig.WebhookURL,
                DiscordID = NyXConfig.DiscordID,
                PrivateServerLink = NyXConfig.PrivateServerLink,
                PingBiomes = NyXConfig.PingBiomes,
                PingMerchants = NyXConfig.PingMerchants
            }
            writefile(State.WebhookConfigFile, Svc.HttpService:JSONEncode(data))
        end)
    end
end

local function LoadWebhookConfig()
    if type(isfile) == 'function' and type(readfile) == 'function' then
        pcall(function()
            if isfile(State.WebhookConfigFile) then
                local decoded = Svc.HttpService:JSONDecode(readfile(State.WebhookConfigFile))
                if type(decoded) == 'table' then
                    NyXConfig.WebhookURL = tostring(decoded.WebhookURL or ''):gsub('%s+', '')
                    NyXConfig.DiscordID = tostring(decoded.DiscordID or ''):gsub('%D+', '')
                    NyXConfig.PrivateServerLink = tostring(decoded.PrivateServerLink or '')
                    if type(decoded.PingBiomes) == 'table' then
                        for k, v in pairs(decoded.PingBiomes) do NyXConfig.PingBiomes[k] = v end
                    end
                    if type(decoded.PingMerchants) == 'table' then
                        for k, v in pairs(decoded.PingMerchants) do NyXConfig.PingMerchants[k] = v end
                    end
                end
            end
        end)
    end
end
LoadWebhookConfig()

-- // Anti-AFK & Auto-Reconnect
pcall(function()
    TrackConnection(LocalPlayer.Idled:Connect(function()
        if not NyXEnv.Running or not NyXConfig.AntiAFK or not Svc.VirtualUser then return end
        pcall(function()
            Svc.VirtualUser:CaptureController()
            Svc.VirtualUser:ClickButton2(Vector2.new(0, 0))
            local cam = Svc.Workspace.CurrentCamera
            if cam then
                Svc.VirtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
                task.wait(1)
                Svc.VirtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
            end
        end)
    end))
end)

pcall(function()
    if Svc.GuiService then
        TrackConnection(Svc.GuiService.ErrorMessageChanged:Connect(function()
            if NyXEnv.Running and NyXConfig.AutoReconnect and Svc.TeleportService then
                task.wait(3)
                Svc.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end))
    end
end)

local function GetMacroUptime(forcedElapsed)
    local elapsed = forcedElapsed
    if not elapsed then
        if not NyXConfig.MacroActive or State.MacroStartTime == 0 then
            return '00:00:00'
        end
        elapsed = math.floor(os.time() - State.MacroStartTime)
    end
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    return string.format('%02d:%02d:%02d', hours, mins, secs)
end

local function FormatMMSS(totalSeconds)
    local s = math.max(0, math.floor(totalSeconds or 0))
    return string.format('%02d:%02d', math.floor(s / 60), s % 60)
end

local function CleanRichText(str)
    if type(str) ~= 'string' then return '' end
    local s = str:gsub('<[^>]+>', '')
    return s:gsub('^%s+', ''):gsub('%s+$', '')
end

-- ==========================================
-- // SEQUENTIAL WEBHOOK QUEUE (FIXES ENDED/STARTED ORDER BUG)
-- ==========================================
local function GetDiscordTimestampLine(customTime)
    local t = customTime or os.time()
    return string.format('<t:%d:T> ( <t:%d:R> )', t, t)
end

local function GetFormattedPrivateServer()
    local link = tostring(NyXConfig.PrivateServerLink or ''):gsub('^%s+', ''):gsub('%s+$', '')
    return (link ~= '') and link or 'None'
end

local function BuildUserPingContent(shouldPing)
    if not shouldPing then return '' end
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    return (cleanID ~= '') and ('<@' .. cleanID .. '>') or ''
end

-- Hàng đợi gửi tuần tự: gói tin trước (Biome Ended) phải gửi xong hoàn tất mới gửi gói tin sau (Biome Started)
local function ProcessWebhookQueue()
    if State.IsProcessingQueue then return end
    State.IsProcessingQueue = true
    task.spawn(function()
        while #State.WebhookQueue > 0 do
            local item = table.remove(State.WebhookQueue, 1)
            local cleanUrl = tostring(NyXConfig.WebhookURL or ''):gsub('%s+', '')
            local req = (syn and syn.request) or http_request or request
            if cleanUrl ~= '' and type(req) == 'function' then
                pcall(function()
                    req({
                        Url = cleanUrl,
                        Method = 'POST',
                        Headers = {['Content-Type'] = 'application/json'},
                        Body = Svc.HttpService:JSONEncode(item)
                    })
                end)
                -- Nghỉ 0.35s giữa 2 gói tin liên tiếp để Discord sắp xếp đúng thứ tự thời gian tuyệt đối
                if #State.WebhookQueue > 0 then
                    task.wait(0.35)
                end
            end
        end
        State.IsProcessingQueue = false
    end)
end

local function SendRawWebhook(payload)
    local cleanUrl = tostring(NyXConfig.WebhookURL or ''):gsub('%s+', '')
    if cleanUrl == '' then return end
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    payload['allowed_mentions'] = {
        ['parse'] = {'users', 'everyone'},
        ['users'] = cleanID ~= '' and {cleanID} or {}
    }
    table.insert(State.WebhookQueue, payload)
    ProcessWebhookQueue()
end

local function SendTestWebhookEmbed(withUserPing)
    local contentMsg = BuildUserPingContent(withUserPing)
    local desc = table.concat({
        GetDiscordTimestampLine(),
        '**Username**',
        '`' .. AccountUsername .. '`',
        '**Private Server**',
        GetFormattedPrivateServer()
    }, '\n')

    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = withUserPing and 'Ping With User ID - Successfully' or 'Webhook Test - Successfully',
            ['description'] = desc,
            ['color'] = 0x2ECC71,
            ['footer'] = {['text'] = State.EmbedFooterText}
        }}
    })
end

local function SendMacroStateEmbed(isStarted, finalElapsed)
    if isStarted then
        local desc = table.concat({
            GetDiscordTimestampLine(),
            '**Username**',
            '`' .. AccountUsername .. '`',
            '**Private Server**',
            GetFormattedPrivateServer()
        }, '\n')

        SendRawWebhook({
            ['content'] = '',
            ['embeds'] = {{
                ['title'] = 'Macro Started',
                ['description'] = desc,
                ['color'] = 0x00FF88,
                ['footer'] = {['text'] = State.EmbedFooterText}
            }}
        })
    else
        local uptimeStr = GetMacroUptime(finalElapsed or 0)
        local desc = table.concat({
            GetDiscordTimestampLine(),
            '**Username**',
            '`' .. AccountUsername .. '`',
            '**Total Uptime**',
            '`' .. uptimeStr .. '`'
        }, '\n')

        SendRawWebhook({
            ['content'] = '',
            ['embeds'] = {{
                ['title'] = 'Macro Stopped',
                ['description'] = desc,
                ['color'] = 0xFF3344,
                ['footer'] = {['text'] = State.EmbedFooterText}
            }}
        })
    end
end

local function SendBiomeEndedEmbed(biomeName, color, imageUrl, customTimestamp)
    local displayBiome = (biomeName == 'SANDSTORM') and 'SAND STORM' or biomeName
    local desc = table.concat({
        GetDiscordTimestampLine(customTimestamp),
        '**Username**',
        '`' .. AccountUsername .. '`'
    }, '\n')

    SendRawWebhook({
        ['content'] = '',
        ['embeds'] = {{
            ['title'] = 'Biome Ended - ' .. displayBiome,
            ['description'] = desc,
            ['color'] = color or 0x555555,
            ['thumbnail'] = {['url'] = imageUrl},
            ['footer'] = {['text'] = State.EmbedFooterText}
        }}
    })
end

local function SendBiomeStartedEmbed(biomeName, color, imageUrl, customTimestamp)
    local shouldPing = NyXConfig.PingBiomes[biomeName] == true
    local contentMsg = BuildUserPingContent(shouldPing)
    local displayBiome = (biomeName == 'SANDSTORM') and 'SAND STORM' or biomeName

    local desc = table.concat({
        GetDiscordTimestampLine(customTimestamp),
        '**Username**',
        '`' .. AccountUsername .. '`',
        '**Private Server**',
        GetFormattedPrivateServer()
    }, '\n')

    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = 'Biome Started - ' .. displayBiome,
            ['description'] = desc,
            ['color'] = color or 0xCC9955,
            ['thumbnail'] = {['url'] = imageUrl},
            ['footer'] = {['text'] = State.EmbedFooterText}
        }}
    })
end

local function SendMerchantArrivedEmbed(merchantName)
    if not NyXConfig.MacroActive then return end
    local mInfo = MerchantData[merchantName] or {Color = 0xF1C40F, Image = DefaultIcon}
    local shouldPing = NyXConfig.PingMerchants[merchantName] == true
    local contentMsg = BuildUserPingContent(shouldPing)
    local embedTitle = (merchantName == 'Sinister S.') and 'Sinister S. has spawned' or ('Merchant Arrived - ' .. merchantName:upper())

    local desc = table.concat({
        GetDiscordTimestampLine(),
        '**Username**',
        '`' .. AccountUsername .. '`',
        '**Private Server**',
        GetFormattedPrivateServer()
    }, '\n')

    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = embedTitle,
            ['description'] = desc,
            ['color'] = mInfo.Color,
            ['thumbnail'] = {['url'] = mInfo.Image},
            ['footer'] = {['text'] = State.EmbedFooterText}
        }}
    })
end

-- ==========================================
-- // CONSOLE LOG READER FOR GLITCHED BIOME
-- ==========================================
local function InspectLogStringForGlitched(msg)
    if type(msg) ~= 'string' or msg == '' then return end
    local upper = msg:upper()
    if upper:find('NYX') or upper:find('WEBHOOK') then return end

    if upper:find('%[%s*GLITCHED%s*%]')
       or upper:find('BIOME:%s*GLITCHED')
       or upper:find('CURRENTBIOME:%s*GLITCHED')
       or upper:find('"BIOME"%s*:%s*"GLITCHED"')
       or upper:find('01000111%s*01001100%s*01001001%s*01010100')
       or (upper:find('GLITCHED') and (upper:find('BIOME') or upper:find('SPAWN') or upper:find('WEATHER') or upper:find('MAP'))) then
        NyXConfig.LogGlitchedTimestamp = os.time()
    elseif upper:find('BIOME') and (upper:find('NORMAL') or upper:find('ENDED')) and NyXConfig.LogGlitchedTimestamp > 0 then
        NyXConfig.LogGlitchedTimestamp = 0
    end
end

pcall(function()
    if Svc.LogService then
        TrackConnection(Svc.LogService.MessageOut:Connect(function(message)
            if not NyXEnv.Running then return end
            InspectLogStringForGlitched(message)
        end))

        task.spawn(function()
            pcall(function()
                local history = Svc.LogService:GetLogHistory()
                if type(history) == 'table' then
                    local startIdx = math.max(1, #history - 30)
                    for i = startIdx, #history do
                        local entry = history[i]
                        if entry and entry.message then
                            InspectLogStringForGlitched(entry.message)
                        end
                    end
                end
            end)
        end)
    end
end)

-- ==========================================
-- // SMART PATHFINDING + 4-LAYER ANTI-STUCK JUMP
-- ==========================================
local function RespawnCharacterSafely()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if hum then hum.Health = 0 end
    end)
end

local function ForceCharacterJump(hum)
    if not hum then return end
    pcall(function()
        hum.Jump = true
        local st = hum:GetState()
        if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function HasObstacleInFront(char, root, targetPos)
    local hitObstacle = false
    pcall(function()
        local flatDir = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
        flatDir = (flatDir.Magnitude < 0.1) and root.CFrame.LookVector or flatDir.Unit

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        for _, yOffset in ipairs({-1.8, -0.8, 0.5}) do
            local origin = root.Position + Vector3.new(0, yOffset, 0)
            local result = Svc.Workspace:Raycast(origin, flatDir * 4.2, rayParams)
            if result and result.Instance and result.Instance.CanCollide then
                hitObstacle = true
                return
            end
        end
    end)
    return hitObstacle
end

local function MatchMerchantFromObject(obj)
    if not obj or not obj.Parent then return nil, nil, nil end
    if obj:IsA('ProximityPrompt') then
        local combined = (obj.ObjectText .. ' ' .. obj.ActionText .. ' ' .. (obj.Parent and obj.Parent.Name or '') .. ' ' .. (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name or '')):upper()
        local mName = nil
        if combined:find('SINISTER') then mName = 'Sinister S.'
        elseif combined:find('%f[%a]JESTER%f[%A]') then mName = 'Jester'
        elseif combined:find('%f[%a]RIN%f[%A]') then mName = 'Rin'
        elseif combined:find('%f[%a]MARI%f[%A]') then mName = 'Mari' end
        if mName then
            local part = obj:FindFirstAncestorWhichIsA('BasePart') or (obj.Parent and obj.Parent:IsA('Model') and obj.Parent.PrimaryPart)
            if part then return mName, part.Position, obj end
        end
    elseif obj:IsA('Model') then
        local n = obj.Name:upper()
        local mName = nil
        if n:find('SINISTER') then mName = 'Sinister S.'
        elseif n == 'JESTER' or n == 'MERCHANT_JESTER' or n == 'JESTERNPC' then mName = 'Jester'
        elseif n == 'RIN' or n == 'MERCHANT_RIN' or n == 'RINNPC' then mName = 'Rin'
        elseif n == 'MARI' or n == 'MERCHANT_MARI' or n == 'MARINPC' then mName = 'Mari' end
        if mName then
            local ok, pivot = pcall(function() return obj:GetPivot() end)
            if ok and pivot then
                return mName, pivot.Position, obj:FindFirstChildWhichIsA('ProximityPrompt', true)
            end
        end
    end
    return nil, nil, nil
end

pcall(function()
    TrackConnection(Svc.Workspace.DescendantAdded:Connect(function(obj)
        if not NyXEnv.Running then return end
        if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
            task.defer(function()
                local mName = MatchMerchantFromObject(obj)
                if mName then State.CachedMerchantObj = obj end
            end)
        end
    end))
end)

local function FindMerchantWorldPosition(forceScan)
    if State.CachedMerchantObj and State.CachedMerchantObj.Parent and State.CachedMerchantObj:IsDescendantOf(Svc.Workspace) then
        local mName, mPos, mPrompt = MatchMerchantFromObject(State.CachedMerchantObj)
        if mName and mPos then return mName, mPos, mPrompt end
    end
    State.CachedMerchantObj = nil

    local now = os.clock()
    if not forceScan and (now - State.LastFullMerchantScan) < 25 then
        return nil, nil, nil
    end
    State.LastFullMerchantScan = now

    local foundName, foundPos, foundPrompt = nil, nil, nil
    pcall(function()
        for _, obj in ipairs(Svc.Workspace:GetDescendants()) do
            if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
                local mName, mPos, mPrompt = MatchMerchantFromObject(obj)
                if mName and mPos then
                    State.CachedMerchantObj = obj
                    foundName, foundPos, foundPrompt = mName, mPos, mPrompt
                    return
                end
            end
        end
    end)
    return foundName, foundPos, foundPrompt
end

local function IsWaypointOverWaterOrVoid(pos)
    local isHazard = false
    pcall(function()
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = Svc.Workspace:Raycast(pos + Vector3.new(0, 6, 0), Vector3.new(0, -35, 0), rayParams)
        if not result or result.Material == Enum.Material.Water then
            isHazard = true
        else
            local hitName = result.Instance.Name:upper()
            if hitName:find('WATER') or hitName:find('RIVER') or hitName:find('KILL') or hitName:find('VOID') then
                isHazard = true
            end
        end
    end)
    return isHazard
end

local function MoveToSinglePointSmart(char, hum, root, pointPos, requireJump, stopConditionFunc)
    if requireJump or (pointPos.Y - root.Position.Y) > 1.5 or IsWaypointOverWaterOrVoid(pointPos) or HasObstacleInFront(char, root, pointPos) then
        ForceCharacterJump(hum)
    end

    hum:MoveTo(pointPos)
    local stepStart = os.clock()
    local lastCheckTime = os.clock()
    local lastCheckPos = root.Position
    local stuckStrikes = 0

    while (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(pointPos.X, 0, pointPos.Z)).Magnitude > 3.6
          and (os.clock() - stepStart) < 2.6 do
        if not NyXEnv.Running or State.CancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
        if not char.Parent or hum.Health <= 0 then break end

        if HasObstacleInFront(char, root, pointPos) or (pointPos.Y - root.Position.Y) > 1.6 then
            ForceCharacterJump(hum)
        end

        if (os.clock() - lastCheckTime) >= 0.3 then
            local movedDist = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(lastCheckPos.X, 0, lastCheckPos.Z)).Magnitude
            lastCheckTime = os.clock()
            lastCheckPos = root.Position

            if movedDist < 0.85 then
                stuckStrikes = stuckStrikes + 1
                ForceCharacterJump(hum)
                if stuckStrikes >= 2 then
                    local sideDir = root.CFrame.RightVector * ((stuckStrikes % 2 == 0) and 5 or -5)
                    local unstuckPos = root.Position - root.CFrame.LookVector * 2 + sideDir
                    ForceCharacterJump(hum)
                    hum:MoveTo(unstuckPos)
                    task.wait(0.22)
                    ForceCharacterJump(hum)
                    hum:MoveTo(pointPos)
                end
            else
                stuckStrikes = 0
            end
        end

        hum:MoveTo(pointPos)
        task.wait(0.08)
    end
end

local function WalkSafelyToTargetPosition(targetPos, stopConditionFunc, isHighPriority)
    if not targetPos then return false end
    if State.IsWalkingPath then
        if isHighPriority then
            State.CancelCurrentWalk = true
            local waitStart = os.clock()
            while State.IsWalkingPath and (os.clock() - waitStart) < 2.5 do
                task.wait(0.05)
            end
        end
        if State.IsWalkingPath then return false end
    end

    State.IsWalkingPath = true
    State.CancelCurrentWalk = false
    local reached = false

    local ok, _ = pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not hum or not root or hum.Health <= 0 then return end

        for _ = 1, 2 do
            if not NyXEnv.Running or State.CancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
            if (root.Position - targetPos).Magnitude <= 8 then
                reached = true
                break
            end

            local path = Svc.PathfindingService:CreatePath({
                AgentRadius = 2.0,
                AgentHeight = 5.0,
                AgentCanJump = true,
                WaypointSpacing = 3.5,
                Costs = {Water = math.huge, Danger = math.huge}
            })

            local computeOk = pcall(function() path:ComputeAsync(root.Position, targetPos) end)
            if computeOk and path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                for i, wp in ipairs(waypoints) do
                    if i > 1 then
                        if not NyXEnv.Running or State.CancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
                        if not char.Parent or hum.Health <= 0 then break end
                        MoveToSinglePointSmart(char, hum, root, wp.Position, wp.Action == Enum.PathWaypointAction.Jump, stopConditionFunc)
                        if (root.Position - targetPos).Magnitude <= 8 then
                            reached = true
                            break
                        end
                    end
                end
            else
                if not IsWaypointOverWaterOrVoid(targetPos) then
                    local t0 = os.clock()
                    while (root.Position - targetPos).Magnitude > 7 and (os.clock() - t0) < 9 do
                        if not NyXEnv.Running or State.CancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
                        if IsWaypointOverWaterOrVoid(root.Position + root.CFrame.LookVector * 5) then
                            ForceCharacterJump(hum)
                        end
                        MoveToSinglePointSmart(char, hum, root, targetPos, false, stopConditionFunc)
                        if (root.Position - targetPos).Magnitude <= 8 then
                            reached = true
                            break
                        end
                    end
                end
            end
            if reached then break end
        end
    end)

    State.IsWalkingPath = false
    State.CancelCurrentWalk = false
    return ok and reached or false
end

local function WalkToActiveMerchantNow()
    task.spawn(function()
        local mName, mPos, mPrompt = FindMerchantWorldPosition(true)
        if not mPos and NyXConfig.MerchantPosition then
            mPos = NyXConfig.MerchantPosition
            mName = NyXConfig.CurrentMerchant
        end
        if not mPos then
            Notify('Merchant', 'No active merchant found!', 2.5)
            return
        end
        Notify('Merchant', 'Walking to ' .. tostring(mName or 'Merchant') .. '...', 3)
        WalkSafelyToTargetPosition(mPos, function()
            return NyXConfig.CurrentMerchant == 'NONE'
        end, true)
        if NyXConfig.AutoInteractMerchant then
            if not mPrompt then _, _, mPrompt = FindMerchantWorldPosition(false) end
            if mPrompt and type(fireproximityprompt) == 'function' then
                pcall(function() fireproximityprompt(mPrompt) end)
            end
        end
    end)
end

-- ==========================================
-- // MERCHANT LIFECYCLE MANAGER
-- ==========================================
local function SetMerchantArrivedState(merchantName, worldPos, customDuration)
    local canonicalName = merchantName:upper():find('SINISTER') and 'Sinister S.' or merchantName
    if NyXConfig.CurrentMerchant == canonicalName:upper() then
        if worldPos then NyXConfig.MerchantPosition = worldPos end
        return
    end

    NyXConfig.CurrentMerchant = canonicalName:upper()
    NyXConfig.MerchantSpawnTimestamp = os.time()
    NyXConfig.MerchantDuration = customDuration or ((canonicalName == 'Sinister S.') and 360 or 180)
    NyXConfig.MerchantPosition = worldPos

    PlayAlertSound()
    SendMerchantArrivedEmbed(canonicalName)
    Notify('Merchant', canonicalName .. ' spawned!', 3.5)
    if NyXConfig.AutoWalkToMerchant and worldPos then
        WalkToActiveMerchantNow()
    end
end

local function SetMerchantLeftState(reason)
    if NyXConfig.CurrentMerchant == 'NONE' then return end
    local prevMerchant = NyXConfig.CurrentMerchant
    NyXConfig.CurrentMerchant = 'NONE'
    NyXConfig.MerchantSpawnTimestamp = 0
    NyXConfig.MerchantPosition = nil
    State.CachedMerchantObj = nil
    Notify('Merchant', prevMerchant .. ' left (' .. tostring(reason or 'Despawned') .. ')', 3.5)
    if NyXConfig.RespawnIfMerchantLeft then
        task.wait(0.8)
        RespawnCharacterSafely()
    end
end

-- ==========================================
-- // BIOME SCANNER
-- ==========================================
local function ParseStrictBiomeToken(rawText, requireBrackets)
    local clean = CleanRichText(rawText):upper()
    if clean == '' or #clean > 38 then return nil end
    local bracketInner = clean:match('^%[%s*(.-)%s*%]$')
    if bracketInner then
        return NormalizedBiomeLookup[bracketInner:gsub('[^A-Z]', '')]
    end
    if not requireBrackets then
        return NormalizedBiomeLookup[clean:gsub('[^A-Z]', '')]
    end
    return nil
end

local function IsValidHudBiomeLabel(v)
    if not v:IsA('TextLabel') or not v.Visible or v.Text == '' then return false end
    if UI.ScreenGui and v:IsDescendantOf(UI.ScreenGui) then return false end
    local pName = (v.Parent and v.Parent.Name or ''):upper()
    local gName = (v.Parent and v.Parent.Parent and v.Parent.Parent.Name or ''):upper()
    if pName:find('INVENTORY') or pName:find('CHAT') or pName:find('SHOP') or pName:find('QUEST')
       or gName:find('INVENTORY') or gName:find('CHAT') or gName:find('SHOP') or gName:find('COLLECTION') then
        return false
    end
    return true
end

local function GetAccurateServerBiome()
    local foundBiome = nil
    pcall(function()
        local candidates = {
            Svc.Workspace:GetAttribute('Biome'),
            Svc.Workspace:GetAttribute('CurrentBiome'),
            Svc.Workspace:GetAttribute('Weather'),
            Svc.ReplicatedStorage:GetAttribute('Biome'),
            Svc.ReplicatedStorage:GetAttribute('CurrentBiome'),
            Svc.Lighting:GetAttribute('Biome'),
            LocalPlayer:GetAttribute('Biome')
        }
        for _, val in ipairs(candidates) do
            if type(val) == 'string' and val ~= '' then
                local m = ParseStrictBiomeToken(val, false)
                if m then foundBiome = m return end
            end
        end
    end)
    if foundBiome and foundBiome ~= 'NORMAL' then return foundBiome end

    pcall(function()
        for _, root in ipairs({Svc.ReplicatedStorage, Svc.Workspace, Svc.Lighting}) do
            for _, obj in ipairs(root:GetChildren()) do
                if obj:IsA('StringValue') then
                    local n = obj.Name:upper()
                    if n == 'BIOME' or n == 'CURRENTBIOME' or n == 'WEATHER' then
                        local m = ParseStrictBiomeToken(obj.Value, false)
                        if m then foundBiome = m return end
                    end
                end
            end
        end
    end)
    if foundBiome and foundBiome ~= 'NORMAL' then return foundBiome end

    pcall(function()
        for i = #State.CachedBiomeLabels, 1, -1 do
            local lbl = State.CachedBiomeLabels[i]
            if not lbl or not lbl.Parent then
                table.remove(State.CachedBiomeLabels, i)
            elseif lbl.Visible and lbl.Text ~= '' then
                local bMatch = ParseStrictBiomeToken(lbl.Text, true) or ParseStrictBiomeToken(lbl.Text, false)
                if bMatch then
                    foundBiome = bMatch
                    if bMatch ~= 'NORMAL' then return end
                end
            end
        end
    end)
    if foundBiome and foundBiome ~= 'NORMAL' then return foundBiome end

    if NyXConfig.LogGlitchedTimestamp > 0 and (os.time() - NyXConfig.LogGlitchedTimestamp) <= 160 then
        return 'GLITCHED'
    end
    if foundBiome then return foundBiome end

    local now = os.clock()
    if (now - State.LastGuiBiomeScan) < 15 then return 'NORMAL' end
    State.LastGuiBiomeScan = now

    pcall(function()
        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end
        local bracketedMatch, exactHudLabelMatch = nil, nil
        ClearTable(State.CachedBiomeLabels)
        for _, v in ipairs(pGui:GetDescendants()) do
            if IsValidHudBiomeLabel(v) then
                local bMatch = ParseStrictBiomeToken(v.Text, true)
                local lblName = v.Name:upper()
                local isNamedBiome = (lblName == 'BIOME' or lblName == 'BIOMELABEL' or lblName == 'BIOMETEXT' or lblName == 'CURRENTBIOME')
                if bMatch then
                    table.insert(State.CachedBiomeLabels, v)
                    bracketedMatch = bMatch
                elseif isNamedBiome then
                    table.insert(State.CachedBiomeLabels, v)
                    local eMatch = ParseStrictBiomeToken(v.Text, false)
                    if eMatch then exactHudLabelMatch = eMatch end
                end
            end
        end
        foundBiome = bracketedMatch or exactHudLabelMatch
    end)
    return foundBiome or 'NORMAL'
end

local function ParseMerchantSystemEvent(rawText)
    local clean = CleanRichText(rawText):upper()
    if clean == '' then return nil, nil end
    local mName = nil
    if clean:find('SINISTER') then mName = 'Sinister S.'
    elseif clean:find('%f[%a]JESTER%f[%A]') then mName = 'Jester'
    elseif clean:find('%f[%a]RIN%f[%A]') then mName = 'Rin'
    elseif clean:find('%f[%a]MARI%f[%A]') then mName = 'Mari' end
    if not mName then return nil, nil end
    if clean:find('HAS LEFT') or clean:find('DESPAWN') or clean:find('DEPARTED') or clean:find('GONE') then
        return mName, 'LEFT'
    elseif clean:find('HAS ARRIVED') or clean:find('HAS SPAWNED') or clean:find('APPEARED') then
        return mName, 'ARRIVED'
    end
    return nil, nil
end

pcall(function()
    if Svc.TextChatService and Svc.TextChatService.MessageReceived then
        TrackConnection(Svc.TextChatService.MessageReceived:Connect(function(message)
            if not NyXEnv.Running or message.TextSource ~= nil then return end
            local txt = (message.Text or '') .. ' ' .. (message.PrefixText or '')
            InspectLogStringForGlitched(txt)
            local mName, action = ParseMerchantSystemEvent(txt)
            if mName and action == 'ARRIVED' then
                local _, pos = FindMerchantWorldPosition(true)
                SetMerchantArrivedState(mName, pos)
            elseif mName and action == 'LEFT' then
                SetMerchantLeftState('System Chat Left')
            end
        end))
    end
end)

-- ==========================================
-- // SAFE AUTO INVENTORY
-- ==========================================
local function ClickGuiElement(guiObj)
    pcall(function()
        if type(getconnections) == 'function' then
            for _, conn in pairs(getconnections(guiObj.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(guiObj.Activated)) do conn:Fire() end
        end
        if type(firesignal) == 'function' then
            pcall(firesignal, guiObj.MouseButton1Click)
            pcall(firesignal, guiObj.Activated)
        end
        if Svc.VirtualInputManager and Svc.GuiService then
            local pos = guiObj.AbsolutePosition
            local size = guiObj.AbsoluteSize
            local inset = Svc.GuiService:GetGuiInset()
            local centerX = pos.X + (size.X / 2)
            local centerY = pos.Y + (size.Y / 2) + inset.Y
            Svc.VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
            task.wait(0.06)
            Svc.VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        end
    end)
end

local function UseItemWithInventoryFailsafe(itemName)
    if State.IsUsingInventory then return end
    State.IsUsingInventory = true

    pcall(function()
        local Remotes = Svc.ReplicatedStorage:FindFirstChild('Remotes') or Svc.ReplicatedStorage:FindFirstChild('Events')
        if Remotes then
            local exactRemote = Remotes:FindFirstChild('UseItem') or Remotes:FindFirstChild('ItemUse')
            if exactRemote and exactRemote:IsA('RemoteEvent') then
                pcall(function() exactRemote:FireServer(itemName, 1) end)
            end
        end

        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end
        local invFrame = nil
        for _, v in pairs(pGui:GetDescendants()) do
            if not UI.ScreenGui or not v:IsDescendantOf(UI.ScreenGui) then
                if v:IsA('Frame') and (v.Name == 'Inventory' or v.Name == 'InventoryFrame' or v.Name == 'ItemsFrame') then
                    invFrame = v
                    break
                end
            end
        end
        local wasClosed = false
        if invFrame and not invFrame.Visible then
            wasClosed = true
            invFrame.Visible = true
            task.wait(0.25)
        elseif not invFrame then
            for _, btn in pairs(pGui:GetDescendants()) do
                if not UI.ScreenGui or not btn:IsDescendantOf(UI.ScreenGui) then
                    if (btn:IsA('TextButton') or btn:IsA('ImageButton')) and (btn.Name:lower():find('inv') or (btn:IsA('TextButton') and btn.Text:lower():find('inventory'))) then
                        wasClosed = true
                        ClickGuiElement(btn)
                        task.wait(0.35)
                        break
                    end
                end
            end
        end
        for _, box in pairs(pGui:GetDescendants()) do
            if not UI.ScreenGui or not box:IsDescendantOf(UI.ScreenGui) then
                if box:IsA('TextBox') and box.Visible and (box.PlaceholderText:lower():find('search') or box.Name:lower():find('search')) then
                    box.Text = itemName
                    task.wait(0.2)
                    break
                end
            end
        end
        local foundItemSlot = nil
        for _, lbl in pairs(pGui:GetDescendants()) do
            if not UI.ScreenGui or not lbl:IsDescendantOf(UI.ScreenGui) then
                if lbl:IsA('TextLabel') and lbl.Visible and string.find(CleanRichText(lbl.Text):lower(), itemName:lower(), 1, true) then
                    local clickableParent = lbl:FindFirstAncestorWhichIsA('TextButton') or lbl:FindFirstAncestorWhichIsA('ImageButton') or lbl.Parent
                    if clickableParent then
                        foundItemSlot = clickableParent
                        ClickGuiElement(clickableParent)
                        task.wait(0.25)
                        break
                    end
                end
            end
        end
        if foundItemSlot then
            for _, btn in pairs(pGui:GetDescendants()) do
                if not UI.ScreenGui or not btn:IsDescendantOf(UI.ScreenGui) then
                    if (btn:IsA('TextButton') or btn:IsA('ImageButton')) and btn.Visible then
                        local txt = btn:IsA('TextButton') and CleanRichText(btn.Text):upper() or ''
                        local bName = btn.Name:upper()
                        if txt == 'USE' or string.find(txt, 'USE ') or bName == 'USEBUTTON' or bName == 'USE' then
                            ClickGuiElement(btn)
                            task.wait(0.2)
                            break
                        end
                    end
                end
            end
        end
        if wasClosed and invFrame then invFrame.Visible = false end
    end)

    State.IsUsingInventory = false
end

-- ==========================================
-- // UNIFIED TOP BAR + CLEAN MINIMAL UI CREATION
-- ==========================================
local ParentGui = nil
pcall(function()
    if type(gethui) == 'function' then ParentGui = gethui() end
end)
if not ParentGui then
    local okCore, cGui = pcall(function() return Svc.CoreGui end)
    ParentGui = (okCore and cGui) or LocalPlayer:WaitForChild('PlayerGui')
end
pcall(function()
    if ParentGui:FindFirstChild('NyXMacroUI') then
        ParentGui.NyXMacroUI:Destroy()
    end
end)

UI.ScreenGui = Instance.new('ScreenGui')
UI.ScreenGui.Name = 'NyXMacroUI'
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.IgnoreGuiInset = true
UI.ScreenGui.DisplayOrder = 99999
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local parentOk = pcall(function() UI.ScreenGui.Parent = ParentGui end)
if not parentOk then
    UI.ScreenGui.Parent = LocalPlayer:WaitForChild('PlayerGui')
end

UI.BlackSaverFrame = Instance.new('Frame', UI.ScreenGui)
UI.BlackSaverFrame.Size = UDim2.new(1, 0, 1, 0)
UI.BlackSaverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.BlackSaverFrame.BorderSizePixel = 0
UI.BlackSaverFrame.Visible = NyXConfig.BlackScreenSaver
UI.BlackSaverFrame.ZIndex = 1

local BlackSaverLabel = Instance.new('TextLabel', UI.BlackSaverFrame)
BlackSaverLabel.Size = UDim2.new(1, 0, 0, 30)
BlackSaverLabel.Position = UDim2.new(0, 0, 0.46, 0)
BlackSaverLabel.BackgroundTransparency = 1
BlackSaverLabel.Text = 'OLED SAVER'
BlackSaverLabel.Font = Enum.Font.GothamBold
BlackSaverLabel.TextSize = 13
BlackSaverLabel.TextColor3 = Color3.fromRGB(95, 100, 120)
BlackSaverLabel.ZIndex = 2

local function RegisterAccent(obj, prop)
    table.insert(UI.AccentObjects, {Obj = obj, Prop = prop})
    obj[prop] = NyXConfig.UIAccentColor
end

local function RegisterDynamicAccent(fn)
    table.insert(UI.DynamicAccentCallbacks, fn)
end

local function UpdateAccentColor(newColor)
    NyXConfig.UIAccentColor = newColor
    for _, item in ipairs(UI.AccentObjects) do
        pcall(function() item.Obj[item.Prop] = newColor end)
    end
    for _, fn in ipairs(UI.DynamicAccentCallbacks) do
        pcall(fn, newColor)
    end
end

UI.ToastHolder = Instance.new('Frame', UI.ScreenGui)
UI.ToastHolder.Size = UDim2.new(0, 200, 1, -16)
UI.ToastHolder.Position = UDim2.new(1, -210, 0, 8)
UI.ToastHolder.BackgroundTransparency = 1
UI.ToastHolder.ZIndex = 20

local ToastLayout = Instance.new('UIListLayout', UI.ToastHolder)
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.Padding = UDim.new(0, 4)

Notify = function(title, text, duration)
    task.spawn(function()
        if not UI.ScreenGui or not UI.ScreenGui.Parent then return end
        local Card = Instance.new('Frame', UI.ToastHolder)
        Card.Size = UDim2.new(1, 0, 0, 38)
        Card.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
        Card.BackgroundTransparency = 0.08
        Card.BorderSizePixel = 0
        Card.ZIndex = 21
        Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

        local AccentLeft = Instance.new('Frame', Card)
        AccentLeft.Size = UDim2.new(0, 3, 1, -8)
        AccentLeft.Position = UDim2.new(0, 4, 0, 4)
        AccentLeft.BackgroundColor3 = NyXConfig.UIAccentColor
        AccentLeft.BorderSizePixel = 0
        AccentLeft.ZIndex = 22
        Instance.new('UICorner', AccentLeft).CornerRadius = UDim.new(1, 0)

        local Tbl = Instance.new('TextLabel', Card)
        Tbl.Size = UDim2.new(1, -16, 0, 14)
        Tbl.Position = UDim2.new(0, 12, 0, 3)
        Tbl.BackgroundTransparency = 1
        Tbl.Text = title
        Tbl.TextColor3 = Color3.fromRGB(245, 247, 255)
        Tbl.Font = Enum.Font.GothamBold
        Tbl.TextSize = 10
        Tbl.ZIndex = 22
        Tbl.TextXAlignment = Enum.TextXAlignment.Left

        local Sub = Instance.new('TextLabel', Card)
        Sub.Size = UDim2.new(1, -16, 0, 14)
        Sub.Position = UDim2.new(0, 12, 0, 18)
        Sub.BackgroundTransparency = 1
        Sub.Text = text
        Sub.TextColor3 = Color3.fromRGB(170, 180, 200)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 9
        Sub.TextTruncate = Enum.TextTruncate.AtEnd
        Sub.ZIndex = 22
        Sub.TextXAlignment = Enum.TextXAlignment.Left

        task.wait(duration or 2.5)
        if Card and Card.Parent then Card:Destroy() end
    end)
end

local function MakeDraggable(dragHandle, targetFrame, onClickCallback)
    local dragging, hasMoved, dragStart, startPos = false, false, nil, nil
    TrackConnection(dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = targetFrame.Position
        end
    end))
    TrackConnection(Svc.UserInputService.InputChanged:Connect(function(input)
        if dragging and not NyXConfig.LockUIPosition and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                hasMoved = true
                targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end))
    TrackConnection(Svc.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not hasMoved and onClickCallback then onClickCallback() end
            end
        end
    end))
end

-- // UNIFIED TOP BAR (Tích hợp [Biome | Merchant | Uptime | Nút Logo mở Full UI] đúng theo ảnh thiết kế)
local FallbackLogo = 'rbxassetid://18648155233'
UI.TopBar = Instance.new('Frame', UI.ScreenGui)
UI.TopBar.Name = 'UnifiedTopBar'
UI.TopBar.AnchorPoint = Vector2.new(0.5, 0)
UI.TopBar.Size = UDim2.new(0, 390, 0, 36)
UI.TopBar.Position = UDim2.new(0.5, 0, 0, 8)
UI.TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27)
UI.TopBar.BackgroundTransparency = 0.08
UI.TopBar.BorderSizePixel = 0
UI.TopBar.Active = true
UI.TopBar.ZIndex = 25
Instance.new('UICorner', UI.TopBar).CornerRadius = UDim.new(0, 8)

local TopBarStroke = Instance.new('UIStroke', UI.TopBar)
TopBarStroke.Thickness = 1.2
TopBarStroke.Transparency = 0.35
RegisterAccent(TopBarStroke, 'Color')

local function CreateTopBarCell(parent, xPosScale, widthScale, titleText, defaultValText)
    local Cell = Instance.new('Frame', parent)
    Cell.Size = UDim2.new(widthScale, 0, 1, 0)
    Cell.Position = UDim2.new(xPosScale, 0, 0, 0)
    Cell.BackgroundTransparency = 1
    Cell.ZIndex = 26

    local Hdr = Instance.new('TextLabel', Cell)
    Hdr.Size = UDim2.new(1, -12, 0, 11)
    Hdr.Position = UDim2.new(0, 8, 0, 4)
    Hdr.BackgroundTransparency = 1
    Hdr.Text = titleText
    Hdr.Font = Enum.Font.GothamBold
    Hdr.TextSize = 8
    Hdr.TextColor3 = Color3.fromRGB(140, 150, 175)
    Hdr.TextXAlignment = Enum.TextXAlignment.Left
    Hdr.ZIndex = 27

    local Val = Instance.new('TextLabel', Cell)
    Val.Size = UDim2.new(1, -12, 0, 16)
    Val.Position = UDim2.new(0, 8, 0, 16)
    Val.BackgroundTransparency = 1
    Val.Text = defaultValText
    Val.Font = Enum.Font.GothamBlack
    Val.TextSize = 11
    Val.TextColor3 = Color3.fromRGB(240, 245, 255)
    Val.TextTruncate = Enum.TextTruncate.AtEnd
    Val.TextXAlignment = Enum.TextXAlignment.Left
    Val.ZIndex = 27

    local Div = Instance.new('Frame', parent)
    Div.Size = UDim2.new(0, 1, 1, -10)
    Div.Position = UDim2.new(xPosScale + widthScale, 0, 0, 5)
    Div.BackgroundColor3 = Color3.fromRGB(45, 52, 72)
    Div.BorderSizePixel = 0
    Div.ZIndex = 27

    return Val
end

-- 3 Ô Thông tin (Biome | Merchant | Uptime) + 1 Ô Nút bấm Logo bên phải cùng
UI.BarBiomeVal = CreateTopBarCell(UI.TopBar, 0.00, 0.31, 'BIOME', 'NORMAL')
UI.BarBiomeVal.TextColor3 = Color3.fromRGB(80, 250, 123)

UI.BarMerchVal = CreateTopBarCell(UI.TopBar, 0.31, 0.31, 'MERCHANT', 'NONE')
UI.BarMerchVal.TextColor3 = Color3.fromRGB(255, 200, 80)

UI.BarUptimeVal = CreateTopBarCell(UI.TopBar, 0.62, 0.27, 'UPTIME', '00:00:00')
RegisterAccent(UI.BarUptimeVal, 'TextColor3')

-- Ô thứ 4 bên phải cùng: Nút Logo mở Full UI (Kéo thả được cả thanh TopBar)
UI.TopBarOpenBtn = Instance.new('ImageButton', UI.TopBar)
UI.TopBarOpenBtn.Name = 'OpenFullUIBtn'
UI.TopBarOpenBtn.Size = UDim2.new(0.11, -6, 1, -6)
UI.TopBarOpenBtn.Position = UDim2.new(0.89, 3, 0, 3)
UI.TopBarOpenBtn.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
UI.TopBarOpenBtn.BorderSizePixel = 0
UI.TopBarOpenBtn.Image = FallbackLogo
UI.TopBarOpenBtn.ScaleType = Enum.ScaleType.Fit
UI.TopBarOpenBtn.ZIndex = 28
Instance.new('UICorner', UI.TopBarOpenBtn).CornerRadius = UDim.new(0, 6)

-- // Main Window (Full UI)
UI.MainWindow = Instance.new('Frame', UI.ScreenGui)
UI.MainWindow.Name = 'MainWindow'
UI.MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
UI.MainWindow.Size = UDim2.new(0, 460, 0, 275)
UI.MainWindow.Position = UDim2.new(0.5, 0, 0.53, 0)
UI.MainWindow.BackgroundColor3 = Color3.fromRGB(15, 19, 29)
UI.MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
UI.MainWindow.BorderSizePixel = 0
UI.MainWindow.Active = true
UI.MainWindow.ZIndex = 5
Instance.new('UICorner', UI.MainWindow).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new('UIStroke', UI.MainWindow)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.45
RegisterAccent(MainStroke, 'Color')

UI.WindowScale = Instance.new('UIScale', UI.MainWindow)
local function RecalculateResponsiveScale()
    pcall(function()
        local cam = Svc.Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 480)
        local autoRatio = math.clamp(math.min(vp.X / 540, vp.Y / 330), 0.65, 1.1)
        UI.WindowScale.Scale = autoRatio * (NyXConfig.UIScalePercent / 100)
    end)
end
RecalculateResponsiveScale()
if Svc.Workspace.CurrentCamera then
    TrackConnection(Svc.Workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(RecalculateResponsiveScale))
end

-- Kéo thả thanh TopBar & Bấm nút Logo để đóng/mở Full UI
MakeDraggable(UI.TopBar, UI.TopBar)
MakeDraggable(UI.TopBarOpenBtn, UI.TopBar, function()
    UI.MainWindow.Visible = not UI.MainWindow.Visible
end)

-- // Sidebar gọn nhẹ
local Sidebar = Instance.new('Frame', UI.MainWindow)
Sidebar.Size = UDim2.new(0, 114, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Instance.new('UICorner', Sidebar).CornerRadius = UDim.new(0, 10)

UI.BrandImage = Instance.new('ImageLabel', Sidebar)
UI.BrandImage.Size = UDim2.new(0, 24, 0, 24)
UI.BrandImage.Position = UDim2.new(0, 10, 0, 10)
UI.BrandImage.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
UI.BrandImage.BackgroundTransparency = 0.2
UI.BrandImage.Image = FallbackLogo
UI.BrandImage.ScaleType = Enum.ScaleType.Fit
Instance.new('UICorner', UI.BrandImage).CornerRadius = UDim.new(0, 6)

-- Tải ảnh Hsin chạy ngầm (Async) cập nhật cho cả Nút TopBar và Sidebar
task.spawn(function()
    pcall(function()
        local customAssetFunc = getcustomasset or getsynasset
        local HsinLogoURL = 'https://wutheringlab.com/wp-content/uploads/Hsin-icon.webp'
        local HsinLogoFile = 'NyX_Hsin_Icon.webp'
        if type(customAssetFunc) == 'function' and type(writefile) == 'function' and type(isfile) == 'function' then
            if not isfile(HsinLogoFile) then
                local req = (syn and syn.request) or http_request or request
                if type(req) == 'function' then
                    local res = req({Url = HsinLogoURL, Method = 'GET'})
                    if res and res.Body then writefile(HsinLogoFile, res.Body) end
                else
                    local body = game:HttpGet(HsinLogoURL)
                    if body then writefile(HsinLogoFile, body) end
                end
            end
            if isfile(HsinLogoFile) then
                local assetId = customAssetFunc(HsinLogoFile)
                if assetId and assetId ~= '' then
                    UI.TopBarOpenBtn.Image = assetId
                    UI.BrandImage.Image = assetId
                end
            end
        end
    end)
end)

local BrandTitle = Instance.new('TextLabel', Sidebar)
BrandTitle.Size = UDim2.new(1, -40, 0, 24)
BrandTitle.Position = UDim2.new(0, 38, 0, 10)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = 'NyX v9'
BrandTitle.Font = Enum.Font.GothamBlack
BrandTitle.TextSize = 12
BrandTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

MakeDraggable(Sidebar, UI.MainWindow)

local CloseBtn = Instance.new('TextButton', UI.MainWindow)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = '×'
CloseBtn.TextColor3 = Color3.fromRGB(210, 215, 235)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new('UICorner', CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    UI.MainWindow.Visible = false
end)

local NavHolder = Instance.new('Frame', Sidebar)
NavHolder.Size = UDim2.new(1, -12, 1, -48)
NavHolder.Position = UDim2.new(0, 6, 0, 42)
NavHolder.BackgroundTransparency = 1
local NavLayout = Instance.new('UIListLayout', NavHolder)
NavLayout.Padding = UDim.new(0, 4)

local ContentArea = Instance.new('Frame', UI.MainWindow)
ContentArea.Size = UDim2.new(1, -118, 1, 0)
ContentArea.Position = UDim2.new(0, 118, 0, 0)
ContentArea.BackgroundTransparency = 1

local function CreateTabPage(tabName)
    local Page = Instance.new('Frame', ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local HeaderTitle = Instance.new('TextLabel', Page)
    HeaderTitle.Size = UDim2.new(1, -44, 0, 22)
    HeaderTitle.Position = UDim2.new(0, 10, 0, 8)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = tabName
    HeaderTitle.Font = Enum.Font.GothamBlack
    HeaderTitle.TextSize = 13
    HeaderTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Scroll = Instance.new('ScrollingFrame', Page)
    Scroll.Size = UDim2.new(1, -16, 1, -38)
    Scroll.Position = UDim2.new(0, 8, 0, 32)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    RegisterAccent(Scroll, 'ScrollBarImageColor3')

    local ScrollLayout = Instance.new('UIListLayout', Scroll)
    ScrollLayout.Padding = UDim.new(0, 4)
    TrackConnection(ScrollLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 8)
    end))

    local NavBtn = Instance.new('TextButton', NavHolder)
    NavBtn.Size = UDim2.new(1, 0, 0, 26)
    NavBtn.BackgroundColor3 = Color3.fromRGB(32, 38, 56)
    NavBtn.BackgroundTransparency = 1
    NavBtn.BorderSizePixel = 0
    NavBtn.Text = '   ' .. tabName
    NavBtn.Font = Enum.Font.GothamBold
    NavBtn.TextSize = 10
    NavBtn.TextColor3 = Color3.fromRGB(160, 170, 195)
    NavBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', NavBtn).CornerRadius = UDim.new(0, 6)

    local ActiveBar = Instance.new('Frame', NavBtn)
    ActiveBar.Size = UDim2.new(0, 3, 0, 13)
    ActiveBar.Position = UDim2.new(0, 0, 0.5, -6)
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    Instance.new('UICorner', ActiveBar).CornerRadius = UDim.new(1, 0)
    RegisterAccent(ActiveBar, 'BackgroundColor3')

    NavBtn.MouseButton1Click:Connect(function()
        for _, p in ipairs(UI.Pages) do p.Visible = false end
        for _, b in ipairs(UI.NavButtons) do
            b.Btn.BackgroundTransparency = 1
            b.Btn.TextColor3 = Color3.fromRGB(160, 170, 195)
            b.Bar.Visible = false
        end
        Page.Visible = true
        NavBtn.BackgroundTransparency = 0.25
        NavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveBar.Visible = true
    end)

    table.insert(UI.Pages, Page)
    table.insert(UI.NavButtons, {Btn = NavBtn, Bar = ActiveBar})
    return Scroll, NavBtn, ActiveBar
end

local function AddSectionLabel(parent, text)
    local Lbl = Instance.new('TextLabel', parent)
    Lbl.Size = UDim2.new(1, -4, 0, 14)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text:upper()
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 8
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterAccent(Lbl, 'TextColor3')
end

-- Toggle tinh gọn: chỉ hiển thị đúng tên chức năng + nút gạt (Bỏ dòng mô tả thừa)
local function AddToggle(parent, title, defaultVal, callback)
    local Card = Instance.new('TextButton', parent)
    Card.Size = UDim2.new(1, -4, 0, 28)
    Card.BackgroundColor3 = Color3.fromRGB(25, 31, 46)
    Card.BackgroundTransparency = 0.25
    Card.BorderSizePixel = 0
    Card.Text = ''
    Card.AutoButtonColor = false
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -54, 1, 0)
    TitleLbl.Position = UDim2.new(0, 10, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextColor3 = Color3.fromRGB(240, 244, 255)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new('Frame', Card)
    SwitchBg.Size = UDim2.new(0, 32, 0, 15)
    SwitchBg.Position = UDim2.new(1, -40, 0.5, -7)
    SwitchBg.BorderSizePixel = 0
    SwitchBg.BackgroundColor3 = defaultVal and NyXConfig.UIAccentColor or Color3.fromRGB(48, 54, 72)
    Instance.new('UICorner', SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new('Frame', SwitchBg)
    Knob.Size = UDim2.new(0, 11, 0, 11)
    Knob.Position = defaultVal and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new('UICorner', Knob).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    RegisterDynamicAccent(function(newCol)
        if state then SwitchBg.BackgroundColor3 = newCol end
    end)

    Card.MouseButton1Click:Connect(function()
        state = not state
        SwitchBg.BackgroundColor3 = state and NyXConfig.UIAccentColor or Color3.fromRGB(48, 54, 72)
        Knob.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        if callback then callback(state) end
    end)
end

local function AddInput(parent, title, defaultText, placeholder, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -4, 0, 38)
    Card.BackgroundColor3 = Color3.fromRGB(25, 31, 46)
    Card.BackgroundTransparency = 0.25
    Card.BorderSizePixel = 0
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -16, 0, 12)
    TitleLbl.Position = UDim2.new(0, 8, 0, 3)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 9
    TitleLbl.TextColor3 = Color3.fromRGB(210, 220, 240)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new('TextBox', Card)
    Box.Size = UDim2.new(1, -16, 0, 18)
    Box.Position = UDim2.new(0, 8, 0, 16)
    Box.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    Box.BackgroundTransparency = 0.15
    Box.BorderSizePixel = 0
    Box.Text = defaultText or ''
    Box.PlaceholderText = placeholder or ''
    Box.TextColor3 = Color3.fromRGB(240, 245, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(115, 125, 145)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 9
    Box.ClearTextOnFocus = false
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', Box).CornerRadius = UDim.new(0, 4)

    Box:GetPropertyChangedSignal('Text'):Connect(function()
        if callback then callback(Box.Text) end
    end)
    return Box
end

local function AddButton(parent, title, callback)
    local Btn = Instance.new('TextButton', parent)
    Btn.Size = UDim2.new(1, -4, 0, 26)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 38, 56)
    Btn.BackgroundTransparency = 0.2
    Btn.BorderSizePixel = 0
    Btn.Text = title
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.TextColor3 = Color3.fromRGB(245, 248, 255)
    Instance.new('UICorner', Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function AddSlider(parent, title, minVal, maxVal, defaultVal, suffix, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -4, 0, 32)
    Card.BackgroundColor3 = Color3.fromRGB(25, 31, 46)
    Card.BackgroundTransparency = 0.25
    Card.BorderSizePixel = 0
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -16, 0, 13)
    TitleLbl.Position = UDim2.new(0, 8, 0, 2)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title .. ': ' .. tostring(defaultVal) .. (suffix or '')
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 9
    TitleLbl.TextColor3 = Color3.fromRGB(235, 240, 252)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local BarBg = Instance.new('TextButton', Card)
    BarBg.Size = UDim2.new(1, -16, 0, 6)
    BarBg.Position = UDim2.new(0, 8, 0, 19)
    BarBg.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
    BarBg.BorderSizePixel = 0
    BarBg.Text = ''
    Instance.new('UICorner', BarBg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new('Frame', BarBg)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Fill.BorderSizePixel = 0
    Instance.new('UICorner', Fill).CornerRadius = UDim.new(1, 0)
    RegisterAccent(Fill, 'BackgroundColor3')

    local sliding = false
    local function UpdateFromInput(input)
        local rel = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / math.max(1, BarBg.AbsoluteSize.X), 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        TitleLbl.Text = title .. ': ' .. tostring(val) .. (suffix or '')
        if callback then callback(val) end
    end
    TrackConnection(BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateFromInput(input)
        end
    end))
    TrackConnection(Svc.UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromInput(input)
        end
    end))
    TrackConnection(Svc.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end))
end

-- ==========================================
-- // BUILD THE 6 TABS (CLEAN & DIRECT)
-- ==========================================
local HomeScroll, HomeNavBtn, HomeNavBar = CreateTabPage('Home')
local MainScroll = CreateTabPage('Main')
local MerchantScroll = CreateTabPage('Merchant')
local ConnScroll = CreateTabPage('Webhook')
local PingsScroll = CreateTabPage('Pings')
local SettingScroll = CreateTabPage('Settings')

UI.Pages[1].Visible = true
HomeNavBtn.BackgroundTransparency = 0.25
HomeNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeNavBar.Visible = true

-- // TAB 1: HOME
do
    local GraveyardHomeCard = Instance.new('Frame', HomeScroll)
    GraveyardHomeCard.Size = UDim2.new(1, -4, 0, 28)
    GraveyardHomeCard.BackgroundColor3 = Color3.fromRGB(25, 31, 46)
    GraveyardHomeCard.BackgroundTransparency = 0.25
    GraveyardHomeCard.BorderSizePixel = 0
    Instance.new('UICorner', GraveyardHomeCard).CornerRadius = UDim.new(0, 6)

    local GraveHomeTitle = Instance.new('TextLabel', GraveyardHomeCard)
    GraveHomeTitle.Size = UDim2.new(0.5, 0, 1, 0)
    GraveHomeTitle.Position = UDim2.new(0, 10, 0, 0)
    GraveHomeTitle.BackgroundTransparency = 1
    GraveHomeTitle.Text = 'Graveyard Timer:'
    GraveHomeTitle.Font = Enum.Font.GothamBold
    GraveHomeTitle.TextSize = 10
    GraveHomeTitle.TextColor3 = Color3.fromRGB(185, 195, 215)
    GraveHomeTitle.TextXAlignment = Enum.TextXAlignment.Left

    UI.GraveyardHomeValue = Instance.new('TextLabel', GraveyardHomeCard)
    UI.GraveyardHomeValue.Size = UDim2.new(0.45, -10, 1, 0)
    UI.GraveyardHomeValue.Position = UDim2.new(0.55, 0, 0, 0)
    UI.GraveyardHomeValue.BackgroundTransparency = 1
    UI.GraveyardHomeValue.Text = 'INACTIVE'
    UI.GraveyardHomeValue.Font = Enum.Font.GothamBlack
    UI.GraveyardHomeValue.TextSize = 10
    UI.GraveyardHomeValue.TextColor3 = Color3.fromRGB(165, 185, 200)
    UI.GraveyardHomeValue.TextXAlignment = Enum.TextXAlignment.Right

    AddSectionLabel(HomeScroll, 'Control')
    AddToggle(HomeScroll, 'Start Macro', NyXConfig.MacroActive, function(val)
        if val then
            NyXConfig.MacroActive = true
            State.MacroStartTime = os.time()
            SendMacroStateEmbed(true)
            Notify('Macro', 'Started!', 2)
        else
            local finalElapsed = (State.MacroStartTime > 0) and (os.time() - State.MacroStartTime) or 0
            NyXConfig.MacroActive = false
            SendMacroStateEmbed(false, finalElapsed)
            State.MacroStartTime = 0
            UI.BarUptimeVal.Text = '00:00:00'
            Notify('Macro', 'Stopped!', 2)
        end
    end)

    AddButton(HomeScroll, 'Unstuck Character', function()
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            local root = char and char:FindFirstChild('HumanoidRootPart')
            if hum and root then
                ForceCharacterJump(hum)
                root.CFrame = root.CFrame + Vector3.new(0, 4, 0)
            end
        end)
    end)
end

-- // TAB 2: MAIN (19 BIOMES)
do
    AddSectionLabel(MainScroll, 'Automation')
    AddToggle(MainScroll, 'Auto Collect Ground Items', NyXConfig.AutoCollectItems, function(val)
        NyXConfig.AutoCollectItems = val
    end)
    AddToggle(MainScroll, 'Auto Biome Randomizer', NyXConfig.AutoBiomeRandomizer, function(val)
        NyXConfig.AutoBiomeRandomizer = val
    end)
    AddToggle(MainScroll, 'Auto Strange Controller', NyXConfig.AutoStrangeController, function(val)
        NyXConfig.AutoStrangeController = val
    end)
    AddSlider(MainScroll, 'Item Interval', 5, 300, NyXConfig.UseInterval, 's', function(val)
        NyXConfig.UseInterval = val
    end)
    AddButton(MainScroll, 'Use Biome Randomizer', function()
        task.spawn(function() UseItemWithInventoryFailsafe('Biome Randomizer') end)
    end)
    AddButton(MainScroll, 'Use Strange Controller', function()
        task.spawn(function() UseItemWithInventoryFailsafe('Strange Controller') end)
    end)

    AddSectionLabel(MainScroll, 'Stop Auto In (19 Biomes)')
    local StopGridFrame = Instance.new('Frame', MainScroll)
    StopGridFrame.Size = UDim2.new(1, -4, 0, 136)
    StopGridFrame.BackgroundTransparency = 1
    local GridLayout = Instance.new('UIGridLayout', StopGridFrame)
    GridLayout.CellSize = UDim2.new(0.24, -3, 0, 23)
    GridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

    for _, bName in ipairs(All19Biomes) do
        local Chip = Instance.new('TextButton', StopGridFrame)
        local isOn = NyXConfig.StopAutoBiomes[bName] == true
        Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
        Chip.BackgroundTransparency = isOn and 0.05 or 0.25
        Chip.BorderSizePixel = 0
        Chip.Text = bName
        Chip.Font = Enum.Font.GothamBold
        Chip.TextSize = 7
        Chip.TextColor3 = Color3.fromRGB(240, 244, 255)
        Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

        RegisterDynamicAccent(function(newCol)
            if NyXConfig.StopAutoBiomes[bName] then Chip.BackgroundColor3 = newCol end
        end)

        Chip.MouseButton1Click:Connect(function()
            NyXConfig.StopAutoBiomes[bName] = not NyXConfig.StopAutoBiomes[bName]
            local active = NyXConfig.StopAutoBiomes[bName]
            Chip.BackgroundColor3 = active and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
            Chip.BackgroundTransparency = active and 0.05 or 0.25
        end)
    end
end

-- // TAB 3: MERCHANT
do
    local MerchantLiveCard = Instance.new('Frame', MerchantScroll)
    MerchantLiveCard.Size = UDim2.new(1, -4, 0, 40)
    MerchantLiveCard.BackgroundColor3 = Color3.fromRGB(25, 31, 46)
    MerchantLiveCard.BackgroundTransparency = 0.25
    MerchantLiveCard.BorderSizePixel = 0
    Instance.new('UICorner', MerchantLiveCard).CornerRadius = UDim.new(0, 6)

    UI.MTabStatusLbl = Instance.new('TextLabel', MerchantLiveCard)
    UI.MTabStatusLbl.Size = UDim2.new(1, -16, 0, 16)
    UI.MTabStatusLbl.Position = UDim2.new(0, 8, 0, 4)
    UI.MTabStatusLbl.BackgroundTransparency = 1
    UI.MTabStatusLbl.Text = 'Merchant: NONE'
    UI.MTabStatusLbl.Font = Enum.Font.GothamBold
    UI.MTabStatusLbl.TextSize = 10
    UI.MTabStatusLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    UI.MTabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

    UI.MTabCoordsLbl = Instance.new('TextLabel', MerchantLiveCard)
    UI.MTabCoordsLbl.Size = UDim2.new(1, -16, 0, 14)
    UI.MTabCoordsLbl.Position = UDim2.new(0, 8, 0, 21)
    UI.MTabCoordsLbl.BackgroundTransparency = 1
    UI.MTabCoordsLbl.Text = 'XYZ: N/A'
    UI.MTabCoordsLbl.Font = Enum.Font.Gotham
    UI.MTabCoordsLbl.TextSize = 9
    UI.MTabCoordsLbl.TextColor3 = Color3.fromRGB(150, 160, 185)
    UI.MTabCoordsLbl.TextXAlignment = Enum.TextXAlignment.Left

    AddSectionLabel(MerchantScroll, 'Actions')
    AddToggle(MerchantScroll, 'Auto Walk to Merchant', NyXConfig.AutoWalkToMerchant, function(val)
        NyXConfig.AutoWalkToMerchant = val
    end)
    AddToggle(MerchantScroll, 'Auto Open Shop', NyXConfig.AutoInteractMerchant, function(val)
        NyXConfig.AutoInteractMerchant = val
    end)
    AddToggle(MerchantScroll, 'Respawn When Merchant Leaves', NyXConfig.RespawnIfMerchantLeft, function(val)
        NyXConfig.RespawnIfMerchantLeft = val
    end)
    AddButton(MerchantScroll, 'Walk to Merchant Now', function()
        WalkToActiveMerchantNow()
    end)
    AddButton(MerchantScroll, 'Stop Walking', function()
        State.CancelCurrentWalk = true
    end)
end

-- // TAB 4 & 5: WEBHOOK & PINGS
do
    AddInput(ConnScroll, 'Webhook URL', NyXConfig.WebhookURL, 'https://discord.com/api/webhooks/...', function(txt)
        NyXConfig.WebhookURL = txt:gsub('%s+', '')
    end)
    UI.ConnUserIDBox = AddInput(ConnScroll, 'Discord User ID', NyXConfig.DiscordID, 'Numeric ID', function(txt)
        local clean = txt:gsub('%D+', '')
        NyXConfig.DiscordID = clean
        if UI.PingUserIDBox and UI.PingUserIDBox.Text ~= clean then UI.PingUserIDBox.Text = clean end
    end)
    AddInput(ConnScroll, 'Private Server Link', NyXConfig.PrivateServerLink, 'https://www.roblox.com/share?code=...', function(txt)
        NyXConfig.PrivateServerLink = txt
    end)
    AddButton(ConnScroll, 'Save Config', function()
        SaveWebhookConfig()
        Notify('Config', 'Saved!', 2)
    end)
    AddButton(ConnScroll, 'Test Webhook', function()
        SendTestWebhookEmbed(false)
        Notify('Webhook', 'Test sent!', 2)
    end)

    UI.PingUserIDBox = AddInput(PingsScroll, 'Discord User ID', NyXConfig.DiscordID, 'Numeric ID...', function(txt)
        local clean = txt:gsub('%D+', '')
        NyXConfig.DiscordID = clean
        if UI.ConnUserIDBox and UI.ConnUserIDBox.Text ~= clean then UI.ConnUserIDBox.Text = clean end
    end)
    AddButton(PingsScroll, 'Test User ID Ping', function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if cleanID == '' then
            Notify('Ping', 'Enter User ID first!', 2.5)
            return
        end
        SendTestWebhookEmbed(true)
        Notify('Ping', 'Sent!', 2)
    end)

    AddSectionLabel(PingsScroll, 'Biomes (19)')
    local PingBiomeGrid = Instance.new('Frame', PingsScroll)
    PingBiomeGrid.Size = UDim2.new(1, -4, 0, 136)
    PingBiomeGrid.BackgroundTransparency = 1
    local PGridLayout = Instance.new('UIGridLayout', PingBiomeGrid)
    PGridLayout.CellSize = UDim2.new(0.24, -3, 0, 23)
    PGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

    for _, bName in ipairs(All19Biomes) do
        local Chip = Instance.new('TextButton', PingBiomeGrid)
        local isOn = NyXConfig.PingBiomes[bName] == true
        Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
        Chip.BackgroundTransparency = isOn and 0.05 or 0.25
        Chip.BorderSizePixel = 0
        Chip.Text = bName
        Chip.Font = Enum.Font.GothamBold
        Chip.TextSize = 7
        Chip.TextColor3 = Color3.fromRGB(240, 244, 255)
        Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

        RegisterDynamicAccent(function(newCol)
            if NyXConfig.PingBiomes[bName] then Chip.BackgroundColor3 = newCol end
        end)

        Chip.MouseButton1Click:Connect(function()
            local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
            if not NyXConfig.PingBiomes[bName] and cleanID == '' then
                Notify('Ping', 'Enter User ID first!', 2.5)
                return
            end
            NyXConfig.PingBiomes[bName] = not NyXConfig.PingBiomes[bName]
            local active = NyXConfig.PingBiomes[bName]
            Chip.BackgroundColor3 = active and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
            Chip.BackgroundTransparency = active and 0.05 or 0.25
            SaveWebhookConfig()
        end)
    end

    AddSectionLabel(PingsScroll, 'Merchants (4)')
    local PingMerchantRow = Instance.new('Frame', PingsScroll)
    PingMerchantRow.Size = UDim2.new(1, -4, 0, 28)
    PingMerchantRow.BackgroundTransparency = 1
    local MGridLayout = Instance.new('UIGridLayout', PingMerchantRow)
    MGridLayout.CellSize = UDim2.new(0.24, -3, 0, 26)
    MGridLayout.CellPadding = UDim2.new(0, 4, 0, 0)

    for _, mName in ipairs(All4Merchants) do
        local MChip = Instance.new('TextButton', PingMerchantRow)
        local isOn = NyXConfig.PingMerchants[mName] == true
        MChip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
        MChip.BackgroundTransparency = isOn and 0.05 or 0.25
        MChip.BorderSizePixel = 0
        MChip.Text = mName:upper()
        MChip.Font = Enum.Font.GothamBold
        MChip.TextSize = 8
        MChip.TextColor3 = Color3.fromRGB(240, 244, 255)
        Instance.new('UICorner', MChip).CornerRadius = UDim.new(0, 5)

        RegisterDynamicAccent(function(newCol)
            if NyXConfig.PingMerchants[mName] then MChip.BackgroundColor3 = newCol end
        end)

        MChip.MouseButton1Click:Connect(function()
            local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
            if not NyXConfig.PingMerchants[mName] and cleanID == '' then
                Notify('Ping', 'Enter User ID first!', 2.5)
                return
            end
            NyXConfig.PingMerchants[mName] = not NyXConfig.PingMerchants[mName]
            local active = NyXConfig.PingMerchants[mName]
            MChip.BackgroundColor3 = active and NyXConfig.UIAccentColor or Color3.fromRGB(25, 31, 46)
            MChip.BackgroundTransparency = active and 0.05 or 0.25
            SaveWebhookConfig()
        end)
    end
end

-- // TAB 6: SETTINGS
do
    AddSectionLabel(SettingScroll, 'UI & Alerts')
    AddToggle(SettingScroll, 'Lock UI Position', NyXConfig.LockUIPosition, function(val)
        NyXConfig.LockUIPosition = val
    end)
    AddToggle(SettingScroll, 'Sound Alert', NyXConfig.EnableSoundAlert, function(val)
        NyXConfig.EnableSoundAlert = val
    end)
    AddButton(SettingScroll, 'Reset UI Position', function()
        UI.MainWindow.Position = UDim2.new(0.5, 0, 0.53, 0)
        UI.TopBar.Position = UDim2.new(0.5, 0, 0, 8)
        UI.MainWindow.Visible = true
    end)

    AddSectionLabel(SettingScroll, 'Movement & Theme')
    AddToggle(SettingScroll, 'WalkSpeed Boost', NyXConfig.WalkSpeedBoost, function(val)
        NyXConfig.WalkSpeedBoost = val
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
            if hum then hum.WalkSpeed = val and NyXConfig.CustomWalkSpeed or 16 end
        end)
    end)
    AddSlider(SettingScroll, 'WalkSpeed', 16, 45, NyXConfig.CustomWalkSpeed, '', function(val)
        NyXConfig.CustomWalkSpeed = val
        if NyXConfig.WalkSpeedBoost then
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                if hum then hum.WalkSpeed = val end
            end)
        end
    end)
    AddSlider(SettingScroll, 'UI Scale', 55, 125, NyXConfig.UIScalePercent, '%', function(val)
        NyXConfig.UIScalePercent = val
        RecalculateResponsiveScale()
    end)
    AddSlider(SettingScroll, 'Glass Transparency', 0, 50, math.floor(NyXConfig.GlassTransparency * 100), '%', function(val)
        NyXConfig.GlassTransparency = val / 100
        UI.MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
    end)

    local ColorRow = Instance.new('Frame', SettingScroll)
    ColorRow.Size = UDim2.new(1, -4, 0, 24)
    ColorRow.BackgroundTransparency = 1
    local ColorListLayout = Instance.new('UIListLayout', ColorRow)
    ColorListLayout.FillDirection = Enum.FillDirection.Horizontal
    ColorListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    ColorListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ColorListLayout.Padding = UDim.new(0.015, 0)

    local ThemePresets = {
        {Name = 'Blue', Col = Color3.fromRGB(110, 165, 255)},
        {Name = 'Purple', Col = Color3.fromRGB(155, 105, 255)},
        {Name = 'Crimson', Col = Color3.fromRGB(255, 75, 100)},
        {Name = 'Emerald', Col = Color3.fromRGB(50, 220, 125)},
        {Name = 'Gold', Col = Color3.fromRGB(255, 180, 50)}
    }
    for i, preset in ipairs(ThemePresets) do
        local CBtn = Instance.new('TextButton', ColorRow)
        CBtn.LayoutOrder = i
        CBtn.Size = UDim2.new(0.188, 0, 1, 0)
        CBtn.BackgroundColor3 = preset.Col
        CBtn.BorderSizePixel = 0
        CBtn.Text = preset.Name
        CBtn.Font = Enum.Font.GothamBold
        CBtn.TextSize = 8
        CBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new('UICorner', CBtn).CornerRadius = UDim.new(0, 5)
        CBtn.MouseButton1Click:Connect(function()
            UpdateAccentColor(preset.Col)
        end)
    end

    AddSectionLabel(SettingScroll, 'System')
    AddToggle(SettingScroll, 'OLED Black Screen', NyXConfig.BlackScreenSaver, function(val)
        NyXConfig.BlackScreenSaver = val
        UI.BlackSaverFrame.Visible = val
    end)
    AddToggle(SettingScroll, 'Disable 3D Rendering', NyXConfig.Disable3DRendering, function(val)
        NyXConfig.Disable3DRendering = val
        pcall(function() Svc.RunService:Set3dRenderingEnabled(not val) end)
    end)
    AddToggle(SettingScroll, 'Anti-AFK', NyXConfig.AntiAFK, function(val)
        NyXConfig.AntiAFK = val
    end)
    AddToggle(SettingScroll, 'Auto Reconnect', NyXConfig.AutoReconnect, function(val)
        NyXConfig.AutoReconnect = val
    end)
    AddButton(SettingScroll, 'Boost FPS', function()
        pcall(function()
            Svc.Lighting.GlobalShadows = false
            for _, v in ipairs(Svc.Workspace:GetDescendants()) do
                if v:IsA('ParticleEmitter') or v:IsA('Trail') or v:IsA('Smoke') or v:IsA('Fire') then
                    v.Enabled = false
                elseif v:IsA('BasePart') then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
        Notify('FPS', 'Optimized!', 2)
    end)
    AddButton(SettingScroll, 'Copy JobId', function()
        if type(setclipboard) == 'function' then
            pcall(setclipboard, tostring(game.JobId))
            Notify('JobId', 'Copied!', 2)
        end
    end)
    AddButton(SettingScroll, 'Rejoin Server', function()
        Svc.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    NyXEnv.Cleanup = function()
        NyXEnv.Running = false
        State.CancelCurrentWalk = true
        pcall(function() Svc.RunService:Set3dRenderingEnabled(true) end)
        if NyXConfig.MacroActive then
            local finalElapsed = (State.MacroStartTime > 0) and (os.time() - State.MacroStartTime) or 0
            SendMacroStateEmbed(false, finalElapsed)
        end
        for _, conn in ipairs(NyXEnv.Connections) do
            pcall(function()
                if conn and conn.Connected then conn:Disconnect() end
            end)
        end
        ClearTable(NyXEnv.Connections)
        if UI.ScreenGui and UI.ScreenGui.Parent then
            UI.ScreenGui:Destroy()
        end
    end

    AddButton(SettingScroll, 'Destroy Script', function()
        NyXEnv.Cleanup()
    end)
end

-- ==========================================
-- // CONSOLIDATED LOW-CPU BACKGROUND LOOPS
-- ==========================================
task.spawn(function()
    local confirmedBiome = GetAccurateServerBiome()
    local pendingBiome = confirmedBiome
    local pendingCount = 0
    NyXConfig.CurrentDetectedBiome = confirmedBiome
    UI.BarBiomeVal.Text = confirmedBiome
    if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
        UI.BarBiomeVal.TextColor3 = BiomeData[confirmedBiome].Hex
    end

    if confirmedBiome == 'GRAVEYARD' then
        NyXConfig.GraveyardActive = true
        NyXConfig.GraveyardStartTimestamp = os.time()
        NyXConfig.GraveyardElapsed = 0
        NyXConfig.SinisterTriggeredInGraveyard = false
    end

    while NyXEnv.Running and task.wait(1) do
        if NyXConfig.WalkSpeedBoost then
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                if hum and hum.WalkSpeed ~= NyXConfig.CustomWalkSpeed then
                    hum.WalkSpeed = NyXConfig.CustomWalkSpeed
                end
            end)
        end

        local rawDetected = GetAccurateServerBiome()
        if rawDetected == pendingBiome then
            pendingCount = pendingCount + 1
        else
            pendingBiome = rawDetected
            pendingCount = 1
        end

        if pendingCount >= 2 and pendingBiome ~= confirmedBiome then
            local previousBiome = confirmedBiome
            confirmedBiome = pendingBiome
            NyXConfig.CurrentDetectedBiome = confirmedBiome
            UI.BarBiomeVal.Text = confirmedBiome
            if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
                UI.BarBiomeVal.TextColor3 = BiomeData[confirmedBiome].Hex
            end

            if confirmedBiome == 'GRAVEYARD' then
                NyXConfig.GraveyardActive = true
                NyXConfig.GraveyardStartTimestamp = os.time()
                NyXConfig.GraveyardElapsed = 0
                NyXConfig.SinisterTriggeredInGraveyard = false
            end

            if previousBiome == 'GRAVEYARD' and confirmedBiome ~= 'GRAVEYARD' then
                NyXConfig.GraveyardActive = false
                NyXConfig.GraveyardStartTimestamp = 0
                NyXConfig.GraveyardElapsed = 0
                NyXConfig.SinisterTriggeredInGraveyard = false
                if NyXConfig.CurrentMerchant == 'SINISTER S.' then
                    SetMerchantLeftState('Graveyard Ended')
                end
            end

            if NyXConfig.PingBiomes[confirmedBiome] or NyXConfig.StopAutoBiomes[confirmedBiome] then
                PlayAlertSound()
            end

            -- Đảm bảo gửi Biome Ended trước, rồi mới gửi Biome Started qua WebhookQueue tuần tự
            if NyXConfig.MacroActive then
                local nowTs = os.time()
                if previousBiome ~= 'NORMAL' and BiomeData[previousBiome] then
                    local prevInfo = BiomeData[previousBiome]
                    SendBiomeEndedEmbed(previousBiome, prevInfo.Color, prevInfo.Image, nowTs)
                end
                if confirmedBiome ~= 'NORMAL' and BiomeData[confirmedBiome] then
                    local newInfo = BiomeData[confirmedBiome]
                    SendBiomeStartedEmbed(confirmedBiome, newInfo.Color, newInfo.Image, nowTs)
                end
            end

            if NyXConfig.StopAutoBiomes[confirmedBiome] then
                Notify('Stop Auto', 'Detected ' .. confirmedBiome, 3)
            end
        end

        -- Bộ đếm Graveyard (Hiển thị trực tiếp trên ô Biome của TopBar & Home)
        if NyXConfig.CurrentDetectedBiome == 'GRAVEYARD' then
            if not NyXConfig.GraveyardActive or NyXConfig.GraveyardStartTimestamp == 0 then
                NyXConfig.GraveyardActive = true
                NyXConfig.GraveyardStartTimestamp = os.time()
            end
            NyXConfig.GraveyardElapsed = os.time() - NyXConfig.GraveyardStartTimestamp
            local gTimeStr = FormatMMSS(NyXConfig.GraveyardElapsed)
            UI.BarBiomeVal.Text = 'GRAVEYARD (' .. gTimeStr .. ')'

            if NyXConfig.GraveyardElapsed >= 300 and not NyXConfig.SinisterTriggeredInGraveyard then
                NyXConfig.SinisterTriggeredInGraveyard = true
                local _, sPos = FindMerchantWorldPosition(true)
                local remainingGraveyard = math.max(60, 660 - NyXConfig.GraveyardElapsed)
                SetMerchantArrivedState('Sinister S.', sPos, remainingGraveyard)
            end

            if UI.MainWindow.Visible then
                if NyXConfig.SinisterTriggeredInGraveyard then
                    UI.GraveyardHomeValue.Text = gTimeStr .. ' / 11:00 (SINISTER)'
                    UI.GraveyardHomeValue.TextColor3 = Color3.fromRGB(255, 140, 50)
                else
                    UI.GraveyardHomeValue.Text = gTimeStr .. ' / 05:00'
                    UI.GraveyardHomeValue.TextColor3 = Color3.fromRGB(165, 220, 255)
                end
            end
        else
            UI.BarBiomeVal.Text = NyXConfig.CurrentDetectedBiome
            if UI.MainWindow.Visible then
                UI.GraveyardHomeValue.Text = 'INACTIVE'
                UI.GraveyardHomeValue.TextColor3 = Color3.fromRGB(150, 160, 185)
            end
        end

        -- Kiểm tra Merchant & Cập nhật ô Merchant trên TopBar
        local worldMerchant, worldPos = FindMerchantWorldPosition(false)
        if worldMerchant and NyXConfig.CurrentMerchant == 'NONE' then
            SetMerchantArrivedState(worldMerchant, worldPos)
        elseif worldMerchant and NyXConfig.CurrentMerchant == worldMerchant:upper() then
            NyXConfig.MerchantPosition = worldPos
        end

        local merchDisplayStr = 'NONE'
        if NyXConfig.CurrentMerchant ~= 'NONE' then
            if NyXConfig.CurrentMerchant == 'SINISTER S.' and NyXConfig.CurrentDetectedBiome == 'GRAVEYARD' then
                local rem = math.max(0, 660 - NyXConfig.GraveyardElapsed)
                merchDisplayStr = string.format('SINISTER (%s)', FormatMMSS(rem))
                if rem <= 0 then SetMerchantLeftState('11m Expired') end
            else
                local elapsed = os.time() - NyXConfig.MerchantSpawnTimestamp
                local remaining = math.max(0, NyXConfig.MerchantDuration - elapsed)
                merchDisplayStr = string.format('%s (%s)', NyXConfig.CurrentMerchant, FormatMMSS(remaining))
                if remaining <= 0 or (not worldMerchant and elapsed > 15 and NyXConfig.CurrentMerchant ~= 'SINISTER S.') then
                    SetMerchantLeftState(remaining <= 0 and '3m Expired' or 'Despawned')
                end
            end

            if UI.MainWindow.Visible then
                UI.MTabStatusLbl.Text = 'Merchant: ' .. merchDisplayStr
                if NyXConfig.MerchantPosition then
                    local p = NyXConfig.MerchantPosition
                    UI.MTabCoordsLbl.Text = string.format('XYZ: %.0f, %.0f, %.0f', p.X, p.Y, p.Z)
                else
                    UI.MTabCoordsLbl.Text = 'XYZ: Active via Timer'
                end
            end
        else
            if UI.MainWindow.Visible then
                UI.MTabStatusLbl.Text = 'Merchant: NONE'
                UI.MTabCoordsLbl.Text = 'XYZ: N/A'
            end
        end

        UI.BarMerchVal.Text = merchDisplayStr
        UI.BarUptimeVal.Text = GetMacroUptime()
    end
end)

task.spawn(function()
    while NyXEnv.Running and task.wait(2.5) do
        if NyXConfig.AutoCollectItems and not State.IsWalkingPath and NyXConfig.CurrentMerchant == 'NONE' then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild('HumanoidRootPart')
                if not root then return end
                local DropFolder = Svc.Workspace:FindFirstChild('DroppedItems') or Svc.Workspace:FindFirstChild('Items') or Svc.Workspace
                for _, item in ipairs(DropFolder:GetChildren()) do
                    local n = item.Name:upper()
                    if n:find('POTION') or n:find('COIN') or n:find('LUCKY') or n:find('SPEED') or n:find('GILDED') then
                        local part = item:IsA('BasePart') and item or item:FindFirstChildWhichIsA('BasePart')
                        if part and (part.Position - root.Position).Magnitude < 160 and not IsWaypointOverWaterOrVoid(part.Position) then
                            WalkSafelyToTargetPosition(part.Position, function()
                                return not item.Parent or not NyXConfig.AutoCollectItems or NyXConfig.CurrentMerchant ~= 'NONE'
                            end, false)
                            local prompt = item:FindFirstChildWhichIsA('ProximityPrompt', true)
                            if prompt and type(fireproximityprompt) == 'function' then
                                pcall(function() fireproximityprompt(prompt) end)
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while NyXEnv.Running do
        task.wait(1)
        if NyXConfig.AutoBiomeRandomizer or NyXConfig.AutoStrangeController then
            local currentB = GetAccurateServerBiome()
            NyXConfig.CurrentDetectedBiome = currentB
            local shouldStop = NyXConfig.StopAutoBiomes[currentB] == true

            if not shouldStop then
                if NyXConfig.AutoBiomeRandomizer then
                    UseItemWithInventoryFailsafe('Biome Randomizer')
                    for _ = 1, 7 do
                        if not NyXEnv.Running then break end
                        task.wait(0.5)
                        local checkB = GetAccurateServerBiome()
                        NyXConfig.CurrentDetectedBiome = checkB
                        if NyXConfig.StopAutoBiomes[checkB] then
                            shouldStop = true
                            break
                        end
                    end
                end
                if not shouldStop and NyXConfig.AutoStrangeController and not NyXConfig.StopAutoBiomes[GetAccurateServerBiome()] then
                    UseItemWithInventoryFailsafe('Strange Controller')
                end
            end

            local waited = 0
            while NyXEnv.Running and waited < NyXConfig.UseInterval do
                task.wait(1)
                waited = waited + 1
                if not NyXConfig.AutoBiomeRandomizer and not NyXConfig.AutoStrangeController then
                    break
                end
            end
        end
    end
end)

Notify('NyX v9', 'Ready!', 2)
