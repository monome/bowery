--- test script for all output lib & asl functions
-- patch a cable from output[1] to input[1]

-- t1: check loopback working
-- t2: check .volts action
-- t3: check .slew timing & output.volts getter & .running==true
-- t4: check .slew stopped & .running==false & .asl assigned to same chan
-- t5: check .asl.action = lfo. assignment & method call & timing
-- t6: check lfo chains to next stage
-- t7: check output table call -> asl:action forwarding

LIMIT = 0.1

function near( volt, test )
    if volt < test + LIMIT and volt > test - LIMIT then
        return true
    else return false end
end

function init()
    output[1].volts = 0
delay( t1, 0.1 )
end

function t1()
    if near(input[1].volts, 0) then print't1 ok' else print 't1 fail' end
    output[1].volts = 3
delay( t2, 0.1 )
end

function t2()
    if near(input[1].volts, 3) then print't2 ok' else print 't2 fail' end
    output[1].slew = 0.5
    output[1].volts = 0
delay( t3, 0.25 ) -- half the time
end

function t3()
    if near(input[1].volts, 1.5) then print't3 ok' else print 't3 fail' end
    if near(output[1].volts, 1.5) then print't3` ok' else print 't3` fail' end
    if output[1].running then print't3`` ok' else print 't3`` fail' end
delay( t4, 0.3 ) -- half the time
end

function t4()
    if near(input[1].volts, 0) then print't4 ok' else print 't4 fail' end
    if not output[1].running then print't4` ok' else print 't4` fail' end
    if output[1].asl == asl.list[1] then print't4`` ok' else print 't4`` fail' end
    output[1].slew = 0
    output[1].volts = 0
    output[1].asl.action = lfo(1,5,'linear')
    output[1].asl:action()
delay( t5, 0.51 ) -- little extra
end

function t5()
    if near(input[1].volts, 5) then print't5 ok' else print 't5 fail' end
delay( t6, 0.51 ) -- little extra
end

function t6()
    if near(input[1].volts, -5) then print't6 ok' else print 't6 fail' end
    output[1].volts = 0
    output[1]( lfo(1,5,'linear') )
delay( t7, 0.51 ) -- little extra
end

function t7()
    if near(input[1].volts, 5) then print't7 ok' else print 't7 fail' end
    print'done'
end
