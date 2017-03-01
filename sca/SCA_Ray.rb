#监听接收端口，射线坐标接收完毕后自动绘制射线
# encoding: utf-8

class Ray

	def ray_draw
		mod = Sketchup.active_model
		entities=mod.entities

		group_ray = entities.add_group
		group_line = group_ray.entities
		group_ray.name = "Ray"
		puts group_ray.name

		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\node.txt";	
		file = File.open(fileName)
		pathArray = Array.new
		file.each_line do |line|
		  lineArray = line.split()
		  path = Array.new
		  for i in 0..lineArray.size/3-1
		    point = [lineArray[i*3].to_f.mm,lineArray[i*3+1].to_f.mm,lineArray[i*3+2].to_f.mm]
		    path.push(point)
		    p point
		  end
		  pathArray.push(path)
		end

		file.close
		
		pathArray.each do |path|
			for i in 0..path.length-2
				group_line.add_line path[i],path[i+1]
			end

		end
			
		
	end

	def ray_delete
		model = Sketchup.active_model
		entities = model.active_entities
		entities.each{|ent|
			if ent.name != nil
				if ent.name=="Ray" then
					entities.erase_entities ent
				end
			end
		}

	end
end