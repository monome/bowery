--- basic.lua
--- params library -- RENAME PUBLIC
Params = {} -- FIXME make this local
Params._names = {} -- keys are names, linked to indexed _params
Params._params = {} -- storage of params

Params.Pubtable = {} -- metamethods for methods on a tables in the public variable space
Params.Pubtable.__newindex = function(self, ix, val)
  print "pubtable newindex"
end
Params.Pubtable.__index = function(self, ix) -- getters
    if ix == 'index' then
        return function(n)
            if not n then print "no index provided"; return end
            self._index = ((n-1) % #self) + 1 -- wrap to table size
            return self[self._index]
          end
    elseif ix == 'step' then
        return function(n)
            self._step = n or self._step
            self._index = (((self._index + self._step)-1) % #self) + 1 -- wrap to table size
            return self[self._index]
          end
    end
end
setmetatable(Params.Pubtable, Params.Pubtable)

Params.add = function(name, default, typ, action)
    local ix = Params._names[name]
    if not ix then
        ix = #(Params._params) + 1
        Params._names[name] = ix
    end
    if type(default) == 'table' then
      -- TODO this should be Pubtable.new()
        print("discover#: "..#Params._params)
        Params._params[ix] = default -- WARNING overwrite above, so table is flat
          print("discover#: "..#Params._params)
        local p = Params._params[ix] -- alias
        p.k = name
        p.v = p -- self-reference
        p._index = 0 -- invalid index
        p._step = 1 -- default step motion
        setmetatable(p, Params.Pubtable) -- overload the parameter with table semantics
                  print("discover#: "..#Params._params)
    else
        Params._params[ix] = { k=name, v=default or 0 }
    end
    -- FIXME handle type restriction on table type
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

-- FIXME refactor this please!
Params.discover = function()
  for _,p in ipairs(Params._params) do
      -- name
      local s = string.format('pub(%q,',p.k)
      -- value
      local tv = type(p.v)
      local def = p.v
      if tv == 'string' then
        def = string.format('%q',p.v)
      elseif tv == 'table' then
        -- { vals }
        def = '{'
        for k,v in ipairs(p.v) do
          def = def .. v .. ','
        end
        -- TODO append .index=p._index
        def = def .. 'index=' .. p._index .. '}'
      end
      s = s .. def .. ',{'
      
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
      print(s)
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

-- public variables
public.add('time', 1.1, {0.1,10}, function(v) metro[1].time = v end)
public.add('seq', {1,2,3,4}) -- create a table set
-- public.add('seq', {1,2,3,4,5,6,7,8}) -- create a table set
public.seq.index(1) -- make that set an indexed table
-- TODO change syntax to: public.seq[i]

function init()
  metro[1].time = 1
  metro[1].event = sh
  metro[1]:start()
end

function sh()
  -- public.seq.step() -- advance sequence on each step
end

public.time = 3.2