player = {}

function player.load()
	player.baseImage = love.graphics.newImage("res/img/waik_new.png")
	player.throwingImage = love.graphics.newImage("res/img/waik_new_throwing.png")
	
	player.image = player.baseImage
	
	player.y = 300
	
	player.x = 100
	
	player.isThrowing = false
	
	player.shots = {}
	
	player.direction = 1
	
end

function player.update()
	-- player movement
		if love.keyboard.isDown("left") then
			player.x = player.x - step
			player.direction = -1
		end
		
		if love.keyboard.isDown("right") then
			player.x = player.x + step
			player.direction = 1
		end
end

function player.keypressed(key)
	if key == " " then
		player.image = player.throwingImage
		player.isThrowing = true
		shoot()
	end
end

function player.keyreleased(key)
	if key == " " then
		player.isThrowing = false
		player.image = player.baseImage
	end
end

function player.draw()
	if not player.isThrowing then
		love.graphics.draw(ballImage, player.x, player.y + ((player.image:getHeight() - ballImage:getHeight()) / 2), math.rad(0), player.direction, 1)
	end
	print(player.isThrowing)
	love.graphics.draw(player.image, player.x - ((player.image:getWidth() / 2) * player.direction), player.y, math.rad(0), player.direction, 1)
	-- love.graphics.circle("fill", player.x, player.y, 5)
end