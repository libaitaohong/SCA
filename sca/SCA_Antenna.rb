class SCA_Antenna 			#网元类

	def initialize(results) 		#初始化网元参数
		id, signal_intensity, frequency, antenna_site_X, antenna_site_Y, antenna_site_Z = results
		@sca_id = id 	#网元id
		@sca_signal_intensity = signal_intensity 	#网元功率
		fre = frequency.to_i*1000000000
		@sca_frequency = fre 	#网元频率
		@antenna_site_X = antenna_site_X
		@antenna_site_Y = antenna_site_Y
		@antenna_site_Z = antenna_site_Z
	end

	def save 						#网元参数保存
		file = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\网元参数.txt", "a")
		file.syswrite(@sca_id+" ")
		file.syswrite(@antenna_site_X+" ")
		file.syswrite(@antenna_site_Y+" ")
		file.syswrite(@antenna_site_Z)
		file.syswrite("\n")
		file.close
		#信号参数保存
		file1 = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\信号参数.txt", "a")
		file1.syswrite(@sca_id+" ")
		file1.syswrite(@sca_signal_intensity+" ")
		file1.syswrite(@sca_frequency)
		file1.syswrite("\n")
		file1.close
	end
end