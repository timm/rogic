% nested pacts and faults? huh?
% only one goal!

% nee this magic load string
:- load_files([arrt],[if(changed),silent(true)]).

+source(v1,u0,when(2001,7,27,23,26,59)).
+aka(u0,"Baseline",v1).
+aka(goal,"goal",v1).
+aka(r193,"Mission duration",v1).
+aka(r196,"Mission duration = 5 years",v1).
+aka(r197,"Mission duration = 8 years",v1).
+aka(r4,"Read/write system",v1).
+aka(r227,"# of Read/write cycles",v1).
+aka(r228,"Nominal Recording Time = TBD",v1).
+aka(r229,"Recording Time over temperature = TBD",v1).
+aka(r2077,"# of reads w/o refresh",v1).
+aka(r201,"Storage Time",v1).
+aka(r210,"Storage Time > 2 weeks",v1).
+aka(r276,"Storage Time > 3 months",v1).
+aka(r333,"storage time = 1 day (downlink)",v1).
+aka(r202,"Bit Error Rates",v1).
+aka(r204,"Bit Error Rate < 1E-6",v1).
+aka(r205,"Bit Error Rate < 1E-8",v1).
+aka(r335,"Bit error rate < 1E-12 (boot rom)",v1).
+aka(r203,"Storage Size",v1).
+aka(r223,"Storage size = 1TB",v1).
+aka(r226,"Storage size = 100 TB",v1).
+aka(r336,"Storage size = 25GB",v1).
+aka(r213,"Environmental Reqts",v1).
+aka(r214,"Survival Range to -55C",v1).
+aka(r217,"Operating Temperature Range 0-50C",v1).
+aka(r220,"Delta Launch Vehicle",v1).
+aka(r221,"TID=100 krad",v1).
+aka(r222,"TID=1 Mrad",v1).
+aka(r575,"No latchup",v1).
+aka(r606,"Operate in ambient environment",v1).
+aka(r236,"Readout time",v1).
+aka(r288,"Access time < 10 ms",v1).
+aka(r346,"Access time = 1 us",v1).
+aka(r237,"Power consumption",v1).
+aka(r291,"System Power Consumption < 10 W",v1).
+aka(r294,"CHDS Power Consumption < 5W",v1).
+aka(r348,"Refresh power = 100 mw RMS",v1).
+aka(r238,"Volume",v1).
+aka(r355,"Volume < 2 litres",v1).
+aka(r356,"Volume < 250 cc",v1).
+aka(r239,"Read rates",v1).
+aka(r240,"Read rate = 1Gb/s",v1).
+aka(r241,"Read rate = 100 Mb/s",v1).
+aka(r1965,"No other technology is better",v1).
+aka(f617,"Overall system issues",v1).
+aka(f626,"System power consumption > 10 W",v1).
+aka(f629,"Refresh power > 100 mW rms",v1).
+aka(f627,"Volume > 2 liters",v1).
+aka(f628,"Volume > 250 cc",v1).
+aka(f650,"System has > 10 ms access time",v1).
+aka(f651,"System has > 1 us access time",v1).
+aka(f1607,"Life/Wearout Issues",v1).
+aka(f1966,"Other technologies are better",v1).
+aka(f19,"CHDS",v1).
+aka(f72,"Writing/Reading",v1).
+aka(f117,"Environmental Exposure",v1).
+aka(f119,"Radiation",v1).
+aka(f120,"Neutrons",v1).
+aka(f121,"Protons",v1).
+aka(f122,"Electrons",v1).
+aka(f123,"Cosmic Rays/SEE",v1).
+aka(f124,"Ambient Dynamic Pressure",v1).
+aka(f129,"Launch loads (shk/vib)",v1).
+aka(f130,"Contamination",v1).
+aka(f373,"Small molecules, e.g., hydrogen",v1).
+aka(f374,"Contaminated Solvents/Condensates",v1).
+aka(f376,"Particulates",v1).
+aka(f493,"Corrosives",v1).
+aka(f127,"Evaporation/outgassing",v1).
+aka(f362,"Temperature",v1).
+aka(f570,"Inability to read/write 0 - 50C",v1).
+aka(f571,"Inability to survive -55C",v1).
+aka(f649,"Excessive power densities",v1).
+aka(f363,"Ground exposure",v1).
+aka(f364,"ESD",v1).
+aka(f365,"Humidity",v1).
+aka(f368,"Vibration",v1).
+aka(f377,"EMC",v1).
+aka(f111,"Angular MUX",v1).
+aka(f114,"Cross-talk",v1).
+aka(f115,"Harmonics, etc.",v1).
+aka(f116,"Frequency shifts (AOD)",v1).
+aka(f77,"Material",v1).
+aka(f78,"Degradation",v1).
+aka(f604,"Aging w/ time",v1).
+aka(f605,"Aging w/ Temp",v1).
+aka(f79,"Properties",v1).
+aka(f80,"Improper Doping",v1).
+aka(f81,"Intermediate state levels",v1).
+aka(f401,"Inadequate Sensitivity",v1).
+aka(f403,"Improper crystal orientation",v1).
+aka(f741,"Crystal distortion",v1).
+aka(f82,"Non-uniformity",v1).
+aka(f83,"Cracks / quasi order / planar",v1).
+aka(f86,"Trapping level variations",v1).
+aka(f380,"Adhesives between beam splitter and crystal",v1).
+aka(f382,"Packaging",v1).
+aka(f384,"non-Hermetic",v1).
+aka(f385,"Secondary reflections",v1).
+aka(f100,"Optics Issues",v1).
+aka(f1745,"Current Optics Issues",v1).
+aka(f1746,"Miniature Optics Issues",v1).
+aka(f152,"Spatial MUX (laser)",v1).
+aka(f181,"Wavelength linewidth",v1).
+aka(f182,"Wavelength variations",v1).
+aka(f977,"due to temperature",v1).
+aka(f184,"Wavefront errors",v1).
+aka(f994,"Power variations (temp_",v1).
+aka(f1141,"Insufficient power",v1).
+aka(f155,"Alignment",v1).
+aka(f156,"Initial misalignments",v1).
+aka(f157,"Variations with temperature",v1).
+aka(f158,"Variations with load/stress",v1).
+aka(f159,"Long-term instabilities",v1).
+aka(f126,"Pressure differentials",v1).
+aka(f161,"Jitter (> 30 Hz)",v1).
+aka(f73,"Read unique",v1).
+aka(f438,"Fibre degredation",v1).
+aka(f443,"CCD degredation",v1).
+aka(f446,"Erase while reading",v1).
+aka(f74,"Write unique",v1).
+aka(f160,"Signal conversion errors (SLM)",v1).
+aka(f250,"Background build-up",v1).
+aka(f252,"Scattering",v1).
+aka(f253,"Reflections",v1).
+aka(f445,"Stray light",v1).
+aka(f75,"Storage",v1).
+aka(f176,"LiNbO3:Mn:Fe properties",v1).
+aka(f642,"CHDS System Issues",v1).
+aka(f644,"CHDS Power consumption > 5W",v1).
+aka(f20,"Input/Output Signal Chain",v1).
+aka(f410,"Environmental Exposure",v1).
+aka(f21,"Error correction",v1).
+aka(f22,"Signal Processing",v1).
+aka(f1621,"Nominal Functional Errors",v1).
+aka(f1623,"Wearout/Life Issues",v1).
+aka(f1624,"Robustness Issues",v1).
+aka(p40,"Preventative Measures",v1).
+aka(p44,"Use AOFS",v1).
+aka(p312,"No moving parts",v1).
+aka(p316,"Radn Shielding",v1).
+aka(p317,"Thermal Control",v1).
+aka(p318,"Vibration Isolation",v1).
+aka(p319,"Error correction",v1).
+aka(p404,"Anti-reflection coatings",v1).
+aka(p405,"Polishing",v1).
+aka(p697,"Hermetic packaging",v1).
+aka(p698,"Storage in dry Nitrogen",v1).
+aka(p699,"Storage in air",v1).
+aka(p755,"Use 2 photon method",v1).
+aka(p859,"Use good crystal",v1).
+aka(p924,"Use characterized parts",v1).
+aka(p1059,"Adhesive selection",v1).
+aka(p1062,"Avoid adhesives",v1).
+aka(p1065,"Optics design",v1).
+aka(p1066,"More compact,integrated optics",v1).
+aka(p1069,"Use phase conjugation",v1).
+aka(p1070,"Mounting practices",v1).
+aka(p1142,"Select/make laser",v1).
+aka(p1154,"System Package selection",v1).
+aka(p1156,"Bench vibration isolation",v1).
+aka(p1168,"Select fibers",v1).
+aka(p1171,"Determine flight environment",v1).
+aka(p1477,"ESD protection techniques",v1).
+aka(p1480,"Align with SLM development",v1).
+aka(p1512,"Align w/ CCD development",v1).
+aka(p1567,"Package design for optics",v1).
+aka(p1591,"Avoid Kovar with H2",v1).
+aka(p1657,"Use JPL Design process",v1).
+aka(p1785,"Immunize to ESD",v1).
+aka(p1868,"Build breadboard prototype",v1).
+aka(p1971,"Align with Caltech material work",v1).
+aka(p41,"Analyses",v1).
+aka(p308,"Cross-talk",v1).
+aka(p309,"Alignment Sensitivity",v1).
+aka(p310,"Wavelength Sensitivity",v1).
+aka(p704,"Launch Loads",v1).
+aka(p705,"Venting",v1).
+aka(p706,"System Study",v1).
+aka(p919,"Radiation Effects Analysis",v1).
+aka(p920,"Standard Parts List",v1).
+aka(p1149,"Jitter sensitivity",v1).
+aka(p1409,"Optical Scalability",v1).
+aka(p1587,"Structural Design/Loads Analysis",v1).
+aka(p1645,"Reliability Analyses",v1).
+aka(p1864,"Detailed system block diagram",v1).
+aka(p1865,"Design overall system electronics",v1).
+aka(p1906,"Optical Sensitivity Analyses",v1).
+aka(p2059,"Solvent Compatability Analysis",v1).
+aka(p2074,"Erasure/Decay Assessment",v1).
+aka(p42,"process Controls",v1).
+aka(p248,"Thermal fixing",v1).
+aka(p311,"LiNbO3 processing",v1).
+aka(p43,"Tests",v1).
+aka(p296,"Radiation",v1).
+aka(p304,"SEE Test",v1).
+aka(p305,"Neutron Test",v1).
+aka(p306,"Gamma Test",v1).
+aka(p307,"Proton Test",v1).
+aka(p297,"Thermal",v1).
+aka(p683,"Thermal aging",v1).
+aka(p684,"Thermal vacuum",v1).
+aka(p685,"Thermal atmosphere",v1).
+aka(p686,"Thermal cycling",v1).
+aka(p688,"Thermal survival",v1).
+aka(p298,"Vibration",v1).
+aka(p689,"Sine test",v1).
+aka(p690,"Random vibration",v1).
+aka(p691,"Acoustic vibration",v1).
+aka(p692,"Shock ",v1).
+aka(p299,"Functional",v1).
+aka(p301,"Integrated System",v1).
+aka(p302,"CHDS System test",v1).
+aka(p303,"LiNbO3 characterization",v1).
+aka(p695,"Sensitivity characterization",v1).
+aka(p696,"Lot variability characterization",v1).
+aka(p734,"Optical Properties",v1).
+aka(p735,"Visual observation",v1).
+aka(p736,"x-ray diffraction",v1).
+aka(p737,"Decoration (etching)",v1).
+aka(p738,"Optical verification",v1).
+aka(p739,"Storage Time verification",v1).
+aka(p740,"Determine optical efficiency",v1).
+aka(p761,"Aging test",v1).
+aka(p756,"Read/write cycle test",v1).
+aka(p1099,"Laser characterization",v1).
+aka(p1106,"Optics testing",v1).
+aka(p1420,"Measure presence of AOD harmonic frequencies",v1).
+aka(p2065,"SLM BER characterization",v1).
+aka(p300,"Vacuum exposure",v1).
+aka(p753,"Flight Validation",v1).
+aka(p1482,"Contamination Sensitivity Assessment",v1).
+aka(p1804,"EMC Testing",v1).

+r(goal,1,0,0,v1) :- r4,r193,r201,r202,r203,r213,r236,r237,r238,r239,r1965.
+r(r1965,100,0,0,v1).
+r(r241,10,0,0,v1).
+r(r240,10,0,0,v1).
+r(r239,1,0,0,v1) :- r240,r241.
+r(r356,3,0,0,v1).
+r(r355,10,0,0,v1).
+r(r238,1,0,0,v1) :- r355,r356.
+r(r348,1,0,0,v1).
+r(r294,5,0,0,v1).
+r(r291,10,0,0,v1).
+r(r237,1,0,0,v1) :- r291,r294,r348.
+r(r346,1,0,0,v1).
+r(r288,5,0,0,v1).
+r(r236,1,0,0,v1) :- r288,r346.
+r(r606,3,0,0,v1).
+r(r575,1,0,0,v1).
+r(r222,5,0,0,v1).
+r(r221,10,0,0,v1).
+r(r220,10,0,0,v1).
+r(r217,1,0,0,v1).
+r(r214,1,0,0,v1).
+r(r213,1,0,0,v1) :- r214,r217,r220,r221,r222,r575,r606.
+r(r336,10,0,0,v1).
+r(r226,0.1,0,0,v1).
+r(r223,3,0,0,v1).
+r(r203,1,0,0,v1) :- r223,r226,r336.
+r(r335,1,0,0,v1).
+r(r205,10,0,0,v1).
+r(r204,5,0,0,v1).
+r(r202,1,0,0,v1) :- r204,r205,r335.
+r(r333,1,0,0,v1).
+r(r276,10,0,0,v1).
+r(r210,5,0,0,v1).
+r(r201,1,0,0,v1) :- r210,r276,r333.
+r(r2077,10,0,0,v1).
+r(r229,1,0,0,v1).
+r(r228,1,0,0,v1).
+r(r227,10,0,0,v1).
+r(r4,1,0,0,v1) :- r227,r228,r229,r2077.
+r(r197,3,0,0,v1).
+r(r196,10,0,0,v1).
+r(r193,1,0,0,v1) :- r196,r197.
+f(f1624,0,1,0,v1).
+f(f1623,0,1,0,v1).
+f(f1621,0,1,0,v1).
+f(f22,0,1,0,v1).
+f(f21,0,1,0,v1).
+f(f410,0,1,0,v1).
+f(f20,1,1,0,v1) :- f410,f21,f22,f1621,f1623,f1624.
+f(f644,0,1,0,v1).
+f(f642,1,1,0,v1) :- f644.
+f(f176,0,1,0,v1).
+f(f75,1,1,0,v1) :- f176.
+f(f445,0,1,0,v1).
+f(f253,0,1,0,v1).
+f(f252,0,1,0,v1).
+f(f250,1,1,0,v1) :- f252,f253,f445.
+f(f160,0,1,0,v1).
+f(f74,1,1,0,v1) :- f160,f250.
+f(f446,0,1,0,v1).
+f(f443,0,1,0,v1).
+f(f438,0,1,0,v1).
+f(f73,1,1,0,v1) :- f438,f443,f446.
+f(f161,0,1,0,v1).
+f(f126,0,1,0,v1).
+f(f159,0,1,0,v1).
+f(f158,0,1,0,v1).
+f(f157,0,1,0,v1).
+f(f156,0,1,0,v1).
+f(f155,1,1,0,v1) :- f156,f157,f158,f159,f126.
+f(f1141,0,1,0,v1).
+f(f994,0,1,0,v1).
+f(f184,0,1,0,v1).
+f(f977,0,1,0,v1).
+f(f182,1,1,0,v1) :- f977.
+f(f181,0,1,0,v1).
+f(f152,1,1,0,v1) :- f181,f182,f184,f994,f1141.
+f(f1746,0,1,0,v1).
+f(f1745,0,1,0,v1).
+f(f100,1,1,0,v1) :- f1745,f1746.
+f(f385,0,1,0,v1).
+f(f384,0,1,0,v1).
+f(f382,1,1,0,v1) :- f384,f385.
+f(f380,0,1,0,v1).
+f(f86,0,1,0,v1).
+f(f83,0,1,0,v1).
+f(f82,1,1,0,v1) :- f83,f86.
+f(f741,0,1,0,v1).
+f(f403,0,1,0,v1).
+f(f401,0,1,0,v1).
+f(f81,0,1,0,v1).
+f(f80,0,1,0,v1).
+f(f79,1,1,0,v1) :- f80,f81,f401,f403,f741.
+f(f605,0,1,0,v1).
+f(f604,0,1,0,v1).
+f(f78,1,1,0,v1) :- f604,f605.
+f(f77,1,1,0,v1) :- f78,f79,f82,f380,f382.
+f(f116,0,1,0,v1).
+f(f115,0,1,0,v1).
+f(f114,0,1,0,v1).
+f(f111,1,1,0,v1) :- f114,f115,f116.
+f(f377,0,1,0,v1).
+f(f368,0,1,0,v1).
+f(f365,0,1,0,v1).
+f(f364,0,1,0,v1).
+f(f363,1,1,0,v1) :- f364,f365,f368.
+f(f649,0,1,0,v1).
+f(f571,0,1,0,v1).
+f(f570,0,1,0,v1).
+f(f362,1,1,0,v1) :- f570,f571,f649.
+f(f127,0,1,0,v1).
+f(f493,0,0.1,0,v1).
+f(f376,0,1,0,v1).
+f(f374,0,1,0,v1).
+f(f373,0,1,0,v1).
+f(f130,1,1,0,v1) :- f373,f374,f376,f493,f127.
+f(f129,0,1,0,v1).
+f(f124,0,1,0,v1).
+f(f123,0,1,0,v1).
+f(f122,0,1,0,v1).
+f(f121,0,1,0,v1).
+f(f120,0,0.001,0,v1).
+f(f119,1,1,0,v1) :- f120,f121,f122,f123.
+f(f117,1,1,0,v1) :- f119,f124,f129,f130,f362,f363,f377.
+f(f72,1,1,0,v1) :- f117,f111,f77,f100,f152,f155,f161.
+f(f19,1,1,0,v1) :- f72,f73,f74,f75,f642.
+f(f1966,0,1,0,v1).
+f(f1607,0,1,0,v1).
+f(f651,0,1,0,v1).
+f(f650,0,1,0,v1).
+f(f628,0,1,0,v1).
+f(f627,0,1,0,v1).
+f(f629,0,1,0,v1).
+f(f626,0,1,0,v1).
+f(f617,1,1,0,v1) :- f626,f629,f627,f628,f650,f651,f1607,f1966.
+p(p1804,0,0.5,36,v1).
+p(p1482,0,0.5,98,v1).
+p(p753,0,0.5,3,v1).
+p(p300,0,0.5,36,v1).
+p(p2065,0,0.5,54,v1).
+p(p1420,0,0.5,75,v1).
+p(p1106,0,0.5,32,v1).
+p(p1099,0,0.5,58,v1).
+p(p756,0,0.5,68,v1).
+p(p761,0,0.5,9,v1).
+p(p740,0,0.5,21,v1).
+p(p739,0,0.5,95,v1).
+p(p738,0,0.5,37,v1).
+p(p737,0,0.5,54,v1).
+p(p736,0,0.5,55,v1).
+p(p735,0,0.5,47,v1).
+p(p734,0,0.5,86,v1).
+p(p696,0,0.5,36,v1).
+p(p695,0,0.5,143,v1).
+p(p303,1,0.5,46,v1) :- p695,p696,p734,p735,p736,p737,p738,p739,p740,p761.
+p(p302,0,0.5,25,v1).
+p(p301,0,0.5,45,v1).
+p(p299,1,0.5,42,v1) :- p301,p302,p303,p756,p1099,p1106,p1420,p2065.
+p(p692,0,0.5,265,v1).
+p(p691,0,0.5,235,v1).
+p(p690,0,0.5,33,v1).
+p(p689,0,0.5,56,v1).
+p(p298,1,0.5,10,v1) :- p689,p690,p691,p692.
+p(p688,0,0.5,46,v1).
+p(p686,0,0.5,6,v1).
+p(p685,0,0.5,48,v1).
+p(p684,0,0.5,22,v1).
+p(p683,0,0.5,11,v1).
+p(p297,1,0.5,25,v1) :- p683,p684,p685,p686,p688.
+p(p307,0,0.5,37,v1).
+p(p306,0,0.5,48,v1).
+p(p305,0,0.5,43,v1).
+p(p304,0,0.5,26,v1).
+p(p296,1,0.5,63,v1) :- p304,p305,p306,p307.
+p(p43,1,0.5,44,v1) :- p296,p297,p298,p299,p300,p753,p1482,p1804.
+p(p311,1,0.5,37,v1).
+p(p248,0,0.5,85,v1).
+p(p42,1,0.5,45,v1) :- p248,p311.
+p(p2074,0,0.5,33,v1).
+p(p2059,0,0.5,56,v1).
+p(p1906,0,0.5,45,v1).
+p(p1865,0,0.5,98,v1).
+p(p1864,0,0.5,53,v1).
+p(p1645,0,0.5,22,v1).
+p(p1587,0,0.5,38,v1).
+p(p1409,0,0.5,32,v1).
+p(p1149,0,0.5,43,v1).
+p(p920,0,0.5,7,v1).
+p(p919,0,0.5,4,v1).
+p(p706,0,0.5,38,v1).
+p(p705,0,0.5,74,v1).
+p(p704,0,0.5,26,v1).
+p(p310,0,0.5,16,v1).
+p(p309,0,0.5,22,v1).
+p(p308,0,0.5,26,v1).
+p(p41,1,0.5,44,v1) :- p308,p309,p310,p704,p705,p706,p919,p920,p1149,p1409,p1587,p1645,p1864,p1865,p1906,p2059,p2074.
+p(p1971,0,0.5,37,v1).
+p(p1868,0,0.5,75,v1).
+p(p1785,0,0.5,2,v1).
+p(p1657,0,0.5,89,v1).
+p(p1591,0,0.5,65,v1).
+p(p1567,0,0.5,16,v1).
+p(p1512,0,0.5,23,v1).
+p(p1480,0,0.5,77,v1).
+p(p1477,0,0.5,35,v1).
+p(p1171,0,0.5,123,v1).
+p(p1168,0,0.5,27,v1).
+p(p1156,0,0.5,15,v1).
+p(p1154,0,0.5,11,v1).
+p(p1142,0,0.5,64,v1).
+p(p1070,0,0.5,26,v1).
+p(p1069,0,0.5,35,v1).
+p(p1066,0,0.5,21,v1).
+p(p1065,0,0.5,65,v1).
+p(p1062,0,0.5,34,v1).
+p(p1059,0,0.5,12,v1).
+p(p924,0,0.5,45,v1).
+p(p859,0,0.5,65,v1).
+p(p755,0,0.5,54,v1).
+p(p699,0,0.5,32,v1).
+p(p698,0,0.5,9,v1).
+p(p697,0,0.5,4,v1).
+p(p405,0,0.5,68,v1).
+p(p404,0,0.5,34,v1).
+p(p319,0,0.5,45,v1).
+p(p318,0,0.5,46,v1).
+p(p317,0,0.5,23,v1).
+p(p316,0,0.5,46,v1).
+p(p312,0,0.5,65,v1).
+p(p44,0,0.5,48,v1).
+p(p40,1,0.5,55,v1) :- p44,p312,p316,p317,p318,p319,p404,p405,p697,p698,p699,p755,p859,p924,p1059,p1062,p1065,p1066,p1069,p1070,p1142,p1154,p1156,p1168,p1171,p1477,p1480,p1512,p1567,p1591,p1657,p1785,p1868,p1971.
+impact(f156,r226,1,v1).
+impact(f156,r336,0.8,v1).
+impact(f156,r223,1,v1).
+impact(f157,r223,0.9,v1).
+impact(f157,r226,1,v1).
+impact(f157,r336,0.8,v1).
+impact(f158,r223,0.9,v1).
+impact(f158,r226,1,v1).
+impact(f158,r336,0.8,v1).
+impact(f159,r223,0.9,v1).
+impact(f159,r226,1,v1).
+impact(f159,r336,0.8,v1).
+impact(f161,r228,0.9,v1).
+impact(f161,r335,1,v1).
+impact(f161,r204,0.9,v1).
+impact(f161,r205,0.95,v1).
+impact(f252,r204,0.3,v1).
+impact(f252,r335,0.8,v1).
+impact(f252,r205,0.6,v1).
+impact(f253,r204,0.3,v1).
+impact(f445,r204,0.3,v1).
+impact(f253,r205,0.6,v1).
+impact(f445,r205,0.6,v1).
+impact(f253,r335,0.8,v1).
+impact(f445,r335,0.8,v1).
+impact(f156,r204,1,v1).
+impact(f156,r205,1,v1).
+impact(f156,r335,1,v1).
+impact(f157,r204,1,v1).
+impact(f158,r204,1,v1).
+impact(f159,r204,1,v1).
+impact(f157,r205,1,v1).
+impact(f157,r335,1,v1).
+impact(f158,r205,1,v1).
+impact(f159,r205,1,v1).
+impact(f158,r335,1,v1).
+impact(f159,r335,1,v1).
+impact(f156,r240,1,v1).
+impact(f156,r241,1,v1).
+impact(f159,r241,1,v1).
+impact(f159,r240,1,v1).
+impact(f158,r240,1,v1).
+impact(f158,r241,1,v1).
+impact(f157,r240,1,v1).
+impact(f157,r241,1,v1).
+impact(f380,r241,1,v1).
+impact(f380,r240,1,v1).
+impact(f380,r204,1,v1).
+impact(f380,r205,1,v1).
+impact(f380,r335,1,v1).
+impact(f380,r223,1,v1).
+impact(f380,r226,1,v1).
+impact(f380,r336,1,v1).
+impact(f385,r204,0.6,v1).
+impact(f385,r205,0.7,v1).
+impact(f385,r335,0.8,v1).
+impact(f384,r204,0.3,v1).
+impact(f384,r335,0.3,v1).
+impact(f384,r205,0.3,v1).
+impact(f1141,r204,0.3,v1).
+impact(f1141,r335,0.9,v1).
+impact(f1141,r205,0.7,v1).
+impact(f1141,r228,0.7,v1).
+impact(f126,r606,1,v1).
+impact(f446,r227,1,v1).
+impact(f443,r204,0.1,v1).
+impact(f443,r205,0.3,v1).
+impact(f443,r335,1,v1).
+impact(f443,r197,0.7,v1).
+impact(f438,r197,0.7,v1).
+impact(f443,r196,0.3,v1).
+impact(f438,r196,0.3,v1).
+impact(f160,r204,0.9,v1).
+impact(f160,r205,1,v1).
+impact(f160,r335,1,v1).
+impact(f443,r294,0.3,v1).
+impact(f176,r196,1,v1).
+impact(f176,r197,1,v1).
+impact(f176,r227,1,v1).
+impact(f176,r228,1,v1).
+impact(f176,r210,1,v1).
+impact(f176,r229,1,v1).
+impact(f176,r276,1,v1).
+impact(f176,r333,1,v1).
+impact(f176,r204,1,v1).
+impact(f176,r205,1,v1).
+impact(f176,r335,1,v1).
+impact(f176,r223,1,v1).
+impact(f176,r226,1,v1).
+impact(f176,r336,0.9,v1).
+impact(f176,r214,1,v1).
+impact(f176,r217,1,v1).
+impact(f176,r220,0.1,v1).
+impact(f176,r221,0.7,v1).
+impact(f176,r222,1,v1).
+impact(f176,r606,0.3,v1).
+impact(f176,r348,0.3,v1).
+impact(f21,r204,0.9,v1).
+impact(f21,r205,1,v1).
+impact(f21,r335,1,v1).
+impact(f21,r288,1,v1).
+impact(f21,r346,1,v1).
+impact(f21,r223,0.3,v1).
+impact(f21,r226,0.3,v1).
+impact(f21,r336,0.3,v1).
+impact(f22,r288,1,v1).
+impact(f22,r346,1,v1).
+impact(f649,r197,0.7,v1).
+impact(f649,r196,0.5,v1).
+impact(f649,r217,1,v1).
+impact(f115,r204,1,v1).
+impact(f115,r205,1,v1).
+impact(f115,r335,1,v1).
+impact(f410,r196,0.9,v1).
+impact(f410,r197,1,v1).
+impact(f410,r217,1,v1).
+impact(f410,r220,1,v1).
+impact(f410,r221,1,v1).
+impact(f410,r222,1,v1).
+impact(f410,r575,1,v1).
+impact(f410,r606,1,v1).
+impact(f377,r196,0.1,v1).
+impact(f377,r197,0.1,v1).
+impact(f377,r204,0.1,v1).
+impact(f377,r205,0.1,v1).
+impact(f377,r335,0.1,v1).
+impact(f368,r196,0.1,v1).
+impact(f368,r197,0.3,v1).
+impact(f365,r196,0.1,v1).
+impact(f365,r197,0.1,v1).
+impact(f365,r214,0.1,v1).
+impact(f1607,r196,0.9,v1).
+impact(f1607,r197,1,v1).
+impact(f1621,r227,0.9,v1).
+impact(f1623,r196,0.9,v1).
+impact(f1623,r197,1,v1).
+impact(f1624,r214,1,v1).
+impact(f1624,r217,1,v1).
+impact(f1623,r220,0.7,v1).
+impact(f1623,r214,0.7,v1).
+impact(f1621,r228,0.9,v1).
+impact(f1624,r229,0.9,v1).
+impact(f1621,r204,0.9,v1).
+impact(f1621,r205,0.9,v1).
+impact(f1621,r335,1,v1).
+impact(f1621,r288,1,v1).
+impact(f1621,r346,1,v1).
+impact(f1621,r291,1,v1).
+impact(f1745,r228,0.1,v1).
+impact(f1746,r228,0.3,v1).
+impact(f1745,r204,0.1,v1).
+impact(f1746,r204,0.5,v1).
+impact(f1745,r205,0.1,v1).
+impact(f1745,r335,0.01,v1).
+impact(f1746,r335,0.9,v1).
+impact(f1746,r205,0.7,v1).
+impact(f1966,r1965,1,v1).
+impact(f446,r210,0.7,v1).
+impact(f446,r276,0.7,v1).
+impact(f446,r333,0.7,v1).
+impact(f446,r204,0.9,v1).
+impact(f446,r205,0.9,v1).
+impact(f446,r335,0.9,v1).
+impact(f446,r2077,1,v1).
+impact(f438,r204,0.1,v1).
+impact(f438,r205,0.3,v1).
+impact(f438,r335,1,v1).
+impact(f116,r223,1,v1).
+impact(f116,r226,1,v1).
+impact(f116,r336,1,v1).
+impact(f114,r223,0.2,v1).
+impact(f114,r226,0.2,v1).
+impact(f114,r336,0.2,v1).
+impact(f114,r240,0.2,v1).
+impact(f114,r241,0.2,v1).
+impact(f114,r204,1,v1).
+impact(f114,r205,1,v1).
+impact(f114,r335,1,v1).
+impact(f129,r197,1,v1).
+impact(f129,r196,1,v1).
+impact(f129,r204,0.9,v1).
+impact(f129,r205,0.9,v1).
+impact(f129,r335,0.9,v1).
+impact(f493,r196,0.7,v1).
+impact(f493,r197,0.7,v1).
+impact(f376,r204,0.3,v1).
+impact(f376,r205,0.3,v1).
+impact(f376,r335,0.3,v1).
+impact(f376,r223,0.3,v1).
+impact(f376,r226,0.3,v1).
+impact(f376,r336,0.3,v1).
+impact(f364,r196,1,v1).
+impact(f364,r197,1,v1).
+impact(f570,r217,1,v1).
+impact(f571,r214,1,v1).
+impact(f129,r220,1,v1).
+impact(f120,r221,1,v1).
+impact(f120,r222,1,v1).
+impact(f121,r221,1,v1).
+impact(f121,r222,1,v1).
+impact(f122,r221,1,v1).
+impact(f122,r222,1,v1).
+impact(f123,r575,1,v1).
+impact(f124,r606,1,v1).
+impact(f604,r196,0.01,v1).
+impact(f604,r197,0.01,v1).
+impact(f605,r217,0.1,v1).
+impact(f604,r204,0.01,v1).
+impact(f604,r205,0.01,v1).
+impact(f604,r335,0.01,v1).
+impact(f605,r204,0.01,v1).
+impact(f605,r205,0.01,v1).
+impact(f605,r335,0.01,v1).
+impact(f626,r291,1,v1).
+impact(f627,r355,1,v1).
+impact(f627,r356,1,v1).
+impact(f628,r356,1,v1).
+impact(f628,r355,0.1,v1).
+impact(f629,r348,1,v1).
+impact(f644,r294,1,v1).
+impact(f651,r346,1,v1).
+impact(f650,r288,1,v1).
+impact(f650,r346,1,v1).
+impact(f649,r210,0.3,v1).
+impact(f649,r276,0.7,v1).
+impact(f649,r333,0.1,v1).
+impact(f604,r210,0.01,v1).
+impact(f604,r276,0.01,v1).
+impact(f604,r333,0.01,v1).
+impact(f605,r210,0.01,v1).
+impact(f605,r276,0.01,v1).
+impact(f605,r333,0.01,v1).
+impact(f604,r227,0.01,v1).
+impact(f605,r227,0.01,v1).
+impact(f604,r228,0.01,v1).
+impact(f605,r228,0.01,v1).
+impact(f80,r204,0.9,v1).
+impact(f80,r205,0.9,v1).
+impact(f80,r335,1,v1).
+impact(f80,r229,0.9,v1).
+impact(f80,r228,0.9,v1).
+impact(f80,r333,0.1,v1).
+impact(f80,r276,0.1,v1).
+impact(f80,r210,0.1,v1).
+impact(f81,r228,1,v1).
+impact(f81,r276,0.3,v1).
+impact(f81,r210,0.1,v1).
+impact(f81,r333,0.01,v1).
+impact(f401,r228,1,v1).
+impact(f401,r229,0.7,v1).
+impact(f401,r204,0.1,v1).
+impact(f401,r205,0.1,v1).
+impact(f401,r335,0.3,v1).
+impact(f403,r228,0.5,v1).
+impact(f403,r204,0.5,v1).
+impact(f403,r205,0.6,v1).
+impact(f403,r335,0.7,v1).
+impact(f403,r223,0.1,v1).
+impact(f403,r226,0.1,v1).
+impact(f403,r336,0.1,v1).
+impact(f741,r223,0.1,v1).
+impact(f741,r226,0.3,v1).
+impact(f741,r336,0.01,v1).
+impact(f81,r214,0.3,v1).
+impact(f83,r204,0.5,v1).
+impact(f83,r205,0.7,v1).
+impact(f83,r335,1,v1).
+impact(f86,r228,0.3,v1).
+impact(f86,r229,0.5,v1).
+impact(f86,r204,0.3,v1).
+impact(f86,r205,0.5,v1).
+impact(f86,r335,0.7,v1).
+impact(f741,r204,0.1,v1).
+impact(f741,r205,0.1,v1).
+impact(f741,r335,0.3,v1).
+impact(f120,r204,0.05,v1).
+impact(f121,r204,0.1,v1).
+impact(f120,r335,0.3,v1).
+impact(f121,r335,0.5,v1).
+impact(f120,r205,0.1,v1).
+impact(f121,r205,0.3,v1).
+impact(f122,r335,0.5,v1).
+impact(f122,r204,0.01,v1).
+impact(f122,r205,0.1,v1).
+impact(f123,r335,0.05,v1).
+impact(f373,r204,0.7,v1).
+impact(f373,r205,0.7,v1).
+impact(f373,r335,0.7,v1).
+impact(f373,r228,0.3,v1).
+impact(f373,r229,0.5,v1).
+impact(f374,r228,0.1,v1).
+impact(f374,r229,0.3,v1).
+impact(f374,r204,0.1,v1).
+impact(f374,r205,0.1,v1).
+impact(f374,r335,0.1,v1).
+impact(f156,r228,1,v1).
+impact(f157,r228,1,v1).
+impact(f158,r228,1,v1).
+impact(f159,r228,1,v1).
+impact(f380,r228,1,v1).
+impact(f181,r228,0.3,v1).
+impact(f181,r204,0.3,v1).
+impact(f181,r205,0.3,v1).
+impact(f181,r335,0.3,v1).
+impact(f181,r223,0.1,v1).
+impact(f181,r226,0.1,v1).
+impact(f181,r336,0.1,v1).
+impact(f977,r204,0.4,v1).
+impact(f977,r205,0.7,v1).
+impact(f977,r335,0.9,v1).
+impact(f184,r226,0.5,v1).
+impact(f184,r336,0.2,v1).
+impact(f184,r223,0.3,v1).
+impact(f994,r204,0.4,v1).
+impact(f994,r205,0.7,v1).
+impact(f994,r335,0.9,v1).
+impact(f994,r228,0.3,v1).
+effect(f605,p317,0.9,v1).
+effect(f977,p317,0.95,v1).
+effect(f994,p317,0.95,v1).
+effect(f157,p317,0.95,v1).
+effect(f380,p1059,0.99,v1).
+effect(f380,p1062,1,v1).
+effect(f156,p1070,0.95,v1).
+effect(f157,p1070,0.95,v1).
+effect(f158,p1070,0.3,v1).
+effect(f159,p1070,0.95,v1).
+effect(f158,p1069,0.001,v1).
+effect(f156,p1069,0.95,v1).
+effect(f157,p1069,0.7,v1).
+effect(f159,p1069,0.9,v1).
+effect(f114,p308,0.8,v1).
+effect(f156,p309,0.9,v1).
+effect(f157,p309,0.1,v1).
+effect(f159,p309,0.9,v1).
+effect(f181,p310,0.9,v1).
+effect(f977,p310,0.9,v1).
+effect(f181,p1099,0.999,v1).
+effect(f977,p1099,0.95,v1).
+effect(f184,p1099,0.9,v1).
+effect(f994,p1099,0.95,v1).
+effect(f626,p302,0.95,v1).
+effect(f629,p302,0.95,v1).
+effect(f650,p302,0.9,v1).
+effect(f651,p302,0.9,v1).
+effect(f124,p302,0.1,v1).
+effect(f129,p302,0.01,v1).
+effect(f376,p302,0.01,v1).
+effect(f114,p302,0.99,v1).
+effect(f115,p302,0.1,v1).
+effect(f116,p302,0.9,v1).
+effect(f80,p302,0.1,v1).
+effect(f81,p302,0.1,v1).
+effect(f401,p302,0.6,v1).
+effect(f403,p302,0.99,v1).
+effect(f741,p302,0.9,v1).
+effect(f83,p302,0.99,v1).
+effect(f86,p302,0.05,v1).
+effect(f380,p302,0.1,v1).
+effect(f385,p302,0.9,v1).
+effect(f181,p302,0.8,v1).
+effect(f977,p302,0.05,v1).
+effect(f184,p302,0.8,v1).
+effect(f156,p302,0.95,v1).
+effect(f157,p302,0.05,v1).
+effect(f159,p302,0.1,v1).
+effect(f161,p302,0.05,v1).
+effect(f181,p1142,0.99,v1).
+effect(f977,p1142,0.95,v1).
+effect(f994,p1142,0.95,v1).
+effect(f184,p1142,0.95,v1).
+effect(f1141,p1142,0.999,v1).
+effect(f161,p1149,0.9,v1).
+effect(f252,p302,0.95,v1).
+effect(f253,p302,0.95,v1).
+effect(f445,p302,0.95,v1).
+effect(f161,p1156,0.95,v1).
+effect(f161,p1154,0.3,v1).
+effect(f156,p1154,0.8,v1).
+effect(f157,p1154,0.8,v1).
+effect(f158,p1154,0.8,v1).
+effect(f159,p1154,0.8,v1).
+effect(f126,p1154,0.3,v1).
+effect(f438,p1168,0.9,v1).
+effect(f493,p1171,0.1,v1).
+effect(f626,p684,0.9,v1).
+effect(f115,p1420,0.99,v1).
+effect(f120,p1171,0.1,v1).
+effect(f121,p1171,0.1,v1).
+effect(f122,p1171,0.1,v1).
+effect(f123,p1171,0.1,v1).
+effect(f124,p1171,0.1,v1).
+effect(f129,p1171,0.03,v1).
+effect(f571,p1171,0.1,v1).
+effect(f129,p704,0.9,v1).
+effect(f410,p920,0.3,v1).
+effect(f22,p920,0.1,v1).
+effect(f410,p684,0.1,v1).
+effect(f410,p688,0.1,v1).
+effect(f410,p689,0.1,v1).
+effect(f410,p690,0.1,v1).
+effect(f410,p692,0.1,v1).
+effect(f410,p685,0.05,v1).
+effect(f410,p304,0.1,v1).
+effect(f410,p305,0.1,v1).
+effect(f410,p306,0.1,v1).
+effect(f410,p307,0.1,v1).
+effect(f410,p706,0.1,v1).
+effect(f410,p1154,0.1,v1).
+effect(f364,p1477,0.9,v1).
+effect(f410,p1477,0.1,v1).
+effect(f160,p1480,0.7,v1).
+effect(f493,p1482,0.01,v1).
+effect(f373,p1482,0.9,v1).
+effect(f374,p1482,0.9,v1).
+effect(f376,p1482,0.9,v1).
+effect(f443,p1512,0.7,v1).
+effect(f252,p1567,0.3,v1).
+effect(f253,p1567,0.9,v1).
+effect(f445,p1567,0.95,v1).
+effect(f176,p311,0.2,v1).
+effect(f176,p695,0.3,v1).
+effect(f176,p696,0.1,v1).
+effect(f176,p734,0.7,v1).
+effect(f176,p735,0.01,v1).
+effect(f176,p736,0.1,v1).
+effect(f176,p737,0.1,v1).
+effect(f176,p739,0.9,v1).
+effect(f176,p740,0.3,v1).
+effect(f176,p738,0.1,v1).
+effect(f159,p761,0.1,v1).
+effect(f176,p302,0.95,v1).
+effect(f158,p1587,0.95,v1).
+effect(f446,p302,0.9,v1).
+effect(f373,p1591,0.3,v1).
+effect(f373,p697,0.95,v1).
+effect(f374,p697,0.9,v1).
+effect(f376,p697,0.9,v1).
+effect(f493,p697,0.9,v1).
+effect(f160,p302,0.1,v1).
+effect(f160,p301,0.9,v1).
+effect(f1607,p312,0.7,v1).
+effect(f570,p684,0.99,v1).
+effect(f570,p685,0.95,v1).
+effect(f570,p686,0.9,v1).
+effect(f571,p684,0.99,v1).
+effect(f571,p685,0.8,v1).
+effect(f571,p686,0.8,v1).
+effect(f410,p316,0.7,v1).
+effect(f1623,p924,0.7,v1).
+effect(f1624,p924,0.7,v1).
+effect(f1621,p924,0.3,v1).
+effect(f410,p919,0.3,v1).
+effect(f1621,p920,0.1,v1).
+effect(f1623,p920,0.3,v1).
+effect(f1624,p920,0.3,v1).
+effect(f1624,p1645,0.9,v1).
+effect(f1623,p1645,0.3,v1).
+effect(f1621,p1645,0.3,v1).
+effect(f1621,p1657,0.99,v1).
+effect(f1623,p1657,0.9,v1).
+effect(f1624,p1657,0.9,v1).
+effect(f22,p1657,0.9,v1).
+effect(f410,p1657,0.3,v1).
+effect(f410,p705,0.01,v1).
+effect(f1621,p706,0.05,v1).
+effect(f626,p44,0.3,v1).
+effect(f410,p686,0.05,v1).
+effect(f1623,p686,0.1,v1).
+effect(f253,p404,0.3,v1).
+effect(f252,p405,0.05,v1).
+effect(f410,p300,0.01,v1).
+effect(f410,p753,1,v1).
+effect(f21,p753,1,v1).
+effect(f22,p753,1,v1).
+effect(f1621,p753,1,v1).
+effect(f1623,p753,1,v1).
+effect(f1624,p753,1,v1).
+effect(f410,p1482,0.1,v1).
+effect(f1623,p1482,0.1,v1).
+effect(f1624,p1482,0.05,v1).
+effect(f1624,p692,0.3,v1).
+effect(f1624,p691,0.7,v1).
+effect(f1624,p690,0.7,v1).
+effect(f1624,p689,0.7,v1).
+effect(f1624,p683,0.1,v1).
+effect(f1624,p684,0.7,v1).
+effect(f1624,p685,0.5,v1).
+effect(f1624,p686,0.3,v1).
+effect(f1624,p688,0.1,v1).
+effect(f1623,p683,0.7,v1).
+effect(f1623,p690,0.7,v1).
+effect(f1623,p691,0.7,v1).
+effect(f1623,p684,0.1,v1).
+effect(f1623,p685,0.1,v1).
+effect(f1621,p684,0.9,v1).
+effect(f1621,p685,0.9,v1).
+effect(f1623,p300,0.01,v1).
+effect(f644,p753,1,v1).
+effect(f176,p753,1,v1).
+effect(f626,p753,1,v1).
+effect(f629,p753,1,v1).
+effect(f627,p753,1,v1).
+effect(f628,p753,1,v1).
+effect(f650,p753,1,v1).
+effect(f651,p753,1,v1).
+effect(f160,p753,1,v1).
+effect(f252,p753,1,v1).
+effect(f253,p753,1,v1).
+effect(f445,p753,1,v1).
+effect(f446,p753,1,v1).
+effect(f443,p753,1,v1).
+effect(f438,p753,1,v1).
+effect(f120,p753,0.1,v1).
+effect(f121,p753,0.3,v1).
+effect(f122,p753,0.3,v1).
+effect(f123,p753,0.1,v1).
+effect(f124,p753,1,v1).
+effect(f129,p753,0.9,v1).
+effect(f570,p753,1,v1).
+effect(f571,p753,0.9,v1).
+effect(f649,p753,0.7,v1).
+effect(f364,p753,0.7,v1).
+effect(f365,p753,0.7,v1).
+effect(f368,p753,0.7,v1).
+effect(f377,p753,0.9,v1).
+effect(f114,p753,1,v1).
+effect(f115,p753,0.9,v1).
+effect(f116,p753,0.9,v1).
+effect(f604,p753,0.9,v1).
+effect(f605,p753,0.7,v1).
+effect(f80,p753,1,v1).
+effect(f81,p753,1,v1).
+effect(f401,p753,1,v1).
+effect(f403,p753,1,v1).
+effect(f741,p753,1,v1).
+effect(f83,p753,1,v1).
+effect(f86,p753,1,v1).
+effect(f1745,p1065,0.95,v1).
+effect(f1746,p1065,0.9,v1).
+effect(f1745,p405,0.1,v1).
+effect(f1746,p405,0.1,v1).
+effect(f1745,p404,0.1,v1).
+effect(f1746,p404,0.1,v1).
+effect(f1746,p1409,0.9,v1).
+effect(f1745,p302,0.9,v1).
+effect(f1746,p302,0.05,v1).
+effect(f1745,p1106,0.95,v1).
+effect(f1746,p1106,0.95,v1).
+effect(f1746,p753,1,v1).
+effect(f380,p753,1,v1).
+effect(f384,p753,1,v1).
+effect(f385,p753,1,v1).
+effect(f994,p753,0.7,v1).
+effect(f184,p753,1,v1).
+effect(f977,p753,1,v1).
+effect(f181,p753,1,v1).
+effect(f1141,p753,1,v1).
+effect(f161,p753,0.7,v1).
+effect(f126,p753,0.7,v1).
+effect(f159,p753,0.7,v1).
+effect(f158,p753,0.1,v1).
+effect(f157,p753,1,v1).
+effect(f156,p753,1,v1).
+effect(f1745,p301,0.99,v1).
+effect(f1746,p301,0.99,v1).
+effect(f364,p1785,0.999,v1).
+effect(f410,p1785,0.05,v1).
+effect(f1607,p1657,0.1,v1).
+effect(f121,p1657,0.05,v1).
+effect(f122,p1657,0.05,v1).
+effect(f123,p1657,0.05,v1).
+effect(f364,p1657,0.1,v1).
+effect(f129,p1657,0.1,v1).
+effect(f124,p1657,0.05,v1).
+effect(f374,p1657,0.1,v1).
+effect(f376,p1657,0.1,v1).
+effect(f649,p1657,0.05,v1).
+effect(f365,p1657,0.1,v1).
+effect(f368,p1657,0.1,v1).
+effect(f377,p1657,0.05,v1).
+effect(f380,p1657,0.1,v1).
+effect(f384,p1657,0.3,v1).
+effect(f156,p1657,0.05,v1).
+effect(f377,p1804,0.99,v1).
+effect(f410,p1804,0.1,v1).
+effect(f1621,p1804,0.2,v1).
+effect(f1607,p684,0.1,v1).
+effect(f1607,p686,0.1,v1).
+effect(f1607,p689,0.7,v1).
+effect(f1607,p690,0.7,v1).
+effect(f1607,p691,0.7,v1).
+effect(f1607,p692,0.1,v1).
+effect(f1607,p683,0.1,v1).
+effect(f124,p691,0.1,v1).
+effect(f129,p692,0.9,v1).
+effect(f129,p691,0.9,v1).
+effect(f129,p690,0.9,v1).
+effect(f493,p683,0.7,v1).
+effect(f493,p685,0.3,v1).
+effect(f604,p683,0.99,v1).
+effect(f605,p683,0.9,v1).
+effect(f604,p686,0.9,v1).
+effect(f605,p686,0.3,v1).
+effect(f605,p685,0.9,v1).
+effect(f604,p684,0.1,v1).
+effect(f605,p302,0.3,v1).
+effect(f604,p706,0.01,v1).
+effect(f605,p684,0.3,v1).
+effect(f83,p690,0.1,v1).
+effect(f83,p691,0.1,v1).
+effect(f83,p692,0.1,v1).
+effect(f380,p686,0.7,v1).
+effect(f380,p684,0.3,v1).
+effect(f380,p685,0.3,v1).
+effect(f380,p683,0.1,v1).
+effect(f380,p688,0.1,v1).
+effect(f380,p690,0.1,v1).
+effect(f380,p691,0.1,v1).
+effect(f380,p692,0.1,v1).
+effect(f158,p690,0.9,v1).
+effect(f158,p691,0.9,v1).
+effect(f158,p692,0.7,v1).
+effect(f159,p690,0.9,v1).
+effect(f159,p691,0.9,v1).
+effect(f157,p684,0.99,v1).
+effect(f157,p685,0.95,v1).
+effect(f157,p686,0.99,v1).
+effect(f161,p690,0.9,v1).
+effect(f161,p691,0.9,v1).
+effect(f438,p683,0.01,v1).
+effect(f626,p1868,0.1,v1).
+effect(f629,p1868,0.9,v1).
+effect(f650,p1868,0.7,v1).
+effect(f651,p1868,0.1,v1).
+effect(f649,p1868,0.95,v1).
+effect(f365,p1868,0.1,v1).
+effect(f377,p1868,0.05,v1).
+effect(f380,p1868,0.1,v1).
+effect(f1745,p1868,0.9,v1).
+effect(f1746,p1868,0.01,v1).
+effect(f156,p1868,0.9,v1).
+effect(f21,p1868,0.3,v1).
+effect(f22,p1868,0.3,v1).
+effect(f1621,p1868,0.7,v1).
+effect(f22,p1864,0.9,v1).
+effect(f21,p1864,0.9,v1).
+effect(f1621,p1864,0.1,v1).
+effect(f410,p1865,0.05,v1).
+effect(f21,p1865,0.9,v1).
+effect(f22,p1865,0.9,v1).
+effect(f1621,p1865,0.99,v1).
+effect(f1624,p1865,0.7,v1).
+effect(f1623,p1865,0.05,v1).
+effect(f649,p1864,0.7,v1).
+effect(f649,p1865,0.9,v1).
+effect(f373,p1906,0.01,v1).
+effect(f374,p1906,0.95,v1).
+effect(f376,p1906,0.95,v1).
+effect(f1746,p1906,0.9,v1).
+effect(f1745,p1906,0.95,v1).
+effect(f156,p1906,0.7,v1).
+effect(f161,p1906,0.9,v1).
+effect(f1745,p1069,0.9,v1).
+effect(f1746,p1069,0.95,v1).
+effect(f627,p1066,0.9,v1).
+effect(f628,p1066,0.99,v1).
+effect(f129,p318,0.9,v1).
+effect(f368,p318,0.99,v1).
+effect(f161,p318,0.9,v1).
+effect(f410,p318,0.1,v1).
+effect(f1623,p318,0.05,v1).
+effect(f410,p1587,0.3,v1).
+effect(f129,p689,0.9,v1).
+effect(f158,p689,0.9,v1).
+effect(f159,p689,0.9,v1).
+effect(f410,p691,0.1,v1).
+effect(f1623,p689,0.7,v1).
+effect(f1966,p706,0.99,v1).
+effect(f570,p1971,0.1,v1).
+effect(f604,p1971,0.1,v1).
+effect(f605,p1971,0.1,v1).
+effect(f80,p1971,0.7,v1).
+effect(f81,p1971,0.9,v1).
+effect(f401,p1971,0.9,v1).
+effect(f403,p1971,0.3,v1).
+effect(f741,p1971,0.3,v1).
+effect(f86,p1971,0.7,v1).
+effect(f83,p1971,0.3,v1).
+effect(f120,p919,0.3,v1).
+effect(f121,p919,0.9,v1).
+effect(f122,p919,0.9,v1).
+effect(f123,p919,0.9,v1).
+effect(f160,p1868,0.3,v1).
+effect(f160,p1864,0.3,v1).
+effect(f160,p1865,0.7,v1).
+effect(f384,p1154,0.3,v1).
+effect(f385,p1154,0.7,v1).
+effect(f374,p2059,0.1,v1).
+effect(f493,p2059,0.9,v1).
+effect(f365,p697,0.9,v1).
+effect(f160,p2065,0.9,v1).
+effect(f446,p2074,0.7,v1).
+effect(f384,p697,0.99,v1).
+effect(f124,p697,0.99,v1).
+effect(f116,p44,0.999,v1).
+effect(f626,p706,0.99,v1).
+effect(f627,p706,0.9,v1).
+effect(f628,p706,0.9,v1).
+effect(f650,p706,0.9,v1).
+effect(f651,p706,0.9,v1).
+effect(f129,p706,0.3,v1).
+effect(f649,p706,0.01,v1).
+effect(f384,p706,0.3,v1).
+effect(f385,p706,0.9,v1).
+effect(f21,p706,0.05,v1).
+effect(f22,p706,0.05,v1).
+effect(f644,p706,0.9,v1).
+effect(f80,p695,0.7,v1).
+effect(f80,p859,0.9,v1).
+effect(f81,p859,0.9,v1).
+effect(f401,p859,0.9,v1).
+effect(f403,p859,0.9,v1).
+effect(f741,p859,0.9,v1).
+effect(f83,p859,0.9,v1).
+effect(f86,p859,0.9,v1).
+effect(f80,p737,0.1,v1).
+effect(f741,p737,1,v1).
+effect(f83,p737,1,v1).
+effect(f86,p737,0.3,v1).
+effect(f604,p739,0.3,v1).
+effect(f604,p761,0.99,v1).
+effect(f605,p761,0.99,v1).
+effect(f401,p695,1,v1).
+effect(f81,p695,0.3,v1).
+effect(f120,p316,0.01,v1).
+effect(f121,p316,0.5,v1).
+effect(f122,p316,0.3,v1).
+effect(f120,p924,0.7,v1).
+effect(f121,p924,0.7,v1).
+effect(f122,p924,0.7,v1).
+effect(f123,p924,0.7,v1).
+effect(f123,p304,0.7,v1).
+effect(f120,p305,0.9,v1).
+effect(f121,p307,0.3,v1).
+effect(f122,p306,0.8,v1).

