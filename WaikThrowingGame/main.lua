function love.load()
	schedule = {
		events = {}
	}
	
	function schedule.newEvent(time, callback)
		schedule.events[#schedule.events + 1] = {
			dueTime = love.timer.getTime() + time,
			callback = callback
		}
	end
	
	function schedule.update()
		i = 1
		
		while i <= #schedule.events do
			if love.timer.getTime() > schedule.events[i].dueTime then
				-- print("executing", i)
				schedule.events[i].callback()
				table.remove(schedule.events, i)
			end
			
			i = i + 1
		end
	end
	
	width = love.graphics.getWidth()
	
	score = 0
	
	waik = {}
	
	enemy = {}
	
	waik.baseImage = love.graphics.newImage("res/img/waik_new.png")
	waik.throwingImage = love.graphics.newImage("res/img/waik_new_throwing.png")
	
	enemy.baseImage = love.graphics.newImage("res/img/enemy_new.png")
	enemy.throwingImage = love.graphics.newImage("res/img/enemy_new_throwing.png")
	
	ballImage = love.graphics.newImage("res/img/ball_128.png")
	
	waik.image = waik.baseImage
	
	enemy.image = enemy.baseImage
	
	waik.walkPlane = 300
	waik.isThrowing = false
	
	enemy.walkPlane = 250
	enemy.isThrowing = false
	enemy.isTurning = false
	
	enemy.scale = 0.85
	
	waik.x = 100
	waik.shots = {}
	
	enemy.x = 100
	enemy.shots = {}
	
	enemy.nextTurn = love.timer.getTime() + math.random() * 1.5 + 0.5
	
	step = 3
	
	waik.direction = 1
	
	enemy.direction = 1
	
	function enemy.turn()
		if not enemy.isTurning then
			enemy.isTurning = true
			enemy.turnStep = (enemy.direction - (-enemy.direction)) / 10
			enemy.destinationDirection = -enemy.direction
		end
		
		enemy.direction = enemy.direction - enemy.turnStep
		
		if enemy.direction ~= enemy.destinationDirection then
			schedule.newEvent(0.025, enemy.turn)
			-- print("set schedule", #schedule.events)
		else
			enemy.isTurning = false
		end
	end
	
	enemy.hitbox = 50
end

function love.update()
	schedule.update()
	
	if love.keyboard.isDown("left") then
		waik.x = waik.x - step
		waik.direction = -1
	end
	
	if love.keyboard.isDown("right") then
		waik.x = waik.x + step
		waik.direction = 1
	end
	
	if love.timer.getTime() > enemy.nextTurn or (enemy.x < 0 and enemy.direction == -1) or (enemy.x > width and enemy.direction == 1) then
		enemy.turn()
		turnDelay = math.random() * 1.5 + 0.5
		enemy.nextTurn = love.timer.getTime() + turnDelay
		print("next turn in:", turnDelay)
	end
	
	enemy.x = enemy.x + (step * enemy.direction)
	
	i = 1
	
	while i <= #waik.shots do
		if math.abs(waik.shots[i].startX - waik.shots[i].x) < math.abs(waik.shots[i].destX) then
			
			waik.shots[i].x = waik.shots[i].x + (3 * waik.shots[i].direction)
			
			waik.shots[i].y = waik.shots[i].startY + (
					(waik.shots[i].maxY - waik.shots[i].startY) * 
					math.sin((
						(waik.shots[i].x - waik.shots[i].startX) / 
						waik.shots[i].destX) * math.pi
					)
				)
			
			-- waik.shots[i].r = waik.shots[i].startR - ((waik.shots[i].startR - waik.shots[i].destR) * ((waik.shots[i].x - waik.shots[i].startX) / waik.shots[i].destX))
			waik.shots[i].scale = 1 - ((waik.shots[i].x - waik.shots[i].startX) / waik.shots[i].destX)
			
		else
			print(waik.shots[i].x, enemy.x)
			if enemy.x > waik.shots[i].x - (enemy.hitbox / 2) and enemy.x < waik.shots[i].x + (enemy.hitbox / 2) then
				print("hit!")
				score = score + 1
				enemy.scale = enemy.scale * 0.85
				enemy.hitbox = enemy.hitbox * 0.9
			end
			
			table.remove(waik.shots, i)
		end
		
		i = i + 1
	end
end

function love.keypressed(key)
	if key == " " then
		waik.image = waik.throwingImage
		waik.isThrowing = true
		shoot()
	end
	
	if key == "q" then
		enemy.turn()
	end
end

function love.keyreleased(key)
	if key == " " then
		waik.isThrowing = false
		waik.image = waik.baseImage
	end
end

function shoot()
	waik.shots[#waik.shots + 1] = {
		-- startR = 50,
		-- r = 0,
		-- destR = 10,
		
		startX = waik.x,
		x = waik.x,
		destX = (300 * waik.direction),
		
		direction = waik.direction,
		
		startY = waik.walkPlane,
		maxY = 100
	}
end

function love.draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.print("júz di eró kíz tu múv öránd end pressz spész tu sút!!!", 100, 100)
	love.graphics.print("szkór: " .. score, 100, 120)
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.draw(enemy.image, enemy.x - (((enemy.image:getWidth() * enemy.scale) / 2) * enemy.direction), enemy.walkPlane, math.rad(0), enemy.scale * enemy.direction, enemy.scale)
	-- love.graphics.circle("fill", enemy.x, enemy.walkPlane, 5)
	
	love.graphics.setColor(255, 0, 0)
	love.graphics.print("ekcsuöl hitbox", 500, 100)
	love.graphics.rectangle("line", enemy.x - enemy.hitbox / 2, waik.walkPlane + (ballImage:getHeight() / 2) - 5, enemy.hitbox, 10)
	love.graphics.setColor(255, 255, 255)
	
	if not waik.isThrowing then
		love.graphics.draw(ballImage, waik.x, waik.walkPlane + ((waik.image:getHeight() - ballImage:getHeight()) / 2), math.rad(0), waik.direction, 1)
	end
	
	love.graphics.draw(waik.image, waik.x - ((waik.image:getWidth() / 2) * waik.direction), waik.walkPlane, math.rad(0), waik.direction, 1)
	-- love.graphics.circle("fill", waik.x, waik.walkPlane, 5)
	
	-- love.graphics.setColor(0, 255, 0)
	-- for i = 1, #waik.shots do
	-- 	love.graphics.circle("fill", waik.shots[i].x, waik.shots[i].y, waik.shots[i].r)
	-- end
	
	for i = 1, #waik.shots do
		love.graphics.draw(ballImage, waik.shots[i].x, waik.shots[i].y + (ballImage:getHeight() / 2), math.rad(0), waik.shots[i].scale * waik.shots[i].direction, waik.shots[i].scale)
	end
end