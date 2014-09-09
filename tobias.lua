--[[
TOBIAS :: version 0.1
Game Sound library

Author: Henry Lu
Date: August 24, 2014
For: LOVE 0.9
License: MIT
]]--

MoanClass = Class -- replace this with your variable for hump/class

Moan = MoanClass{}


Moan.counter = 1
Moan.list = {} -- stores all the music

function Moan:init(loop, stream)
    self.loop = loop
    self.stream = stream
	self.tagID = Moan.counter
	Moan.counter = Moan.counter + 1
	print(self.tagID)
	print(self.stream)
end

-- example Moan.list[1] = {"music/main.mp3", "loop", "stream", {tag1}, ""}
--[[
table.insert(A.hi, {})
A.hi[1] = {key = "stuff"}
print(A.hi[1].key)
]]--

function Moan.exists(f,t)
	for k,v in ipairs(Moan.list) do
		if v.file == f and v.tag == t and not v.clone then return k end
	end
	return nil
end

function Moan.vol()

end

function Moan.pause()

end

function Moan.resume()

end

function Moan:load(f)
	if Moan.exists(f,self.tagID) then return end
	local stream = (self.stream and "stream") or "static"
	local source = love.audio.newSource(f, stream)
	if self.loop then source:setLooping(true) end
	table.insert(Moan.list, {file = f, tag = self.tagID, sound = source, pause = 0, clone = false})
end

function Moan:play(f)
	local k = Moan.exists(f,self.tagID)
	if k then
		local sound = Moan.list[k].sound
		if sound:isStopped() then sound:play() print("works")
		elseif sound:isPaused() then Moan.list[k].pause = 0 sound:play()
		else -- I would use Source:clone(), but I wanted compatibility for 0.9 to be safe
			local stream = sound:isStatic() and "static" or "stream"
			local source = love.audio.newSource(f, stream)
			if sound:isLooping() then source:setLooping(true) end
			source:play()
			table.insert(Moan.list, {file = f, tag = self.tagID, sound = source, pause = 0, clone = true})
			print("here")
		end
	else
		local stream = (self.stream and "stream") or "static"
		local source = love.audio.newSource(f, stream)
		if self.loop then source:setLooping(true) end
		source:play()
		table.insert(Moan.list, {file = f, tag = self.tagID, sound = source, pause = 0, clone = false})
		print("me")
	end
end

function Moan:change(of,nf)
	local file = Moan.list[Moan.exists(of,self.tagID)]

	if of == nf then file.sound:stop() file.sound:play() return end

	local a = Moan.exists(nf,self.tagID)
	if a then
		file.sound:stop()
		Moan.list[a].pause = file.pause
		if Moan.list[a].pause <=0 then Moan.list[a].sound:play() end
		return
	end

	local playing = file.sound:isPlaying()
	local stream = (self.stream and "stream") or "static"
	local source = love.audio.newSource(nf, stream)
	if self.loop then source:setLooping(true) end

	file.sound:stop()
	if playing then source:play() end
	print("check stream")

	if stream == "stream" then
		file.file = nf
		file.sound = source
	else
		print("it's static")
		table.insert(Moan.list, {file = nf, tag = self.tagID, sound = source, pause = 0, clone = false})
	end
end

function Moan:vol(number)
end

function Moan:pause()
	for _,v in ipairs(Moan.list) do
		if v.tag == self.tagID then
			v.pause = v.pause + 1
			v.sound:pause()
			print(v.file.."-pause: "..v.pause)
		end
	end
end

function Moan:resume()
	for _,v in ipairs(Moan.list) do
		if v.tag == self.tagID then
			v.pause = v.pause <= 0 and v.pause or v.pause - 1
			if v.pause <= 0 then v.sound:resume() print("resuming...") end
			print(v.file.."-resume: "..v.pause)
		end
	end
end

function Moan:stop()
	k = Moan.exists(f,self.tagID)
	Moan.list[k]:stop()
end
function Moan:kill(f)
	k = Moan.exists(f,self.tagID)
	Moan.list[k]:stop()
	table.remove(Moan.list,k)
end

Hear = MoanClass{__includes = Moan}

function Hear:init(loop, stream)
	if stream == nil then stream = false end
	if loop == nil then loop = false end
	Moan.init(self, loop, stream)
end

Play = MoanClass{__includes = Moan}
function Play:init(loop, stream)
	if stream == nil then stream = true end
	if loop == nil then loop = true end
	Moan.init(self, loop, stream)
end