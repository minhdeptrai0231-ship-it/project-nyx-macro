-- // NyX DETECTOR - SOLS RNG MACRO (ARGON UNIVERSAL EDITION - FIXED)
-- // Giao diện Liquid Glass Menu + Nút nổi ND + Failsafe Auto Inventory

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Dịch vụ hệ thống
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ScriptRunning = true
local MacroStartTime = 0

-- // Bảng dữ liệu 16 Biome chuẩn theo Eon 1-30
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

-- // Cấu hình
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
    MenuTransparency = 0.25
}

for _, bName in ipairs(All16Biomes) do
    NyXConfig.StopAutoBiomes[bName] = false
end

-- // Anti-AFK
local IdledConn = LocalPlayer.Idled:Connect(function()
    if not ScriptRunning then return end
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- // Hàm định dạng Thời gian Macro (Hỗ trợ truyền thời gian tĩnh khi dừng)
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
-- // HỆ THỐNG DISCORD WEBHOOK EMBED
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

local function SendMacroStateEmbed(isStarted, finalElapsed)
    local currentClock = os.date("%H:%M:%S")
    if isStarted then
        SendRawWebhook({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "🟢 Macro Started",
                ["description"] = "Hệ thống **NyX Detector** đã bắt đầu theo dõi Biome!\n⏱️ **Thời gian Macro :** `00:00:00`",
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
                ["description"] = "Đã tạm dừng **NyX Detector**.\n⏱️ **Tổng thời gian đã chạy :** `" .. uptimeStr .. "` *(Đã Reset)*",
                ["color"] = 0xFF3344,
                ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
            }}
        })
    end
end

local function SendBiomeStartedEmbed(biomeName, color, pingType, imageUrl)
    local contentMsg = ""
    if pingType == "Everyone" then
        contentMsg = "@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")
    elseif NyXConfig.DiscordID ~= "" and pingType == "UserPing" then
        contentMsg = "<@" .. NyXConfig.DiscordID .. ">"
    end

    local psDisplay = NyXConfig.PrivateServerLink ~= "" and ("[Nhấn để vào Server](" .. NyXConfig.PrivateServerLink .. ")") or "`Không có`"
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = "Biome Started - " .. biomeName,
            ["description"] = "⏱️ **Thời gian Macro :** `" .. uptimeStr .. "`\n🔗 **Private Server :** " .. psDisplay,
            ["color"] = color or 0x9B59B6,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
        }}
    })
end

local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
    local currentClock = os.date("%H:%M:%S")
    local uptimeStr = GetMacroUptime()

    SendRawWebhook({
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Biome Ended - " .. biomeName,
            ["description"] = "⏱️ **Thời gian Macro :** `" .. uptimeStr .. "`",
            ["color"] = color or 0x555555,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "NyX Detector • " .. currentClock}
        }}
    })
end

-- ==========================================
-- // HIỆU ỨNG LIQUID GLASS & LOGO NỔI "ND"
-- ==========================================
local NDGui = nil
local RayfieldMainFrame = nil

local function ApplyMenuLiquidGlass(enabled, trans)
    pcall(function()
        local rfGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
        if not rfGui then return end

        for _, v in pairs(rfGui:GetDescendants()) do
            if v:IsA("Frame") and (v.Name == "Main" or v.Name == "Topbar" or v.Name == "Elements" or v.Name == "TabList") then
                if v.Name == "Main" then RayfieldMainFrame = v end
                v.BackgroundTransparency = enabled and trans or 0
                if enabled then
                    v.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                end
            elseif v:IsA("Frame") and v.Parent and v.Parent.Name == "Elements" then
                v.BackgroundTransparency = enabled and (trans + 0.15) or 0
            elseif v:IsA("UIStroke") then
                if enabled then
                    v.Color = Color3.fromRGB(170, 120, 255)
                    v.Transparency = 0.35
                    v.Thickness = 1.2
                else
                    v.Transparency = 0
                end
            end
        end
    end)
end

local function CreateNDLogoButton()
    pcall(function()
        local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer.PlayerGui
        if parentTarget:FindFirstChild("NyXDetectorLogoGui") then
            parentTarget.NyXDetectorLogoGui:Destroy()
        end

        NDGui = Instance.new("ScreenGui")
        NDGui.Name = "NyXDetectorLogoGui"
        NDGui.ResetOnSpawn = false
        NDGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NDGui.Parent = parentTarget

        local NDButton = Instance.new("TextButton")
        NDButton.Name = "NDLogoBtn"
        NDButton.Size = UDim2.new(0, 52, 0, 52)
        NDButton.Position = UDim2.new(0.05, 0, 0.18, 0)
        NDButton.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        NDButton.BackgroundTransparency = 0.15
        NDButton.Text = "ND"
        NDButton.TextColor3 = Color3.fromRGB(235, 220, 255)
        NDButton.Font = Enum.Font.GothamBlack
        NDButton.TextSize = 22
        NDButton.AutoButtonColor = true
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
        SubText.Parent = NDButton

        local dragging, dragInput, dragStart, startPos
        NDButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = NDButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        NDButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                NDButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        NDButton.MouseButton1Click:Connect(function()
            local rfGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
            if rfGui then
                local mainFrame = RayfieldMainFrame or rfGui:FindFirstChild("Main", true)
                if mainFrame then
                    mainFrame.Visible = not mainFrame.Visible
                else
                    rfGui.Enabled = not rfGui.Enabled
                end
            end
        end)
    end)
end

-- ==========================================
-- // FAILSAFE AUTO MỞ INVENTORY & CLICK DÙNG ITEM
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
-- // HÀM QUÉT BIOME CHÍNH XÁC (ĐÃ SỬA LỖI RETURN SCOPE)
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

-- ==========================================
-- // KHỞI TẠO MENU: NyX DETECTOR
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "🌌 NyX Detector",
    LoadingTitle = "NyX Detector",
    LoadingSubtitle = "Biome & Merchant Macro",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NyXDetector",
        FileName = "NyXConfig"
    },
    KeySystem = false
})

task.spawn(function()
    task.wait(1.2)
    CreateNDLogoButton()
    ApplyMenuLiquidGlass(NyXConfig.LiquidGlassMenu, NyXConfig.MenuTransparency)
end)

-- ==========================================
-- // TAB 1: WEBHOOK & BIOME DETECTOR
-- ==========================================
local WebhookTab = Window:CreateTab("🌐 Detector & Webhook", 4483362458)
WebhookTab:CreateSection("Cấu hình Discord & Private Server")

WebhookTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "Dán link Discord Webhook vào đây...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.WebhookURL = Text end,
})

WebhookTab:CreateInput({
    Name = "Discord ID",
    PlaceholderText = "VD: 123456789012345678",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.DiscordID = Text end,
})

WebhookTab:CreateInput({
    Name = "Link Private Server",
    PlaceholderText = "https://www.roblox.com/games/...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.PrivateServerLink = Text end,
})

WebhookTab:CreateSection("Điều khiển NyX Detector")

local BiomeStatusLabel = WebhookTab:CreateLabel("🌍 Biome: NORMAL | ⏱️ Uptime: 00:00:00")

WebhookTab:CreateToggle({
    Name = "▶️ Start Detector (Tự báo Macro Started / Stopped & Biome)",
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
    Name = "🛒 Bật Detect Merchant (Mari / Jester)",
    CurrentValue = false,
    Flag = "ToggleMerchantWebhook",
    Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end,
})

WebhookTab:CreateSection("Kiểm tra Kết nối")

WebhookTab:CreateButton({
    Name = "🔔 Test Webhook",
    Callback = function()
        SendTestWebhookEmbed()
        Rayfield:Notify({
            Title = "NyX Detector",
            Content = "Đã gửi 'Webhook Test - Successfully' tới Discord!",
            Duration = 2.5
        })
    end,
})

-- ==========================================
-- // TAB 2: INVENTORY
-- ==========================================
local InventoryTab = Window:CreateTab("🎒 Inventory", 4483362458)
InventoryTab:CreateSection("Sử dụng Item (Tự mở Inventory + Click Failsafe)")

InventoryTab:CreateButton({
    Name = "🎲 Dùng ngay: Biome Randomizer",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Biome Randomizer") end)
    end,
})

InventoryTab:CreateButton({
    Name = "🕹️ Dùng ngay: Strange Controller",
    Callback = function()
        task.spawn(function() UseItemWithInventoryFailsafe("Strange Controller") end)
    end,
})

InventoryTab:CreateSection("Tự động hóa theo Thời gian yêu cầu")

InventoryTab:CreateSlider({
    Name = "Thời gian lặp lại (Cooldown mở Inventory dùng item)",
    Range = {5, 300},
    Increment = 5,
    Suffix = " giây",
    CurrentValue = 20,
    Flag = "UseIntervalSlider",
    Callback = function(Value)
        NyXConfig.UseInterval = Value
    end,
})

InventoryTab:CreateToggle({
    Name = "Auto Biome Randomizer (Failsafe Tự Mở Balo)",
    CurrentValue = false,
    Flag = "AutoBR",
    Callback = function(Value) NyXConfig.AutoBiomeRandomizer = Value end,
})

InventoryTab:CreateToggle({
    Name = "Auto Strange Controller (Failsafe Tự Mở Balo)",
    CurrentValue = false,
    Flag = "AutoSC",
    Callback = function(Value) NyXConfig.AutoStrangeController = Value end,
})

InventoryTab:CreateSection("🛑 Stop Auto in (Tự dừng Random khi trúng Biome)")

InventoryTab:CreateDropdown({
    Name = "Stop Auto in (Chọn Biome muốn dừng Randomizer)",
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
SettingsTab:CreateSection("Hiệu ứng Liquid Glass (Trong suốt Menu Script)")

SettingsTab:CreateToggle({
    Name = "Bật Liquid Glass cho Menu NyX Detector",
    CurrentValue = true,
    Flag = "LiquidGlassMenuToggle",
    Callback = function(Value)
        NyXConfig.LiquidGlassMenu = Value
        ApplyMenuLiquidGlass(Value, NyXConfig.MenuTransparency)
    end,
})

SettingsTab:CreateSlider({
    Name = "Độ trong suốt của Menu (Menu Glass Transparency)",
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

SettingsTab:CreateSection("Quản lý Script")

SettingsTab:CreateButton({
    Name = "🗑️ Destroy UI / Uninstall (Tắt hoàn toàn NyX Detector)",
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
        Rayfield:Destroy()
    end,
})

-- ==========================================
-- // VÒNG LẶP XỬ LÝ NGẦM (TỐI ƯU HÓA FPS)
-- ==========================================

-- 1. Vòng lặp Detect Biome & Đếm thời gian Uptime
task.spawn(function()
    local lastBiome = GetAccurateServerBiome()
    NyXConfig.CurrentDetectedBiome = lastBiome

    while ScriptRunning and task.wait(1) do
        local detectedBiome = GetAccurateServerBiome()
        NyXConfig.CurrentDetectedBiome = detectedBiome
        local uptimeStr = GetMacroUptime()
        BiomeStatusLabel:Set("🌍 Biome: " .. detectedBiome .. " | ⏱️ Uptime: " .. uptimeStr)

        -- Đã lược bỏ hàm ApplyMenuLiquidGlass khỏi vòng lặp mỗi giây để chống tụt FPS/lag máy

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
                    Title = "🛑 Stop Auto in!",
                    Content = "Đã gặp " .. detectedBiome .. "! Tạm dừng dùng Item cho đến khi hết Biome.",
                    Duration = 4
                })
            end
        end
    end
end)

-- 2. Vòng lặp Detect Merchant (Mari & Jester)
task.spawn(function()
    local merchantSpawned = false
    while ScriptRunning and task.wait(2.5) do
        if NyXConfig.EnableMerchantWebhook then
            pcall(function()
                local foundMerchant = nil
                for _, obj in pairs(Workspace:GetChildren()) do
                    local nameUpper = obj.Name:upper()
                    if string.find(nameUpper, "MARI") or string.find(nameUpper, "JESTER") or string.find(nameUpper, "MERCHANT") then
                        foundMerchant = obj.Name
                        break
                    end
                end

                if foundMerchant and not merchantSpawned then
                    merchantSpawned = true
                    local isJester = string.find(foundMerchant:upper(), "JESTER")
                    SendBiomeStartedEmbed(
                        "Merchant (" .. foundMerchant .. ")",
                        isJester and 0x9B59B6 or 0x2ECC71,
                        isJester and "Everyone" or "Normal",
                        "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"
                    )
                elseif not foundMerchant then
                    merchantSpawned = false
                end
            end)
        end
    end
end)

-- 3. Vòng lặp Auto Biome Randomizer & Strange Controller
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
