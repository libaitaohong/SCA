#!/usr/bin/env ruby
# Pull in API hooks

require "sketchup"
require "socket"

require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_Antenna')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_Ray')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_Receiver')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_spaceAnalysis')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_Position')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_FirstPath')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_MultiPath')
require File.join(File.expand_path(".."),'/AppData/Roaming/SketchUp/SketchUp 2015/SketchUp/Plugins/sca/SCA_single_draw')

#Menu item
SKETCHUP_CONSOLE.show	

view_menu = UI.menu "Plugins"
view_menu.add_separator
set_param = view_menu.add_submenu("参数设置")
ray = view_menu.add_submenu("射线绘制")
pos = view_menu.add_submenu("定位点绘制")
signal = view_menu.add_submenu("信号覆盖图")

set_param.add_item("设置终端参数") { 	#添加终端参数设置
	set_receiver
}

set_param.add_item("查看终端参数 ") { 	#添加终端参数设置
	check_phone
}

set_param.add_item("清空终端参数") { 	#添加终端参数设置
	phone_empty
}

set_param.add_separator

set_param.add_item("设置网元参数") { 	#添加网元参数设置
	sca_setantennaparameters
}

set_param.add_item("查看网元参数 ") { 	#添加终端参数设置
	check_signal
}

set_param.add_item("清空网元参数") { 	#添加终端参数设置
	single_empty
}
set_param.add_separator

set_param.add_item("绘制网元分布图 ") { 	#添加终端参数设置
	single_draw = Single_draw.new
	single_draw.draw_signal
}
set_param.add_item("删除网元分布图 ") { 	#添加终端参数设置
	single_draw = Single_draw.new
	single_draw.delete_single
}


view_menu.add_separator

view_menu.add_item("空间信息提取") {
	point = SCA_spaceAnalysis.new
	point.pointsanalysis
}

ray.add_item("绘制射线") {  #应该是自动绘制吧
	# array = get_ray_array()
	# if array.empty?
	# 	draw_ray(array)
	# end
	ray = Ray.new
	ray.ray_draw
}

ray.add_item("删除射线") {
	ray = Ray.new
	ray.ray_delete
}

pos.add_item("绘制定位点") {
	point = Position.new
	point.draw_position
}
pos.add_item("删除定位点") {
	point = Position.new
	point.delete_position
}
signal.add_item("首径覆盖图") {
	firstPath= SCA_FirstPath.new
	firstPath.firstPath
}
signal.add_item("删除首径覆盖图") {
	firstPath= SCA_FirstPath.new
	firstPath.delete_firstPath
}
signal.add_separator

signal.add_item("多径覆盖图") {
	multiPath= SCA_MultiPath.new
	multiPath.multiPath
}
signal.add_item("删除多径覆盖图") {
	multiPath= SCA_MultiPath.new
	multiPath.delete_multiPath
}

def sca_setantennaparameters 		#网元与信号参数设置函数
	entities = Sketchup.active_model.entities
	prompts = ["网元ID", "信号强度(dB)", "信号频率(GHz)", "网元坐标_X(mm)", "网元坐标_Y(mm)", "网元坐标_Z(mm)"]
	values = []
	results = inputbox prompts, values, "网元参数设置"
	if !results == false
		sas_antenna_parameters = SCA_Antenna.new(results)
		sas_antenna_parameters.save
	end
	#send_to('127.0.0.1', '2000', sas_antenna_parameters.to_s)

end

def set_receiver #终端参数
	entities = Sketchup.active_model.entities
	prompts = ["终端ID", "终端坐标_X(mm)", "终端坐标_Y(mm)", "终端坐标_Z(mm)"]
	values = []
	results = inputbox prompts, values, "终端参数设置"
	if !results == false
		sca_receiver_parameters = SCA_Receiver.new(results)
		sca_receiver_parameters.save
	end
	
	#send_to('127.0.0.1', '2000', sca_receiver_parameters.to_s)
end
def check_signal
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\网元参数.txt";
		file = File.open(fileName)
		param = Array.new
		many_param = Array.new
		file.each_line do |params|
			param = params.split()
			many_param.push(param)
		end
		file.close
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\信号参数.txt";
		file = File.open(fileName)
		param1 = Array.new
		many_param1 = Array.new
		file.each_line do |params1|
			param1 = params1.split()
			many_param1.push(param1)
		end
		file.close

		content = ""
		many_param.each do |param|
			content = content +  "ID= " + param[0].to_s 
			content = content + "\n"
			content = content + "(X, Y, Z) = " + "(" + param[1].to_s + ", " + param[2].to_s + ", " + param[3].to_s + ")" + "mm"
			content = content + "\n" + "\n"

		end
		many_param1.each do |param1|
			content = content +  "ID= " + param1[0].to_s 
			content = content + "\n"
			content = content +  "功率 = " + param1[1].to_s + "dB"
			content = content + "\n"
			fre = param1[2].to_i/1000000000
			content = content +  "频率 = " + fre.to_s + "GHz"
			content = content + "\n" + "\n"
		end

		UI.messagebox content, MB_MULTILINE, "网元参数"

	end
	def check_phone
		fileName = "C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\终端参数.txt";
		file = File.open(fileName)
		param = Array.new
		many_param = Array.new
		file.each_line do |params|
			param = params.split()
			many_param.push(param)
		end
		file.close
		content = ""
		many_param.each do |param|
			content = content +  "ID = " + param[0].to_s 
			content = content + "\n"
			content = content + "(X, Y, Z) = " + "(" + param[1].to_s + ", " + param[2].to_s + ", " + param[3].to_s + ")" + "mm"
			content = content + "\n" + "\n"

		end
		UI.messagebox content, MB_MULTILINE, "终端参数"
	end

def single_empty
	file = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\网元参数.txt", "w+")
end
def phone_empty
	file = File.new("C:\\Users\\zhanghe\\Desktop\\ZTE\\Source Code\\终端参数.txt", "w+")
end
