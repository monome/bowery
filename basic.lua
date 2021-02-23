--- basic.lua
-- START MODULE

--- params library -- RENAME PUBLIC
Params = {} -- this 
Params._names = {} -- keys are names, linked to indexed _params
Params._params = {} -- storage of params

Params.add = function(name, default, typ, action)
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
            p.type = typ
        elseif t == 'table' then
            local len = #typ
            if type(typ[1]) == 'string' then
                if len == 1 then
                    p.type = typ[1]
                else -- enum type
                    p.type = 'enum'
                    p.enum = {}
                    for i=1,len do
                        p.enum[i] = typ[i]
                    end
                end
            elseif len == 2 then -- assume min, max
                p.min = typ[1]
                p.max = typ[2]
            elseif len == 3 then -- min, max, type
                p.min = typ[1]
                p.max = typ[2]
                p.type = typ[3]
            else print 'unknown type restriction 2'
            end
        elseif t == 'function' then
            p.action = typ
        else print 'unknown type restriction 3'
        end
        
        if action then p.action = action end -- types & action
    end
end


Params.clear = function()
  Params._names = {}
  Params._params = {}
end


Params.discover = function()
  -- FIXME send type data in a table
  for _,p in ipairs(Params._params) do
      -- name
      local s = string.format('pub(%q,',p.k)
      -- value
      if type(p.v) == 'string' then
        s = string.format('%s%q,{',s,p.v)
      else
        s = s .. p.v .. ',{'
      end
      -- type
      if p.enum then
        s = string.format('%s%q,', s, 'enum')
        for k,v in ipairs(p.enum) do
          s = string.format('%s%q,', s, v)
        end
      else
        if p.min then s = string.format('%s%g,', s, p.min) end
        if p.max then s = string.format('%s%g,', s, p.max) end
        if p.type then s = string.format('%s%q', s, p.type) end
      end
      s = s .. '})'
      print('^^'..s) -- send to remote
  end
  _c.tell('pub',string.format('%q','_end'))
end

-- Only called by remote device.
Params.update = function(k,v)
    local kix = Params._names[k]
    if kix then
        local p = Params._params[kix]
        p.v = v
        if p.action then p.action(v) end
    end
end

--- METAMETHODS
-- setters
Params.__newindex = function(self, ix, val)
    local kix = Params._names[ix]
    if kix then
        local p = Params._params[kix]
        if p.min then -- clamp
          val = (val > p.max) and p.max or val
          val = (val < p.min) and p.min or val
        end
        p.v = val -- local storage
        if type(p.v) == 'string' then
          _c.tell('pupdate',string.format('%q,%q',p.k,p.v))
        else
          _c.tell('pupdate',string.format('%q',p.k),p.v)
        end
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
public.add('range', 3, {0,10})
public.add('time', 1.1, {0.1,10}, function(v) metro[1].time = v end)
-- public.add('scale', 'minor', {'minor','major','penta'})
public.add('volts', 0, {-5,5,'slider'})

function init()
  input[1].change = sh
  input[1].mode('change',1,0.1,'rising')
  metro[1].time = 3
  metro[1].event = sh
  metro[1]:start()
end

function sh()
  public.volts = (math.random() - 0.5) * public.range
  output[1].volts = public.volts
end