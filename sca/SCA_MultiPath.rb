class SCA_MultiPath
	def multiPath
		ents = Sketchup.active_model.entities
		group_multiPath = ents.add_group
		multiPath = group_multiPath.entities
		group_multiPath.name = "multiPath"

		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\multiPath.txt";	
		file = File.open(fileName)
		pointArray = Array.new #每行
		point = Array.new #点坐标+颜色
		tpoint = Array.new #所有point数组存到这个数组中
		file.each_line do |line|
			pointArray = line.split()
		    point = [pointArray[0].to_f.mm,pointArray[1].to_f.mm,pointArray[2].to_f.mm,pointArray[3].to_f]
			tpoint.push(point)
		end
		file.close
		
		#设定颜色
		red_mat =Sketchup.active_model.materials.add "red"
		orange_mat =Sketchup.active_model.materials.add "orange"
		yellow_mat =Sketchup.active_model.materials.add "yellow"
		green_mat =Sketchup.active_model.materials.add "green"
		blue_mat =Sketchup.active_model.materials.add "blue"
		purple_mat =Sketchup.active_model.materials.add "purple"
		white_mat =Sketchup.active_model.materials.add "white"
		red_mat.color=[255,0,0]
		orange_mat.color=[255,63,0]
		yellow_mat.color=[255,255,0]
		green_mat.color=[127,255,0]
		blue_mat.color=[0,255,255]
		purple_mat.color=[127,0,255]
		white_mat.color=[255,255,255]
		#遍历tpoint，绘制圆,根据point[3]的数字判断圆是什么颜色
		tpoint.each do |point|

			#设置圆心
			center = [point[0],point[1],point[2]]
			#center = [0,0,0]
			#设置半径
			radius = 50.mm
			#绘制圆
			circle = multiPath.add_circle center, [0, 0, 1], radius
			circle_face = multiPath.add_face(circle)
			#添加数字
			pos = [center[0],center[1],center[2]+ 150.mm]
			num = point[3].to_i.to_s
			text = multiPath.add_text num, pos
			#设置颜色
			if point[3] == 0
				circle_face.material = "white"
				circle_face.back_material = "white"
			elsif point[3] > 0 && point[3] <=3
				circle_face.material = "purple"
				circle_face.back_material = "purple"
			elsif point[3] > 3 && point[3] <=6
				circle_face.material = "blue"
				circle_face.back_material = "blue"
			elsif point[3] > 6 && point[3] <=9
				circle_face.material = "green"
				circle_face.back_material = "green"
			elsif point[3] > 9 && point[3] <=12
				circle_face.material = "yellow"
				circle_face.back_material = "yellow"
			elsif point[3] > 12 && point[3] <=15
				circle_face.material = "orange"
				circle_face.back_material = "orange"
			elsif point[3] > 15
				circle_face.material = "red"
				circle_face.back_material = "red"
			end
			path = multiPath.add_circle center, [0, 1, 0], radius + 1
			circle_face.followme path
			multiPath.erase_entities path
		end
	end

	def delete_multiPath
		model = Sketchup.active_model
		entities = model.active_entities
		entities.each{|ent|
			if ent.name != nil
				if ent.name=="multiPath" then
					entities.erase_entities ent
				end
			end
		}
	end

end