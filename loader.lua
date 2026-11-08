-- t1nkq hub | Loader
local StarterGui = game:GetService("StarterGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local HttpService = game:GetService("HttpService")

-- URL твоего Cloudflare Worker (поменяй после деплоя)
local API_URL = "https://t1nkq-hub.zapadunskiy1354.workers.dev"

-- Функция для показа уведомлений в Roblox
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- 1. Проверка наличия ключа
local key = getgenv and getgenv().script_key or _G.script_key
if not key or type(key) ~= "string" or #key < 5 then
    notify("t1nkq hub", "Ошибка: укажите ваш ключ в переменной script_key!", 6)
    return
end

-- 2. Получение данных клиента
local placeId = tostring(game.PlaceId)
local okHwid, hwid = pcall(function()
    return RbxAnalyticsService:GetClientId()
end)

if not okHwid or not hwid then
    notify("t1nkq hub", "Ошибка получения HWID клиента.", 6)
    return
end

notify("t1nkq hub", "Проверка лицензии...", 3)

-- 3. Формирование URL и запрос к серверу
local url = string.format(
    "%s/script/%s?key=%s&hwid=%s",
    API_URL,
    placeId,
    HttpService:UrlEncode(key),
    HttpService:UrlEncode(hwid)
)

local okReq, response = pcall(function()
    return game:HttpGet(url)
end)

if not okReq or not response then
    notify("t1nkq hub", "Ошибка сети: сервер недоступен.", 6)
    return
end

-- 4. Обработка ошибок от сервера (сервер возвращает текст с префиксом ERROR:)
if string.sub(response, 1, 6) == "ERROR:" then
    local errMsg = string.sub(response, 8)
    notify("t1nkq hub — Отказ", errMsg, 8)
    return
end

-- 5. Компиляция и запуск полученного скрипта
local fn, syntaxErr = loadstring(response)
if not fn then
    notify("t1nkq hub", "Ошибка загрузки модуля.", 6)
    warn("[t1nkq hub] Load error:", syntaxErr)
    return
end

notify("t1nkq hub", "Лицензия активна! Загрузка...", 4)
task.spawn(fn)