-- // NYX DETECTOR MACRO - ULTRA FIX v3 (SYNTAX VERIFIED)
-- // Features: 3-Min Merchant Lifecycle (Arrived/Left) + River-Safe Pathfinding Walk + Custom 16-Biome/3-Merchant Ping Selector + User Utilities

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
    ['NORMAL'] = 'NORMAL',
    ['WINDY'] = 'WINDY',
    ['SNOWY'] = 'SNOWY',
    ['RAINY'] = 'RAINY',
    ['SANDSTORM'] = 'SANDSTORM',
    ['SANDY'] = 'SANDSTORM',
    ['HELL'] = 'HELL',
    ['STARFALL'] = 'STARFALL',
    ['HEAVEN'] = 'HEAVEN',
    ['LOSTFOREST'] = 'LOST FOREST',
    ['CORRUPTION'] = 'CORRUPTION',
    ['CORRUPTED'] = 'CORRUPTION',
    ['NULL'] = 'NULL',
    ['GLITCHED'] = 'GLITCHED',
    ['GLITCH'] = 'GLITCHED',
    ['DREAMSPACE'] = 'DREAMSPACE',
    ['CYBERSPACE'] = 'CYBERSPACE',
    ['SINGULARITY'] = 'SINGULARITY',
    ['THERADIANTFOREST'] = 'THE RADIANT FOREST',
    ['RADIANTFOREST'] = 'THE RADIANT FOREST'
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

-- // Configuration Table
local NyXConfig = {
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
    StopAutoBiomes = {
        ['GLITCHED'] = true,
        ['DREAMSPACE'] = true,
        ['CYBERSPACE'] = true
    },
    PingBiomes = {
        ['GLITCHED'] = true,
        ['DREAMSPACE'] = true,
        ['CYBERSPACE'] = true
    },
    PingMerchants = {
        ['Mari'] = false,
        ['Jester'] = false,
        ['Rin'] = false
    },
    CurrentDetectedBiome = 'NORMAL',
    CurrentMerchant = 'NONE',
    MerchantSpawnTimestamp = 0,
    MerchantDuration = 180, -- 3 minutes (180 seconds)
    MerchantPosition = nil,
    AntiAFK = true,
    Disable3DRendering = false,
    UIAccentColor = Color3.fromRGB(135, 95, 255),
    GlassTransparency = 0.08,
    UIScalePercent = 95
}

for _, bName in ipairs(All16Biomes) do
    if NyXConfig.PingBiomes[bName] == nil then
        NyXConfig.PingBiomes[bName] = false
    end
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
local IdledConn = LocalPlayer.Idled:Connect(function()
    if not ScriptRunning or not NyXConfig.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end)

pcall(function()
    GuiService.ErrorMessageChanged:Connect(function()
        if ScriptRunning and NyXConfig.AutoReconnect then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
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
-- // DISCORD WEBHOOK SYSTEM (USER-DEFINED PINGS)
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

local function SendMerchantLeftEmbed(merchantName)
    if not NyXConfig.EnableMerchantWebhook then return end
    local mInfo = MerchantData[merchantName] or {
        Color = 0x555555,
        Image = 'https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter'
    }

    SendRawWebhook({
        ['content'] = '',
        ['embeds'] = {{
            ['title'] = merchantName .. ' has left!',
            ['description'] = '**Merchant :** `' .. merchantName .. '` has despawned.\n**Macro Uptime :** `' .. GetMacroUptime() .. '`',
            ['color'] = 0x555555,
            ['thumbnail'] = {['url'] = mInfo.Image},
            ['footer'] = {['text'] = 'NyX Detector Macro | ' .. os.date('%H:%M:%S')}
        }}
    })
end

-- ==========================================
-- // RIVER-SAFE PATHFINDING TO MERCHANT & ITEMS (ANTI-BAN)
-- ==========================================
local isWalkingPath = false

local function RespawnCharacterSafely()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if hum then
            hum.Health = 0
        end
    end)
end

local function FindMerchantWorldPosition()
    local foundName, foundPos, foundPrompt = nil, nil, nil
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA('ProximityPrompt') then
                local combined = (obj.ObjectText .. ' ' .. obj.ActionText .. ' ' .. (obj.Parent and obj.Parent.Name or '') .. ' ' .. (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name or '')):upper()
                local mName = nil
                if combined:find('%f[%a]JESTER%f[%A]') then mName = 'Jester'
                elseif combined:find('%f[%a]RIN%f[%A]') then mName = 'Rin'
                elseif combined:find('%f[%a]MARI%f[%A]') then mName = 'Mari' end

                if mName then
                    local part = obj:FindFirstAncestorWhichIsA('BasePart') or (obj.Parent and obj.Parent:IsA('Model') and obj.Parent.PrimaryPart)
                    if part then
                        foundName = mName
                        foundPos = part.Position
                        foundPrompt = obj
                        return
                    end
                end
            elseif obj:IsA('Model') then
                local n = obj.Name:upper()
                local mName = nil
                if n == 'JESTER' or n == 'MERCHANT_JESTER' or n == 'JESTERNPC' then mName = 'Jester'
                elseif n == 'RIN' or n == 'MERCHANT_RIN' or n == 'RINNPC' then mName = 'Rin'
                elseif n == 'MARI' or n == 'MERCHANT_MARI' or n == 'MARINPC' then mName = 'Mari' end

                if mName then
                    local pivot = obj:GetPivot()
                    if pivot then
                        foundName = mName
                        foundPos = pivot.Position
                        foundPrompt = obj:FindFirstChildWhichIsA('ProximityPrompt', true)
                        return
                    end
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

local function WalkSafelyToTargetPosition(targetPos, stopConditionFunc)
    if isWalkingPath or not targetPos then return false end
    isWalkingPath = true
    local reached = false

    xpcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not hum or not root or hum.Health <= 0 then
            isWalkingPath = false
            return
        end

        local path = PathfindingService:CreatePath({
            AgentRadius = 2.2,
            AgentHeight = 5.0,
            AgentCanJump = true,
            WaypointSpacing = 4.0,
            Costs = {
                Water = math.huge,
                Danger = math.huge
            }
        })

        local ok = pcall(function()
            path:ComputeAsync(root.Position, targetPos)
        end)

        if ok and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, wp in ipairs(waypoints) do
                if not ScriptRunning or (stopConditionFunc and stopConditionFunc()) then break end
                if not char.Parent or hum.Health <= 0 then break end

                if IsWaypointOverWaterOrVoid(wp.Position) then
                    hum.Jump = true
                end

                if wp.Action == Enum.PathWaypointAction.Jump then
                    hum.Jump = true
                end

                hum:MoveTo(wp.Position)
                local stepStart = os.clock()
                while (root.Position - wp.Position).Magnitude > 4.2 and (os.clock() - stepStart) < 2.2 do
                    if not ScriptRunning or (stopConditionFunc and stopConditionFunc()) then break end
                    if (root.Position - wp.Position).Magnitude > 3 and hum.MoveDirection.Magnitude > 0 and root.Velocity.Magnitude < 1.2 then
                        hum.Jump = true
                    end
                    task.wait(0.08)
                end

                if (root.Position - targetPos).Magnitude <= 8 then
                    reached = true
                    break
                end
            end
        else
            if not IsWaypointOverWaterOrVoid(targetPos) then
                hum:MoveTo(targetPos)
                local t0 = os.clock()
                while (root.Position - targetPos).Magnitude > 7 and (os.clock() - t0) < 8 do
                    if not ScriptRunning or IsWaypointOverWaterOrVoid(root.Position + root.CFrame.LookVector * 5) then
                        hum:MoveTo(root.Position)
                        break
                    end
                    task.wait(0.15)
                end
            end
        end
    end, function() end)

    isWalkingPath = false
    return reached
end

local function WalkToActiveMerchantNow()
    task.spawn(function()
        local mName, mPos, mPrompt = FindMerchantWorldPosition()
        if not mPos and NyXConfig.MerchantPosition then
            mPos = NyXConfig.MerchantPosition
            mName = NyXConfig.CurrentMerchant
        end
        if not mPos then
            Notify('Merchant Pathfinding', 'No active merchant coordinates found in world!', 3)
            return
        end

        Notify('Merchant Pathfinding', 'Walking safely to ' .. tostring(mName or 'Merchant') .. ' (Avoiding rivers)...', 3.5)
        WalkSafelyToTargetPosition(mPos, function()
            return NyXConfig.CurrentMerchant == 'NONE'
        end)

        if NyXConfig.AutoInteractMerchant and mPrompt and fireproximityprompt then
            pcall(function() fireproximityprompt(mPrompt) end)
        end
    end)
end

-- ==========================================
-- // MERCHANT LIFECYCLE MANAGER (3-MINUTE TIMER + LEFT STATE)
-- ==========================================
local function SetMerchantArrivedState(merchantName, worldPos)
    if NyXConfig.CurrentMerchant == merchantName:upper() then
        if worldPos then NyXConfig.MerchantPosition = worldPos end
        return
    end

    NyXConfig.CurrentMerchant = merchantName:upper()
    NyXConfig.MerchantSpawnTimestamp = os.time()
    NyXConfig.MerchantPosition = worldPos

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

    SendMerchantLeftEmbed(prevMerchant)
    Notify('Merchant Left', prevMerchant .. ' has left! (' .. tostring(reason or '3m Elapsed') .. ')', 4)

    if NyXConfig.RespawnIfMerchantLeft then
        Notify('Auto Respawn', 'Respawning character because merchant left...', 3)
        task.wait(0.8)
        RespawnCharacterSafely()
    end
end

-- ==========================================
-- // ULTRA-ACCURATE BIOME SCANNER
-- ==========================================
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
        local pGui = LocalPlayer:FindFirstChild('PlayerGui')
        if not pGui then return end

        local bracketedMatch = nil
        local exactHudLabelMatch = nil

        for _, v in ipairs(pGui:GetDescendants()) do
            if v:IsA('TextLabel') and v.Visible and v.Text ~= '' and (not ScreenGui or not v:IsDescendantOf(ScreenGui)) then
                local fullName = v:GetFullName():upper()
                if not fullName:find('NYX')
                   and not fullName:find('INVENTORY')
                   and not fullName:find('BACKPACK')
                   and not fullName:find('CHAT')
                   and not fullName:find('SHOP')
                   and not fullName:find('COLLECTION')
                   and not fullName:find('BESTIARY')
                   and not fullName:find('INDEX')
                   and not fullName:find('QUEST')
                   and not fullName:find('CRAFT')
                   and not fullName:find('SETTING')
                   and not fullName:find('LEADERBOARD')
                   and not fullName:find('PLAYERLIST')
                   and not fullName:find('AURA')
                   and not fullName:find('ROLL') then

                    local bMatch = ParseStrictBiomeToken(v.Text, true)
                    if bMatch then
                        bracketedMatch = bMatch
                        if bMatch ~= 'NORMAL' then break end
                    end

                    local lblName = v.Name:upper()
                    if lblName == 'BIOME' or lblName == 'BIOMELABEL' or lblName == 'BIOMETEXT' or lblName == 'CURRENTBIOME' then
                        local eMatch = ParseStrictBiomeToken(v.Text, false)
                        if eMatch then
                            exactHudLabelMatch = eMatch
                        end
                    end
                end
            end
        end

        foundBiome = bracketedMatch or exactHudLabelMatch
    end)

    return foundBiome or 'NORMAL'
end

-- ==========================================
-- // STRICT MERCHANT ARRIVAL & DEPARTURE PARSER (FIXED SYNTAX)
-- ==========================================
local function ParseMerchantSystemEvent(rawText)
    local clean = CleanRichText(rawText):upper()
    if clean == '' then return nil, nil end

    local mName = nil
    if clean:find('%f[%a]JESTER%f[%A]') or clean:find('JESTER') then
        mName = 'Jester'
    elseif clean:find('%f[%a]RIN%f[%A]') or clean:find('RIN') then
        mName = 'Rin'
    elseif clean:find('%f[%a]MARI%f[%A]') or clean:find('MARI') then
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
        TextChatService.MessageReceived:Connect(function(message)
            if not ScriptRunning then return end
            if message.TextSource ~= nil then return end
            local txt = (message.Text or '') .. ' ' .. (message.PrefixText or '')
            local mName, action = ParseMerchantSystemEvent(txt)
            if mName and action == 'ARRIVED' then
                local _, pos = FindMerchantWorldPosition()
                SetMerchantArrivedState(mName, pos)
            elseif mName and action == 'LEFT' then
                SetMerchantLeftState('System Chat Left')
            end
        end)
    end
end)

-- ==========================================
-- // FAILSAFE AUTO INVENTORY
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

    xpcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild('Remotes') or ReplicatedStorage:FindFirstChild('Events') or ReplicatedStorage
        for _, r in pairs(Remotes:GetDescendants()) do
            if r:IsA('RemoteEvent') and (r.Name:lower():find('use') or r.Name:lower():find('item') or r.Name:lower():find('inventory')) then
                pcall(function() r:FireServer(itemName) end)
                pcall(function() r:FireServer('Use', itemName) end)
                pcall(function() r:FireServer(itemName, 1) end)
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
    end, function() end)

    isUsingInventoryFailsafe = false
end

-- ==========================================
-- // ANDROID-COMPACT RESPONSIVE UI CREATION
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

-- OLED Black Screen Battery Saver Overlay
local BlackSaverFrame = Instance.new('Frame')
BlackSaverFrame.Name = 'BlackScreenOverlay'
BlackSaverFrame.Size = UDim2.new(1, 0, 1, 0)
BlackSaverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackSaverFrame.Visible = false
BlackSaverFrame.ZIndex = 1
BlackSaverFrame.Parent = ScreenGui

local BlackSaverLabel = Instance.new('TextLabel', BlackSaverFrame)
BlackSaverLabel.Size = UDim2.new(1, 0, 0, 40)
BlackSaverLabel.Position = UDim2.new(0, 0, 0.45, -20)
BlackSaverLabel.BackgroundTransparency = 1
BlackSaverLabel.Text = 'NYX DETECTOR MACRO - BATTERY SAVER ACTIVE'
BlackSaverLabel.Font = Enum.Font.GothamBlack
BlackSaverLabel.TextSize = 14
BlackSaverLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
BlackSaverLabel.ZIndex = 2

local AccentObjects = {}

local function RegisterAccent(obj, prop)
    table.insert(AccentObjects, {Obj = obj, Prop = prop})
    obj[prop] = NyXConfig.UIAccentColor
end

local function UpdateAccentColor(newColor)
    NyXConfig.UIAccentColor = newColor
    for _, item in ipairs(AccentObjects) do
        pcall(function() item.Obj[item.Prop] = newColor end)
    end
end

local ToastHolder = Instance.new('Frame')
ToastHolder.Size = UDim2.new(0, 220, 1, -16)
ToastHolder.Position = UDim2.new(1, -230, 0, 8)
ToastHolder.BackgroundTransparency = 1
ToastHolder.ZIndex = 20
ToastHolder.Parent = ScreenGui

local ToastLayout = Instance.new('UIListLayout')
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.Padding = UDim.new(0, 6)
ToastLayout.Parent = ToastHolder

Notify = function(title, text, duration)
    task.spawn(function()
        local Card = Instance.new('Frame')
        Card.Size = UDim2.new(1, 0, 0, 48)
        Card.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
        Card.BackgroundTransparency = 0.08
        Card.ZIndex = 21
        Card.Parent = ToastHolder

        local Crn = Instance.new('UICorner', Card)
        Crn.CornerRadius = UDim.new(0, 8)

        local Strk = Instance.new('UIStroke', Card)
        Strk.Color = NyXConfig.UIAccentColor
        Strk.Thickness = 1.2
        Strk.Transparency = 0.25

        local Tbl = Instance.new('TextLabel', Card)
        Tbl.Size = UDim2.new(1, -16, 0, 18)
        Tbl.Position = UDim2.new(0, 10, 0, 4)
        Tbl.BackgroundTransparency = 1
        Tbl.Text = title
        Tbl.TextColor3 = Color3.fromRGB(245, 245, 255)
        Tbl.Font = Enum.Font.GothamBold
        Tbl.TextSize = 11
        Tbl.ZIndex = 22
        Tbl.TextXAlignment = Enum.TextXAlignment.Left

        local Sub = Instance.new('TextLabel', Card)
        Sub.Size = UDim2.new(1, -16, 0, 20)
        Sub.Position = UDim2.new(0, 10, 0, 22)
        Sub.BackgroundTransparency = 1
        Sub.Text = text
        Sub.TextColor3 = Color3.fromRGB(175, 175, 195)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 9
        Sub.TextWrapped = true
        Sub.ZIndex = 22
        Sub.TextXAlignment = Enum.TextXAlignment.Left

        task.wait(duration or 3)
        if Card and Card.Parent then Card:Destroy() end
    end)
end

-- Compact Main Window (480x285 base size for Android screens)
local MainWindow = Instance.new('Frame')
MainWindow.Name = 'MainWindow'
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Size = UDim2.new(0, 480, 0, 285)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
MainWindow.Active = true
MainWindow.ZIndex = 5
MainWindow.Parent = ScreenGui

local WindowScale = Instance.new('UIScale', MainWindow)

local function RecalculateResponsiveScale()
    pcall(function()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 480)
        local autoRatio = math.clamp(math.min(vp.X / 560, vp.Y / 340), 0.65, 1.1)
        WindowScale.Scale = autoRatio * (NyXConfig.UIScalePercent / 100)
    end)
end
RecalculateResponsiveScale()
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(RecalculateResponsiveScale)
end

local MainCorner = Instance.new('UICorner', MainWindow)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new('UIStroke', MainWindow)
MainStroke.Thickness = 1.3
MainStroke.Transparency = 0.35
RegisterAccent(MainStroke, 'Color')

-- Compact Floating "ND" Button
local NDButton = Instance.new('TextButton')
NDButton.Name = 'NDLogoBtn'
NDButton.Size = UDim2.new(0, 44, 0, 44)
NDButton.Position = UDim2.new(0.03, 0, 0.2, 0)
NDButton.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
NDButton.BackgroundTransparency = 0.08
NDButton.Text = 'ND'
NDButton.TextColor3 = Color3.fromRGB(245, 240, 255)
NDButton.Font = Enum.Font.GothamBlack
NDButton.TextSize = 17
NDButton.Active = true
NDButton.ZIndex = 30
NDButton.Parent = ScreenGui

local NDCrn = Instance.new('UICorner', NDButton)
NDCrn.CornerRadius = UDim.new(0, 10)

local NDStroke = Instance.new('UIStroke', NDButton)
NDStroke.Thickness = 1.8
RegisterAccent(NDStroke, 'Color')

local NDSub = Instance.new('TextLabel', NDButton)
NDSub.Size = UDim2.new(1, 0, 0, 10)
NDSub.Position = UDim2.new(0, 0, 0.72, 0)
NDSub.BackgroundTransparency = 1
NDSub.Text = 'NYX'
NDSub.Font = Enum.Font.GothamBold
NDSub.TextSize = 7
NDSub.ZIndex = 31
RegisterAccent(NDSub, 'TextColor3')

local function MakeDraggable(dragHandle, targetFrame, onClickCallback)
    local dragging, hasMoved, dragStart, startPos = false, false, nil, nil
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = targetFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                hasMoved = true
                targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not hasMoved and onClickCallback then
                    onClickCallback()
                end
            end
        end
    end)
end

MakeDraggable(NDButton, NDButton, function()
    MainWindow.Visible = not MainWindow.Visible
end)

-- Left Sidebar
local Sidebar = Instance.new('Frame', MainWindow)
Sidebar.Size = UDim2.new(0, 138, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
Sidebar.BackgroundTransparency = 0.2

local SidebarCrn = Instance.new('UICorner', Sidebar)
SidebarCrn.CornerRadius = UDim.new(0, 12)

local SidebarDivider = Instance.new('Frame', MainWindow)
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(0, 138, 0, 0)
SidebarDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 68)
SidebarDivider.BorderSizePixel = 0

local BrandIcon = Instance.new('Frame', Sidebar)
BrandIcon.Size = UDim2.new(0, 28, 0, 28)
BrandIcon.Position = UDim2.new(0, 10, 0, 10)
BrandIcon.BackgroundColor3 = Color3.fromRGB(26, 24, 42)
Instance.new('UICorner', BrandIcon).CornerRadius = UDim.new(1, 0)
local BrandStroke = Instance.new('UIStroke', BrandIcon)
BrandStroke.Thickness = 1.3
RegisterAccent(BrandStroke, 'Color')

local BrandLogoTxt = Instance.new('TextLabel', BrandIcon)
BrandLogoTxt.Size = UDim2.new(1, 0, 1, 0)
BrandLogoTxt.BackgroundTransparency = 1
BrandLogoTxt.Text = 'N'
BrandLogoTxt.Font = Enum.Font.GothamBlack
BrandLogoTxt.TextSize = 14
BrandLogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)

local BrandTitle = Instance.new('TextLabel', Sidebar)
BrandTitle.Size = UDim2.new(0, 88, 0, 16)
BrandTitle.Position = UDim2.new(0, 44, 0, 10)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = 'NyX Detector'
BrandTitle.Font = Enum.Font.GothamBlack
BrandTitle.TextSize = 12
BrandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

local BrandSub = Instance.new('TextLabel', Sidebar)
BrandSub.Size = UDim2.new(0, 88, 0, 12)
BrandSub.Position = UDim2.new(0, 44, 0, 25)
BrandSub.BackgroundTransparency = 1
BrandSub.Text = 'MACRO'
BrandSub.Font = Enum.Font.GothamBold
BrandSub.TextSize = 9
BrandSub.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(BrandSub, 'TextColor3')

MakeDraggable(Sidebar, MainWindow)

local CloseBtn = Instance.new('TextButton', MainWindow)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -30, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
CloseBtn.Text = 'x'
CloseBtn.TextColor3 = Color3.fromRGB(190, 190, 215)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new('UICorner', CloseBtn).CornerRadius = UDim.new(0, 6)
Instance.new('UIStroke', CloseBtn).Color = Color3.fromRGB(55, 55, 80)
CloseBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

local NavHolder = Instance.new('Frame', Sidebar)
NavHolder.Size = UDim2.new(1, -16, 1, -52)
NavHolder.Position = UDim2.new(0, 8, 0, 44)
NavHolder.BackgroundTransparency = 1

local NavLayout = Instance.new('UIListLayout', NavHolder)
NavLayout.Padding = UDim.new(0, 3)

local ContentArea = Instance.new('Frame', MainWindow)
ContentArea.Size = UDim2.new(1, -139, 1, 0)
ContentArea.Position = UDim2.new(0, 139, 0, 0)
ContentArea.BackgroundTransparency = 1

local Pages = {}
local NavButtons = {}

local function CreateTabPage(tabName, subtitleText)
    local Page = Instance.new('Frame', ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local HeaderTitle = Instance.new('TextLabel', Page)
    HeaderTitle.Size = UDim2.new(1, -48, 0, 20)
    HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = tabName
    HeaderTitle.Font = Enum.Font.GothamBlack
    HeaderTitle.TextSize = 15
    HeaderTitle.TextColor3 = Color3.fromRGB(250, 250, 255)
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local HeaderSub = Instance.new('TextLabel', Page)
    HeaderSub.Size = UDim2.new(1, -48, 0, 14)
    HeaderSub.Position = UDim2.new(0, 16, 0, 29)
    HeaderSub.BackgroundTransparency = 1
    HeaderSub.Text = subtitleText
    HeaderSub.Font = Enum.Font.Gotham
    HeaderSub.TextSize = 10
    HeaderSub.TextColor3 = Color3.fromRGB(150, 150, 175)
    HeaderSub.TextXAlignment = Enum.TextXAlignment.Left

    local HeaderLine = Instance.new('Frame', Page)
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 0, 48)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(40, 40, 62)
    HeaderLine.BorderSizePixel = 0

    local Scroll = Instance.new('ScrollingFrame', Page)
    Scroll.Size = UDim2.new(1, -24, 1, -56)
    Scroll.Position = UDim2.new(0, 14, 0, 52)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 2
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RegisterAccent(Scroll, 'ScrollBarImageColor3')

    local ScrollLayout = Instance.new('UIListLayout', Scroll)
    ScrollLayout.Padding = UDim.new(0, 7)

    local NavBtn = Instance.new('TextButton', NavHolder)
    NavBtn.Size = UDim2.new(1, 0, 0, 28)
    NavBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
    NavBtn.BackgroundTransparency = 1
    NavBtn.Text = '     ' .. tabName
    NavBtn.Font = Enum.Font.GothamBold
    NavBtn.TextSize = 11
    NavBtn.TextColor3 = Color3.fromRGB(160, 160, 185)
    NavBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', NavBtn).CornerRadius = UDim.new(0, 7)

    local ActiveBar = Instance.new('Frame', NavBtn)
    ActiveBar.Size = UDim2.new(0, 3, 0, 15)
    ActiveBar.Position = UDim2.new(0, 0, 0.5, -7)
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    Instance.new('UICorner', ActiveBar).CornerRadius = UDim.new(1, 0)
    RegisterAccent(ActiveBar, 'BackgroundColor3')

    NavBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(NavButtons) do
            b.Btn.BackgroundTransparency = 1
            b.Btn.TextColor3 = Color3.fromRGB(160, 160, 185)
            b.Bar.Visible = false
        end
        Page.Visible = true
        NavBtn.BackgroundTransparency = 0.15
        NavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveBar.Visible = true
    end)

    table.insert(Pages, Page)
    table.insert(NavButtons, {Btn = NavBtn, Bar = ActiveBar})
    return Scroll, NavBtn, ActiveBar
end

local function AddSectionLabel(parent, text)
    local Holder = Instance.new('Frame', parent)
    Holder.Size = UDim2.new(1, -6, 0, 18)
    Holder.BackgroundTransparency = 1

    local Bar = Instance.new('Frame', Holder)
    Bar.Size = UDim2.new(0, 3, 0, 12)
    Bar.Position = UDim2.new(0, 0, 0.5, -6)
    Instance.new('UICorner', Bar).CornerRadius = UDim.new(1, 0)
    RegisterAccent(Bar, 'BackgroundColor3')

    local Lbl = Instance.new('TextLabel', Holder)
    Lbl.Size = UDim2.new(1, -12, 1, 0)
    Lbl.Position = UDim2.new(0, 8, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text:upper()
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 10
    Lbl.TextColor3 = Color3.fromRGB(175, 175, 200)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddToggle(parent, title, subtext, defaultVal, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -6, 0, 38)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Card.BackgroundTransparency = 0.15
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 8)
    local Strk = Instance.new('UIStroke', Card)
    Strk.Color = Color3.fromRGB(42, 42, 64)
    Strk.Thickness = 1

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -65, 0, 16)
    TitleLbl.Position = UDim2.new(0, 10, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 11
    TitleLbl.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SubLbl = Instance.new('TextLabel', Card)
    SubLbl.Size = UDim2.new(1, -65, 0, 14)
    SubLbl.Position = UDim2.new(0, 10, 0, 20)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = subtext
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextSize = 9
    SubLbl.TextColor3 = Color3.fromRGB(145, 145, 170)
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new('TextButton', Card)
    SwitchBg.Size = UDim2.new(0, 36, 0, 18)
    SwitchBg.Position = UDim2.new(1, -46, 0.5, -9)
    SwitchBg.Text = ''
    SwitchBg.BackgroundColor3 = defaultVal and NyXConfig.UIAccentColor or Color3.fromRGB(45, 45, 65)
    Instance.new('UICorner', SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new('Frame', SwitchBg)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = defaultVal and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new('UICorner', Knob).CornerRadius = UDim.new(1, 0)

    local state = defaultVal
    SwitchBg.MouseButton1Click:Connect(function()
        state = not state
        SwitchBg.BackgroundColor3 = state and NyXConfig.UIAccentColor or Color3.fromRGB(45, 45, 65)
        Knob.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        if callback then callback(state) end
    end)
end

local function AddInput(parent, title, defaultText, placeholder, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -6, 0, 48)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Card.BackgroundTransparency = 0.15
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', Card).Color = Color3.fromRGB(42, 42, 64)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -20, 0, 14)
    TitleLbl.Position = UDim2.new(0, 10, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new('TextBox', Card)
    Box.Size = UDim2.new(1, -20, 0, 22)
    Box.Position = UDim2.new(0, 10, 0, 21)
    Box.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
    Box.Text = defaultText or ''
    Box.PlaceholderText = placeholder or ''
    Box.TextColor3 = Color3.fromRGB(240, 240, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 135)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 10
    Box.ClearTextOnFocus = false
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new('UICorner', Box).CornerRadius = UDim.new(0, 5)
    Instance.new('UIStroke', Box).Color = Color3.fromRGB(50, 50, 75)

    Box.FocusLost:Connect(function()
        if callback then callback(Box.Text) end
    end)
    Box:GetPropertyChangedSignal('Text'):Connect(function()
        if callback then callback(Box.Text) end
    end)
    return Box
end

local function AddButton(parent, title, callback)
    local Btn = Instance.new('TextButton', parent)
    Btn.Size = UDim2.new(1, -6, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 24, 42)
    Btn.Text = title
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    Instance.new('UICorner', Btn).CornerRadius = UDim.new(0, 7)
    local Strk = Instance.new('UIStroke', Btn)
    Strk.Thickness = 1.1
    Strk.Transparency = 0.35
    RegisterAccent(Strk, 'Color')

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function AddSlider(parent, title, minVal, maxVal, defaultVal, suffix, callback)
    local Card = Instance.new('Frame', parent)
    Card.Size = UDim2.new(1, -6, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Card.BackgroundTransparency = 0.15
    Instance.new('UICorner', Card).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', Card).Color = Color3.fromRGB(42, 42, 64)

    local TitleLbl = Instance.new('TextLabel', Card)
    TitleLbl.Size = UDim2.new(1, -20, 0, 16)
    TitleLbl.Position = UDim2.new(0, 10, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title .. ': ' .. tostring(defaultVal) .. (suffix or '')
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextColor3 = Color3.fromRGB(235, 235, 250)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local BarBg = Instance.new('TextButton', Card)
    BarBg.Size = UDim2.new(1, -20, 0, 8)
    BarBg.Position = UDim2.new(0, 10, 0, 26)
    BarBg.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
    BarBg.Text = ''
    Instance.new('UICorner', BarBg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new('Frame', BarBg)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Instance.new('UICorner', Fill).CornerRadius = UDim.new(1, 0)
    RegisterAccent(Fill, 'BackgroundColor3')

    local sliding = false
    local function UpdateFromInput(input)
        local rel = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        TitleLbl.Text = title .. ': ' .. tostring(val) .. (suffix or '')
        if callback then callback(val) end
    end

    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateFromInput(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

-- ==========================================
-- // BUILD THE 6 TABS (HOME, MAIN, MERCHANT, CONNECTIONS, PINGS, SETTING)
-- ==========================================
local HomeScroll, HomeNavBtn, HomeNavBar = CreateTabPage('Home', 'Dashboard, live status & macro overview.')
local MainScroll = CreateTabPage('Main', 'Biome detector, inventory automation & ground item collector.')
local MerchantScroll = CreateTabPage('Merchant', '3-Min Merchant lifecycle, river-safe pathfinding & auto-respawn.')
local ConnScroll = CreateTabPage('Connections', 'Discord Webhook URL, User ID & Private Server config.')
local PingsScroll = CreateTabPage('Pings', 'Select which of the 16 Biomes & 3 Merchants ping your User ID.')
local SettingScroll = CreateTabPage('Setting', 'UI Scale, OLED Black Screen, Anti-AFK & server tools.')

Pages[1].Visible = true
HomeNavBtn.BackgroundTransparency = 0.15
HomeNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeNavBar.Visible = true

-- // TAB 1: HOME
local WelcomeCard = Instance.new('Frame', HomeScroll)
WelcomeCard.Size = UDim2.new(1, -6, 0, 54)
WelcomeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
WelcomeCard.BackgroundTransparency = 0.12
Instance.new('UICorner', WelcomeCard).CornerRadius = UDim.new(0, 10)
Instance.new('UIStroke', WelcomeCard).Color = Color3.fromRGB(45, 45, 68)

local WBackLbl = Instance.new('TextLabel', WelcomeCard)
WBackLbl.Size = UDim2.new(0, 180, 0, 14)
WBackLbl.Position = UDim2.new(0, 14, 0, 8)
WBackLbl.BackgroundTransparency = 1
WBackLbl.Text = 'Welcome back,'
WBackLbl.Font = Enum.Font.Gotham
WBackLbl.TextSize = 10
WBackLbl.TextColor3 = Color3.fromRGB(165, 165, 190)
WBackLbl.TextXAlignment = Enum.TextXAlignment.Left

local WUserLbl = Instance.new('TextLabel', WelcomeCard)
WUserLbl.Size = UDim2.new(0, 200, 0, 22)
WUserLbl.Position = UDim2.new(0, 14, 0, 24)
WUserLbl.BackgroundTransparency = 1
WUserLbl.Text = LocalPlayer.DisplayName:upper()
WUserLbl.Font = Enum.Font.GothamBlack
WUserLbl.TextSize = 16
WUserLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
WUserLbl.TextXAlignment = Enum.TextXAlignment.Left

local MacroBadge = Instance.new('Frame', WelcomeCard)
MacroBadge.Size = UDim2.new(0, 76, 0, 22)
MacroBadge.Position = UDim2.new(1, -88, 0.5, -11)
MacroBadge.BackgroundColor3 = Color3.fromRGB(24, 22, 42)
Instance.new('UICorner', MacroBadge).CornerRadius = UDim.new(1, 0)
local BadgeStroke = Instance.new('UIStroke', MacroBadge)
BadgeStroke.Thickness = 1.1
RegisterAccent(BadgeStroke, 'Color')

local BadgeTxt = Instance.new('TextLabel', MacroBadge)
BadgeTxt.Size = UDim2.new(1, 0, 1, 0)
BadgeTxt.BackgroundTransparency = 1
BadgeTxt.Text = 'MACRO'
BadgeTxt.Font = Enum.Font.GothamBold
BadgeTxt.TextSize = 9
RegisterAccent(BadgeTxt, 'TextColor3')

AddSectionLabel(HomeScroll, 'LIVE STATUS')

local StatusRow = Instance.new('Frame', HomeScroll)
StatusRow.Size = UDim2.new(1, -6, 0, 56)
StatusRow.BackgroundTransparency = 1

local UptimeCard = Instance.new('Frame', StatusRow)
UptimeCard.Size = UDim2.new(0.485, 0, 1, 0)
UptimeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
UptimeCard.BackgroundTransparency = 0.12
Instance.new('UICorner', UptimeCard).CornerRadius = UDim.new(0, 10)
local UpStroke = Instance.new('UIStroke', UptimeCard)
UpStroke.Thickness = 1.1
UpStroke.Transparency = 0.35
RegisterAccent(UpStroke, 'Color')

local UpTitle = Instance.new('TextLabel', UptimeCard)
UpTitle.Size = UDim2.new(1, -20, 0, 14)
UpTitle.Position = UDim2.new(0, 12, 0, 8)
UpTitle.BackgroundTransparency = 1
UpTitle.Text = 'Uptime'
UpTitle.Font = Enum.Font.Gotham
UpTitle.TextSize = 10
UpTitle.TextColor3 = Color3.fromRGB(160, 160, 185)
UpTitle.TextXAlignment = Enum.TextXAlignment.Left

local UptimeValueLabel = Instance.new('TextLabel', UptimeCard)
UptimeValueLabel.Size = UDim2.new(1, -20, 0, 22)
UptimeValueLabel.Position = UDim2.new(0, 12, 0, 24)
UptimeValueLabel.BackgroundTransparency = 1
UptimeValueLabel.Text = '00:00:00'
UptimeValueLabel.Font = Enum.Font.GothamBlack
UptimeValueLabel.TextSize = 16
UptimeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(UptimeValueLabel, 'TextColor3')

local BiomeCard = Instance.new('Frame', StatusRow)
BiomeCard.Size = UDim2.new(0.485, 0, 1, 0)
BiomeCard.Position = UDim2.new(0.515, 0, 0, 0)
BiomeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
BiomeCard.BackgroundTransparency = 0.12
Instance.new('UICorner', BiomeCard).CornerRadius = UDim.new(0, 10)
Instance.new('UIStroke', BiomeCard).Color = Color3.fromRGB(45, 45, 68)

local BmTitle = Instance.new('TextLabel', BiomeCard)
BmTitle.Size = UDim2.new(1, -20, 0, 14)
BmTitle.Position = UDim2.new(0, 12, 0, 8)
BmTitle.BackgroundTransparency = 1
BmTitle.Text = 'Current Biome'
BmTitle.Font = Enum.Font.Gotham
BmTitle.TextSize = 10
BmTitle.TextColor3 = Color3.fromRGB(160, 160, 185)
BmTitle.TextXAlignment = Enum.TextXAlignment.Left

local BiomeValueLabel = Instance.new('TextLabel', BiomeCard)
BiomeValueLabel.Size = UDim2.new(1, -20, 0, 22)
BiomeValueLabel.Position = UDim2.new(0, 12, 0, 24)
BiomeValueLabel.BackgroundTransparency = 1
BiomeValueLabel.Text = 'NORMAL'
BiomeValueLabel.Font = Enum.Font.GothamBlack
BiomeValueLabel.TextSize = 14
BiomeValueLabel.TextColor3 = Color3.fromRGB(80, 250, 123)
BiomeValueLabel.TextXAlignment = Enum.TextXAlignment.Left

local MerchantStatusCard = Instance.new('Frame', HomeScroll)
MerchantStatusCard.Size = UDim2.new(1, -6, 0, 42)
MerchantStatusCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
MerchantStatusCard.BackgroundTransparency = 0.12
Instance.new('UICorner', MerchantStatusCard).CornerRadius = UDim.new(0, 10)
Instance.new('UIStroke', MerchantStatusCard).Color = Color3.fromRGB(45, 45, 68)

local MerTitle = Instance.new('TextLabel', MerchantStatusCard)
MerTitle.Size = UDim2.new(0.55, 0, 1, 0)
MerTitle.Position = UDim2.new(0, 12, 0, 0)
MerTitle.BackgroundTransparency = 1
MerTitle.Text = 'Active Merchant (3m Timer):'
MerTitle.Font = Enum.Font.GothamBold
MerTitle.TextSize = 11
MerTitle.TextColor3 = Color3.fromRGB(185, 185, 210)
MerTitle.TextXAlignment = Enum.TextXAlignment.Left

local MerchantValueLabel = Instance.new('TextLabel', MerchantStatusCard)
MerchantValueLabel.Size = UDim2.new(0.4, -12, 1, 0)
MerchantValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
MerchantValueLabel.BackgroundTransparency = 1
MerchantValueLabel.Text = 'NONE'
MerchantValueLabel.Font = Enum.Font.GothamBlack
MerchantValueLabel.TextSize = 12
MerchantValueLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
MerchantValueLabel.TextXAlignment = Enum.TextXAlignment.Right

-- // TAB 2: MAIN
AddSectionLabel(MainScroll, 'Biome Detector & Ground Collector')

AddToggle(MainScroll, 'Start Biome & State Detector', 'Sends Macro Started/Stopped and accurate Biome embeds.', false, function(val)
    if val then
        NyXConfig.EnableBiomeWebhook = true
        MacroStartTime = os.time()
        SendMacroStateEmbed(true)
        Notify('NyX Detector Macro', 'Macro Started!', 2.5)
    else
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        NyXConfig.EnableBiomeWebhook = false
        SendMacroStateEmbed(false, finalElapsed)
        MacroStartTime = 0
        UptimeValueLabel.Text = '00:00:00'
        Notify('NyX Detector Macro', 'Macro Stopped!', 2.5)
    end
end)

AddToggle(MainScroll, 'Auto Collect Natural Ground Items', 'Safely walks to nearby potions & coins on the ground.', false, function(val)
    NyXConfig.AutoCollectItems = val
end)

AddSectionLabel(MainScroll, 'Inventory Automation')

AddButton(MainScroll, 'Use Now: Biome Randomizer', function()
    task.spawn(function() UseItemWithInventoryFailsafe('Biome Randomizer') end)
end)

AddButton(MainScroll, 'Use Now: Strange Controller', function()
    task.spawn(function() UseItemWithInventoryFailsafe('Strange Controller') end)
end)

AddSlider(MainScroll, 'Item Use Interval', 5, 300, 20, 's', function(val)
    NyXConfig.UseInterval = val
end)

AddToggle(MainScroll, 'Auto Biome Randomizer', 'Automatically opens inventory and uses Biome Randomizer.', false, function(val)
    NyXConfig.AutoBiomeRandomizer = val
end)

AddToggle(MainScroll, 'Auto Strange Controller', 'Automatically opens inventory and uses Strange Controller.', false, function(val)
    NyXConfig.AutoStrangeController = val
end)

AddSectionLabel(MainScroll, 'Stop Auto In (Pause Randomizer on Target Biomes)')

local StopGridFrame = Instance.new('Frame', MainScroll)
StopGridFrame.Name = 'StopFilterContainer'
StopGridFrame.Size = UDim2.new(1, -6, 0, 118)
StopGridFrame.BackgroundTransparency = 1
local GridLayout = Instance.new('UIGridLayout', StopGridFrame)
GridLayout.CellSize = UDim2.new(0.24, -4, 0, 24)
GridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All16Biomes) do
    local Chip = Instance.new('TextButton', StopGridFrame)
    local isOn = NyXConfig.StopAutoBiomes[bName] == true
    Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 8
    Chip.TextColor3 = Color3.fromRGB(245, 245, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

    Chip.MouseButton1Click:Connect(function()
        NyXConfig.StopAutoBiomes[bName] = not NyXConfig.StopAutoBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.StopAutoBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
    end)
end

-- // TAB 3: MERCHANT (DEDICATED CATEGORY)
AddSectionLabel(MerchantScroll, 'Merchant Lifecycle & 3-Min Timer')

local MerchantLiveCard = Instance.new('Frame', MerchantScroll)
MerchantLiveCard.Size = UDim2.new(1, -6, 0, 46)
MerchantLiveCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
MerchantLiveCard.BackgroundTransparency = 0.12
Instance.new('UICorner', MerchantLiveCard).CornerRadius = UDim.new(0, 8)
Instance.new('UIStroke', MerchantLiveCard).Color = Color3.fromRGB(45, 45, 68)

local MTabStatusLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabStatusLbl.Size = UDim2.new(1, -20, 0, 18)
MTabStatusLbl.Position = UDim2.new(0, 10, 0, 5)
MTabStatusLbl.BackgroundTransparency = 1
MTabStatusLbl.Text = 'Status: NONE (Waiting for Spawn)'
MTabStatusLbl.Font = Enum.Font.GothamBold
MTabStatusLbl.TextSize = 11
MTabStatusLbl.TextColor3 = Color3.fromRGB(240, 240, 255)
MTabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local MTabCoordsLbl = Instance.new('TextLabel', MerchantLiveCard)
MTabCoordsLbl.Size = UDim2.new(1, -20, 0, 16)
MTabCoordsLbl.Position = UDim2.new(0, 10, 0, 24)
MTabCoordsLbl.BackgroundTransparency = 1
MTabCoordsLbl.Text = 'XYZ Coordinates: N/A'
MTabCoordsLbl.Font = Enum.Font.Gotham
MTabCoordsLbl.TextSize = 10
MTabCoordsLbl.TextColor3 = Color3.fromRGB(160, 160, 190)
MTabCoordsLbl.TextXAlignment = Enum.TextXAlignment.Left

AddToggle(MerchantScroll, 'Enable Merchant Detector (Arrived + 3m Left)', 'Detects Mari, Jester & Rin arrival and automatically logs has left after 3 minutes.', false, function(val)
    NyXConfig.EnableMerchantWebhook = val
end)

AddSectionLabel(MerchantScroll, 'Anti-Ban Pathfinding & Respawn')

AddToggle(MerchantScroll, 'Auto Pathfind Walk to Merchant (Avoid Rivers)', 'Reads merchant XYZ and walks safely along bridges/ground instead of teleporting.', false, function(val)
    NyXConfig.AutoWalkToMerchant = val
end)

AddToggle(MerchantScroll, 'Auto Open Merchant Shop on Arrival', 'Automatically triggers the merchant ProximityPrompt once you reach them.', false, function(val)
    NyXConfig.AutoInteractMerchant = val
end)

AddToggle(MerchantScroll, 'Respawn if Merchant Left', 'Automatically resets/respawns your character when the 3-minute merchant leaves.', false, function(val)
    NyXConfig.RespawnIfMerchantLeft = val
end)

AddButton(MerchantScroll, 'Walk Safely to Active Merchant Now', function()
    WalkToActiveMerchantNow()
end)

-- // TAB 4: CONNECTIONS
AddSectionLabel(ConnScroll, 'Discord Webhook & Server Link')

AddInput(ConnScroll, 'Webhook URL', NyXConfig.WebhookURL, 'https://discord.com/api/webhooks/...', function(txt)
    NyXConfig.WebhookURL = txt:gsub('%s+', '')
end)

local ConnUserIDBox = AddInput(ConnScroll, 'Discord User ID (Required for Pings)', NyXConfig.DiscordID, 'Ex: 123456789012345678', function(txt)
    NyXConfig.DiscordID = txt:gsub('%D+', '')
end)

AddInput(ConnScroll, 'Private Server Link', NyXConfig.PrivateServerLink, 'https://www.roblox.com/games/...', function(txt)
    NyXConfig.PrivateServerLink = txt
end)

AddButton(ConnScroll, 'Save Webhook & Ping Config', function()
    SaveWebhookConfig()
    Notify('Config Saved', 'Webhook, User ID, Private Server & Ping rules saved!', 3)
end)

AddButton(ConnScroll, 'Test Webhook Connection', function()
    SendTestWebhookEmbed(false)
    Notify('Webhook Test', 'Sent Webhook Test - Successfully to Discord!', 3)
end)

-- // TAB 5: PINGS (16 BIOMES + 3 MERCHANTS + MANDATORY USER ID CHECK)
AddSectionLabel(PingsScroll, 'Mandatory Discord User ID for Pings')

local PingUserIDBox = AddInput(PingsScroll, 'Your Discord User ID (Must Enter to Enable Pings)', NyXConfig.DiscordID, 'Enter your numeric Discord User ID here...', function(txt)
    local clean = txt:gsub('%D+', '')
    NyXConfig.DiscordID = clean
    if ConnUserIDBox and ConnUserIDBox.Text ~= clean then
        ConnUserIDBox.Text = clean
    end
end)

AddButton(PingsScroll, 'Test Ping With User ID Now', function()
    local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
    if cleanID == '' then
        Notify('User ID Required!', 'Please enter your numeric Discord User ID above before testing pings!', 4)
        return
    end
    SendTestWebhookEmbed(true)
    Notify('Ping Sent!', 'Sent test ping to <@' .. cleanID .. '> on Discord!', 3)
end)

AddSectionLabel(PingsScroll, 'Which Biomes Should Ping You? (16 Biomes)')

local PingBiomeGrid = Instance.new('Frame', PingsScroll)
PingBiomeGrid.Name = 'PingBiomeContainer'
PingBiomeGrid.Size = UDim2.new(1, -6, 0, 118)
PingBiomeGrid.BackgroundTransparency = 1
local PGridLayout = Instance.new('UIGridLayout', PingBiomeGrid)
PGridLayout.CellSize = UDim2.new(0.24, -4, 0, 24)
PGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for _, bName in ipairs(All16Biomes) do
    local Chip = Instance.new('TextButton', PingBiomeGrid)
    local isOn = NyXConfig.PingBiomes[bName] == true
    Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
    Chip.Text = bName
    Chip.Font = Enum.Font.GothamBold
    Chip.TextSize = 8
    Chip.TextColor3 = Color3.fromRGB(245, 245, 255)
    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 5)

    Chip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingBiomes[bName] and cleanID == '' then
            Notify('Discord User ID Required!', 'You must enter your Discord User ID above before selecting biomes to ping!', 4)
            return
        end
        NyXConfig.PingBiomes[bName] = not NyXConfig.PingBiomes[bName]
        Chip.BackgroundColor3 = NyXConfig.PingBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
        SaveWebhookConfig()
    end)
end

AddSectionLabel(PingsScroll, 'Which Merchants Should Ping You? (Mari / Jester / Rin)')

local PingMerchantRow = Instance.new('Frame', PingsScroll)
PingMerchantRow.Name = 'PingMerchantContainer'
PingMerchantRow.Size = UDim2.new(1, -6, 0, 32)
PingMerchantRow.BackgroundTransparency = 1
local MGridLayout = Instance.new('UIGridLayout', PingMerchantRow)
MGridLayout.CellSize = UDim2.new(0.32, -4, 0, 28)
MGridLayout.CellPadding = UDim2.new(0, 6, 0, 0)

for _, mName in ipairs(All3Merchants) do
    local MChip = Instance.new('TextButton', PingMerchantRow)
    local isOn = NyXConfig.PingMerchants[mName] == true
    MChip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
    MChip.Text = mName:upper()
    MChip.Font = Enum.Font.GothamBold
    MChip.TextSize = 10
    MChip.TextColor3 = Color3.fromRGB(245, 245, 255)
    Instance.new('UICorner', MChip).CornerRadius = UDim.new(0, 6)

    MChip.MouseButton1Click:Connect(function()
        local cleanID = tostring(NyXConfig.DiscordID or ''):gsub('%D+', '')
        if not NyXConfig.PingMerchants[mName] and cleanID == '' then
            Notify('Discord User ID Required!', 'You must enter your Discord User ID above before enabling Merchant pings!', 4)
            return
        end
        NyXConfig.PingMerchants[mName] = not NyXConfig.PingMerchants[mName]
        MChip.BackgroundColor3 = NyXConfig.PingMerchants[mName] and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
        SaveWebhookConfig()
    end)
end

-- // TAB 6: SETTING
AddSectionLabel(SettingScroll, 'Android Screen & UI Customization')

AddSlider(SettingScroll, 'UI Scale (Resize for Mobile Screen)', 55, 125, 95, '%', function(val)
    NyXConfig.UIScalePercent = val
    RecalculateResponsiveScale()
end)

local ColorRow = Instance.new('Frame', SettingScroll)
ColorRow.Size = UDim2.new(1, -6, 0, 28)
ColorRow.BackgroundTransparency = 1
local ColorGrid = Instance.new('UIGridLayout', ColorRow)
ColorGrid.CellSize = UDim2.new(0.2, -4, 0, 26)
ColorGrid.CellPadding = UDim2.new(0, 4, 0, 0)

local ThemePresets = {
    {Name = 'Purple', Col = Color3.fromRGB(135, 95, 255)},
    {Name = 'Cyan', Col = Color3.fromRGB(0, 210, 255)},
    {Name = 'Crimson', Col = Color3.fromRGB(255, 65, 90)},
    {Name = 'Emerald', Col = Color3.fromRGB(46, 213, 115)},
    {Name = 'Gold', Col = Color3.fromRGB(255, 175, 45)}
}

for _, preset in ipairs(ThemePresets) do
    local CBtn = Instance.new('TextButton', ColorRow)
    CBtn.BackgroundColor3 = preset.Col
    CBtn.Text = preset.Name
    CBtn.Font = Enum.Font.GothamBold
    CBtn.TextSize = 9
    CBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new('UICorner', CBtn).CornerRadius = UDim.new(0, 6)
    CBtn.MouseButton1Click:Connect(function()
        UpdateAccentColor(preset.Col)
    end)
end

AddSlider(SettingScroll, 'Window Transparency', 0, 65, 8, '%', function(val)
    NyXConfig.GlassTransparency = val / 100
    MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
end)

AddSectionLabel(SettingScroll, 'Battery Saver, Performance & AFK')

AddToggle(SettingScroll, 'OLED Black Screen Battery Saver', 'Covers the screen in pure black while keeping NyX UI & ND button accessible.', false, function(val)
    NyXConfig.BlackScreenSaver = val
    BlackSaverFrame.Visible = val
end)

AddToggle(SettingScroll, 'Enable Anti-AFK', 'Prevents 20-minute idle disconnect.', true, function(val)
    NyXConfig.AntiAFK = val
end)

AddToggle(SettingScroll, 'Auto Reconnect on Disconnect / Kick', 'Automatically rejoins the server if your connection drops.', true, function(val)
    NyXConfig.AutoReconnect = val
end)

AddToggle(SettingScroll, 'Disable 3D Rendering (CPU / GPU Saver)', 'Turns off 3D world rendering for low-resource AFK macroing.', false, function(val)
    NyXConfig.Disable3DRendering = val
    pcall(function() RunService:Set3dRenderingEnabled(not val) end)
end)

AddButton(SettingScroll, 'Boost FPS (Remove Particles & Shadows)', function()
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
    Notify('FPS Boost', 'Particles disabled and textures optimized!', 3)
end)

AddSlider(SettingScroll, 'FPS Cap', 15, 240, 60, ' FPS', function(val)
    if setfpscap then pcall(setfpscap, val) end
end)

AddSectionLabel(SettingScroll, 'Server & Script Management')

AddButton(SettingScroll, 'Rejoin Current Server', function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

AddButton(SettingScroll, 'Uninstall / Destroy NyX Detector Macro', function()
    ScriptRunning = false
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    if NyXConfig.EnableBiomeWebhook then
        local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
        SendMacroStateEmbed(false, finalElapsed)
    end
    if IdledConn then IdledConn:Disconnect() end
    if ScreenGui then ScreenGui:Destroy() end
end)

-- ==========================================
-- // BACKGROUND LOOPS (BIOME, 3-MIN MERCHANT LIFECYCLE, ITEMS)
-- ==========================================

-- 1. Biome Detection Loop (With 2-Tick Verification Debounce)
task.spawn(function()
    local confirmedBiome = GetAccurateServerBiome()
    local pendingBiome = confirmedBiome
    local pendingCount = 0

    NyXConfig.CurrentDetectedBiome = confirmedBiome
    BiomeValueLabel.Text = confirmedBiome

    while ScriptRunning and task.wait(1) do
        local rawDetected = GetAccurateServerBiome()
        UptimeValueLabel.Text = GetMacroUptime()

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
                Notify('Stop Auto In', 'Detected ' .. confirmedBiome .. '! Pausing item usage.', 4)
            end
        end
    end
end)

-- 2. Merchant Lifecycle Loop (Strict Physical Model Verification + 3-Minute Countdown -> Merchant Left = NONE)
task.spawn(function()
    while ScriptRunning and task.wait(1) do
        local worldMerchant, worldPos = FindMerchantWorldPosition()

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

-- 3. Auto Collect Natural Ground Items Loop (Potions / Coins via River-Safe Walk)
task.spawn(function()
    while ScriptRunning and task.wait(2.5) do
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
                            end)
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
    while ScriptRunning do
        task.wait(1)
        if NyXConfig.AutoBiomeRandomizer or NyXConfig.AutoStrangeController then
            local currentB = NyXConfig.CurrentDetectedBiome
            local shouldStop = NyXConfig.StopAutoBiomes[currentB] == true

            if not shouldStop then
                if NyXConfig.AutoBiomeRandomizer then
                    UseItemWithInventoryFailsafe('Biome Randomizer')
                    task.wait(1)
                end
                if NyXConfig.AutoStrangeController and not NyXConfig.StopAutoBiomes[GetAccurateServerBiome()] then
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
