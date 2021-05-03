---  euclidean rhythms
-- sam wolk 2019.10.21
-- Create 4 euclidean rhythm generators
-- in1: clock
-- in2: reset
-- outs: euclidean rhythms

-- ER parameters for each channel.
lengths = {16,16,16,16}
fills = {4,5,9,12}
offsets = {0,0,0,0}

-- Non-User Variables
locations = {-1,-1,-1,-1} --

-- ER function adapted from  https://gist.github.com/vrld/b1e6f4cce7a8d15e00e4
-- k > Euclidean Fill
-- n > Euclidean Length
-- s > current step (0-indexed)
function er(k,n,s)
    local r = {}
    for i = 1,n do
        r[i] = {i <= k}
    end
    local function cat(i,k)
        for _,v in ipairs(r[k]) do
            r[i][#r[i]+1] = v
        end
        r[k] = nil
    end
    
    while #r > k do
        for i = 1,math.min(k, #r-k) do
            cat(i, #r)
        end
    end

    while #r > 1 do
       cat(#r-1, #r) 
    end

    return r[1][s+1]
end

-- Use a trigger to advance ER counters and activate ASLs on hits
input[1].change = function(state) 
	for i=1,4 do
		--- increment counters
		locations[i] = ((locations[i]+1) % lengths[i])
		
		-- get current location
		local index = ((locations[i]+offsets[i]) % lengths[i])
		
		-- fire asl if there is a hit
		if er(fills[i],lengths[i],index) then
			output[i]()
		end
	end
end

-- Use a trigger to reset locations
input[2].change = function(state)
	for i=1,4 do
		locations[i]=-1
	end
end

function init()
	input[1].mode('change',1,0.1,'rising')
	input[2].mode('change',1,0.1,'rising')

	for i=1,4 do 
		output[i].action = pulse(0.02,8)
	end
end
