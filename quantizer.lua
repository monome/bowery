--- quantizer
-- sam wolk 2019.10.15
-- updated by whimsicalraps 2021
-- in1: clock
-- in2: voltage to quantize
-- out1: in2 quantized to scale1 on clock pulses
-- out2: in2 quantized to scale2 on clock pulses
-- out3: in2 quantized to scale3 continuously
-- out4: trigger pulses when out3 changes

snum = {'octave','chroma','major','harMin','dorian','majTri','dom7th','wholet'}

public.add('scale1','major',snum
  , function(s) output[1].scale = scales[s] end)
public.add('scale2','harMin',snum
  , function(s) output[2].scale = scales[s] end)
public.add('scale3','majTri',snum
  , function(s) input[2].mode('scale',scales[s]) end)

scales =
{ octave = {0}
, chroma = {} -- this is a shortcut
, major  = {0,2,4,5,7,9,11}
, harMin = {0,2,3,5,7,8,10}
, dorian = {0,2,3,5,7,9,10}
, majTri = {0,4,7}
, dom7th = {0,4,7,10}
, wholet = {0,2,4,6,8,10}
}

-- update clocked outputs
input[1].change = function(state)
  output[1].volts = input[2].volts
  output[2].volts = input[2].volts
end

-- update continuous quantizer
input[2].scale = function(s)
  output[3].volts = s.volts
  output[4]()
end

function init()
  input[1].mode('change',1,0.1,'rising')
  input[2].mode('scale',scales[public.scale3])
  output[1].scale(scales[public.scale1])
  output[2].scale(scales[public.scale2])
  output[4].action = pulse(0.01, 8)
end

