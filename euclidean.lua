--- 4 euclidean rhythm generators
-- sam wolk 2019.10.21
-- in1: clock
-- in2: reset
-- outs: euclidean rhythms

-- ER parameters for each channel.
public.add('lengths', {16,16,16,16})
public.add('fills', {4,5,9,12})
public.add('offsets', {0,0,0,0})

-- private state
locations = {-1,-1,-1,-1}

-- ER function adapted from  https://gist.github.com/vrld/b1e6f4cce7a8d15e00e4
function er(fill, length, ix)
    local r = {}
    -- place all filled slots at the start of the rhythm
    for i=1,length do
        r[i] = {i <= fill}
    end
    -- each element is now a table with either true or false

    local function cat(t, dst, src)
        -- copy all elements of t[src] to the end of t[dst] and remove t[src]
        for _,v in ipairs(t[src]) do
            table.insert(t[dst], v)
        end
        t[src] = nil
    end

    -- interleave the empty slots until they are spread out evenly
    while #r > fill do
        for i=1,math.min(fill, #r-fill) do
            cat(r, i, #r)
        end
    end

    -- fold all lists down to a single one
    while #r > 1 do
       cat(r, #r-1, #r) 
    end

    -- return boolean (and discard table)
    return r[1][ix]
end

-- Use a trigger to advance ER counters and activate ASLs on hits
input[1].change = function(state) 
	for i=1,4 do
		--- increment counters
		locations[i] = (locations[i] + 1) % public.lengths[i]
		
		-- get current location
		local index = (locations[i] + public.offsets[i]) % public.lengths[i]

		-- create pulse if there is an event
		if er(public.fills[i], public.lengths[i], index+1) then
			output[i]()
		end
	end
end

input[2].change = function(state)
	for i=1,4 do
		locations[i] = -1 -- reset locations
	end
end

function init()
	input[1].mode('change',1,0.1,'rising')
	input[2].mode('change',1,0.1,'rising')

	for i=1,4 do 
		output[i].action = pulse(0.02,8)
	end
end
