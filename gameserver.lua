game:GetService("ContentProvider"):SetBaseUrl("roblox.com")
game:GetService("ScriptContext").ScriptsDisabled = true
local plr = game.Players:CreateLocalPlayer(0)
plr:LoadCharacter()
local char = plr.Character or plr.CharacterAdded:Wait()
local https = game:GetService("HttpService")
https.HttpEnabled = true
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

local function CallOnChildren(Instance, FunctionToCall)
	FunctionToCall(Instance)
	for _, Child in next, Instance:GetChildren() do
		CallOnChildren(Child, FunctionToCall)
	end
end

local function GetDescendants(StartInstance)
	local List = {}
	CallOnChildren(StartInstance, function(Item)
		List[#List+1] = Item;
	end)
	return List
end

local function GetDescendantsJSON(StartInstance)
	local List = {}
	CallOnChildren(StartInstance, function(Item)
		List[#List+1] = {Name = Item.Name, ClassName = Item.ClassName, Parent = Item.Parent.Name};
	end)
	return List
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
	local avacont = Instance.new("Model",game)
	apply(appearance,avacont,true)
	for i, v in pairs(GetDescendants(avacont)) do
		v.Parent = char
		print(v.ClassName)
		if v:IsA("Part") then
			v.CFrame = char.Head
		end
	end
	--ungroup(avacont,char)
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
local render = {game:GetService("ThumbnailGenerator"):Click("PNG", 100, 100, true)}
print(render[1])
