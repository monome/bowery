-- convert just ratios to volts-per-octave
-- single values return single values
-- table of values is manipulated in place
-- second value is an offset for transposing by a just ratio
function just_volts( f, off )
    local t = type(f)
    local ld2 = 1/math.log(2)
    if off then
        off = math.log(off) * ld2
    else
        off = 0
    end
    if t == 'number' then
        return math.log(f) * ld2 + off
    elseif t == 'table' then
        local vs = {}
        for k,v in ipairs(f) do
            vs[k] = math.log(v) * ld2 + off
        end
        return vs
    end
end


