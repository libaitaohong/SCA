class SCA_Receiver 					#终端类

	def initialize(results) 		#初始化终端参数
		id, receiver_site_X, receiver_site_Y, receiver_site_Z = results
		@sca_id = id
		@receiver_site_X = receiver_site_X
		@receiver_site_Y = receiver_site_Y
		@receiver_site_Z = receiver_site_Z
	end

	def save 						#终端参数保存
		file = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\终端参数.txt", "a")
		file.syswrite(@sca_id+" ")
		file.syswrite(@receiver_site_X+" ")
		file.syswrite(@receiver_site_Y+" ")
		file.syswrite(@receiver_site_Z)
		file.syswrite("\n")
		file.close
	end

	
end