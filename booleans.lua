--- boolean logic
-- output logic transfer functions are dynamically selected per channel
-- a state change on any input triggers update of all outputs

-- enumeration of the fnlist. least to most density of transfer
fenum = {'~|','>','<','&','~^','^','~&','<=','>=','|'}

public.add('f1','&',fenum)
public.add('f2','|',fenum)
public.add('f3','^',fenum)
public.add('f4','~^',fenum)

-- all the dynamic transfer fns between 2 inputs (ordering doesn't matter)
fnlist =
{ '~|' = function(a,b) return not (a or b) end
, '>'  = function(a,b) return a>b end
, '<'  = function(a,b) return a<b end
, '&'  = function(a,b) return (a and b) end
, '~^' = function(a,b) return a==b end
, '^'  = function(a,b) return a~=b end
, '~&' = function(a,b) return not (a and b) end
, '<=' = function(a,b) return a<=b end
, '>=' = function(a,b) return a>=b end
, '|'  = function(a,b) return (a or b) end
}

function q(n) return input[n].volts > 1.0 end
function apply()
    local a, b = q(1), q(2)
    output[1].volts = fnlist[public.f1](a, b)
    output[2].volts = fnlist[public.f2](a, b)
    output[3].volts = fnlist[public.f3](a, b)
    output[4].volts = fnlist[public.f4](a, b)
end

function init()
    for n=1,2 do
        input[n].mode('change')
        input[n].change = apply -- update all outs on any state change
    end
    apply() -- initialize to current state
end
