class Single_draw

	def draw_signal
		ents = Sketchup.active_model.entities
		signal = ents.add_group
		signalpoint = signal.entities
		signal.name = "signalpoint"

		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\网元参数.txt";	
		file = File.open(fileName)
		pointArray = Array.new #每行
		point = Array.new #点坐标+颜色
		tpoint = Array.new #所有point数组存到这个数组中
		file.each_line do |line|
			pointArray = line.split()
		    point = [pointArray[0].to_s,pointArray[1].to_f.mm,pointArray[2].to_f.mm,pointArray[3].to_f.mm]
			tpoint.push(point)
		end
		file.close
		
		#设定颜色
		yellow_mat =Sketchup.active_model.materials.add "yellow"
		yellow_mat.color=[255,255,0]
		
		#遍历tpoint，绘制圆
		tpoint.each do |point|
			#设置数字
			numpos = [point[1]-25.mm, point[2]-25.mm, point[3]+ 250.mm]
			num = point[0].to_i.to_s
			text = signalpoint.add_text num, numpos

			#设置圆心
			center = [point[1],point[2],point[3]]
			#设置半径
			radius = 150.mm
			#绘制圆
			circle = signalpoint.add_circle center, [0, 0, 1], radius
			circle_face = signalpoint.add_face(circle)
			#设置颜色
			circle_face.material = "yellow"
			circle_face.back_material = "yellow"
			
			path = signalpoint.add_circle center, [0, 1, 0], radius + 1
			circle_face.followme path
			signalpoint.erase_entities path
		end
	end
	def delete_single
		model = Sketchup.active_model
		entities = model.active_entities
		entities.each{|ent|
			if ent.name != nil
				if ent.name=="signalpoint" then
					entities.erase_entities ent
				end
			end
		}

	end
end