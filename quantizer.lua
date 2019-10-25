--- quantizer example
-- s wolk 2019.10.15
-- in1: clock
-- in2: voltage to quantize
-- out1: in2 quantized to scale1 on clock pulses
-- out2: in2 quantized to scale2 on clock pulses
-- out3: in2 quantized to scale3 continuously
-- out4: trigger pulses when out3 changes

-- nb: scales should be written as semitones (cents optional) in ascending order
octaves = {0,12}
major = {0,2,4,5,7,9,11,12}
harmonicMinor = {0,2,3,5,7,8,10,12}
dorian = {0,2,3,5,7,9,10,12}
majorTriad = {0,4,7,12}
dominant7th = {0,4,7,10,12}

-- try re-assigning scale1/2/3 to change your quantizer!
scale1 = major
scale2 = harmonicMinor
scale3 = majorTriad


function quantize(volts,scale) 
	local octave = math.floor(volts)
	local interval = volts - octave
	local semitones = interval / 12
	local degree = 1
	while degree < #scale and semitones > scale[degree+1]  do
		degree = degree + 1
	end
	local above = scale[degree+1] - semitones
	local below = semitones - scale[degree]
	if below > above then 
		degree = degree +1
	end
	local note = scale[degree]
	note = note + 12*octave
	return note
end

-- sample & hold handler; sets out1 & out2
input[1].change = function(state)
	-- sample input[2]
	local v = input[2].volts
	
	-- quantize voltage to scale
	local note1 = quantize(v,scale1)
	local note2 = quantize(v,scale2)
		
	-- convert semitones to volts and update out1 & out2
	output[1].volts = n2v(note1) 
	output[2].volts = n2v(note2)
end

-- streaming handler; sets out3 & out4
input[2].stream = function(volts)
	-- find current quantized note
	local newNote = quantize(volts,scale3)
	
	-- check if quantized voltage is equal to current voltage
	if newNote / 12.0 ~= output[3].volts then
		-- if not, update out3 to new voltage and pulse out4
		output[3].volts = n2v(newNote)
		output[4](pulse(0.01,8))
	end
end


function init()
	input[1].mode('change',1,0.1,'rising')
	input[2].mode('stream',0.005)
	print('quantizer loaded')
end

