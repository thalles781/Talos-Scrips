-- Coloca o script dentro da parte que vc quer q seja a loja
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OpenShopEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("OpenShopEvent")

for _, c in ipairs(script.Parent:GetChildren()) do
    if c:IsA("ProximityPrompt") then
        c:Destroy()
    end
end

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Abrir Loja"
prompt.ObjectText = "Loja de Armas"
prompt.HoldDuration = 0
prompt.RequiresLineOfSight = false
prompt.MaxActivationDistance = 10
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.Parent = script.Parent

prompt.Triggered:Connect(function(player)
    OpenShopEvent:FireClient(player)
end)
print("😶‍🌫️ deixa o like")
