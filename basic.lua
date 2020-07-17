--- Basic param sharing test

-- these need to be backed with a metatable
-- and the order of declaration must be maintained (ie. create an indexed table of {k,v} pairs)
params = {}
params.time = 1.0
params.out  = 2.0

function init()
  output[1].action = pulse()
  metro[1].time = params.time -- TODO might be unnecessary after adding 'on_change' functions
  -- basically we want metro[1].time to be 'subscribed' to params.time
  metro[1].event = banger
  metro[1]:start()
end

function banger(c)
  output[1]()

  -- TODO this behaviour should be installed into the params system
  -- eg: params.time.change = function(v) metro[1].time = v end
  if params.time ~= metro[1].time then
    metro[1].time = params.time
  end
end

params.internal = {} -- TODO this is what will become the library
params.internal.discover = function()
  for k,v in pairs(params) do
    if k ~= 'internal' then
      --print(k..'='..v)
      _c.tell('pub',string.format('%q',k),v)
    end
  end
  _c.tell('pub',string.format('%q','_done'))
end
