local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

local function useSpring(initialGoal: number | UDim2, config: { speed: number }?)
	local speed = (config and config.speed) or 12.5
	local value, setValue = React.useState(initialGoal)
	local goal, setGoal = React.useState(initialGoal)

	local callbacksRef = React.useRef({})
	local completedRef = React.useRef(false)

	-- Refs to keep the latest values available to the heartbeat and snap
	local valueRef = React.useRef(value)
	local goalRef = React.useRef(goal)
	local connectionRef = React.useRef(nil)

	React.useEffect(function()
		valueRef.current = value
	end, { value })

	React.useEffect(function()
		goalRef.current = goal
	end, { goal })

	-- Heartbeat spring update (uses refs so the connection can be long-lived)
	React.useEffect(function()
		local connection = RunService.Heartbeat:Connect(function(dt)
			local curValue = valueRef.current
			local curGoal = goalRef.current
			local newValue = curValue
			local done = false

			if typeof(curValue) == "number" and typeof(curGoal) == "number" then
				if math.abs(curValue - curGoal) < 0.001 then
					newValue = curGoal
					done = true
				else
					local factor = math.clamp(dt * speed, 0, 1)
					newValue = curValue + (curGoal - curValue) * factor
				end
			elseif typeof(curValue) == "UDim2" and typeof(curGoal) == "UDim2" then
				local dxScale = curGoal.X.Scale - curValue.X.Scale
				local dyScale = curGoal.Y.Scale - curValue.Y.Scale
				local dxOffset = curGoal.X.Offset - curValue.X.Offset
				local dyOffset = curGoal.Y.Offset - curValue.Y.Offset

				local factor = math.clamp(dt * speed, 0, 1)
				local newXScale = curValue.X.Scale + dxScale * factor
				local newYScale = curValue.Y.Scale + dyScale * factor
				local newXOffset = curValue.X.Offset + dxOffset * factor
				local newYOffset = curValue.Y.Offset + dyOffset * factor

				newValue = UDim2.new(newXScale, newXOffset, newYScale, newYOffset)

				done = math.abs(dxScale) < 0.001
					and math.abs(dyScale) < 0.001
					and math.abs(dxOffset) < 0.5
					and math.abs(dyOffset) < 0.5

				if done then
					newValue = curGoal
				end
			else
				-- fallback: different types, snap
				newValue = curGoal
				done = true
			end

			-- only update if changed (reduces needless setState)
			if newValue ~= curValue then
				valueRef.current = newValue
				setValue(newValue)
			end

			-- handle callbacks
			if done and not completedRef.current then
				completedRef.current = true
				for _, fn in ipairs(callbacksRef.current) do
					fn()
				end
				callbacksRef.current = {}
			elseif not done then
				completedRef.current = false
			end
		end)

		-- expose the connection so snap() can disconnect it immediately
		connectionRef.current = connection

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

	-- snap immediately to goal AND stop the heartbeat so it won't overwrite the snap
	local function snap()
		-- disconnect any running heartbeat connection immediately
		if connectionRef.current then
			connectionRef.current:Disconnect()
			connectionRef.current = nil
		end

		-- update ref + state instantly
		valueRef.current = goalRef.current
		setValue(goalRef.current)

		-- mark completed and fire callbacks
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

return useSpring
