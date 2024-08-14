local ButtonAnim = {}

function ButtonAnim.addClickAnim(button: ImageButton, folder, sizeMultiplier, originalSize)
	local multipliedSize = UDim2.new(
		button.Size.X.Scale * sizeMultiplier,
		0,
		button.Size.Y.Scale * sizeMultiplier,
		0
	)
	
	button.MouseButton1Click:Connect(function()
		
		button:TweenSize(
			multipliedSize,
			Enum.EasingDirection.In,
			Enum.EasingStyle.Quart,
			0.1,
			true
		)
		task.wait(0.1)

	end)
	
	button.MouseEnter:Connect(function()
		for i, v in pairs(folder:GetChildren()) do
			if v:IsA("TextButton") then 
				v.ZIndex = 1
			end
		end

		button.ZIndex = 2
		
		button:TweenSize(
			multipliedSize,
			Enum.EasingDirection.In,
			Enum.EasingStyle.Quart,
			0.25,
			true
		)

	end)

	button.MouseLeave:Connect(function()
		button:TweenSize(
			originalSize,
			Enum.EasingDirection.In,
			Enum.EasingStyle.Quart,
			0.5,
			true
		)
	end)
end

return ButtonAnim