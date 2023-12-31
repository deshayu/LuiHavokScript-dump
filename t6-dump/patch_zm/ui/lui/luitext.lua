LUI.UIText = InheritFrom(LUI.UIElement)
LUI.UIText.addElement = function (f1_arg0, f1_arg1)
	DebugPrint("WARNING: An element is being added to a UIText element. This will cause undesired behavior!")
	LUI.UIElement.addElement(f1_arg0, f1_arg1)
end

LUI.UIText.addElementBefore = function (f2_arg0, f2_arg1)
	DebugPrint("WARNING: An element is being added to a UIText element. This will cause undesired behavior!")
	LUI.UIElement.addElementBefore(f2_arg0, f2_arg1)
end

LUI.UIText.addElementAfter = function (f3_arg0, f3_arg1)
	DebugPrint("WARNING: An element is being added to a UIText element. This will cause undesired behavior!")
	LUI.UIElement.addElementAfter(f3_arg0, f3_arg1)
end

LUI.UIText.new = function (f4_arg0, f4_arg1)
	if f4_arg0 == nil then
		f4_arg0 = {
			red = CoD.DefaultTextColor.r,
			green = CoD.DefaultTextColor.g,
			blue = CoD.DefaultTextColor.b
		}
	elseif f4_arg0.red == nil and f4_arg0.green == nil and f4_arg0.blue == nil then
		f4_arg0.red = CoD.DefaultTextColor.r
		f4_arg0.green = CoD.DefaultTextColor.g
		f4_arg0.blue = CoD.DefaultTextColor.b
	end
	local Widget = LUI.UIElement.new(f4_arg0)
	Widget:setClass(LUI.UIText)
	if not f4_arg1 then
		Widget:setupUIText()
	else
		Widget:setupUITextUncached()
	end
	return Widget
end

LUI.UIText.TransitionComplete_OutState = function (f5_arg0, f5_arg1)
	f5_arg0:setText(f5_arg0.replaceContentData.text)
	f5_arg0:registerEventHandler("transition_complete_" .. f5_arg0.replaceContentData.outState, nil)
	f5_arg0:animateToState(f5_arg0.replaceContentData.inState, f5_arg0.replaceContentData.inDuration)
	f5_arg0.replaceContentData = nil
end

LUI.UIText.setText = function (f6_arg0, f6_arg1, f6_arg2, f6_arg3, f6_arg4, f6_arg5)
	if f6_arg2 ~= nil and f6_arg3 ~= nil then
		f6_arg0.replaceContentData = {}
		f6_arg0.replaceContentData.outState = f6_arg2
		f6_arg0.replaceContentData.inState = f6_arg3
		f6_arg0.replaceContentData.outDuration = f6_arg4
		f6_arg0.replaceContentData.inDuration = f6_arg5
		f6_arg0.replaceContentData.text = f6_arg1
		f6_arg0:registerEventHandler("transition_complete_" .. f6_arg2, LUI.UIText.TransitionComplete_OutState)
		f6_arg0:animateToState(f6_arg2, f6_arg4)
		return 
	else
		f6_arg0:setTextInC(f6_arg1)
	end
end

LUI.UIText.id = "LUIText"
