LUI.UIElement = {
	id = "LUIElement",
	m_defaultAnimationState = {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = false,
		topAnchor = false,
		bottomAnchor = false,
		rightAnchor = false,
		red = 1,
		green = 1,
		blue = 1,
		alpha = 1,
		alphaMultiplier = 1
	}
}
LUI.UIContainer = {}
LUI.UIElement.addElement = function (f1_arg0, f1_arg1)
	if f1_arg0:canAddElement(f1_arg1) then
		f1_arg0:addElementToC(f1_arg1)
	end
end

LUI.UIElement.addElementBefore = function (f2_arg0, f2_arg1)
	local f2_local0 = f2_arg1:getParent()
	if not f2_local0 then
		error("LUI Error: Element has no parent!")
		return 
	elseif f2_local0:canAddElement(f2_arg0) then
		f2_arg0:addElementBeforeInC(f2_arg1)
	end
end

LUI.UIElement.addElementAfter = function (f3_arg0, f3_arg1)
	local f3_local0 = f3_arg1:getParent()
	if not f3_local0 then
		error("LUI Error: Element has no parent!")
		return 
	elseif f3_local0:canAddElement(f3_arg0) then
		f3_arg0:addElementAfterInC(f3_arg1)
	end
end

LUI.UIElement.canAddElement = function (f4_arg0, f4_arg1)
	if f4_arg1 == nil then
		error("LUI Error: Tried to add nil element!")
		return false
	elseif f4_arg1:getParent() == f4_arg0 then
		return false
	else
		return true
	end
end

LUI.UIElement.isClosed = function (f5_arg0)
	return f5_arg0:getParent() == nil
end

LUI.UIElement.close = function (f6_arg0)
	local f6_local0 = f6_arg0:getParent()
	if f6_local0 ~= nil then
		f6_local0:removeElement(f6_arg0)
	end
end

LUI.UIElement.closeAndRefocus = function (f7_arg0, f7_arg1)
	if f7_arg0:isInFocus() then
		f7_arg0:processEvent(LUI.UIButton.LoseFocusEvent)
		f7_arg1:processEvent(LUI.UIButton.GainFocusEvent)
	end
	f7_arg0:close()
end

LUI.UIElement.getFullID = function (f8_arg0)
	local f8_local0 = f8_arg0.id
	local f8_local1 = f8_arg0:getParent()
	while f8_local1 do
		f8_local0 = f8_local1.id .. "/" .. f8_local0
		f8_local1 = f8_local1:getParent()
	end
	return f8_local0
end

LUI.UIElement.isInputDisabledOnChain = function (f9_arg0)
	while f9_arg0 do
		if f9_arg0.m_inputDisabled then
			return true
		end
		f9_arg0 = f9_arg0:getParent()
	end
	return false
end

LUI.UIElement.setMouseDisabled = function (f10_arg0, f10_arg1)
	f10_arg0.m_leftMouseDown = nil
	f10_arg0.m_rightMouseDown = nil
	f10_arg0.m_mouseDisabled = f10_arg1
	if CoD.isPC then
		CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_NORMAL)
	end
end

LUI.UIElement.setRestrictMouseInsideElement = function (f11_arg0, f11_arg1)
	f11_arg0.m_restrictMouseInside = f11_arg1
end

LUI.UIElement.setHandleMouseAnim = function (f12_arg0, f12_arg1)
	f12_arg0.handleMouseAnim = f12_arg1
end

LUI.UIElement.setHandleMouse = function (f13_arg0, f13_arg1)
	f13_arg0.handleMouseMove = f13_arg1
	f13_arg0.handleMouseButton = f13_arg1
end

LUI.UIElement.setHandleMouseMove = function (f14_arg0, f14_arg1)
	f14_arg0.handleMouseMove = f14_arg1
end

LUI.UIElement.setHandleMouseButton = function (f15_arg0, f15_arg1)
	f15_arg0.handleMouseButton = f15_arg1
end

LUI.UIElement.IsMouseInsideElement = function (f16_arg0, f16_arg1)
	local f16_local0 = false
	local f16_local1, f16_local2 = ProjectRootCoordinate(f16_arg1.rootName, f16_arg1.x, f16_arg1.y)
	if f16_local1 == nil or f16_local2 == nil then
		return f16_local0
	end
	local f16_local3, f16_local4, f16_local5, f16_local6 = f16_arg0:getRect()
	if f16_local3 ~= nil and f16_local4 <= f16_local2 and f16_local2 <= f16_local6 and f16_local3 <= f16_local1 and f16_local1 <= f16_local5 then
		f16_local0 = true
	end
	return f16_local0, f16_local1, f16_local2
end

LUI.UIElement.MouseClear = function (f17_arg0, f17_arg1)
	f17_arg0.m_leftMouseDown = nil
	f17_arg0.m_rightMouseDown = nil
	f17_arg0:dispatchEventToChildren(f17_arg1)
end

LUI.UIElement.MouseMoveEvent = function (f18_arg0, f18_arg1)
	if f18_arg0.m_inputDisabled or f18_arg0.m_mouseDisabled then
		return 
	elseif f18_arg0.handleMouseMove and not f18_arg1.waitingForKeyBind then
		local f18_local0, f18_local1, f18_local2 = LUI.UIElement.IsMouseInsideElement(f18_arg0, f18_arg1)
		if f18_local0 then
			if f18_arg0.m_focusable and not f18_arg0:isInFocus() then
				if LUI.currentMouseFocus ~= nil then
					LUI.currentMouseFocus:processEvent({
						name = "lose_focus",
						controller = f18_arg1.controller
					})
					LUI.currentMouseFocus.m_mouseOver = nil
				end
				f18_arg0:processEvent({
					name = "gain_focus",
					controller = f18_arg1.controller
				})
				if f18_arg0.gainFocusSFX ~= nil then
					Engine.PlaySound(f18_arg0.gainFocusSFX)
				end
				LUI.currentMouseFocus = f18_arg0
			end
			if f18_arg0.m_mouseOver == nil then
				f18_arg0.m_mouseOver = true
				if f18_arg0.m_eventHandlers.mouseenter ~= nil then
					f18_arg0.m_eventHandlers:mouseenter({
						name = "mouseenter",
						controller = f18_arg1.controller,
						root = f18_arg1.root,
						x = f18_local1,
						y = f18_local2
					})
				end
			end
			if f18_arg0.m_eventHandlers.mouseover ~= nil then
				f18_arg0.m_eventHandlers:mouseover({
					name = "mouseover",
					controller = f18_arg1.controller,
					root = f18_arg1.root,
					x = f18_local1,
					y = f18_local2
				})
			end
			if f18_arg0.handleMouseAnim and f18_arg0.m_leftMouseDown == nil then
				CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_GRABOPEN)
				CoD.Mouse.InGrabMode = true
			end
		elseif f18_arg0 ~= LUI.currentMouseFocus then
			if f18_arg0:isInFocus() then
				f18_arg0:processEvent({
					name = "lose_focus",
					controller = f18_arg1.controller
				})
			end
			if f18_arg0.m_mouseOver ~= nil then
				f18_arg0.m_mouseOver = nil
				if f18_arg0.m_eventHandlers.mouseleave ~= nil then
					f18_arg0.m_eventHandlers:mouseleave({
						name = "mouseleave",
						controller = f18_arg1.controller,
						root = f18_arg1.root
					})
				end
				if f18_arg0.handleMouseAnim and f18_arg0.m_leftMouseDown == nil then
					CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_NORMAL)
				end
			end
		end
		if f18_arg0.m_eventHandlers.mousedrag ~= nil and f18_arg0.m_leftMouseDown ~= nil then
			f18_arg0.m_eventHandlers:mousedrag({
				name = "mousedrag",
				controller = f18_arg1.controller,
				root = f18_arg1.root,
				x = f18_local1,
				y = f18_local2
			})
		end
	end
	if not f18_arg0.m_restrictMouseInside or LUI.UIElement.IsMouseInsideElement(f18_arg0, f18_arg1) then
		f18_arg0:dispatchEventToChildren(f18_arg1)
	end
end

LUI.UIElement.MouseButtonEvent = function (f19_arg0, f19_arg1)
	if f19_arg0.m_inputDisabled or f19_arg0.m_mouseDisabled then
		return 
	elseif f19_arg0.handleMouseButton then
		local f19_local0, f19_local1, f19_local2 = LUI.UIElement.IsMouseInsideElement(f19_arg0, f19_arg1)
		if f19_arg1.name == "mouseup" or f19_arg1.name == "touchpad_up" then
			if f19_arg1.button == "left" then
				if f19_arg0.handleMouseAnim then
					if f19_local0 then
						CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_GRABOPEN)
					else
						CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_NORMAL)
					end
				end
				if f19_arg0.m_leftMouseDown ~= nil or f19_arg1.name == "touchpad_up" then
					f19_arg0.m_leftMouseDown = nil
					if f19_arg0.m_eventHandlers.leftmouseup ~= nil then
						local f19_local3 = f19_arg0.m_eventHandlers:leftmouseup({
							name = "leftmouseup",
							controller = f19_arg1.controller,
							root = f19_arg1.root,
							x = f19_local1,
							y = f19_local2,
							inside = f19_local0
						})
						if f19_local3 then
							return f19_local3
						end
					end
				elseif not f19_local0 and f19_arg0.m_eventHandlers.leftmouseup_outside ~= nil then
					local f19_local3 = f19_arg0.m_eventHandlers:leftmouseup_outside({
						name = "leftmouseup_outside",
						controller = f19_arg1.controller,
						root = f19_arg1.root,
						x = f19_local1,
						y = f19_local2,
						inside = f19_local0
					})
					if f19_local3 then
						return f19_local3
					end
				end
			end
			if f19_arg1.button == "right" and f19_arg0.m_rightMouseDown ~= nil then
				f19_arg0.m_rightMouseDown = nil
				if f19_arg0.m_eventHandlers.rightmouseup ~= nil then
					local f19_local3 = f19_arg0.m_eventHandlers:rightmouseup({
						name = "rightmouseup",
						controller = f19_arg1.controller,
						root = f19_arg1.root,
						x = f19_local1,
						y = f19_local2,
						inside = f19_local0
					})
					if f19_local3 then
						return f19_local3
					end
				end
			end
		end
		if f19_local0 and (f19_arg1.name == "mousedown" or f19_arg1.name == "touchpad_down") then
			if f19_arg1.button == "left" and f19_arg0.m_eventHandlers.leftmousedown ~= nil and f19_arg0.m_leftMouseDown == nil then
				f19_arg0.m_leftMouseDown = true
				f19_arg0.m_eventHandlers:leftmousedown({
					name = "leftmousedown",
					controller = f19_arg1.controller,
					root = f19_arg1.root,
					x = f19_local1,
					y = f19_local2,
					inside = f19_local0
				})
				if f19_arg0.handleMouseAnim then
					CoD.Mouse.SetCursorState(CoD.Mouse.CURSOR_GRABCLOSE)
				end
			end
			if f19_arg1.button == "right" and f19_arg0.m_eventHandlers.rightmousedown ~= nil and f19_arg0.m_rightMouseDown == nil then
				f19_arg0.m_rightMouseDown = true
				f19_arg0.m_eventHandlers:rightmousedown({
					name = "rightmousedown",
					controller = f19_arg1.controller,
					root = f19_arg1.root,
					x = f19_local1,
					y = f19_local2,
					inside = f19_local0
				})
			end
		end
	end
	if not f19_arg0.m_restrictMouseInside or LUI.UIElement.IsMouseInsideElement(f19_arg0, f19_arg1) then
		f19_arg0:dispatchEventToChildren(f19_arg1)
	end
end

LUI.UIElement.GamepadButton = function (f20_arg0, f20_arg1)
	if f20_arg0.m_inputDisabled then
		return 
	elseif not f20_arg0:handleGamepadButton(f20_arg1) then
		if f20_arg0.m_ownerController == nil or f20_arg0.m_ownerController == f20_arg1.controller then
			return f20_arg0:dispatchEventToChildren(f20_arg1)
		else

		end
	else
		return true
	end
end

LUI.UIElement.GamepadButton_DPadOnly = function (f21_arg0, f21_arg1)
	if f21_arg1.qualifier ~= "dpad" then
		return 
	else
		LUI.UIElement.GamepadButton(f21_arg0, f21_arg1)
	end
end

LUI.UIElement.handleGamepadButton = function (f22_arg0, f22_arg1)
	if f22_arg0:isInFocus() and f22_arg1.down == true and f22_arg0.m_disableNavigation ~= true then
		if f22_arg0.navigationSounds and f22_arg0.navigationSounds[f22_arg1.button] then
			Engine.PlaySound(f22_arg0.navigationSounds[f22_arg1.button])
		end
		if f22_arg0.navigation[f22_arg1.button] and f22_arg0.navigation[f22_arg1.button].m_focusable then
			f22_arg0:processEvent({
				name = "lose_focus",
				controller = f22_arg1.controller,
				button = f22_arg1.button
			})
			f22_arg0.navigation[f22_arg1.button]:processEvent({
				name = "gain_focus",
				controller = f22_arg1.controller,
				button = f22_arg1.button
			})
			if f22_arg0.navigation[f22_arg1.button].gainFocusSFX then
				Engine.PlaySound(f22_arg0.navigation[f22_arg1.button].gainFocusSFX)
			end
			return true
		end
	end
end

LUI.UIElement.gainFocus = function (f23_arg0, f23_arg1)
	if f23_arg0.m_focusable then
		f23_arg0:setFocus(true)
		LUI.currentMouseFocus = f23_arg0
	end
	f23_arg0:dispatchEventToChildren(f23_arg1)
end

LUI.UIElement.loseFocus = function (f24_arg0, f24_arg1)
	if f24_arg0.m_focusable and f24_arg0:isInFocus() then
		f24_arg0:setFocus(false)
	end
	f24_arg0:dispatchEventToChildren(f24_arg1)
end

LUI.UIElement.processEvent = function (f25_arg0, f25_arg1)
	local f25_local0 = f25_arg0.m_eventHandlers[f25_arg1.name]
	if f25_local0 ~= nil then
		return f25_local0(f25_arg0, f25_arg1)
	else
		return f25_arg0:dispatchEventToChildren(f25_arg1)
	end
end

LUI.UIElement.getRoot = function (f26_arg0)
	if not f26_arg0 then
		return 
	end
	local f26_local0 = f26_arg0:getParent()
	while f26_local0 do
		f26_arg0 = f26_local0
		f26_local0 = f26_local0:getParent()
	end
	return f26_arg0
end

LUI.UIElement.dispatchEventToRoot = function (f27_arg0, f27_arg1)
	local f27_local0 = f27_arg0:getParent()
	while f27_local0 do
		local f27_local1 = f27_local0:getParent()
		if f27_local1 == nil then
			local f27_local2 = f27_local0.m_eventHandlers[f27_arg1.name]
			if f27_local2 ~= nil then
				f27_local2(f27_local0, f27_arg1)
			end
			f27_local0:dispatchEventToChildren(f27_arg1)
			return 
		end
		f27_local0 = f27_local1
	end
end

LUI.UIElement.dispatchEventToParent = function (f28_arg0, f28_arg1)
	local f28_local0 = f28_arg0:getParent()
	while f28_local0 do
		local f28_local1 = f28_local0.m_eventHandlers[f28_arg1.name]
		if f28_local1 then
			return f28_local1(f28_local0, f28_arg1)
		end
		f28_local0 = f28_local0:getParent()
	end
end

LUI.UIElement.dispatchEventToChildren = function (f29_arg0, f29_arg1)
	local f29_local0 = f29_arg0:getFirstChild()
	if f29_local0 == nil then
		return 
	end
	while f29_local0 ~= nil do
		local f29_local1 = f29_local0:getNextSibling()
		local f29_local2 = f29_local0:processEvent(f29_arg1)
		if f29_local2 then
			return f29_local2
		end
		f29_local0 = f29_local1
	end
end

LUI.UIElement.registerChildEventHandler = function (f30_arg0, f30_arg1)
	f30_arg0.m_eventsHandledByChildren[f30_arg1] = true
	local f30_local0 = f30_arg0:getParent()
	if f30_local0 ~= nil then
		f30_local0:registerChildEventHandler(f30_arg1)
	end
end

LUI.UIElement.registerEventHandler = function (f31_arg0, f31_arg1, f31_arg2)
	f31_arg0.m_eventHandlers[f31_arg1] = f31_arg2
end

LUI.UIElement.isFocusable = function (f32_arg0)
	return f32_arg0.m_focusable
end

LUI.UIElement.makeFocusable = function (f33_arg0)
	f33_arg0.m_focusable = true
	f33_arg0.navigation = {}
end

LUI.UIElement.makeNotFocusable = function (f34_arg0)
	f34_arg0.m_focusable = false
end

LUI.UIElement.isIDNamed = function (f35_arg0)
	if string.find(f35_arg0.id, ".") then
		return true
	else
		return false
	end
end

LUI.UIElement.getFirstInFocus = function (f36_arg0)
	if f36_arg0:isInFocus() then
		return f36_arg0
	end
	local f36_local0 = f36_arg0:getFirstChild()
	while f36_local0 do
		local f36_local1 = f36_local0:getFirstInFocus()
		if f36_local1 then
			return f36_local1
		end
		f36_local0 = f36_local0:getNextSibling()
	end
	local f36_local1 = f36_arg0:getNextSibling()
	if f36_local1 then
		return f36_local1:getFirstInFocus()
	end
end

LUI.UIElement.saveState = function (f37_arg0)
	if not f37_arg0:isIDNamed() then
		error("LUI Error: Tried to save menu state, but element has no name: " .. f37_arg0:getFullID())
		return 
	elseif f37_arg0:getFirstChild() then
		local f37_local0 = f37_arg0:getFirstChild()
		f37_local0 = f37_local0:getFirstInFocus()
		if f37_local0 then
			if not f37_local0:isIDNamed() then
				error("LUI Error: Tried to save menu state, but focused element has no name: " .. f37_local0:getFullID())
				return 
			end
			LUI.savedMenuStates[f37_arg0.id] = {
				id = f37_local0.id,
				data = f37_local0.saveData
			}
		else
			LUI.savedMenuStates[f37_arg0.id] = nil
		end
	end
end

LUI.UIElement.clearSavedState = function (f38_arg0)
	if not f38_arg0:isIDNamed() then
		error("LUI Error: Tried to save menu state, but element has no name: " .. f38_arg0:getFullID())
		return 
	else
		LUI.savedMenuStates[f38_arg0.id] = nil
	end
end

LUI.UIElement.restoreState = function (f39_arg0)
	if not f39_arg0:isIDNamed() then
		error("LUI Error: Tried to restore menu state, but element has no name: " .. f39_arg0:getFullID())
		return 
	else
		local f39_local0 = LUI.savedMenuStates[f39_arg0.id]
		if f39_local0 ~= nil and f39_local0.id then
			return f39_arg0:processEvent({
				name = "restore_focus",
				id = f39_local0.id,
				data = f39_local0.data
			})
		else

		end
	end
end

LUI.UIElement.restoreFocus = function (f40_arg0, f40_arg1)
	if f40_arg0.id == f40_arg1.id then
		f40_arg0:processEvent({
			name = "gain_focus"
		})
		return true
	else
		return f40_arg0:dispatchEventToChildren(f40_arg1)
	end
end

LUI.UIElement.animate = function (f41_arg0, f41_arg1)
	if f41_arg0.m_animationStates[f41_arg1.animationStateName] then
		f41_arg0:animateToState(f41_arg1.animationStateName, f41_arg1.duration, f41_arg1.easeIn, f41_arg1.easeOut)
		if f41_arg1.animateChildren then
			f41_arg0:dispatchEventToChildren(f41_arg1)
		end
	else
		f41_arg0:dispatchEventToChildren(f41_arg1)
	end
end

LUI.UIElement.hide = function (f42_arg0)
	f42_arg0:setAlpha(0)
	f42_arg0.m_inputDisabled = true
end

LUI.UIElement.show = function (f43_arg0)
	f43_arg0:setAlpha(1)
	f43_arg0.m_inputDisabled = nil
end

LUI.UIElement.rotateRandomly = function (f44_arg0, f44_arg1)
	if not f44_arg0.m_eventHandlers.rotate_randomly then
		f44_arg0:registerEventHandler("rotate_randomly", LUI.UIElement.rotateRandomly)
		f44_arg0:addElement(LUI.UITimer.new(2500, "rotate_randomly", false, f44_arg0))
	end
	f44_arg0:beginAnimation("rotate_randomly", 2500, true, true)
	f44_arg0:setXRot(math.random(-45, 45))
	f44_arg0:setYRot(math.random(-45, 45))
end

LUI.UIElement.spinRandomly = function (f45_arg0, f45_arg1)
	if not f45_arg0.m_eventHandlers.spin_randomly then
		f45_arg0:registerEventHandler("spin_randomly", LUI.UIElement.rotateRandomly)
		f45_arg0:addElement(LUI.UITimer.new(2500, "spin_randomly", false, f45_arg0))
	end
	f45_arg0:beginAnimation("rotate_randomly", 2500, true, true)
	f45_arg0:setZRot(math.random(-90, 90))
end

LUI.UIElement.flicker = function (f46_arg0, f46_arg1, f46_arg2, f46_arg3, f46_arg4, f46_arg5, f46_arg6)
	if not f46_arg1 then
		f46_arg1 = 1000
	end
	if not f46_arg2 then
		f46_arg2 = 1
	end
	if not f46_arg3 then
		f46_arg3 = 0.2
	end
	if not f46_arg4 then
		f46_arg4 = 0.7
	end
	if not f46_arg5 then
		f46_arg5 = 50
	end
	if not f46_arg6 then
		f46_arg6 = 150
	end
	f46_arg0.lowFlickerAlpha = f46_arg3
	f46_arg0.highFlickerAlpha = f46_arg4
	f46_arg0.endFlickerAlpha = f46_arg2
	f46_arg0:registerEventHandler("close_flicker_timer", LUI.UIElement.CloseFlickerTimer)
	f46_arg0:alternateStates(f46_arg1, LUI.UIElement.LowFlickerAlternate, LUI.UIElement.HighFlickerAlternate, f46_arg5, f46_arg6, LUI.UIElement.EndFlickerAlternate)
end

LUI.UIElement.LowFlickerAlternate = function (f47_arg0, f47_arg1)
	f47_arg0:beginAnimation("lower_alpha", f47_arg1)
	f47_arg0:setAlpha(f47_arg0.lowFlickerAlpha)
end

LUI.UIElement.HighFlickerAlternate = function (f48_arg0, f48_arg1)
	f48_arg0:beginAnimation("raise_alpha", f48_arg1)
	f48_arg0:setAlpha(f48_arg0.highFlickerAlpha)
end

LUI.UIElement.EndFlickerAlternate = function (f49_arg0, f49_arg1)
	f49_arg0:beginAnimation("end_alpha", f49_arg1)
	f49_arg0:setAlpha(f49_arg0.endFlickerAlpha)
	f49_arg0.lowFlickerAlpha = nil
	f49_arg0.highFlickerAlpha = nil
	f49_arg0.endFlickerAlpha = nil
end

LUI.UIElement.CloseFlickerTimer = function (f50_arg0, f50_arg1)
	if f50_arg0.lowFlickerAlpha then
		f50_arg0:closeStateAlternator()
	end
end

LUI.UIElement.closeStateAlternator = function (f51_arg0)
	if f51_arg0.alternatorTimer then
		f51_arg0.alternatorTimer:close()
		f51_arg0.alternatorTimer = nil
	end
	if f51_arg0.alternatorEnd then
		f51_arg0:alternatorEnd()
		f51_arg0.alternatorEnd = nil
	end
end

LUI.UIElement.UpdateStateAlternater = function (f52_arg0, f52_arg1)
	if f52_arg1.next ~= "first" and f52_arg1.next ~= "second" then
		f52_arg0:closeStateAlternator()
		return 
	end
	local f52_local0 = "first"
	local f52_local1 = f52_arg1.func2
	if f52_arg1.next == "first" then
		f52_local0 = "second"
		f52_local1 = f52_arg1.func1
	end
	local f52_local2 = math.random(f52_arg1.lowTime, f52_arg1.highTime)
	if f52_arg1.timeLeft <= f52_local2 and not f52_arg1.isInfinite then
		f52_local2 = f52_arg1.timeLeft + 1
		f52_local0 = "final"
	end
	f52_local1(f52_arg0, f52_local2)
	local f52_local3 = -1
	if not f52_arg1.isInfinite then
		f52_local3 = f52_arg1.timeLeft - f52_local2
	end
	f52_arg0.alternatorTimer = LUI.UITimer.new(f52_local2, {
		name = "update_state_alternate",
		isInfinite = f52_arg1.isInfinite,
		next = f52_local0,
		func1 = f52_arg1.func1,
		func2 = f52_arg1.func2,
		timeLeft = f52_local3,
		lowTime = f52_arg1.lowTime,
		highTime = f52_arg1.highTime
	}, true, f52_arg0)
	f52_arg0:addElement(f52_arg0.alternatorTimer)
end

LUI.UIElement.alternateStates = function (f53_arg0, f53_arg1, f53_arg2, f53_arg3, f53_arg4, f53_arg5, f53_arg6)
	if f53_arg0.alternatorEnd then
		return 
	elseif not f53_arg1 then
		f53_arg1 = 1000
	end
	if f53_arg2 == nil or f53_arg3 == nil then
		return 
	elseif f53_arg6 == nil then
		f53_arg6 = f53_arg3
	end
	if not f53_arg4 then
		f53_arg4 = 50
	end
	if not f53_arg5 then
		f53_arg5 = 150
	end
	f53_arg0.alternatorEnd = f53_arg6
	f53_arg0:registerEventHandler("update_state_alternate", LUI.UIElement.UpdateStateAlternater)
	f53_arg0:processEvent({
		name = "update_state_alternate",
		isInfinite = f53_arg1 == 0,
		next = "first",
		func1 = f53_arg2,
		func2 = f53_arg3,
		timeLeft = f53_arg1,
		lowTime = f53_arg4,
		highTime = f53_arg5
	})
end

LUI.UIElement.CloseAnimationQueue = function (f54_arg0)
	if f54_arg0.queueTimer then
		f54_arg0.queueTimer:close()
		f54_arg0.queueTimer = nil
	end
end

LUI.UIElement.QueueAnimation = function (f55_arg0, f55_arg1)
	if #f55_arg1.queue == 0 or not f55_arg0.queueTimer then
		LUI.UIElement.CloseAnimationQueue(f55_arg0)
		return 
	end
	local f55_local0 = f55_arg1.queue
	local f55_local1 = f55_local0[1].funct
	local f55_local2 = f55_local0[1].time
	if f55_local2 == nil then
		f55_local2 = 0
	end
	if f55_local1 then
		f55_local1(f55_arg0, f55_local2, f55_local0[1])
	end
	if f55_arg1.repeats then
		table.insert(f55_local0, f55_local0[1])
	end
	table.remove(f55_local0, 1)
	f55_arg0.queueTimer.interval = f55_local2
end

LUI.UIElement.animationQueue = function (f56_arg0, f56_arg1, f56_arg2, f56_arg3)
	if f56_arg0.queueTimer or not f56_arg1 then
		return 
	end
	f56_arg0:registerEventHandler("queue_animation", LUI.UIElement.QueueAnimation)
	local f56_local0 = 0
	if f56_arg2 then
		f56_local0 = f56_arg2
	end
	f56_arg0.queueTimer = LUI.UITimer.new(f56_local0, {
		name = "queue_animation",
		repeats = f56_arg3,
		queue = f56_arg1
	}, false, f56_arg0)
	f56_arg0:addElement(f56_arg0.queueTimer)
end

LUI.UIElement.ViewportAnimation = function (f57_arg0, f57_arg1)
	if not f57_arg0.viewportScaleTime then
		f57_arg0.viewportScaleTime = f57_arg1.timeElapsed
	else
		f57_arg0.viewportScaleTime = f57_arg0.viewportScaleTime + f57_arg1.timeElapsed
	end
	local f57_local0 = f57_arg0.viewportScaleTime / f57_arg1.scaleDuration
	if f57_local0 > 1 then
		f57_local0 = 1
		f57_arg1.timer:close()
		f57_arg0.viewportScaleTime = nil
	end
	local f57_local1 = f57_arg1.startScale + (f57_arg1.endScale - f57_arg1.startScale) * f57_local0
	Engine.SetViewport(f57_arg1.controller, 0.1 - f57_local1 / 10, 0.5 - f57_local1 / 2, f57_local1)
end

LUI.UIElement.animateViewport = function (f58_arg0, f58_arg1, f58_arg2, f58_arg3, f58_arg4)
	f58_arg0:addElement(LUI.UITimer.new(1, {
		name = "viewport_animation",
		controller = f58_arg1,
		startScale = f58_arg2,
		endScale = f58_arg3,
		scaleDuration = f58_arg4
	}, false, f58_arg0))
end

LUI.UIElement.animateToNextState = function (f59_arg0, f59_arg1, f59_arg2, f59_arg3, f59_arg4)
	return function (f68_arg0, f68_arg1)
		if not f68_arg1.interrupted then
			f68_arg0:animateToState(f59_arg1, f59_arg2, f59_arg3, f59_arg4)
		end
	end

end

LUI.UIElement.CompleteAnimationEvent = function (f60_arg0, f60_arg1)
	f60_arg0:completeAnimation()
	f60_arg0:dispatchEventToChildren(f60_arg1)
end

LUI.UIElement.UpdateSafeArea = function (f61_arg0, f61_arg1, f61_arg2)
	if f61_arg2 == nil and f61_arg1 ~= nil then
		f61_arg2 = f61_arg1.controller
	end
	local f61_local0, f61_local1, f61_local2, f61_local3 = Engine.GetUserSafeAreaForController(f61_arg2)
	f61_arg0:setLeftRight(false, false, f61_local0, f61_local2)
	f61_arg0:setTopBottom(false, false, f61_local1, f61_local3)
end

LUI.UIElement.sizeToSafeArea = function (f62_arg0, f62_arg1)
	f62_arg0:UpdateSafeArea(nil, f62_arg1)
	f62_arg0:registerEventHandler("update_safe_area", f62_arg0.UpdateSafeArea)
end

LUI.UIElement.playBitchinFX = function (f63_arg0, f63_arg1, f63_arg2, f63_arg3)
	f63_arg0:setShaderVector(0, 0, 0, 0, 0)
	f63_arg0:beginAnimation("bitchin", f63_arg1, f63_arg2, f63_arg3)
	f63_arg0:setShaderVector(0, 1, 0, 0, 0)
end

LUI.UIElement.playBitchinFXReverse = function (f64_arg0, f64_arg1, f64_arg2, f64_arg3)
	f64_arg0:setShaderVector(0, 1, 0, 0, 0)
	f64_arg0:beginAnimation("bitchin", f64_arg1, f64_arg2, f64_arg3)
	f64_arg0:setShaderVector(0, 0, 0, 0, 0)
end

LUI.UIElement.setClass = function (f65_arg0, f65_arg1)
	local f65_local0 = getmetatable(f65_arg0)
	local f65_local1 = f65_local0.__newindex
	local f65_local2 = getmetatable(f65_local1)
	if not f65_local2 then
		setmetatable(f65_local1, {
			__index = f65_arg1
		})
	else
		f65_local2.__index = f65_arg1
	end
	local f65_local3 = getmetatable(f65_local1.m_eventHandlers)
	if not f65_local3 then
		setmetatable(f65_local1.m_eventHandlers, {
			__index = f65_arg1.m_eventHandlers
		})
	else
		f65_local3.__index = f65_arg1.m_eventHandlers
	end
end

LUI.UIElement.m_eventHandlers = {
	complete_animation = LUI.UIElement.CompleteAnimationEvent,
	mousemove = LUI.UIElement.MouseMoveEvent,
	mousedown = LUI.UIElement.MouseButtonEvent,
	mouseup = LUI.UIElement.MouseButtonEvent,
	mouseclear = LUI.UIElement.MouseClear,
	gamepad_button = LUI.UIElement.GamepadButton,
	gain_focus = LUI.UIElement.gainFocus,
	lose_focus = LUI.UIElement.loseFocus,
	restore_focus = LUI.UIElement.restoreFocus,
	close = LUI.UIElement.close,
	animate = LUI.UIElement.animate,
	viewport_animation = LUI.UIElement.ViewportAnimation,
	touchpad_move = LUI.UIElement.MouseMoveEvent,
	touchpad_down = LUI.UIElement.MouseButtonEvent,
	touchpad_up = LUI.UIElement.MouseButtonEvent
}
LUI.UIElement.new = function (f66_arg0)
	local f66_local0 = ConstructLUIElement()
	LUI.UIElement.setClass(f66_local0, LUI.UIElement)
	f66_local0:setLayoutCached(false)
	if not f66_arg0 then
		f66_local0:registerAnimationState("default", LUI.UIElement.m_defaultAnimationState)
	else
		f66_local0:registerAnimationState("default", f66_arg0)
	end
	f66_local0:animateToState("default")
	return f66_local0
end

LUI.UIElement.ContainerState = {
	left = 0,
	top = 0,
	right = 0,
	bottom = 0,
	leftAnchor = true,
	topAnchor = true,
	rightAnchor = true,
	bottomAnchor = true
}
LUI.UIContainer.new = function ()
	return LUI.UIElement.new(LUI.UIElement.ContainerState)
end

