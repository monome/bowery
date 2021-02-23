-- START MODULE

--- params library
--- FIXME should this be named Public as you are declaring vars as publicly accessible on the network
Params = {} -- this 
Params._names = {} -- keys are names, linked to indexed _params
Params._params = {} -- storage of params
-- _params must contain: 'name', value
-- _params may contain: min, max, 'type', action, default

Params.add = function(name, default, typ)
    local ix = Params._names[name]
    if not ix then
        ix = #(Params._params) + 1
        Params._names[name] = ix
    end
    Params._params[ix] = { k=name, v=default or 0 }
    if typ then -- type restriction applies
        local p = Params._params[ix] -- alias
        -- TODO add 'action' handling - type match on function
        local t = type(typ)
        if t == 'string' then
            if typ == 'integer' then p.type = 'i'
            elseif typ == 'exp' then p.type = 'e'
            else print 'unknown type restriction 1'
            end
        elseif t == 'table' then
            local len = #typ
            if len == 1 then -- assume 'integer' or 'exp'
                p.type = typ[1]
            elseif len == 2 then -- assume min, max
                p.min = typ[1]
                p.max = typ[2]
            elseif len == 3 then -- min, max, type
                p.min = typ[1]
                p.max = typ[2]
                p.type = typ[3]
            else print 'unknown type restriction 2'
            end
        else print 'unknown type restriction 3'
        end
    end
end


Params.clear = function()
  Params._names = {}
  Params._params = {}
end

Params.discover = function()
  -- FIXME send type data in a table
  for _,p in ipairs(Params._params) do
      if type(p.v) == 'string' then
        _c.tell('pub',string.format('%q',p.k),string.format('%q',p.v))
      else
        _c.tell('pub',string.format('%q',p.k),p.v)
      end
      
  end
  _c.tell('pub',string.format('%q','_end'))
end

--- METAMETHODS
-- setters
Params.__newindex = function(self, ix, val)
    local kix = Params._names[ix]
    if kix then
        Params._params[kix].v = val
        -- TODO update remote here
        -- TODO suppress update if change comes from remote (will work, but redundant)
    end
end

-- getters
Params.__index = function(self, ix)
    local kix = Params._names[ix]
    if kix then
        return Params._params[kix].v
    end
end

setmetatable(Params, Params)

-- return Params

-- END MODULE
public = Params


--- basic sample & hold
-- in1: sampling clock
-- out1: random sample, updated on each clock pulse

-- public variables
-- set with params.name = val
-- get with n = params.name
-- public.add('range', 3, {0,10})
public.add('range', 3)
public.add('time', 1.1)
public.add('str', 'hello')

function init()
  input[1].mode('change',1,0.1,'rising')
end

input[1].change = function()
  output[1].volts = (math.random() - 0.5) * public.range
end
