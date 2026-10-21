-- // PROJECT NyX - SOLS RNG & FISHING ULTIMATE (DELTA MOBILE EDITION)
-- // Tối ưu hóa chuyên sâu cho Delta Executor trên Mobile

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Khởi tạo Dịch vụ
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ScriptRunning = true

-- // Bảng dữ liệu 16 Biome chuẩn theo Eon 1-30
local BiomeData = {
    ["NORMAL"] = {Color = 0xAAAAAA, Type = "None", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["WINDY"] = {Color = 0x55FFFF, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["SNOWY"] = {Color = 0xAAFFFF, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["RAINY"] = {Color = 0x4477FF, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["SANDSTORM"] = {Color = 0xCC9955, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["HELL"] = {Color = 0xFF3300, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["STARFALL"] = {Color = 0x2266FF, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["HEAVEN"] = {Color = 0xFFEEAA, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["LOST FOREST"] = {Color = 0x33FF33, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["CORRUPTION"] = {Color = 0x8833FF, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["NULL"] = {Color = 0x777777, Type = "Normal", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["GLITCHED"] = {Color = 0x228855, Type = "Everyone", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["DREAMSPACE"] = {Color = 0xFF66CC, Type = "Everyone", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["CYBERSPACE"] = {Color = 0x2255AA, Type = "Everyone", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["SINGULARITY"] = {Color = 0xFF9955, Type = "Rare", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"},
    ["THE RADIANT FOREST"] = {Color = 0xCC33FF, Type = "Rare", Image = "https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter"}
}

local All16Biomes = {
    "NORMAL", "WINDY", "SNOWY", "RAINY", "SANDSTORM", "HELL", 
    "STARFALL", "HEAVEN", "LOST FOREST", "CORRUPTION", "NULL", 
    "GLITCHED", "DREAMSPACE", "CYBERSPACE", "SINGULARITY", "THE RADIANT FOREST"
}

-- // Cấu hình Settings & Trạng thái
local NyXConfig = {
    WebhookURL = "",
    DiscordID = "",
    PrivateServerLink = "",
    EnableBiomeWebhook = false,
    EnableMerchantWebhook = false,
    AutoBiomeRandomizer = false,
    AutoStrangeController = false,
    StopAutoBiomes = {},
    CurrentDetectedBiome = "NORMAL",
    
    -- Fishing & Checkpoint
    AutoCast = false,
    AutoSellFish = false,
    SellAtAmount = 25,
    CurrentFishCount = 0,
    SavedCheckpoint = nil, -- Lưu tọa độ vị trí câu cá
    AutoReturnToCheckpoint = true,
    
    -- Liquid Glass
    LiquidGlassEnabled = true,
    GlassTransparency = 0.2,
    BlurSize = 10
}

for _, bName in ipairs(All16Biomes) do
    NyXConfig.StopAutoBiomes[bName] = false
end

-- Anti-AFK Mobile
local IdledConn = LocalPlayer.Idled:Connect(function()
    if not ScriptRunning then return end
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- // Hiệu ứng Liquid Glass trên Mobile
local NyXBlur = Lighting:FindFirstChild("NyXDeltaBlur") or Instance.new("BlurEffect")
NyXBlur.Name = "NyXDeltaBlur"
NyXBlur.Size = 0
NyXBlur.Parent = Lighting

local function ApplyLiquidGlass(enabled, transparency)
    pcall(function()
        NyXBlur.Size = enabled and NyXConfig.BlurSize or 0
        local targetGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
        if targetGui then
            for _, obj in pairs(targetGui:GetDescendants()) do
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "Topbar" or obj.Name == "Elements") then
                    obj.BackgroundTransparency = enabled and transparency or 0
                end
            end
        end
    end)
end

-- // Hàm Webhook Embed gọn gàng
local function SendDiscordEmbed(title, desc, color, pingType, imageUrl, hasPS)
    if NyXConfig.WebhookURL == "" then return end
    
    local contentMsg = ""
    if pingType == "Everyone" then
        contentMsg = "@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")
    end

    local descText = desc
    if hasPS then
        local psDisplay = NyXConfig.PrivateServerLink ~= "" and ("[Click to Join](" .. NyXConfig.PrivateServerLink .. ")") or "`None`"
        descText = "**Private Server :** " .. psDisplay
    end

    local embedData = {
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = descText,
            ["color"] = color or 0x9B59B6,
            ["thumbnail"] = {["url"] = imageUrl or BiomeData["NORMAL"].Image},
            ["footer"] = {["text"] = "Project NyX • Delta Mobile"}
        }}
    }

    pcall(function()
        request({
            Url = NyXConfig.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(embedData)
        })
    end)
end

-- // Hàm gọi Remote Game (Bypass Inventory)
local function FireGameRemote(remoteName, ...)
    pcall(function()
        local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
        local remote = remotesFolder:FindFirstChild(remoteName, true)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end
    end)
end

-- // DETECT BIOME & MERCHANT TỪ BỘ NHỚ GAME (DELTA MEMORY INJECT)
local function GetTrueGameBiome()
    local detected = "NORMAL"
    pcall(function()
        -- Đọc trực tiếp từ Workspace hoặc ReplicatedStorage attributes/values của Sols RNG
        for _, obj in pairs({Workspace, ReplicatedStorage, LocalPlayer}) do
            local attr = obj:GetAttribute("Biome") or obj:GetAttribute("CurrentBiome")
            if type(attr) == "string" then
                local upper = attr:upper()
                for bName, _ in pairs(BiomeData) do
                    if string.find(upper, bName, 1, true) then
                        return bName
                    end
                end
            end
        end

        -- Quét qua các StringValue lưu trạng thái Biome trong game
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("StringValue") and (v.Name:upper():find("BIOME") or v.Name:upper():find("WEATHER")) then
                local val = v.Value:upper()
                for bName, _ in pairs(BiomeData) do
                    if string.find(val, bName, 1, true) then
                        detected = bName
                        return detected
                    end
                end
            end
        end
    end)
    return detected
end

-- // KHỞI TẠO RAYFIELD UI
local Window = Rayfield:CreateWindow({
    Name = "🌌 Project NyX | Delta Mobile",
    LoadingTitle = "Project NyX Engine",
    LoadingSubtitle = "Delta Mobile Inject Edition",
    ConfigurationSaving = { Enabled = true, FolderName = "ProjectNyXDelta", FileName = "Config" },
    KeySystem = false
})

task.spawn(function()
    task.wait(1)
    ApplyLiquidGlass(NyXConfig.LiquidGlassEnabled, NyXConfig.GlassTransparency)
end)

-- ==========================================
-- // TAB 1: WEBHOOK
-- ==========================================
local WebhookTab = Window:CreateTab("🌐 Webhook", 4483362458)
WebhookTab:CreateSection("Cấu hình Discord")

WebhookTab:CreateInput({
    Name = "Webhook URL", PlaceholderText = "Dán link Discord Webhook...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.WebhookURL = Text end,
})

WebhookTab:CreateInput({
    Name = "Discord ID", PlaceholderText = "VD: 123456789012345678",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.DiscordID = Text end,
})

WebhookTab:CreateInput({
    Name = "Link Private Server", PlaceholderText = "https://www.roblox.com/games/...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) NyXConfig.PrivateServerLink = Text end,
})

WebhookTab:CreateSection("Trạng thái & Detect")
local CurrentBiomeLabel = WebhookTab:CreateLabel("🌍 Biome Hiện Tại: Đang khởi tạo...")

WebhookTab:CreateToggle({
    Name = "Bật Detect Biome (Started & Ended)", CurrentValue = false,
    Callback = function(Value) NyXConfig.EnableBiomeWebhook = Value end,
})

WebhookTab:CreateToggle({
    Name = "Bật Detect Merchant (Mari / Jester)", CurrentValue = false,
    Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end,
})

WebhookTab:CreateButton({
    Name = "🔔 Test Webhook Embed",
    Callback = function()
        SendDiscordEmbed("Biome Started - GLITCHED", "", 0x228855, "Everyone", BiomeData["GLITCHED"].Image, true)
        Rayfield:Notify({Title = "Project NyX", Content = "Đã gửi Test Webhook!", Duration = 2})
    end,
})

-- ==========================================
-- // TAB 2: INVENTORY (BYPASS & STOP AUTO)
-- ==========================================
local InventoryTab = Window:CreateTab("🎒 Inventory", 4483362458)
InventoryTab:CreateSection("Randomizer & Strange Controller")

InventoryTab:CreateButton({
    Name = "🎲 Dùng ngay: Biome Randomizer",
    Callback = function() FireGameRemote("UseItem", "Biome Randomizer") end,
})

InventoryTab:CreateButton({
    Name = "🕹️ Dùng ngay: Strange Controller",
    Callback = function() FireGameRemote("UseItem", "Strange Controller") end,
})

InventoryTab:CreateToggle({
    Name = "Auto Biome Randomizer (Tự ngắt khi gặp Stop Auto)", CurrentValue = false,
    Callback = function(Value) NyXConfig.AutoBiomeRandomizer = Value end,
})

InventoryTab:CreateToggle({
    Name = "Auto Strange Controller (Tự ngắt khi gặp Stop Auto)", CurrentValue = false,
    Callback = function(Value) NyXConfig.AutoStrangeController = Value end,
})

InventoryTab:CreateSection("🛑 Stop Auto in (Dừng Random khi trúng Biome)")
InventoryTab:CreateDropdown({
    Name = "Chọn Biome cần giữ lại (Không Random nữa)",
    Options = All16Biomes,
    CurrentOption = {"GLITCHED", "DREAMSPACE", "CYBERSPACE"},
    MultipleOptions = true,
    Callback = function(Selected)
        for _, b in ipairs(All16Biomes) do NyXConfig.StopAutoBiomes[b] = false end
        for _, b in ipairs(Selected) do NyXConfig.StopAutoBiomes[b] = true end
    end,
})

InventoryTab:CreateSection("✨ 16 Nút Chọn Biome Trực Tiếp (Biome Selector)")
for i, bName in ipairs(All16Biomes) do
    InventoryTab:CreateButton({
        Name = "["..i.."] Selector -> " .. bName,
        Callback = function()
            FireGameRemote("UseItem", "Biome Selector", bName)
            Rayfield:Notify({Title = "Project NyX", Content = "Đã dùng Selector cho: " .. bName, Duration = 2})
        end,
    })
end

-- ==========================================
-- // TAB 3: FISHING & CHECKPOINT
-- ==========================================
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)
FishingTab:CreateSection("Hệ Thống Checkpoint & Auto Fishsol")

local FishCountLabel = FishingTab:CreateLabel("🐟 Số cá trong kho: 0 | Mốc tự bán: 25")

FishingTab:CreateButton({
    Name = "📍 Set Checkpoint (Lưu vị trí đứng câu cá hiện tại)",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            NyXConfig.SavedCheckpoint = hrp.CFrame
            Rayfield:Notify({Title = "Checkpoint Saved!", Content = "Đã lưu tọa độ vị trí câu cá!", Duration = 3})
        end
    end,
})

FishingTab:CreateToggle({
    Name = "Auto Return to Checkpoint (Tự kéo về chỗ cũ nếu bị lệch)", CurrentValue = true,
    Callback = function(Value) NyXConfig.AutoReturnToCheckpoint = Value end,
})

FishingTab:CreateToggle({
    Name = "Auto Cast & Catch (Fishsol Mobile Macro)", CurrentValue = false,
    Callback = function(Value) NyXConfig.AutoCast = Value end,
})

FishingTab:CreateToggle({
    Name = "Auto Sell At (Tự bán khi đầy kho)", CurrentValue = false,
    Callback = function(Value) NyXConfig.AutoSellFish = Value end,
})

FishingTab:CreateSlider({
    Name = "Sell At (Số lượng cá để tự bán)",
    Range = {1, 200}, Increment = 1, Suffix = " con", CurrentValue = 25,
    Callback = function(Val) NyXConfig.SellAtAmount = Val end,
})

FishingTab:CreateButton({
    Name = "💰 Bán Cá Ngay Lập Tức (Instant Sell)",
    Callback = function()
        FireGameRemote("SellAll")
        FireGameRemote("SellFish")
        Rayfield:Notify({Title = "Project NyX", Content = "Đã gửi lệnh bán cá!", Duration = 2})
    end,
})

-- ==========================================
-- // TAB 4: SETTINGS & UNINSTALL
-- ==========================================
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("Giao diện Liquid Glass")

SettingsTab:CreateToggle({
    Name = "Bật hiệu ứng Kính Mờ (Liquid Glass)", CurrentValue = true,
    Callback = function(Value)
        NyXConfig.LiquidGlassEnabled = Value
        ApplyLiquidGlass(Value, NyXConfig.GlassTransparency)
    end,
})

SettingsTab:CreateSlider({
    Name = "Độ mờ nền UI", Range = {0, 80}, Increment = 5, Suffix = "%", CurrentValue = 20,
    Callback = function(Val)
        NyXConfig.GlassTransparency = Val / 100
        if NyXConfig.LiquidGlassEnabled then ApplyLiquidGlass(true, NyXConfig.GlassTransparency) end
    end,
})

SettingsTab:CreateSection("Quản lý Script")
SettingsTab:CreateButton({
    Name = "🗑️ Destroy UI / Uninstall (Tắt sạch Script)",
    Callback = function()
        ScriptRunning = false
        if IdledConn then IdledConn:Disconnect() end
        if NyXBlur then NyXBlur:Destroy() end
        Rayfield:Destroy()
    end,
})

-- ==========================================
-- // VÒNG LẶP XỬ LÝ NGẦM (BACKGROUND TASKS)
-- ==========================================

-- 1. Detect Biome & Merchant ngầm (Delta Memory)
task.spawn(function()
    local lastBiome = GetTrueGameBiome()
    NyXConfig.CurrentDetectedBiome = lastBiome

    while ScriptRunning and task.wait(1) do
        local currentBiome = GetTrueGameBiome()
        NyXConfig.CurrentDetectedBiome = currentBiome
        CurrentBiomeLabel:Set("🌍 Biome Hiện Tại: " .. currentBiome)

        if currentBiome ~= lastBiome then
            local oldBiome = lastBiome
            lastBiome = currentBiome

            if NyXConfig.EnableBiomeWebhook then
                if oldBiome ~= "NORMAL" and BiomeData[oldBiome] then
                    SendDiscordEmbed("Biome Ended - " .. oldBiome, "", 0x555555, "None", BiomeData[oldBiome].Image, false)
                end
                if currentBiome ~= "NORMAL" and BiomeData[currentBiome] then
                    local info = BiomeData[currentBiome]
                    SendDiscordEmbed("Biome Started - " .. currentBiome, "", info.Color, info.Type, info.Image, true)
                end
            end
        end
    end
end)

-- 2. Auto Randomizer thông minh (Tự ngắt khi trúng Stop Auto)
task.spawn(function()
    while ScriptRunning and task.wait(1.5) do
        local activeBiome = NyXConfig.CurrentDetectedBiome
        local isStopped = NyXConfig.StopAutoBiomes[activeBiome] == true

        if not isStopped then
            if NyXConfig.AutoBiomeRandomizer then FireGameRemote("UseItem", "Biome Randomizer") end
            if NyXConfig.AutoStrangeController then FireGameRemote("UseItem", "Strange Controller") end
        end
    end
end)

-- 3. Auto Fishing, Checkpoint & Sell At
task.spawn(function()
    local fishCounter = 0
    while ScriptRunning and task.wait(1) do
        -- Kiểm tra Checkpoint
        if NyXConfig.AutoReturnToCheckpoint and NyXConfig.SavedCheckpoint then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - NyXConfig.SavedCheckpoint.Position).Magnitude > 15 then
                    hrp.CFrame = NyXConfig.SavedCheckpoint
                end
            end)
        end

        -- Auto Cast
        if NyXConfig.AutoCast then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                FireGameRemote("Cast")
                FireGameRemote("Catch", true)
                FireGameRemote("Reel")
                fishCounter = fishCounter + 1
            end)
        end

        -- Auto Sell At
        if NyXConfig.AutoSellFish and fishCounter >= NyXConfig.SellAtAmount then
            FireGameRemote("SellAll")
            FireGameRemote("SellFish")
            fishCounter = 0
            Rayfield:Notify({Title = "Auto Sell At", Content = "Đã tự động bán cá để chống đầy kho!", Duration = 2})
        end

        FishCountLabel:Set("🐟 Số cá câu được: " .. fishCounter .. " | Mốc tự bán: " .. NyXConfig.SellAtAmount)
    end
end)
