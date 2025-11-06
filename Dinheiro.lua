-- Coloca esse script em ServerScriptService
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local moneyStore = DataStoreService:GetDataStore("PlayerMoneyData")
 
local folder = ReplicatedStorage:FindFirstChild("RemoteEvents") or Instance.new("Folder")
folder.Name = "RemoteEvents"
folder.Parent = ReplicatedStorage
 
local function getEvent(name)
    local e = folder:FindFirstChild(name)
    if not e then
        e = Instance.new("RemoteEvent")
        e.Name = name
        e.Parent = folder
    end
    return e
end
 
local OpenShopEvent = getEvent("OpenShopEvent")
local PurchaseRequest = getEvent("PurchaseRequest")
local PurchaseResult = getEvent("PurchaseResult")
 
local function saveMoney(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local dinheiro = leaderstats:FindFirstChild("Dinheiro")
        if dinheiro then
            local success, err = pcall(function()
                moneyStore:SetAsync(player.UserId, dinheiro.Value)
            end)
            if success then
                print("💾 Dinheiro de " .. player.Name .. " salvo com sucesso!")
            else
                warn("❌ Erro ao salvar dinheiro de " .. player.Name .. ": " .. err)
            end
        end
    end
end
 
game.Players.PlayerAdded:Connect(function(player)
    
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local dinheiro = Instance.new("IntValue")
    dinheiro.Name = "Dinheiro"
    dinheiro.Parent = leaderstats
    
    local success, data = pcall(function()
        return moneyStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        dinheiro.Value = data
        print("💰 Dinheiro de " .. player.Name .. " carregado: " .. data)
    else
        dinheiro.Value = 0 -- dinheiro inicial, muda se vc quiser para eb/RP recomendo deixar no 0
        print("💵 Dinheiro inicial definido para " .. player.Name)
    end
end)
 
game.Players.PlayerRemoving:Connect(function(player)
    saveMoney(player)
end)
 
game:BindToClose(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        saveMoney(player)
    end
end)
 
PurchaseRequest.OnServerEvent:Connect(function(player, itemName, price)
    local armasFolder = ReplicatedStorage:FindFirstChild("Armas")
    if not armasFolder then
        PurchaseResult:FireClient(player, false, "⚠️ Pasta 'Armas' não encontrada no ReplicatedStorage!")
        return
    end
    
    local arma = armasFolder:FindFirstChild(itemName)
    if not arma then
        PurchaseResult:FireClient(player, false, "❌ Arma '" .. itemName .. "' não encontrada!")
        return
    end
    
    local dinheiro = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Dinheiro")
    if not dinheiro then
        PurchaseResult:FireClient(player, false, "Erro ao acessar o saldo!")
        return
    end
    
    if dinheiro.Value >= price then
        dinheiro.Value -= price
        local clone = arma:Clone()
        clone.Parent = player.Backpack
        PurchaseResult:FireClient(player, true, "✅ Você comprou " .. itemName .. "!")
    else
        PurchaseResult:FireClient(player, false, "💸 Dinheiro insuficiente!")
    end
end)
