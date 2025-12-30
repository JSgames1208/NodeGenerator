local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

--[[
	useLinear(initial, { speed = number })

	A simplified alternative to useSpring:
	- Moves at roughly constant perceived speed
	- Does NOT ease out or smooth near the end
	- Finishes around 1/speed seconds after setGoal
]]
local function useLinear(initialValue: number | UDim2, config: { speed: number }?)
	local speed = (config and config.speed) or 8
	local value, setValue = React.useState(initialValue)
	local goal, setGoal = React.useState(initialValue)

	local valueRef = React.useRef(value)
	local goalRef = React.useRef(goal)
	local connectionRef = React.useRef(nil)
	local callbacksRef = React.useRef({})
	local completedRef = React.useRef(false)

	React.useEffect(function()
		valueRef.current = value
	end, { value })

	React.useEffect(function()
		goalRef.current = goal
	end, { goal })

	React.useEffect(function()
		local progress = 0
		local lastGoal = goalRef.current
		local startValue = valueRef.current

		local function step(dt)
			-- reset interpolation if goal changes
			if goalRef.current ~= lastGoal then
				lastGoal = goalRef.current
				startValue = valueRef.current
				progress = 0
			end

			progress += dt * speed
			local alpha = math.clamp(progress, 0, 1)

			local newValue
			if typeof(startValue) == "number" and typeof(lastGoal) == "number" then
				newValue = startValue + (lastGoal - startValue) * alpha
			elseif typeof(startValue) == "UDim2" and typeof(lastGoal) == "UDim2" then
				local function lerp(a, b)
					return a + (b - a) * alpha
				end
				newValue = UDim2.new(
					lerp(startValue.X.Scale, lastGoal.X.Scale),
					lerp(startValue.X.Offset, lastGoal.X.Offset),
					lerp(startValue.Y.Scale, lastGoal.Y.Scale),
					lerp(startValue.Y.Offset, lastGoal.Y.Offset)
				)
			else
				newValue = lastGoal
				progress = 1
			end

			if newValue ~= valueRef.current then
				valueRef.current = newValue
				setValue(newValue)
			end

			if progress >= 1 then
				progress = 1
				completedRef.current = true
				for _, fn in ipairs(callbacksRef.current) do
					fn()
				end
				callbacksRef.current = {}
			else
				completedRef.current = false
			end
		end

		local conn = RunService.Heartbeat:Connect(step)
		connectionRef.current = conn

		return function()
			if connectionRef.current then
				connectionRef.current:Disconnect()
				connectionRef.current = nil
			end
		end
	end, { goal, speed })

	local function onComplete(fn)
		table.insert(callbacksRef.current, fn)
	end

	local function snap()
		if connectionRef.current then
			connectionRef.current:Disconnect()
			connectionRef.current = nil
		end
		valueRef.current = goalRef.current
		setValue(goalRef.current)
		completedRef.current = true
		for _, fn in ipairs(callbacksRef.current) do
			fn()
		end
		callbacksRef.current = {}
	end

	return {
		binding = value,
		setGoal = setGoal,
		onComplete = onComplete,
		snap = snap,
	}
end

return useLinear
