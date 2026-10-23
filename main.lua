-- // NYX DETECTOR MACRO - PATHFINDING &amp; SMART MERCHANT EDITION
-- // Features: 3-Min Merchant Lifecycle (Arrived/Left) + River-Safe Pathfinding Walk + Custom 16-Biome/3-
Merchant Ping Selector + User Utilities
local Players = game:GetService(&quot;Players&quot;)
local ReplicatedStorage = game:GetService(&quot;ReplicatedStorage&quot;)
local HttpService = game:GetService(&quot;HttpService&quot;)
local VirtualUser = game:GetService(&quot;VirtualUser&quot;)
local VirtualInputManager = game:GetService(&quot;VirtualInputManager&quot;)
local GuiService = game:GetService(&quot;GuiService&quot;)
local Workspace = game:GetService(&quot;Workspace&quot;)
local CoreGui = game:GetService(&quot;CoreGui&quot;)
local UserInputService = game:GetService(&quot;UserInputService&quot;)
local TextChatService = game:GetService(&quot;TextChatService&quot;)
local Lighting = game:GetService(&quot;Lighting&quot;)
local RunService = game:GetService(&quot;RunService&quot;)
local TeleportService = game:GetService(&quot;TeleportService&quot;)
local PathfindingService = game:GetService(&quot;PathfindingService&quot;)
local LocalPlayer = Players.LocalPlayer
local ScriptRunning = true
local MacroStartTime = 0
local ScreenGui = nil
local Notify = function() end
-- // 16 Standard Biomes Data
local BiomeData = {
[&quot;NORMAL&quot;] = {Color = 0xAAAAAA, Hex = Color3.fromRGB(80, 250, 123), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;WINDY&quot;] = {Color = 0x55FFFF, Hex = Color3.fromRGB(85, 255, 255), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},

[&quot;SNOWY&quot;] = {Color = 0xAAFFFF, Hex = Color3.fromRGB(170, 255, 255), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;RAINY&quot;] = {Color = 0x4477FF, Hex = Color3.fromRGB(68, 119, 255), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;SANDSTORM&quot;] = {Color = 0xCC9955, Hex = Color3.fromRGB(235, 180, 90), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;HELL&quot;] = {Color = 0xFF3300, Hex = Color3.fromRGB(255, 65, 35), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;STARFALL&quot;] = {Color = 0x2266FF, Hex = Color3.fromRGB(80, 140, 255), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;HEAVEN&quot;] = {Color = 0xFFEEAA, Hex = Color3.fromRGB(255, 238, 170), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;LOST FOREST&quot;] = {Color = 0x33FF33, Hex = Color3.fromRGB(51, 255, 51), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;CORRUPTION&quot;] = {Color = 0x8833FF, Hex = Color3.fromRGB(165, 90, 255), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;NULL&quot;] = {Color = 0x777777, Hex = Color3.fromRGB(160, 160, 160), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;GLITCHED&quot;] = {Color = 0x228855, Hex = Color3.fromRGB(60, 220, 140), Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;DREAMSPACE&quot;] = {Color = 0xFF66CC, Hex = Color3.fromRGB(255, 102, 204), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;CYBERSPACE&quot;] = {Color = 0x2255AA, Hex = Color3.fromRGB(70, 150, 255), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;SINGULARITY&quot;] = {Color = 0xFF9955, Hex = Color3.fromRGB(255, 153, 85), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;THE RADIANT FOREST&quot;] = {Color = 0xCC33FF, Hex = Color3.fromRGB(204, 51, 255), Image =
&quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;}
}
local NormalizedBiomeLookup = {
[&quot;NORMAL&quot;] = &quot;NORMAL&quot;,
[&quot;WINDY&quot;] = &quot;WINDY&quot;,
[&quot;SNOWY&quot;] = &quot;SNOWY&quot;,
[&quot;RAINY&quot;] = &quot;RAINY&quot;,
[&quot;SANDSTORM&quot;] = &quot;SANDSTORM&quot;,
[&quot;SANDY&quot;] = &quot;SANDSTORM&quot;,
[&quot;HELL&quot;] = &quot;HELL&quot;,
[&quot;STARFALL&quot;] = &quot;STARFALL&quot;,
[&quot;HEAVEN&quot;] = &quot;HEAVEN&quot;,
[&quot;LOSTFOREST&quot;] = &quot;LOST FOREST&quot;,
[&quot;CORRUPTION&quot;] = &quot;CORRUPTION&quot;,
[&quot;CORRUPTED&quot;] = &quot;CORRUPTION&quot;,
[&quot;NULL&quot;] = &quot;NULL&quot;,
[&quot;GLITCHED&quot;] = &quot;GLITCHED&quot;,
[&quot;GLITCH&quot;] = &quot;GLITCHED&quot;,
[&quot;DREAMSPACE&quot;] = &quot;DREAMSPACE&quot;,
[&quot;CYBERSPACE&quot;] = &quot;CYBERSPACE&quot;,
[&quot;SINGULARITY&quot;] = &quot;SINGULARITY&quot;,
[&quot;THERADIANTFOREST&quot;] = &quot;THE RADIANT FOREST&quot;,
[&quot;RADIANTFOREST&quot;] = &quot;THE RADIANT FOREST&quot;
}
local All16Biomes = {
&quot;NORMAL&quot;, &quot;WINDY&quot;, &quot;SNOWY&quot;, &quot;RAINY&quot;, &quot;SANDSTORM&quot;, &quot;HELL&quot;,
&quot;STARFALL&quot;, &quot;HEAVEN&quot;, &quot;LOST FOREST&quot;, &quot;CORRUPTION&quot;, &quot;NULL&quot;,
&quot;GLITCHED&quot;, &quot;DREAMSPACE&quot;, &quot;CYBERSPACE&quot;, &quot;SINGULARITY&quot;, &quot;THE RADIANT FOREST&quot;
}
local All3Merchants = {&quot;Mari&quot;, &quot;Jester&quot;, &quot;Rin&quot;}
local MerchantData = {
[&quot;Mari&quot;] = {Color = 0x2ECC71, Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},
[&quot;Jester&quot;] = {Color = 0x9B59B6, Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;},

[&quot;Rin&quot;] = {Color = 0x3498DB, Image = &quot;https://tr.rbxcdn.com/180DAY-
b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;}
}
-- // Configuration Table
local NyXConfig = {
WebhookURL = &quot;&quot;,
DiscordID = &quot;&quot;,
PrivateServerLink = &quot;&quot;,
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
[&quot;GLITCHED&quot;] = true,
[&quot;DREAMSPACE&quot;] = true,
[&quot;CYBERSPACE&quot;] = true
},
PingBiomes = {
[&quot;GLITCHED&quot;] = true,
[&quot;DREAMSPACE&quot;] = true,
[&quot;CYBERSPACE&quot;] = true
},
PingMerchants = {
[&quot;Mari&quot;] = false,
[&quot;Jester&quot;] = false,
[&quot;Rin&quot;] = false
},
CurrentDetectedBiome = &quot;NORMAL&quot;,
CurrentMerchant = &quot;NONE&quot;,
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
local WebhookConfigFile = &quot;NyX_WebhookConfig.json&quot;
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
if type(decoded) == &quot;table&quot; then
NyXConfig.WebhookURL = tostring(decoded.WebhookURL or &quot;&quot;):gsub(&quot;%s+&quot;, &quot;&quot;)
NyXConfig.DiscordID = tostring(decoded.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
NyXConfig.PrivateServerLink = tostring(decoded.PrivateServerLink or &quot;&quot;)
if type(decoded.PingBiomes) == &quot;table&quot; then
for k, v in pairs(decoded.PingBiomes) do NyXConfig.PingBiomes[k] = v end
end
if type(decoded.PingMerchants) == &quot;table&quot; then
for k, v in pairs(decoded.PingMerchants) do NyXConfig.PingMerchants[k] = v end
end
end
end)
end
end
LoadWebhookConfig()
-- // Anti-AFK &amp; Auto-Reconnect
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
return &quot;00:00:00&quot;
end
elapsed = math.floor(os.time() - MacroStartTime)
end
local hours = math.floor(elapsed / 3600)
local mins = math.floor((elapsed % 3600) / 60)
local secs = elapsed % 60
return string.format(&quot;%02d:%02d:%02d&quot;, hours, mins, secs)
end
local function CleanRichText(str)
if type(str) ~= &quot;string&quot; then return &quot;&quot; end
local s = str:gsub(&quot;&lt;[^&gt;]+&gt;&quot;, &quot;&quot;)
s = s:gsub(&quot;^%s+&quot;, &quot;&quot;):gsub(&quot;%s+$&quot;, &quot;&quot;)
return s

end
-- ==========================================
-- // DISCORD WEBHOOK SYSTEM (USER-DEFINED PINGS)
-- ==========================================
local function BuildUserPingContent(shouldPing)
if not shouldPing then return &quot;&quot; end
local cleanID = tostring(NyXConfig.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
if cleanID ~= &quot;&quot; then
return &quot;&lt;@&quot; .. cleanID .. &quot;&gt;&quot;
end
return &quot;&quot;
end
local function SendRawWebhook(payload)
local cleanUrl = tostring(NyXConfig.WebhookURL or &quot;&quot;):gsub(&quot;%s+&quot;, &quot;&quot;)
if cleanUrl == &quot;&quot; then return end
local cleanID = tostring(NyXConfig.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
payload[&quot;allowed_mentions&quot;] = {
[&quot;parse&quot;] = {&quot;users&quot;, &quot;everyone&quot;},
[&quot;users&quot;] = cleanID ~= &quot;&quot; and {cleanID} or {}
}
local req = (syn and syn.request) or http_request or request
if req then
pcall(function()
req({
Url = cleanUrl,
Method = &quot;POST&quot;,
Headers = {[&quot;Content-Type&quot;] = &quot;application/json&quot;},
Body = HttpService:JSONEncode(payload)
})
end)
end
end
local function SendTestWebhookEmbed(withUserPing)
local contentMsg = BuildUserPingContent(withUserPing)
SendRawWebhook({
[&quot;content&quot;] = contentMsg,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = withUserPing and &quot;Ping With User ID - Successfully&quot; or &quot;Webhook Test - Successfully&quot;,
[&quot;description&quot;] = withUserPing and (&quot;User ID Ping verified for &quot; .. contentMsg) or &quot;Connection
verified. NyX Detector Macro is ready.&quot;,
[&quot;color&quot;] = 0x2ECC71,
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;Project NyX&quot;}
}}
})
end
local function SendMacroStateEmbed(isStarted, finalElapsed)
local currentClock = os.date(&quot;%H:%M:%S&quot;)
if isStarted then
SendRawWebhook({
[&quot;content&quot;] = &quot;&quot;,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = &quot;Macro Started&quot;,
[&quot;description&quot;] = &quot;**NyX Detector Macro** has started monitoring Biomes and Merchants.\n**Macro
Uptime :** `00:00:00`&quot;,
[&quot;color&quot;] = 0x00FF88,
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. currentClock}
}}
})
else
local uptimeStr = GetMacroUptime(finalElapsed or 0)
SendRawWebhook({

[&quot;content&quot;] = &quot;&quot;,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = &quot;Macro Stopped&quot;,
[&quot;description&quot;] = &quot;**NyX Detector Macro** has been stopped.\n**Total Uptime :** `&quot; .. uptimeStr
.. &quot;` *(Reset)*&quot;,
[&quot;color&quot;] = 0xFF3344,
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. currentClock}
}}
})
end
end
local function SendBiomeStartedEmbed(biomeName, color, imageUrl)
local shouldPing = NyXConfig.PingBiomes[biomeName] == true
local contentMsg = BuildUserPingContent(shouldPing)
local psDisplay = NyXConfig.PrivateServerLink ~= &quot;&quot; and (&quot;[Click to Join Server](&quot; ..
NyXConfig.PrivateServerLink .. &quot;)&quot;) or &quot;`None`&quot;
local currentClock = os.date(&quot;%H:%M:%S&quot;)
local uptimeStr = GetMacroUptime()
SendRawWebhook({
[&quot;content&quot;] = contentMsg,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = &quot;Biome Started - &quot; .. biomeName,
[&quot;description&quot;] = &quot;**Macro Uptime :** `&quot; .. uptimeStr .. &quot;`\n**Private Server :** &quot; .. psDisplay,
[&quot;color&quot;] = color or 0x9B59B6,
[&quot;thumbnail&quot;] = {[&quot;url&quot;] = imageUrl},
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. currentClock}
}}
})
end
local function SendBiomeEndedEmbed(biomeName, color, imageUrl)
local currentClock = os.date(&quot;%H:%M:%S&quot;)
local uptimeStr = GetMacroUptime()
SendRawWebhook({
[&quot;content&quot;] = &quot;&quot;,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = &quot;Biome Ended - &quot; .. biomeName,
[&quot;description&quot;] = &quot;**Macro Uptime :** `&quot; .. uptimeStr .. &quot;`&quot;,
[&quot;color&quot;] = color or 0x555555,
[&quot;thumbnail&quot;] = {[&quot;url&quot;] = imageUrl},
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. currentClock}
}}
})
end
local function SendMerchantArrivedEmbed(merchantName)
if not NyXConfig.EnableMerchantWebhook then return end
local mInfo = MerchantData[merchantName] or {
Color = 0xF1C40F,
Image = &quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;
}
local shouldPing = NyXConfig.PingMerchants[merchantName] == true
local contentMsg = BuildUserPingContent(shouldPing)
local psDisplay = NyXConfig.PrivateServerLink ~= &quot;&quot; and (&quot;[Click to Join Server](&quot; ..
NyXConfig.PrivateServerLink .. &quot;)&quot;) or &quot;`None`&quot;
SendRawWebhook({
[&quot;content&quot;] = contentMsg,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = merchantName .. &quot; has arrived!&quot;,
[&quot;description&quot;] = &quot;**Merchant :** `&quot; .. merchantName .. &quot;`\n**Duration :** `03:00`\n**Macro Uptime
:** `&quot; .. GetMacroUptime() .. &quot;`\n**Private Server :** &quot; .. psDisplay,

[&quot;color&quot;] = mInfo.Color,
[&quot;thumbnail&quot;] = {[&quot;url&quot;] = mInfo.Image},
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. os.date(&quot;%H:%M:%S&quot;)}
}}
})
end
local function SendMerchantLeftEmbed(merchantName)
if not NyXConfig.EnableMerchantWebhook then return end
local mInfo = MerchantData[merchantName] or {
Color = 0x555555,
Image = &quot;https://tr.rbxcdn.com/180DAY-b568b5a06678921704d6c473e1ab1cb8/150/150/Image/Png/noFilter&quot;
}
SendRawWebhook({
[&quot;content&quot;] = &quot;&quot;,
[&quot;embeds&quot;] = {{
[&quot;title&quot;] = merchantName .. &quot; has left!&quot;,
[&quot;description&quot;] = &quot;**Merchant :** `&quot; .. merchantName .. &quot;` has despawned.\n**Macro Uptime :** `&quot; ..
GetMacroUptime() .. &quot;`&quot;,
[&quot;color&quot;] = 0x555555,
[&quot;thumbnail&quot;] = {[&quot;url&quot;] = mInfo.Image},
[&quot;footer&quot;] = {[&quot;text&quot;] = &quot;NyX Detector Macro | &quot; .. os.date(&quot;%H:%M:%S&quot;)}
}}
})
end
-- ==========================================
-- // RIVER-SAFE PATHFINDING TO MERCHANT &amp; ITEMS (ANTI-BAN)
-- ==========================================
local isWalkingPath = false
local function RespawnCharacterSafely()
pcall(function()
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass(&quot;Humanoid&quot;)
if hum then
hum.Health = 0
end
end)
end
local function FindMerchantWorldPosition()
local foundName, foundPos, foundPrompt = nil, nil, nil
pcall(function()
for _, obj in ipairs(Workspace:GetDescendants()) do
if obj:IsA(&quot;ProximityPrompt&quot;) then
local combined = (obj.ObjectText .. &quot; &quot; .. obj.ActionText .. &quot; &quot; .. (obj.Parent and
obj.Parent.Name or &quot;&quot;) .. &quot; &quot; .. (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name or &quot;&quot;)):upper()
local mName = nil
if combined:find(&quot;%f[%a]JESTER%f[%A]&quot;) then mName = &quot;Jester&quot;
elseif combined:find(&quot;%f[%a]RIN%f[%A]&quot;) then mName = &quot;Rin&quot;
elseif combined:find(&quot;%f[%a]MARI%f[%A]&quot;) then mName = &quot;Mari&quot; end
if mName then
local part = obj:FindFirstAncestorWhichIsA(&quot;BasePart&quot;) or (obj.Parent and
obj.Parent:IsA(&quot;Model&quot;) and obj.Parent.PrimaryPart)
if part then
foundName = mName
foundPos = part.Position
foundPrompt = obj
return
end
end
elseif obj:IsA(&quot;Model&quot;) then
local n = obj.Name:upper()
local mName = nil

if n == &quot;JESTER&quot; or n == &quot;MERCHANT_JESTER&quot; or n == &quot;JESTERNPC&quot; then mName = &quot;Jester&quot;
elseif n == &quot;RIN&quot; or n == &quot;MERCHANT_RIN&quot; or n == &quot;RINNPC&quot; then mName = &quot;Rin&quot;
elseif n == &quot;MARI&quot; or n == &quot;MERCHANT_MARI&quot; or n == &quot;MARINPC&quot; then mName = &quot;Mari&quot; end
if mName then
local pivot = obj:GetPivot()
if pivot then
foundName = mName
foundPos = pivot.Position
foundPrompt = obj:FindFirstChildWhichIsA(&quot;ProximityPrompt&quot;, true)
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
if hitName:find(&quot;WATER&quot;) or hitName:find(&quot;RIVER&quot;) or hitName:find(&quot;KILL&quot;) or hitName:find(&quot;VOID&quot;)
then
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
local hum = char and char:FindFirstChildOfClass(&quot;Humanoid&quot;)
local root = char and char:FindFirstChild(&quot;HumanoidRootPart&quot;)
if not hum or not root or hum.Health &lt;= 0 then
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
if not char.Parent or hum.Health &lt;= 0 then break end
if IsWaypointOverWaterOrVoid(wp.Position) then
hum.Jump = true
end
if wp.Action == Enum.PathWaypointAction.Jump then
hum.Jump = true
end
hum:MoveTo(wp.Position)
local stepStart = os.clock()
while (root.Position - wp.Position).Magnitude &gt; 4.2 and (os.clock() - stepStart) &lt; 2.2 do
if not ScriptRunning or (stopConditionFunc and stopConditionFunc()) then break end
if (root.Position - wp.Position).Magnitude &gt; 3 and hum.MoveDirection.Magnitude &gt; 0 and
root.Velocity.Magnitude &lt; 1.2 then
hum.Jump = true
end
task.wait(0.08)
end
if (root.Position - targetPos).Magnitude &lt;= 8 then
reached = true
break
end
end
else
-- Safe direct ground-checked walk if navmesh is simple
if not IsWaypointOverWaterOrVoid(targetPos) then
hum:MoveTo(targetPos)
local t0 = os.clock()
while (root.Position - targetPos).Magnitude &gt; 7 and (os.clock() - t0) &lt; 8 do
if not ScriptRunning or IsWaypointOverWaterOrVoid(root.Position + root.CFrame.LookVector *
5) then
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
Notify(&quot;Merchant Pathfinding&quot;, &quot;No active merchant coordinates found in world!&quot;, 3)
return
end

Notify(&quot;Merchant Pathfinding&quot;, &quot;Walking safely to &quot; .. tostring(mName or &quot;Merchant&quot;) .. &quot; (Avoiding
rivers)...&quot;, 3.5)
WalkSafelyToTargetPosition(mPos, function()
return NyXConfig.CurrentMerchant == &quot;NONE&quot;
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
Notify(&quot;Merchant Arrived!&quot;, merchantName .. &quot; has arrived! (3m timer started)&quot;, 4)
if NyXConfig.AutoWalkToMerchant then
WalkToActiveMerchantNow()
end
end
local function SetMerchantLeftState(reason)
if NyXConfig.CurrentMerchant == &quot;NONE&quot; then return end
local prevMerchant = NyXConfig.CurrentMerchant:sub(1,1):upper() .. NyXConfig.CurrentMerchant:sub(2):lower()
NyXConfig.CurrentMerchant = &quot;NONE&quot;
NyXConfig.MerchantSpawnTimestamp = 0
NyXConfig.MerchantPosition = nil
SendMerchantLeftEmbed(prevMerchant)
Notify(&quot;Merchant Left&quot;, prevMerchant .. &quot; has left! (&quot; .. tostring(reason or &quot;3m Elapsed&quot;) .. &quot;)&quot;, 4)
if NyXConfig.RespawnIfMerchantLeft then
Notify(&quot;Auto Respawn&quot;, &quot;Respawning character because merchant left...&quot;, 3)
task.wait(0.8)
RespawnCharacterSafely()
end
end
-- ==========================================
-- // ULTRA-ACCURATE BIOME SCANNER
-- ==========================================
local function ParseStrictBiomeToken(rawText, requireBrackets)
local clean = CleanRichText(rawText):upper()
if clean == &quot;&quot; or #clean &gt; 38 then return nil end
local bracketInner = clean:match(&quot;^%[%s*(.-)%s*%]$&quot;)
if bracketInner then
local condensed = bracketInner:gsub(&quot;[^A-Z]&quot;, &quot;&quot;)
return NormalizedBiomeLookup[condensed]
end
if not requireBrackets then
local condensed = clean:gsub(&quot;[^A-Z]&quot;, &quot;&quot;)
return NormalizedBiomeLookup[condensed]

end
return nil
end
local function GetAccurateServerBiome()
local foundBiome = nil
pcall(function()
local candidates = {
Workspace:GetAttribute(&quot;Biome&quot;),
Workspace:GetAttribute(&quot;CurrentBiome&quot;),
Workspace:GetAttribute(&quot;Weather&quot;),
ReplicatedStorage:GetAttribute(&quot;Biome&quot;),
ReplicatedStorage:GetAttribute(&quot;CurrentBiome&quot;),
Lighting:GetAttribute(&quot;Biome&quot;),
LocalPlayer:GetAttribute(&quot;Biome&quot;)
}
for _, val in ipairs(candidates) do
if type(val) == &quot;string&quot; and val ~= &quot;&quot; then
local m = ParseStrictBiomeToken(val, false)
if m then foundBiome = m return end
end
end
end)
if foundBiome then return foundBiome end
pcall(function()
for _, root in ipairs({ReplicatedStorage, Workspace, Lighting}) do
for _, obj in ipairs(root:GetChildren()) do
if obj:IsA(&quot;StringValue&quot;) then
local n = obj.Name:upper()
if n == &quot;BIOME&quot; or n == &quot;CURRENTBIOME&quot; or n == &quot;WEATHER&quot; then
local m = ParseStrictBiomeToken(obj.Value, false)
if m then foundBiome = m return end
end
end
end
end
end)
if foundBiome then return foundBiome end
pcall(function()
local pGui = LocalPlayer:FindFirstChild(&quot;PlayerGui&quot;)
if not pGui then return end
local bracketedMatch = nil
local exactHudLabelMatch = nil
for _, v in ipairs(pGui:GetDescendants()) do
if v:IsA(&quot;TextLabel&quot;) and v.Visible and v.Text ~= &quot;&quot; and (not ScreenGui or not
v:IsDescendantOf(ScreenGui)) then
local fullName = v:GetFullName():upper()
if not fullName:find(&quot;NYX&quot;)
and not fullName:find(&quot;INVENTORY&quot;)
and not fullName:find(&quot;BACKPACK&quot;)
and not fullName:find(&quot;CHAT&quot;)
and not fullName:find(&quot;SHOP&quot;)
and not fullName:find(&quot;COLLECTION&quot;)
and not fullName:find(&quot;BESTIARY&quot;)
and not fullName:find(&quot;INDEX&quot;)
and not fullName:find(&quot;QUEST&quot;)
and not fullName:find(&quot;CRAFT&quot;)
and not fullName:find(&quot;SETTING&quot;)
and not fullName:find(&quot;LEADERBOARD&quot;)
and not fullName:find(&quot;PLAYERLIST&quot;)
and not fullName:find(&quot;AURA&quot;)

and not fullName:find(&quot;ROLL&quot;) then
local bMatch = ParseStrictBiomeToken(v.Text, true)
if bMatch then
bracketedMatch = bMatch
if bMatch ~= &quot;NORMAL&quot; then break end
end
local lblName = v.Name:upper()
if lblName == &quot;BIOME&quot; or lblName == &quot;BIOMELABEL&quot; or lblName == &quot;BIOMETEXT&quot; or lblName ==
&quot;CURRENTBIOME&quot; then
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
return foundBiome or &quot;NORMAL&quot;
end
-- ==========================================
-- // STRICT MERCHANT ARRIVAL &amp; DEPARTURE PARSER
-- ==========================================
local function ParseMerchantSystemEvent(rawText)
local clean = CleanRichText(rawText):upper()
if clean == &quot;&quot; then return nil, nil end
local mName = nil
if clean:find(&quot;%f[%a]JESTER%f[%A]&quot;) or clean:find(&quot;JESTER&#39;S&quot;) then
mName = &quot;Jester&quot;
elseif clean:find(&quot;%f[%a]RIN%f[%A]&quot;) or clean:find(&quot;RIN&#39;S&quot;) then
mName = &quot;Rin&quot;
elseif clean:find(&quot;%f[%a]MARI%f[%A]&quot;) or clean:find(&quot;MARI&#39;S&quot;) then
mName = &quot;Mari&quot;
end
if not mName then return nil, nil end
if clean:find(&quot;HAS LEFT&quot;) or clean:find(&quot;DESPAWN&quot;) or clean:find(&quot;DEPARTED&quot;) or clean:find(&quot;GONE&quot;) then
return mName, &quot;LEFT&quot;
elseif clean:find(&quot;HAS ARRIVED&quot;) or clean:find(&quot;HAS SPAWNED&quot;) or clean:find(&quot;APPEARED&quot;) then
return mName, &quot;ARRIVED&quot;
end
return nil, nil
end
pcall(function()
if TextChatService and TextChatService.MessageReceived then
TextChatService.MessageReceived:Connect(function(message)
if not ScriptRunning then return end
-- Only parse system messages (TextSource == nil) so player chat never spoofs merchants
if message.TextSource ~= nil then return end
local txt = (message.Text or &quot;&quot;) .. &quot; &quot; .. (message.PrefixText or &quot;&quot;)
local mName, action = ParseMerchantSystemEvent(txt)
if mName and action == &quot;ARRIVED&quot; then
local _, pos = FindMerchantWorldPosition()
SetMerchantArrivedState(mName, pos)
elseif mName and action == &quot;LEFT&quot; then
SetMerchantLeftState(&quot;System Chat Left&quot;)
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
local Remotes = ReplicatedStorage:FindFirstChild(&quot;Remotes&quot;) or
ReplicatedStorage:FindFirstChild(&quot;Events&quot;) or ReplicatedStorage
for _, r in pairs(Remotes:GetDescendants()) do
if r:IsA(&quot;RemoteEvent&quot;) and (r.Name:lower():find(&quot;use&quot;) or r.Name:lower():find(&quot;item&quot;) or
r.Name:lower():find(&quot;inventory&quot;)) then
pcall(function() r:FireServer(itemName) end)
pcall(function() r:FireServer(&quot;Use&quot;, itemName) end)
pcall(function() r:FireServer(itemName, 1) end)
end
end
local pGui = LocalPlayer:FindFirstChild(&quot;PlayerGui&quot;)
if not pGui then return end
local invFrame = nil
for _, v in pairs(pGui:GetDescendants()) do
if not ScreenGui or not v:IsDescendantOf(ScreenGui) then
if v:IsA(&quot;Frame&quot;) and (v.Name == &quot;Inventory&quot; or v.Name == &quot;InventoryFrame&quot; or v.Name ==
&quot;ItemsFrame&quot;) then
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
if (btn:IsA(&quot;TextButton&quot;) or btn:IsA(&quot;ImageButton&quot;)) and (btn.Name:lower():find(&quot;inv&quot;) or
(btn:IsA(&quot;TextButton&quot;) and btn.Text:lower():find(&quot;inventory&quot;))) then
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
if box:IsA(&quot;TextBox&quot;) and box.Visible and (box.PlaceholderText:lower():find(&quot;search&quot;) or
box.Name:lower():find(&quot;search&quot;)) then
box.Text = itemName
task.wait(0.2)
break
end
end
end
local foundItemSlot = nil
for _, lbl in pairs(pGui:GetDescendants()) do
if not ScreenGui or not lbl:IsDescendantOf(ScreenGui) then
if lbl:IsA(&quot;TextLabel&quot;) and lbl.Visible and string.find(CleanRichText(lbl.Text):lower(),
itemName:lower(), 1, true) then
local clickableParent = lbl:FindFirstAncestorWhichIsA(&quot;TextButton&quot;) or
lbl:FindFirstAncestorWhichIsA(&quot;ImageButton&quot;) or lbl.Parent
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
if (btn:IsA(&quot;TextButton&quot;) or btn:IsA(&quot;ImageButton&quot;)) and btn.Visible then
local txt = btn:IsA(&quot;TextButton&quot;) and CleanRichText(btn.Text):upper() or &quot;&quot;
local bName = btn.Name:upper()
if txt == &quot;USE&quot; or string.find(txt, &quot;USE &quot;) or bName == &quot;USEBUTTON&quot; or bName == &quot;USE&quot;
then
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
local ParentGui = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild(&quot;PlayerGui&quot;)
if ParentGui:FindFirstChild(&quot;NyXMacroUI&quot;) then
ParentGui.NyXMacroUI:Destroy()
end
ScreenGui = Instance.new(&quot;ScreenGui&quot;)
ScreenGui.Name = &quot;NyXMacroUI&quot;
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui
-- OLED Black Screen Battery Saver Overlay
local BlackSaverFrame = Instance.new(&quot;Frame&quot;)
BlackSaverFrame.Name = &quot;BlackScreenOverlay&quot;
BlackSaverFrame.Size = UDim2.new(1, 0, 1, 0)
BlackSaverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackSaverFrame.Visible = false
BlackSaverFrame.ZIndex = 1
BlackSaverFrame.Parent = ScreenGui
local BlackSaverLabel = Instance.new(&quot;TextLabel&quot;, BlackSaverFrame)
BlackSaverLabel.Size = UDim2.new(1, 0, 0, 40)
BlackSaverLabel.Position = UDim2.new(0, 0, 0.45, -20)
BlackSaverLabel.BackgroundTransparency = 1
BlackSaverLabel.Text = &quot;NYX DETECTOR MACRO - BATTERY SAVER ACTIVE&quot;
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
local ToastHolder = Instance.new(&quot;Frame&quot;)
ToastHolder.Size = UDim2.new(0, 220, 1, -16)
ToastHolder.Position = UDim2.new(1, -230, 0, 8)
ToastHolder.BackgroundTransparency = 1
ToastHolder.ZIndex = 20
ToastHolder.Parent = ScreenGui
local ToastLayout = Instance.new(&quot;UIListLayout&quot;)
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.Padding = UDim.new(0, 6)
ToastLayout.Parent = ToastHolder
Notify = function(title, text, duration)
task.spawn(function()
local Card = Instance.new(&quot;Frame&quot;)
Card.Size = UDim2.new(1, 0, 0, 48)
Card.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
Card.BackgroundTransparency = 0.08

Card.ZIndex = 21
Card.Parent = ToastHolder
local Crn = Instance.new(&quot;UICorner&quot;, Card)
Crn.CornerRadius = UDim.new(0, 8)
local Strk = Instance.new(&quot;UIStroke&quot;, Card)
Strk.Color = NyXConfig.UIAccentColor
Strk.Thickness = 1.2
Strk.Transparency = 0.25
local Tbl = Instance.new(&quot;TextLabel&quot;, Card)
Tbl.Size = UDim2.new(1, -16, 0, 18)
Tbl.Position = UDim2.new(0, 10, 0, 4)
Tbl.BackgroundTransparency = 1
Tbl.Text = title
Tbl.TextColor3 = Color3.fromRGB(245, 245, 255)
Tbl.Font = Enum.Font.GothamBold
Tbl.TextSize = 11
Tbl.ZIndex = 22
Tbl.TextXAlignment = Enum.TextXAlignment.Left
local Sub = Instance.new(&quot;TextLabel&quot;, Card)
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
local MainWindow = Instance.new(&quot;Frame&quot;)
MainWindow.Name = &quot;MainWindow&quot;
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Size = UDim2.new(0, 480, 0, 285)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
MainWindow.Active = true
MainWindow.ZIndex = 5
MainWindow.Parent = ScreenGui
local WindowScale = Instance.new(&quot;UIScale&quot;, MainWindow)
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
Workspace.CurrentCamera:GetPropertyChangedSignal(&quot;ViewportSize&quot;):Connect(RecalculateResponsiveScale)
end
local MainCorner = Instance.new(&quot;UICorner&quot;, MainWindow)

MainCorner.CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new(&quot;UIStroke&quot;, MainWindow)
MainStroke.Thickness = 1.3
MainStroke.Transparency = 0.35
RegisterAccent(MainStroke, &quot;Color&quot;)
-- Compact Floating &quot;ND&quot; Button
local NDButton = Instance.new(&quot;TextButton&quot;)
NDButton.Name = &quot;NDLogoBtn&quot;
NDButton.Size = UDim2.new(0, 44, 0, 44)
NDButton.Position = UDim2.new(0.03, 0, 0.2, 0)
NDButton.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
NDButton.BackgroundTransparency = 0.08
NDButton.Text = &quot;ND&quot;
NDButton.TextColor3 = Color3.fromRGB(245, 240, 255)
NDButton.Font = Enum.Font.GothamBlack
NDButton.TextSize = 17
NDButton.Active = true
NDButton.ZIndex = 30
NDButton.Parent = ScreenGui
local NDCrn = Instance.new(&quot;UICorner&quot;, NDButton)
NDCrn.CornerRadius = UDim.new(0, 10)
local NDStroke = Instance.new(&quot;UIStroke&quot;, NDButton)
NDStroke.Thickness = 1.8
RegisterAccent(NDStroke, &quot;Color&quot;)
local NDSub = Instance.new(&quot;TextLabel&quot;, NDButton)
NDSub.Size = UDim2.new(1, 0, 0, 10)
NDSub.Position = UDim2.new(0, 0, 0.72, 0)
NDSub.BackgroundTransparency = 1
NDSub.Text = &quot;NYX&quot;
NDSub.Font = Enum.Font.GothamBold
NDSub.TextSize = 7
NDSub.ZIndex = 31
RegisterAccent(NDSub, &quot;TextColor3&quot;)
local function MakeDraggable(dragHandle, targetFrame, onClickCallback)
local dragging, hasMoved, dragStart, startPos = false, false, nil, nil
dragHandle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType ==
Enum.UserInputType.Touch then
dragging = true
hasMoved = false
dragStart = input.Position
startPos = targetFrame.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType ==
Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
if delta.Magnitude &gt; 5 then
hasMoved = true
targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType ==
Enum.UserInputType.Touch then
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
local Sidebar = Instance.new(&quot;Frame&quot;, MainWindow)
Sidebar.Size = UDim2.new(0, 138, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
Sidebar.BackgroundTransparency = 0.2
local SidebarCrn = Instance.new(&quot;UICorner&quot;, Sidebar)
SidebarCrn.CornerRadius = UDim.new(0, 12)
local SidebarDivider = Instance.new(&quot;Frame&quot;, MainWindow)
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(0, 138, 0, 0)
SidebarDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 68)
SidebarDivider.BorderSizePixel = 0
local BrandIcon = Instance.new(&quot;Frame&quot;, Sidebar)
BrandIcon.Size = UDim2.new(0, 28, 0, 28)
BrandIcon.Position = UDim2.new(0, 10, 0, 10)
BrandIcon.BackgroundColor3 = Color3.fromRGB(26, 24, 42)
Instance.new(&quot;UICorner&quot;, BrandIcon).CornerRadius = UDim.new(1, 0)
local BrandStroke = Instance.new(&quot;UIStroke&quot;, BrandIcon)
BrandStroke.Thickness = 1.3
RegisterAccent(BrandStroke, &quot;Color&quot;)
local BrandLogoTxt = Instance.new(&quot;TextLabel&quot;, BrandIcon)
BrandLogoTxt.Size = UDim2.new(1, 0, 1, 0)
BrandLogoTxt.BackgroundTransparency = 1
BrandLogoTxt.Text = &quot;N&quot;
BrandLogoTxt.Font = Enum.Font.GothamBlack
BrandLogoTxt.TextSize = 14
BrandLogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
local BrandTitle = Instance.new(&quot;TextLabel&quot;, Sidebar)
BrandTitle.Size = UDim2.new(0, 88, 0, 16)
BrandTitle.Position = UDim2.new(0, 44, 0, 10)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = &quot;NyX Detector&quot;
BrandTitle.Font = Enum.Font.GothamBlack
BrandTitle.TextSize = 12
BrandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
local BrandSub = Instance.new(&quot;TextLabel&quot;, Sidebar)
BrandSub.Size = UDim2.new(0, 88, 0, 12)
BrandSub.Position = UDim2.new(0, 44, 0, 25)
BrandSub.BackgroundTransparency = 1
BrandSub.Text = &quot;MACRO&quot;
BrandSub.Font = Enum.Font.GothamBold
BrandSub.TextSize = 9
BrandSub.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(BrandSub, &quot;TextColor3&quot;)
MakeDraggable(Sidebar, MainWindow)
local CloseBtn = Instance.new(&quot;TextButton&quot;, MainWindow)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)

CloseBtn.Position = UDim2.new(1, -30, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
CloseBtn.Text = &quot;×&quot;
CloseBtn.TextColor3 = Color3.fromRGB(190, 190, 215)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new(&quot;UICorner&quot;, CloseBtn).CornerRadius = UDim.new(0, 6)
Instance.new(&quot;UIStroke&quot;, CloseBtn).Color = Color3.fromRGB(55, 55, 80)
CloseBtn.MouseButton1Click:Connect(function()
MainWindow.Visible = false
end)
local NavHolder = Instance.new(&quot;Frame&quot;, Sidebar)
NavHolder.Size = UDim2.new(1, -16, 1, -52)
NavHolder.Position = UDim2.new(0, 8, 0, 44)
NavHolder.BackgroundTransparency = 1
local NavLayout = Instance.new(&quot;UIListLayout&quot;, NavHolder)
NavLayout.Padding = UDim.new(0, 3)
local ContentArea = Instance.new(&quot;Frame&quot;, MainWindow)
ContentArea.Size = UDim2.new(1, -139, 1, 0)
ContentArea.Position = UDim2.new(0, 139, 0, 0)
ContentArea.BackgroundTransparency = 1
local Pages = {}
local NavButtons = {}
local function CreateTabPage(tabName, subtitleText)
local Page = Instance.new(&quot;Frame&quot;, ContentArea)
Page.Size = UDim2.new(1, 0, 1, 0)
Page.BackgroundTransparency = 1
Page.Visible = false
local HeaderTitle = Instance.new(&quot;TextLabel&quot;, Page)
HeaderTitle.Size = UDim2.new(1, -48, 0, 20)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = tabName
HeaderTitle.Font = Enum.Font.GothamBlack
HeaderTitle.TextSize = 15
HeaderTitle.TextColor3 = Color3.fromRGB(250, 250, 255)
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
local HeaderSub = Instance.new(&quot;TextLabel&quot;, Page)
HeaderSub.Size = UDim2.new(1, -48, 0, 14)
HeaderSub.Position = UDim2.new(0, 16, 0, 29)
HeaderSub.BackgroundTransparency = 1
HeaderSub.Text = subtitleText
HeaderSub.Font = Enum.Font.Gotham
HeaderSub.TextSize = 10
HeaderSub.TextColor3 = Color3.fromRGB(150, 150, 175)
HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
local HeaderLine = Instance.new(&quot;Frame&quot;, Page)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 0, 48)
HeaderLine.BackgroundColor3 = Color3.fromRGB(40, 40, 62)
HeaderLine.BorderSizePixel = 0
local Scroll = Instance.new(&quot;ScrollingFrame&quot;, Page)
Scroll.Size = UDim2.new(1, -24, 1, -56)
Scroll.Position = UDim2.new(0, 14, 0, 52)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

RegisterAccent(Scroll, &quot;ScrollBarImageColor3&quot;)
local ScrollLayout = Instance.new(&quot;UIListLayout&quot;, Scroll)
ScrollLayout.Padding = UDim.new(0, 7)
local NavBtn = Instance.new(&quot;TextButton&quot;, NavHolder)
NavBtn.Size = UDim2.new(1, 0, 0, 28)
NavBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
NavBtn.BackgroundTransparency = 1
NavBtn.Text = &quot; &quot; .. tabName
NavBtn.Font = Enum.Font.GothamBold
NavBtn.TextSize = 11
NavBtn.TextColor3 = Color3.fromRGB(160, 160, 185)
NavBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new(&quot;UICorner&quot;, NavBtn).CornerRadius = UDim.new(0, 7)
local ActiveBar = Instance.new(&quot;Frame&quot;, NavBtn)
ActiveBar.Size = UDim2.new(0, 3, 0, 15)
ActiveBar.Position = UDim2.new(0, 0, 0.5, -7)
ActiveBar.BorderSizePixel = 0
ActiveBar.Visible = false
Instance.new(&quot;UICorner&quot;, ActiveBar).CornerRadius = UDim.new(1, 0)
RegisterAccent(ActiveBar, &quot;BackgroundColor3&quot;)
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
local Holder = Instance.new(&quot;Frame&quot;, parent)
Holder.Size = UDim2.new(1, -6, 0, 18)
Holder.BackgroundTransparency = 1
local Bar = Instance.new(&quot;Frame&quot;, Holder)
Bar.Size = UDim2.new(0, 3, 0, 12)
Bar.Position = UDim2.new(0, 0, 0.5, -6)
Instance.new(&quot;UICorner&quot;, Bar).CornerRadius = UDim.new(1, 0)
RegisterAccent(Bar, &quot;BackgroundColor3&quot;)
local Lbl = Instance.new(&quot;TextLabel&quot;, Holder)
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
local Card = Instance.new(&quot;Frame&quot;, parent)
Card.Size = UDim2.new(1, -6, 0, 38)

Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Card.BackgroundTransparency = 0.15
Instance.new(&quot;UICorner&quot;, Card).CornerRadius = UDim.new(0, 8)
local Strk = Instance.new(&quot;UIStroke&quot;, Card)
Strk.Color = Color3.fromRGB(42, 42, 64)
Strk.Thickness = 1
local TitleLbl = Instance.new(&quot;TextLabel&quot;, Card)
TitleLbl.Size = UDim2.new(1, -65, 0, 16)
TitleLbl.Position = UDim2.new(0, 10, 0, 4)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = title
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 11
TitleLbl.TextColor3 = Color3.fromRGB(240, 240, 250)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
local SubLbl = Instance.new(&quot;TextLabel&quot;, Card)
SubLbl.Size = UDim2.new(1, -65, 0, 14)
SubLbl.Position = UDim2.new(0, 10, 0, 20)
SubLbl.BackgroundTransparency = 1
SubLbl.Text = subtext
SubLbl.Font = Enum.Font.Gotham
SubLbl.TextSize = 9
SubLbl.TextColor3 = Color3.fromRGB(145, 145, 170)
SubLbl.TextXAlignment = Enum.TextXAlignment.Left
local SwitchBg = Instance.new(&quot;TextButton&quot;, Card)
SwitchBg.Size = UDim2.new(0, 36, 0, 18)
SwitchBg.Position = UDim2.new(1, -46, 0.5, -9)
SwitchBg.Text = &quot;&quot;
SwitchBg.BackgroundColor3 = defaultVal and NyXConfig.UIAccentColor or Color3.fromRGB(45, 45, 65)
Instance.new(&quot;UICorner&quot;, SwitchBg).CornerRadius = UDim.new(1, 0)
local Knob = Instance.new(&quot;Frame&quot;, SwitchBg)
Knob.Size = UDim2.new(0, 12, 0, 12)
Knob.Position = defaultVal and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new(&quot;UICorner&quot;, Knob).CornerRadius = UDim.new(1, 0)
local state = defaultVal
SwitchBg.MouseButton1Click:Connect(function()
state = not state
SwitchBg.BackgroundColor3 = state and NyXConfig.UIAccentColor or Color3.fromRGB(45, 45, 65)
Knob.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
if callback then callback(state) end
end)
end
local function AddInput(parent, title, defaultText, placeholder, callback)
local Card = Instance.new(&quot;Frame&quot;, parent)
Card.Size = UDim2.new(1, -6, 0, 48)
Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Card.BackgroundTransparency = 0.15
Instance.new(&quot;UICorner&quot;, Card).CornerRadius = UDim.new(0, 8)
Instance.new(&quot;UIStroke&quot;, Card).Color = Color3.fromRGB(42, 42, 64)
local TitleLbl = Instance.new(&quot;TextLabel&quot;, Card)
TitleLbl.Size = UDim2.new(1, -20, 0, 14)
TitleLbl.Position = UDim2.new(0, 10, 0, 4)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = title
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 10
TitleLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local Box = Instance.new(&quot;TextBox&quot;, Card)
Box.Size = UDim2.new(1, -20, 0, 22)
Box.Position = UDim2.new(0, 10, 0, 21)
Box.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
Box.Text = defaultText or &quot;&quot;
Box.PlaceholderText = placeholder or &quot;&quot;
Box.TextColor3 = Color3.fromRGB(240, 240, 255)
Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 135)
Box.Font = Enum.Font.Gotham
Box.TextSize = 10
Box.ClearTextOnFocus = false
Box.TextXAlignment = Enum.TextXAlignment.Left
Instance.new(&quot;UICorner&quot;, Box).CornerRadius = UDim.new(0, 5)
Instance.new(&quot;UIStroke&quot;, Box).Color = Color3.fromRGB(50, 50, 75)
Box.FocusLost:Connect(function()
if callback then callback(Box.Text) end
end)
Box:GetPropertyChangedSignal(&quot;Text&quot;):Connect(function()
if callback then callback(Box.Text) end
end)
return Box
end
local function AddButton(parent, title, callback)
local Btn = Instance.new(&quot;TextButton&quot;, parent)
Btn.Size = UDim2.new(1, -6, 0, 30)
Btn.BackgroundColor3 = Color3.fromRGB(25, 24, 42)
Btn.Text = title
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 11
Btn.TextColor3 = Color3.fromRGB(245, 245, 255)
Instance.new(&quot;UICorner&quot;, Btn).CornerRadius = UDim.new(0, 7)
local Strk = Instance.new(&quot;UIStroke&quot;, Btn)
Strk.Thickness = 1.1
Strk.Transparency = 0.35
RegisterAccent(Strk, &quot;Color&quot;)
Btn.MouseButton1Click:Connect(function()
if callback then callback() end
end)
end
local function AddSlider(parent, title, minVal, maxVal, defaultVal, suffix, callback)
local Card = Instance.new(&quot;Frame&quot;, parent)
Card.Size = UDim2.new(1, -6, 0, 42)
Card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Card.BackgroundTransparency = 0.15
Instance.new(&quot;UICorner&quot;, Card).CornerRadius = UDim.new(0, 8)
Instance.new(&quot;UIStroke&quot;, Card).Color = Color3.fromRGB(42, 42, 64)
local TitleLbl = Instance.new(&quot;TextLabel&quot;, Card)
TitleLbl.Size = UDim2.new(1, -20, 0, 16)
TitleLbl.Position = UDim2.new(0, 10, 0, 4)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = title .. &quot;: &quot; .. tostring(defaultVal) .. (suffix or &quot;&quot;)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 10
TitleLbl.TextColor3 = Color3.fromRGB(235, 235, 250)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
local BarBg = Instance.new(&quot;TextButton&quot;, Card)
BarBg.Size = UDim2.new(1, -20, 0, 8)
BarBg.Position = UDim2.new(0, 10, 0, 26)
BarBg.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
BarBg.Text = &quot;&quot;
Instance.new(&quot;UICorner&quot;, BarBg).CornerRadius = UDim.new(1, 0)

local Fill = Instance.new(&quot;Frame&quot;, BarBg)
local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
Fill.Size = UDim2.new(pct, 0, 1, 0)
Instance.new(&quot;UICorner&quot;, Fill).CornerRadius = UDim.new(1, 0)
RegisterAccent(Fill, &quot;BackgroundColor3&quot;)
local sliding = false
local function UpdateFromInput(input)
local rel = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
local val = math.floor(minVal + (maxVal - minVal) * rel)
Fill.Size = UDim2.new(rel, 0, 1, 0)
TitleLbl.Text = title .. &quot;: &quot; .. tostring(val) .. (suffix or &quot;&quot;)
if callback then callback(val) end
end
BarBg.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType ==
Enum.UserInputType.Touch then
sliding = true
UpdateFromInput(input)
end
end)
UserInputService.InputChanged:Connect(function(input)
if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType ==
Enum.UserInputType.Touch) then
UpdateFromInput(input)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType ==
Enum.UserInputType.Touch then
sliding = false
end
end)
end
-- ==========================================
-- // BUILD THE 6 TABS (HOME, MAIN, MERCHANT, CONNECTIONS, PINGS, SETTING)
-- ==========================================
local HomeScroll, HomeNavBtn, HomeNavBar = CreateTabPage(&quot;Home&quot;, &quot;Dashboard, live status &amp; macro overview.&quot;)
local MainScroll = CreateTabPage(&quot;Main&quot;, &quot;Biome detector, inventory automation &amp; ground item collector.&quot;)
local MerchantScroll = CreateTabPage(&quot;Merchant&quot;, &quot;3-Min Merchant lifecycle, river-safe pathfinding &amp; auto-
respawn.&quot;)
local ConnScroll = CreateTabPage(&quot;Connections&quot;, &quot;Discord Webhook URL, User ID &amp; Private Server config.&quot;)
local PingsScroll = CreateTabPage(&quot;Pings&quot;, &quot;Select which of the 16 Biomes &amp; 3 Merchants ping your User ID.&quot;)
local SettingScroll = CreateTabPage(&quot;Setting&quot;, &quot;UI Scale, OLED Black Screen, Anti-AFK &amp; server tools.&quot;)
Pages[1].Visible = true
HomeNavBtn.BackgroundTransparency = 0.15
HomeNavBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeNavBar.Visible = true
-- // TAB 1: HOME
local WelcomeCard = Instance.new(&quot;Frame&quot;, HomeScroll)
WelcomeCard.Size = UDim2.new(1, -6, 0, 54)
WelcomeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
WelcomeCard.BackgroundTransparency = 0.12
Instance.new(&quot;UICorner&quot;, WelcomeCard).CornerRadius = UDim.new(0, 10)
Instance.new(&quot;UIStroke&quot;, WelcomeCard).Color = Color3.fromRGB(45, 45, 68)
local WBackLbl = Instance.new(&quot;TextLabel&quot;, WelcomeCard)
WBackLbl.Size = UDim2.new(0, 180, 0, 14)
WBackLbl.Position = UDim2.new(0, 14, 0, 8)
WBackLbl.BackgroundTransparency = 1
WBackLbl.Text = &quot;Welcome back,&quot;
WBackLbl.Font = Enum.Font.Gotham

WBackLbl.TextSize = 10
WBackLbl.TextColor3 = Color3.fromRGB(165, 165, 190)
WBackLbl.TextXAlignment = Enum.TextXAlignment.Left
local WUserLbl = Instance.new(&quot;TextLabel&quot;, WelcomeCard)
WUserLbl.Size = UDim2.new(0, 200, 0, 22)
WUserLbl.Position = UDim2.new(0, 14, 0, 24)
WUserLbl.BackgroundTransparency = 1
WUserLbl.Text = LocalPlayer.DisplayName:upper()
WUserLbl.Font = Enum.Font.GothamBlack
WUserLbl.TextSize = 16
WUserLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
WUserLbl.TextXAlignment = Enum.TextXAlignment.Left
local MacroBadge = Instance.new(&quot;Frame&quot;, WelcomeCard)
MacroBadge.Size = UDim2.new(0, 76, 0, 22)
MacroBadge.Position = UDim2.new(1, -88, 0.5, -11)
MacroBadge.BackgroundColor3 = Color3.fromRGB(24, 22, 42)
Instance.new(&quot;UICorner&quot;, MacroBadge).CornerRadius = UDim.new(1, 0)
local BadgeStroke = Instance.new(&quot;UIStroke&quot;, MacroBadge)
BadgeStroke.Thickness = 1.1
RegisterAccent(BadgeStroke, &quot;Color&quot;)
local BadgeTxt = Instance.new(&quot;TextLabel&quot;, MacroBadge)
BadgeTxt.Size = UDim2.new(1, 0, 1, 0)
BadgeTxt.BackgroundTransparency = 1
BadgeTxt.Text = &quot;MACRO&quot;
BadgeTxt.Font = Enum.Font.GothamBold
BadgeTxt.TextSize = 9
RegisterAccent(BadgeTxt, &quot;TextColor3&quot;)
AddSectionLabel(HomeScroll, &quot;LIVE STATUS&quot;)
local StatusRow = Instance.new(&quot;Frame&quot;, HomeScroll)
StatusRow.Size = UDim2.new(1, -6, 0, 56)
StatusRow.BackgroundTransparency = 1
local UptimeCard = Instance.new(&quot;Frame&quot;, StatusRow)
UptimeCard.Size = UDim2.new(0.485, 0, 1, 0)
UptimeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
UptimeCard.BackgroundTransparency = 0.12
Instance.new(&quot;UICorner&quot;, UptimeCard).CornerRadius = UDim.new(0, 10)
local UpStroke = Instance.new(&quot;UIStroke&quot;, UptimeCard)
UpStroke.Thickness = 1.1
UpStroke.Transparency = 0.35
RegisterAccent(UpStroke, &quot;Color&quot;)
local UpTitle = Instance.new(&quot;TextLabel&quot;, UptimeCard)
UpTitle.Size = UDim2.new(1, -20, 0, 14)
UpTitle.Position = UDim2.new(0, 12, 0, 8)
UpTitle.BackgroundTransparency = 1
UpTitle.Text = &quot;Uptime&quot;
UpTitle.Font = Enum.Font.Gotham
UpTitle.TextSize = 10
UpTitle.TextColor3 = Color3.fromRGB(160, 160, 185)
UpTitle.TextXAlignment = Enum.TextXAlignment.Left
local UptimeValueLabel = Instance.new(&quot;TextLabel&quot;, UptimeCard)
UptimeValueLabel.Size = UDim2.new(1, -20, 0, 22)
UptimeValueLabel.Position = UDim2.new(0, 12, 0, 24)
UptimeValueLabel.BackgroundTransparency = 1
UptimeValueLabel.Text = &quot;00:00:00&quot;
UptimeValueLabel.Font = Enum.Font.GothamBlack
UptimeValueLabel.TextSize = 16
UptimeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterAccent(UptimeValueLabel, &quot;TextColor3&quot;)

local BiomeCard = Instance.new(&quot;Frame&quot;, StatusRow)
BiomeCard.Size = UDim2.new(0.485, 0, 1, 0)
BiomeCard.Position = UDim2.new(0.515, 0, 0, 0)
BiomeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
BiomeCard.BackgroundTransparency = 0.12
Instance.new(&quot;UICorner&quot;, BiomeCard).CornerRadius = UDim.new(0, 10)
Instance.new(&quot;UIStroke&quot;, BiomeCard).Color = Color3.fromRGB(45, 45, 68)
local BmTitle = Instance.new(&quot;TextLabel&quot;, BiomeCard)
BmTitle.Size = UDim2.new(1, -20, 0, 14)
BmTitle.Position = UDim2.new(0, 12, 0, 8)
BmTitle.BackgroundTransparency = 1
BmTitle.Text = &quot;Current Biome&quot;
BmTitle.Font = Enum.Font.Gotham
BmTitle.TextSize = 10
BmTitle.TextColor3 = Color3.fromRGB(160, 160, 185)
BmTitle.TextXAlignment = Enum.TextXAlignment.Left
local BiomeValueLabel = Instance.new(&quot;TextLabel&quot;, BiomeCard)
BiomeValueLabel.Size = UDim2.new(1, -20, 0, 22)
BiomeValueLabel.Position = UDim2.new(0, 12, 0, 24)
BiomeValueLabel.BackgroundTransparency = 1
BiomeValueLabel.Text = &quot;NORMAL&quot;
BiomeValueLabel.Font = Enum.Font.GothamBlack
BiomeValueLabel.TextSize = 14
BiomeValueLabel.TextColor3 = Color3.fromRGB(80, 250, 123)
BiomeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
local MerchantStatusCard = Instance.new(&quot;Frame&quot;, HomeScroll)
MerchantStatusCard.Size = UDim2.new(1, -6, 0, 42)
MerchantStatusCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
MerchantStatusCard.BackgroundTransparency = 0.12
Instance.new(&quot;UICorner&quot;, MerchantStatusCard).CornerRadius = UDim.new(0, 10)
Instance.new(&quot;UIStroke&quot;, MerchantStatusCard).Color = Color3.fromRGB(45, 45, 68)
local MerTitle = Instance.new(&quot;TextLabel&quot;, MerchantStatusCard)
MerTitle.Size = UDim2.new(0.55, 0, 1, 0)
MerTitle.Position = UDim2.new(0, 12, 0, 0)
MerTitle.BackgroundTransparency = 1
MerTitle.Text = &quot;Active Merchant (3m Timer):&quot;
MerTitle.Font = Enum.Font.GothamBold
MerTitle.TextSize = 11
MerTitle.TextColor3 = Color3.fromRGB(185, 185, 210)
MerTitle.TextXAlignment = Enum.TextXAlignment.Left
local MerchantValueLabel = Instance.new(&quot;TextLabel&quot;, MerchantStatusCard)
MerchantValueLabel.Size = UDim2.new(0.4, -12, 1, 0)
MerchantValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
MerchantValueLabel.BackgroundTransparency = 1
MerchantValueLabel.Text = &quot;NONE&quot;
MerchantValueLabel.Font = Enum.Font.GothamBlack
MerchantValueLabel.TextSize = 12
MerchantValueLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
MerchantValueLabel.TextXAlignment = Enum.TextXAlignment.Right
-- // TAB 2: MAIN
AddSectionLabel(MainScroll, &quot;Biome Detector &amp; Ground Collector&quot;)
AddToggle(MainScroll, &quot;Start Biome &amp; State Detector&quot;, &quot;Sends Macro Started/Stopped and accurate Biome embeds.&quot;,
false, function(val)
if val then
NyXConfig.EnableBiomeWebhook = true
MacroStartTime = os.time()
SendMacroStateEmbed(true)
Notify(&quot;NyX Detector Macro&quot;, &quot;Macro Started!&quot;, 2.5)
else
local finalElapsed = (MacroStartTime &gt; 0) and (os.time() - MacroStartTime) or 0

NyXConfig.EnableBiomeWebhook = false
SendMacroStateEmbed(false, finalElapsed)
MacroStartTime = 0
UptimeValueLabel.Text = &quot;00:00:00&quot;
Notify(&quot;NyX Detector Macro&quot;, &quot;Macro Stopped!&quot;, 2.5)
end
end)
AddToggle(MainScroll, &quot;Auto Collect Natural Ground Items&quot;, &quot;Safely walks to nearby potions &amp; coins on the
ground.&quot;, false, function(val)
NyXConfig.AutoCollectItems = val
end)
AddSectionLabel(MainScroll, &quot;Inventory Automation&quot;)
AddButton(MainScroll, &quot;Use Now: Biome Randomizer&quot;, function()
task.spawn(function() UseItemWithInventoryFailsafe(&quot;Biome Randomizer&quot;) end)
end)
AddButton(MainScroll, &quot;Use Now: Strange Controller&quot;, function()
task.spawn(function() UseItemWithInventoryFailsafe(&quot;Strange Controller&quot;) end)
end)
AddSlider(MainScroll, &quot;Item Use Interval&quot;, 5, 300, 20, &quot;s&quot;, function(val)
NyXConfig.UseInterval = val
end)
AddToggle(MainScroll, &quot;Auto Biome Randomizer&quot;, &quot;Automatically opens inventory and uses Biome Randomizer.&quot;,
false, function(val)
NyXConfig.AutoBiomeRandomizer = val
end)
AddToggle(MainScroll, &quot;Auto Strange Controller&quot;, &quot;Automatically opens inventory and uses Strange Controller.&quot;,
false, function(val)
NyXConfig.AutoStrangeController = val
end)
AddSectionLabel(MainScroll, &quot;Stop Auto In (Pause Randomizer on Target Biomes)&quot;)
local StopGridFrame = Instance.new(&quot;Frame&quot;, MainScroll)
StopGridFrame.Name = &quot;StopFilterContainer&quot;
StopGridFrame.Size = UDim2.new(1, -6, 0, 118)
StopGridFrame.BackgroundTransparency = 1
local GridLayout = Instance.new(&quot;UIGridLayout&quot;, StopGridFrame)
GridLayout.CellSize = UDim2.new(0.24, -4, 0, 24)
GridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
for _, bName in ipairs(All16Biomes) do
local Chip = Instance.new(&quot;TextButton&quot;, StopGridFrame)
local isOn = NyXConfig.StopAutoBiomes[bName] == true
Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
Chip.Text = bName
Chip.Font = Enum.Font.GothamBold
Chip.TextSize = 8
Chip.TextColor3 = Color3.fromRGB(245, 245, 255)
Instance.new(&quot;UICorner&quot;, Chip).CornerRadius = UDim.new(0, 5)
Chip.MouseButton1Click:Connect(function()
NyXConfig.StopAutoBiomes[bName] = not NyXConfig.StopAutoBiomes[bName]
Chip.BackgroundColor3 = NyXConfig.StopAutoBiomes[bName] and NyXConfig.UIAccentColor or
Color3.fromRGB(22, 22, 36)
end)
end
-- // TAB 3: MERCHANT (DEDICATED CATEGORY)
AddSectionLabel(MerchantScroll, &quot;Merchant Lifecycle &amp; 3-Min Timer&quot;)

local MerchantLiveCard = Instance.new(&quot;Frame&quot;, MerchantScroll)
MerchantLiveCard.Size = UDim2.new(1, -6, 0, 46)
MerchantLiveCard.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
MerchantLiveCard.BackgroundTransparency = 0.12
Instance.new(&quot;UICorner&quot;, MerchantLiveCard).CornerRadius = UDim.new(0, 8)
Instance.new(&quot;UIStroke&quot;, MerchantLiveCard).Color = Color3.fromRGB(45, 45, 68)
local MTabStatusLbl = Instance.new(&quot;TextLabel&quot;, MerchantLiveCard)
MTabStatusLbl.Size = UDim2.new(1, -20, 0, 18)
MTabStatusLbl.Position = UDim2.new(0, 10, 0, 5)
MTabStatusLbl.BackgroundTransparency = 1
MTabStatusLbl.Text = &quot;Status: NONE (Waiting for Spawn)&quot;
MTabStatusLbl.Font = Enum.Font.GothamBold
MTabStatusLbl.TextSize = 11
MTabStatusLbl.TextColor3 = Color3.fromRGB(240, 240, 255)
MTabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
local MTabCoordsLbl = Instance.new(&quot;TextLabel&quot;, MerchantLiveCard)
MTabCoordsLbl.Size = UDim2.new(1, -20, 0, 16)
MTabCoordsLbl.Position = UDim2.new(0, 10, 0, 24)
MTabCoordsLbl.BackgroundTransparency = 1
MTabCoordsLbl.Text = &quot;XYZ Coordinates: N/A&quot;
MTabCoordsLbl.Font = Enum.Font.Gotham
MTabCoordsLbl.TextSize = 10
MTabCoordsLbl.TextColor3 = Color3.fromRGB(160, 160, 190)
MTabCoordsLbl.TextXAlignment = Enum.TextXAlignment.Left
AddToggle(MerchantScroll, &quot;Enable Merchant Detector (Arrived + 3m Left)&quot;, &quot;Detects Mari, Jester &amp; Rin arrival
and automatically logs &#39;has left!&#39; after 3 minutes.&quot;, false, function(val)
NyXConfig.EnableMerchantWebhook = val
end)
AddSectionLabel(MerchantScroll, &quot;Anti-Ban Pathfinding &amp; Respawn&quot;)
AddToggle(MerchantScroll, &quot;Auto Pathfind Walk to Merchant (Avoid Rivers)&quot;, &quot;Reads merchant XYZ and walks safely
along bridges/ground instead of teleporting.&quot;, false, function(val)
NyXConfig.AutoWalkToMerchant = val
end)
AddToggle(MerchantScroll, &quot;Auto Open Merchant Shop on Arrival&quot;, &quot;Automatically triggers the merchant&#39;s
ProximityPrompt once you reach them.&quot;, false, function(val)
NyXConfig.AutoInteractMerchant = val
end)
AddToggle(MerchantScroll, &quot;Respawn if Merchant Left&quot;, &quot;Automatically resets/respawns your character when the 3-
minute merchant leaves.&quot;, false, function(val)
NyXConfig.RespawnIfMerchantLeft = val
end)
AddButton(MerchantScroll, &quot;Walk Safely to Active Merchant Now&quot;, function()
WalkToActiveMerchantNow()
end)
-- // TAB 4: CONNECTIONS
AddSectionLabel(ConnScroll, &quot;Discord Webhook &amp; Server Link&quot;)
AddInput(ConnScroll, &quot;Webhook URL&quot;, NyXConfig.WebhookURL, &quot;https://discord.com/api/webhooks/...&quot;, function(txt)
NyXConfig.WebhookURL = txt:gsub(&quot;%s+&quot;, &quot;&quot;)
end)
local ConnUserIDBox = AddInput(ConnScroll, &quot;Discord User ID (Required for Pings)&quot;, NyXConfig.DiscordID, &quot;Ex:
123456789012345678&quot;, function(txt)
NyXConfig.DiscordID = txt:gsub(&quot;%D+&quot;, &quot;&quot;)
end)
AddInput(ConnScroll, &quot;Private Server Link&quot;, NyXConfig.PrivateServerLink, &quot;https://www.roblox.com/games/...&quot;,
function(txt)

NyXConfig.PrivateServerLink = txt
end)
AddButton(ConnScroll, &quot;Save Webhook &amp; Ping Config&quot;, function()
SaveWebhookConfig()
Notify(&quot;Config Saved&quot;, &quot;Webhook, User ID, Private Server &amp; Ping rules saved!&quot;, 3)
end)
AddButton(ConnScroll, &quot;Test Webhook Connection&quot;, function()
SendTestWebhookEmbed(false)
Notify(&quot;Webhook Test&quot;, &quot;Sent &#39;Webhook Test - Successfully&#39; to Discord!&quot;, 3)
end)
-- // TAB 5: PINGS (16 BIOMES + 3 MERCHANTS + MANDATORY USER ID CHECK)
AddSectionLabel(PingsScroll, &quot;Mandatory Discord User ID for Pings&quot;)
local PingUserIDBox = AddInput(PingsScroll, &quot;Your Discord User ID (Must Enter to Enable Pings)&quot;,
NyXConfig.DiscordID, &quot;Enter your numeric Discord User ID here...&quot;, function(txt)
local clean = txt:gsub(&quot;%D+&quot;, &quot;&quot;)
NyXConfig.DiscordID = clean
if ConnUserIDBox and ConnUserIDBox.Text ~= clean then
ConnUserIDBox.Text = clean
end
end)
AddButton(PingsScroll, &quot;Test Ping With User ID Now&quot;, function()
local cleanID = tostring(NyXConfig.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
if cleanID == &quot;&quot; then
Notify(&quot;User ID Required!&quot;, &quot;Please enter your numeric Discord User ID above before testing pings!&quot;, 4)
return
end
SendTestWebhookEmbed(true)
Notify(&quot;Ping Sent!&quot;, &quot;Sent test ping to &lt;@&quot; .. cleanID .. &quot;&gt; on Discord!&quot;, 3)
end)
AddSectionLabel(PingsScroll, &quot;Which Biomes Should Ping You? (16 Biomes)&quot;)
local PingBiomeGrid = Instance.new(&quot;Frame&quot;, PingsScroll)
PingBiomeGrid.Name = &quot;PingBiomeContainer&quot;
PingBiomeGrid.Size = UDim2.new(1, -6, 0, 118)
PingBiomeGrid.BackgroundTransparency = 1
local PGridLayout = Instance.new(&quot;UIGridLayout&quot;, PingBiomeGrid)
PGridLayout.CellSize = UDim2.new(0.24, -4, 0, 24)
PGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
for _, bName in ipairs(All16Biomes) do
local Chip = Instance.new(&quot;TextButton&quot;, PingBiomeGrid)
local isOn = NyXConfig.PingBiomes[bName] == true
Chip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
Chip.Text = bName
Chip.Font = Enum.Font.GothamBold
Chip.TextSize = 8
Chip.TextColor3 = Color3.fromRGB(245, 245, 255)
Instance.new(&quot;UICorner&quot;, Chip).CornerRadius = UDim.new(0, 5)
Chip.MouseButton1Click:Connect(function()
local cleanID = tostring(NyXConfig.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
if not NyXConfig.PingBiomes[bName] and cleanID == &quot;&quot; then
Notify(&quot;Discord User ID Required!&quot;, &quot;You must enter your Discord User ID above before selecting
biomes to ping!&quot;, 4)
return
end
NyXConfig.PingBiomes[bName] = not NyXConfig.PingBiomes[bName]
Chip.BackgroundColor3 = NyXConfig.PingBiomes[bName] and NyXConfig.UIAccentColor or Color3.fromRGB(22,
22, 36)
SaveWebhookConfig()
end)

end
AddSectionLabel(PingsScroll, &quot;Which Merchants Should Ping You? (Mari / Jester / Rin)&quot;)
local PingMerchantRow = Instance.new(&quot;Frame&quot;, PingsScroll)
PingMerchantRow.Name = &quot;PingMerchantContainer&quot;
PingMerchantRow.Size = UDim2.new(1, -6, 0, 32)
PingMerchantRow.BackgroundTransparency = 1
local MGridLayout = Instance.new(&quot;UIGridLayout&quot;, PingMerchantRow)
MGridLayout.CellSize = UDim2.new(0.32, -4, 0, 28)
MGridLayout.CellPadding = UDim2.new(0, 6, 0, 0)
for _, mName in ipairs(All3Merchants) do
local MChip = Instance.new(&quot;TextButton&quot;, PingMerchantRow)
local isOn = NyXConfig.PingMerchants[mName] == true
MChip.BackgroundColor3 = isOn and NyXConfig.UIAccentColor or Color3.fromRGB(22, 22, 36)
MChip.Text = mName:upper()
MChip.Font = Enum.Font.GothamBold
MChip.TextSize = 10
MChip.TextColor3 = Color3.fromRGB(245, 245, 255)
Instance.new(&quot;UICorner&quot;, MChip).CornerRadius = UDim.new(0, 6)
MChip.MouseButton1Click:Connect(function()
local cleanID = tostring(NyXConfig.DiscordID or &quot;&quot;):gsub(&quot;%D+&quot;, &quot;&quot;)
if not NyXConfig.PingMerchants[mName] and cleanID == &quot;&quot; then
Notify(&quot;Discord User ID Required!&quot;, &quot;You must enter your Discord User ID above before enabling
Merchant pings!&quot;, 4)
return
end
NyXConfig.PingMerchants[mName] = not NyXConfig.PingMerchants[mName]
MChip.BackgroundColor3 = NyXConfig.PingMerchants[mName] and NyXConfig.UIAccentColor or
Color3.fromRGB(22, 22, 36)
SaveWebhookConfig()
end)
end
-- // TAB 6: SETTING
AddSectionLabel(SettingScroll, &quot;Android Screen &amp; UI Customization&quot;)
AddSlider(SettingScroll, &quot;UI Scale (Resize for Mobile Screen)&quot;, 55, 125, 95, &quot;%&quot;, function(val)
NyXConfig.UIScalePercent = val
RecalculateResponsiveScale()
end)
local ColorRow = Instance.new(&quot;Frame&quot;, SettingScroll)
ColorRow.Size = UDim2.new(1, -6, 0, 28)
ColorRow.BackgroundTransparency = 1
local ColorGrid = Instance.new(&quot;UIGridLayout&quot;, ColorRow)
ColorGrid.CellSize = UDim2.new(0.2, -4, 0, 26)
ColorGrid.CellPadding = UDim2.new(0, 4, 0, 0)
local ThemePresets = {
{Name = &quot;Purple&quot;, Col = Color3.fromRGB(135, 95, 255)},
{Name = &quot;Cyan&quot;, Col = Color3.fromRGB(0, 210, 255)},
{Name = &quot;Crimson&quot;, Col = Color3.fromRGB(255, 65, 90)},
{Name = &quot;Emerald&quot;, Col = Color3.fromRGB(46, 213, 115)},
{Name = &quot;Gold&quot;, Col = Color3.fromRGB(255, 175, 45)}
}
for _, preset in ipairs(ThemePresets) do
local CBtn = Instance.new(&quot;TextButton&quot;, ColorRow)
CBtn.BackgroundColor3 = preset.Col
CBtn.Text = preset.Name
CBtn.Font = Enum.Font.GothamBold
CBtn.TextSize = 9
CBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new(&quot;UICorner&quot;, CBtn).CornerRadius = UDim.new(0, 6)

CBtn.MouseButton1Click:Connect(function()
UpdateAccentColor(preset.Col)
end)
end
AddSlider(SettingScroll, &quot;Window Transparency&quot;, 0, 65, 8, &quot;%&quot;, function(val)
NyXConfig.GlassTransparency = val / 100
MainWindow.BackgroundTransparency = NyXConfig.GlassTransparency
end)
AddSectionLabel(SettingScroll, &quot;Battery Saver, Performance &amp; AFK&quot;)
AddToggle(SettingScroll, &quot;OLED Black Screen Battery Saver&quot;, &quot;Covers the screen in pure black while keeping NyX
UI &amp; ND button accessible.&quot;, false, function(val)
NyXConfig.BlackScreenSaver = val
BlackSaverFrame.Visible = val
end)
AddToggle(SettingScroll, &quot;Enable Anti-AFK&quot;, &quot;Prevents 20-minute idle disconnect.&quot;, true, function(val)
NyXConfig.AntiAFK = val
end)
AddToggle(SettingScroll, &quot;Auto Reconnect on Disconnect / Kick&quot;, &quot;Automatically rejoins the server if your
connection drops.&quot;, true, function(val)
NyXConfig.AutoReconnect = val
end)
AddToggle(SettingScroll, &quot;Disable 3D Rendering (CPU / GPU Saver)&quot;, &quot;Turns off 3D world rendering for low-
resource AFK macroing.&quot;, false, function(val)
NyXConfig.Disable3DRendering = val
pcall(function() RunService:Set3dRenderingEnabled(not val) end)
end)
AddButton(SettingScroll, &quot;Boost FPS (Remove Particles &amp; Shadows)&quot;, function()
pcall(function()
Lighting.GlobalShadows = false
for _, v in ipairs(Workspace:GetDescendants()) do
if v:IsA(&quot;ParticleEmitter&quot;) or v:IsA(&quot;Trail&quot;) or v:IsA(&quot;Smoke&quot;) or v:IsA(&quot;Fire&quot;) then
v.Enabled = false
elseif v:IsA(&quot;BasePart&quot;) then
v.Material = Enum.Material.SmoothPlastic
end
end
end)
Notify(&quot;FPS Boost&quot;, &quot;Particles disabled and textures optimized!&quot;, 3)
end)
AddSlider(SettingScroll, &quot;FPS Cap&quot;, 15, 240, 60, &quot; FPS&quot;, function(val)
if setfpscap then pcall(setfpscap, val) end
end)
AddSectionLabel(SettingScroll, &quot;Server &amp; Script Management&quot;)
AddButton(SettingScroll, &quot;Rejoin Current Server&quot;, function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
AddButton(SettingScroll, &quot;Uninstall / Destroy NyX Detector Macro&quot;, function()
ScriptRunning = false
pcall(function() RunService:Set3dRenderingEnabled(true) end)
if NyXConfig.EnableBiomeWebhook then
local finalElapsed = (MacroStartTime &gt; 0) and (os.time() - MacroStartTime) or 0
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
if pendingCount &gt;= 2 and pendingBiome ~= confirmedBiome then
local previousBiome = confirmedBiome
confirmedBiome = pendingBiome
NyXConfig.CurrentDetectedBiome = confirmedBiome
BiomeValueLabel.Text = confirmedBiome
if BiomeData[confirmedBiome] and BiomeData[confirmedBiome].Hex then
BiomeValueLabel.TextColor3 = BiomeData[confirmedBiome].Hex
end
if NyXConfig.EnableBiomeWebhook then
if previousBiome ~= &quot;NORMAL&quot; and BiomeData[previousBiome] then
local prevInfo = BiomeData[previousBiome]
SendBiomeEndedEmbed(previousBiome, prevInfo.Color, prevInfo.Image)
end
if confirmedBiome ~= &quot;NORMAL&quot; and BiomeData[confirmedBiome] then
local newInfo = BiomeData[confirmedBiome]
SendBiomeStartedEmbed(confirmedBiome, newInfo.Color, newInfo.Image)
end
end
if NyXConfig.StopAutoBiomes[confirmedBiome] then
Notify(&quot;Stop Auto In&quot;, &quot;Detected &quot; .. confirmedBiome .. &quot;! Pausing item usage.&quot;, 4)
end
end
end
end)
-- 2. Merchant Lifecycle Loop (Strict Physical Model Verification + 3-Minute Countdown -&gt; Merchant Left = NONE)
task.spawn(function()
while ScriptRunning and task.wait(1) do
local worldMerchant, worldPos = FindMerchantWorldPosition()
if worldMerchant and NyXConfig.CurrentMerchant == &quot;NONE&quot; then
SetMerchantArrivedState(worldMerchant, worldPos)
elseif worldMerchant and NyXConfig.CurrentMerchant == worldMerchant:upper() then
NyXConfig.MerchantPosition = worldPos
end
if NyXConfig.CurrentMerchant ~= &quot;NONE&quot; then
local elapsed = os.time() - NyXConfig.MerchantSpawnTimestamp

local remaining = math.max(0, NyXConfig.MerchantDuration - elapsed)
local mMins = math.floor(remaining / 60)
local mSecs = remaining % 60
local timerText = string.format(&quot;%s (%02d:%02d)&quot;, NyXConfig.CurrentMerchant, mMins, mSecs)
MerchantValueLabel.Text = timerText
MTabStatusLbl.Text = &quot;Status: &quot; .. NyXConfig.CurrentMerchant .. &quot; Active (&quot; ..
string.format(&quot;%02d:%02d&quot;, mMins, mSecs) .. &quot; left)&quot;
if NyXConfig.MerchantPosition then
local p = NyXConfig.MerchantPosition
MTabCoordsLbl.Text = string.format(&quot;XYZ Coordinates: %.0f, %.0f, %.0f&quot;, p.X, p.Y, p.Z)
end
-- Default 3-Minute Rule: Once 180s has elapsed (or model despawned after 15s grace), Merchant Left
= NONE
if remaining &lt;= 0 or (not worldMerchant and elapsed &gt; 15) then
SetMerchantLeftState(remaining &lt;= 0 and &quot;3m Timer Expired&quot; or &quot;Model Despawned&quot;)
end
else
MerchantValueLabel.Text = &quot;NONE&quot;
MTabStatusLbl.Text = &quot;Status: NONE (Waiting for Spawn)&quot;
MTabCoordsLbl.Text = &quot;XYZ Coordinates: N/A&quot;
end
end
end)
-- 3. Auto Collect Natural Ground Items Loop (Potions / Coins via River-Safe Walk)
task.spawn(function()
while ScriptRunning and task.wait(2.5) do
if NyXConfig.AutoCollectItems and not isWalkingPath and NyXConfig.CurrentMerchant == &quot;NONE&quot; then
pcall(function()
local char = LocalPlayer.Character
local root = char and char:FindFirstChild(&quot;HumanoidRootPart&quot;)
if not root then return end
local DropFolder = Workspace:FindFirstChild(&quot;DroppedItems&quot;) or Workspace:FindFirstChild(&quot;Items&quot;)
or Workspace
for _, item in ipairs(DropFolder:GetChildren()) do
local n = item.Name:upper()
if n:find(&quot;POTION&quot;) or n:find(&quot;COIN&quot;) or n:find(&quot;LUCKY&quot;) or n:find(&quot;SPEED&quot;) or
n:find(&quot;GILDED&quot;) then
local part = item:IsA(&quot;BasePart&quot;) and item or item:FindFirstChildWhichIsA(&quot;BasePart&quot;)
if part and (part.Position - root.Position).Magnitude &lt; 160 and not
IsWaypointOverWaterOrVoid(part.Position) then
WalkSafelyToTargetPosition(part.Position, function()
return not item.Parent or not NyXConfig.AutoCollectItems or
NyXConfig.CurrentMerchant ~= &quot;NONE&quot;
end)
local prompt = item:FindFirstChildWhichIsA(&quot;ProximityPrompt&quot;, true)
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
-- 4. Auto Biome Randomizer &amp; Strange Controller Loop
task.spawn(function()
while ScriptRunning do
task.wait(1)
if NyXConfig.AutoBiomeRandomizer or NyXConfig.AutoStrangeController then
local currentB = NyXConfig.CurrentDetectedBiome

local shouldStop = NyXConfig.StopAutoBiomes[currentB] == true
if not shouldStop then
if NyXConfig.AutoBiomeRandomizer then
UseItemWithInventoryFailsafe(&quot;Biome Randomizer&quot;)
task.wait(1)
end
if NyXConfig.AutoStrangeController and not NyXConfig.StopAutoBiomes[GetAccurateServerBiome()]
then
UseItemWithInventoryFailsafe(&quot;Strange Controller&quot;)
end
end
local waited = 0
while ScriptRunning and waited &lt; NyXConfig.UseInterval do
task.wait(1)
waited = waited + 1
if not NyXConfig.AutoBiomeRandomizer and not NyXConfig.AutoStrangeController then
break
end
end
end
end
end)
