class SCA_FirstPath
	def firstPath
		ents = Sketchup.active_model.entities
		group_firstPath = ents.add_group
		firstPath = group_firstPath.entities
		group_firstPath.name = "firstPath"

		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\firstPath.txt";	
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
		
		#设定颜色，红色与蓝色
		red_mat =Sketchup.active_model.materials.add "red"
		blue_mat =Sketchup.active_model.materials.add "blue"
		white_mat =Sketchup.active_model.materials.add "white"
		red_mat.color=[255,0,0]
		blue_mat.color=[0,255,255]
		white_mat.color=[255,255,255]
		#遍历tpoint，绘制圆,根据point[3]的数字判断圆是什么颜色
		tpoint.each do |point|

			#设置圆心
			center = [point[0],point[1],point[2]]
			#center = [0,0,0]
			#设置半径
			radius = 50.mm
			#绘制圆
			circle = firstPath.add_circle center, [0, 0, 1], radius
			circle_face = firstPath.add_face(circle)
			#设置颜色
			if point[3] > 0
				circle_face.material = "red"
				circle_face.back_material = "red"
			elsif point[3] == 0
				circle_face.material = "white"
				circle_face.back_material = "white"
			end
			path = firstPath.add_circle center, [0, 1, 0], radius + 1
			circle_face.followme path
			firstPath.erase_entities path
		end
	end

	def delete_firstPath
		model = Sketchup.active_model
		entities = model.active_entities
		entities.each{|ent|
			if ent.name != nil
				if ent.name=="firstPath" then
					entities.erase_entities ent
				end
			end
		}
	end
end