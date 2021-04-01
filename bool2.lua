--- boolean logic
-- output logic transfer functions are dynamically selected per channel
-- a state change on any input triggers update of all outputs

-- all the dynamic transfer fns between 2 inputs
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
-- explicit list to enforce ordering. least to most density of transfer
fenum = {'~|','>','<','&','~^','^','~&','<=','>=','|'}

public.add('f1','&',fenum)
public.add('f2','|',fenum)
public.add('f3','^',fenum)
public.add('f4','~^',fenum)

function init()
    for n=1,2 do
        input[n].mode('change')
        input[n].change = apply
    end
    apply()
end

function apply()
    local function q(n) return input[n].volts > 1.0 end
    output[1].volts = fnlist[public.f1](q(1), q(2))
    output[2].volts = fnlist[public.f2](q(1), q(2))
    output[3].volts = fnlist[public.f3](q(1), q(2))
    output[4].volts = fnlist[public.f4](q(1), q(2))
end
