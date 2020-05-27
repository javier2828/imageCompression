function signalQuant = signedQuantizer(signal, bits)
    maxLevel= 2^(bits-1) -1;
    minLevel= -2^(bits-1);
    level = 2^bits;
    stepSize = (maxLevel-minLevel)/level;
    k = 1; exit = 0;
    if (signal < maxLevel)
        while signal >= minLevel+stepSize*k
            k = k+1;
        end
    else
        exit = 1;
    end
    if (exit == 0)
        signalQuant = minLevel+stepSize*(k-1) + stepSize/2;
    else
        signalQuant = maxLevel;
    end
end