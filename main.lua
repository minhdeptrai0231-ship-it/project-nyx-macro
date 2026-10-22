-- // NyX DETECTOR - SOLS RNG MACRO (AIRFLOW UI EDITION)
-- // Modern Airflow UI + No-Emoji Plain Text Embeds + 3 Merchants (Mari, Jester, Rin) + Custom UI Color Picker

local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/AirFlow/refs/heads/main/src/source.luau"))()

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
    AntiAFK = true,
    UIAccentColor = Color3.fromRGB(165, 105, 255),
    UIBackgroundColor = Color3.fromRGB(16, 16, 24)
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

-- // Helper Notification Wrapper for Airflow
local function NotifyUser(title, content, duration)
    pcall(function()
        if Airflow and Airflow.Notify then
            Airflow:Notify({
                Title = title,
                Content = content,
                Duration = duration or 3
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = content,
                Duration = duration or 3
            })
        end
    end)
end

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

    NotifyUser("Merchant Detected", merchantName .. " has arrived!", 5)
end

-- ==========================================
-- // AIRFLOW UI FINDER, COLOR CUSTOMIZER & "ND" BUTTON
-- ==========================================
local NDGui = nil

local function FindAirflowGui()
    local roots = {}
    if gethui then pcall(function() table.insert(roots, gethui()) end) end
    table.insert(roots, CoreGui)
    if LocalPlayer:FindFirstChild("PlayerGui") then
        table.insert(roots, LocalPlayer.PlayerGui)
    end

    for _, root in ipairs(roots) do
        for _, gui in ipairs(root:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "NyXDetectorLogoGui" then
                if gui.Name:lower():find("airflow") or gui:FindFirstChild("NyX Detector", true) then
                    return gui
                end
                for _, lbl in ipairs(gui:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text:find("NyX Detector") then
                        return gui
                    end
                end
            end
        end
    end
    return nil
end

local function ApplyCustomUIColors(accentColor, bgColor)
    pcall(function()
        if Airflow and Airflow.Config then
            Airflow.Config.Highlight = accentColor
        end
        local afGui = FindAirflowGui()
        if not afGui then return end

        for _, v in ipairs(afGui:GetDescendants()) do
            if v:IsA("UIStroke") then
                if v.Thickness >= 1.2 then
                    v.Color = accentColor
                end
            elseif v:IsA("Frame") then
                local c = v.BackgroundColor3
                -- Recolor main dark backgrounds
                if c.R < 0.15 and c.G < 0.15 and c.B < 0.18 and v.BackgroundTransparency < 0.5 then
                    v.BackgroundColor3 = bgColor
                -- Recolor active accent toggles / sliders
                elseif (c.R > 0.3 or c.B > 0.3) and v.Size.Y.Offset <= 26 then
                    v.BackgroundColor3 = accentColor
                end
            end
        end
    end)
end

local function ToggleAirflowWindow()
    pcall(function()
        local afGui = FindAirflowGui()
        if afGui then
            afGui.Enabled = not afGui.Enabled
        else
            -- Fallback: Send LeftControl keybind (Airflow's default toggle key)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
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
        NDButton.Size = UDim2.new(0, 52, 0, 52)
        NDButton.Position = UDim2.new(0.04, 0, 0.22, 0)
        NDButton.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
        NDButton.BackgroundTransparency = 0.08
        NDButton.Text = "ND"
        NDButton.TextColor3 = Color3.fromRGB(240, 230, 255)
        NDButton.Font = Enum.Font.GothamBlack
        NDButton.TextSize = 21
        NDButton.AutoButtonColor = true
        NDButton.Active = true
        NDButton.ZIndex = 10
        NDButton.Parent = NDGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = NDButton

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 2
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Color = NyXConfig.UIAccentColor
        Stroke.Parent = NDButton

        local SubText = Instance.new("TextLabel")
        SubText.Size = UDim2.new(1, 0, 0, 12)
        SubText.Position = UDim2.new(0, 0, 0.72, 0)
        SubText.BackgroundTransparency = 1
        SubText.Text = "NYX"
        SubText.TextColor3 = Color3.fromRGB(185, 145, 255)
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
                        ToggleAirflowWindow()
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

    -- Layer 3: Scan HUD TextLabels (Excluding Menus, Inventory, Chat, Airflow UI)
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
                   and not fullName:find("AIRFLOW")
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
    end)
    return detected
end

-- ==========================================
-- // AIRFLOW UI WINDOW & TABS INITIALIZATION
-- ==========================================
local Window = Airflow:Init({
    Name = "NyX Detector | Sols RNG Macro",
    Keybind = "LeftControl",
    Logo = "http://www.roblox.com/asset/?id=118752982916680",
    Highlight = NyXConfig.UIAccentColor
})

CreateNDLogoButton()

local DetectorTab = Window:DrawTab({
    Name = "Detector & Webhook",
    Icon = "globe"
})

local InventoryTab = Window:DrawTab({
    Name = "Inventory",
    Icon = "archive"
})

local SettingsTab = Window:DrawTab({
    Name = "Settings & UI",
    Icon = "settings"
})

-- ==========================================
-- // TAB 1: DETECTOR & WEBHOOK (AIRFLOW SECTIONS)
-- ==========================================
local WebhookSection = DetectorTab:AddLeftSection("Discord & Server Configuration")
local ControlSection = DetectorTab:AddRightSection("Detector Controls & Status")

WebhookSection:AddTextbox({
    Name = "Webhook URL",
    Default = NyXConfig.WebhookURL,
    Placeholder = "Paste Discord Webhook URL...",
    Callback = function(Value)
        NyXConfig.WebhookURL = Value
    end
})

WebhookSection:AddTextbox({
    Name = "Discord User ID (For Pings)",
    Default = NyXConfig.DiscordID,
    Placeholder = "Ex: 123456789012345678",
    Callback = function(Value)
        NyXConfig.DiscordID = Value
    end
})

WebhookSection:AddTextbox({
    Name = "Private Server Link",
    Default = NyXConfig.PrivateServerLink,
    Placeholder = "https://www.roblox.com/games/...",
    Callback = function(Value)
        NyXConfig.PrivateServerLink = Value
    end
})

WebhookSection:AddButton({
    Name = "Save Webhook Config",
    Callback = function()
        SaveWebhookConfig()
        NotifyUser("Config Saved", "Webhook URL, User ID, and Private Server Link saved!", 3)
    end
})

WebhookSection:AddButton({
    Name = "Test Webhook",
    Callback = function()
        SendTestWebhookEmbed()
        NotifyUser("NyX Detector", "Sent 'Webhook Test - Successfully' to Discord!", 3)
    end
})

local StatusBiomeLabel = ControlSection:AddLabel("Current Biome: NORMAL")
local StatusUptimeLabel = ControlSection:AddLabel("Macro Uptime: 00:00:00")

ControlSection:AddToggle({
    Name = "Start Detector (Biome & State Logs)",
    Default = false,
    Callback = function(Value)
        if Value then
            NyXConfig.EnableBiomeWebhook = true
            MacroStartTime = os.time()
            SendMacroStateEmbed(true)
            NotifyUser("NyX Detector", "Macro Started!", 2.5)
        else
            local finalElapsed = (MacroStartTime > 0) and (os.time() - MacroStartTime) or 0
            NyXConfig.EnableBiomeWebhook = false
            SendMacroStateEmbed(false, finalElapsed)
            MacroStartTime = 0
            pcall(function() StatusUptimeLabel:SetText("Macro Uptime: 00:00:00") end)
            pcall(function() StatusUptimeLabel:Set("Macro Uptime: 00:00:00") end)
            NotifyUser("NyX Detector", "Macro Stopped!", 2.5)
        end
    end
})

ControlSection:AddToggle({
    Name = "Enable Merchant Detector (Mari / Jester / Rin)",
    Default = false,
    Callback = function(Value)
        NyXConfig.EnableMerchantWebhook = Value
    end
})

-- ==========================================
-- // TAB 2: INVENTORY AUTOMATION
-- ==========================================
local ManualItemSection = InventoryTab:AddLeftSection("Instant Item Actions")
local AutoItemSection = InventoryTab:AddRightSection("Timed Item Automation")

ManualItemSection:AddButton({
    Name = "Use Now: Biome Randomizer",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Biome Randomizer") end)
    end
})

ManualItemSection:AddButton({
    Name = "Use Now: Strange Controller",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Strange Controller") end)
    end
})

AutoItemSection:AddSlider({
    Name = "Use Interval (Seconds)",
    Min = 5,
    Max = 300,
    Default = 20,
    Round = 0,
    Callback = function(Value)
        NyXConfig.UseInterval = Value
    end
})

AutoItemSection:AddToggle({
    Name = "Auto Biome Randomizer",
    Default = false,
    Callback = function(Value)
        NyXConfig.AutoBiomeRandomizer = Value
    end
})

AutoItemSection:AddToggle({
    Name = "Auto Strange Controller",
    Default = false,
    Callback = function(Value)
        NyXConfig.AutoStrangeController = Value
    end
})

AutoItemSection:AddDropdown({
    Name = "Stop Auto In (Target Biomes)",
    Values = All16Biomes,
    Default = {"GLITCHED", "DREAMSPACE", "CYBERSPACE"},
    Multi = true,
    Callback = function(Selected)
        for _, bName in ipairs(All16Biomes) do
            NyXConfig.StopAutoBiomes[bName] = false
        end
        if type(Selected) == "table" then
            for k, v in pairs(Selected) do
                if type(k) == "number" and type(v) == "string" then
                    NyXConfig.StopAutoBiomes[v] = true
                elseif type(k) == "string" and v == true then
                    NyXConfig.StopAutoBiomes[k] = true
                end
            end
        elseif type(Selected) == "string" then
            NyXConfig.StopAutoBiomes[Selected] = true
        end
    end
})

-- ==========================================
-- // TAB 3: SETTINGS & UI COLOR PICKER
-- ==========================================
local UtilitySection = SettingsTab:AddLeftSection("System & Anti-AFK")
local ThemeSection = SettingsTab:AddRightSection("UI Color Customization")

UtilitySection:AddToggle({
    Name = "Enable Anti-AFK",
    Default = true,
    Callback = function(Value)
        NyXConfig.AntiAFK = Value
        NotifyUser("Anti-AFK", Value and "Anti-AFK Enabled" or "Anti-AFK Disabled", 2.5)
    end
})

UtilitySection:AddButton({
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
        if IdledConn then IdledConn:Disconnect() end
        if NDGui then NDGui:Destroy() end
        local afGui = FindAirflowGui()
        if afGui then afGui:Destroy() end
    end
})

ThemeSection:AddColorPicker({
    Name = "UI Accent / Highlight Color",
    Default = NyXConfig.UIAccentColor,
    Callback = function(Color)
        NyXConfig.UIAccentColor = Color
        ApplyCustomUIColors(NyXConfig.UIAccentColor, NyXConfig.UIBackgroundColor)
        if NDGui and NDGui:FindFirstChild("NDLogoBtn") then
            local st = NDGui.NDLogoBtn:FindFirstChildWhichIsA("UIStroke")
            if st then st.Color = Color end
        end
    end
})

ThemeSection:AddColorPicker({
    Name = "UI Background Color",
    Default = NyXConfig.UIBackgroundColor,
    Callback = function(Color)
        NyXConfig.UIBackgroundColor = Color
        ApplyCustomUIColors(NyXConfig.UIAccentColor, NyXConfig.UIBackgroundColor)
    end
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

        pcall(function()
            if StatusBiomeLabel.SetText then
                StatusBiomeLabel:SetText("Current Biome: " .. detectedBiome)
                StatusUptimeLabel:SetText("Macro Uptime: " .. uptimeStr)
            elseif StatusBiomeLabel.Set then
                StatusBiomeLabel:Set("Current Biome: " .. detectedBiome)
                StatusUptimeLabel:Set("Macro Uptime: " .. uptimeStr)
            end
        end)

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
                NotifyUser("Stop Auto In", "Detected " .. detectedBiome .. "! Pausing item usage.", 4)
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
