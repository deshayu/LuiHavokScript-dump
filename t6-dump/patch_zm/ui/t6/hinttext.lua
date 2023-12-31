if CoD == nil then
	CoD = {}
end
CoD.HintText = {}
CoD.HintText.Height = CoD.textSize.Default
CoD.HintText.ArrowMaterialName = "ui_arrow_right"
CoD.HintText.UpdateText = function (f1_arg0, f1_arg1)
	if f1_arg1 == nil then
		f1_arg0:removeText()
		return 
	elseif f1_arg0.hint:getParent() == nil then
		f1_arg0:addElement(f1_arg0.hintArrow)
		f1_arg0:addElement(f1_arg0.hint)
	end
	f1_arg0.hint:setText(f1_arg1)
end

CoD.HintText.UpdateImage = function (f2_arg0, f2_arg1)
	if f2_arg1 == nil then
		f2_arg1 = "ui_arrow_right"
	end
	f2_arg0.hintArrow:beginAnimation("change_material")
	f2_arg0.hintArrow:setImage(RegisterMaterial(f2_arg1))
end

CoD.HintText.RemoveText = function (f3_arg0)
	f3_arg0.hintArrow:close()
	f3_arg0.hint:close()
end

CoD.HintText.new = function (f4_arg0)
	local f4_local0 = CoD.HintText.Height - 8
	local f4_local1 = -5
	local Widget = LUI.UIElement.new(f4_arg0)
	Widget.hintArrow = LUI.UIImage.new()
	Widget.hintArrow:setLeftRight(true, false, f4_local1, f4_local1 + f4_local0)
	Widget.hintArrow:setTopBottom(false, false, -f4_local0 / 2, f4_local0 / 2)
	Widget.hintArrow:setImage(RegisterMaterial(CoD.HintText.ArrowMaterialName))
	f4_local1 = f4_local1 + f4_local0
	Widget.hint = LUI.UIText.new()
	Widget.hint:setLeftRight(true, true, f4_local1, 0)
	Widget.hint:setTopBottom(true, false, 0, CoD.HintText.Height)
	Widget.hint:setAlignment(LUI.Alignment.Left)
	Widget.setColor = CoD.HintText.SetColor
	Widget.updateText = CoD.HintText.UpdateText
	Widget.removeText = CoD.HintText.RemoveText
	Widget.updateImage = CoD.HintText.UpdateImage
	if CoD.isSinglePlayer then
		Widget:setColor(CoD.visorBlue2.r, CoD.visorBlue2.g, CoD.visorBlue2.b, 1)
		Widget.hintArrow:setRGB(0.75, 0.75, 0.75)
	else
		Widget:setColor(CoD.DefaultTextColor.r, CoD.DefaultTextColor.g, CoD.DefaultTextColor.b, 0.75)
	end
	return Widget
end

CoD.HintText.SetColor = function (f5_arg0, f5_arg1, f5_arg2, f5_arg3, f5_arg4)
	f5_arg0.hintArrow:beginAnimation("color")
	f5_arg0.hintArrow:setRGB(f5_arg1, f5_arg2, f5_arg3)
	f5_arg0.hintArrow:setAlpha(f5_arg4)
	f5_arg0.hint:beginAnimation("color")
	f5_arg0.hint:setRGB(f5_arg1, f5_arg2, f5_arg3)
	f5_arg0.hint:setAlpha(f5_arg4)
end

