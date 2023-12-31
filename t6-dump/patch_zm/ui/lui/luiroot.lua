LUI.UIRoot = {}
local f0_local0 = function (f1_arg0, f1_arg1)
	f1_arg0:registerAnimationState("default", {
		left = -f1_arg1.width / 2,
		top = -f1_arg1.height / 2,
		right = f1_arg1.width / 2,
		bottom = f1_arg1.height / 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false
	})
	f1_arg0:animateToState("default")
end

local f0_local1 = function (f2_arg0, f2_arg1)
	f2_arg1.root = f2_arg0
	f2_arg0:dispatchEventToChildren(f2_arg1)
end

local f0_local2 = function (f3_arg0, f3_arg1)
	f3_arg0:setLayoutCached(false)
	f3_arg0:dispatchEventToChildren(f3_arg1)
end

local f0_local3 = function (f4_arg0, f4_arg1)
	local f4_local0 = LUI.createMenu[f4_arg1.menu]
	if f4_local0 then
		f4_arg0:addElement(f4_local0(f4_arg1.controller))
	else
		error("LUI Error: Tried to add nonexistent menu " .. f4_arg1.menu)
	end
end

local f0_local4 = function (f5_arg0, f5_arg1)
	local f5_local0 = f5_arg0.m_currentAnimationState
	local f5_local1 = f5_local0.unitsToPixels
	return f5_local0.left + f5_arg1.left * f5_local1, f5_local0.top + f5_arg1.top * f5_local1, f5_local0.left + f5_arg1.right * f5_local1, f5_local0.top + f5_arg1.bottom * f5_local1
end

local f0_local5 = function (f6_arg0, f6_arg1)
	return f6_arg1 * f6_arg0.m_currentAnimationState.unitsToPixels
end

local f0_local6 = function (f7_arg0, f7_arg1, f7_arg2)
	return f7_arg0:RootPixelsToUnits(f7_arg1, f7_arg2)
end

LUI.UIRoot.new = function (f8_arg0)
	local Widget = LUI.UIElement.new({
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false
	})
	Widget.id = "LUIRoot"
	Widget.unitsToPixelsRect = f0_local4
	Widget.pixelsToUnits = f0_local6
	Widget.unitsToPixels = f0_local5
	Widget:registerEventHandler("resize", f0_local0)
	Widget:registerEventHandler("addmenu", f0_local3)
	Widget:registerEventHandler("mousemove", f0_local1)
	Widget:registerEventHandler("mousedown", f0_local1)
	Widget:registerEventHandler("mouseup", f0_local1)
	Widget:registerEventHandler("controller_changed", f0_local2)
	Widget.name = f8_arg0
	Widget:setRoot()
	LUI.roots[f8_arg0] = Widget
	return Widget
end

