-- // NyX DETECTOR - SOLS RNG MACRO (ARGON UNIVERSAL EDITION - FULL ENGLISH & FIXED)
-- // Features: True Liquid Glass UI + Working ND Floating Toggle + 3 Merchants (Mari, Jester, Rin) + Webhook Config Saver

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
local LocalPlayer = Players.LocalPlayer

local ScriptRunning = true
local MacroStartTime = 0

-- // 16 Standard Biomes Data (Eon 1-30)
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
    ["Jester"] = {Color = 0x9B59B6, Ping = "Everyone", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["Rin"] = {Color = 0x3498DB, Ping = "Everyone", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"}
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
    StopAutoBiomes = {},
    CurrentDetectedBiome = "NORMAL",
    LiquidGlassMenu = true,
    MenuTransparency = 0.25,
    AntiAFK = true
}

for _, bName in ipairs(All16Biomes) do
    NyXConfig.StopAutoBiomes[bName] = false
end

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

-- ==========================================
-- // DISCORD WEBHOOK EMBED SYSTEM
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

-- 2. Macro State Embed (Started / Stopped)
local function SendMacroStateEmbed(isStarted, finalElapsed)
    local currentClock = os.date("%H:%M:%S")
    if isStarted then
        SendRawWebhook({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "🟢 Macro Started",
                ["description"] = "**NyX Detector** has started monitoring Biomes & Merchants!\n⏱️ **Macro Uptime :** `00:00:00`",
                ["color"] = 0x00FF88,
                ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
            }}
        })
    else
        local uptimeStr = GetMacroUptime(finalElapsed or 0)
        SendRawWebhook({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "🔴 Macro Stopped",
                ["description"] = "**NyX Detector** has been paused.\n⏱️ **Total Uptime :** `" .. uptimeStr .. "` *(Reset)*",
                ["color"] = 0xFF3344,
                ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
            }}
        })
    end
end

-- 3. Biome Started Embed
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
            ["description"] = "⏱️ **Macro Uptime :** `" .. uptimeStr .. "`\n🔗 **Private Server :** " .. psDisplay,
            ["color"] = color or 0x9B59B6,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
        }}
    })
end

-- 4. Biome Ended Embed
local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Biome Ended - " .. biomeName,
            ["description"] = "⏱️ **Macro Uptime :** `" .. uptimeStr .. "`",
            ["color"] = color or 0x555555,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
        }}
    })
end

-- 5. Merchant Arrived Embed ("<Merchant Name> has arrived!")
local function SendMerchantEmbed(merchantName)
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
            ["description"] = "🛒 **Merchant :** `" .. merchantName .. "`\n⏱️ **Macro Uptime :** `" .. uptimeStr .. "`\n🔗 **Private Server :** " .. psDisplay,
            ["color"] = mInfo.Color,
            ["thumbnail"] = {["url"] = mInfo.Image},
            ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
        }}
    })
end

-- ==========================================
-- // RAYFIELD FINDER, LIQUID GLASS & "ND" FLOATING BUTTON (FIXED)
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
                if gui.Name == "Rayfield" or gui:FindFirstChild("Main", true) then
                    local mainCheck = gui:FindFirstChild("Main", true)
                    if mainCheck and mainCheck:FindFirstChild("Topbar") then
                        return gui, mainCheck
                    end
                end
            end
        end
    end
    return nil, nil
end

local function ApplyMenuLiquidGlass(enabled, trans)
    pcall(function()
        local rfGui, mainFrame = FindRayfieldScreenGui()
        if not rfGui or not mainFrame then return end

        -- Hide Rayfield's default mini "Show Rayfield" bar so ND button controls everything cleanly
        for _, child in ipairs(rfGui:GetChildren()) do
            if child:IsA("Frame") and child ~= mainFrame and child.Name ~= "Notification" and child.Name ~= "Notifications" then
                if child:FindFirstChildWhichIsA("TextButton", true) then
                    child.Visible = false
                end
            end
        end

        local targetMainTrans = enabled and trans or 0
        local targetElemTrans = enabled and math.clamp(trans + 0.15, 0, 0.92) or 0

        local function StyleObject(v)
            if v:IsA("Frame") then
                local n = v.Name
                if n == "Main" or n == "Topbar" or n == "Elements" or n == "TabList" then
                    v.BackgroundTransparency = targetMainTrans
                    if enabled then v.BackgroundColor3 = Color3.fromRGB(16, 16, 26) end
                elseif v.Parent and (v.Parent.Name == "Elements" or v.Parent:IsA("ScrollingFrame")) then
                    v.BackgroundTransparency = targetElemTrans
                    if enabled then v.BackgroundColor3 = Color3.fromRGB(24, 22, 38) end
                elseif n == "Shadow" or n == "DropShadow" then
                    v.Visible = not enabled
                end
            elseif v:IsA("ScrollingFrame") then
                v.BackgroundTransparency = 1
            elseif v:IsA("UIStroke") then
                if enabled then
                    v.Color = Color3.fromRGB(175, 120, 255)
                    v.Transparency = 0.35
                    v.Thickness = 1.2
                else
                    v.Transparency = 0
                end
            end
        end

        for _, v in ipairs(mainFrame:GetDescendants()) do
            StyleObject(v)
            -- Lock transparency against Rayfield's internal TweenService overrides
            if enabled and not GlassConnections[v] and v:IsA("Frame") then
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

local function ToggleRayfieldWindow()
    pcall(function()
        local rfGui, mainFrame = FindRayfieldScreenGui()
        if not rfGui then return end

        if mainFrame then
            local newState = not mainFrame.Visible
            mainFrame.Visible = newState
            rfGui.Enabled = true
            -- Re-apply Liquid Glass if toggled back on
            if newState and NyXConfig.LiquidGlassMenu then
                task.defer(function()
                    ApplyMenuLiquidGlass(true, NyXConfig.MenuTransparency)
                end)
            end
        else
            rfGui.Enabled = not rfGui.Enabled
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
        NDButton.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        NDButton.BackgroundTransparency = 0.12
        NDButton.Text = "ND"
        NDButton.TextColor3 = Color3.fromRGB(235, 220, 255)
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
        Stroke.Color = Color3.fromRGB(185, 115, 255)
        Stroke.Parent = NDButton

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 80, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 110, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 190, 255))
        })
        Gradient.Rotation = 45
        Gradient.Parent = Stroke

        local SubText = Instance.new("TextLabel")
        SubText.Size = UDim2.new(1, 0, 0, 12)
        SubText.Position = UDim2.new(0, 0, 0.72, 0)
        SubText.BackgroundTransparency = 1
        SubText.Text = "NYX"
        SubText.TextColor3 = Color3.fromRGB(180, 140, 255)
        SubText.Font = Enum.Font.GothamBold
        SubText.TextSize = 8
        SubText.ZIndex = 11
        SubText.Parent = NDButton

        -- Smooth Drag + Click Separation (Fixes click not registering after touch/mouse down)
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
                        ToggleRayfieldWindow()
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
            if lbl:IsA("TextLabel") and lbl.Visible and string.find(lbl.Text:lower(), itemName:lower(), 1, true) then
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
                    local txt = btn:IsA("TextButton") and btn.Text:upper() or ""
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
-- // ACCURATE BIOME & MERCHANT SCANNERS
-- ==========================================
local function GetAccurateServerBiome()
    local foundBiome = "NORMAL"

    pcall(function()
        local serverBiomeAttr = Workspace:GetAttribute("Biome") or Workspace:GetAttribute("CurrentBiome") or ReplicatedStorage:GetAttribute("Biome")
        if serverBiomeAttr and type(serverBiomeAttr) == "string" then
            local upperAttr = serverBiomeAttr:upper()
            for _, bName in ipairs(BiomeScanPriority) do
                if string.find(upperAttr, bName, 1, true) then
                    foundBiome = bName
                    return
                end
            end
        end
    end)
    if foundBiome ~= "NORMAL" then return foundBiome end

    pcall(function()
        local biomeValObj = ReplicatedStorage:FindFirstChild("Biome") or ReplicatedStorage:FindFirstChild("CurrentBiome") or Workspace:FindFirstChild("Biome")
        if biomeValObj and biomeValObj:IsA("StringValue") then
            local upperVal = biomeValObj.Value:upper()
            for _, bName in ipairs(BiomeScanPriority) do
                if string.find(upperVal, bName, 1, true) then
                    foundBiome = bName
                    return
                end
            end
        end
    end)
    if foundBiome ~= "NORMAL" then return foundBiome end

    pcall(function()
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                local fullName = v:GetFullName():upper()
                if not string.find(fullName, "INVENTORY") 
                   and not string.find(fullName, "BACKPACK") 
                   and not string.find(fullName, "RAYFIELD") 
                   and not string.find(fullName, "CHAT") 
                   and not string.find(fullName, "SHOP") then
                    
                    local textUpper = v.Text:upper()
                    if #textUpper <= 35 and (v.Name:upper():find("BIOME") or textUpper:find("%[") or BiomeData[textUpper]) then
                        for _, bName in ipairs(BiomeScanPriority) do
                            if string.find(textUpper, bName, 1, true) then
                                foundBiome = bName
                                return
                            end
                        end
                    end
                end
            end
        end
    end)

    return foundBiome
end

-- Deep Merchant Scanner for Mari, Jester, and Rin
local function ScanActiveMerchant()
    local detected = nil
    pcall(function()
        -- 1. Check Workspace Descendants (Models, NPCs, Dialogs, Prompts)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart") or obj:IsA("ProximityPrompt") or obj:IsA("BillboardGui") then
                local n = obj.Name:upper()
                if n == "MARI" or n:find("MARI'S") or n:find("MERCHANT_MARI") then
                    detected = "Mari"
                    return
                elseif n == "JESTER" or n:find("JESTER'S") or n:find("MERCHANT_JESTER") then
                    detected = "Jester"
                    return
                elseif n == "RIN" or n:find("RIN'S") or n:find("MERCHANT_RIN") then
                    detected = "Rin"
                    return
                end
            elseif obj:IsA("TextLabel") and obj.Visible and obj.Text ~= "" then
                local t = obj.Text:upper()
                if t:find("MARI") and (t:find("MERCHANT") or t:find("SHOP") or t:find("ARRIVED")) then
                    detected = "Mari"
                    return
                elseif t:find("JESTER") and (t:find("MERCHANT") or t:find("SHOP") or t:find("ARRIVED")) then
                    detected = "Jester"
                    return
                elseif (t == "RIN" or t:find("RIN'S") or t:find("RIN HAS ARRIVED")) then
                    detected = "Rin"
                    return
                end
            end
        end

        -- 2. Check PlayerGui for Merchant Shop / Notification Banners
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, v in ipairs(pGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                    local fullName = v:GetFullName():upper()
                    if not fullName:find("RAYFIELD") and not fullName:find("INVENTORY") then
                        local t = v.Text:upper()
                        if t:find("MARI HAS ARRIVED") or t:find("MARI'S SHOP") then
                            detected = "Mari"
                            return
                        elseif t:find("JESTER HAS ARRIVED") or t:find("JESTER'S SHOP") then
                            detected = "Jester"
                            return
                        elseif t:find("RIN HAS ARRIVED") or t:find("RIN'S SHOP") then
                            detected = "Rin"
                            return
                        end
                    end
                end
            end
        end
    end)
    return detected
end

-- ==========================================
-- // INITIALIZE MENU: NyX DETECTOR
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "🌌 NyX Detector",
    LoadingTitle = "NyX Detector",
    LoadingSubtitle = "Biome & Merchant Macro (Argon Edition)",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NyXDetector",
        FileName = "NyXConfig"
    },
    KeySystem = false
})

task.spawn(function()
    task.wait(1)
    CreateNDLogoButton()
    ApplyMenuLiquidGlass(NyXConfig.LiquidGlassMenu, NyXConfig.MenuTransparency)
end)

-- ==========================================
-- // TAB 1: DETECTOR & WEBHOOK
-- ==========================================
local WebhookTab = Window:CreateTab("🌐 Detector & Webhook", 4483362458)
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
    Name = "💾 Save Webhook Config (Webhook, User ID & Private Server)",
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

local BiomeStatusLabel = WebhookTab:CreateLabel("🌍 Biome: NORMAL | ⏱️ Uptime: 00:00:00")

WebhookTab:CreateToggle({
    Name = "▶️ Start Detector (Auto Macro Started / Stopped & Biome Logs)",
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
            BiomeStatusLabel:Set("🌍 Biome: " .. NyXConfig.CurrentDetectedBiome .. " | ⏱️ Uptime: 00:00:00")
        end
    end,
})

WebhookTab:CreateToggle({
    Name = "🛒 Enable Merchant Detector (Mari / Jester / Rin)",
    CurrentValue = false,
    Flag = "ToggleMerchantWebhook",
    Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end,
})

WebhookTab:CreateSection("Connection Test")

WebhookTab:CreateButton({
    Name = "🔔 Test Webhook",
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
-- // TAB 2: INVENTORY
-- ==========================================
local InventoryTab = Window:CreateTab("🎒 Inventory", 4483362458)
InventoryTab:CreateSection("Instant Item Use (Auto-Open Inventory + Failsafe Click)")

InventoryTab:CreateButton({
    Name = "🎲 Use Now: Biome Randomizer",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Biome Randomizer") end)
    end,
})

InventoryTab:CreateButton({
    Name = "🕹️ Use Now: Strange Controller",
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

InventoryTab:CreateSection("🛑 Stop Auto In (Pause Item Use on Target Biomes)")

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
-- // TAB 3: SETTINGS
-- ==========================================
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("Player & Macro Utilities")

SettingsTab:CreateToggle({
    Name = "🛡️ Enable Anti-AFK (Prevent 20m Idle Disconnect)",
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

SettingsTab:CreateSection("Liquid Glass UI Theme")

SettingsTab:CreateToggle({
    Name = "Enable Liquid Glass Effect for Menu",
    CurrentValue = true,
    Flag = "LiquidGlassMenuToggle",
    Callback = function(Value)
        NyXConfig.LiquidGlassMenu = Value
        ApplyMenuLiquidGlass(Value, NyXConfig.MenuTransparency)
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
            ApplyMenuLiquidGlass(true, NyXConfig.MenuTransparency)
        end
    end,
})

SettingsTab:CreateSection("Script Management")

SettingsTab:CreateButton({
    Name = "🗑️ Destroy UI / Uninstall NyX Detector",
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
        BiomeStatusLabel:Set("🌍 Biome: " .. detectedBiome .. " | ⏱️ Uptime: " .. uptimeStr)

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
                    Title = "🛑 Stop Auto In Triggered!",
                    Content = "Detected " .. detectedBiome .. "! Pausing item usage until biome ends.",
                    Duration = 4
                })
            end
        end
    end
end)

-- 2. Merchant Detection Loop (Mari, Jester, Rin)
task.spawn(function()
    local lastMerchant = nil
    while ScriptRunning and task.wait(2) do
        if NyXConfig.EnableMerchantWebhook then
            local currentMerchant = ScanActiveMerchant()
            if currentMerchant and currentMerchant ~= lastMerchant then
                lastMerchant = currentMerchant
                SendMerchantEmbed(currentMerchant)
                Rayfield:Notify({
                    Title = "🛒 Merchant Detected!",
                    Content = currentMerchant .. " has arrived!",
                    Duration = 4
                })
            elseif not currentMerchant then
                lastMerchant = nil
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
