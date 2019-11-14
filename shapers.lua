function init()
  -- n-Tone-Equal-Temperament
  nTET_shaper = shaper.init{  mode      = 'tones', -- n-tone equal temperament
                              cycle     = 12, -- number of tones per fold (n); 'octave' also works
                              scale     = {0,2,4,5,7.2,9,10}, -- list of tones; n-TET can also accept microtonal info; 'lut' also works as key
                              weighting = 'global', -- weights will be normalized to 1 and then used to divide octave (default is 'neighbor')
                              weights   = {1,1,1,1,10,1,1} -- the 5th will be much more likley.
                            }

  -- maybe you want to convert a v/oct signal to buchla
  -- period table sets the foldover point for input and output signals
  -- as opposed to cycle, which sets foldover point for lookup table
  nTET_shaper.period.input = 1 -- this is actually the default, but just showing for clarity
  nTET_shaper.period.output = 1.2
  print('n-TET converts 3.27 to :' .. nTET_shaper:process(3.3))

  -- cosine shaper
  cosine_shaper = shaper.init{  mode = 'interp', -- interpolate between values in the lookup
                                lut = 'cosine', -- choose lookup table from options, or directly set your own ('scale' also works as key)
                                period = 5 -- set the input and output range to 0-5
                              }
  input[1].stream = function(cv) output[1].volts = cosine_shaper:process(cv) end
  input[1].mode('stream',0.05)

  -- just intonation shaper
  ji_shaper = shaper.init{  mode = 'ji', -- Just Intonation
                            scale = {1,1.25,1.33,1.5,1.67,1.75} -- list of ratios
                          }

  -- window-function executor
  function_shaper = Shaper.init{  mode = 'functions', -- call functions
                                  lut = {output[1],output[2],output[3],output[4]}
                                }
  for i = 1,4 do
    output[i].action = ar(0.1,i) -- simple envelopes for each channel
  end
  function_shaper:process(0.1) -- ths should fire off output[1]'s asl

  -- markov models!
  markov_weights = {
    {0,0,1,2},
    {0,0,2,1},
    {1,4,1,2},
    {3,1,1,2}
  }

  markov_actions = {}

  for i = 1,4 do
    markov_actions[i] = function()
      print("Action "..i)
      output[i]() -- fire off the new ASL
      markov_shaper.weights = markov_weights[i] -- set new transition probabilities
    end
  end

  markov_shaper = shaper.init{  mode = 'functions',
                                weighting = 'global',
                                lut = markovActions
                              }
  input[2].change = function() markov_shaper:process(math.random()) end
  input[2].mode('change',1,0.1,'rising') -- use input 2 to advance markov model one stage
end
