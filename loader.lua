-- t1nkq hub | Loader
local LOADER_URL = "https://t1nkq-hub.t1nkq.workers.dev/loader?t=" .. tostring(math.floor(tick()))

local function notifyError(msg)
    warn("[t1nkq hub] " .. tostring(msg))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "t1nkq hub",
            Text = tostring(msg),
            Duration = 6
        })
    end)
end

local okHttp, source = pcall(function()
    return game:HttpGet(LOADER_URL)
end)

if not okHttp or type(source) ~= "string" or #source < 10 then
    notifyError("РќРµ СѓРґР°Р»РѕСЃСЊ РїРѕРґРєР»СЋС‡РёС‚СЊСЃСЏ Рє СЃРµСЂРІРµСЂСѓ t1nkq hub.")
    return
end

local fn, compileErr = loadstring(source)
if not fn then
    notifyError("РћС€РёР±РєР° Р·Р°РіСЂСѓР·РєРё РёРЅС‚РµСЂС„РµР№СЃР°.")
    warn("[t1nkq hub] Compile error:", compileErr)
    return
end

local okRun, runErr = pcall(fn)
if not okRun then
    notifyError("РћС€РёР±РєР° Р·Р°РїСѓСЃРєР° РёРЅС‚РµСЂС„РµР№СЃР°.")
    warn("[t1nkq hub] Runtime error:", runErr)
end
