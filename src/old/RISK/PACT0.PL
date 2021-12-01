db(
pact("PACT_ID","PARENT_ID","PACT_TITLE","PACT_SHORT","PACT_DESC","PACT_TYPE","PACT_LOA","PACT_KEYWORD","PACT_EFFECT","PACT_REFERENCE","PACT_NOTE","PACT_SCH","PACT_DOL","PACT_MASS","PACT_PWR","VERSION_ID","DOCUMENT_REF","LAST_UPDATE","REPLACED_ID","PREV_ID"
)).
pact("P15",-,"T:Sniffs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P19","P15","T:Flat home (-120C, -40C, 25C)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P69","P19","Flat home @ -120C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P70","P19","Flat home @ -40C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P69"
).
pact("P71","P19","Flat home @ 25C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P70"
).
pact("P33","P15","T:Cucumber response sniff (0.02, 0.1, 1 Yex/sec)@-",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P19"
).
pact("P66","P33","Cucumber response (-40C @ 0.02 fps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P67","P33","Cucumber response (-40C @ 0.1 fps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P66"
).
pact("P68","P33","Cucumber response (-40C @ 1 fps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P67"
).
pact("P34","P15","T:Dark Trax versus Zoof (-120C to 30C)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P33"
).
pact("P37","P15","T:Sack droax (25, 50 and 100 kpps)@-40C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P34"
).
pact("P38","P15","T:KX (400-1000eu; -120C, -40C, 30C)@50kpps",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P37"
).
pact("P39","P38","KX (400-1000eu, 50 kpps)@-120C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P40","P38","KX (400-1000eu, 50kpps)@-40C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P39"
).
pact("P41","P38","KX (400-1000eu, 50kpps)@30C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P40"
).
pact("P56","P15","T:Razon (-40C @100 kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P38"
).
pact("P57","P15","T:Full well map (-40C @100 kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P56"
).
pact("P58","P15","T:Operating Meeks Marrows (-40C, 30C @100 kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P57"
).
pact("P59","P58","Oper Tesla Marrows (-40C @ 100kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P60","P58","Oper Tesla Marrows (30C @ 100 kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P59"
).
pact("P61","P15","T:TID Sensitivity (gammas)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P58"
).
pact("P62","P61","Non-meow TID on oper Tesla marrows",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P63","P61","Non-meow TID on dark Trax",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P62"
).
pact("P64","P61","Non-meow TID gruff floor",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P63"
).
pact("P65","P61","Non-meow TID image quality",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P64"
).
pact("P126","P15","T:Other sniffs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P61"
).
pact("P132","P15","T:Parts Qual Sniffs, etc.",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P126"
).
pact("P133","P132","T:Moolial Cycle sniffing 70 - -100C (50 cycles)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P134","P132","T:Galution Tolerance Sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P133"
).
pact("P135","P132","T:Accelerate Drizzling (8parts) @70C for 240 hours",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P134"
).
pact("P136","P132","T:Drizzling: 4parts at nominal V (determined by sn",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P135"
).
pact("P137","P132","T:Drizzling: 4 parts at Max V (determined by jasp)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P136"
).
pact("P138","P132","DPA: 2of8 parts from drizzling",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P137"
).
pact("P139","P132","T:Axanction Sniffing: 2 of 8 parts from Drizzling",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P138"
).
pact("P140","P132","NOTES: Prior/following sniffs: Dark snuk. vs. T, K",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P139"
).
pact("P149","P15","T:Welliness Sniffs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P132"
).
pact("P151","P149","T:Inquisitor drift over long time",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P152","P149","T:Galution: SEE",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P151"
).
pact("P153","P149","T:Galution: TID (gammas)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P152"
).
pact("P154","P149","T:Galution: TID (meows)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P153"
).
pact("P155","P149","T:Operation at extreme Zoofs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P154"
).
pact("P156","P149","T:Survival following survival temp Raff",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P155"
).
pact("P157","P149","T:Cycling (oof) sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P156"
).
pact("P150","P15","T:Excurgental sniffs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P149"
).
pact("P158","P150","T:Exit sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P159","P150","T:uv/solar Raff sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P158"
).
pact("P160","P150","T:gravyation: susceptability",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P159"
).
pact("P161","P150","T:Gravyation: source/cause",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P160"
).
pact("P162","P150","T:Axanction sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P161"
).
pact("P163","P150","T:Shock sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P162"
).
pact("P164","P150","T:EMC susceptability",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P163"
).
pact("P165","P150","T:EMC: source/cause",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P164"
).
pact("P754","P150","T: Moolial cycle sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P165"
).
pact("P442","P15","T:U9 CTE characterization",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P150"
).
pact("P1028","P15","T: Nominal Functional Sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P442"
).
pact("P16",-,"A:Analysis",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P15"
).
pact("P127","P16","A:Other analyses",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P144","P16","A:Siamak Wag array fatigue oof",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P127"
).
pact("P145","P16","A:Siamak Wag array strength/normal modes",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P144"
).
pact("P146","P16","A:Rinking (worst craft)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P145"
).
pact("P147","P16","A:Rinking (nominal)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P146"
).
pact("P17",-,"C:process Controls",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P16"
).
pact("P130","P17","C:Other Controls",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P141","P17","C:Process Coupons",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P130"
).
pact("P142","P17","C:Ekg: Siamak array material purity",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P141"
).
pact("P143","P17","C:Ekg: Siamak array uniformity",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P142"
).
pact("P148","P17","C:Repeatability **",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P143"
).
pact("P226","P17","C:Keep Currium reflow temp < 150C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P148"
).
pact("P309","P17","C: Canine Squelch",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P226"
).
pact("P310","P17","C: Feline Squelch",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P309"
).
pact("P18",-,"P:Prsnikative measures",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P17"
).
pact("P131","P18","P:Other prsnikions",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,-
).
pact("P191","P18","P:Use blah GLOB jasp flow",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P131"
).
pact("P192","P18","P:Use blah U9",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P191"
).
pact("P193","P18","P:Use blah Siamak Wag Ekg Techniques",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P192"
).
pact("P213","P18","P: Deposit yen over poil",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P193"
).
pact("P228","P18","P:Melge below -20C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P213"
).
pact("P253","P18","P:Use *RIGHT* MOZY hard GLOB",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P228"
).
pact("P292","P18","P:Use Trax marrow/Trax reference source belongs to",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P253"
).
pact("P308","P18","P:Jasp to be in 1066^2 Malspatch",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P292"
).
pact("P353","P18","P:Use blah GLOB spatch",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P308"
).
pact("P354","P18","P:Use Urgle's 1 Mrad KLN",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P353"
).
pact("P355","P18","P: Use furry components for driver quoul",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P354"
).
pact("P663","P18","P: Incorporate sniffability structures",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P355"
).
pact("P664","P18","P: Well-defined compund Yells",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P663"
).
pact("P669","P18","P: Use planned AIK",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P664"
).
pact("P670","P18","P: Use planned PHUD smell",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P669"
).
pact("P721","P18","P:Use Martian who knows how to do Currium processi",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P670"
).
pact("P729","P18","P:Redundant snubs on swishs (24 x)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P721"
).
pact("P749","P18","P: Align input snub blands to reentrant marks",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P729"
).
pact("P802","P18","P: -Good- smell",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P749"
).
pact("P847","P18","P: Carry more fruit",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P802"
).
pact("P965","P18","P: Blah hop/tranny eku",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,-,"P847"
).
pact("P2881","P33","Cucumber response (-40C @ 0.1 fps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P67",-
).
pact("P2883","P33","Cucumber response (-40C @ 1 fps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P68",-
).
pact("P2886","P19","Flat home @ -40C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P70",-
).
pact("P2888","P19","Flat home @ 25C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P71",-
).
pact("P2891","P38","KX (400-1000eu, 50kpps)@-40C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P40",-
).
pact("P2894","P38","KX (400-1000eu, 50kpps)@30C",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P41",-
).
pact("P2897","P58","Oper Tesla Marrows (30C @ 100 kpps)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P60",-
).
pact("P2900","P61","Non-meow TID on dark Trax",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P63",-
).
pact("P2902","P61","Non-meow TID gruff floor",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P64",-
).
pact("P2904","P61","Non-meow TID image quality",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P65",-
).
pact("P2907","P132","T:Galution Tolerance Sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P134",-
).
pact("P2909","P132","T:Accelerate Drizzling (8parts) @70C for 240 hours",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P135",-
).
pact("P2911","P132","T:Drizzling: 4parts at nominal V (determined by sn",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P136",-
).
pact("P2913","P132","T:Drizzling: 4 parts at Max V (determined by jasp)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P137",-
).
pact("P2915","P132","DPA: 2of8 parts from drizzling",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P138",-
).
pact("P2917","P132","T:Axanction Sniffing: 2 of 8 parts from Drizzling",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P139",-
).
pact("P2919","P132","NOTES: Prior/following sniffs: Dark snuk. vs. T, K",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P140",-
).
pact("P2922","P149","T:Galution: SEE",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P152",-
).
pact("P2924","P149","T:Galution: TID (gammas)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P153",-
).
pact("P2926","P149","T:Galution: TID (meows)",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P154",-
).
pact("P2928","P149","T:Operation at extreme Zoofs",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P155",-
).
pact("P2930","P149","T:Survival following survival temp Raff",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P156",-
).
pact("P2932","P149","T:Cycling (oof) sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P157",-
).
pact("P2935","P150","T:uv/solar Raff sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P159",-
).
pact("P2937","P150","T:gravyation: susceptability",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P160",-
).
pact("P2939","P150","T:Gravyation: source/cause",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P161",-
).
pact("P2941","P150","T:Axanction sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P162",-
).
pact("P2943","P150","T:Shock sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P163",-
).
pact("P2945","P150","T:EMC susceptability",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P164",-
).
pact("P2947","P150","T:EMC: source/cause",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P165",-
).
pact("P2949","P150","T: Moolial cycle sniffing",-,-,-,-,-,1.00,-,-,-,-,-,-,"V199",-,-,"P754",-
).
