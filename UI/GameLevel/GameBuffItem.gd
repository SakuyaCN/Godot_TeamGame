extends Control

var buff = null


func setData(_buff):
	buff = _buff
	reLoad()

func reLoad():
	if buff != null:
		$Name.text = EquUtils.get_attr_string(buff[0])
		$num.text = str(buff[1])
