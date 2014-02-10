schedule = require("schedule")
require("player")
require("enemy")

function love.load()
	width = love.graphics.getWidth()
	
	score = 0
	
	player.load()
	enemy.load()
	
	step = 3
end

function love.update()
	schedule.update()
	
	player.update()
	enemy.update()
	
	enemy.x = enemy.x + (step * enemy.direction)
	
	i = 1
	
	while i <= #player.shots do
		if math.abs(player.shots[i].startX - player.shots[i].x) < math.abs(player.shots[i].destX) then
			
			player.shots[i].x = player.shots[i].x + (3 * player.shots[i].direction)
			
			player.shots[i].y = player.shots[i].startY + (
					(player.shots[i].maxY - player.shots[i].startY) * 
					math.sin((
						(player.shots[i].x - player.shots[i].startX) / 
						player.shots[i].destX) * math.pi
					)
				)
			
			-- player.shots[i].r = player.shots[i].startR - ((player.shots[i].startR - player.shots[i].destR) * ((player.shots[i].x - player.shots[i].startX) / player.shots[i].destX))
			player.shots[i].scale = 1 - ((player.shots[i].x - player.shots[i].startX) / player.shots[i].destX)
			
		else
			print(player.shots[i].x, enemy.x)
			if enemy.x > player.shots[i].x - (enemy.hitbox / 2) and enemy.x < player.shots[i].x + (enemy.hitbox / 2) then
				print("hit!")
				score = score + 1
				enemy.scale = enemy.scale * 0.85
				enemy.hitbox = enemy.hitbox * 0.9
			end
			
			table.remove(player.shots, i)
		end
		
		i = i + 1
	end
end

function love.keypressed(key)
	player.keypressed(key)
	enemy.keypressed(key)
end

function love.keyreleased(key)
	player.keyreleased(key)
end

function shoot()
	player.shots[#player.shots + 1] = {
		-- startR = 50,
		-- r = 0,
		-- destR = 10,
		
		startX = player.x,
		x = player.x,
		destX = (300 * player.direction),
		
		direction = player.direction,
		
		startY = player.y,
		maxY = 100
	}
end

function love.draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.print("júz di eró kíz tu múv öránd end pressz spész tu sút!!!", 100, 100)
	love.graphics.print("szkór: " .. score, 100, 120)
	love.graphics.setColor(255, 255, 255)
	
	enemy.draw()
	
	love.graphics.draw(player.image, player.x - ((player.image:getWidth() / 2) * player.direction), player.y, math.rad(0), player.direction, 1)
	-- love.graphics.circle("fill", player.x, player.y, 5)
	
	-- love.graphics.setColor(0, 255, 0)
	-- for i = 1, #player.shots do
	-- 	love.graphics.circle("fill", player.shots[i].x, player.shots[i].y, player.shots[i].r)
	-- end
	
	for i = 1, #player.shots do
		love.graphics.draw(ballImage, player.shots[i].x, player.shots[i].y + (ballImage:getHeight() / 2), math.rad(0), player.shots[i].scale * player.shots[i].direction, player.shots[i].scale)
	end
end