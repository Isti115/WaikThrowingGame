enemy = {}

function enemy.load()
	enemy.baseImage = love.graphics.newImage("res/img/enemy_new.png")
	enemy.throwingImage = love.graphics.newImage("res/img/enemy_new_throwing.png")
	
	ballImage = love.graphics.newImage("res/img/ball_128.png")
	
	enemy.image = enemy.baseImage
	
	enemy.y = 250
	enemy.x = 100
	
	enemy.isThrowing = false
	enemy.isTurning = false
	
	enemy.direction = 1
	
	enemy.scale = 0.85
	
	enemy.shots = {}
	
	enemy.nextTurn = love.timer.getTime() + math.random() * 1.5 + 0.5
	
	enemy.hitbox = 50
	
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
end

function enemy.update()
	-- enemy turn timing
		if love.timer.getTime() > enemy.nextTurn or (enemy.x < 0 and enemy.direction == -1) or (enemy.x > width and enemy.direction == 1) then
			enemy.turn()
			turnDelay = math.random() * 1.5 + 0.5
			enemy.nextTurn = love.timer.getTime() + turnDelay
			
			print("next turn in:", turnDelay)
		end
end

function enemy.keypressed(key)
	if key == "q" then
		enemy.turn()
	end
end

function enemy.draw()
	love.graphics.draw(enemy.image, enemy.x - (((enemy.image:getWidth() * enemy.scale) / 2) * enemy.direction), enemy.y, math.rad(0), enemy.scale * enemy.direction, enemy.scale)
	-- love.graphics.circle("fill", enemy.x, enemy.y, 5)
	
	love.graphics.setColor(255, 0, 0)
	love.graphics.print("ekcsuöl hitboksz", 500, 100)
	love.graphics.rectangle("line", enemy.x - enemy.hitbox / 2, player.y + (ballImage:getHeight() / 2) - 5, enemy.hitbox, 10)
	love.graphics.setColor(255, 255, 255)
end