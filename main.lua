-- // NYX DETECTOR MACRO - v6 (GETGENV PROTECTED + HSIN ICON + LIGHTWEIGHT UI)
local Env = (getgenv and getgenv()) or _G

-- Tự động dọn dẹp phiên bản cũ nếu người dùng chạy lại script (Tránh trùng lặp luồng & Anti-Cheat)
if Env.NyXDetectorEnv and type(Env.NyXDetectorEnv.Cleanup) == 'function' then
    pcall(Env.NyXDetectorEnv.Cleanup)
end

local cloneref = cloneref or function(o) return o end
local function SafeService(name)
    local ok, svc = pcall(function()
        return cloneref(game:GetService(name))
    end)
    return ok and svc or game:GetService(name)
end

local Players = SafeService('Players')
local ReplicatedStorage = SafeService('ReplicatedStorage')
local HttpService = SafeService('HttpService')
local VirtualUser = SafeService('VirtualUser')
local VirtualInputManager = SafeService('VirtualInputManager')
local GuiService = SafeService('GuiService')
local Workspace = SafeService('Workspace')
local CoreGui = SafeService('CoreGui')
local UserInputService = SafeService('UserInputService')
local TextChatService = SafeService('TextChatService')
local Lighting = SafeService('Lighting')
local RunService = SafeService('RunService')
local TeleportService = SafeService('TeleportService')
local PathfindingService = SafeService('PathfindingService')
local SoundService = SafeService('SoundService')

local LocalPlayer = Players.LocalPlayer
local MacroStartTime = 0
local ScreenGui = nil
local Notify = function() end

-- // Khởi tạo môi trường trong getgenv()
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

-- // Tải và chuyển đổi ảnh Logo từ URL Web sang Asset hiển thị được trong Roblox
local HsinLogoURL = 'https://wutheringlab.com/wp-content/uploads/Hsin-icon.webp'
local HsinLogoFile = 'NyX_Hsin_Icon.webp'
local CustomLogoAsset = 'rbxassetid://18648155233' -- Fallback icon nếu executor không hỗ trợ getcustomasset

local function GetHsinLogoAsset()
    local customAssetFunc = getcustomasset or getsynasset
    if customAssetFunc and writefile and isfile then
        local ok, assetId = pcall(function()
            if not isfile(HsinLogoFile) then
                local req = (syn and syn.request) or http_request or request
                if req then
                    local res = req({Url = HsinLogoURL, Method = 'GET'})
                    if res and res.Body then
                        writefile(HsinLogoFile, res.Body)
                    end
                else
                    local body = game:HttpGet(HsinLogoURL)
                    if body then
                        writefile(HsinLogoFile, body)
                    end
                end
            end
            if isfile(HsinLogoFile) then
                return customAssetFunc(HsinLogoFile)
            end
        end)
        if ok and assetId and assetId ~= '' then
            return assetId
        end
    end
    return CustomLogoAsset
end
CustomLogoAsset = GetHsinLogoAsset()

-- // 16 Standard Biomes Data
local BiomeData = {
    ['NORMAL'] = {Color = 0xAAAAAA, Hex = Color3.fromRGB(80, 250, 123), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['WINDY'] = {Color = 0x55FFFF, Hex = Color3.fromRGB(85, 255, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['SNOWY'] = {Color = 0xAAFFFF, Hex = Color3.fromRGB(170, 255, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['RAINY'] = {Color = 0x4477FF, Hex = Color3.fromRGB(68, 119, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['SANDSTORM'] = {Color = 0xCC9955, Hex = Color3.fromRGB(235, 180, 90), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['HELL'] = {Color = 0xFF3300, Hex = Color3.fromRGB(255, 65, 35), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['STARFALL'] = {Color = 0x2266FF, Hex = Color3.fromRGB(80, 140, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['HEAVEN'] = {Color = 0xFFEEAA, Hex = Color3.fromRGB(255, 238, 170), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['LOST FOREST'] = {Color = 0x33FF33, Hex = Color3.fromRGB(51, 255, 51), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['CORRUPTION'] = {Color = 0x8833FF, Hex = Color3.fromRGB(165, 90, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['NULL'] = {Color = 0x777777, Hex = Color3.fromRGB(160, 160, 160), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['GLITCHED'] = {Color = 0x228855, Hex = Color3.fromRGB(60, 220, 140), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['DREAMSPACE'] = {Color = 0xFF66CC, Hex = Color3.fromRGB(255, 102, 204), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['CYBERSPACE'] = {Color = 0x2255AA, Hex = Color3.fromRGB(70, 150, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['SINGULARITY'] = {Color = 0xFF9955, Hex = Color3.fromRGB(255, 153, 85), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['THE RADIANT FOREST'] = {Color = 0xCC33FF, Hex = Color3.fromRGB(204, 51, 255), Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'}
}

local NormalizedBiomeLookup = {
    ['NORMAL'] = 'NORMAL', ['WINDY'] = 'WINDY', ['SNOWY'] = 'SNOWY', ['RAINY'] = 'RAINY',
    ['SANDSTORM'] = 'SANDSTORM', ['SANDY'] = 'SANDSTORM', ['HELL'] = 'HELL', ['STARFALL'] = 'STARFALL',
    ['HEAVEN'] = 'HEAVEN', ['LOSTFOREST'] = 'LOST FOREST', ['CORRUPTION'] = 'CORRUPTION', ['CORRUPTED'] = 'CORRUPTION',
    ['NULL'] = 'NULL', ['GLITCHED'] = 'GLITCHED', ['GLITCH'] = 'GLITCHED', ['DREAMSPACE'] = 'DREAMSPACE',
    ['CYBERSPACE'] = 'CYBERSPACE', ['SINGULARITY'] = 'SINGULARITY',
    ['THERADIANTFOREST'] = 'THE RADIANT FOREST', ['RADIANTFOREST'] = 'THE RADIANT FOREST'
}

local All16Biomes = {
    'NORMAL', 'WINDY', 'SNOWY', 'RAINY', 'SANDSTORM', 'HELL', 
    'STARFALL', 'HEAVEN', 'LOST FOREST', 'CORRUPTION', 'NULL', 
    'GLITCHED', 'DREAMSPACE', 'CYBERSPACE', 'SINGULARITY', 'THE RADIANT FOREST'
}

local All3Merchants = {'Mari', 'Jester', 'Rin'}
local MerchantData = {
    ['Mari'] = {Color = 0x2ECC71, Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['Jester'] = {Color = 0x9B59B6, Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'},
    ['Rin'] = {Color = 0x3498DB, Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'}
}

-- // Lưu trữ Config trong getgenv()
Env.NyXConfig = Env.NyXConfig or {
    WebhookURL = '',
    DiscordID = '',
    PrivateServerLink = '',
    EnableBiomeWebhook = false,
    EnableMerchantWebhook = false,
    AutoWalkToMerchant = false,
    RespawnIfMerchantLeft = false,
    AutoInteractMerchant = false,
    AutoCollectItems = false,
    AutoReconnect = true,
    BlackScreenSaver = false,
    AutoBiomeRandomizer = false,
    AutoStrangeController = false,
    UseInterval = 20,
    StopAutoBiomes = {['GLITCHED'] = true, ['DREAMSPACE'] = true, ['CYBERSPACE'] = true},
    PingBiomes = {['GLITCHED'] = true, ['DREAMSPACE'] = true, ['CYBERSPACE'] = true},
    PingMerchants = {['Mari'] = false, ['Jester'] = false, ['Rin'] = false},
    CurrentDetectedBiome = 'NORMAL',
    CurrentMerchant = 'NONE',
    MerchantSpawnTimestamp = 0,
    MerchantDuration = 180,
    MerchantPosition = nil,
    AntiAFK = true,
    Disable3DRendering = false,
    ShowMiniHUD = true,
    LockUIPosition = false,
    EnableSoundAlert = true,
    WalkSpeedBoost = false,
    CustomWalkSpeed = 24,
    UIAccentColor = Color3.fromRGB(95, 145, 255),
    GlassTransparency = 0.04,
    UIScalePercent = 95
}
local NyXConfig = Env.NyXConfig

for _, bName in ipairs(All16Biomes) do
    if NyXConfig.PingBiomes[bName] == nil then
        NyXConfig.PingBiomes[bName] = false
    end
end

local function PlayAlertSound()
    if not NyXConfig.EnableSoundAlert then return end
    pcall(function()
        local snd = Instance.new('Sound')
        snd.SoundId = 'rbxassetid://4590657391'
        snd.Volume = 2
        snd.Parent = SoundService
        snd:Play()
        task.delay(3, function()
            if snd and snd.Parent then snd:Destroy() end
        end)
    end)
end

-- ==========================================
-- // CONFIG SAVE / LOAD
-- ==========================================
local WebhookConfigFile = 'NyX_WebhookConfig.json'
local function SaveWebhookConfig()
    if writefile then
        pcall(function()
            local data = {
                WebhookURL = NyXConfig.WebhookURL,
                DiscordID = NyXConfig.DiscordID,
                PrivateServerLink = NyXConfig.PrivateServerLink,
                PingBiomes = NyXConfig.PingBiomes,
                PingMerchants = NyXConfig.PingMerchants
            }
            writefile(WebhookConfigFile, HttpService:JSONEncode(data))
        end)
    end
end

local function LoadWebhookConfig()
    if isfile and readfile and isfile(WebhookConfigFile) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(WebhookConfigFile))
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
        end)
    end
end
LoadWebhookConfig()

-- // Anti-AFK & Auto-Reconnect
TrackConnection(LocalPlayer.Idled:Connect(function()
    if not NyXEnv.Running or not NyXConfig.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
        local cam = Workspace.CurrentCamera
        if cam then
            VirtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
        end
    end)
end))

pcall(function()
    TrackConnection(GuiService.ErrorMessageChanged:Connect(function()
        if NyXEnv.Running and NyXConfig.AutoReconnect then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end))
end)

local function GetMacroUptime(forcedElapsed)
    local elapsed = forcedElapsed
    if not elapsed then
        if not NyXConfig.EnableBiomeWebhook or MacroStartTime == 0 then
            return '00:00:00'
        end
        elapsed = math.floor(os.time() - MacroStartTime)
    end
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    return string.format('%02d:%02d:%02d', hours, mins, secs)
end

local function CleanRichText(str)
    if type(str) ~= 'string' then return '' end
    local s = str:gsub('<[^>]+>', '')
    s = s:gsub('^%s+', ''):gsub('%s+$', '')
    return s
end

-- ==========================================
-- // DISCORD WEBHOOK SYSTEM
-- ==========================================
local function BuildUserPingContent(shouldPing)
    if not shouldPing then return '' end
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    if cleanID ~= '' then
        return '<@' .. cleanID .. '>'
    end
    return ''
end

local function SendRawWebhook(payload)
    local cleanUrl = tostring(NyXConfig.WebhookURL or ''):gsub('%s+', '')
    if cleanUrl == '' then return end
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    payload['allowed_mentions'] = {
        ['parse'] = {'users', 'everyone'},
        ['users'] = cleanID ~= '' and {cleanID} or {}
    }
    local req = (syn and syn.request) or http_request or request
    if req then
        pcall(function()
            req({
                Url = cleanUrl,
                Method = 'POST',
                Headers = {['Content-Type'] = 'application/json'},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end

local function SendTestWebhookEmbed(withUserPing)
    local contentMsg = BuildUserPingContent(withUserPing)
    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = withUserPing and 'Ping With User ID - Successfully' or 'Webhook Test - Successfully',
            ['description'] = withUserPing and ('User ID Ping verified for ' .. contentMsg) or 'Connection verified. NyX Detector Macro is ready.',
            ['color'] = 0x2ECC71,
            ['footer'] = {['text'] = 'Project NyX'}
        }}
    })
end

local function SendMacroStateEmbed(isStarted, finalElapsed)
    local currentClock = os.date('%H:%M:%S')
    if isStarted then
        SendRawWebhook({
            ['content'] = '',
            ['embeds'] = {{
                ['title'] = 'Macro Started',
                ['description'] = '**NyX Detector Macro** has started monitoring Biomes and Merchants.\n**Macro Uptime :** `00:00:00`',
                ['color'] = 0x00FF88,
                ['footer'] = {['text'] = 'NyX Detector Macro | ' .. currentClock}
            }}
        })
    else
        local uptimeStr = GetMacroUptime(finalElapsed or 0)
        SendRawWebhook({
            ['content'] = '',
            ['embeds'] = {{
                ['title'] = 'Macro Stopped',
                ['description'] = '**NyX Detector Macro** has been stopped.\n**Total Uptime :** `' .. uptimeStr .. '` *(Reset)*',
                ['color'] = 0xFF3344,
                ['footer'] = {['text'] = 'NyX Detector Macro | ' .. currentClock}
            }}
        })
    end
end

local function SendBiomeStartedEmbed(biomeName, color, imageUrl)
    local shouldPing = NyXConfig.PingBiomes[biomeName] == true
    local contentMsg = BuildUserPingContent(shouldPing)
    local psDisplay = NyXConfig.PrivateServerLink ~= '' and ('[Click to Join Server](' .. NyXConfig.PrivateServerLink .. ')') or '`None`'
    local currentClock = os.date('%H:%M:%S')
    local uptimeStr = GetMacroUptime()
    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = 'Biome Started - ' .. biomeName,
            ['description'] = '**Macro Uptime :** `' .. uptimeStr .. '`\n**Private Server :** ' .. psDisplay,
            ['color'] = color or 0x9B59B6,
            ['thumbnail'] = {['url'] = imageUrl},
            ['footer'] = {['text'] = 'NyX Detector Macro | ' .. currentClock}
        }}
    })
end

local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
    local currentClock = os.date('%H:%M:%S')
    local uptimeStr = GetMacroUptime()
    SendRawWebhook({
        ['content'] = '',
        ['embeds'] = {{
            ['title'] = 'Biome Ended - ' .. biomeName,
            ['description'] = '**Macro Uptime :** `' .. uptimeStr .. '`',
            ['color'] = color or 0x555555,
            ['thumbnail'] = {['url'] = imageUrl},
            ['footer'] = {['text'] = 'NyX Detector Macro | ' .. currentClock}
        }}
    })
end

local function SendMerchantArrivedEmbed(merchantName)
    if not NyXConfig.EnableMerchantWebhook then return end
    local mInfo = MerchantData[merchantName] or {
        Color = 0xF1C40F,
        Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'
    }
    local shouldPing = NyXConfig.PingMerchants[merchantName] == true
    local contentMsg = BuildUserPingContent(shouldPing)
    local psDisplay = NyXConfig.PrivateServerLink ~= '' and ('[Click to Join Server](' .. NyXConfig.PrivateServerLink .. ')') or '`None`'
    SendRawWebhook({
        ['content'] = contentMsg,
        ['embeds'] = {{
            ['title'] = merchantName .. ' has arrived!',
            ['description'] = '**Merchant :** `' .. merchantName .. '`\n**Duration :** `03:00`\n**Macro Uptime :** `' .. GetMacroUptime() .. '`\n**Private Server :** ' .. psDisplay,
            ['color'] = mInfo.Color,
            ['thumbnail'] = {['url'] = mInfo.Image},
            ['footer'] = {['text'] = 'NyX Detector Macro | ' .. os.date('%H:%M:%S')}
        }}
    })
end

-- ==========================================
-- // SMART PATHFINDING + 4-LAYER ANTI-STUCK JUMP
-- ==========================================
local isWalkingPath = false
local cancelCurrentWalk = false
local CachedMerchantObj = nil
local LastFullMerchantScan = 0

local function RespawnCharacterSafely()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if hum then
            hum.Health = 0
        end
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
        if flatDir.Magnitude < 0.1 then
            flatDir = root.CFrame.LookVector
        else
            flatDir = flatDir.Unit
        end

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        for _, yOffset in ipairs({-1.8, -0.8, 0.5}) do
            local origin = root.Position + Vector3.new(0, yOffset, 0)
            local result = Workspace:Raycast(origin, flatDir * 4.2, rayParams)
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
        if combined:find('%f[%a]JESTER%f[%A]') then mName = 'Jester'
        elseif combined:find('%f[%a]RIN%f[%A]') then mName = 'Rin'
        elseif combined:find('%f[%a]MARI%f[%A]') then mName = 'Mari' end
        if mName then
            local part = obj:FindFirstAncestorWhichIsA('BasePart') or (obj.Parent and obj.Parent:IsA('Model') and obj.Parent.PrimaryPart)
            if part then
                return mName, part.Position, obj
            end
        end
    elseif obj:IsA('Model') then
        local n = obj.Name:upper()
        local mName = nil
        if n == 'JESTER' or n == 'MERCHANT_JESTER' or n == 'JESTERNPC' then mName = 'Jester'
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

TrackConnection(Workspace.DescendantAdded:Connect(function(obj)
    if not NyXEnv.Running then return end
    if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
        task.defer(function()
            local mName = MatchMerchantFromObject(obj)
            if mName then
                CachedMerchantObj = obj
            end
        end)
    end
end))

local function FindMerchantWorldPosition(forceScan)
    if CachedMerchantObj and CachedMerchantObj.Parent and CachedMerchantObj:IsDescendantOf(Workspace) then
        local mName, mPos, mPrompt = MatchMerchantFromObject(CachedMerchantObj)
        if mName and mPos then
            return mName, mPos, mPrompt
        end
    end
    CachedMerchantObj = nil

    local now = os.clock()
    if not forceScan and (now - LastFullMerchantScan) < 10 then
        return nil, nil, nil
    end
    LastFullMerchantScan = now

    local foundName, foundPos, foundPrompt = nil, nil, nil
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
                local mName, mPos, mPrompt = MatchMerchantFromObject(obj)
                if mName and mPos then
                    CachedMerchantObj = obj
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
        local result = Workspace:Raycast(pos + Vector3.new(0, 6, 0), Vector3.new(0, -35, 0), rayParams)
        if not result then
            isHazard = true
        elseif result.Material == Enum.Material.Water then
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
        if not NyXEnv.Running or cancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
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
        task.wait(0.06)
    end
end

local function WalkSafelyToTargetPosition(targetPos, stopConditionFunc, isHighPriority)
    if not targetPos then return false end
    if isWalkingPath then
        if isHighPriority then
            cancelCurrentWalk = true
            local waitStart = os.clock()
            while isWalkingPath and (os.clock() - waitStart) < 2.5 do
                task.wait(0.05)
            end
        end
        if isWalkingPath then return false end
    end

    isWalkingPath = true
    cancelCurrentWalk = false
    local reached = false

    local ok, _ = pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not hum or not root or hum.Health <= 0 then
            return
        end

        for attempt = 1, 2 do
            if not NyXEnv.Running or cancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
            if (root.Position - targetPos).Magnitude <= 8 then
                reached = true
                break
            end

            local path = PathfindingService:CreatePath({
                AgentRadius = 2.0,
                AgentHeight = 5.0,
                AgentCanJump = true,
                WaypointSpacing = 3.5,
                Costs = {
                    Water = math.huge,
                    Danger = math.huge
                }
            })

            local computeOk = pcall(function()
                path:ComputeAsync(root.Position, targetPos)
            end)

            if computeOk and path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                for i, wp in ipairs(waypoints) do
                    if i > 1 then
                        if not NyXEnv.Running or cancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
                        if not char.Parent or hum.Health <= 0 then break end

                        local needJump = (wp.Action == Enum.PathWaypointAction.Jump)
                        MoveToSinglePointSmart(char, hum, root, wp.Position, needJump, stopConditionFunc)

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
                        if not NyXEnv.Running or cancelCurrentWalk or (stopConditionFunc and stopConditionFunc()) then break end
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

    isWalkingPath = false
    cancelCurrentWalk = false
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
            Notify('Merchant Pathfinding', 'No active merchant coordinates found in world!', 3)
            return
        end
        Notify('Merchant Pathfinding', 'Walking safely to ' .. tostring(mName or 'Merchant') .. '...', 3.5)
        WalkSafelyToTargetPosition(mPos, function()
            return NyXConfig.CurrentMerchant == 'NONE'
        end, true)
        if NyXConfig.AutoInteractMerchant then
            if not mPrompt then
                _, _, mPrompt = FindMerchantWorldPosition(false)
            end
            if mPrompt and fireproximityprompt then
                pcall(function() fireproximityprompt(mPrompt) end)
            end
        end
    end)
end

-- ==========================================
-- // MERCHANT LIFECYCLE MANAGER (3M TIMER, NO LEFT WEBHOOK)
-- ==========================================
local function SetMerchantArrivedState(merchantName, worldPos)
    if NyXConfig.CurrentMerchant == merchantName:upper() then
        if worldPos then NyXConfig.MerchantPosition = worldPos end
        return
    end
    NyXConfig.CurrentMerchant = merchantName:upper()
    NyXConfig.MerchantSpawnTimestamp = os.time()
    NyXConfig.MerchantPosition = worldPos
    PlayAlertSound()
    SendMerchantArrivedEmbed(merchantName)
    Notify('Merchant Arrived!', merchantName .. ' has arrived! (3m timer started)', 4)
    if NyXConfig.AutoWalkToMerchant then
        WalkToActiveMerchantNow()
    end
end

local function SetMerchantLeftState(reason)
    if NyXConfig.CurrentMerchant == 'NONE' then return end
    local prevMerchant = NyXConfig.CurrentMerchant:sub(1,1):upper() .. NyXConfig.CurrentMerchant:sub(2):lower()
    NyXConfig.CurrentMerchant = 'NONE'
    NyXConfig.MerchantSpawnTimestamp = 0
    NyXConfig.MerchantPosition = nil
    CachedMerchantObj = nil
    Notify('Merchant Left', prevMerchant .. ' has left! (' .. tostring(reason or '3m Elapsed') .. ')', 4)
    if NyXConfig.RespawnIfMerchantLeft then
        Notify('Auto Respawn', 'Respawning character because merchant left...', 3)
        task.wait(0.8)
        RespawnCharacterSafely()
    end
end

-- ==========================================
-- // BIOME SCANNER (CACHED & OPTIMIZED)
-- ==========================================
local CachedBiomeLabels = {}
local LastGuiBiomeScan = 0

local function ParseStrictBiomeToken(rawText, requireBrackets)
    local clean = CleanRichText(rawText):upper()
    if clean == '' or #clean > 38 then return nil end
    local bracketInner = clean:match('^%[%s*(.-)%s*%]$')
    if bracketInner then
        local condensed = bracketInner:gsub('[^A-Z]', '')
        return NormalizedBiomeLookup[condensed]
    end
    if not requireBrackets then
        local condensed = clean:gsub('[^A-Z]', '')
        return NormalizedBiomeLookup[condensed]
    end
    return nil
end

local function IsValidHudBiomeLabel(v)
    if not v:IsA('TextLabel') or not v.Visible or v.Text == '' then return false end
    if ScreenGui and v:IsDescendantOf(ScreenGui) then return false end
    local fullName = v:GetFullName():upper()
    if fullName:find('NYX') or fullName:find('INVENTORY') or fullName:find('BACKPACK')
       or fullName:find('CHAT') or fullName:find('SHOP') or fullName:find('COLLECTION')
       or fullName:find('BESTIARY') or fullName:find('INDEX') or fullName:find('QUEST')
       or fullName:find('CRAFT') or fullName:find('SETTING') or fullName:find('LEADERBOARD')
       or fullName:find('PLAYERLIST') or fullName:find('AURA') or fullName:find('ROLL') then
        return false
    end
    return true
end

local function GetAccurateServerBiome()
    local foundBiome = nil
    pcall(function()
        local candidates = {
            Workspace:GetAttribute('Biome'),
            Workspace:GetAttribute('CurrentBiome'),
            Workspace:GetAttribute('Weather'),
            ReplicatedStorage:GetAttribute('Biome'),
            ReplicatedStorage:GetAttribute('CurrentBiome'),
            Lighting:GetAttribute('Biome'),
            LocalPlayer:GetAttribute('Biome')
        }
        for _, val in ipairs(candidates) do
            if type(val) == 'string' and val ~= '' then
                local m = ParseStrictBiomeToken(val, false)
                if m then foundBiome = m return end
            end
        end
    end)
    if foundBiome then return foundBiome end

    pcall(function()
        for _, root in ipairs({ReplicatedStorage, Workspace, Lighting}) do
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
    if foundBiome then return foundBiome end

    pcall(function()
        for i = #CachedBiomeLabels, 1, -1 do
            local lbl = CachedBiomeLabels[i]
            if not lbl or not lbl.Parent then
                table.remove(CachedBiomeLabels, i)
            elseif lbl.Visible and lbl.Text ~= '' then
                local bMatch = ParseStrictBiomeToken(lbl.Text, true) or ParseStrictBiomeToken(lbl.Text, false)
                if bMatch then
                    foundBiome = bMatch
                    if bMatch ~= 'NORMAL' then return end
                end
            end
        end
    end)
    if foundBiome then return foundBiome end

    local now = os.clock()
    if (now - LastGuiBiomeScan) < 8 then
        return 'NORMAL'
    end
    LastGuiBiomeScan = now

    pcall(function()
        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end
        local bracketedMatch = nil
        local exactHudLabelMatch = nil
        table.clear(CachedBiomeLabels)
        for _, v in ipairs(pGui:GetDescendants()) do
            if IsValidHudBiomeLabel(v) then
                local bMatch = ParseStrictBiomeToken(v.Text, true)
                local lblName = v.Name:upper()
                local isNamedBiome = (lblName == 'BIOME' or lblName == 'BIOMELABEL' or lblName == 'BIOMETEXT' or lblName == 'CURRENTBIOME')
                if bMatch then
                    table.insert(CachedBiomeLabels, v)
                    bracketedMatch = bMatch
                elseif isNamedBiome then
                    table.insert(CachedBiomeLabels, v)
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
    if clean:find('%f[%a]JESTER%f[%A]') then
        mName = 'Jester'
    elseif clean:find('%f[%a]RIN%f[%A]') then
        mName = 'Rin'
    elseif clean:find('%f[%a]MARI%f[%A]') then
        mName = 'Mari'
    end
    if not mName then return nil, nil end
    if clean:find('HAS LEFT') or clean:find('DESPAWN') or clean:find('DEPARTED') or clean:find('GONE') then
        return mName, 'LEFT'
    elseif clean:find('HAS ARRIVED') or clean:find('HAS SPAWNED') or clean:find('APPEARED') then
        return mName, 'ARRIVED'
    end
    return nil, nil
end

pcall(function()
    if TextChatService and TextChatService.MessageReceived then
        TrackConnection(TextChatService.MessageReceived:Connect(function(message)
            if not NyXEnv.Running then return end
            if message.TextSource ~= nil then return end
            local txt = (message.Text or '') .. ' ' .. (message.PrefixText or '')
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
        if getconnections then
            for _, conn in pairs(getconnections(guiObj.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(guiObj.Activated)) do conn:Fire() end
        end
        if firesignal then
            pcall(firesignal, guiObj.MouseButton1Click)
            pcall(firesignal, guiObj.Activated)
        end
        local pos = guiObj.AbsolutePosition
        local size = guiObj.AbsoluteSize
        local inset = GuiService:GetGuiInset()
        local centerX = pos.X + (size.X / 2)
        local centerY = pos.Y + (size.Y / 2) + inset.Y
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
        task.wait(0.06)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
    end)
end

local isUsingInventoryFailsafe = false
local function UseItemWithInventoryFailsafe(itemName)
    if isUsingInventoryFailsafe then return end
    isUsingInventoryFailsafe = true

    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild('Remotes') or ReplicatedStorage:FindFirstChild('Events')
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
            if not ScreenGui or not v:IsDescendantOf(ScreenGui) then
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
                if not ScreenGui or not btn:IsDescendantOf(ScreenGui) then
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
            if not ScreenGui or not box:IsDescendantOf(ScreenGui) then
                if box:IsA('TextBox') and box.Visible and (box.PlaceholderText:lower():find('search') or box.Name:lower():find('search')) then
                    box.Text = itemName
                    task.wait(0.2)
                    break
                end
            end
        end
        local foundItemSlot = nil
        for _, lbl in pairs(pGui:GetDescendants()) do
            if not ScreenGui or not lbl:IsDescendantOf(ScreenGui) then
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
                if not ScreenGui or not btn:IsDescendantOf(ScreenGui) then
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
        if wasClosed and invFrame then
            invFrame.Visible = false
        end
    end)

    isUsingInventoryFailsafe = false
end

-- ==========================================
-- // REDESIGNED ULTRA-LIGHTWEIGHT FLAT UI (HSIN LOGO)
-- ==========================================
local ParentGui = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild('PlayerGui')
if ParentGui:FindFirstChild('NyXMacroUI') then
    ParentGui.NyXMacroUI:Destroy()
end

ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'NyXMacroUI'
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- OLED Black Screen Saver
local BlackSaverFrame = Instance.new('Frame')
BlackSaverFrame.Size = UDim2.new(1, 0, 1, 0)
BlackSaverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackSaverFrame.BorderSizePixel = 0
BlackSaverFrame.Visible = NyXConfig.BlackScreenSaver
BlackSaverFrame.ZIndex = 1
BlackSaverFrame.Parent = ScreenGui

local BlackSaverLabel = Instance.new('TextLabel', BlackSaverFrame)
BlackSaverLabel.Size = UDim2.new(1, 0, 0, 30)
BlackSaverLabel.Position = UDim2.new(0, 0, 0.46, 0)
BlackSaverLabel.BackgroundTransparency = 1
BlackSaverLabel.Text = 'OLED BATTERY SAVER ACTIVE'
BlackSaverLabel.Font = Enum.Font.GothamBold
BlackSaverLabel.TextSize = 13
BlackSaverLabel.TextColor3 = Color3.fromRGB(100, 105, 125)
BlackSaverLabel.ZIndex = 2

local AccentObjects = {}
local DynamicAccentCallbacks = {}

local function RegisterAccent(obj, prop)
    table.insert(AccentObjects, {Obj = obj, Prop = prop})
    obj[prop] = NyXConfig.UIAccentColor
end

local function RegisterDynamicAccent(fn)
    table.insert(DynamicAccentCallbacks, fn)
end

local function UpdateAccentColor(newColor)
    NyXConfig.UIAccentColor = newColor
    for _, item in ipairs(AccentObjects) do
        pcall(function() item.Obj[item.Prop] = newColor end)
    end
    for _, fn in ipairs(DynamicAccentCallbacks) do
        pcall(fn, newColor)
    end
end

-- Lightweight Toast Notification
local ToastHolder = Instance.new('Frame', ScreenGui)
ToastHolder.Size = UDim2.new(0, 210, 1, -16)
ToastHolder.Position = UDim2.new(1, -220, 0, 8)
ToastHolder.BackgroundTransparency = 1
ToastHolder.ZIndex = 20

local ToastLayout = Instance.new('UIListLayout', ToastHolder)
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.Padding = UDim.new(0, 5)

Notify = function(title, text, duration)
    task.spawn(function()
        if not ScreenGui or not ScreenGui.Parent then return end
        local Card = Instance.new('Frame', ToastHolder)
        Card.Size = UDim2.new(1, 0, 0, 44)
        Card.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
        Card.BorderSizePixel = 0
        Card.ZIndex = 21
        Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

        local AccentLeft = Instance.new('Frame', Card)
        AccentLeft.Size = UDim2.new(0, 3, 1, -10)
        AccentLeft.Position = UDim2.new(0, 4, 0, 5)
        AccentLeft.BackgroundColor3 = NyXConfig.UIAccentColor
        AccentLeft.BorderSizePixel = 0
        AccentLeft.ZIndex = 22
        Instance.new('UICorner', AccentLeft).CornerRadius = UDim.new(1, 0)

        local Tbl = Instance.new('TextLabel', Card)
        Tbl.Size = UDim2.new(1, -18, 0, 16)
        Tbl.Position = UDim2.new(0, 12, 0, 4)
        Tbl.BackgroundTransparency = 1
        Tbl.Text = title
        Tbl.TextColor3 = Color3.fromRGB(245, 247, 255)
        Tbl.Font = Enum.Font.GothamBold
        Tbl.TextSize = 11
        Tbl.ZIndex = 22
        Tbl.TextXAlignment = Enum.TextXAlignment.Left

        local Sub = Instance.new('TextLabel', Card)
        Sub.Size = UDim2.new(1, -18, 0, 18)
        Sub.Position = UDim2.new(0, 12, 0, 20)
        Sub.BackgroundTransparency = 1
        Sub.Text = text
        Sub.TextColor3 = Color3.fromRGB(165, 170, 190)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 9
        Sub.TextWrapped = true
        Sub.ZIndex = 22
        Sub.TextXAlignment = Enum.TextXAlignment.Left

        task.wait(duration or 3)
        if Card and Card.Parent then Card:Destroy() end
    end)
end

-- // Mini Status HUD Bar
local MiniHUD = Instance.new('Frame', ScreenGui)
MiniHUD.AnchorPoint = Vector2.new(0.5, 0)
MiniHUD.Size = UDim2.new(0, 300, 0, 24)
MiniHUD.Position = UDim2.new(0.5, 0, 0, 8)
MiniHUD.BackgroundColor3 = Color3.fromRGB(16, 18, 25)
MiniHUD.BackgroundTransparency = 0.08
MiniHUD.BorderSizePixel = 0
MiniHUD.Active = true
MiniHUD.Visible = NyXConfig.ShowMiniHUD
MiniHUD.ZIndex = 25
Instance.new('UICorner', MiniHUD).CornerRadius = UDim.new(0, 6)

local MiniHUDText = Instance.new('TextLabel', MiniHUD)
MiniHUDText.Size = UDim2.new(1, -12, 1, 0)
MiniHUDText.Position = UDim2.new(0, 6, 0, 0)
MiniHUDText.BackgroundTransparency = 1
MiniHUDText.Text = 'BIOME: NORMAL  |  MERCHANT: NONE  |  00:00:00'
MiniHUDText.Font = Enum.Font.GothamBold
MiniHUDText.TextSize = 10
MiniHUDText.TextColor3 = Color3.fromRGB(235, 240, 255)
MiniHUDText.ZIndex = 26

-- // Redesigned Streamlined Main Window (490x295)
local MainWindow = Instance.new('Frame', ScreenGui)
MainWindow.Name = 'MainWindow'
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Size = UDim2.new(0, 490, 0, 295)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.ZIndex = 5
Instance.new('UICorner', MainWindow).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new('UIStroke', MainWindow)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
RegisterAccent(MainStroke, 'Color')

local WindowScale = Instance.new('UIScale', MainWindow)
local function RecalculateResponsiveScale()
    pcall(function()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 480)
        local autoRatio = math.clamp(math.min(vp.X / 550, vp.Y / 335), 0.65, 1.1)
        WindowScale.Scale = autoRatio * (NyXConfig.UIScalePercent / 100)
    end)
end
RecalculateResponsiveScale()
if Workspace.CurrentCamera then
    TrackConnection(Workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(RecalculateResponsiveScale))
end

-- // Floating Hsin Image Logo Toggle Button (Thay thế nút chữ ND NyX cũ)
local LogoToggleBtn = Instance.new('ImageButton', ScreenGui)
LogoToggleBtn.Name = 'HsinToggleBtn'
LogoToggleBtn.Size = UDim2.new(0, 46, 0, 46)
LogoToggleBtn.Position = UDim2.new(0.03, 0, 0.2, 0)
LogoToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
LogoToggleBtn.Image = CustomLogoAsset
LogoToggleBtn.ScaleType = Enum.ScaleType.Fit
LogoToggleBtn.Active = true
LogoToggleBtn.ZIndex = 30
Instance.new('UICorner', LogoToggleBtn).CornerRadius = UDim.new(0, 10)

local LogoBtnStroke = Instance.new('UIStroke', LogoToggleBtn)
LogoBtnStroke.Thickness = 1.5
RegisterAccent(LogoBtnStroke, 'Color')

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
    TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and not NyXConfig.LockUIPosition and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                hasMoved = true
                targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end))
    TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not hasMoved and onClickCallback then
                    onClickCallback()
                end
            end
        end
    end))
end

MakeDraggable(LogoToggleBtn, LogoToggleBtn, function()
    MainWindow.Visible = not MainWindow.Visible
end)
MakeDraggable(MiniHUD, MiniHUD, function()
    MainWindow.Visible = not MainWindow.Visible
end)

-- // Top Bar & Compact Left Sidebar
local Sidebar = Instance.new('Frame', MainWindow)
Sidebar.Size = UDim2.new(0, 128, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
Sidebar.BorderSizePixel = 0
Instance.new('UICorner', Sidebar).CornerRadius = UDim.new(0, 10)

-- Sidebar Hsin Logo Image
local BrandImage = Instance.new('ImageLabel', Sidebar)
BrandImage.Size = UDim2.new(0, 30, 0, 30)
BrandImage.Position = UDim2.new(0, 10, 0, 10)
BrandImage.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
BrandImage.Image = CustomLogoAsset
BrandImage.ScaleType = Enum.ScaleType.Fit
Instance.new('UICorner', BrandImage).CornerRadius = UDim.new(0, 7)

local BrandTitle = Instance.new('TextLabel', Sidebar)
BrandTitle.Size = UDim2.new(1, -46, 0, 16)
BrandTitle.Position = UDim2.new(0, 44, 0, 10)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = 'NyX Macro'
BrandTitle.Font = Enum.Font.GothamBlack
BrandTitle.TextSize = 12
BrandTitle.TextColor3 = Color3.fromRGB(245, 247, 255)
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

local BrandSub = Instance.new('TextLabel', Sidebar)
BrandSub.Size = UDim2.new(1, -46, 0, 12)
BrandSub.Position = UDim2.new(0, 44, 0, 25)
BrandSub.BackgroundTransparency = 1
BrandSub.Text = 'LITE v6'
BrandSub.Font = Enum.Font.GothamBold
BrandSub.TextSize = 9
BrandSub.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(BrandSub, 'TextColor3')

MakeDraggable(Sidebar, MainWindow)

local CloseBtn = Instance.new('TextButton', MainWindow)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = '×'
CloseBtn.TextColor3 = Color3.fromRGB(200, 205, 225)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new('UICorner', CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

local NavHolder = Instance.new('Frame', Sidebar)
NavHolder.Size = UDim2.new(1, -14, 1, -54)
NavHolder.Position = UDim2.new(0, 7, 0, 46)
NavHolder.BackgroundTransparency = 1
local NavLayout = Instance.new('UIListLayout', NavHolder)
NavLayout.Padding = UDim.new(0, 4)

local ContentArea = Instance.new('Frame', MainWindow)
ContentArea.Size = UDim2.new(1, -132, 1, 0)
ContentArea.Position = UDim2.new(0, 132, 0, 0)
ContentArea.BackgroundTransparency = 1

local Pages = {}
local NavButtons = {}

local function CreateTabPage(tabName, subtitleText)
    local Page = Instance.new('Frame', ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local HeaderTitle = Instance.new('TextLabel', Page)
    HeaderTitle.Size = UDim2.new(1, -48, 0, 18)
    HeaderTitle.Position = UDim2.new(0, 12, 0, 9)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = tabName
    HeaderTitle.Font = Enum.Font.GothamBlack
    HeaderTitle.TextSize = 14
    HeaderTitle.TextColor3 = Color3.fromRGB(245, 247, 255)
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local HeaderSub = Instance.new('TextLabel', Page)
    HeaderSub.Size = UDim2.new(1, -48, 0, 12)
    HeaderSub.Position = UDim2.new(0, 12, 0, 26)
    HeaderSub.BackgroundTransparency = 1
    HeaderSub.Text = subtitleText
    HeaderSub.Font = Enum.Font.Gotham
    HeaderSub.TextSize = 9
    HeaderSub.TextColor3 = Color3.fromRGB(145, 150, 175)
    HeaderSub.TextXAlignment = Enum.TextXAlignment.Left

    local Scroll = Instance.new('ScrollingFrame', Page)
    Scroll.Size = UDim2.new(1, -20, 1, -48)
    Scroll.Position = UDim2.new(0, 10, 0, 42)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RegisterAccent(Scroll, 'ScrollBarImageColor3')

    local ScrollLayout = Instance.new('UIListLayout', Scroll)
    ScrollLayout.Padding = UDim.new(0, 5)

    local NavBtn = Instance.new('TextButton', NavHolder)
    NavBtn.Size = UDim2.new(1, 0, 0, 28)
    NavBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
    NavBtn.BackgroundTransparency = 1
    NavBtn.BorderSizePixel = 0
    NavBtn.Text = '   ' .. tabName
    NavBtn.Font = Enum.Font.GothamBold
    NavBtn.TextSize = 11
    NavBtn.TextColor3 = Color3.fromRGB(155, 160, 185)
    NavBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', NavBtn).CornerRadius = UDim.new(0, 6)

    local ActiveBar = Instance.new('Frame', NavBtn)
    ActiveBar.Size = UDim2.new(0, 3, 0, 14)
    ActiveBar.Position = UDim2.new(0, 0, 0.5, -7)
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    Instance.new('UICorner', ActiveBar).CornerRadius = UDim.new(1, 0)
    RegisterAccent(ActiveBar, 'BackgroundColor3')

    NavBtn.MouseButton1Click:Connect(function()
        for _, p in ipairs(Pages) do p.Visible = false end
        for _, b in ipairs(NavButtons) do
            b.Btn.BackgroundTransparency = 1
            b.Btn.TextColor3 = Color3.fromRGB(155, 160, 185)
            b.Bar.Visible = false
        end
        Page.Visible = true
        NavBtn.BackgroundTransparency = 0
        NavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveBar.Visible = true
    end)

    table.insert(Pages, Page)
    table.insert(NavButtons, {Btn = NavBtn, Bar = ActiveBar})
    return Scroll, NavBtn, ActiveBar
end

local function AddSectionLabel(parent, text)
    local Lbl = Instance.new('TextLabel', parent)
    Lbl.Size = UDim2.new(1, -4, 0, 16)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = '• ' .. text:upper()
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 9
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterAccent(Lbl, 'TextColor3')
end

local function AddToggle(parent, title, subtext, defaultVal, callback)
    local Card = Instance.new('TextButton', parent)
    Card.Size = UDim2.new(1, -4, 0, 36)
    Card.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
    Card.BorderSizePixel = 0
    Card.Text = ''
    Card.AutoButtonColor = false
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -58, 0, 15)
    TitleLbl.Position = UDim2.new(0, 10, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextColor3 = Color3.fromRGB(240, 242, 252)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SubLbl = Instance.new('TextLabel', Card)
    SubLbl.Size = UDim2.new(1, -58, 0, 13)
    SubLbl.Position = UDim2.new(0, 10, 0, 19)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = subtext
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextSize = 8
    SubLbl.TextColor3 = Color3.fromRGB(140, 145, 168)
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new('Frame', Card)
    SwitchBg.Size = UDim2.new(0, 34, 0, 16)
    SwitchBg.Position = UDim2.new(1, -44, 0.5, -8)
    SwitchBg.BorderSizePixel = 0
    SwitchBg.BackgroundColor3 = defaultVal and NyXConfig.UIAccentColor or Color3.fromRGB(45, 48, 65)
    Instance.new('UICorner', SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new('Frame', SwitchBg)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = defaultVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new('UICorner', Knob).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    RegisterDynamicAccent(function(newCol)
        if state then SwitchBg.BackgroundColor3 = newCol end
    end)

    Card.MouseButton1Click:Connect(function()
        state = not state
        SwitchBg.BackgroundColor3 = state and NyXConfig.UIAccentColor or Color3.fromRGB(45, 48, 65)
        Knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end)
end

local function AddInput(parent, title, defaultText, placeholder, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -4, 0, 44)
    Card.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
    Card.BorderSizePixel = 0
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -16, 0, 14)
    TitleLbl.Position = UDim2.new(0, 8, 0, 3)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 9
    TitleLbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new('TextBox', Card)
    Box.Size = UDim2.new(1, -16, 0, 20)
    Box.Position = UDim2.new(0, 8, 0, 19)
    Box.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    Box.BorderSizePixel = 0
    Box.Text = defaultText or ''
    Box.PlaceholderText = placeholder or ''
    Box.TextColor3 = Color3.fromRGB(240, 242, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(105, 110, 130)
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
    Btn.Size = UDim2.new(1, -4, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(26, 30, 44)
    Btn.BorderSizePixel = 0
    Btn.Text = title
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.TextColor3 = Color3.fromRGB(245, 247, 255)
    Instance.new('UICorner', Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function AddSlider(parent, title, minVal, maxVal, defaultVal, suffix, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -4, 0, 38)
    Card.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
    Card.BorderSizePixel = 0
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -16, 0, 14)
    TitleLbl.Position = UDim2.new(0, 8, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title .. ': ' .. tostring(defaultVal) .. (suffix or '')
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 9
    TitleLbl.TextColor3 = Color3.fromRGB(235, 238, 250)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local BarBg = Instance.new('TextButton', Card)
    BarBg.Size = UDim2.new(1, -16, 0, 7)
    BarBg.Position = UDim2.new(0, 8, 0, 23)
    BarBg.BackgroundColor3 = Color3.fromRGB(13, 15, 20)
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
    TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromInput(input)
        end
    end))
    TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end))
end

-- ==========================================
-- // BUILD THE 6 TABS
-- ==========================================
local HomeScroll, HomeNavBtn, HomeNavBar = CreateTabPage('Home', 'Live status & quick controls')
local MainScroll = CreateTabPage('Main', 'Biome detector & item automation')
local MerchantScroll = CreateTabPage('Merchant', '3m Merchant tracker & smart walk')
local ConnScroll = CreateTabPage('Webhook', 'Discord Webhook, User ID & Server link')
local PingsScroll = CreateTabPage('Pings', '16 Biomes & 3 Merchants ping filter')
local SettingScroll = CreateTabPage('Settings', 'UI tools, speed, FPS & system')

Pages[1].Visible = true
HomeNavBtn.BackgroundTransparency = 0
HomeNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeNavBar.Visible = true

-- // TAB 1: HOME
local StatusRow = Instance.new('Frame', HomeScroll)
StatusRow.Size = UDim2.new(1, -4, 0, 48)
StatusRow.BackgroundTransparency = 1

local UptimeCard = Instance.new('Frame', StatusRow)
UptimeCard.Size = UDim2.new(0.49, 0, 1, 0)
UptimeCard.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
UptimeCard.BorderSizePixel = 0
Instance.new('UICorner', UptimeCard).CornerRadius = UDim.new(0, 6)

local UpTitle = Instance.new('TextLabel', UptimeCard)
UpTitle.Size = UDim2.new(1, -16, 0, 13)
UpTitle.Position = UDim2.new(0, 10, 0, 6)
UpTitle.BackgroundTransparency = 1
UpTitle.Text = 'MACRO UPTIME'
UpTitle.Font = Enum.Font.GothamBold
UpTitle.TextSize = 8
UpTitle.TextColor3 = Color3.fromRGB(145, 150, 175)
UpTitle.TextXAlignment = Enum.TextXAlignment.Left

local UptimeValueLabel = Instance.new('TextLabel', UptimeCard)
UptimeValueLabel.Size = UDim2.new(1, -16, 0, 20)
UptimeValueLabel.Position = UDim2.new(0, 10, 0, 20)
UptimeValueLabel.BackgroundTransparency = 1
UptimeValueLabel.Text = '00:00:00'
UptimeValueLabel.Font = Enum.Font.GothamBlack
UptimeValueLabel.TextSize = 14
UptimeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(UptimeValueLabel, 'TextColor3')

local BiomeCard = Instance.new('Frame', StatusRow)
BiomeCard.Size = UDim2.new(0.49, 0, 1, 0)
BiomeCard.Position = UDim2.new(0.51, 0, 0, 0)
BiomeCard.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
BiomeCard.BorderSizePixel = 0
Instance.new('UICorner', BiomeCard).CornerRadius = UDim.new(0, 6)

local BmTitle = Instance.new('TextLabel', BiomeCard)
BmTitle.Size = UDim2.new(1, -16, 0, 13)
BmTitle.Position = UDim2.new(0, 10, 0, 6)
BmTitle.BackgroundTransparency = 1
BmTitle.Text = 'CURRENT BIOME'
BmTitle.Font = Enum.Font.GothamBold
BmTitle.TextSize = 8
BmTitle.TextColor3 = Color3.fromRGB(145, 150, 175)
BmTitle.TextXAlignment = Enum.TextXAlignment.Left

local BiomeValueLabel = Instance.new('TextLabel', BiomeCard)
BiomeValueLabel.Size = UDim2.new(1, -16, 0, 20)
BiomeValueLabel.Position = UDim2.new(0, 10, 0, 20)
BiomeValueLabel.BackgroundTransparency = 1
BiomeValueLabel.Text = 'NORMAL'
BiomeValueLabel.Font = Enum.Font.GothamBlack
BiomeValueLabel.TextSize = 13
BiomeValueLabel.TextColor3 = Color3.fromRGB(80, 250, 123)
BiomeValueLabel.TextXAlignment = Enum.TextXAlignment.Left

local MerchantStatusCard = Instance.new('Frame', HomeScroll)
MerchantStatusCard.Size = UDim2.new(1, -4, 0, 34)
MerchantStatusCard.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
MerchantStatusCard.BorderSizePixel = 0
Instance.new('UICorner', MerchantStatusCard).CornerRadius = UDim.new(0, 6)

local MerTitle = Instance.new('TextLabel', MerchantStatusCard)
MerTitle.Size = UDim2.new(0.55, 0, 1, 0)
MerTitle.Position = UDim2.new(0, 10, 0, 0)
MerTitle.BackgroundTransparency = 1
MerTitle.Text = 'Active Merchant (3m):'
MerTitle.Font = Enum.Font.GothamBold
MerTitle.TextSize = 10
MerTitle.TextColor3 = Color3.fromRGB(180, 185, 210)
MerTitle.TextXAlignment = Enum.TextXAlignment.Left

local MerchantValueLabel = Instance.new('TextLabel', MerchantStatusCard)
MerchantValueLabel.Size = UDim2.new(0.4, -10, 1, 0)
MerchantValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
MerchantValueLabel.BackgroundTransparency = 1
MerchantValueLabel.Text = 'NONE'
MerchantValueLabel.Font = Enum.Font.GothamBlack
MerchantValueLabel.TextSize = 11
MerchantValueLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
MerchantValueLabel.TextXAlignment = Enum.TextXAlignment.Right

AddSectionLabel(HomeScroll, 'Quick Controls')
AddToggle(HomeScroll, 'Start Biome & State Detector', 'Enable macro timer & Discord biome notifications.', NyXConfig.EnableBiomeWebhook, function(val)
    if val then
        NyXConfig.EnableBiomeWebhook = true
        MacroStartTime = os.time()
        SendMacroStateEmbed(true)
        Notify('NyX Macro', 'Macro Started!', 2.5)
    else
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        NyXConfig.EnableBiomeWebhook = false
        SendMacroStateEmbed(false, finalElapsed)
        MacroStartTime = 0
        UptimeValueLabel.Text = '00:00:00'
        Notify('NyX Macro', 'Macro Stopped!', 2.5)
    end
end)

AddButton(HomeScroll, 'Unstuck Character Jump (Thoát kẹt gạch)', function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if hum and root then
            ForceCharacterJump(hum)
            root.CFrame = root.CFrame + Vector3.new(0, 4, 0)
            Notify('Unstuck', 'Character lifted out of obstacle!', 2)
        end
    end)
end)

-- // TAB 2: MAIN
AddSectionLabel(MainScroll, 'Ground Item Collector')
AddToggle(MainScroll, 'Auto Collect Ground Items', 'Walks & jumps safely to nearby potions/coins.', NyXConfig.AutoCollectItems, function(val)
    NyXConfig.AutoCollectItems = val
end)

AddSectionLabel(MainScroll, 'Inventory Automation')
AddButton(MainScroll, 'Use Now: Biome Randomizer', function()
    task.spawn(function() UseItemWithInventoryFailsafe('Biome Randomizer') end)
end)
AddButton(MainScroll, 'Use Now: Strange Controller', function()
    task.spawn(function() UseItemWithInventoryFailsafe('Strange Controller') end)
end)
AddSlider(MainScroll, 'Item Use Interval', 5, 300, NyXConfig.UseInterval, 's', function(val)
    NyXConfig.UseInterval = val
end)
AddToggle(MainScroll, 'Auto Biome Randomizer', 'Uses Biome Randomizer on interval.', NyXConfig.AutoBiomeRandomizer, function(val)
    NyXConfig.AutoBiomeRandomizer = val
end)
AddToggle(MainScroll, 'Auto Strange Controller', 'Uses Strange Controller on interval.', NyXConfig.AutoStrangeController, function(val)
    NyXConfig.AutoStrangeController = val
end)

AddSectionLabel(MainScroll, 'Stop Auto In (Target Biomes)')
local StopGridFrame = Instance.new('Frame', MainScroll)
StopGridFrame.Size = UDim2.new(1, -4, 0, 112)
StopGridFrame.BackgroundTransparency = 1
local GridLayout = Instance.new('UIGridLayout', StopGridFrame)
GridLayout.CellSize = UDim2.new(0.24, -3, 0, 23)
GridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All16Biomes) do
    local Chip = Instance.new('TextButton', StopGridFrame)
    local isOn = NyXConfig.StopAutoBiomes[bName] == true
    Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
    Chip.BorderSizePixel = 0
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 8
    Chip.TextColor3 = Color3.fromRGB(240, 242, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 4)

    RegisterDynamicAccent(function(newCol)
        if NyXConfig.StopAutoBiomes[bName] then Chip.BackgroundColor3 = newCol end
    end)

    Chip.MouseButton1Click:Connect(function()
        NyXConfig.StopAutoBiomes[bName] = not NyXConfig.StopAutoBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.StopAutoBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
    end)
end

-- // TAB 3: MERCHANT
AddSectionLabel(MerchantScroll, '3-Minute Merchant Status')
local MerchantLiveCard = Instance.new('Frame', MerchantScroll)
MerchantLiveCard.Size = UDim2.new(1, -4, 0, 42)
MerchantLiveCard.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
MerchantLiveCard.BorderSizePixel = 0
Instance.new('UICorner', MerchantLiveCard).CornerRadius = UDim.new(0, 6)

local MTabStatusLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabStatusLbl.Size = UDim2.new(1, -16, 0, 16)
MTabStatusLbl.Position = UDim2.new(0, 8, 0, 4)
MTabStatusLbl.BackgroundTransparency = 1
MTabStatusLbl.Text = 'Status: NONE (Waiting for Spawn)'
MTabStatusLbl.Font = Enum.Font.GothamBold
MTabStatusLbl.TextSize = 10
MTabStatusLbl.TextColor3 = Color3.fromRGB(240, 242, 255)
MTabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local MTabCoordsLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabCoordsLbl.Size = UDim2.new(1, -16, 0, 14)
MTabCoordsLbl.Position = UDim2.new(0, 8, 0, 22)
MTabCoordsLbl.BackgroundTransparency = 1
MTabCoordsLbl.Text = 'XYZ Coordinates: N/A'
MTabCoordsLbl.Font = Enum.Font.Gotham
MTabCoordsLbl.TextSize = 9
MTabCoordsLbl.TextColor3 = Color3.fromRGB(150, 155, 180)
MTabCoordsLbl.TextXAlignment = Enum.TextXAlignment.Left

AddToggle(MerchantScroll, 'Enable Merchant Arrived Webhook', 'Sends Discord webhook on arrival (No Left webhook).', NyXConfig.EnableMerchantWebhook, function(val)
    NyXConfig.EnableMerchantWebhook = val
end)
AddToggle(MerchantScroll, 'Auto Walk & Jump to Merchant', 'Smart obstacle jump & river avoidance.', NyXConfig.AutoWalkToMerchant, function(val)
    NyXConfig.AutoWalkToMerchant = val
end)
AddToggle(MerchantScroll, 'Auto Open Shop on Arrival', 'Fires ProximityPrompt when reaching merchant.', NyXConfig.AutoInteractMerchant, function(val)
    NyXConfig.AutoInteractMerchant = val
end)
AddToggle(MerchantScroll, 'Respawn When Merchant Leaves (3m)', 'Resets character after 3m merchant despawns.', NyXConfig.RespawnIfMerchantLeft, function(val)
    NyXConfig.RespawnIfMerchantLeft = val
end)
AddButton(MerchantScroll, 'Walk Safely to Active Merchant Now', function()
    WalkToActiveMerchantNow()
end)
AddButton(MerchantScroll, 'Stop Walking Path', function()
    cancelCurrentWalk = true
    Notify('Pathfinding', 'Stopped walking.', 2)
end)

-- // TAB 4: WEBHOOK
local ConnUserIDBox, PingUserIDBox
AddSectionLabel(ConnScroll, 'Discord Configuration')
AddInput(ConnScroll, 'Webhook URL', NyXConfig.WebhookURL, 'https://discord.com/api/webhooks/...', function(txt)
    NyXConfig.WebhookURL = txt:gsub('%s+', '')
end)
ConnUserIDBox = AddInput(ConnScroll, 'Discord User ID', NyXConfig.DiscordID, 'Numeric ID (Ex: 1234567890)', function(txt)
    local clean = txt:gsub('%D+', '')
    NyXConfig.DiscordID = clean
    if PingUserIDBox and PingUserIDBox.Text ~= clean then PingUserIDBox.Text = clean end
end)
AddInput(ConnScroll, 'Private Server Link', NyXConfig.PrivateServerLink, 'https://www.roblox.com/games/...', function(txt)
    NyXConfig.PrivateServerLink = txt
end)
AddButton(ConnScroll, 'Save Config to File', function()
    SaveWebhookConfig()
    Notify('Saved', 'Configuration saved!', 2.5)
end)
AddButton(ConnScroll, 'Test Webhook Connection', function()
    SendTestWebhookEmbed(false)
    Notify('Webhook Test', 'Sent test embed to Discord!', 2.5)
end)

-- // TAB 5: PINGS
AddSectionLabel(PingsScroll, 'User ID for Mention Pings')
PingUserIDBox = AddInput(PingsScroll, 'Your Discord User ID', NyXConfig.DiscordID, 'Enter numeric Discord ID...', function(txt)
    local clean = txt:gsub('%D+', '')
    NyXConfig.DiscordID = clean
    if ConnUserIDBox and ConnUserIDBox.Text ~= clean then ConnUserIDBox.Text = clean end
end)
AddButton(PingsScroll, 'Test User ID Ping', function()
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    if cleanID == '' then
        Notify('User ID Required', 'Enter your Discord User ID first!', 3)
        return
    end
    SendTestWebhookEmbed(true)
    Notify('Ping Sent', 'Sent ping to <@' .. cleanID .. '>!', 2.5)
end)

AddSectionLabel(PingsScroll, 'Biome Pings (16 Biomes)')
local PingBiomeGrid = Instance.new('Frame', PingsScroll)
PingBiomeGrid.Size = UDim2.new(1, -4, 0, 112)
PingBiomeGrid.BackgroundTransparency = 1
local PGridLayout = Instance.new('UIGridLayout', PingBiomeGrid)
PGridLayout.CellSize = UDim2.new(0.24, -3, 0, 23)
PGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All16Biomes) do
    local Chip = Instance.new('TextButton', PingBiomeGrid)
    local isOn = NyXConfig.PingBiomes[bName] == true
    Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
    Chip.BorderSizePixel = 0
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 8
    Chip.TextColor3 = Color3.fromRGB(240, 242, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 4)

    RegisterDynamicAccent(function(newCol)
        if NyXConfig.PingBiomes[bName] then Chip.BackgroundColor3 = newCol end
    end)

    Chip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingBiomes[bName] and cleanID == '' then
            Notify('User ID Required', 'Enter your Discord ID above first!', 3)
            return
        end
        NyXConfig.PingBiomes[bName] = not NyXConfig.PingBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.PingBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
        SaveWebhookConfig()
    end)
end

AddSectionLabel(PingsScroll, 'Merchant Pings (Mari / Jester / Rin)')
local PingMerchantRow = Instance.new('Frame', PingsScroll)
PingMerchantRow.Size = UDim2.new(1, -4, 0, 28)
PingMerchantRow.BackgroundTransparency = 1
local MGridLayout = Instance.new('UIGridLayout', PingMerchantRow)
MGridLayout.CellSize = UDim2.new(0.32, -3, 0, 26)
MGridLayout.CellPadding = UDim2.new(0, 5, 0, 0)

for _, mName in ipairs(All3Merchants) do
    local MChip = Instance.new('TextButton', PingMerchantRow)
    local isOn = NyXConfig.PingMerchants[mName] == true
    MChip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
    MChip.BorderSizePixel = 0
    MChip.Text = mName:upper()
    MChip.Font = Enum.Font.GothamBold
    MChip.TextSize = 9
    MChip.TextColor3 = Color3.fromRGB(240, 242, 255)
    Instance.new('UICorner', MChip).CornerRadius = UDim.new(0, 5)

    RegisterDynamicAccent(function(newCol)
        if NyXConfig.PingMerchants[mName] then MChip.BackgroundColor3 = newCol end
    end)

    MChip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingMerchants[mName] and cleanID == '' then
            Notify('User ID Required', 'Enter your Discord ID above first!', 3)
            return
        end
        NyXConfig.PingMerchants[mName] = not NyXConfig.PingMerchants[mName]
        MChip.BackgroundColor3 = NyXConfig.PingMerchants[mName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 25, 35)
        SaveWebhookConfig()
    end)
end

-- // TAB 6: SETTINGS & UTILITIES
AddSectionLabel(SettingScroll, 'UI Utilities & Alerts')
AddToggle(SettingScroll, 'Show Floating Mini HUD', 'Compact status bar at top of screen.', NyXConfig.ShowMiniHUD, function(val)
    NyXConfig.ShowMiniHUD = val
    MiniHUD.Visible = val
end)
AddToggle(SettingScroll, 'Lock UI & Logo Position', 'Prevents accidental dragging.', NyXConfig.LockUIPosition, function(val)
    NyXConfig.LockUIPosition = val
end)
AddToggle(SettingScroll, 'Sound Alert on Target Spawn', 'Plays chime when rare biome/merchant spawns.', NyXConfig.EnableSoundAlert, function(val)
    NyXConfig.EnableSoundAlert = val
end)
AddButton(SettingScroll, 'Reset UI Positions to Default', function()
    MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoToggleBtn.Position = UDim2.new(0.03, 0, 0.2, 0)
    MiniHUD.Position = UDim2.new(0.5, 0, 0, 8)
    MainWindow.Visible = true
end)

AddSectionLabel(SettingScroll, 'Movement & Appearance')
AddToggle(SettingScroll, 'WalkSpeed Boost', 'Speeds up walking to merchants/items.', NyXConfig.WalkSpeedBoost, function(val)
    NyXConfig.WalkSpeedBoost = val
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then hum.WalkSpeed = val and NyXConfig.CustomWalkSpeed or 16 end
    end)
end)
AddSlider(SettingScroll, 'WalkSpeed Value', 16, 45, NyXConfig.CustomWalkSpeed, '', function(val)
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

local ColorRow = Instance.new('Frame', SettingScroll)
ColorRow.Size = UDim2.new(1, -4, 0, 24)
ColorRow.BackgroundTransparency = 1
local ColorGrid = Instance.new('UIGridLayout', ColorRow)
ColorGrid.CellSize = UDim2.new(0.2, -3, 0, 22)
ColorGrid.CellPadding = UDim2.new(0, 4, 0, 0)

local ThemePresets = {
    {Name = 'Blue', Col = Color3.fromRGB(95, 145, 255)},
    {Name = 'Purple', Col = Color3.fromRGB(145, 95, 255)},
    {Name = 'Crimson', Col = Color3.fromRGB(255, 70, 95)},
    {Name = 'Emerald', Col = Color3.fromRGB(46, 213, 115)},
    {Name = 'Gold', Col = Color3.fromRGB(255, 175, 45)}
}
for _, preset in ipairs(ThemePresets) do
    local CBtn = Instance.new('TextButton', ColorRow)
    CBtn.BackgroundColor3 = preset.Col
    CBtn.BorderSizePixel = 0
    CBtn.Text = preset.Name
    CBtn.Font = Enum.Font.GothamBold
    CBtn.TextSize = 8
    CBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new('UICorner', CBtn).CornerRadius = UDim.new(0, 4)
    CBtn.MouseButton1Click:Connect(function()
        UpdateAccentColor(preset.Col)
    end)
end

AddSectionLabel(SettingScroll, 'Performance & System')
AddToggle(SettingScroll, 'OLED Black Screen Saver', 'Covers screen in black to save battery.', NyXConfig.BlackScreenSaver, function(val)
    NyXConfig.BlackScreenSaver = val
    BlackSaverFrame.Visible = val
end)
AddToggle(SettingScroll, 'Disable 3D Rendering', 'Maximizes FPS & reduces CPU/GPU load.', NyXConfig.Disable3DRendering, function(val)
    NyXConfig.Disable3DRendering = val
    pcall(function() RunService:Set3dRenderingEnabled(not val) end)
end)
AddToggle(SettingScroll, 'Enable Anti-AFK', 'Prevents 20m idle kick.', NyXConfig.AntiAFK, function(val)
    NyXConfig.AntiAFK = val
end)
AddToggle(SettingScroll, 'Auto Reconnect', 'Rejoins server on disconnect.', NyXConfig.AutoReconnect, function(val)
    NyXConfig.AutoReconnect = val
end)
AddButton(SettingScroll, 'Boost FPS (Clear Particles & Shadows)', function()
    pcall(function()
        Lighting.GlobalShadows = false
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA('ParticleEmitter') or v:IsA('Trail') or v:IsA('Smoke') or v:IsA('Fire') then
                v.Enabled = false
            elseif v:IsA('BasePart') then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    end)
    Notify('FPS Boost', 'Optimized world materials & particles!', 2.5)
end)
AddButton(SettingScroll, 'Copy Current Server JobId', function()
    if setclipboard then
        pcall(setclipboard, tostring(game.JobId))
        Notify('Copied', 'JobId copied to clipboard!', 2)
    end
end)
AddButton(SettingScroll, 'Rejoin Current Server', function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- // Hàm dọn dẹp tập trung lưu trong getgenv()
NyXEnv.Cleanup = function()
    NyXEnv.Running = false
    cancelCurrentWalk = true
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    if NyXConfig.EnableBiomeWebhook then
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        SendMacroStateEmbed(false, finalElapsed)
    end
    for _, conn in ipairs(NyXEnv.Connections) do
        pcall(function()
            if conn and conn.Connected then conn:Disconnect() end
        end)
    end
    table.clear(NyXEnv.Connections)
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end

AddButton(SettingScroll, 'Uninstall / Destroy Script', function()
    NyXEnv.Cleanup()
end)

-- ==========================================
-- // BACKGROUND LOOPS
-- ==========================================
-- 1. Biome Detection & Mini HUD Sync
task.spawn(function()
    local confirmedBiome = GetAccurateServerBiome()
    local pendingBiome = confirmedBiome
    local pendingCount = 0
    NyXConfig.CurrentDetectedBiome = confirmedBiome
    BiomeValueLabel.Text = confirmedBiome
    if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
        BiomeValueLabel.TextColor3 = BiomeData[confirmedBiome].Hex
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
        local upStr = GetMacroUptime()
        UptimeValueLabel.Text = upStr
        MiniHUDText.Text = string.format('BIOME: %s  |  MERCHANT: %s  |  %s', NyXConfig.CurrentDetectedBiome, MerchantValueLabel.Text, upStr)

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
            BiomeValueLabel.Text = confirmedBiome
            if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
                BiomeValueLabel.TextColor3 = BiomeData[confirmedBiome].Hex
            end
            if NyXConfig.PingBiomes[confirmedBiome] or NyXConfig.StopAutoBiomes[confirmedBiome] then
                PlayAlertSound()
            end
            if NyXConfig.EnableBiomeWebhook then
                if previousBiome ~= 'NORMAL' and BiomeData[previousBiome] then
                    local prevInfo = BiomeData[previousBiome]
                    SendBiomeEndedEmbed(previousBiome, prevInfo.Color, prevInfo.Image)
                end
                if confirmedBiome ~= 'NORMAL' and BiomeData[confirmedBiome] then
                    local newInfo = BiomeData[confirmedBiome]
                    SendBiomeStartedEmbed(confirmedBiome, newInfo.Color, newInfo.Image)
                end
            end
            if NyXConfig.StopAutoBiomes[confirmedBiome] then
                Notify('Stop Auto In', 'Detected ' .. confirmedBiome .. '! Pausing items.', 4)
            end
        end
    end
end)

-- 2. Merchant Lifecycle Loop (3m Countdown -> Merchant Left = NONE, No Left Webhook)
task.spawn(function()
    while NyXEnv.Running and task.wait(1) do
        local worldMerchant, worldPos = FindMerchantWorldPosition(false)
        if worldMerchant and NyXConfig.CurrentMerchant == 'NONE' then
            SetMerchantArrivedState(worldMerchant, worldPos)
        elseif worldMerchant and NyXConfig.CurrentMerchant == worldMerchant:upper() then
            NyXConfig.MerchantPosition = worldPos
        end
        if NyXConfig.CurrentMerchant ~= 'NONE' then
            local elapsed = os.time() - NyXConfig.MerchantSpawnTimestamp
            local remaining = math.max(0, NyXConfig.MerchantDuration - elapsed)
            local mMins = math.floor(remaining / 60)
            local mSecs = remaining % 60
            local timerText = string.format('%s (%02d:%02d)', NyXConfig.CurrentMerchant, mMins, mSecs)
            MerchantValueLabel.Text = timerText
            MTabStatusLbl.Text = 'Status: ' .. NyXConfig.CurrentMerchant .. ' Active (' .. string.format('%02d:%02d', mMins, mSecs) .. ' left)'
            if NyXConfig.MerchantPosition then
                local p = NyXConfig.MerchantPosition
                MTabCoordsLbl.Text = string.format('XYZ Coordinates: %.0f, %.0f, %.0f', p.X, p.Y, p.Z)
            end
            if remaining <= 0 or (not worldMerchant and elapsed > 15) then
                SetMerchantLeftState(remaining <= 0 and '3m Timer Expired' or 'Model Despawned')
            end
        else
            MerchantValueLabel.Text = 'NONE'
            MTabStatusLbl.Text = 'Status: NONE (Waiting for Spawn)'
            MTabCoordsLbl.Text = 'XYZ Coordinates: N/A'
        end
    end
end)

-- 3. Auto Collect Ground Items Loop
task.spawn(function()
    while NyXEnv.Running and task.wait(2.5) do
        if NyXConfig.AutoCollectItems and not isWalkingPath and NyXConfig.CurrentMerchant == 'NONE' then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild('HumanoidRootPart')
                if not root then return end
                local DropFolder = Workspace:FindFirstChild('DroppedItems') or Workspace:FindFirstChild('Items') or Workspace
                for _, item in ipairs(DropFolder:GetChildren()) do
                    local n = item.Name:upper()
                    if n:find('POTION') or n:find('COIN') or n:find('LUCKY') or n:find('SPEED') or n:find('GILDED') then
                        local part = item:IsA('BasePart') and item or item:FindFirstChildWhichIsA('BasePart')
                        if part and (part.Position - root.Position).Magnitude < 160 and not IsWaypointOverWaterOrVoid(part.Position) then
                            WalkSafelyToTargetPosition(part.Position, function()
                                return not item.Parent or not NyXConfig.AutoCollectItems or NyXConfig.CurrentMerchant ~= 'NONE'
                            end, false)
                            local prompt = item:FindFirstChildWhichIsA('ProximityPrompt', true)
                            if prompt and fireproximityprompt then
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

-- 4. Auto Biome Randomizer & Strange Controller Loop
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
