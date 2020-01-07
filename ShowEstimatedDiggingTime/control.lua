script.on_event(defines.events.on_tick, function()
	if global.Drills ~= nil then
		if #global.Drills > 0 then
			for k, entity in pairs(global.Drills) do
			  if entity.shouldupdate == game.tick then 
					if (entity.entity ~= nil and entity.entity.valid) then
					

						posx = entity.entity.position.x 
						posy = entity.entity.position.y
						radius = entity.entity.prototype.mining_drill_radius
						count = 0
						for key,value in ipairs(entity.entity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
							count = count + value.amount
						end
						
						if entity.prevcount ~= count then
							howmuch =  entity.prevcount - count
					
							diggingtime = game.tick - entity.prevtick
					
							x = math.floor(count / howmuch)

							estimatedticktime =  math.floor((x * diggingtime) / 60)

							hour = math.floor(estimatedticktime / 3600)

							estimatedticktime = estimatedticktime - hour * 3600

							min = math.floor(estimatedticktime / 60)

							if min < 10 then
								min = '0' .. min
							end


							estimatedticktime = estimatedticktime - min * 60

							sec = math.floor(estimatedticktime)

							if sec < 10 then
								sec = '0' .. sec
							end



							time = hour .. ':' .. min .. ':' .. sec
					
					
							rendering.set_text(entity.text, time)
						end

						entity.prevcount = count
						entity.prevtick = game.tick
						entity.shouldupdate = game.tick + 297
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

	if (global.Drills == nil and event.created_entity.type == 'mining-drill') then
		global.Drills = {}
		posx = event.created_entity.position.x 
		posy = event.created_entity.position.y
		radius = event.created_entity.prototype.mining_drill_radius
		
		count = 0
		for key,value in ipairs(event.created_entity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
			count = count + value.amount
		end

		global.Drills[1] = {entity = event.created_entity, text = rendering.draw_text{text = 'w8 4 update', surface = event.created_entity.surface, target = {event.created_entity.position.x - 0.75, event.created_entity.position.y}, color = {255, 255, 255}}, prevcount = count, prevtick = game.tick, shouldupdate = game.tick + 297}
	else
		if(event.created_entity ~= nil and event.created_entity.type == 'mining-drill') then
			posx = event.created_entity.position.x 
			posy = event.created_entity.position.y
			radius = event.created_entity.prototype.mining_drill_radius
		
			count = 0
			for key,value in ipairs(event.created_entity.surface.find_entities_filtered{area = {{posx - radius, posy - radius}, {posx + radius, posy + radius}}, type = "resource"}) do 
				count = count + value.amount
			end


			global.Drills[#global.Drills + 1] = {entity = event.created_entity, text = rendering.draw_text{text = 'w8 4 update', surface = event.created_entity.surface, target = {event.created_entity.position.x - 0.75, event.created_entity.position.y}, color = {255, 255, 255}}, prevcount = count, prevtick = game.tick, shouldupdate = game.tick + 297}
		end
	end
	
end)

