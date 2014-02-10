schedule = {}

schedule.events = {}

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

return schedule