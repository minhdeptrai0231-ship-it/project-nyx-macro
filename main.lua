-- // NYX DETECTOR MACRO - ULTRA FIX v10 (100% ORIGINAL BOOT STRUCTURE + UNIFIED TOP BAR)
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local HttpService = game:GetService('HttpService')
local VirtualUser = game:GetService('VirtualUser')
local VirtualInputManager = game:GetService('VirtualInputManager')
local GuiService = game:GetService('GuiService')
local Workspace = game:GetService('Workspace')
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')
local TextChatService = game:GetService('TextChatService')
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')
local TeleportService = game:GetService('TeleportService')
local PathfindingService = game:GetService('PathfindingService')

local LocalPlayer = Players.LocalPlayer
local ScriptRunning = true
local MacroStartTime = 0
local ScreenGui = nil
local Notify = function() end

-- // Dọn dẹp UI cũ nếu đang mở (An toàn, không đụng chạm getgenv readonly)
local ParentGui = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild('PlayerGui')
if ParentGui:FindFirstChild('NyXMacroUI') then
    ParentGui.NyXMacroUI:Destroy()
end

-- // 19 Biomes & 4 Merchants Data
local DefaultIcon = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAKRQKtpEDOoV6TlVxqJnuFo9ZWQu2iP4TU3UpD5ojBNN6MsGqs1t6lonQ&s=10'
local BiomeData = {
    ['NORMAL'] = {Color = 0xAAAAAA, Hex = Color3.fromRGB(80, 250, 123), Image = DefaultIcon},
    ['WINDY'] = {Color = 0x55FFFF, Hex = Color3.fromRGB(85, 255, 255), Image = DefaultIcon},
    ['SNOWY'] = {Color = 0xAAFFFF, Hex = Color3.fromRGB(170, 255, 255), Image = DefaultIcon},
    ['RAINY'] = {Color = 0x4477FF, Hex = Color3.fromRGB(68, 119, 255), Image = DefaultIcon},
    ['SANDSTORM'] = {Color = 0xCC9955, Hex = Color3.fromRGB(235, 180, 90), Image = DefaultIcon},
    ['HELL'] = {Color = 0xFF3300, Hex = Color3.fromRGB(255, 65, 35), Image = DefaultIcon},
    ['STARFALL'] = {Color = 0x2266FF, Hex = Color3.fromRGB(80, 140, 255), Image = DefaultIcon},
    ['HEAVEN'] = {Color = 0xFFEEAA, Hex = Color3.fromRGB(255, 238, 170), Image = DefaultIcon},
    ['LOST FOREST'] = {Color = 0x33FF33, Hex = Color3.fromRGB(51, 255, 51), Image = DefaultIcon},
    ['CORRUPTION'] = {Color = 0x8833FF, Hex = Color3.fromRGB(165, 90, 255), Image = DefaultIcon},
    ['NULL'] = {Color = 0x777777, Hex = Color3.fromRGB(160, 160, 160), Image = DefaultIcon},
    ['GLITCHED'] = {Color = 0x228855, Hex = Color3.fromRGB(60, 255, 140), Image = DefaultIcon},
    ['DREAMSPACE'] = {Color = 0xFF66CC, Hex = Color3.fromRGB(255, 102, 204), Image = DefaultIcon},
    ['CYBERSPACE'] = {Color = 0x2255AA, Hex = Color3.fromRGB(70, 150, 255), Image = DefaultIcon},
    ['SINGULARITY'] = {Color = 0xFF9955, Hex = Color3.fromRGB(255, 153, 85), Image = DefaultIcon},
    ['THE RADIANT FOREST'] = {Color = 0xCC33FF, Hex = Color3.fromRGB(204, 51, 255), Image = DefaultIcon},
    ['PUMPKIN MOON'] = {Color = 0xFF7518, Hex = Color3.fromRGB(255, 130, 40), Image = DefaultIcon},
    ['GRAVEYARD'] = {Color = 0x7F8C8D, Hex = Color3.fromRGB(165, 185, 200), Image = DefaultIcon},
    ['BLOOD RAIN'] = {Color = 0x8B0000, Hex = Color3.fromRGB(220, 40, 55), Image = DefaultIcon}
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
    ['Mari'] = {Color = 0x2ECC71, Image = DefaultIcon},
    ['Jester'] = {Color = 0x9B59B6, Image = DefaultIcon},
    ['Rin'] = {Color = 0x3498DB, Image = DefaultIcon},
    ['Sinister S.'] = {Color = 0xE67E22, Image = DefaultIcon}
}

local NyXConfig = {
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
    GlassTransparency = 0.08,
    UIScalePercent = 95
}

for _, bName in ipairs(All19Biomes) do
    if NyXConfig.PingBiomes[bName] == nil then NyXConfig.PingBiomes[bName] = false end
    if NyXConfig.StopAutoBiomes[bName] == nil then NyXConfig.StopAutoBiomes[bName] = false end
end

local Runtime = {
    Connections = {},
    AccentObjects = {},
    DynamicAccentCallbacks = {},
    Pages = {},
    NavButtons = {},
    WebhookQueue = {},
    IsProcessingQueue = false,
    IsWalkingPath = false,
    CancelCurrentWalk = false,
    IsUsingInventory = false,
    CachedMerchantObj = nil,
    LastFullMerchantScan = 0,
    CachedBiomeLabels = {},
    LastGuiBiomeScan = 0,
    AccountUsername = tostring(LocalPlayer and LocalPlayer.Name or 'Unknown')
}

local function TrackConn(c)
    if c then table.insert(Runtime.Connections, c) end
    return c
end

local function PlayAlertSound()
    if not NyXConfig.EnableSoundAlert then return end
    pcall(function()
        local snd = Instance.new('Sound')
        snd.SoundId = 'rbxassetid://4590657391'
        snd.Volume = 2
        snd.Parent = Workspace
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
            writefile(WebhookConfigFile, HttpService:JSONEncode({
                WebhookURL = NyXConfig.WebhookURL,
                DiscordID = NyXConfig.DiscordID,
                PrivateServerLink = NyXConfig.PrivateServerLink,
                PingBiomes = NyXConfig.PingBiomes,
                PingMerchants = NyXConfig.PingMerchants
            }))
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
TrackConn(LocalPlayer.Idled:Connect(function()
    if not ScriptRunning or not NyXConfig.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
        if Workspace.CurrentCamera then
            VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end
    end)
end))

pcall(function()
    TrackConn(GuiService.ErrorMessageChanged:Connect(function()
        if ScriptRunning and NyXConfig.AutoReconnect then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end))
end)

local function GetMacroUptime(forcedElapsed)
    local elapsed = forcedElapsed
    if not elapsed then
        if not NyXConfig.MacroActive or MacroStartTime == 0 then
            return '00:00:00'
        end
        elapsed = math.floor(os.time() - MacroStartTime)
    end
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    return string.format('%02d:%02d:%02d', hours, mins, secs)
end

local function FormatMMSS(totalSeconds)
    local sec = math.max(0, math.floor(totalSeconds or 0))
    return string.format('%02d:%02d', math.floor(sec / 60), sec % 60)
end

local function CleanRichText(str)
    if type(str) ~= 'string' then return '' end
    local s = str:gsub('<[^>]+>', '')
    return s:gsub('^%s+', ''):gsub('%s+$', '')
end

-- ==========================================
-- // SEQUENTIAL WEBHOOK SYSTEM (FIX ENDED BEFORE STARTED)
-- ==========================================
local function ProcessWebhookQueue()
    if Runtime.IsProcessingQueue then return end
    Runtime.IsProcessingQueue = true
    task.spawn(function()
        while #Runtime.WebhookQueue > 0 do
            local payload = table.remove(Runtime.WebhookQueue, 1)
            local cleanUrl = tostring(NyXConfig.WebhookURL or ''):gsub('%s+', '')
            local req = (syn and syn.request) or http_request or request
            if cleanUrl ~= '' and req then
                pcall(function()
                    req({
                        Url = cleanUrl,
                        Method = 'POST',
                        Headers = {['Content-Type'] = 'application/json'},
                        Body = HttpService:JSONEncode(payload)
                    })
                end)
                if #Runtime.WebhookQueue > 0 then
                    task.wait(0.35)
                end
            end
        end
        Runtime.IsProcessingQueue = false
    end)
end

local function QueueDiscordEmbed(title, descLines, color, thumbUrl, shouldPing)
    local cleanUrl = tostring(NyXConfig.WebhookURL or ''):gsub('%s+', '')
    if cleanUrl == '' then return end
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    local contentMsg = (shouldPing and cleanID ~= '') and ('<@' .. cleanID .. '>') or ''
    local embed = {
        ['title'] = title,
        ['description'] = table.concat(descLines, '\n'),
        ['color'] = color or 0x2ECC71,
        ['footer'] = {['text'] = 'NyX Macro | Release v1.0.0'}
    }
    if thumbUrl then embed['thumbnail'] = {['url'] = thumbUrl} end
    table.insert(Runtime.WebhookQueue, {
        ['content'] = contentMsg,
        ['allowed_mentions'] = {
            ['parse'] = {'users', 'everyone'},
            ['users'] = cleanID ~= '' and {cleanID} or {}
        },
        ['embeds'] = {embed}
    })
    ProcessWebhookQueue()
end

local function GetTsLine(customTs)
    local t = customTs or os.time()
    return string.format('<t:%d:T> ( <t:%d:R> )', t, t)
end

local function GetPsLine()
    local link = tostring(NyXConfig.PrivateServerLink or ''):gsub('^%s+', ''):gsub('%s+$', '')
    return (link ~= '') and link or 'None'
end

local function SendTestWebhookEmbed(withUserPing)
    QueueDiscordEmbed(
        withUserPing and 'Ping With User ID - Successfully' or 'Webhook Test - Successfully',
        {GetTsLine(), '**Username**', '`' .. Runtime.AccountUsername .. '`', '**Private Server**', GetPsLine()},
        0x2ECC71, nil, withUserPing
    )
end

local function SendMacroStateEmbed(isStarted, finalElapsed)
    if isStarted then
        QueueDiscordEmbed('Macro Started', {GetTsLine(), '**Username**', '`' .. Runtime.AccountUsername .. '`', '**Private Server**', GetPsLine()}, 0x00FF88, nil, false)
    else
        QueueDiscordEmbed('Macro Stopped', {GetTsLine(), '**Username**', '`' .. Runtime.AccountUsername .. '`', '**Total Uptime**', '`' .. GetMacroUptime(finalElapsed or 0) .. '`'}, 0xFF3344, nil, false)
    end
end

local function SendBiomeEndedEmbed(biomeName, color, imageUrl, customTs)
    local disp = (biomeName == 'SANDSTORM') and 'SAND STORM' or biomeName
    QueueDiscordEmbed('Biome Ended - ' .. disp, {GetTsLine(customTs), '**Username**', '`' .. Runtime.AccountUsername .. '`'}, color or 0x555555, imageUrl, false)
end

local function SendBiomeStartedEmbed(biomeName, color, imageUrl, customTs)
    local disp = (biomeName == 'SANDSTORM') and 'SAND STORM' or biomeName
    QueueDiscordEmbed('Biome Started - ' .. disp, {GetTsLine(customTs), '**Username**', '`' .. Runtime.AccountUsername .. '`', '**Private Server**', GetPsLine()}, color or 0xCC9955, imageUrl, NyXConfig.PingBiomes[biomeName] == true)
end

local function SendMerchantArrivedEmbed(merchantName)
    if not NyXConfig.MacroActive then return end
    local mInfo = MerchantData[merchantName] or {Color = 0xF1C40F, Image = DefaultIcon}
    local title = (merchantName == 'Sinister S.') and 'Sinister S. has spawned' or ('Merchant Arrived - ' .. merchantName:upper())
    QueueDiscordEmbed(title, {GetTsLine(), '**Username**', '`' .. Runtime.AccountUsername .. '`', '**Private Server**', GetPsLine()}, mInfo.Color, mInfo.Image, NyXConfig.PingMerchants[merchantName] == true)
end

-- ==========================================
-- // SAFE LOG READER FOR GLITCHED BIOME
-- ==========================================
local function InspectLogForGlitched(msg)
    if type(msg) ~= 'string' or msg == '' then return end
    local u = msg:upper()
    if u:find('NYX') or u:find('WEBHOOK') then return end
    if u:find('%[%s*GLITCHED%s*%]') or u:find('BIOME:%s*GLITCHED') or u:find('CURRENTBIOME:%s*GLITCHED')
       or u:find('"BIOME"%s*:%s*"GLITCHED"') or u:find('01000111%s*01001100%s*01001001%s*01010100')
       or (u:find('GLITCHED') and (u:find('BIOME') or u:find('SPAWN') or u:find('WEATHER') or u:find('MAP'))) then
        NyXConfig.LogGlitchedTimestamp = os.time()
    elseif u:find('BIOME') and (u:find('NORMAL') or u:find('ENDED')) and NyXConfig.LogGlitchedTimestamp > 0 then
        NyXConfig.LogGlitchedTimestamp = 0
    end
end

pcall(function()
    local LogService = game:GetService('LogService')
    if LogService and LogService.MessageOut then
        TrackConn(LogService.MessageOut:Connect(function(msg)
            if ScriptRunning then InspectLogForGlitched(msg) end
        end))
    end
end)

-- ==========================================
-- // SMART PATHFINDING & OBSTACLE JUMP
-- ==========================================
local function ForceJump(hum)
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
    local hit = false
    pcall(function()
        local flatDir = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
        flatDir = (flatDir.Magnitude < 0.1) and root.CFrame.LookVector or flatDir.Unit
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        for _, yOff in ipairs({-1.8, -0.8, 0.5}) do
            local r = Workspace:Raycast(root.Position + Vector3.new(0, yOff, 0), flatDir * 4.2, rp)
            if r and r.Instance and r.Instance.CanCollide then
                hit = true
                return
            end
        end
    end)
    return hit
end

local function MatchMerchantObj(obj)
    if not obj or not obj.Parent then return nil, nil, nil end
    if obj:IsA('ProximityPrompt') then
        local c = (obj.ObjectText .. ' ' .. obj.ActionText .. ' ' .. (obj.Parent and obj.Parent.Name or '') .. ' ' .. (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name or '')):upper()
        local m = c:find('SINISTER') and 'Sinister S.' or (c:find('%f[%a]JESTER%f[%A]') and 'Jester') or (c:find('%f[%a]RIN%f[%A]') and 'Rin') or (c:find('%f[%a]MARI%f[%A]') and 'Mari') or nil
        if m then
            local part = obj:FindFirstAncestorWhichIsA('BasePart') or (obj.Parent and obj.Parent:IsA('Model') and obj.Parent.PrimaryPart)
            if part then return m, part.Position, obj end
        end
    elseif obj:IsA('Model') then
        local n = obj.Name:upper()
        local m = n:find('SINISTER') and 'Sinister S.' or ((n == 'JESTER' or n == 'MERCHANT_JESTER' or n == 'JESTERNPC') and 'Jester') or ((n == 'RIN' or n == 'MERCHANT_RIN' or n == 'RINNPC') and 'Rin') or ((n == 'MARI' or n == 'MERCHANT_MARI' or n == 'MARINPC') and 'Mari') or nil
        if m then
            local ok, pv = pcall(function() return obj:GetPivot() end)
            if ok and pv then return m, pv.Position, obj:FindFirstChildWhichIsA('ProximityPrompt', true) end
        end
    end
    return nil, nil, nil
end

pcall(function()
    TrackConn(Workspace.DescendantAdded:Connect(function(obj)
        if not ScriptRunning then return end
        if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
            task.defer(function()
                if MatchMerchantObj(obj) then Runtime.CachedMerchantObj = obj end
            end)
        end
    end))
end)

local function FindMerchantWorldPosition(forceScan)
    if Runtime.CachedMerchantObj and Runtime.CachedMerchantObj.Parent and Runtime.CachedMerchantObj:IsDescendantOf(Workspace) then
        local m, p, pr = MatchMerchantObj(Runtime.CachedMerchantObj)
        if m and p then return m, p, pr end
    end
    Runtime.CachedMerchantObj = nil
    local now = os.clock()
    if not forceScan and (now - Runtime.LastFullMerchantScan) < 25 then return nil, nil, nil end
    Runtime.LastFullMerchantScan = now

    local fName, fPos, fPrompt = nil, nil, nil
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA('ProximityPrompt') or obj:IsA('Model') then
                local m, p, pr = MatchMerchantObj(obj)
                if m and p then
                    Runtime.CachedMerchantObj = obj
                    fName, fPos, fPrompt = m, p, pr
                    return
                end
            end
        end
    end)
    return fName, fPos, fPrompt
end

local function IsOverHazard(pos)
    local hz = false
    pcall(function()
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {LocalPlayer.Character}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local res = Workspace:Raycast(pos + Vector3.new(0, 6, 0), Vector3.new(0, -35, 0), rp)
        if not res or res.Material == Enum.Material.Water then
            hz = true
        else
            local hn = res.Instance.Name:upper()
            if hn:find('WATER') or hn:find('RIVER') or hn:find('KILL') or hn:find('VOID') then hz = true end
        end
    end)
    return hz
end

local function MoveToPointSmart(char, hum, root, pointPos, reqJump, stopFunc)
    if reqJump or (pointPos.Y - root.Position.Y) > 1.5 or IsOverHazard(pointPos) or HasObstacleInFront(char, root, pointPos) then
        ForceJump(hum)
    end
    hum:MoveTo(pointPos)
    local stepStart, lastCheckTime, lastCheckPos, strikes = os.clock(), os.clock(), root.Position, 0

    while (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(pointPos.X, 0, pointPos.Z)).Magnitude > 3.6 and (os.clock() - stepStart) < 2.6 do
        if not ScriptRunning or Runtime.CancelCurrentWalk or (stopFunc and stopFunc()) or not char.Parent or hum.Health <= 0 then break end
        if HasObstacleInFront(char, root, pointPos) or (pointPos.Y - root.Position.Y) > 1.6 then ForceJump(hum) end

        if (os.clock() - lastCheckTime) >= 0.3 then
            local moved = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(lastCheckPos.X, 0, lastCheckPos.Z)).Magnitude
            lastCheckTime, lastCheckPos = os.clock(), root.Position
            if moved < 0.85 then
                strikes = strikes + 1
                ForceJump(hum)
                if strikes >= 2 then
                    local side = root.CFrame.RightVector * ((strikes % 2 == 0) and 5 or -5)
                    ForceJump(hum)
                    hum:MoveTo(root.Position - root.CFrame.LookVector * 2 + side)
                    task.wait(0.22)
                    ForceJump(hum)
                    hum:MoveTo(pointPos)
                end
            else
                strikes = 0
            end
        end
        hum:MoveTo(pointPos)
        task.wait(0.08)
    end
end

local function WalkSafelyToTargetPosition(targetPos, stopFunc, isHighPriority)
    if not targetPos then return false end
    if Runtime.IsWalkingPath then
        if isHighPriority then
            Runtime.CancelCurrentWalk = true
            local w0 = os.clock()
            while Runtime.IsWalkingPath and (os.clock() - w0) < 2.5 do task.wait(0.05) end
        end
        if Runtime.IsWalkingPath then return false end
    end
    Runtime.IsWalkingPath = true
    Runtime.CancelCurrentWalk = false
    local reached = false

    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not hum or not root or hum.Health <= 0 then return end

        for _ = 1, 2 do
            if not ScriptRunning or Runtime.CancelCurrentWalk or (stopFunc and stopFunc()) then break end
            if (root.Position - targetPos).Magnitude <= 8 then reached = true break end

            local path = PathfindingService:CreatePath({
                AgentRadius = 2.0, AgentHeight = 5.0, AgentCanJump = true, WaypointSpacing = 3.5,
                Costs = {Water = math.huge, Danger = math.huge}
            })
            local ok = pcall(function() path:ComputeAsync(root.Position, targetPos) end)
            if ok and path.Status == Enum.PathStatus.Success then
                for i, wp in ipairs(path:GetWaypoints()) do
                    if i > 1 then
                        if not ScriptRunning or Runtime.CancelCurrentWalk or (stopFunc and stopFunc()) or not char.Parent or hum.Health <= 0 then break end
                        MoveToPointSmart(char, hum, root, wp.Position, wp.Action == Enum.PathWaypointAction.Jump, stopFunc)
                        if (root.Position - targetPos).Magnitude <= 8 then reached = true break end
                    end
                end
            elseif not IsOverHazard(targetPos) then
                local t0 = os.clock()
                while (root.Position - targetPos).Magnitude > 7 and (os.clock() - t0) < 9 do
                    if not ScriptRunning or Runtime.CancelCurrentWalk or (stopFunc and stopFunc()) then break end
                    if IsOverHazard(root.Position + root.CFrame.LookVector * 5) then ForceJump(hum) end
                    MoveToPointSmart(char, hum, root, targetPos, false, stopFunc)
                    if (root.Position - targetPos).Magnitude <= 8 then reached = true break end
                end
            end
            if reached then break end
        end
    end)

    Runtime.IsWalkingPath = false
    Runtime.CancelCurrentWalk = false
    return reached
end

local function WalkToActiveMerchantNow()
    task.spawn(function()
        local mName, mPos, mPrompt = FindMerchantWorldPosition(true)
        if not mPos and NyXConfig.MerchantPosition then
            mPos, mName = NyXConfig.MerchantPosition, NyXConfig.CurrentMerchant
        end
        if not mPos then
            Notify('Merchant', 'No active merchant found!', 2.5)
            return
        end
        Notify('Merchant', 'Walking to ' .. tostring(mName or 'Merchant') .. '...', 3)
        WalkSafelyToTargetPosition(mPos, function() return NyXConfig.CurrentMerchant == 'NONE' end, true)
        if NyXConfig.AutoInteractMerchant then
            if not mPrompt then _, _, mPrompt = FindMerchantWorldPosition(false) end
            if mPrompt and fireproximityprompt then pcall(function() fireproximityprompt(mPrompt) end) end
        end
    end)
end

-- ==========================================
-- // MERCHANT LIFECYCLE & BIOME SCANNER
-- ==========================================
local function SetMerchantArrivedState(merchantName, worldPos, customDuration)
    local canonical = merchantName:upper():find('SINISTER') and 'Sinister S.' or merchantName
    if NyXConfig.CurrentMerchant == canonical:upper() then
        if worldPos then NyXConfig.MerchantPosition = worldPos end
        return
    end
    NyXConfig.CurrentMerchant = canonical:upper()
    NyXConfig.MerchantSpawnTimestamp = os.time()
    NyXConfig.MerchantDuration = customDuration or ((canonical == 'Sinister S.') and 360 or 180)
    NyXConfig.MerchantPosition = worldPos
    PlayAlertSound()
    SendMerchantArrivedEmbed(canonical)
    Notify('Merchant', canonical .. ' spawned!', 3.5)
    if NyXConfig.AutoWalkToMerchant and worldPos then WalkToActiveMerchantNow() end
end

local function SetMerchantLeftState(reason)
    if NyXConfig.CurrentMerchant == 'NONE' then return end
    local prev = NyXConfig.CurrentMerchant
    NyXConfig.CurrentMerchant = 'NONE'
    NyXConfig.MerchantSpawnTimestamp = 0
    NyXConfig.MerchantPosition = nil
    Runtime.CachedMerchantObj = nil
    Notify('Merchant', prev .. ' left (' .. tostring(reason or 'Despawned') .. ')', 3.5)
    if NyXConfig.RespawnIfMerchantLeft then
        task.wait(0.8)
        pcall(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
            if h then h.Health = 0 end
        end)
    end
end

local function ParseStrictBiomeToken(rawText, requireBrackets)
    local clean = CleanRichText(rawText):upper()
    if clean == '' or #clean > 38 then return nil end
    local bInner = clean:match('^%[%s*(.-)%s*%]$')
    if bInner then return NormalizedBiomeLookup[bInner:gsub('[^A-Z]', '')] end
    if not requireBrackets then return NormalizedBiomeLookup[clean:gsub('[^A-Z]', '')] end
    return nil
end

local function GetAccurateServerBiome()
    local found = nil
    pcall(function()
        for _, val in ipairs({
            Workspace:GetAttribute('Biome'), Workspace:GetAttribute('CurrentBiome'), Workspace:GetAttribute('Weather'),
            ReplicatedStorage:GetAttribute('Biome'), ReplicatedStorage:GetAttribute('CurrentBiome'),
            Lighting:GetAttribute('Biome'), LocalPlayer:GetAttribute('Biome')
        }) do
            if type(val) == 'string' and val ~= '' then
                local m = ParseStrictBiomeToken(val, false)
                if m then found = m return end
            end
        end
    end)
    if found and found ~= 'NORMAL' then return found end

    pcall(function()
        for _, root in ipairs({ReplicatedStorage, Workspace, Lighting}) do
            for _, obj in ipairs(root:GetChildren()) do
                if obj:IsA('StringValue') then
                    local n = obj.Name:upper()
                    if n == 'BIOME' or n == 'CURRENTBIOME' or n == 'WEATHER' then
                        local m = ParseStrictBiomeToken(obj.Value, false)
                        if m then found = m return end
                    end
                end
            end
        end
    end)
    if found and found ~= 'NORMAL' then return found end

    pcall(function()
        for i = #Runtime.CachedBiomeLabels, 1, -1 do
            local lbl = Runtime.CachedBiomeLabels[i]
            if not lbl or not lbl.Parent then
                table.remove(Runtime.CachedBiomeLabels, i)
            elseif lbl.Visible and lbl.Text ~= '' then
                local bMatch = ParseStrictBiomeToken(lbl.Text, true) or ParseStrictBiomeToken(lbl.Text, false)
                if bMatch then
                    found = bMatch
                    if bMatch ~= 'NORMAL' then return end
                end
            end
        end
    end)
    if found and found ~= 'NORMAL' then return found end

    if NyXConfig.LogGlitchedTimestamp > 0 and (os.time() - NyXConfig.LogGlitchedTimestamp) <= 160 then
        return 'GLITCHED'
    end
    if found then return found end

    local now = os.clock()
    if (now - Runtime.LastGuiBiomeScan) < 15 then return 'NORMAL' end
    Runtime.LastGuiBiomeScan = now

    pcall(function()
        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end
        local bMatch, eMatch = nil, nil
        Runtime.CachedBiomeLabels = {}
        for _, v in ipairs(pGui:GetDescendants()) do
            if v:IsA('TextLabel') and v.Visible and v.Text ~= '' and (not ScreenGui or not v:IsDescendantOf(ScreenGui)) then
                local pName = (v.Parent and v.Parent.Name or ''):upper()
                if not pName:find('INVENTORY') and not pName:find('CHAT') and not pName:find('SHOP') then
                    local bm = ParseStrictBiomeToken(v.Text, true)
                    local ln = v.Name:upper()
                    if bm then
                        table.insert(Runtime.CachedBiomeLabels, v)
                        bMatch = bm
                    elseif ln == 'BIOME' or ln == 'BIOMELABEL' or ln == 'BIOMETEXT' or ln == 'CURRENTBIOME' then
                        table.insert(Runtime.CachedBiomeLabels, v)
                        local em = ParseStrictBiomeToken(v.Text, false)
                        if em then eMatch = em end
                    end
                end
            end
        end
        found = bMatch or eMatch
    end)
    return found or 'NORMAL'
end

pcall(function()
    if TextChatService and TextChatService.MessageReceived then
        TrackConn(TextChatService.MessageReceived:Connect(function(message)
            if not ScriptRunning or message.TextSource ~= nil then return end
            local txt = CleanRichText((message.Text or '') .. ' ' .. (message.PrefixText or '')):upper()
            InspectLogForGlitched(txt)
            local mName = txt:find('SINISTER') and 'Sinister S.' or (txt:find('%f[%a]JESTER%f[%A]') and 'Jester') or (txt:find('%f[%a]RIN%f[%A]') and 'Rin') or (txt:find('%f[%a]MARI%f[%A]') and 'Mari') or nil
            if mName then
                if txt:find('HAS LEFT') or txt:find('DESPAWN') or txt:find('DEPARTED') or txt:find('GONE') then
                    SetMerchantLeftState('System Chat Left')
                elseif txt:find('HAS ARRIVED') or txt:find('HAS SPAWNED') or txt:find('APPEARED') then
                    local _, pos = FindMerchantWorldPosition(true)
                    SetMerchantArrivedState(mName, pos)
                end
            end
        end))
    end
end)

-- ==========================================
-- // AUTO INVENTORY
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
        local pos, size, inset = guiObj.AbsolutePosition, guiObj.AbsoluteSize, GuiService:GetGuiInset()
        local cx, cy = pos.X + (size.X / 2), pos.Y + (size.Y / 2) + inset.Y
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.06)
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end)
end

local function UseItemWithInventoryFailsafe(itemName)
    if Runtime.IsUsingInventory then return end
    Runtime.IsUsingInventory = true
    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild('Remotes') or ReplicatedStorage:FindFirstChild('Events')
        if Remotes then
            local exact = Remotes:FindFirstChild('UseItem') or Remotes:FindFirstChild('ItemUse')
            if exact and exact:IsA('RemoteEvent') then pcall(function() exact:FireServer(itemName, 1) end) end
        end
        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end
        local invFrame = nil
        for _, v in pairs(pGui:GetDescendants()) do
            if not ScreenGui or not v:IsDescendantOf(ScreenGui) then
                if v:IsA('Frame') and (v.Name == 'Inventory' or v.Name == 'InventoryFrame' or v.Name == 'ItemsFrame') then
                    invFrame = v break
                end
            end
        end
        local wasClosed = false
        if invFrame and not invFrame.Visible then
            wasClosed = true invFrame.Visible = true task.wait(0.25)
        elseif not invFrame then
            for _, btn in pairs(pGui:GetDescendants()) do
                if not ScreenGui or not btn:IsDescendantOf(ScreenGui) then
                    if (btn:IsA('TextButton') or btn:IsA('ImageButton')) and (btn.Name:lower():find('inv') or (btn:IsA('TextButton') and btn.Text:lower():find('inventory'))) then
                        wasClosed = true ClickGuiElement(btn) task.wait(0.35) break
                    end
                end
            end
        end
        for _, box in pairs(pGui:GetDescendants()) do
            if not ScreenGui or not box:IsDescendantOf(ScreenGui) then
                if box:IsA('TextBox') and box.Visible and (box.PlaceholderText:lower():find('search') or box.Name:lower():find('search')) then
                    box.Text = itemName task.wait(0.2) break
                end
            end
        end
        local foundSlot = nil
        for _, lbl in pairs(pGui:GetDescendants()) do
            if not ScreenGui or not lbl:IsDescendantOf(ScreenGui) then
                if lbl:IsA('TextLabel') and lbl.Visible and string.find(CleanRichText(lbl.Text):lower(), itemName:lower(), 1, true) then
                    local p = lbl:FindFirstAncestorWhichIsA('TextButton') or lbl:FindFirstAncestorWhichIsA('ImageButton') or lbl.Parent
                    if p then foundSlot = p ClickGuiElement(p) task.wait(0.25) break end
                end
            end
        end
        if foundSlot then
            for _, btn in pairs(pGui:GetDescendants()) do
                if not ScreenGui or not btn:IsDescendantOf(ScreenGui) then
                    if (btn:IsA('TextButton') or btn:IsA('ImageButton')) and btn.Visible then
                        local txt = btn:IsA('TextButton') and CleanRichText(btn.Text):upper() or ''
                        local bName = btn.Name:upper()
                        if txt == 'USE' or string.find(txt, 'USE ') or bName == 'USEBUTTON' or bName == 'USE' then
                            ClickGuiElement(btn) task.wait(0.2) break
                        end
                    end
                end
            end
        end
        if wasClosed and invFrame then invFrame.Visible = false end
    end)
    Runtime.IsUsingInventory = false
end

-- ==========================================
-- // UI CREATION (100% ORIGINAL MOUNT METHOD)
-- ==========================================
ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'NyXMacroUI'
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

local BlackSaverFrame = Instance.new('Frame', ScreenGui)
BlackSaverFrame.Size = UDim2.new(1, 0, 1, 0)
BlackSaverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackSaverFrame.Visible = NyXConfig.BlackScreenSaver
BlackSaverFrame.ZIndex = 1

local BlackSaverLabel = Instance.new('TextLabel', BlackSaverFrame)
BlackSaverLabel.Size = UDim2.new(1, 0, 0, 40)
BlackSaverLabel.Position = UDim2.new(0, 0, 0.45, -20)
BlackSaverLabel.BackgroundTransparency = 1
BlackSaverLabel.Text = 'OLED BATTERY SAVER ACTIVE'
BlackSaverLabel.Font = Enum.Font.GothamBlack
BlackSaverLabel.TextSize = 14
BlackSaverLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
BlackSaverLabel.ZIndex = 2

local function RegisterAccent(obj, prop)
    table.insert(Runtime.AccentObjects, {Obj = obj, Prop = prop})
    obj[prop] = NyXConfig.UIAccentColor
end

local function UpdateAccentColor(newColor)
    NyXConfig.UIAccentColor = newColor
    for _, item in ipairs(Runtime.AccentObjects) do
        pcall(function() item.Obj[item.Prop] = newColor end)
    end
    for _, fn in ipairs(Runtime.DynamicAccentCallbacks) do
        pcall(fn, newColor)
    end
end

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
        Card.Size = UDim2.new(1, 0, 0, 42)
        Card.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
        Card.BackgroundTransparency = 0.08
        Card.ZIndex = 21
        Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 7)

        local Tbl = Instance.new('TextLabel', Card)
        Tbl.Size = UDim2.new(1, -16, 0, 16)
        Tbl.Position = UDim2.new(0, 10, 0, 4)
        Tbl.BackgroundTransparency = 1
        Tbl.Text = title
        Tbl.TextColor3 = Color3.fromRGB(245, 245, 255)
        Tbl.Font = Enum.Font.GothamBold
        Tbl.TextSize = 11
        Tbl.ZIndex = 22
        Tbl.TextXAlignment = Enum.TextXAlignment.Left

        local Sub = Instance.new('TextLabel', Card)
        Sub.Size = UDim2.new(1, -16, 0, 18)
        Sub.Position = UDim2.new(0, 10, 0, 20)
        Sub.BackgroundTransparency = 1
        Sub.Text = text
        Sub.TextColor3 = Color3.fromRGB(175, 180, 200)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 9
        Sub.TextWrapped = true
        Sub.ZIndex = 22
        Sub.TextXAlignment = Enum.TextXAlignment.Left

        task.wait(duration or 2.5)
        if Card and Card.Parent then Card:Destroy() end
    end)
end

local function MakeDraggable(dragHandle, targetFrame, onClickCallback)
    local dragging, hasMoved, dragStart, startPos = false, false, nil, nil
    TrackConn(dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, hasMoved, dragStart, startPos = true, false, input.Position, targetFrame.Position
        end
    end))
    TrackConn(UserInputService.InputChanged:Connect(function(input)
        if dragging and not NyXConfig.LockUIPosition and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                hasMoved = true
                targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end))
    TrackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not hasMoved and onClickCallback then onClickCallback() end
            end
        end
    end))
end

-- // UNIFIED TOP BAR ([Biome | Merchant | Uptime | Nút mở Full UI])
local FallbackLogo = 'rbxassetid://18648155233'
local TopBar = Instance.new('Frame', ScreenGui)
TopBar.Name = 'UnifiedTopBar'
TopBar.AnchorPoint = Vector2.new(0.5, 0)
TopBar.Size = UDim2.new(0, 390, 0, 36)
TopBar.Position = UDim2.new(0.5, 0, 0, 8)
TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27)
TopBar.BackgroundTransparency = 0.08
TopBar.Active = true
TopBar.ZIndex = 25
Instance.new('UICorner', TopBar).CornerRadius = UDim.new(0, 8)

local TopBarStroke = Instance.new('UIStroke', TopBar)
TopBarStroke.Thickness = 1.3
TopBarStroke.Transparency = 0.3
RegisterAccent(TopBarStroke, 'Color')

local function CreateTopBarCell(xPosScale, widthScale, titleText, defaultValText)
    local Cell = Instance.new('Frame', TopBar)
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

    local Div = Instance.new('Frame', TopBar)
    Div.Size = UDim2.new(0, 1, 1, -10)
    Div.Position = UDim2.new(xPosScale + widthScale, 0, 0, 5)
    Div.BackgroundColor3 = Color3.fromRGB(45, 52, 72)
    Div.BorderSizePixel = 0
    Div.ZIndex = 27

    return Val
end

local BarBiomeVal = CreateTopBarCell(0.00, 0.31, 'BIOME', 'NORMAL')
BarBiomeVal.TextColor3 = Color3.fromRGB(80, 250, 123)

local BarMerchVal = CreateTopBarCell(0.31, 0.31, 'MERCHANT', 'NONE')
BarMerchVal.TextColor3 = Color3.fromRGB(255, 200, 80)

local BarUptimeVal = CreateTopBarCell(0.62, 0.27, 'UPTIME', '00:00:00')
RegisterAccent(BarUptimeVal, 'TextColor3')

local TopBarOpenBtn = Instance.new('ImageButton', TopBar)
TopBarOpenBtn.Size = UDim2.new(0.11, -6, 1, -6)
TopBarOpenBtn.Position = UDim2.new(0.89, 3, 0, 3)
TopBarOpenBtn.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
TopBarOpenBtn.Image = FallbackLogo
TopBarOpenBtn.ScaleType = Enum.ScaleType.Fit
TopBarOpenBtn.ZIndex = 28
Instance.new('UICorner', TopBarOpenBtn).CornerRadius = UDim.new(0, 6)

-- // Main Window
local MainWindow = Instance.new('Frame', ScreenGui)
MainWindow.Name = 'MainWindow'
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Size = UDim2.new(0, 465, 0, 280)
MainWindow.Position = UDim2.new(0.5, 0, 0.54, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 19, 29)
MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
MainWindow.Active = true
MainWindow.ZIndex = 5
Instance.new('UICorner', MainWindow).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new('UIStroke', MainWindow)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
RegisterAccent(MainStroke, 'Color')

local WindowScale = Instance.new('UIScale', MainWindow)
local function RecalculateScale()
    pcall(function()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 480)
        local ratio = math.clamp(math.min(vp.X / 540, vp.Y / 330), 0.65, 1.1)
        WindowScale.Scale = ratio * (NyXConfig.UIScalePercent / 100)
    end)
end
RecalculateScale()
if Workspace.CurrentCamera then
    TrackConn(Workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(RecalculateScale))
end

MakeDraggable(TopBar, TopBar)
MakeDraggable(TopBarOpenBtn, TopBar, function()
    MainWindow.Visible = not MainWindow.Visible
end)

local Sidebar = Instance.new('Frame', MainWindow)
Sidebar.Size = UDim2.new(0, 118, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
Sidebar.BackgroundTransparency = 0.25
Instance.new('UICorner', Sidebar).CornerRadius = UDim.new(0, 10)

local BrandImage = Instance.new('ImageLabel', Sidebar)
BrandImage.Size = UDim2.new(0, 24, 0, 24)
BrandImage.Position = UDim2.new(0, 10, 0, 10)
BrandImage.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
BrandImage.BackgroundTransparency = 0.2
BrandImage.Image = FallbackLogo
BrandImage.ScaleType = Enum.ScaleType.Fit
Instance.new('UICorner', BrandImage).CornerRadius = UDim.new(0, 6)

task.spawn(function()
    pcall(function()
        local customAsset = getcustomasset or getsynasset
        local url = 'https://wutheringlab.com/wp-content/uploads/Hsin-icon.webp'
        local file = 'NyX_Hsin_Icon.webp'
        if customAsset and writefile and isfile then
            if not isfile(file) then
                local req = (syn and syn.request) or http_request or request
                if req then
                    local res = req({Url = url, Method = 'GET'})
                    if res and res.Body then writefile(file, res.Body) end
                end
            end
            if isfile(file) then
                local id = customAsset(file)
                if id and id ~= '' then
                    TopBarOpenBtn.Image = id
                    BrandImage.Image = id
                end
            end
        end
    end)
end)

local BrandTitle = Instance.new('TextLabel', Sidebar)
BrandTitle.Size = UDim2.new(1, -40, 0, 24)
BrandTitle.Position = UDim2.new(0, 38, 0, 10)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = 'NyX v10'
BrandTitle.Font = Enum.Font.GothamBlack
BrandTitle.TextSize = 12
BrandTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

MakeDraggable(Sidebar, MainWindow)

local CloseBtn = Instance.new('TextButton', MainWindow)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
CloseBtn.Text = 'X'
CloseBtn.TextColor3 = Color3.fromRGB(210, 215, 235)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
Instance.new('UICorner', CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

local NavHolder = Instance.new('Frame', Sidebar)
NavHolder.Size = UDim2.new(1, -12, 1, -48)
NavHolder.Position = UDim2.new(0, 6, 0, 42)
NavHolder.BackgroundTransparency = 1
Instance.new('UIListLayout', NavHolder).Padding = UDim.new(0, 4)

local ContentArea = Instance.new('Frame', MainWindow)
ContentArea.Size = UDim2.new(1, -122, 1, 0)
ContentArea.Position = UDim2.new(0, 122, 0, 0)
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
    HeaderTitle.TextSize = 14
    HeaderTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Scroll = Instance.new('ScrollingFrame', Page)
    Scroll.Size = UDim2.new(1, -16, 1, -38)
    Scroll.Position = UDim2.new(0, 8, 0, 32)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RegisterAccent(Scroll, 'ScrollBarImageColor3')
    Instance.new('UIListLayout', Scroll).Padding = UDim.new(0, 5)

    local NavBtn = Instance.new('TextButton', NavHolder)
    NavBtn.Size = UDim2.new(1, 0, 0, 26)
    NavBtn.BackgroundColor3 = Color3.fromRGB(32, 38, 56)
    NavBtn.BackgroundTransparency = 1
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
        for _, p in ipairs(Runtime.Pages) do p.Visible = false end
        for _, b in ipairs(Runtime.NavButtons) do
            b.Btn.BackgroundTransparency = 1
            b.Btn.TextColor3 = Color3.fromRGB(160, 170, 195)
            b.Bar.Visible = false
        end
        Page.Visible = true
        NavBtn.BackgroundTransparency = 0.2
        NavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveBar.Visible = true
    end)

    table.insert(Runtime.Pages, Page)
    table.insert(Runtime.NavButtons, {Btn = NavBtn, Bar = ActiveBar})
    return Scroll, NavBtn, ActiveBar
end

local function AddSectionLabel(parent, text)
    local Lbl = Instance.new('TextLabel', parent)
    Lbl.Size = UDim2.new(1, -4, 0, 15)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text:upper()
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 9
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterAccent(Lbl, 'TextColor3')
end

local function AddToggle(parent, title, defaultVal, callback)
    local Card = Instance.new('TextButton', parent)
    Card.Size = UDim2.new(1, -4, 0, 29)
    Card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    Card.BackgroundTransparency = 0.2
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
    SwitchBg.BackgroundColor3 = defaultVal and NyXConfig.UIAccentColor or Color3.fromRGB(48, 54, 72)
    Instance.new('UICorner', SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new('Frame', SwitchBg)
    Knob.Size = UDim2.new(0, 11, 0, 11)
    Knob.Position = defaultVal and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new('UICorner', Knob).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    table.insert(Runtime.DynamicAccentCallbacks, function(newCol)
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
    Card.Size = UDim2.new(1, -4, 0, 40)
    Card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    Card.BackgroundTransparency = 0.2
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 6)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -16, 0, 13)
    TitleLbl.Position = UDim2.new(0, 8, 0, 3)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 9
    TitleLbl.TextColor3 = Color3.fromRGB(210, 220, 240)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new('TextBox', Card)
    Box.Size = UDim2.new(1, -16, 0, 18)
    Box.Position = UDim2.new(0, 8, 0, 17)
    Box.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    Box.Text = defaultText or ''
    Box.PlaceholderText = placeholder or ''
    Box.TextColor3 = Color3.fromRGB(240, 245, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(115, 125, 145)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 9
    Box.ClearTextOnFocus = false
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', Box).CornerRadius = UDim.new(0, 4)

    Box.FocusLost:Connect(function()
        if callback then callback(Box.Text) end
    end)
    return Box
end

local function AddButton(parent, title, callback)
    local Btn = Instance.new('TextButton', parent)
    Btn.Size = UDim2.new(1, -4, 0, 27)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 38, 56)
    Btn.BackgroundTransparency = 0.15
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
    Card.Size = UDim2.new(1, -4, 0, 34)
    Card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    Card.BackgroundTransparency = 0.2
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
    BarBg.Size = UDim2.new(1, -16, 0, 7)
    BarBg.Position = UDim2.new(0, 8, 0, 20)
    BarBg.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
    BarBg.Text = ''
    Instance.new('UICorner', BarBg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new('Frame', BarBg)
    Fill.Size = UDim2.new(math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
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
    TrackConn(BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true UpdateFromInput(input)
        end
    end))
    TrackConn(UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromInput(input)
        end
    end))
    TrackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end))
end

-- ==========================================
-- // BUILD THE 6 TABS
-- ==========================================
local HomeScroll, HomeNavBtn, HomeNavBar = CreateTabPage('Home')
local MainScroll = CreateTabPage('Main')
local MerchantScroll = CreateTabPage('Merchant')
local ConnScroll = CreateTabPage('Webhook')
local PingsScroll = CreateTabPage('Pings')
local SettingScroll = CreateTabPage('Settings')

Runtime.Pages[1].Visible = true
HomeNavBtn.BackgroundTransparency = 0.2
HomeNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeNavBar.Visible = true

-- // TAB 1: HOME
local GraveyardHomeCard = Instance.new('Frame', HomeScroll)
GraveyardHomeCard.Size = UDim2.new(1, -4, 0, 30)
GraveyardHomeCard.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
GraveyardHomeCard.BackgroundTransparency = 0.2
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

local GraveyardHomeValue = Instance.new('TextLabel', GraveyardHomeCard)
GraveyardHomeValue.Size = UDim2.new(0.45, -10, 1, 0)
GraveyardHomeValue.Position = UDim2.new(0.55, 0, 0, 0)
GraveyardHomeValue.BackgroundTransparency = 1
GraveyardHomeValue.Text = 'INACTIVE'
GraveyardHomeValue.Font = Enum.Font.GothamBlack
GraveyardHomeValue.TextSize = 10
GraveyardHomeValue.TextColor3 = Color3.fromRGB(165, 185, 200)
GraveyardHomeValue.TextXAlignment = Enum.TextXAlignment.Right

AddSectionLabel(HomeScroll, 'Control')
AddToggle(HomeScroll, 'Start Macro (Biome & Merchant)', NyXConfig.MacroActive, function(val)
    if val then
        NyXConfig.MacroActive = true
        MacroStartTime = os.time()
        SendMacroStateEmbed(true)
        Notify('Macro', 'Started!', 2)
    else
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        NyXConfig.MacroActive = false
        SendMacroStateEmbed(false, finalElapsed)
        MacroStartTime = 0
        BarUptimeVal.Text = '00:00:00'
        Notify('Macro', 'Stopped!', 2)
    end
end)

AddButton(HomeScroll, 'Unstuck Character Jump', function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if hum and root then
            ForceJump(hum)
            root.CFrame = root.CFrame + Vector3.new(0, 4, 0)
        end
    end)
end)

-- // TAB 2: MAIN (19 BIOMES)
AddSectionLabel(MainScroll, 'Automation')
AddToggle(MainScroll, 'Auto Collect Ground Items', NyXConfig.AutoCollectItems, function(val) NyXConfig.AutoCollectItems = val end)
AddToggle(MainScroll, 'Auto Biome Randomizer', NyXConfig.AutoBiomeRandomizer, function(val) NyXConfig.AutoBiomeRandomizer = val end)
AddToggle(MainScroll, 'Auto Strange Controller', NyXConfig.AutoStrangeController, function(val) NyXConfig.AutoStrangeController = val end)
AddSlider(MainScroll, 'Item Interval', 5, 300, NyXConfig.UseInterval, 's', function(val) NyXConfig.UseInterval = val end)
AddButton(MainScroll, 'Use Biome Randomizer', function() task.spawn(function() UseItemWithInventoryFailsafe('Biome Randomizer') end) end)
AddButton(MainScroll, 'Use Strange Controller', function() task.spawn(function() UseItemWithInventoryFailsafe('Strange Controller') end) end)

AddSectionLabel(MainScroll, 'Stop Auto In (19 Biomes)')
local StopGridFrame = Instance.new('Frame', MainScroll)
StopGridFrame.Size = UDim2.new(1, -4, 0, 140)
StopGridFrame.BackgroundTransparency = 1
local GridLayout = Instance.new('UIGridLayout', StopGridFrame)
GridLayout.CellSize = UDim2.new(0.24, -3, 0, 24)
GridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All19Biomes) do
    local Chip = Instance.new('TextButton', StopGridFrame)
    Chip.BackgroundColor3 = NyXConfig.StopAutoBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 7
    Chip.TextColor3 = Color3.fromRGB(240, 244, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

    table.insert(Runtime.DynamicAccentCallbacks, function(newCol)
        if NyXConfig.StopAutoBiomes[bName] then Chip.BackgroundColor3 = newCol end
    end)

    Chip.MouseButton1Click:Connect(function()
        NyXConfig.StopAutoBiomes[bName] = not NyXConfig.StopAutoBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.StopAutoBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
    end)
end

-- // TAB 3: MERCHANT
local MerchantLiveCard = Instance.new('Frame', MerchantScroll)
MerchantLiveCard.Size = UDim2.new(1, -4, 0, 42)
MerchantLiveCard.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
MerchantLiveCard.BackgroundTransparency = 0.2
Instance.new('UICorner', MerchantLiveCard).CornerRadius = UDim.new(0, 6)

local MTabStatusLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabStatusLbl.Size = UDim2.new(1, -16, 0, 16)
MTabStatusLbl.Position = UDim2.new(0, 8, 0, 4)
MTabStatusLbl.BackgroundTransparency = 1
MTabStatusLbl.Text = 'Merchant: NONE'
MTabStatusLbl.Font = Enum.Font.GothamBold
MTabStatusLbl.TextSize = 10
MTabStatusLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
MTabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local MTabCoordsLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabCoordsLbl.Size = UDim2.new(1, -16, 0, 14)
MTabCoordsLbl.Position = UDim2.new(0, 8, 0, 21)
MTabCoordsLbl.BackgroundTransparency = 1
MTabCoordsLbl.Text = 'XYZ: N/A'
MTabCoordsLbl.Font = Enum.Font.Gotham
MTabCoordsLbl.TextSize = 9
MTabCoordsLbl.TextColor3 = Color3.fromRGB(150, 160, 185)
MTabCoordsLbl.TextXAlignment = Enum.TextXAlignment.Left

AddSectionLabel(MerchantScroll, 'Actions')
AddToggle(MerchantScroll, 'Auto Walk to Merchant', NyXConfig.AutoWalkToMerchant, function(val) NyXConfig.AutoWalkToMerchant = val end)
AddToggle(MerchantScroll, 'Auto Open Shop', NyXConfig.AutoInteractMerchant, function(val) NyXConfig.AutoInteractMerchant = val end)
AddToggle(MerchantScroll, 'Respawn When Merchant Leaves', NyXConfig.RespawnIfMerchantLeft, function(val) NyXConfig.RespawnIfMerchantLeft = val end)
AddButton(MerchantScroll, 'Walk to Merchant Now', function() WalkToActiveMerchantNow() end)
AddButton(MerchantScroll, 'Stop Walking', function() Runtime.CancelCurrentWalk = true end)

-- // TAB 4 & 5: WEBHOOK & PINGS
local ConnUserIDBox, PingUserIDBox
AddInput(ConnScroll, 'Webhook URL', NyXConfig.WebhookURL, 'https://discord.com/api/webhooks/...', function(txt)
    NyXConfig.WebhookURL = txt:gsub('%s+', '')
end)
ConnUserIDBox = AddInput(ConnScroll, 'Discord User ID', NyXConfig.DiscordID, 'Numeric ID', function(txt)
    local clean = txt:gsub('%D+', '')
    NyXConfig.DiscordID = clean
    if PingUserIDBox then PingUserIDBox.Text = clean end
end)
AddInput(ConnScroll, 'Private Server Link', NyXConfig.PrivateServerLink, 'https://www.roblox.com/share?code=...', function(txt)
    NyXConfig.PrivateServerLink = txt
end)
AddButton(ConnScroll, 'Save Config', function() SaveWebhookConfig() Notify('Config', 'Saved!', 2) end)
AddButton(ConnScroll, 'Test Webhook', function() SendTestWebhookEmbed(false) Notify('Webhook', 'Test sent!', 2) end)

PingUserIDBox = AddInput(PingsScroll, 'Discord User ID', NyXConfig.DiscordID, 'Numeric ID...', function(txt)
    local clean = txt:gsub('%D+', '')
    NyXConfig.DiscordID = clean
    if ConnUserIDBox then ConnUserIDBox.Text = clean end
end)
AddButton(PingsScroll, 'Test User ID Ping', function()
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    if cleanID == '' then Notify('Ping', 'Enter User ID first!', 2.5) return end
    SendTestWebhookEmbed(true)
    Notify('Ping', 'Sent!', 2)
end)

AddSectionLabel(PingsScroll, 'Biomes (19)')
local PingBiomeGrid = Instance.new('Frame', PingsScroll)
PingBiomeGrid.Size = UDim2.new(1, -4, 0, 140)
PingBiomeGrid.BackgroundTransparency = 1
local PGridLayout = Instance.new('UIGridLayout', PingBiomeGrid)
PGridLayout.CellSize = UDim2.new(0.24, -3, 0, 24)
PGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All19Biomes) do
    local Chip = Instance.new('TextButton', PingBiomeGrid)
    Chip.BackgroundColor3 = NyXConfig.PingBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 7
    Chip.TextColor3 = Color3.fromRGB(240, 244, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

    table.insert(Runtime.DynamicAccentCallbacks, function(newCol)
        if NyXConfig.PingBiomes[bName] then Chip.BackgroundColor3 = newCol end
    end)

    Chip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingBiomes[bName] and cleanID == '' then
            Notify('Ping', 'Enter User ID first!', 2.5)
            return
        end
        NyXConfig.PingBiomes[bName] = not NyXConfig.PingBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.PingBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
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
    MChip.BackgroundColor3 = NyXConfig.PingMerchants[mName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
    MChip.Text = mName:upper()
    MChip.Font = Enum.Font.GothamBold
    MChip.TextSize = 8
    MChip.TextColor3 = Color3.fromRGB(240, 244, 255)
    Instance.new('UICorner', MChip).CornerRadius = UDim.new(0, 5)

    table.insert(Runtime.DynamicAccentCallbacks, function(newCol)
        if NyXConfig.PingMerchants[mName] then MChip.BackgroundColor3 = newCol end
    end)

    MChip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingMerchants[mName] and cleanID == '' then
            Notify('Ping', 'Enter User ID first!', 2.5)
            return
        end
        NyXConfig.PingMerchants[mName] = not NyXConfig.PingMerchants[mName]
        MChip.BackgroundColor3 = NyXConfig.PingMerchants[mName] and NyXConfig.UIAccentColor or Color3.fromRGB(24, 30, 44)
        SaveWebhookConfig()
    end)
end

-- // TAB 6: SETTINGS
AddSectionLabel(SettingScroll, 'UI & Alerts')
AddToggle(SettingScroll, 'Lock UI Position', NyXConfig.LockUIPosition, function(val) NyXConfig.LockUIPosition = val end)
AddToggle(SettingScroll, 'Sound Alert', NyXConfig.EnableSoundAlert, function(val) NyXConfig.EnableSoundAlert = val end)
AddButton(SettingScroll, 'Reset UI Position', function()
    MainWindow.Position = UDim2.new(0.5, 0, 0.54, 0)
    TopBar.Position = UDim2.new(0.5, 0, 0, 8)
    MainWindow.Visible = true
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
    RecalculateScale()
end)
AddSlider(SettingScroll, 'Glass Transparency', 0, 50, math.floor(NyXConfig.GlassTransparency * 100), '%', function(val)
    NyXConfig.GlassTransparency = val / 100
    MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
end)

local ColorRow = Instance.new('Frame', SettingScroll)
ColorRow.Size = UDim2.new(1, -4, 0, 24)
ColorRow.BackgroundTransparency = 1
local ColorListLayout = Instance.new('UIListLayout', ColorRow)
ColorListLayout.FillDirection = Enum.FillDirection.Horizontal
ColorListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ColorListLayout.Padding = UDim.new(0.015, 0)

for i, preset in ipairs({
    {Name = 'Blue', Col = Color3.fromRGB(110, 165, 255)},
    {Name = 'Purple', Col = Color3.fromRGB(155, 105, 255)},
    {Name = 'Crimson', Col = Color3.fromRGB(255, 75, 100)},
    {Name = 'Emerald', Col = Color3.fromRGB(50, 220, 125)},
    {Name = 'Gold', Col = Color3.fromRGB(255, 180, 50)}
}) do
    local CBtn = Instance.new('TextButton', ColorRow)
    CBtn.LayoutOrder = i
    CBtn.Size = UDim2.new(0.188, 0, 1, 0)
    CBtn.BackgroundColor3 = preset.Col
    CBtn.Text = preset.Name
    CBtn.Font = Enum.Font.GothamBold
    CBtn.TextSize = 8
    CBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new('UICorner', CBtn).CornerRadius = UDim.new(0, 5)
    CBtn.MouseButton1Click:Connect(function() UpdateAccentColor(preset.Col) end)
end

AddSectionLabel(SettingScroll, 'System')
AddToggle(SettingScroll, 'OLED Black Screen', NyXConfig.BlackScreenSaver, function(val)
    NyXConfig.BlackScreenSaver = val
    BlackSaverFrame.Visible = val
end)
AddToggle(SettingScroll, 'Disable 3D Rendering', NyXConfig.Disable3DRendering, function(val)
    NyXConfig.Disable3DRendering = val
    pcall(function() RunService:Set3dRenderingEnabled(not val) end)
end)
AddToggle(SettingScroll, 'Anti-AFK', NyXConfig.AntiAFK, function(val) NyXConfig.AntiAFK = val end)
AddToggle(SettingScroll, 'Auto Reconnect', NyXConfig.AutoReconnect, function(val) NyXConfig.AutoReconnect = val end)
AddButton(SettingScroll, 'Boost FPS', function()
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
    Notify('FPS', 'Optimized!', 2)
end)
AddButton(SettingScroll, 'Copy JobId', function()
    if setclipboard then pcall(setclipboard, tostring(game.JobId)) Notify('JobId', 'Copied!', 2) end
end)
AddButton(SettingScroll, 'Rejoin Server', function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

AddButton(SettingScroll, 'Destroy Script', function()
    ScriptRunning = false
    Runtime.CancelCurrentWalk = true
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    if NyXConfig.MacroActive then
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        SendMacroStateEmbed(false, finalElapsed)
    end
    for _, conn in ipairs(Runtime.Connections) do
        pcall(function() if conn and conn.Connected then conn:Disconnect() end end)
    end
    Runtime.Connections = {}
    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
end)

-- ==========================================
-- // CONSOLIDATED LOW-CPU BACKGROUND LOOPS
-- ==========================================
task.spawn(function()
    local confirmedBiome = GetAccurateServerBiome()
    local pendingBiome = confirmedBiome
    local pendingCount = 0
    NyXConfig.CurrentDetectedBiome = confirmedBiome
    BarBiomeVal.Text = confirmedBiome
    if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
        BarBiomeVal.TextColor3 = BiomeData[confirmedBiome].Hex
    end

    if confirmedBiome == 'GRAVEYARD' then
        NyXConfig.GraveyardActive = true
        NyXConfig.GraveyardStartTimestamp = os.time()
        NyXConfig.GraveyardElapsed = 0
        NyXConfig.SinisterTriggeredInGraveyard = false
    end

    while ScriptRunning and task.wait(1) do
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
            BarBiomeVal.Text = confirmedBiome
            if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
                BarBiomeVal.TextColor3 = BiomeData[confirmedBiome].Hex
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

        if NyXConfig.CurrentDetectedBiome == 'GRAVEYARD' then
            if not NyXConfig.GraveyardActive or NyXConfig.GraveyardStartTimestamp == 0 then
                NyXConfig.GraveyardActive = true
                NyXConfig.GraveyardStartTimestamp = os.time()
            end
            NyXConfig.GraveyardElapsed = os.time() - NyXConfig.GraveyardStartTimestamp
            local gTimeStr = FormatMMSS(NyXConfig.GraveyardElapsed)
            BarBiomeVal.Text = 'GRAVEYARD (' .. gTimeStr .. ')'

            if NyXConfig.GraveyardElapsed >= 300 and not NyXConfig.SinisterTriggeredInGraveyard then
                NyXConfig.SinisterTriggeredInGraveyard = true
                local _, sPos = FindMerchantWorldPosition(true)
                local remainingGraveyard = math.max(60, 660 - NyXConfig.GraveyardElapsed)
                SetMerchantArrivedState('Sinister S.', sPos, remainingGraveyard)
            end

            if MainWindow.Visible then
                if NyXConfig.SinisterTriggeredInGraveyard then
                    GraveyardHomeValue.Text = gTimeStr .. ' / 11:00 (SINISTER)'
                    GraveyardHomeValue.TextColor3 = Color3.fromRGB(255, 140, 50)
                else
                    GraveyardHomeValue.Text = gTimeStr .. ' / 05:00'
                    GraveyardHomeValue.TextColor3 = Color3.fromRGB(165, 220, 255)
                end
            end
        else
            BarBiomeVal.Text = NyXConfig.CurrentDetectedBiome
            if MainWindow.Visible then
                GraveyardHomeValue.Text = 'INACTIVE'
                GraveyardHomeValue.TextColor3 = Color3.fromRGB(150, 160, 185)
            end
        end

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

            if MainWindow.Visible then
                MTabStatusLbl.Text = 'Merchant: ' .. merchDisplayStr
                if NyXConfig.MerchantPosition then
                    local p = NyXConfig.MerchantPosition
                    MTabCoordsLbl.Text = string.format('XYZ: %.0f, %.0f, %.0f', p.X, p.Y, p.Z)
                else
                    MTabCoordsLbl.Text = 'XYZ: Active via Timer'
                end
            end
        else
            if MainWindow.Visible then
                MTabStatusLbl.Text = 'Merchant: NONE'
                MTabCoordsLbl.Text = 'XYZ: N/A'
            end
        end

        BarMerchVal.Text = merchDisplayStr
        BarUptimeVal.Text = GetMacroUptime()
    end
end)

task.spawn(function()
    while ScriptRunning and task.wait(2.5) do
        if NyXConfig.AutoCollectItems and not Runtime.IsWalkingPath and NyXConfig.CurrentMerchant == 'NONE' then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild('HumanoidRootPart')
                if not root then return end
                local DropFolder = Workspace:FindFirstChild('DroppedItems') or Workspace:FindFirstChild('Items') or Workspace
                for _, item in ipairs(DropFolder:GetChildren()) do
                    local n = item.Name:upper()
                    if n:find('POTION') or n:find('COIN') or n:find('LUCKY') or n:find('SPEED') or n:find('GILDED') then
                        local part = item:IsA('BasePart') and item or item:FindFirstChildWhichIsA('BasePart')
                        if part and (part.Position - root.Position).Magnitude < 160 and not IsOverHazard(part.Position) then
                            WalkSafelyToTargetPosition(part.Position, function()
                                return not item.Parent or not NyXConfig.AutoCollectItems or NyXConfig.CurrentMerchant ~= 'NONE'
                            end, false)
                            local prompt = item:FindFirstChildWhichIsA('ProximityPrompt', true)
                            if prompt and fireproximityprompt then pcall(function() fireproximityprompt(prompt) end) end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while ScriptRunning do
        task.wait(1)
        if NyXConfig.AutoBiomeRandomizer or NyXConfig.AutoStrangeController then
            local currentB = GetAccurateServerBiome()
            NyXConfig.CurrentDetectedBiome = currentB
            local shouldStop = NyXConfig.StopAutoBiomes[currentB] == true

            if not shouldStop then
                if NyXConfig.AutoBiomeRandomizer then
                    UseItemWithInventoryFailsafe('Biome Randomizer')
                    for _ = 1, 7 do
                        if not ScriptRunning then break end
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
            while ScriptRunning and waited < NyXConfig.UseInterval do
                task.wait(1)
                waited = waited + 1
                if not NyXConfig.AutoBiomeRandomizer and not NyXConfig.AutoStrangeController then
                    break
                end
            end
        end
    end
end)

Notify('NyX v10', 'Loaded successfully!', 2.5)
