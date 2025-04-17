--- simple dual quantizer
-- oootini 27082020
-- negative input values are inverted. use LFOs to paint melodies
-- in1, in2: voltage to quantize
-- quantized notes on outs 1 and 3, with a trigger on outs 2 and 4 for every new note

function init()
	-- quantize based on a harmonic minor scale
	input[1].mode( 'scale', {0,2,3,5,7,8,10,12} )
	-- quantize based on a major triad scale
	input[2].mode( 'scale', {0,4,7,12} )
	print('dual quantizer loaded')
end

input[1].scale = function( note )
	-- invert negative voltages, eg negative phase of LFO
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[1].volts = note.volts
	-- trigger when the input moves to a new note
	output[2](pulse(0.01,8))
end

input[2].scale = function( note )
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[3].volts = note.volts
	output[4](pulse(0.01,8))
end