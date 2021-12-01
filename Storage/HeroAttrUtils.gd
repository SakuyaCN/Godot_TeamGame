extends Node

#刷新当前选择英雄属性值
func reloadHeroAttr(hero_attr,hero_data): 
	var bean = HeroAttrBean.new()
	bean.setEquAttrBean(hero_data)
	return bean
