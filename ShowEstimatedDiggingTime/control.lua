script.on_init(function()

	global.Drills = {}

	for _,surface in pairs(game.surfaces) do
		for _,sentity in ipairs(surface.find_entities_filtered{type = "mining-drill"}) do 
			posx = sentity.position.x 
			posy = sentity.position.y
			radius = sentity.prototype.mining_drill_radius
			
			count = 0

			for key,value in ipairs(sentity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
				count = count + value.amount
			end
			table.insert(global.Drills, {entity = sentity, text = rendering.draw_text{text = '?', surface = sentity.surface, target = {sentity.position.x - 0.75, sentity.position.y}, color = {255, 255, 255}}, prevcount = count, prevtick = game.tick, shouldupdate = game.tick + math.random(55, 100)})
		end
	end
end)


script.on_event(defines.events.on_tick, function()
	if global.Drills ~= nil then
		if #global.Drills > 0 then
			for k, entity in pairs(global.Drills) do
			  if entity.shouldupdate < game.tick then 
					if (entity.entity ~= nil and entity.entity.valid) then
                        if (entity.entity.status == 1) then
                        
					

						posx = entity.entity.position.x 
						posy = entity.entity.position.y
						radius = entity.entity.prototype.mining_drill_radius
						count = 0
						for key,value in ipairs(entity.entity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
							count = count + value.amount
						end
						
						if entity.prevcount ~= count then
					
							

							estimatedticktime =  count / ( entity.entity.prototype.mining_speed * (entity.entity.speed_bonus + 1))

							hour = math.floor(estimatedticktime / 3600)

							estimatedticktime = estimatedticktime - hour * 3600

							min = math.floor(estimatedticktime / 60)
                            mins = tostring(min)
							if min < 10 then
								mins = '0' .. mins
							end


							estimatedticktime = estimatedticktime - min * 60

							sec = math.floor(estimatedticktime)
                            secs = tostring(sec)
							if sec < 10 then
								secs = '0' .. secs
							end



							time = hour .. ':' .. mins .. ':' .. secs
					
                            rendering.set_color(entity.text, {255, 255, 255})
							rendering.set_text(entity.text, time)
						end

						entity.prevcount = count
						entity.prevtick = game.tick
						entity.shouldupdate = game.tick + math.random(55, 100)
                    else
                        rendering.set_color(entity.text, {255, 0, 0})
                        rendering.set_text(entity.text, 'STOP')
                    end
					else
						rendering.destroy(global.Drills[k].text)
						table.remove(global.Drills, k)

					end
			  end
			end
		end
	end
end)


script.on_event(defines.events.on_built_entity, function(event)

	if (event.created_entity.type == 'mining-drill') then
		posx = event.created_entity.position.x 
		posy = event.created_entity.position.y
		radius = event.created_entity.prototype.mining_drill_radius
		
		count = 0
		for key,value in ipairs(event.created_entity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
			count = count + value.amount
		end

		table.insert(global.Drills, {entity = event.created_entity, text = rendering.draw_text{text = '?', surface = event.created_entity.surface, target = {event.created_entity.position.x - 0.75, event.created_entity.position.y}, color = {255, 255, 255}}, prevcount = count, prevtick = game.tick, shouldupdate = game.tick + math.random(55, 100)})
	end
end)


script.on_event(defines.events.on_player_mined_entity, function(event)
    if (event.entity.type == 'mining-drill') then
        if global.Drills ~= nil then
            if #global.Drills > 0 then
                for k, entity in pairs(global.Drills) do
                    if (entity.entity.position.x == event.entity.position.x) and (entity.entity.position.y == event.entity.position.y) then
                        rendering.destroy(entity.text)
                        table.remove(global.Drills, k)
                        break
                    end
                    
                end
            end
        end
    end
end)
