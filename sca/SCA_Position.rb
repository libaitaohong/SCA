class Position

	def draw_position

		ents = Sketchup.active_model.entities
		group_positon = ents.add_group
		point = group_positon.entities
		group_positon.name = "position"

		#读取设置的定位点
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\终端参数.txt";	
		file = File.open(fileName)
		phoneArray = Array.new
		phoneparam = Array.new
		phonepos = Array.new
		file.each_line do |line|
			phoneArray = line.split()
		    phoneparam = [phoneArray[0].to_f,phoneArray[1].to_f.mm,phoneArray[2].to_f.mm,phoneArray[3].to_f.mm]
		    phonepos.push(phoneparam)
		end
		file.close

		#读取计算出的定位点
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\定位点坐标.txt";	
		file = File.open(fileName)
		pointArray = Array.new
		pointt = Array.new
		pos = Array.new
		file.each_line do |line|
			pointArray = line.split()
		    pointt = [pointArray[0].to_f,pointArray[1].to_f.mm,pointArray[2].to_f.mm,pointArray[3].to_f.mm]
		    pos.push(pointt)
		end
		file.close

		green_mat =Sketchup.active_model.materials.add "green"
		pink_mat =Sketchup.active_model.materials.add "pink"
		green_mat.color=[153,255,153]
		pink_mat.color=[255,0,127]

		#绘制设置的定位点
		phonepos.each do |phoneparam|
			#添加数字
			numpos = [phoneparam[1]-25.mm, phoneparam[2]-25.mm, phoneparam[3]+ 250.mm]
			num = phoneparam[0].to_i.to_s
			text = point.add_text num, numpos
			#绘制圆球
			center = [phoneparam[1], phoneparam[2], phoneparam[3]]
			radius = 150.mm
			circle = point.add_circle center, [0, 0, 1], radius
			circle_face = point.add_face circle 

			circle_face.material = "green"
			circle_face.back_material = "green"

			path = point.add_circle center, [0, 1, 0], radius + 1
			circle_face.followme path
			point.erase_entities path
			
		end	

		#绘制计算出的定位点
		pos.each do |pointt|
			#添加数字
			numpos = [pointt[1]-25.mm, pointt[2]-25.mm, pointt[3]+ 250.mm]
			num = pointt[0].to_i.to_s
			text = point.add_text num, numpos
			#绘制圆球
			center = [pointt[1], pointt[2], pointt[3]]
			radius = 150.mm
			circle = point.add_circle center, [0, 0, 1], radius
			circle_face = point.add_face circle

			circle_face.material = "pink"
			circle_face.back_material = "pink"

			path = point.add_circle center, [0, 1, 0], radius + 1
			circle_face.followme path
			point.erase_entities path
		end	
	end

	def delete_position
		model = Sketchup.active_model
		entities = model.active_entities
		entities.each{|ent|
			if ent.name != nil
				if ent.name=="position" then
					entities.erase_entities ent
				end
			end
		}

	end


end
