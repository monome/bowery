--- boolean logic
-- output logic transfer functions are dynamically selected per channel
-- a state change on any input triggers update of all outputs

-- enumeration of the fnlist. least to most density of transfer
fenum = {'~|','>','<','&','~^','^','~&','<=','>=','|'}

public{f1 = '&' }:options(fenum):action(function() apply() end)
public{f2 = '|' }:options(fenum):action(function() apply() end)
public{f3 = '^' }:options(fenum):action(function() apply() end)
public{f4 = '~^'}:options(fenum):action(function() apply() end)

-- all the dynamic transfer fns between 2 inputs (ordering doesn't matter)
fnlist =
{ ['~|'] = function(a,b) return not (a or b) end
, ['>' ] = function(a,b) return a and not b end
, ['<' ] = function(a,b) return b and not a end
, ['&' ] = function(a,b) return (a and b) end
, ['~^'] = function(a,b) return a==b end
, ['^' ] = function(a,b) return a~=b end
, ['~&'] = function(a,b) return not (a and b) end
, ['<='] = function(a,b) return not (a and not b) end
, ['>='] = function(a,b) return not (b and not a) end
, ['|' ] = function(a,b) return (a or b) end
}

function q(n) return input[n].volts > 1.0 end
function apply()
    print'apply'
    local a, b = q(1), q(2)
    output[1].volts = fnlist[public.f1](a, b) and 5 or 0
    output[2].volts = fnlist[public.f2](a, b) and 5 or 0
    output[3].volts = fnlist[public.f3](a, b) and 5 or 0
    output[4].volts = fnlist[public.f4](a, b) and 5 or 0
end

function init()
    for n=1,2 do
        input[n].mode('change')
        input[n].change = apply -- update all outs on any state change
    end
    apply() -- initialize to current state
end
