-- Coloca em ServerScriptService
-- Nn meche aqui!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local se = Instance.new("RemoteEvent")
se.Name = "OpenShopEvent"
se.Parent = ReplicatedStorage
 
local inscreve = Instance.new("RemoteEvent")
inscreve.Name = "PurchaseRequest"
inscreve.Parent = ReplicatedStorage
 
local pls = Instance.new("RemoteEvent")
pls.Name = "PurchaseResult"
pls.Parent = ReplicatedStorage
