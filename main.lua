-- // NyX DETECTOR - SOLS RNG MACRO (SIRIUS RAYFIELD EDITION - FINAL FIXED)
-- // Features: Working ND Button + Liquid Glass & Color Picker + Clean Plain-Text Embeds + 3 Merchants (Mari, Jester, Rin)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // System Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local ScriptRunning = true
local MacroStartTime = 0

-- // 16 Standard Biomes Data
local BiomeData = {
    ["NORMAL"] = {Color = 0xAAAAAA, Type = "None", Image = "https://static.wikia.nocookie.net/sol-rng/images/0/07/DISCORICH-NORMAL.png/revision/latest/scale-to-width-down/250?cb=20260823042008"},
    ["WINDY"] = {Color = 0x55FFFF, Type = "Normal", Image = "https://static.wikia.nocookie.net/sol-rng/images/0/07/DISCORICH-NORMAL.png/revision/latest/scale-to-width-down/250?cb=20260823042008"},
    ["SNOWY"] = {Color = 0xAAFFFF, Type = "Normal", Image = "https://static.wikia.nocookie.net/sol-rng/images/8/86/DISCORICH-SNOWY.png/revision/latest/scale-to-width-down/250?cb=20260823041153"},
    ["RAINY"] = {Color = 0x4477FF, Type = "Normal", Image = "https://static.wikia.nocookie.net/sol-rng/images/7/77/DISCORICH-RAINY.png/revision/latest/scale-to-width-down/250?cb=20260823042833"},
    ["SANDSTORM"] = {Color = 0xCC9955, Type = "Normal", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHyGYg2pr47DNuAlzWPvO8GvfI4Q-10h4EEqne__0LCA&s"},
    ["HELL"] = {Color = 0xFF3300, Type = "Normal", Image = "https://static.wikia.nocookie.net/sol-rng/images/b/b9/DISCORICH-HELL.png/revision/latest/scale-to-width-down/250?cb=20260823044812"},
    ["STARFALL"] = {Color = 0x2266FF, Type = "Normal", Image = "https://static.wikia.nocookie.net/sol-rng/images/1/11/DISCORICH-STARFALL.png/revision/latest/scale-to-width-down/250?cb=20260823041135"},
    ["HEAVEN"] = {Color = 0xFFEEAA, Type = "Normal", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA7MvgAC3DxYVI4jt4DQ8YUvNRgHnLhtYIOJjnhvLJGUMhYvd4wtctOZ0l&s=10"},
    ["LOST FOREST"] = {Color = 0x33FF33, Type = "Normal", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7cTBAkzKDZO8sb9wAPHDpuVwRyWhAuHfEUkqEzH3CLw&s"},
    ["CORRUPTION"] = {Color = 0x8833FF, Type = "Normal", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHLaYqUpmoLGJiST12FRbfmlWzorC4J4LVUBFSxKG9TA&s"},
    ["NULL"] = {Color = 0x777777, Type = "Normal", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXSoTVgOGdurb913lQNnreYlm68Nd1zthlDWnt-uzl0qY5QcvV7FZDZ8o&s=10"},
    ["GLITCHED"] = {Color = 0x228855, Type = "Everyone", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRZDgmOTmOuKCus91vLwkxmxVdYN9ZmO55GJwEW9Mk9A&s=10"},
    ["DREAMSPACE"] = {Color = 0xFF66CC, Type = "Everyone", Image = "https://i1.sndcdn.com/artworks-4REvzocas0Xf3WZQ-wlFSVw-t500x500.jpg"},
    ["CYBERSPACE"] = {Color = 0x2255AA, Type = "Everyone", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWnzl06DTg0F8rYnpLbHJhIj3pV58GaRfJLrkwCWhTAYa1GOyhlzflCj_M&s=10"},
    ["SINGULARITY"] = {Color = 0xFF9955, Type = "Rare", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9sl4YUs1-pBY2SJgepOHHrBAxjha7AP2_fxjx0eJ_ag&s"},
    ["THE RADIANT FOREST"] = {Color = 0xCC33FF, Type = "Rare", Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZxdhkfNNq7PMavKT9srm09DU-sH6DueoDYk9Hw1wPStkUylWMsx126nY&s=10"}
}

-- // Merchant Data (Mari, Jester, Rin)
local MerchantData = {
    ["Mari"] = {Color = 0x2ECC71, Ping = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["Jester"] = {Color = 0x9B59B6, Ping = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["Rin"] = {Color = 0x3498DB, Ping = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"}
}

local BiomeScanPriority = {
    "THE RADIANT FOREST", "LOST FOREST", "DREAMSPACE", "CYBERSPACE", "SINGULARITY",
    "CORRUPTION", "SANDSTORM", "STARFALL", "GLITCHED", "HEAVEN",
    "WINDY", "SNOWY", "RAINY", "HELL", "NULL", "NORMAL"
}

local All16Biomes = {
    "NORMAL", "WINDY", "SNOWY", "RAINY", "SANDSTORM", "HELL", 
    "STARFALL", "HEAVEN", "LOST FOREST", "CORRUPTION", "NULL", 
    "GLITCHED", "DREAMSPACE", "CYBERSPACE", "SINGULARITY", "THE RADIANT FOREST"
}

-- // Configuration Table
local NyXConfig = {
    WebhookURL = "",
    DiscordID = "",
    PrivateServerLink = "",
    EnableBiomeWebhook = false,
    EnableMerchantWebhook = false,
    AutoBiomeRandomizer = false,
    AutoStrangeController = false,
    UseInterval = 20,
    StopAutoBiomes = {
        ["GLITCHED"] = true,
        ["DREAMSPACE"] = true,
        ["CYBERSPACE"] = true
    },
    CurrentDetectedBiome = "NORMAL",
    LiquidGlassMenu = true,
    MenuTransparency = 0.25,
    UIAccentColor = Color3.fromRGB(175, 120, 255),
    UIBackgroundColor = Color3.fromRGB(18, 18, 28),
    AntiAFK = true
}

-- ==========================================
-- // DEDICATED WEBHOOK CONFIG SAVE / LOAD
-- ==========================================
local WebhookConfigFile = "NyX_WebhookConfig.json"

local function SaveWebhookConfig()
    if writefile then
        pcall(function()
            local data = {
                WebhookURL = NyXConfig.WebhookURL,
                DiscordID = NyXConfig.DiscordID,
                PrivateServerLink = NyXConfig.PrivateServerLink
            }
            writefile(WebhookConfigFile, HttpService:JSONEncode(data))
        end)
    end
end

local function LoadWebhookConfig()
    if isfile and readfile and isfile(WebhookConfigFile) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(WebhookConfigFile))
            if type(decoded) == "table" then
                NyXConfig.WebhookURL = decoded.WebhookURL or ""
                NyXConfig.DiscordID = decoded.DiscordID or ""
                NyXConfig.PrivateServerLink = decoded.PrivateServerLink or ""
            end
        end)
    end
end

LoadWebhookConfig()

-- // Anti-AFK Connection
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

-- // Format Macro Uptime (HH:MM:SS)
local function GetMacroUptime(forcedElapsed)
    local elapsed = forcedElapsed
    if not elapsed then
        if not NyXConfig.EnableBiomeWebhook or MacroStartTime == 0 then
            return "00:00:00"
        end
        elapsed = math.floor(os.time() - MacroStartTime)
    end
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

-- // Strip RichText / HTML Tags
local function CleanRichText(str)
    if type(str) ~= "string" then return "" end
    local s = str:gsub("<[^>]+>", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    return s
end

-- ==========================================
-- // DISCORD WEBHOOK EMBED SYSTEM (NO EMOJIS)
-- ==========================================
local function SendRawWebhook(payload)
    if NyXConfig.WebhookURL == "" then return end
    local req = (syn and syn.request) or http_request or request
    if req then
        pcall(function()
            req({
                Url = NyXConfig.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end

-- 1. Test Webhook Embed
local function SendTestWebhookEmbed()
    SendRawWebhook({
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Webhook Test - Successfully",
            ["color"] = 0x2ECC71,
            ["footer"] = {["text"] = "Project NyX"}
        }}
    })
end

-- 2. Macro State Embed (Started / Stopped - Clean Plain Text)
local function SendMacroStateEmbed(isStarted, finalElapsed)
    local currentClock = os.date("%H:%M:%S")
    if isStarted then
        SendRawWebhook({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "Macro Started",
                ["description"] = "**NyX Detector** has started monitoring Biomes and Merchants.\n**Macro Uptime :** `00:00:00`",
                ["color"] = 0x00FF88,
                ["footer"] = {["text"] = "NyX Detector | " .. currentClock}
            }}
        })
    else
        local uptimeStr = GetMacroUptime(finalElapsed or 0)
        SendRawWebhook({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "Macro Stopped",
                ["description"] = "**NyX Detector** has been stopped.\n**Total Uptime :** `" .. uptimeStr .. "` *(Reset)*",
                ["color"] = 0xFF3344,
                ["footer"] = {["text"] = "NyX Detector | " .. currentClock}
            }}
        })
    end
end

-- 3. Biome Started Embed (Clean Plain Text)
local function SendBiomeStartedEmbed(biomeName, color, pingType, imageUrl)
    local contentMsg = ""
    if pingType == "Everyone" then
        contentMsg = "@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")
    elseif NyXConfig.DiscordID ~= "" and (pingType == "Rare" or pingType == "UserPing") then
        contentMsg = "<@" .. NyXConfig.DiscordID .. ">"
    end

    local psDisplay = NyXConfig.PrivateServerLink ~= "" and ("[Click to Join Server](" .. NyXConfig.PrivateServerLink .. ")") or "`None`"
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = "Biome Started - " .. biomeName,
            ["description"] = "**Macro Uptime :** `" .. uptimeStr .. "`\n**Private Server :** " .. psDisplay,
            ["color"] = color or 0x9B59B6,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector | " .. currentClock}
        }}
    })
end

-- 4. Biome Ended Embed (Clean Plain Text)
local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Biome Ended - " .. biomeName,
            ["description"] = "**Macro Uptime :** `" .. uptimeStr .. "`",
            ["color"] = color or 0x555555,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector | " .. currentClock}
        }}
    })
end

-- 5. Merchant Arrived Embed ("<Merchant Name> has arrived!" - Clean Plain Text)
local LastMerchantSentTime = {["Mari"] = 0, ["Jester"] = 0, ["Rin"] = 0}

local function TriggerMerchantArrival(merchantName)
    if not NyXConfig.EnableMerchantWebhook then return end
    local now = os.time()
    if LastMerchantSentTime[merchantName] and (now - LastMerchantSentTime[merchantName]) < 90 then
        return
    end
    LastMerchantSentTime[merchantName] = now

    local mInfo = MerchantData[merchantName] or {
        Color = 0xF1C40F,
        Ping = "Everyone",
        Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"
    }

    local contentMsg = ""
    if mInfo.Ping == "Everyone" then
        contentMsg = "@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")
    elseif NyXConfig.DiscordID ~= "" then
        contentMsg = "<@" .. NyXConfig.DiscordID .. ">"
    end

    local psDisplay = NyXConfig.PrivateServerLink ~= "" and ("[Click to Join Server](" .. NyXConfig.PrivateServerLink .. ")") or "`None`"
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = merchantName .. " has arrived!",
            ["description"] = "**Merchant :** `" .. merchantName .. "`\n**Macro Uptime :** `" .. uptimeStr .. "`\n**Private Server :** " .. psDisplay,
            ["color"] = mInfo.Color,
            ["thumbnail"] = {["url"] = mInfo.Image},
            ["footer"] = {["text"] = "NyX Detector | " .. currentClock}
        }}
    })

    Rayfield:Notify({
        Title = "Merchant Detected",
        Content = merchantName .. " has arrived!",
        Duration = 4
    })
end

-- ==========================================
-- // RAYFIELD LIQUID GLASS, COLOR STYLER & "ND" FLOATING BUTTON
-- ==========================================
local NDGui = nil
local GlassConnections = {}

local function FindRayfieldScreenGui()
    local roots = {}
    if gethui then pcall(function() table.insert(roots, gethui()) end) end
    table.insert(roots, CoreGui)
    if LocalPlayer:FindFirstChild("PlayerGui") then
        table.insert(roots, LocalPlayer.PlayerGui)
    end

    for _, root in ipairs(roots) do
        for _, gui in ipairs(root:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "NyXDetectorLogoGui" then
                local mainCheck = gui:FindFirstChild("Main", true)
                if mainCheck and mainCheck:FindFirstChild("Topbar") then
                    return gui, mainCheck
                end
            end
        end
    end
    return nil, nil
end

local function ApplyMenuThemeAndGlass()
    pcall(function()
        local rfGui, mainFrame = FindRayfieldScreenGui()
        if not rfGui or not mainFrame then return end

        local enabled = NyXConfig.LiquidGlassMenu
        local trans = NyXConfig.MenuTransparency
        local bgCol = NyXConfig.UIBackgroundColor
        local accentCol = NyXConfig.UIAccentColor

        -- Hide Rayfield's default mini "Show Rayfield" bar so ND button controls everything
        for _, child in ipairs(rfGui:GetChildren()) do
            if child:IsA("Frame") and child ~= mainFrame and child.Name ~= "Notifications" then
                if child:FindFirstChildWhichIsA("TextButton", true) then
                    child.Visible = false
                end
            end
        end

        local targetMainTrans = enabled and trans or 0
        local targetElemTrans = enabled and math.clamp(trans + 0.15, 0, 0.92) or 0
        local elemColor = Color3.new(
            math.clamp(bgCol.R + 0.04, 0, 1),
            math.clamp(bgCol.G + 0.04, 0, 1),
            math.clamp(bgCol.B + 0.05, 0, 1)
        )

        local function StyleObject(v)
            if v:IsA("Frame") then
                local n = v.Name
                if n == "Main" or n == "Topbar" or n == "Elements" or n == "TabList" then
                    v.BackgroundTransparency = targetMainTrans
                    v.BackgroundColor3 = bgCol
                elseif v.Parent and (v.Parent.Name == "Elements" or v.Parent:IsA("ScrollingFrame")) then
                    v.BackgroundTransparency = targetElemTrans
                    v.BackgroundColor3 = elemColor
                elseif n == "Shadow" or n == "DropShadow" then
                    v.Visible = not enabled
                end
            elseif v:IsA("ScrollingFrame") then
                v.BackgroundTransparency = 1
            elseif v:IsA("UIStroke") then
                v.Color = accentCol
                v.Transparency = enabled and 0.35 or 0
                v.Thickness = 1.2
            end
        end

        for _, v in ipairs(mainFrame:GetDescendants()) do
            StyleObject(v)
            if not GlassConnections[v] and v:IsA("Frame") then
                local n = v.Name
                if n == "Main" or n == "Topbar" or n == "Elements" or n == "TabList" or (v.Parent and v.Parent:IsA("ScrollingFrame")) then
                    GlassConnections[v] = v:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
                        if not NyXConfig.LiquidGlassMenu then return end
                        local desired = (n == "Main" or n == "Topbar" or n == "Elements" or n == "TabList")
                            and NyXConfig.MenuTransparency
                            or math.clamp(NyXConfig.MenuTransparency + 0.15, 0, 0.92)
                        if math.abs(v.BackgroundTransparency - desired) > 0.03 and v.BackgroundTransparency < 0.98 then
                            v.BackgroundTransparency = desired
                        end
                    end)
                end
            end
        end
        StyleObject(mainFrame)
    end)
end

local function ToggleRayfieldMenu()
    pcall(function()
        local rfGui, mainFrame = FindRayfieldScreenGui()
        if rfGui and mainFrame then
            -- Trigger Rayfield's native toggle keybind (RightShift) AND fallback to direct visibility
            local wasVisible = mainFrame.Visible
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
            task.wait(0.08)

            -- Direct fallback if Rayfield didn't process the keybind (e.g., on mobile executors)
            if mainFrame.Visible == wasVisible then
                mainFrame.Visible = not wasVisible
            end
            rfGui.Enabled = true

            -- Hide any "Show Rayfield" prompt bar that Rayfield tries to spawn when minimized
            for _, child in ipairs(rfGui:GetChildren()) do
                if child:IsA("Frame") and child ~= mainFrame and child.Name ~= "Notifications" then
                    child.Visible = false
                end
            end

            if mainFrame.Visible then
                task.defer(ApplyMenuThemeAndGlass)
            end
        end
    end)
end

local function CreateNDLogoButton()
    pcall(function()
        local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
        if parentTarget:FindFirstChild("NyXDetectorLogoGui") then
            parentTarget.NyXDetectorLogoGui:Destroy()
        end

        NDGui = Instance.new("ScreenGui")
        NDGui.Name = "NyXDetectorLogoGui"
        NDGui.ResetOnSpawn = false
        NDGui.IgnoreGuiInset = true
        NDGui.DisplayOrder = 999999
        NDGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NDGui.Parent = parentTarget

        local NDButton = Instance.new("TextButton")
        NDButton.Name = "NDLogoBtn"
        NDButton.Size = UDim2.new(0, 54, 0, 54)
        NDButton.Position = UDim2.new(0.04, 0, 0.22, 0)
        NDButton.BackgroundColor3 = NyXConfig.UIBackgroundColor
        NDButton.BackgroundTransparency = 0.1
        NDButton.Text = "ND"
        NDButton.TextColor3 = Color3.fromRGB(240, 230, 255)
        NDButton.Font = Enum.Font.GothamBlack
        NDButton.TextSize = 22
        NDButton.AutoButtonColor = true
        NDButton.Active = true
        NDButton.ZIndex = 10
        NDButton.Parent = NDGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = NDButton

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 2.2
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Color = NyXConfig.UIAccentColor
        Stroke.Parent = NDButton

        local SubText = Instance.new("TextLabel")
        SubText.Size = UDim2.new(1, 0, 0, 12)
        SubText.Position = UDim2.new(0, 0, 0.72, 0)
        SubText.BackgroundTransparency = 1
        SubText.Text = "NYX"
        SubText.TextColor3 = NyXConfig.UIAccentColor
        SubText.Font = Enum.Font.GothamBold
        SubText.TextSize = 8
        SubText.ZIndex = 11
        SubText.Parent = NDButton

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil

        NDButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                dragStart = input.Position
                startPos = NDButton.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                if delta.Magnitude > 6 then
                    hasMoved = true
                    NDButton.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    if not hasMoved then
                        ToggleRayfieldMenu()
                    end
                end
            end
        end)
    end)
end

-- ==========================================
-- // FAILSAFE AUTO INVENTORY & ITEM CLICKER
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
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
        for _, r in pairs(Remotes:GetDescendants()) do
            if r:IsA("RemoteEvent") and (r.Name:lower():find("use") or r.Name:lower():find("item") or r.Name:lower():find("inventory")) then
                pcall(function() r:FireServer(itemName) end)
                pcall(function() r:FireServer("Use", itemName) end)
                pcall(function() r:FireServer(itemName, 1) end)
            end
        end

        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pGui then return end

        local invFrame = nil
        for _, v in pairs(pGui:GetDescendants()) do
            if v:IsA("Frame") and (v.Name == "Inventory" or v.Name == "InventoryFrame" or v.Name == "ItemsFrame") then
                invFrame = v
                break
            end
        end

        local wasClosed = false
        if invFrame and not invFrame.Visible then
            wasClosed = true
            invFrame.Visible = true
            task.wait(0.25)
        elseif not invFrame then
            for _, btn in pairs(pGui:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Name:lower():find("inv") or (btn:IsA("TextButton") and btn.Text:lower():find("inventory"))) then
                    wasClosed = true
                    ClickGuiElement(btn)
                    task.wait(0.35)
                    break
                end
            end
        end

        for _, box in pairs(pGui:GetDescendants()) do
            if box:IsA("TextBox") and box.Visible and (box.PlaceholderText:lower():find("search") or box.Name:lower():find("search")) then
                box.Text = itemName
                task.wait(0.2)
                break
            end
        end

        local foundItemSlot = nil
        for _, lbl in pairs(pGui:GetDescendants()) do
            if lbl:IsA("TextLabel") and lbl.Visible and string.find(CleanRichText(lbl.Text):lower(), itemName:lower(), 1, true) then
                local clickableParent = lbl:FindFirstAncestorWhichIsA("TextButton") or lbl:FindFirstAncestorWhichIsA("ImageButton") or lbl.Parent
                if clickableParent then
                    foundItemSlot = clickableParent
                    ClickGuiElement(clickableParent)
                    task.wait(0.25)
                    break
                end
            end
        end

        if foundItemSlot then
            for _, btn in pairs(pGui:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                    local txt = btn:IsA("TextButton") and CleanRichText(btn.Text):upper() or ""
                    local bName = btn.Name:upper()
                    if txt == "USE" or string.find(txt, "USE ") or bName == "USEBUTTON" or bName == "USE" then
                        ClickGuiElement(btn)
                        task.wait(0.2)
                        break
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
-- // MULTI-LAYER BIOME & MERCHANT DETECTION
-- ==========================================
local function MatchExactBiomeString(rawText)
    local clean = CleanRichText(rawText):upper()
    if clean == "" or #clean > 45 then return nil end

    for _, bName in ipairs(BiomeScanPriority) do
        if clean == bName 
           or clean:find("%[%s*" .. bName .. "%s*%]") 
           or clean:find("%f[%a]" .. bName .. "%f[%A]") then
            return bName
        end
    end
    return nil
end

local function GetAccurateServerBiome()
    local foundBiome = nil

    -- Layer 1: Check Server Attributes
    pcall(function()
        local candidates = {
            Workspace:GetAttribute("Biome"),
            Workspace:GetAttribute("CurrentBiome"),
            ReplicatedStorage:GetAttribute("Biome"),
            ReplicatedStorage:GetAttribute("CurrentBiome"),
            Lighting:GetAttribute("Biome"),
            LocalPlayer:GetAttribute("Biome")
        }
        for _, val in ipairs(candidates) do
            if type(val) == "string" and val ~= "" then
                local m = MatchExactBiomeString(val)
                if m then foundBiome = m return end
            end
        end
    end)
    if foundBiome then return foundBiome end

    -- Layer 2: Check StringValues
    pcall(function()
        for _, root in ipairs({ReplicatedStorage, Workspace, Lighting}) do
            for _, obj in ipairs(root:GetChildren()) do
                if obj:IsA("StringValue") and (obj.Name:lower():find("biome") or obj.Name:lower():find("weather")) then
                    local m = MatchExactBiomeString(obj.Value)
                    if m then foundBiome = m return end
                end
            end
        end
    end)
    if foundBiome then return foundBiome end

    -- Layer 3: Scan HUD TextLabels (Strictly filtering out Inventory, Chat, Leaderboards, and Rayfield UI)
    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pGui then return end

        for _, v in ipairs(pGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                local fullName = v:GetFullName():upper()
                if not fullName:find("INVENTORY")
                   and not fullName:find("BACKPACK")
                   and not fullName:find("CHAT")
                   and not fullName:find("SHOP")
                   and not fullName:find("COLLECTION")
                   and not fullName:find("QUEST")
                   and not fullName:find("CRAFT")
                   and not fullName:find("SETTING")
                   and not fullName:find("RAYFIELD")
                   and not fullName:find("PLAYERLIST") then

                    local cleanTxt = CleanRichText(v.Text):upper()
                    if #cleanTxt <= 35 and (v.Name:upper():find("BIOME") or v.Parent.Name:upper():find("BIOME") or cleanTxt:find("%[") or BiomeData[cleanTxt]) then
                        local m = MatchExactBiomeString(cleanTxt)
                        if m then
                            foundBiome = m
                            return
                        end
                    end
                end
            end
        end
    end)

    return foundBiome or "NORMAL"
end

-- Check any string for Merchant Spawn / Presence (Mari, Jester, Rin)
local function ParseMerchantFromText(rawText)
    local clean = CleanRichText(rawText):upper()
    if clean == "" then return nil end

    if clean:find("MARI HAS ARRIVED") or clean:find("%[MARI%]") or clean:find("MARI'S SHOP") or clean == "MARI" then
        return "Mari"
    elseif clean:find("JESTER HAS ARRIVED") or clean:find("%[JESTER%]") or clean:find("JESTER'S SHOP") or clean == "JESTER" then
        return "Jester"
    elseif clean:find("RIN HAS ARRIVED") or clean:find("%[RIN%]") or clean:find("RIN'S SHOP") or clean == "RIN" then
        return "Rin"
    end
    return nil
end

-- Real-time Chat / System Message Listeners for Instant Merchant Detection
pcall(function()
    if TextChatService then
        TextChatService.OnIncomingMessage = function(message)
            if not ScriptRunning then return end
            local txt = (message.Text or "") .. " " .. (message.PrefixText or "")
            local m = ParseMerchantFromText(txt)
            if m then
                task.spawn(function() TriggerMerchantArrival(m) end)
            end
        end
    end
end)

pcall(function()
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMsg = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMsg and onMsg:IsA("RemoteEvent") then
            onMsg.OnClientEvent:Connect(function(data)
                if not ScriptRunning or type(data) ~= "table" then return end
                local m = ParseMerchantFromText(tostring(data.Message or ""))
                if m then
                    task.spawn(function() TriggerMerchantArrival(m) end)
                end
            end)
        end
    end
end)

-- Deep Workspace & UI Scanner for Mari, Jester, and Rin
local function ScanActiveMerchantInWorld()
    local detected = nil
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Folder") then
                local n = obj.Name:upper()
                if n == "MARI" or n == "MERCHANT_MARI" or n == "MARINPC" then
                    detected = "Mari" return
                elseif n == "JESTER" or n == "MERCHANT_JESTER" or n == "JESTERNPC" then
                    detected = "Jester" return
                elseif n == "RIN" or n == "MERCHANT_RIN" or n == "RINNPC" then
                    detected = "Rin" return
                end
            elseif obj:IsA("ProximityPrompt") then
                local combined = (obj.ObjectText .. " " .. obj.ActionText .. " " .. (obj.Parent and obj.Parent.Name or "")):upper()
                if combined:find("%f[%a]MARI%f[%A]") then
                    detected = "Mari" return
                elseif combined:find("%f[%a]JESTER%f[%A]") then
                    detected = "Jester" return
                elseif combined:find("%f[%a]RIN%f[%A]") then
                    detected = "Rin" return
                end
            elseif obj:IsA("TextLabel") and obj.Visible and obj.Text ~= "" then
                local m = ParseMerchantFromText(obj.Text)
                if m then detected = m return end
            end
        end

        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, v in ipairs(pGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                    local fullName = v:GetFullName():upper()
                    if not fullName:find("RAYFIELD") and not fullName:find("INVENTORY") then
                        local clean = CleanRichText(v.Text):upper()
                        if clean:find("MARI HAS ARRIVED") or clean:find("MARI'S SHOP") then
                            detected = "Mari" return
                        elseif clean:find("JESTER HAS ARRIVED") or clean:find("JESTER'S SHOP") then
                            detected = "Jester" return
                        elseif clean:find("RIN HAS ARRIVED") or clean:find("RIN'S SHOP") then
                            detected = "Rin" return
                        end
                    end
                end
            end
        end
    end)
    return detected
end

-- ==========================================
-- // INITIALIZE SIRIUS RAYFIELD WINDOW
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "NyX Detector | Sols RNG Macro",
    LoadingTitle = "NyX Detector",
    LoadingSubtitle = "Biome & Merchant Macro (Argon Edition)",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NyXDetector",
        FileName = "NyXConfig"
    },
    KeySystem = false,
    DisableBuildWarnings = true
})

task.spawn(function()
    task.wait(1)
    CreateNDLogoButton()
    ApplyMenuThemeAndGlass()
end)

-- ==========================================
-- // TAB 1: DETECTOR & WEBHOOK
-- ==========================================
local WebhookTab = Window:CreateTab("Detector & Webhook", 4483362458)
WebhookTab:CreateSection("Discord & Private Server Configuration")

WebhookTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = NyXConfig.WebhookURL ~= "" and NyXConfig.WebhookURL or "Paste your Discord Webhook URL here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.WebhookURL = Text end,
})

WebhookTab:CreateInput({
    Name = "Discord User ID (For Pings)",
    PlaceholderText = NyXConfig.DiscordID ~= "" and NyXConfig.DiscordID or "Ex: 123456789012345678",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.DiscordID = Text end,
})

WebhookTab:CreateInput({
    Name = "Private Server Link",
    PlaceholderText = NyXConfig.PrivateServerLink ~= "" and NyXConfig.PrivateServerLink or "https://www.roblox.com/games/...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.PrivateServerLink = Text end,
})

WebhookTab:CreateButton({
    Name = "Save Webhook Config (Webhook, User ID & Private Server)",
    Callback = function()
        SaveWebhookConfig()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Webhook URL, User ID, and Private Server Link have been saved!",
            Duration = 3
        })
    end,
})

WebhookTab:CreateSection("NyX Detector Controls")

local BiomeStatusLabel = WebhookTab:CreateLabel("Biome: NORMAL | Uptime: 00:00:00")

WebhookTab:CreateToggle({
    Name = "Start Detector (Auto Macro Started / Stopped & Biome Logs)",
    CurrentValue = false,
    Flag = "ToggleBiomeWebhook",
    Callback = function(Value)
        if Value then
            NyXConfig.EnableBiomeWebhook = true
            MacroStartTime = os.time()
            SendMacroStateEmbed(true)
        else
            local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
            NyXConfig.EnableBiomeWebhook = false
            SendMacroStateEmbed(false, finalElapsed)
            MacroStartTime = 0
            BiomeStatusLabel:Set("Biome: " .. NyXConfig.CurrentDetectedBiome .. " | Uptime: 00:00:00")
        end
    end,
})

WebhookTab:CreateToggle({
    Name = "Enable Merchant Detector (Mari / Jester / Rin)",
    CurrentValue = false,
    Flag = "ToggleMerchantWebhook",
    Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end,
})

WebhookTab:CreateSection("Connection Test")

WebhookTab:CreateButton({
    Name = "Test Webhook",
    Callback = function()
        SendTestWebhookEmbed()
        Rayfield:Notify({
            Title = "NyX Detector",
            Content = "Sent 'Webhook Test - Successfully' to Discord!",
            Duration = 2.5
        })
    end,
})

-- ==========================================
-- // TAB 2: INVENTORY AUTOMATION
-- ==========================================
local InventoryTab = Window:CreateTab("Inventory", 4483362458)
InventoryTab:CreateSection("Instant Item Use (Auto-Open Inventory + Failsafe Click)")

InventoryTab:CreateButton({
    Name = "Use Now: Biome Randomizer",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Biome Randomizer") end)
    end,
})

InventoryTab:CreateButton({
    Name = "Use Now: Strange Controller",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Strange Controller") end)
    end,
})

InventoryTab:CreateSection("Timed Item Automation")

InventoryTab:CreateSlider({
    Name = "Use Interval (Cooldown between Inventory actions)",
    Range = {5, 300},
    Increment = 5,
    Suffix = " Seconds",
    CurrentValue = 20,
    Flag = "UseIntervalSlider",
    Callback = function(Value)
        NyXConfig.UseInterval = Value
    end,
})

InventoryTab:CreateToggle({
    Name = "Auto Biome Randomizer (Failsafe Auto-Inventory)",
    CurrentValue = false,
    Flag = "AutoBR",
    Callback = function(Value) NyXConfig.AutoBiomeRandomizer = Value end,
})

InventoryTab:CreateToggle({
    Name = "Auto Strange Controller (Failsafe Auto-Inventory)",
    CurrentValue = false,
    Flag = "AutoSC",
    Callback = function(Value) NyXConfig.AutoStrangeController = Value end,
})

InventoryTab:CreateSection("Stop Auto In (Pause Item Use on Target Biomes)")

InventoryTab:CreateDropdown({
    Name = "Stop Auto In (Select Biomes to Pause Randomizer)",
    Options = All16Biomes,
    CurrentOption = {"GLITCHED", "DREAMSPACE", "CYBERSPACE"},
    MultipleOptions = true,
    Flag = "StopAutoInDropdown",
    Callback = function(SelectedOptions)
        for _, bName in ipairs(All16Biomes) do
            NyXConfig.StopAutoBiomes[bName] = false
        end
        for _, chosenBiome in ipairs(SelectedOptions) do
            NyXConfig.StopAutoBiomes[chosenBiome] = true
        end
    end,
})

-- ==========================================
-- // TAB 3: SETTINGS & UI COLOR CUSTOMIZATION
-- ==========================================
local SettingsTab = Window:CreateTab("Settings & UI", 4483362458)
SettingsTab:CreateSection("Player & Macro Utilities")

SettingsTab:CreateToggle({
    Name = "Enable Anti-AFK (Prevent 20m Idle Disconnect)",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        NyXConfig.AntiAFK = Value
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = Value and "Anti-AFK is now Enabled." or "Anti-AFK is now Disabled.",
            Duration = 2.5
        })
    end,
})

SettingsTab:CreateSection("UI Colors & Liquid Glass Theme")

SettingsTab:CreateColorPicker({
    Name = "UI Accent / Border Color",
    Color = NyXConfig.UIAccentColor,
    Flag = "UIAccentColorPicker",
    Callback = function(Value)
        NyXConfig.UIAccentColor = Value
        ApplyMenuThemeAndGlass()
        if NDGui and NDGui:FindFirstChild("NDLogoBtn") then
            local btn = NDGui.NDLogoBtn
            local st = btn:FindFirstChildWhichIsA("UIStroke")
            local sub = btn:FindFirstChildWhichIsA("TextLabel")
            if st then st.Color = Value end
            if sub then sub.TextColor3 = Value end
        end
    end
})

SettingsTab:CreateColorPicker({
    Name = "UI Background Color",
    Color = NyXConfig.UIBackgroundColor,
    Flag = "UIBgColorPicker",
    Callback = function(Value)
        NyXConfig.UIBackgroundColor = Value
        ApplyMenuThemeAndGlass()
        if NDGui and NDGui:FindFirstChild("NDLogoBtn") then
            NDGui.NDLogoBtn.BackgroundColor3 = Value
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Enable Liquid Glass Effect for Menu",
    CurrentValue = true,
    Flag = "LiquidGlassMenuToggle",
    Callback = function(Value)
        NyXConfig.LiquidGlassMenu = Value
        ApplyMenuThemeAndGlass()
    end,
})

SettingsTab:CreateSlider({
    Name = "Menu Glass Transparency",
    Range = {0, 80},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 25,
    Flag = "MenuTransSlider",
    Callback = function(Value)
        NyXConfig.MenuTransparency = Value / 100
        if NyXConfig.LiquidGlassMenu then
            ApplyMenuThemeAndGlass()
        end
    end,
})

SettingsTab:CreateSection("Script Management")

SettingsTab:CreateButton({
    Name = "Destroy UI / Uninstall NyX Detector",
    Callback = function()
        ScriptRunning = false
        if NyXConfig.EnableBiomeWebhook then
            local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
            SendMacroStateEmbed(false, finalElapsed)
        end
        NyXConfig.EnableBiomeWebhook = false
        NyXConfig.AutoBiomeRandomizer = false
        NyXConfig.AutoStrangeController = false
        
        for _, conn in pairs(GlassConnections) do
            pcall(function() conn:Disconnect() end)
        end
        if IdledConn then IdledConn:Disconnect() end
        if NDGui then NDGui:Destroy() end
        Rayfield:Destroy()
    end,
})

-- ==========================================
-- // BACKGROUND LOOPS (BIOME, MERCHANT, AUTO-ITEM)
-- ==========================================

-- 1. Biome Detection & Uptime Loop
task.spawn(function()
    local lastBiome = GetAccurateServerBiome()
    NyXConfig.CurrentDetectedBiome = lastBiome

    while ScriptRunning and task.wait(1) do
        local detectedBiome = GetAccurateServerBiome()
        NyXConfig.CurrentDetectedBiome = detectedBiome
        local uptimeStr = GetMacroUptime()
        BiomeStatusLabel:Set("Biome: " .. detectedBiome .. " | Uptime: " .. uptimeStr)

        if detectedBiome ~= lastBiome then
            local previousBiome = lastBiome
            lastBiome = detectedBiome

            if NyXConfig.EnableBiomeWebhook then
                if previousBiome ~= "NORMAL" and BiomeData[previousBiome] then
                    local prevInfo = BiomeData[previousBiome]
                    SendBiomeEndedEmbed(previousBiome, prevInfo.Color, prevInfo.Image)
                end

                if detectedBiome ~= "NORMAL" and BiomeData[detectedBiome] then
                    local newInfo = BiomeData[detectedBiome]
                    SendBiomeStartedEmbed(detectedBiome, newInfo.Color, newInfo.Type, newInfo.Image)
                end
            end

            if NyXConfig.StopAutoBiomes[detectedBiome] then
                Rayfield:Notify({
                    Title = "Stop Auto In Triggered",
                    Content = "Detected " .. detectedBiome .. "! Pausing item usage until biome ends.",
                    Duration = 4
                })
            end
        end
    end
end)

-- 2. Active World & UI Merchant Scanner Loop (Mari, Jester, Rin)
task.spawn(function()
    local lastMerchantInWorld = nil
    while ScriptRunning and task.wait(2) do
        if NyXConfig.EnableMerchantWebhook then
            local currentMerchant = ScanActiveMerchantInWorld()
            if currentMerchant and currentMerchant ~= lastMerchantInWorld then
                lastMerchantInWorld = currentMerchant
                TriggerMerchantArrival(currentMerchant)
            elseif not currentMerchant then
                lastMerchantInWorld = nil
            end
        end
    end
end)

-- 3. Auto Biome Randomizer & Strange Controller Loop
task.spawn(function()
    while ScriptRunning do
        task.wait(1)
        if NyXConfig.AutoBiomeRandomizer or NyXConfig.AutoStrangeController then
            local currentB = NyXConfig.CurrentDetectedBiome
            local shouldStop = NyXConfig.StopAutoBiomes[currentB] == true

            if not shouldStop then
                if NyXConfig.AutoBiomeRandomizer then
                    UseItemWithInventoryFailsafe("Biome Randomizer")
                    task.wait(1)
                end
                if NyXConfig.AutoStrangeController and not NyXConfig.StopAutoBiomes[GetAccurateServerBiome()] then
                    UseItemWithInventoryFailsafe("Strange Controller")
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
