--!nocheck

local ServerStorage = game:GetService("ServerStorage")

local Enums = require(ServerStorage.Modules.Enums)

--[[
    Create a new event used in battle.

    ---
    ### Event Usage
    Like a `bindable function`, but with a `connectBefore` method that allows you to directly edit arguments passing into the function before it is fired.

    You can also edit the result of the function with `connect` after it is fired.

    ---
    ### Usage
    ```
    event, methodToFireEvent = Battle.new(function(...)
        ...
    end)

    healEvent, heal = BattleEvent.new(function(add_health)
        health += add_health
    ))
    ```
]]
return function<EventFireFunction>(function_: EventFireFunction)
	local self = {}

	self._connectedBefore = {}

	--[[
        Connect to the event's arguments, before it is fired.

        Returns a function that disconnects the connection to the event.

        ### Usage
        To change arguments return a **table** of the keys being the index of what argument to change and the values as the new value.
        ```
        event.connectBefore(function(arg1, arg2)
            local index = 1
            return { [index] = "myNewValue" }
        end)
        ```
        This code will override `arg1` to `"myNewValue"` whenever the event is used.

        Returning `BattleEvent.EventReturn.cancel` will stop the event from firing altogether.
    ]]
	function self.connectBefore(method: EventFireFunction)
		table.insert(self._connectedBefore, method)

		return {
			disconnect = function()
				table.remove(self._connectedBefore, table.find(self._connectedBefore, method))
			end,
		}
	end

	self._connected = {}

	--[[
        Connect to the event's result, after it is fired.

        Returns a function that disconnects the connection to the event.

        ### Usage
        To change result, return something truthy (not false)
        ```
        event.connectBefore(function(resultOfFiredFunction, arg1, arg2)
            return { [1] = 5 }
        end)
        ```
        This code will override arg1 to 5 whenever the event is used.
    ]]
	function self.connect(method: EventFireFunction)
		table.insert(self._connected, method)
		return {
			disconnect = function()
				table.remove(self._connected, table.find(self._connected, method))
			end,
		}
	end

	local function fire(...)
		local args = { ... }

		for _, method in self._connectedBefore do
			local new_args = method(unpack(args))

			if new_args == nil then
				continue
			end

			if new_args == Enums.BattleEventReturn.Cancel then
				return
			end

			for i, value in new_args do
				args[i] = value
			end
		end
		local result = function_(unpack(args))

		for _, method in self._connected do
			local new_result
			if result then
				new_result = method(result, unpack(args))
			else
				new_result = method(unpack(args))
			end
			if new_result then
				result = new_result
			end
		end
		return result
	end

	return self, fire :: EventFireFunction
end
