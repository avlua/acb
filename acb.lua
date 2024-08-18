--[[
	Loaded Check
--]]
if not game:IsLoaded() then
	game.Loaded:Wait();
end;
local waitplayer = game.Players.LocalPlayer;
if waitplayer.Character then
	local waithrp = waitplayer.Character:WaitForChild("HumanoidRootPart");
else
    waitplayer.CharacterAdded:Wait()
    local waithrp = waitplayer.Character:WaitForChild("HumanoidRootPart")
end

--[[
	Roblox Services & Variables
--]]
local workspace = game:GetService("Workspace");
local player = game.Players.LocalPlayer;
local placeid = game.PlaceId;
local character = player.Character;
local humanoidRootPart = character:WaitForChild("HumanoidRootPart");
local virtualuser = game:GetService("VirtualUser");
local teleportservice = game:GetService("TeleportService");
local proximitypromptservice = game:GetService("ProximityPromptService");
local stats = player:WaitForChild("Stats")
local playergui = player:WaitForChild("PlayerGui")
local gamenpcs = workspace:WaitForChild("NPCs")

--[[
	Libraries
--]]
local Fluent = (loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")))();
local InterfaceManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")))();

--[[
	Helper Functions
--]]
local function generateRandomKey(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	local key = "";
	for i = 1, length do
		local randIndex = math.random(1, #chars);
		key = key .. string.sub(chars, randIndex, randIndex);
		task.wait(0.1);
	end;
	return key;
end;
local function antiAfk()
	player.Idled:Connect(function()
		virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		task.wait(0.1);
		virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end);
	print("Anti Afk enabled");
end;
local function rejoinGame()
	task.wait(1);
	teleportservice:Teleport(placeid, player);
end;

--[[
	Library Variables
--]]
local statsParagraph, disclaimerParagraph;
local updatingParagraph = false;
local randomKey = generateRandomKey(9);
_G[randomKey] = {};
local guiWindow = {};
local Hub = _G[randomKey];

--[[
	Teleport Tables
--]]
local otherLocations = {
	"Sword",
	"Old Position Sword",
};
local otherCoordinates = {
	["Sword"] = Vector3.new(-7714.85205078125, 211.64096069335938, -9588.51953125),
	["Old Position Sword"] = Vector3.new(0, 0, 0),
};
local npcTeleports = {
	"Heaven Infinite",
	"Heaven Tower",
	"Charm Merchant",
	"Potion Shop",
	"Card Fusion",
	"Daily Chest",
	"Card Index",
	"Strange Trader",
	"Card Packs",
	"Luck Fountain"
};
local mobTeleports = {
	"Earth's Mightiest",
	"Prince",
	"Knucklehead Ninja",
	"Rogue Ninja",
	"Limitless",
	"Substitute Reaper",
	"Rubber Boy",
	"Bald Hero",
};
local bossTeleports = {
	"Cifer",
	"King Of Curses",
	"Shinobi God",
	"Galactic Tyrant",
	"Wicked Weaver",
	"Cosmic Menace"
}
local areaTeleports = {
	"Heavens Arena",
	"Roll Leaderboard",
	"Card Leaderboard",
	"Spawn",
};
local npcTeleportsCoordinates = {
	["Heaven Infinite"] = Vector3.new(454.615417, 260.529327,5928.994629),
	["Heaven Tower"] = Vector3.new(451.595367, 247.374268, 5980.721191),
	["Charm Merchant"] = Vector3.new(-7764.36572265625, 179.71200561523438, -9194.859375),
	["Potion Shop"] = Vector3.new(-7744.11376953125, 180.14158630371094, -9369.5908203125),
	["Card Fusion"] = Vector3.new(13131.391602, 84.905922, 11281.490234),
	["Card Index"] = Vector3.new(-7846.603515625, 180.50991821289062, -9371.1884765625),
	["Daily Chest"] = Vector3.new(-7785.53173828125, 180.8318634033203, -9339.9423828125),
	["Strange Trader"] = Vector3.new(523.097717, 247.374268, 6017.144531),
	["Card Packs"] = Vector3.new(-7708.05810546875, 180.46566772460938, -9310.736328125),
	["Luck Fountain"] = Vector3.new(-7811.5751953125, 180.41331481933594, -9278.078125)
};
local mobsTeleportsCoordinates = {
	["Earth's Mightiest"] = Vector3.new(10939.111328, 340.554169, -5141.633789),
	["Prince"] = Vector3.new(10987.201172, 344.049896, -5241.321777),
	["Knucklehead Ninja"] = Vector3.new(4219.748535, 31.724997, 7506.525391),
	["Rogue Ninja"] = Vector3.new(4306.954102, 31.724993, 7506.855469),
	["Limitless"] = Vector3.new(-12.537902, 272.422241, 5996.07666),
	["Substitute Reaper"] = Vector3.new(-7901.751465, 734.372009, 6714.296875),
	["Rubber Boy"] = Vector3.new(13150.526367, 84.124977, 11365.570312),
	["Bald Hero"] = Vector3.new(-11790.704102, 152.171967, -8566.525391),
};
local bossTeleportsCoordinates = {
	["Cosmic Menace (Boss)"] = Vector3.new(-11721.826172, 156.702225, -8551.984375),
	["Wicked Weaver (Boss)"] = Vector3.new(13107.546875, 84.274979, 11333.648438),
	["Cifer (Boss)"] = Vector3.new(-7899.03418, 734.354736, 6741.601562),
	["King Of Curses (Boss)"] = Vector3.new(-25.217384, 256.795135, 5882.467773),
	["Shinobi God (Boss)"] = Vector3.new(4258.674805, 31.874994, 7444.705078),
	["Galactic Tyrant (Boss)"] = Vector3.new(10927.65918, 352.19986, -5072.885254),
}
local areaTeleportCoordinates = {
	["Heavens Arena"] = Vector3.new(461.994751, 247.374268, 5954.683105),
	["Roll Leaderboard"] = Vector3.new(-7920.541015625, 186.38790893554688, -9144.70703125),
	["Card Leaderboard"] = Vector3.new(-7920.541015625, 186.38800048828125, -9170.8369140625),
	["Spawn"] = Vector3.new(-7921.300781, 177.836029,-9143.949219),
};

--[[
	Variables
--]]
local swordCooldown = stats:WaitForChild("SwordObbyCD").Value;
local potionCount = 0;
local autoPotionsActive = false;
local autoSwordActive = false;
local canGoBack = false;
local tickCount, uptimeInSeconds, hours, minutes, seconds
local uptimeText = "00 hours\n00 minutes\n00 seconds";

--[[
	Hub Functions
--]]
function Hub:Functions()
	--[[
		Character & Position Functions
	--]]
	self.setPrimaryPart = function()
		player = game.Players.LocalPlayer;
		character = player.Character;
		if character:FindFirstChild("HumanoidRootPart") then
			character.PrimaryPart = character.HumanoidRootPart;
		end;
	end;
	self.getOldPositionSword = function()
		if character and humanoidRootPart then
			local position = humanoidRootPart.Position;
			otherCoordinates["Old Position Sword"] = Vector3.new(position.X, (position.Y + 5), position.Z);
		end;
	end;
	self.characterTeleport = function(destination)
		if character and character.PrimaryPart then
			character:SetPrimaryPartCFrame(CFrame.new(destination));
			task.wait(0.1);
		else
			character = player.Character;
			self.setPrimaryPart();
		end;
	end;
	self.setPrimaryPart();
	player.CharacterAdded:Connect(function(newCharacter)
		player = game.Players.LocalPlayer;
		character = newCharacter;
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10);
		if humanoidRootPart then
			character.PrimaryPart = humanoidRootPart;
		end;
	end);

	--[[
		Auto Functions
	--]]
	self.grabPotions = function()
		local activePotions = workspace:WaitForChild("ActivePotions");
		for _, potion in ipairs(activePotions:GetChildren()) do
			local base = potion:FindFirstChild("Base");
			if base and base:FindFirstChild("TouchInterest") then
				firetouchinterest(base, humanoidRootPart, 0);
				task.wait(0.1);
				firetouchinterest(base, humanoidRootPart, 1);
				potionCount = potionCount + 1;
			end;
		end;
	end;
	self.grabSword = function()
		self.getOldPositionSword();
		local swordProximityPrompt = workspace.ObbySwordPrompt.SwordBlock.ProximityPrompt
		if swordProximityPrompt then
			self.characterTeleport(otherCoordinates["Sword"]);
			task.wait(0.25);
			fireproximityprompt(swordProximityPrompt);
			task.wait(0.5);
			canGoBack = true;
		end;
	end;
	self.autoInfinite = function()
		local davidNPC, davidHRP, davidProximityPrompt, inBattle
		while self.autoInfiniteToggle.Value do
			repeat 
				davidNPC = gamenpcs:WaitForChild("David");
				davidHRP = davidNPC:WaitForChild("HumanoidRootPart")
				davidProximityPrompt = davidHRP.ProximityPrompt
				task.wait(0.25)
			until davidProximityPrompt
			fireproximityprompt(davidProximityPrompt);
			task.wait(0.25)
		end;
	end;
	self.closeResultScreen = function()
		local davidNPC, davidHRP, inBattle
		local function getDavidHRP()
			davidNPC = gamenpcs:WaitForChild("David")
			return davidNPC:WaitForChild("HumanoidRootPart")
		end
		davidHRP = getDavidHRP()
		while self.closeResultScreenToggle.Value and self.autoInfiniteToggle.Value do
			inBattle = stats:WaitForChild("InBattle")
			repeat
				task.wait(0.25)
			until not inBattle.Value
			for _, instantroll in ipairs(playergui:GetChildren()) do
				if instantroll.Name == "InstantRoll" then
					instantroll:Destroy()
				end
			end
			task.wait(0.25)
			if not davidHRP then
				davidHRP = getDavidHRP()
			end
		end
	end	
	self.autoHideBattle = function()
		local hideBattle = stats:WaitForChild("HideBattle")
		while self.autoHideBattleToggle.Value do
			if hideBattle then
				hideBattle.Value = true
			end
			task.wait(1)
		end;
	end;
	
	--[[
		Auto Loop Functions
	--]]
	self.autoPotionsLoop = function()
		while self.autoPotionsToggle.Value do
			self.grabPotions();
			task.wait(0.25);
		end;
	end;
	self.autoSwordLoop = function()
		while self.autoSwordToggle.Value do
			local swordObbyCD = swordCooldown;
			if swordObbyCD == 0 then
				self.grabSword();
				if canGoBack then
					self.characterTeleport(otherCoordinates["Old Position Sword"]);
					canGoBack = false;
				end;
			end;
			task.wait(0.25);
		end;
	end;
	
	--[[
		Paragraph Functions
	--]]
	self.updateParagraph = function()
		while self.autoPotionsToggle.Value or self.autoSwordToggle.Value do
			swordCooldown = (stats:WaitForChild("SwordObbyCD")).Value;
			local totalPotions = potionCount;
			local timeLeft = swordCooldown;

			uptimeInSeconds = tick() - tickCount
			hours = math.floor(uptimeInSeconds / 3600)
			minutes = math.floor((uptimeInSeconds % 3600) / 60)
			seconds = uptimeInSeconds % 60
			uptimeText = string.format("%02d hours\n%02d minutes\n%02d seconds", hours, minutes, seconds)

			statsParagraph:SetDesc("Total Potions: " .. totalPotions 
				.. "\nSword Timer: " .. timeLeft 
				.. "\n" .. uptimeText);
			task.wait(0.2);
		end;
	end;
	self.updateParagraphStatus = function()
		if autoPotionsActive or autoSwordActive then
			if not updatingParagraph then
				updatingParagraph = true;
				task.spawn(self.updateParagraph);
			end;
		elseif updatingParagraph then
			updatingParagraph = false;
		end;
	end;
end;
function Hub:Gui()
	--[[
		Gui Init
	--]]
	guiWindow[randomKey] = Fluent:CreateWindow({
		Title = "UK1",
		SubTitle = "by Av",
		TabWidth = 100,
		Size = UDim2.fromOffset(500, 350),
		Acrylic = true,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	});
	local Tabs = {
		Farm = guiWindow[randomKey]:AddTab({
			Title = "Farm",
			Icon = "repeat"
		}),
		Battle = guiWindow[randomKey]:AddTab({
			Title = "Battle",
			Icon = "sword"
		}),
		Teleports = guiWindow[randomKey]:AddTab({
			Title = "Teleports",
			Icon = "navigation"
		}),
		Misc = guiWindow[randomKey]:AddTab({
			Title = "Misc",
			Icon = "circle-ellipsis"
		}),
	};
	Tabs.Settings = guiWindow[randomKey]:AddTab({
		Title = "Settings",
		Icon = "settings"
	})
	
	local Options = Fluent.Options;

	--[[
		Auto Tab
	--]]
	statsParagraph = Tabs.Farm:AddParagraph({
		Title = "Stats\n",
		Content = "Total Potions: " .. potionCount 
		.. "\n" .. "Sword Timer: " .. swordCooldown 
		.. "\n" .. uptimeText
	});
	self.autoPotionsToggle = Tabs.Farm:AddToggle("AutoPotions", {
		Title = "Auto Potions",
		Default = false
	});
	self.autoSwordToggle = Tabs.Farm:AddToggle("AutoSword", {
		Title = "Auto Sword",
		Default = false
	});
	self.autoPotionsToggle:OnChanged(function()
		autoPotionsActive = self.autoPotionsToggle.Value;
		if autoPotionsActive then
			task.spawn(self.autoPotionsLoop);
		end;
		self.updateParagraphStatus();
	end);
	self.autoSwordToggle:OnChanged(function()
		autoSwordActive = self.autoSwordToggle.Value;
		if autoSwordActive then
			task.spawn(self.autoSwordLoop);
		end;
		self.updateParagraphStatus();
	end);

	--[[
		Battle Tab
	--]]
	disclaimerParagraph = Tabs.Battle:AddParagraph({
		Title = "ReadMe\n",
		Content = "*Auto Infinite"
		.. "\n->\t" .. "Experimental"
		.. "\n->\t" .. "only opens dialogue for now"
		.. "\n->\t" .. "need to be near the NPC"
		.. "\n->\t" .. "use autoclicker or macro to start battle"
	});
	self.autoInfiniteToggle = Tabs.Battle:AddToggle("AutoInfinite", {
		Title = "Auto Infinite",
		Default = false
	});
	self.closeResultScreenToggle = Tabs.Battle:AddToggle("CloseResultScreen", {
		Title = "Auto Close Result",
		Description = "->\t" .. "Auto Infinite must be on as well",
		Default = false
	});
	self.autoHideBattleToggle = Tabs.Battle:AddToggle("AutoHideBattle", {
		Title = "Auto Hide Battle",
		Default = false
	});
	self.autoInfiniteToggle:OnChanged(function()
		if self.autoInfiniteToggle.Value then
			self.characterTeleport(npcTeleportsCoordinates["Heaven Infinite"]);
			task.wait(1);
			task.spawn(self.autoInfinite);
		end;
	end);
	self.closeResultScreenToggle:OnChanged(function()
		if self.closeResultScreenToggle.Value then
			task.spawn(self.closeResultScreen);
		end;
	end);
	self.autoHideBattleToggle:OnChanged(function()
		if self.autoHideBattleToggle.Value then
			task.spawn(self.autoHideBattle);
		end;
	end);

	--[[
		Teleports Tab
	--]]
	local npcTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Npcs",
		Values = npcTeleports,
		Multi = false,
		Default = nil
	});
	local mobTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Repeatable Bosses",
		Values = mobTeleports,
		Multi = false,
		Default = nil
	});
	local bossTeleportsDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Bosses",
		Values = bossTeleports,
		Multi = false,
		Default = nil
	});
	local areaTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Areas",
		Values = areaTeleports,
		Multi = false,
		Default = nil
	});
	npcTeleportDropdown:OnChanged(function(Value)
		local destination = npcTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			npcTeleportDropdown:SetValue(nil);
		end;
	end);
	mobTeleportDropdown:OnChanged(function(Value)
		local destination = mobsTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			mobTeleportDropdown:SetValue(nil);
		end;
	end);
	bossTeleportsDropdown:OnChanged(function(Value)
		local destination = bossTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			bossTeleportsDropdown:SetValue(nil);
		end;
	end);
	areaTeleportDropdown:OnChanged(function(Value)
		local destination = areaTeleportCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			areaTeleportDropdown:SetValue(nil);
		end;
	end);

	--[[
		Misc Tab
	--]]
	Tabs.Misc:AddButton({
		Title = "Rejoin game",
		Callback = function()
			rejoinGame();
		end
	});
	Tabs.Misc:AddButton({
		Title = "Join Random Public Server",
		Callback = function()
			self.joinPublicServer();
		end
	});

	--[[
		Settings Tab
	--]]
	InterfaceManager:SetLibrary(Fluent);
	InterfaceManager:SetFolder("UK1");
	InterfaceManager:BuildInterfaceSection(Tabs.Settings);
	guiWindow[randomKey]:SelectTab(1);
end;

--[[
	Main
--]]
Hub:Functions();
Hub:Gui();
antiAfk();
tickCount = tick();