LUI.UIVerticalList = {}
LUI.UIVerticalList.AddSpacer = function (f1_arg0, f1_arg1, f1_arg2)
	local Widget = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = f1_arg1
	})
	Widget:setPriority(f1_arg2)
	f1_arg0:addElement(Widget)
	return Widget
end

LUI.UIVerticalList.new = function (f2_arg0)
	local Widget = LUI.UIElement.new(f2_arg0)
	Widget.id = "LUIVerticalList"
	Widget:setupUIVerticalList()
	Widget.addSpacer = LUI.UIVerticalList.AddSpacer
	Widget.addElement = LUI.UIVerticalList.AddElement
	Widget.removeElement = LUI.UIVerticalList.RemoveElement
	Widget.addElementToTop = LUI.UIVerticalList.AddElementToTop
	Widget.selectElementIndex = LUI.UIVerticalList.SelectElementIndex
	Widget.addNavigationFailSound = LUI.UIVerticalList.AddNavigationFailSound
	Widget.addNavigationFocusSound = LUI.UIVerticalList.AddNavigationFocusSound
	Widget:registerEventHandler("gain_focus", LUI.UIVerticalList.gainFocus)
	Widget:registerEventHandler("gain_focus_skip_disabled", LUI.UIVerticalList.gainFocusSkipDisabled)
	return Widget
end

LUI.UIVerticalList.AddElement = function (f3_arg0, f3_arg1)
	LUI.UIElement.addElement(f3_arg0, f3_arg1)
	f3_arg0:setLayoutCached(false)
	LUI.UIVerticalList.UpdateNavigation(f3_arg0)
end

LUI.UIVerticalList.RemoveElement = function (f4_arg0, f4_arg1)
	LUI.UIElement.removeElement(f4_arg0, f4_arg1)
	f4_arg0:setLayoutCached(false)
	LUI.UIVerticalList.UpdateNavigation(f4_arg0)
end

LUI.UIVerticalList.AddElementToTop = function (f5_arg0, f5_arg1)
	local f5_local0 = f5_arg0:getFirstChild()
	if f5_local0 ~= nil then
		LUI.UIElement.addElementBefore(f5_arg1, f5_local0)
		f5_arg0:setLayoutCached(false)
		LUI.UIVerticalList.UpdateNavigation(f5_arg0)
	else
		LUI.UIVerticalList.AddElement(f5_arg0, f5_arg1)
		f5_arg0:setLayoutCached(false)
		LUI.UIVerticalList.UpdateNavigation(f5_arg0)
	end
end

LUI.UIVerticalList.SelectElementIndex = function (f6_arg0, f6_arg1)
	local f6_local0 = f6_arg0:getFirstChild()
	local f6_local1 = 0
	while f6_local0 ~= nil do
		if f6_local0.m_focusable then
			f6_local1 = f6_local1 + 1
			if f6_local1 == f6_arg1 then
				f6_local0:processEvent({
					name = "gain_focus"
				})
			else
				f6_local0:processEvent({
					name = "lose_focus"
				})
			end
		end
		f6_local0 = f6_local0:getNextSibling()
	end
end

LUI.UIVerticalList.UpdateNavigation = function (f7_arg0)
	local f7_local0, f7_local1 = nil
	local f7_local2 = f7_arg0:getFirstChild()
	while f7_local2 ~= nil do
		if f7_local2.m_focusable then
			if f7_local0 == nil then
				f7_local0 = f7_local2
			end
			if f7_local1 ~= nil then
				f7_local1.navigation.down = f7_local2
				f7_local2.navigation.up = f7_local1
			end
			if f7_local2.navigation ~= nil and f7_arg0.navigation ~= nil then
				if f7_local2.navigation.left == nil and f7_arg0.navigation.left ~= nil then
					f7_local2.navigation.left = f7_arg0.navigation.left
				end
				if f7_local2.navigation.right == nil and f7_arg0.navigation.right ~= nil then
					f7_local2.navigation.right = f7_arg0.navigation.right
				end
			end
			if f7_arg0.navigationFocusSound ~= nil then
				f7_local2.gainFocusSFX = f7_arg0.navigationFocusSound
			end
			if f7_local2.navigationSounds then
				f7_local2.navigationSounds.up = nil
				f7_local2.navigationSounds.down = nil
			end
			f7_local1 = f7_local2
		end
		f7_local2 = f7_local2:getNextSibling()
	end
	if f7_local1 ~= nil and not f7_arg0.disableWrapping then
		if f7_arg0.navigation ~= nil and f7_arg0.navigation.down ~= nil and f7_arg0.navigation.down.m_focusable == true then
			f7_local1.navigation.down = f7_arg0.navigation.down
			f7_arg0.navigation.down.navigation.up = f7_local1
		elseif f7_local1 ~= f7_local0 then
			f7_local1.navigation.down = f7_local0
			f7_local0.navigation.up = f7_local1
		else
			f7_local1.navigation.down = nil
			f7_local1.navigation.up = nil
		end
		if f7_arg0.navigation ~= nil and f7_arg0.navigation.up ~= nil and f7_arg0.navigation.up.m_focusable == true then
			f7_local0.navigation.up = f7_arg0.navigation.up
			f7_arg0.navigation.up.navigation.down = f7_local0
		end
	elseif f7_local1 ~= nil and f7_arg0.disableWrapping and f7_arg0.navigationFailSound then
		f7_local0.navigationSounds = {}
		f7_local1.navigationSounds = {}
		f7_local0.navigationSounds.up = f7_arg0.navigationFailSound
		f7_local1.navigationSounds.down = f7_arg0.navigationFailSound
	end
end

LUI.UIVerticalList.gainFocus = function (f8_arg0)
	local f8_local0 = nil
	local f8_local1 = f8_arg0:getFirstChild()
	while f8_local1 ~= nil do
		if f8_local1.m_focusable and f8_local0 == nil then
			f8_local0 = f8_local1
		end
		f8_local1 = f8_local1:getNextSibling()
	end
	if f8_local0 ~= nil then
		f8_local0:processEvent({
			name = "gain_focus"
		})
	end
end

LUI.UIVerticalList.gainFocusSkipDisabled = function (f9_arg0)
	local f9_local0, f9_local1 = nil
	local f9_local2 = f9_arg0:getFirstChild()
	while f9_local2 ~= nil do
		if f9_local2.m_focusable then
			if f9_local0 == nil then
				f9_local0 = f9_local2
			end
			if not f9_local2.disabled then
				f9_local1 = f9_local2
				break
			end
		end
		f9_local2 = f9_local2:getNextSibling()
	end
	if f9_local1 ~= nil then
		f9_local0 = f9_local1
	end
	if f9_local0 ~= nil then
		f9_local0:processEvent({
			name = "gain_focus"
		})
	end
end

LUI.UIVerticalList.AddNavigationFocusSound = function (f10_arg0, f10_arg1)
	f10_arg0.navigationFocusSound = f10_arg1
	LUI.UIVerticalList.UpdateNavigation(f10_arg0)
end

LUI.UIVerticalList.AddNavigationFailSound = function (f11_arg0, f11_arg1)
	f11_arg0.navigationFailSound = f11_arg1
	LUI.UIVerticalList.UpdateNavigation(f11_arg0)
end

