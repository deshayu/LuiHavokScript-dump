LUI.UIStreamedImage = InheritFrom(LUI.UIElement)
LUI.UIStreamedImage.ImageReady = function (f1_arg0, f1_arg1)
	f1_arg1.image = f1_arg0
	f1_arg0:dispatchEventToChildren(f1_arg1)
	f1_arg0:dispatchEventToParent(f1_arg1)
end

local f0_local0 = function (f2_arg0, f2_arg1)
	f2_arg0.spinner:close()
	LUI.UIStreamedImage.ImageReady(f2_arg0, f2_arg1)
end

LUI.UIStreamedImage.new = function (f3_arg0, f3_arg1, f3_arg2, f3_arg3)
	local Widget = LUI.UIElement.new(f3_arg0)
	if f3_arg1 == nil then
		f3_arg1 = 0
	end
	Widget:setClass(LUI.UIStreamedImage)
	Widget:setupUIStreamedImage(f3_arg1)
	if f3_arg2 then
		local f3_local1 = 64
		if f3_arg3 then
			f3_local1 = f3_arg3
		end
		Widget.spinner = LUI.UIImage.new()
		Widget.spinner:setLeftRight(false, false, -f3_local1 / 2, f3_local1 / 2)
		Widget.spinner:setTopBottom(false, false, -f3_local1 / 2, f3_local1 / 2)
		Widget.spinner:setImage(RegisterMaterial("lui_loader"))
		Widget:addElement(Widget.spinner)
		Widget:registerEventHandler("streamed_image_ready", f0_local0)
	else
		Widget:registerEventHandler("streamed_image_ready", LUI.UIStreamedImage.ImageReady)
	end
	return Widget
end

LUI.UIStreamedImage.id = "LUIStreamedImage"
