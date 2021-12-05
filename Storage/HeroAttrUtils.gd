extends Node

#刷新当前选择英雄属性值
func reloadHeroAttr(node:Node,hero_data): 
	var bean = HeroAttrBean.new()
	bean.setEquAttrBean(hero_data)
	bean._parant_node = node
	return bean
