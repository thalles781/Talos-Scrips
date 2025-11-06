-- Esse script é opcional, coloca dentro da parte que vc botou a loja
local part = script.Parent
 
local sla = Instance.new("BillboardGui")
 
sla.Adornee = part
sla.Parent = part
sla.Size = UDim2.new(0, 200, 0, 50)
sla.StudsOffset = Vector3.new(0, 4, 0)
sla.MaxDistance = 20 
sla.AlwaysOnTop = false
 
local texto = Instance.new("TextLabel")

texto.Parent = sla
texto.Size = UDim2.new(1, 0, 1, 0)
texto.BackgroundTransparency = 1
texto.Text = "Loja de Armas"
texto.Font = Enum.Font.GothamBlack
texto.TextColor3 = Color3.fromRGB(255, 255, 255)
texto.TextScaled = true
