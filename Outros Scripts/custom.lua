-- Customização de Interface studio lite
local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

 
local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local studioGui = playerGui:FindFirstChild("StudioGui")

 

if not studioGui then

    warn("⚠️ StudioGui not found in PlayerGui")

    return

end

 

-- destiny credits

local gui = script

local old = studioGui:FindFirstChild(gui.Name)

if old and old ~= gui then

    old:Destroy()

end

gui.Parent = studioGui

 

-- ===== Color  =====

local DARK_BLUE = Color3.fromRGB(0, 0, 0)

local WHITE = Color3.new(1, 1, 1)

local BLACK = Color3.new(0, 0, 0)

local DARKER_BLACK = Color3.fromRGB(10, 10, 10)

local colorHandlesR = Color3.fromRGB(128, 0, 128)

local colorHandlesG = Color3.fromRGB(0, 0, 255)

local colorHandlesB = Color3.fromRGB(0, 0, 0)

local colorSelectionBox = Color3.fromRGB(0, 255, 0)

 

local targetNames = {

HandlesR = colorHandlesR,

HandlesG = colorHandlesG,

HandlesB = colorHandlesB,

}

 

-- ===== Dark Mode  =====

local function styleTextGui(guiObject, bgColor)

    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then

        guiObject.BackgroundColor3 = bgColor

        guiObject.TextColor3 = DARK_BLUE

        guiObject.TextStrokeColor3 = WHITE

        guiObject.TextStrokeTransparency = 0

        guiObject.Font = Enum.Font.FredokaOne

    end

end

 

local function makeGuiDark(guiObject)

    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then

        guiObject.BackgroundColor3 = BLACK

        guiObject.TextColor3 = DARK_BLUE

        guiObject.TextStrokeColor3 = WHITE

        guiObject.TextStrokeTransparency = 0

        guiObject.Font = Enum.Font.FredokaOne

    elseif guiObject:IsA("Frame") or guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then

        guiObject.BackgroundColor3 = BLACK

    elseif guiObject:IsA("ScrollingFrame") then

        guiObject.BackgroundColor3 = BLACK

        guiObject.ScrollBarImageColor3 = WHITE

    end

end

 

local function applyDarkMode(container)

    for _, obj in pairs(container:GetDescendants()) do

        makeGuiDark(obj)

        if obj:IsA("ScrollingFrame") then

            for _, descendant in pairs(obj:GetDescendants()) do

                styleTextGui(descendant, DARKER_BLACK)

            end

        end

    end

end

 

applyDarkMode(studioGui)

 

-- ===== Color Assignment Helpers =====

local function trySetColor(obj, color)

    local success = false

    local function tryAssign(fn)

        local ok, _ = pcall(fn)

        if ok then success = true end

    end

    tryAssign(function() obj.Color3 = color end)

        tryAssign(function() obj.Color = color end)

            tryAssign(function() obj.BrickColor = BrickColor.new(color) end)

                tryAssign(function() obj.SurfaceColor3 = color end)

                    tryAssign(function() obj:SetAttribute("Color3", color) end)

                        tryAssign(function() obj:SetAttribute("Color", color) end)

                            tryAssign(function()

                                for _, c in pairs(obj:GetChildren()) do

                                    if c:IsA("SelectionBox") then

                                        c.Color3 = color

                                    elseif c:IsA("BoxHandleAdornment") or c:IsA("HandleAdornment") then

                                        if rawget(c, "Color3") ~= nil then

                                            c.Color3 = color

                                        elseif rawget(c, "Color") ~= nil then

                                            c.Color = color

                                        end

                                    end

                                end

                            end)

                            return success

                        end

                        

                        local function createFallbackSelectionBox(obj, color)

                            local success, adornee = pcall(function() return obj.Adornee end)

                                if not success or not adornee then return nil end

                                

                                local box = Instance.new("SelectionBox")

                                box.Name = "FallbackSelectionFor_" .. (obj.Name or "unknown")

                                box.Adornee = adornee

                                box.Color3 = color

                                box.LineThickness = 0.02

                                box.Parent = studioGui

                                return box

                            end

                            

                            local function processObject(obj)

                                if targetNames[obj.Name] then

                                    local col = targetNames[obj.Name]

                                    local ok = trySetColor(obj, col)

                                    if not ok then

                                        createFallbackSelectionBox(obj, col)

                                    end

                                elseif obj:IsA("SelectionBox") then

                                    pcall(function() obj.Color3 = colorSelectionBox end)

                                    end

                                    end

                                        

                                        for _, obj in pairs(studioGui:GetDescendants()) do

                                            processObject(obj)

                                        end

                                        

                                        studioGui.DescendantAdded:Connect(function(obj)

                                            task.defer(function()

                                                processObject(obj)

                                            end)

                                        end)

                                        

                                        -- ===== Spin  =====

                                        local function setupSpinImage(imgName, imageId, size)

                                            local img = studioGui:WaitForChild(imgName)

                                            img.Image = imageId

                                            img.Size = size

                                            img.BackgroundTransparency = 1

                                            return img

                                        end

                                        

                                        local img1 = setupSpinImage("WorkingImageLabel1", "rbxassetid://11569282129", UDim2.new(0, 35, 0, 35))

                                        local img2 = setupSpinImage("WorkingImageLabel2", "rbxassetid://11569282129", UDim2.new(0, 35, 0, 35))

                                        

                                        RunService.RenderStepped:Connect(function(deltaTime)

                                            img1.Rotation = (img1.Rotation + 90 * deltaTime) % 360

                                            img2.Rotation = (img2.Rotation + 90 * deltaTime) % 360

                                        end)

                                        

                                        -- ==== Whoa =====

                                        local function fixPartselButton(parentName, childName, imageId, color, size, position, text)

                                            local mainBar = studioGui:WaitForChild("MainBar")

                                            local partsel = mainBar:WaitForChild(parentName)

                                            local partImage = partsel:WaitForChild(childName)

                                            

                                            partImage.Image = imageId

                                            partImage.ImageColor3 = color

                                            partImage.Size = size

                                            if position then partImage.Position = position end

                                            if text then partsel.Text = text end

                                            partImage.BackgroundTransparency = 0

                                        end

                                        

                                        fixPartselButton("play", "play", "rbxassetid://77800091330319", Color3.new(1,1,1), UDim2.new(0,27,0,28), UDim2.new(0,7,0,5))

                                        fixPartselButton("select", "select", "rbxassetid://17095495324", Color3.fromRGB(40,132,255), UDim2.new(0,27,0,28), UDim2.new(0,5,0,5))

                                        fixPartselButton("rotate", "rotate", "rbxassetid://84031887426375", Color3.new(1,1,1), UDim2.new(0,27,0,28), UDim2.new(0,5,0,5))

                                        fixPartselButton("partsel", "part", "rbxassetid://14944375078", Color3.new(1,1,1), UDim2.new(0,35,0,35), nil, "Insert obj")

                                        fixPartselButton("move", "move", "rbxassetid://5172066892", Color3.fromRGB(40,132,255), UDim2.new(0,27,0,28), UDim2.new(0,5,0,5))

                                        

                                        -- ===== Toolbox =====

                                        local mainBar = studioGui:WaitForChild("MainBar")

                                        local toolboxFirst = mainBar:WaitForChild("toolbox")

                                        local toolboxSecond = toolboxFirst:WaitForChild("toolbox") -- the actual image

                                        toolboxSecond.Image = "rbxassetid://116305154568640"

                                        toolboxSecond.ImageColor3 = Color3.new(1, 1, 1)

                                        

                                        
