-- // PROJECT NyX - SOLS RNG ULTIMATE MACRO (LIQUID GLASS EDITION)
-- // Tối ưu hóa cho Argon Executor | Đã Fix Bug Detect Biome & Smart Fishing

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

-- // Biến kiểm soát trạng thái sống của Script (Dùng cho Uninstall)
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

-- Sắp xếp ưu tiên tên dài trước để tránh quét nhầm chữ (VD: "THE RADIANT FOREST" trước "LOST FOREST")
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

-- // Biến lưu trữ Cấu hình (Settings)
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
    
    -- Cấu hình Fishsol Macro
    AutoCast = false,
    AutoSellFish = false,
    SellAtAmount = 25, -- Số lượng cá trong kho để tự động bán
    CurrentFishCount = 0,
    
    -- Cấu hình Liquid Glass UI
    LiquidGlassEnabled = true,
    GlassTransparency = 0.25,
    BlurSize = 12
}

for _, bName in ipairs(All16Biomes) do
    NyXConfig.StopAutoBiomes[bName] = false
end

-- // Anti-AFK Connection (Có thể ngắt khi Uninstall)
local IdledConnection = LocalPlayer.Idled:Connect(function()
    if not ScriptRunning then return end
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- // HIỆU ỨNG LIQUID GLASS UI (KÍNH MỜ TRONG SUỐT)
-- ==========================================
local NyXBlur = Lighting:FindFirstChild("NyXLiquidBlur") or Instance.new("BlurEffect")
NyXBlur.Name = "NyXLiquidBlur"
NyXBlur.Size = 0
NyXBlur.Parent = Lighting

local function ApplyLiquidGlass(enabled, transparency, blurStrength)
    pcall(function()
        NyXBlur.Size = enabled and blurStrength or 0
        -- Quét UI Rayfield trong CoreGui hoặc PlayerGui để làm hiệu ứng kính trong suốt
        local targetGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
        if targetGui then
            for _, obj in pairs(targetGui:GetDescendants()) do
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "Topbar" or obj.Name == "Elements") then
                    obj.BackgroundTransparency = enabled and transparency or 0
                elseif obj:IsA("UIStroke") then
                    obj.Transparency = enabled and 0.4 or 0
                    obj.Color = enabled and Color3.fromRGB(190, 140, 255) or obj.Color
                end
            end
        end
    end)
end

-- ==========================================
-- // HỆ THỐNG EMBED TỐI ƯU NHỎ GỌN (COMPACT EMBED)
-- ==========================================
local function SendBiomeStartedEmbed(biomeName, color, pingType, imageUrl)
    if NyXConfig.WebhookURL == "" then return end
    
    local contentMsg = ""
    if pingType == "Everyone" then
        contentMsg = "@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")
    elseif NyXConfig.DiscordID ~= "" and pingType == "UserPing" then
        contentMsg = "<@" .. NyXConfig.DiscordID .. ">"
    end

    local psDisplay = NyXConfig.PrivateServerLink ~= "" and ("[Click to Join](" .. NyXConfig.PrivateServerLink .. ")") or "`None`"

    local embedData = {
        ["content"] = contentMsg,
        ["embeds"] = {{
            ["title"] = "Biome Started - " .. biomeName,
            ["description"] = "**Private Server :** " .. psDisplay,
            ["color"] = color or 0x9B59B6,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "Project NyX"}
        }}
    }

    local req = (syn and syn.request) or http_request or request or HttpPost
    if req then
        pcall(function()
            req({
                Url = NyXConfig.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(embedData)
            })
        end)
    end
end

local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
    if NyXConfig.WebhookURL == "" then return end

    local embedData = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Biome Ended - " .. biomeName,
            ["color"] = color or 0x555555,
            ["thumbnail"] = {["url"] = imageUrl},
            ["footer"] = {["text"] = "Project NyX"}
        }}
    }

    local req = (syn and syn.request) or http_request or request or HttpPost
    if req then
        pcall(function()
            req({
                Url = NyXConfig.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(embedData)
            })
        end)
    end
end

-- ==========================================
-- // HÀM TƯƠNG TÁC GAME (BYPASS INVENTORY & ĐẾM SLOT CÁ)
-- ==========================================
local function FireItemRemote(itemName, extraArg)
    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
        local UseItemRemote = Remotes:FindFirstChild("UseItem") or Remotes:FindFirstChild("ItemRemote") or Remotes:FindFirstChild("InventoryRemote")
        if UseItemRemote then
            if extraArg then
                UseItemRemote:FireServer(itemName, extraArg)
            else
                UseItemRemote:FireServer(itemName)
            end
        end
    end)
end

-- Hàm đọc số lượng cá hiện tại trong kho (Inventory Slot Counter)
local function GetCurrentFishInventoryCount()
    local count = 0
    pcall(function()
        -- Cách 1: Kiểm tra dữ liệu Inventory/FishFolder của Player
        local fishData = LocalPlayer:FindFirstChild("FishInventory") or LocalPlayer:FindFirstChild("Inventory") or (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Fish"))
        if fishData then
            count = #fishData:GetChildren()
            return
        end

        -- Cách 2: Đọc từ UI kho cá hoặc đếm số item cá trong Backpack
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and (v.Name == "FishCount" or v.Name == "InventorySlots" or v.Name == "SlotCount") then
                local currentNum = string.match(v.Text, "(%d+)%s*/%s*%d+") or string.match(v.Text, "%d+")
                if currentNum then
                    count = tonumber(currentNum) or 0
                    return
                end
            end
        end

        -- Cách 3: Đếm trực tiếp số item cá nằm trong Backpack
        if LocalPlayer:FindFirstChild("Backpack") then
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item:GetAttribute("IsFish") or string.find(item.Name:lower(), "fish") then
                    count = count + 1
                end
            end
        end
    end)
    return count
end

-- Hàm Bán Cá trực tiếp không cần mở Inventory
local function ExecuteInstantSellFish()
    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
        local SellRemote = Remotes:FindFirstChild("SellFish") or Remotes:FindFirstChild("SellAll") or Remotes:FindFirstChild("FishingRemote") or Remotes:FindFirstChild("MerchantRemote")
        if SellRemote then
            SellRemote:FireServer("SellAll")
            SellRemote:FireServer("Sell")
        end
    end)
end

-- ==========================================
-- // HÀM QUÉT BIOME ĐÃ FIX TOÀN BỘ BUG
-- ==========================================
local function GetAccurateServerBiome()
    local foundBiome = "NORMAL"
    pcall(function()
        -- Bước 1: Ưu tiên đọc từ Attribute hoặc Value của Server (Chính xác 100% không sợ lỗi UI)
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

        -- Bước 2: Quét trên HUD chính (Loại trừ hoàn toàn Inventory/Backpack/Chat để không dính bug đọc nhầm tên Item)
        for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible and v.Text ~= "" then
                local fullName = v:GetFullName():upper()
                -- Bỏ qua nếu TextLabel nằm trong Inventory, Backpack, Shop, Chat hoặc chính UI Rayfield
                if not string.find(fullName, "INVENTORY") 
                   and not string.find(fullName, "BACKPACK") 
                   and not string.find(fullName, "RAYFIELD") 
                   and not string.find(fullName, "CHAT") 
                   and not string.find(fullName, "SHOP") then
                    
                    local textUpper = v.Text:upper()
                    -- Chỉ xét các TextLabel ngắn hiển thị trạng thái Biome trên HUD
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
-- // KHỞI TẠO MENU GIAO DIỆN: PROJECT NyX
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "🌌 Project NyX | Liquid Glass Edition",
    LoadingTitle = "Project NyX",
    LoadingSubtitle = "Smart Biome & Fishsol Macro",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ProjectNyX",
        FileName = "NyXConfig"
    },
    KeySystem = false
})

-- Kích hoạt hiệu ứng Liquid Glass ngay khi mở Menu
task.spawn(function()
    task.wait(1)
    ApplyLiquidGlass(NyXConfig.LiquidGlassEnabled, NyXConfig.GlassTransparency, NyXConfig.BlurSize)
end)

-- ==========================================
-- // PHẦN 1: WEBHOOK TAB
-- ==========================================
local WebhookTab = Window:CreateTab("🌐 Webhook", 4483362458)
WebhookTab:CreateSection("Kết nối Discord & Private Server")

WebhookTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "Dán link Discord Webhook...",
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

WebhookTab:CreateSection("Chức năng Tự động Thông báo")

local BiomeStatusLabel = WebhookTab:CreateLabel("🌍 Biome Hiện Tại: Đang quét...")

WebhookTab:CreateToggle({
    Name = "Bật Detect Biome (Started & Ended)",
    CurrentValue = false,
    Flag = "ToggleBiomeWebhook",
    Callback = function(Value) NyXConfig.EnableBiomeWebhook = Value end,
})

WebhookTab:CreateToggle({
    Name = "Bật Detect Merchant (Mari / Jester)",
    CurrentValue = false,
    Flag = "ToggleMerchantWebhook",
    Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end,
})

WebhookTab:CreateSection("Test Embed Nhỏ Gọn")

WebhookTab:CreateButton({
    Name = "🔔 Test Biome Started (Có @everyone)",
    Callback = function()
        local info = BiomeData["GLITCHED"]
        SendBiomeStartedEmbed("GLITCHED", info.Color, "Everyone", info.Image)
        Rayfield:Notify({Title = "Project NyX", Content = "Đã gửi Test Started (Glitched)!", Duration = 2})
    end,
})

WebhookTab:CreateButton({
    Name = "🔔 Test Biome Started (Message Thường)",
    Callback = function()
        local info = BiomeData["NULL"]
        SendBiomeStartedEmbed("NULL", info.Color, "Normal", info.Image)
        Rayfield:Notify({Title = "Project NyX", Content = "Đã gửi Test Started (Null)!", Duration = 2})
    end,
})

WebhookTab:CreateButton({
    Name = "🔕 Test Biome Ended (Gọn, Không PS)",
    Callback = function()
        local info = BiomeData["GLITCHED"]
        SendBiomeEndedEmbed("GLITCHED", info.Color, info.Image)
        Rayfield:Notify({Title = "Project NyX", Content = "Đã gửi Test Ended!", Duration = 2})
    end,
})

-- ==========================================
-- // PHẦN 2: INVENTORY TAB
-- ==========================================
local InventoryTab = Window:CreateTab("🎒 Inventory", 4483362458)
InventoryTab:CreateSection("Auto Biome Randomizer & Strange Controller")

InventoryTab:CreateButton({
    Name = "🎲 Dùng ngay: Biome Randomizer",
    Callback = function()
        FireItemRemote("Biome Randomizer")
        Rayfield:Notify({Title = "Project NyX", Content = "Đã dùng Biome Randomizer!", Duration = 2})
    end,
})

InventoryTab:CreateButton({
    Name = "🕹️ Dùng ngay: Strange Controller",
    Callback = function()
        FireItemRemote("Strange Controller")
        Rayfield:Notify({Title = "Project NyX", Content = "Đã dùng Strange Controller!", Duration = 2})
    end,
})

InventoryTab:CreateToggle({
    Name = "Auto Biome Randomizer",
    CurrentValue = false,
    Flag = "AutoBR",
    Callback = function(Value) NyXConfig.AutoBiomeRandomizer = Value end,
})

InventoryTab:CreateToggle({
    Name = "Auto Strange Controller",
    CurrentValue = false,
    Flag = "AutoSC",
    Callback = function(Value) NyXConfig.AutoStrangeController = Value end,
})

InventoryTab:CreateSection("🛑 Stop Auto in (Tự dừng Random khi gặp Biome)")

InventoryTab:CreateDropdown({
    Name = "Stop Auto in (Chọn các Biome muốn giữ lại)",
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

InventoryTab:CreateSection("✨ 16 Nút Chọn Nhanh Biome (Biome Selector)")

for index, biomeName in ipairs(All16Biomes) do
    InventoryTab:CreateButton({
        Name = "[" .. index .. "] Chọn Biome: " .. biomeName,
        Callback = function()
            FireItemRemote("Biome Selector", biomeName)
            Rayfield:Notify({Title = "Project NyX", Content = "Đã chọn Biome: " .. biomeName, Duration = 2})
        end,
    })
end

-- ==========================================
-- // PHẦN 3: FISHING TAB (CHUẨN FISHSOL + SELL AT SLOT)
-- ==========================================
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)
FishingTab:CreateSection("Fishsol Macro & Kiểm Soát Kho Cá (Chống Lag)")

local FishSlotLabel = FishingTab:CreateLabel("🐟 Số cá trong kho hiện tại: 0 | Tự bán ở mốc: 25")

FishingTab:CreateToggle({
    Name = "Auto Cast & Catch (Câu tự động chuẩn Fishsol)",
    CurrentValue = false,
    Flag = "AutoCastToggle",
    Callback = function(Value) NyXConfig.AutoCast = Value end,
})

FishingTab:CreateToggle({
    Name = "Auto Sell At (Tự bán khi đạt mốc số cá đã chọn)",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(Value) NyXConfig.AutoSellFish = Value end,
})

FishingTab:CreateSlider({
    Name = "Sell At (Số lượng cá trong Inventory để tự bán)",
    Range = {1, 200},
    Increment = 1,
    Suffix = " con cá",
    CurrentValue = 25,
    Flag = "SellAtSlider",
    Callback = function(Value)
        NyXConfig.SellAtAmount = Value
        FishSlotLabel:Set("🐟 Số cá trong kho hiện tại: " .. NyXConfig.CurrentFishCount .. " | Tự bán ở mốc: " .. NyXConfig.SellAtAmount)
    end,
})

FishingTab:CreateButton({
    Name = "💰 Sell All Fish Ngay Lập Tức (Bypass Inventory)",
    Callback = function()
        ExecuteInstantSellFish()
        NyXConfig.CurrentFishCount = 0
        FishSlotLabel:Set("🐟 Số cá trong kho hiện tại: 0 | Tự bán ở mốc: " .. NyXConfig.SellAtAmount)
        Rayfield:Notify({Title = "Project NyX", Content = "Đã bán sạch cá trong kho!", Duration = 2})
    end,
})

-- ==========================================
-- // PHẦN 4: SETTINGS TAB (LIQUID GLASS & UNINSTALL)
-- ==========================================
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("Giao diện Liquid Glass (Hiệu ứng Kính Mờ)")

SettingsTab:CreateToggle({
    Name = "Bật hiệu ứng Liquid Glass UI",
    CurrentValue = true,
    Flag = "LiquidGlassToggle",
    Callback = function(Value)
        NyXConfig.LiquidGlassEnabled = Value
        ApplyLiquidGlass(Value, NyXConfig.GlassTransparency, NyXConfig.BlurSize)
    end,
})

SettingsTab:CreateSlider({
    Name = "Độ trong suốt Kính (Glass Transparency)",
    Range = {0, 80},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 25,
    Flag = "GlassTransSlider",
    Callback = function(Value)
        NyXConfig.GlassTransparency = Value / 100
        if NyXConfig.LiquidGlassEnabled then
            ApplyLiquidGlass(true, NyXConfig.GlassTransparency, NyXConfig.BlurSize)
        end
    end,
})

SettingsTab:CreateSlider({
    Name = "Độ mờ Nền (Background Blur)",
    Range = {0, 30},
    Increment = 1,
    Suffix = " px",
    CurrentValue = 12,
    Flag = "BlurSizeSlider",
    Callback = function(Value)
        NyXConfig.BlurSize = Value
        if NyXConfig.LiquidGlassEnabled then
            ApplyLiquidGlass(true, NyXConfig.GlassTransparency, NyXConfig.BlurSize)
        end
    end,
})

SettingsTab:CreateSection("Quản lý Script & Hệ thống")

SettingsTab:CreateButton({
    Name = "🗑️ Destroy UI / Uninstall (Tắt hoàn toàn Script)",
    Callback = function()
        -- 1. Dừng toàn bộ vòng lặp
        ScriptRunning = false
        NyXConfig.AutoBiomeRandomizer = false
        NyXConfig.AutoStrangeController = false
        NyXConfig.AutoCast = false
        NyXConfig.AutoSellFish = false
        
        -- 2. Ngắt kết nối Anti-AFK và xóa hiệu ứng Blur
        if IdledConnection then IdledConnection:Disconnect() end
        if NyXBlur then NyXBlur:Destroy() end
        
        -- 3. Hủy giao diện Rayfield
        Rayfield:Destroy()
    end,
})

-- ==========================================
-- // VÒNG LẶP XỬ LÝ NGẦM (ĐÃ TỐI ƯU & CHỐNG BUG)
-- ==========================================

-- 1. Vòng lặp Detect Biome Chuẩn Xác
task.spawn(function()
    local lastBiome = GetAccurateServerBiome()
    NyXConfig.CurrentDetectedBiome = lastBiome
    BiomeStatusLabel:Set("🌍 Biome Hiện Tại: " .. lastBiome)

    while ScriptRunning and task.wait(0.8) do
        local detectedBiome = GetAccurateServerBiome()
        NyXConfig.CurrentDetectedBiome = detectedBiome
        BiomeStatusLabel:Set("🌍 Biome Hiện Tại: " .. detectedBiome)

        if detectedBiome ~= lastBiome then
            local previousBiome = lastBiome
            lastBiome = detectedBiome

            if NyXConfig.EnableBiomeWebhook then
                -- Nếu Biome cũ kết thúc -> Gửi Embed Ended nhỏ gọn
                if previousBiome ~= "NORMAL" and BiomeData[previousBiome] then
                    local prevInfo = BiomeData[previousBiome]
                    SendBiomeEndedEmbed(previousBiome, prevInfo.Color, prevInfo.Image)
                end

                -- Nếu Biome mới bắt đầu -> Gửi Embed Started
                if detectedBiome ~= "NORMAL" and BiomeData[detectedBiome] then
                    local newInfo = BiomeData[detectedBiome]
                    SendBiomeStartedEmbed(detectedBiome, newInfo.Color, newInfo.Type, newInfo.Image)
                end
            end

            -- Kiểm tra nếu trúng Biome trong Stop Auto in
            if NyXConfig.StopAutoBiomes[detectedBiome] then
                Rayfield:Notify({
                    Title = "🛑 Đã Dừng Auto Randomizer!",
                    Content = "Phát hiện Biome: " .. detectedBiome .. ". Sẽ tự chạy lại khi hết Biome!",
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

-- 3. Vòng lặp Auto Randomizer / Strange Controller (Tự ngắt khi trúng Stop Auto in)
task.spawn(function()
    while ScriptRunning and task.wait(1.5) do
        local currentB = NyXConfig.CurrentDetectedBiome
        local isPausedByBiome = NyXConfig.StopAutoBiomes[currentB] == true

        if not isPausedByBiome then
            if NyXConfig.AutoBiomeRandomizer then
                FireItemRemote("Biome Randomizer")
            end
            if NyXConfig.AutoStrangeController then
                FireItemRemote("Strange Controller")
            end
        end
    end
end)

-- 4. Vòng lặp Fishsol Macro & Smart Sell At Inventory Count
task.spawn(function()
    local internalCatchCounter = 0
    while ScriptRunning and task.wait(1) do
        -- Đọc số cá thực tế từ Inventory, nếu game ẩn thông số thì dùng bộ đếm dự phòng
        local realFishCount = GetCurrentFishInventoryCount()
        if realFishCount > 0 then
            NyXConfig.CurrentFishCount = realFishCount
        else
            NyXConfig.CurrentFishCount = internalCatchCounter
        end

        FishSlotLabel:Set("🐟 Số cá trong kho hiện tại: " .. NyXConfig.CurrentFishCount .. " | Tự bán ở mốc: " .. NyXConfig.SellAtAmount)

        -- Logic Auto Cast & Minigame Bypass kiểu Fishsol
        if NyXConfig.AutoCast then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
                local CastRemote = Remotes:FindFirstChild("Cast") or Remotes:FindFirstChild("FishingRemote") or Remotes:FindFirstChild("FishRemote")
                if CastRemote then
                    CastRemote:FireServer("Cast")
                    task.wait(0.4)
                    CastRemote:FireServer("Catch", true)
                    CastRemote:FireServer("Reel")
                end
                internalCatchCounter = internalCatchCounter + 1
            end)
        end

        -- Logic Kiểm tra mốc Sell At (Chống đầy kho gây lag)
        if NyXConfig.AutoSellFish and NyXConfig.CurrentFishCount >= NyXConfig.SellAtAmount then
            ExecuteInstantSellFish()
            internalCatchCounter = 0
            NyXConfig.CurrentFishCount = 0
            FishSlotLabel:Set("🐟 Số cá trong kho hiện tại: 0 | Tự bán ở mốc: " .. NyXConfig.SellAtAmount)
            Rayfield:Notify({
                Title = "🎣 Auto Sell At Kích Hoạt!",
                Content = "Kho cá đã chạm mốc " .. NyXConfig.SellAtAmount .. " con! Đã tự động bán sạch để chống lag.",
                Duration = 2.5
            })
        end
    end
end)
