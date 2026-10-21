-- // PROJECT NyX - SOLS RNG & FISHING ULTIMATE (POTASSIUM EXECUTOR EDITION)
-- // Tối ưu hóa chuẩn chỉnh cho Potassium Executor

local Success, Result = pcall(function()
return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success then
warn("Rayfield Lib Load Failed: " .. tostring(Result))
return
end

local Rayfield = Result
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ScriptRunning = true

-- // Bảng dữ liệu 16 Biome Eon 1-30 chuẩn xác
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
AutoCast = false,
AutoSellFish = false,
SellAtAmount = 25,
CurrentFishCount = 0,
SavedCheckpoint = nil,
AutoReturnToCheckpoint = true,
LiquidGlassEnabled = true,
GlassTransparency = 0.25,
BlurSize = 12
}

for _, bName in ipairs(All16Biomes) do
NyXConfig.StopAutoBiomes[bName] = false
end

-- Anti-AFK
local IdledConn = LocalPlayer.Idled:Connect(function()
if not ScriptRunning then return end
VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Liquid Glass Effect
local NyXBlur = Lighting:FindFirstChild("NyXPotassiumBlur") or Instance.new("BlurEffect")
NyXBlur.Name = "NyXPotassiumBlur"
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

-- Webhook Request tương thích chuẩn Potassium
local function SendDiscordEmbed(title, desc, color, pingType, imageUrl, hasPS)
if NyXConfig.WebhookURL == "" then return end
local contentMsg = (pingType == "Everyone") and ("@everyone " .. (NyXConfig.DiscordID ~= "" and ("<@" .. NyXConfig.DiscordID .. ">") or "")) or ""
local descText = hasPS and ("Private Server : " .. (NyXConfig.PrivateServerLink ~= "" and ("[Click to Join](" .. NyXConfig.PrivateServerLink .. ")") or "None")) or desc

local embedData = {
    ["content"] = contentMsg,
    ["embeds"] = {{
        ["title"] = title,
        ["description"] = descText,
        ["color"] = color or 0x9B59B6,
        ["thumbnail"] = {["url"] = imageUrl or BiomeData["NORMAL"].Image},
        ["footer"] = {["text"] = "Project NyX • Potassium Edition"}
    }}
}

local reqFunc = (syn and syn.request) or http_request or request
if reqFunc then
    pcall(function()
        reqFunc({
            Url = NyXConfig.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(embedData)
        })
    end)
end


end

-- Fire Remote Game
local function FireGameRemote(remoteName, ...)
pcall(function()
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
local remote = remotesFolder:FindFirstChild(remoteName, true)
if remote then
if remote:IsA("RemoteEvent") then remote:FireServer(...)
elseif remote:IsA("RemoteFunction") then remote:InvokeServer(...) end
end
end)
end

-- Detect Biome
local function GetTrueGameBiome()
local detected = "NORMAL"
pcall(function()
for _, obj in pairs({Workspace, ReplicatedStorage, LocalPlayer}) do
local attr = obj:GetAttribute("Biome") or obj:GetAttribute("CurrentBiome")
if type(attr) == "string" then
local upper = attr:upper()
for bName, _ in pairs(BiomeData) do
if string.find(upper, bName, 1, true) then return bName end
end
end
end
end)
return detected
end

-- UI Khởi tạo
local Window = Rayfield:CreateWindow({
Name = "🌌 Project NyX | Potassium Edition",
LoadingTitle = "Project NyX Engine",
LoadingSubtitle = "Potassium Executor Hook",
ConfigurationSaving = { Enabled = true, FolderName = "ProjectNyXPotassium", FileName = "Config" },
KeySystem = false
})

task.spawn(function()
task.wait(1)
ApplyLiquidGlass(NyXConfig.LiquidGlassEnabled, NyXConfig.GlassTransparency)
end)

-- TAB 1: WEBHOOK
local WebhookTab = Window:CreateTab("🌐 Webhook", 4483362458)
WebhookTab:CreateSection("Cấu hình Discord")
WebhookTab:CreateInput({Name = "Webhook URL", PlaceholderText = "Dán link Discord Webhook...", RemoveTextAfterFocusLost = false, Callback = function(Text) NyXConfig.WebhookURL = Text end})
WebhookTab:CreateInput({Name = "Discord ID", PlaceholderText = "VD: 123456789012345678", RemoveTextAfterFocusLost = false, Callback = function(Text) NyXConfig.DiscordID = Text end})
WebhookTab:CreateInput({Name = "Link Private Server", PlaceholderText = "https://www.roblox.com/games/...", RemoveTextAfterFocusLost = false, Callback = function(Text) NyXConfig.PrivateServerLink = Text end})

WebhookTab:CreateSection("Trạng thái & Detect")
local CurrentBiomeLabel = WebhookTab:CreateLabel("🌍 Biome Hiện Tại: Đang khởi tạo...")
WebhookTab:CreateToggle({Name = "Bật Detect Biome (Started & Ended)", CurrentValue = false, Callback = function(Value) NyXConfig.EnableBiomeWebhook = Value end})
WebhookTab:CreateToggle({Name = "Bật Detect Merchant (Mari / Jester)", CurrentValue = false, Callback = function(Value) NyXConfig.EnableMerchantWebhook = Value end})
WebhookTab:CreateButton({Name = "🔔 Test Webhook Embed", Callback = function() SendDiscordEmbed("Biome Started - GLITCHED", "", 0x228855, "Everyone", BiomeData["GLITCHED"].Image, true) end})

-- TAB 2: INVENTORY
local InventoryTab = Window:CreateTab("🎒 Inventory", 4483362458)
InventoryTab:CreateSection("Randomizer & Strange Controller")
InventoryTab:CreateButton({Name = "🎲 Dùng ngay: Biome Randomizer", Callback = function() FireGameRemote("UseItem", "Biome Randomizer") end})
InventoryTab:CreateButton({Name = "🕹️ Dùng ngay: Strange Controller", Callback = function() FireGameRemote("UseItem", "Strange Controller") end})
InventoryTab:CreateToggle({Name = "Auto Biome Randomizer", CurrentValue = false, Callback = function(Value) NyXConfig.AutoBiomeRandomizer = Value end})
InventoryTab:CreateToggle({Name = "Auto Strange Controller", CurrentValue = false, Callback = function(Value) NyXConfig.AutoStrangeController = Value end})

InventoryTab:CreateSection("🛑 Stop Auto in (Dừng Random khi trúng Biome)")
InventoryTab:CreateDropdown({Name = "Chọn Biome cần giữ lại", Options = All16Biomes, CurrentOption = {"GLITCHED", "DREAMSPACE", "CYBERSPACE"}, MultipleOptions = true, Callback = function(Selected)
for _, b in ipairs(All16Biomes) do NyXConfig.StopAutoBiomes[b] = false end
for _, b in ipairs(Selected) do NyXConfig.StopAutoBiomes[b] = true end
end})

InventoryTab:CreateSection("✨ 16 Nút Chọn Biome Trực Tiếp")
for i, bName in ipairs(All16Biomes) do
InventoryTab:CreateButton({Name = "["..i.."] Selector -> " .. bName, Callback = function() FireGameRemote("UseItem", "Biome Selector", bName) end})
end

-- TAB 3: FISHING
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)
FishingTab:CreateSection("Checkpoint & Fishsol Macro")
local FishCountLabel = FishingTab:CreateLabel("🐟 Số cá câu được: 0 | Mốc tự bán: 25")

FishingTab:CreateButton({Name = "📍 Set Checkpoint (Lưu vị trí câu cá)", Callback = function()
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
NyXConfig.SavedCheckpoint = hrp.CFrame
Rayfield:Notify({Title = "Checkpoint Saved!", Content = "Đã lưu tọa độ câu cá thành công!", Duration = 2.5})
end
end})

FishingTab:CreateToggle({Name = "Auto Return to Checkpoint", CurrentValue = true, Callback = function(Value) NyXConfig.AutoReturnToCheckpoint = Value end})
FishingTab:CreateToggle({Name = "Auto Cast & Catch", CurrentValue = false, Callback = function(Value) NyXConfig.AutoCast = Value end})
FishingTab:CreateToggle({Name = "Auto Sell At", CurrentValue = false, Callback = function(Value) NyXConfig.AutoSellFish = Value end})
FishingTab:CreateSlider({Name = "Sell At (Số lượng cá)", Range = {1, 200}, Increment = 1, Suffix = " con", CurrentValue = 25, Callback = function(Val) NyXConfig.SellAtAmount = Val end})
FishingTab:CreateButton({Name = "💰 Bán Cá Ngay Lập Tức", Callback = function() FireGameRemote("SellAll") end})

-- TAB 4: SETTINGS
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("Giao diện Liquid Glass")
SettingsTab:CreateToggle({Name = "Bật hiệu ứng Kính Mờ", CurrentValue = true, Callback = function(Value)
NyXConfig.LiquidGlassEnabled = Value
ApplyLiquidGlass(Value, NyXConfig.GlassTransparency)
end})
SettingsTab:CreateSlider({Name = "Độ mờ nền UI", Range = {0, 80}, Increment = 5, Suffix = "%", CurrentValue = 25, Callback = function(Val)
NyXConfig.GlassTransparency = Val / 100
if NyXConfig.LiquidGlassEnabled then ApplyLiquidGlass(true, NyXConfig.GlassTransparency) end
end})

SettingsTab:CreateSection("Quản lý Script")
SettingsTab:CreateButton({Name = "🗑️ Destroy UI / Uninstall", Callback = function()
ScriptRunning = false
if IdledConn then IdledConn:Disconnect() end
if NyXBlur then NyXBlur:Destroy() end
Rayfield:Destroy()
end})

-- VÒNG LẶP NGẦM
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

task.spawn(function()
while ScriptRunning and task.wait(1.5) do
local activeBiome = NyXConfig.CurrentDetectedBiome
if not NyXConfig.StopAutoBiomes[activeBiome] then
if NyXConfig.AutoBiomeRandomizer then FireGameRemote("UseItem", "Biome Randomizer") end
if NyXConfig.AutoStrangeController then FireGameRemote("UseItem", "Strange Controller") end
end
end
end)

task.spawn(function()
local fishCounter = 0
while ScriptRunning and task.wait(1) do
if NyXConfig.AutoReturnToCheckpoint and NyXConfig.SavedCheckpoint then
pcall(function()
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp and (hrp.Position - NyXConfig.SavedCheckpoint.Position).Magnitude > 15 then
hrp.CFrame = NyXConfig.SavedCheckpoint
end
end)
end
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
if NyXConfig.AutoSellFish and fishCounter >= NyXConfig.SellAtAmount then
FireGameRemote("SellAll")
fishCounter = 0
end
FishCountLabel:Set("🐟 Số cá câu được: " .. fishCounter .. " | Mốc tự bán: " .. NyXConfig.SellAtAmount)
end
end)
