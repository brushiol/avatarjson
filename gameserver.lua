local plr = game.Players:CreateLocalPlayer(0)
plr:LoadCharacter()
local char = plr.Character or plr.CharacterAdded:Wait()
local https = game:GetService("HttpService")
https.HttpEnabled = true
local port = 4299 --gayy
local site = "https://raw.githubusercontent.com/brushiol/avatarjson/refs/heads/main/avatar1.json"
local appearance = https:JSONDecode(https:GetAsync(site))
--local classes = https:JSONDecode(https:GetAsync("https://setup.roblox.com/version-0f92b7995f2446f0-API-Dump.json"))

--FUNCTIONS--
function namefind(t,name)
	for i, v in pairs(t) do
		if v.Name and v.Name == name then
			return i, v
		end
	end
end

function GetDescendants(instance)
    local descendants = {}
    function recurse(obj)
        for _, child in ipairs(obj:GetChildren()) do
            descendants[#descendants+1] = child
            recurse(child)
        end
    end
    recurse(instance)
    return descendants
end

function GetDescendantsJSON(instance)
    local descendants = {}
    function recurse(obj)
        for _, child in ipairs(obj:GetChildren()) do
            descendants[#descendants+1] = {Name = child.Name, ClassName = child.ClassName, Parent = child.Parent.Name};
            recurse(child)
        end
    end
    recurse(instance)
    return descendants
end

function apply(a,parent,start)
	for i, v in pairs(a) do
		--print(https:JSONEncode(v))
		if start and char:FindFirstChild(i) then
			parent = char
			for ii, vv in pairs(v) do
				if parent[i][ii] then 
					local new = vv
					if ii == "BrickColor" then
						new = BrickColor.new(new)
					end
					parent[i][ii] = new
				end
			end
		elseif v["ClassName"] then
			local new = Instance.new(v["ClassName"])
			new.Parent = parent
			new.Name = i		
			for ii, vv in pairs(v) do
				--print(i,ii)
				if type(vv) ~= "table" and ii ~= "ClassName" and new[ii] then 
					new[ii] = vv
				elseif type(vv) == "table" then
					apply(vv,new)
				end
			end
		end
	end
end
function ungroup(model, parent)
	if model:IsA("Model") then
		parent = parent or model.Parent
		for i, v in pairs(model:GetChildren()) do
			v.Parent = parent
		end
		model:Destroy()
	end
end

--CHARACTER SETUP--
local succ, err = pcall(function()
	apply(appearance,char,true)
	for i,v in pairs(char:GetChildren()) do
		if v:IsA("Tool") then
			char.Torso["Right Shoulder"].CurrentAngle = math.pi / 2
		end
	end
	--print(https:JSONEncode(GetDescendantsJSON(char)))
end)
if not succ then
	warn(err)
end

--RENDER--
local size = 512
local ip = "localhost:"..port
local url = "http://"..ip.."/render"
local click = {game:GetService("ThumbnailGenerator"):Click("PNG", size, size, false)}
local render = click[1]
local post = https:PostAsync(url, https:JSONEncode({data = render}))
print(render, post)