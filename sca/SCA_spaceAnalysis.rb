#空间信息提取
class SCA_spaceAnalysis
	def pointsanalysis
		model=Sketchup.active_model
		ent=model.entities
		file = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\空间提取结果.txt", "w+")
		@sss=""
		@mmm =""
		ent.each{|ent|

			point = Geom::Point3d.new 0,0,0
			t = Geom::Transformation.new point

			if ent.typename=="Group" then
				t = ent.transformation
				group(ent,t)
			elsif ent.typename=="Face" then
				face(ent,t)
			end
		}
		s = @sss
		#send_to('127.0.0.1', '2000', s)
		file.syswrite(s)
		file.close
		SKETCHUP_CONSOLE.show	
		p "end"
	end

	def group(group,t)	
		#记录群组材质mmm
		if group.material == nil		
			@mmm = nil
		else
			@mmm = group.material.display_name		
		end
		group_ent = group.entities

		#读取group的面个数
		facenum = 0
		group_ent.each{|face_ent| 
			if face_ent.typename=="Face"
				facenum += 1
			end
		}
		@sss = @sss + facenum.to_s
		@sss = @sss + "\n"
		#先把group的面读出来
        group_ent.each{|face_ent| 
			if face_ent.typename=="Face"
				face(face_ent,t)
			end
		}

        group_ent.each{|group_ent|  
			if group_ent.typename=="Group"
				#求group_ent的偏移量
				t1 = group_ent.transformation
				#得到偏移量t的值，并加到t1上，形成新的tranformation对象
				transf = Array.new(3,0)
				for j in 0..2
					temp = t.origin[j]
					transf[j] = temp
				end
				tt = t1.origin + [transf[0],transf[1],transf[2]]
				newt = Geom::Transformation.new tt

				group(group_ent,newt)
			end
		}	
		
	end 

	def face(face,t)
		#1 获取面方程
		point1=face.vertices[0].position.transform(t) 
		point2=face.vertices[1].position.transform(t)
		point3=face.vertices[2].position.transform(t)
		plane = Geom.fit_plane_to_points(point1, point2, point3) 
		for j in 0..2
			tmp = plane[j]
			@sss = @sss + tmp.to_s + " "
		end
		tmp = plane[3].to_mm
		@sss = @sss + tmp.to_s + " "


		#2 面坐标
		transf = Array.new(3)
		for j in 0..2
			temp = t.origin[j].to_mm
			transf[j] = temp
		end

		#3 面点个数
		l = face.vertices.length
		@sss = @sss + l.to_s + " "

		for j in 0..l - 1
			tmp = face.vertices[j].position.to_a
			s1 = tmp[0].to_mm + transf[0]
			s2 = tmp[1].to_mm + transf[1]
			s3 = tmp[2].to_mm + transf[2]
			@sss = @sss + s1.to_s + " " + s2.to_s + " " + s3.to_s + " "
		end

		#4 面材质
		if face.material == nil		
			judge(@mmm)
		else
			judge(face.material.display_name) #输出面材质		
		end

		#5 面积
		area = face.area*645.16
		@sss = @sss + area.to_s + " "
		@sss = @sss + "\n"
	end

	def judge(name)
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\材质.txt";	
		file = File.open(fileName)
		material = Array.new
		file.each_line do |line|
			line = line.delete "\n"
			material.push(line)
		end
		file.close
		for i in 0..material.length-1
			if material[i] == name
				j = i+1
				@sss = @sss + j.to_s + " "
			end
		end
	end
end