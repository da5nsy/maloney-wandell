This is a Matlab/Octave implementation of Maloney & Wandell's colour constancy algorithm.

Edited by Danny Garside 2019

Comments:
1. I am confused because, from my understanding, this should reconstruct the data perfectly, and it instead only does a moderately OK job.
2. I have updated this script to use biologically plausible data (from [PsychToolbox](https://github.com/Psychtoolbox-3/Psychtoolbox-3)). This makes little difference, apart from meaning that the basis functions are the same each time, and so the results look similar each time.

--------

Copyright 2015 Han Gong <gong@fedoraproject.org>, University of East Anglia

Copyright 2011 Michael Harris <michael.harris@uea.ac.uk>, University of East Anglia

Code: see Demo.m for test.

References:
    L.T. Maloney and B.A. Wandell, "Color Constancy: A Method for Recovering Surface
    Spectral Reflectance", JOSA A, vol.3, no.1, pp.29-33, 1986. 

Results:

![Image of Entropy](http://cs.bath.ac.uk/~hg299/cons_curve.png)
![Image of Output](http://cs.bath.ac.uk/~hg299/cons_vis.png)
