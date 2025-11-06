-- Coloca o script em StarterPlayerScripts (fica dentro de StarterPlayer)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("RemoteEvents")
local OpenShopEvent = Events:WaitForChild("OpenShopEvent")
local PurchaseRequest = Events:WaitForChild("PurchaseRequest")
local PurchaseResult = Events:WaitForChild("PurchaseResult")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = playerGui:FindFirstChild("ShopGui")
if not gui then
    gui = Instance.new("ScreenGui")
    gui.Name = "ShopGui"
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 5 
    gui.Parent = playerGui
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.85, 0, 0.6, 0)
frame.Position = UDim2.new(0.075, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.05
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "🛒 Loja de Armas"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0.05, 0, 0.05, 0)
title.Size = UDim2.new(0.7, 0, 0.1, 0)
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 26
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.Size = UDim2.new(0.1, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.88, 0, 0.05, 0)
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(0.9, 0, 0.7, 0)
container.Position = UDim2.new(0.05, 0, 0.2, 0)
container.CanvasSize = UDim2.new(0, 0, 2, 0)
container.ScrollBarThickness = 8
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0.45, -10, 0.25, -10)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.Parent = container

local function createWeaponCard(name, price)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    card.Parent = container
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local label = Instance.new("TextLabel")
    label.Text = name .. "\n💵 " .. price
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0.6, 0)
    label.Parent = card
    
    local buyBtn = Instance.new("TextButton")
    buyBtn.Text = "Comprar"
    buyBtn.Font = Enum.Font.GothamBold
    buyBtn.TextSize = 22
    buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    buyBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
    buyBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    buyBtn.Parent = card
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = buyBtn
    
    buyBtn.MouseButton1Click:Connect(function()
        PurchaseRequest:FireServer(name, price)
    end)
end

local armas = {
{nome = "M4A1", preco = 5000},
{nome = "AK-47", preco = 7000},
{nome = "Sniper", preco = 50000},
{nome = "MAG-7", preco = 1},
{nome = "Pistola", preco = 10000}
}

for _, arma in ipairs(armas) do
    createWeaponCard(arma.nome, arma.preco)
end

-- Resultado da compra
PurchaseResult.OnClientEvent:Connect(function(_, sucesso, mensagem)
    local msg = Instance.new("TextLabel")
    msg.Text = mensagem
    msg.Font = Enum.Font.GothamBold
    msg.TextSize = 22
    msg.TextColor3 = sucesso and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    msg.BackgroundTransparency = 1
    msg.Position = UDim2.new(0.25, 0, 0.85, 0)
    msg.Size = UDim2.new(0.5, 0, 0.1, 0)
    msg.Parent = frame
    game.Debris:AddItem(msg, 2)
end)

OpenShopEvent.OnClientEvent:Connect(function()
    gui.Enabled = true
end)
)