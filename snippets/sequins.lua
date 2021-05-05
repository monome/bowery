--- sequencing with sequins
-- in1: clock input
-- out1: next note

-- first we make a table representing the chromatic scale as semitones
chrom_scale = {0,1,2,3,4,5,6,7,8,9,10,11}

-- make a new sequins from chrom_scale by passing it as the argument to the 'sequins' function
-- this makes a copy of chrom_scale, which can be 'called' like a function, to get a new note
chrom_sequins = sequins(chrom_scale)

-- by default chrom_sequins() would generate a chromatic scale, moving up by one note at a time
-- we can change this default behaviour by applying the 'step' method to the sequins
-- here :step(7) means each new value will move forward by 7 elements, resulting in a musical 'fifth'
-- when the selection goes out of range, it will wrap around
cycle_of_fifths = chrom_sequins:step(7)

-- next_note will be called on every clock pulse at input1
function next_note()
    -- get the next note from the cycle_of_fifths sequins, and store it in 'n'
    n = cycle_of_fifths()

    -- because chrom_scale above is written in semitones, we must convert to volts
    -- divide-by-12 will convert semitones to volts, as there are 12 semitones in 1 octave (aka 1 volt)
    n = n / 12

    -- set output1's voltage to our calculated value 'n'
    output[1].volts = n
end

function init()
    input[1]{mode = 'change', direction = 'rising'}
    input[1].change = next_note
end



--- REPL interaction
-- interesting things happen when sequencing by steps other than fifths
-- cycle_of_fifths:step(5) -- step by fourths (moving backwards around the cycle)
-- cycle_of_fifths:step(4) -- step by major thirds (augmented triads)
-- cycle_of_fifths:step(3) -- step by minor thirds (diminished triads)



--- simplified form
-- it is idiomatic to alias 'sequins' to the letter 's' for more concise scripts
s = sequins
-- wrap the chromatic scale in a sequins directly, and set it's step to 7
cycle = s{0,1,2,3,4,5,6,7,8,9,10,11}:step(7)
function init()
    input[1]{mode = 'change', direction = 'rising'}
    input[1].change = function() output[1].volts = cycle()/12 end
end
