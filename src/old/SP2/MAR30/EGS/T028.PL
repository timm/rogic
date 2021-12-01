*[
acth,
acthProduction,
acutEdex,
adrx,
adrx_now,
aluminium,
bar_and36,
brainGlucose,
brainGlucoseUptake,
catechole,
catecholeDisp,
catecholeProd,
chroniCdex,
chroniCdiaz,
chroniCglucose,
chroniCinsulin,
chroniCtolbut,
corticoidProduction,
cortisol,
cortisolProduction,
crf,
da,
da2Hva,
daProduction,
dex,
dhpg,
diaz,
dummy1,
dummy10,
dummy11,
dummy12,
dummy13,
dummy2,
dummy3,
dummy4,
dummy5,
dummy6,
dummy7,
dummy8,
dummy9,
etherstr,
fiveHIAA,
fromGut,
fromLiver,
fromPancreas,
gentle,
ghProduction,
ghrh,
glucagon,
glucagonDis,
glucagonProd,
glucocorticoid,
glucose,
guan,
guan_now,
hgh,
hghInj,
hva,
hypox,
hypox_now,
insulin,
insulin10,
insulin30,
insulinBolis,
msg,
msg_now,
ne,
ne2dhpg,
ne2Epin,
neControl,
neProduction,
parg,
pHgh,
pns,
pPrl,
prl,
prlRelease,
ptu,
sateity,
serotonin,
serotoninProduction,
serotoninTOfiveHIAA,
sns,
srif,
stress,
swimstr,
t4,
temp1,
temp2,
temp3,
toKidneys,
tolbut10,
tolbut20,
tolbut30,
toTissue,
twoDg,
vagus,
yoh
].



*[rx= [[], [msg], [diaz], [guan], [parg], [hypox], [twoDg], [acutEdex],
 [gentle],[chroniCdex], [swimstr ], [  etherstr ], [  ptu,  yoh ], [  tolbut10 ],
 [  tolbut20 ], [  insulin10 ], [  insulin30 ], [  msg,  parg ], [  chroniCtolbut ], 
[  chroniCglucose ], [  chroniCinsulin ], [  gentle , yoh ], [  guan , twoDg ],
 [ptu , swimstr ], [  ptu,  etherstr ], [  diaz,  chroniCdiaz ], [  hypox , hghInj ], 
[  acutEdex , swimstr ], [chroniCdex , swimstr ], [  chroniCglucose , chroniCtolbut]],
da=[10,5,10,-,20,10,10,-,-,-,10,15,-,9,10,-,-,20,10,7,10,-,-,10,10,10,10,-,-,10]
,ne=[10,10,5,7,20,10,8,10,15,15,10,8,3,9,10,11,10,20,10,10,9,5,7,9,10,10,10,10,10,10]
,hgh=[10,-,-,-,-,-,-,-,-,-,-,-,-,-,-,50,5,-,-,-,-,-,-,-,-,-,-,-,-,-]
,hva=[10,10,10,-,2,10,20,-,-,-,12,12,-,11,10,-,-,2,10,10,10,-,-,18,20,10,10,-,-,10]
,acth=[-,10,-,20,-,-,-,-,10,8,1,20,20,20,-,-,-,-,-,-,-,-,30,-,20,20,10,-,45,1]
,dhpg=[10,10,12,30,2,10,20,15,10,10,20,23,30,11,10,9,20,2,10,10,11,15,21,15,23,10,10,20,21,10]
,glucose=[10,-,-,5,-,-,20,-,-,-,-,-,-,5,5,5,3,-,7,12,5,-,9,-,-,-,-,-,-,8]
,insulin=[10,-,-,5,-,-,15,-,-,-,-,-,-,50,20,-,-,-,10,10,20,-,10,-,-,-,-,-,-,10]
,cortisol=[10,-,90,50,-,-,50,10,8,5,100,100,20,50,40,8,9,-,10,10,25,30,50,90,90,45,-,50,6,10]
,fiveHIAA=[10,10,5,-,2,20,10,-,10,-,9,10,9,10,10,20,-,2,15,7,10,9,-,18,18,5,10,-,-,15]
,glucagon=[10,-,-,-,-,-,15,-,-,-,-,-,-,10,10,10,50,-,10,10,-,-,-,-,-,-,-,-,-,10]
,serotonin=[10,15,20,-,20,10,12,-,10,-,12,12,11,10,10,10,-,20,10,10,10,11,-,12,12,20,10,-,-,10]
].

x(acthProduction, A, 1) :-
	x(crf, A, 1).
x(acthProduction, A, -1) :-
	x(crf, A, -1).
x(acth, A, 1) :-
	x(acthProduction, A, 1).
x(acthProduction, A, -1) :-
	x(hypox, A, 1).
x(acthProduction, A, 1) :-
	x(hypox, A, -1).
x(cortisolProduction, A, 1) :-
	x(acth, A, 1).
x(cortisolProduction, A, -1) :-
	x(acth, A, -1).
x(cortisolProduction, A, 1) :-
	x(dummy1, A, 1).
x(cortisolProduction, A, -1) :-
	x(dummy1, A, -1).
x(dummy1, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy1, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(cortisolProduction, A, -1) :-
	x(guan, A, 1).
x(cortisolProduction, A, 1) :-
	x(guan, A, -1).
x(cortisol, A, 1) :-
	x(dummy2, A, 1).
x(cortisol, A, -1) :-
	x(dummy2, A, -1).
x(dummy2, A, 1) :-
	x(adrx_now, A, -1),
	x(cortisolProduction, A, 1).
x(cortisol, A, 1) :-
	x(adrx, A, -1).
x(cortisol, A, -1) :-
	x(corticoidProduction, A, 1).
x(acthProduction, A, -1) :-
	x(glucocorticoid, A, 1).
x(acthProduction, A, 1) :-
	x(glucocorticoid, A, -1).
x(glucocorticoid, A, 1) :-
	x(corticoidProduction, A, 1).
x(glucocorticoid, A, 1) :-
	x(dex, A, 1).
x(glucocorticoid, A, -1) :-
	x(dex, A, -1).
x(glucocorticoid, A, 1) :-
	x(acutEdex, A, 1).
x(glucocorticoid, A, -1) :-
	x(acutEdex, A, -1).
x(glucocorticoid, A, 1) :-
	x(chroniCdex, A, 1).
x(glucocorticoid, A, -1) :-
	x(chroniCdex, A, -1).
x(catechole, A, 1) :-
	x(dummy3, A, 1).
x(catechole, A, -1) :-
	x(dummy3, A, -1).
x(dummy3, A, 1) :-
	x(adrx_now, A, -1),
	x(catecholeProd, A, 1).
x(catechole, A, 1) :-
	x(adrx, A, -1).
x(catechole, A, -1) :-
	x(catecholeDisp, A, 1).
x(catecholeProd, A, 1) :-
	x(dummy4, A, 1).
x(catecholeProd, A, -1) :-
	x(dummy4, A, -1).
x(dummy4, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy4, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(catecholeProd, A, -1) :-
	x(guan, A, 1).
x(catecholeProd, A, 1) :-
	x(guan, A, -1).
x(da, A, 1) :-
	x(daProduction, A, 1).
x(da, A, -1) :-
	x(da2Hva, A, 1).
x(da, A, 1) :-
	x(prl, A, 1).
x(da, A, -1) :-
	x(prl, A, -1).
x(daProduction, A, -1) :-
	x(aluminium, A, 1).
x(daProduction, A, 1) :-
	x(aluminium, A, -1).
x(hva, A, 1) :-
	x(dummy5, A, 1).
x(hva, A, -1) :-
	x(dummy5, A, -1).
x(dummy5, A, 1) :-
	x(msg_now, A, -1),
	x(da2Hva, A, 1).
x(hva, A, 1) :-
	x(msg, A, -1).
x(da2Hva, A, -1) :-
	x(parg, A, 1).
x(da2Hva, A, 1) :-
	x(parg, A, -1).
x(glucagon, A, 1) :-
	x(glucagonProd, A, 1).
x(glucagon, A, -1) :-
	x(glucagonDis, A, 1).
x(glucagonProd, A, 1) :-
	x(dummy6, A, 1).
x(glucagonProd, A, -1) :-
	x(dummy6, A, -1).
x(dummy6, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy6, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(glucagonProd, A, -1) :-
	x(guan, A, 1).
x(glucagonProd, A, 1) :-
	x(guan, A, -1).
x(glucagonProd, A, -1) :-
	x(glucose, A, 1).
x(glucagonProd, A, 1) :-
	x(glucose, A, -1).
x(glucagonProd, A, -1) :-
	x(insulin, A, 1).
x(glucagonProd, A, 1) :-
	x(insulin, A, -1).
x(glucose, A, 1) :-
	x(chroniCglucose, A, 1).
x(glucose, A, -1) :-
	x(chroniCglucose, A, -1).
x(glucose, A, 1) :-
	x(fromGut, A, 1).
x(glucose, A, 1) :-
	x(fromLiver, A, 1).
x(glucose, A, -1) :-
	x(brainGlucoseUptake, A, 1).
x(brainGlucoseUptake, A, 1) :-
	x(glucose, A, 1).
x(brainGlucoseUptake, A, -1) :-
	x(glucose, A, -1).
x(glucose, A, -1) :-
	x(toTissue, A, 1).
x(brainGlucose, A, 1) :-
	x(brainGlucoseUptake, A, 1).
x(toTissue, A, 1) :-
	x(temp1, A, 1).
x(toTissue, A, -1) :-
	x(temp1, A, -1).
x(temp1, A, 1) :-
	x(glucose, A, 1).
x(temp1, A, -1) :-
	x(glucose, A, -1).
x(temp1, A, 1) :-
	x(insulin, A, 1).
x(temp1, A, -1) :-
	x(insulin, A, -1).
x(fromLiver, A, 1) :-
	x(temp2, A, 1).
x(fromLiver, A, -1) :-
	x(temp2, A, -1).
x(temp2, A, -1) :-
	x(insulin, A, 1).
x(temp2, A, 1) :-
	x(insulin, A, -1).
x(temp2, A, 1) :-
	x(glucocorticoid, A, 1).
x(temp2, A, -1) :-
	x(glucocorticoid, A, -1).
x(temp2, A, -1) :-
	x(pns, A, 1).
x(temp2, A, 1) :-
	x(pns, A, -1).
x(temp2, A, 1) :-
	x(catechole, A, 1).
x(temp2, A, -1) :-
	x(catechole, A, -1).
x(temp2, A, 1) :-
	x(dummy7, A, 1).
x(temp2, A, -1) :-
	x(dummy7, A, -1).
x(dummy7, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy7, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(temp2, A, 1) :-
	x(guan, A, 1).
x(temp2, A, -1) :-
	x(guan, A, -1).
x(temp2, A, 1) :-
	x(glucagon, A, 1).
x(temp2, A, -1) :-
	x(glucagon, A, -1).
x(brainGlucoseUptake, A, -1) :-
	x(twoDg, A, 1).
x(brainGlucoseUptake, A, 1) :-
	x(twoDg, A, -1).
x(insulin, A, 1) :-
	x(fromPancreas, A, 1).
x(insulin, A, -1) :-
	x(toKidneys, A, 1).
x(toKidneys, A, 1) :-
	x(insulin, A, 1).
x(toKidneys, A, -1) :-
	x(insulin, A, -1).
x(temp3, A, 1) :-
	x(dummy8, A, 1).
x(temp3, A, -1) :-
	x(dummy8, A, -1).
x(dummy8, A, -1) :-
	x(guan_now, A, 1),
	x(sns, A, 1).
x(dummy8, A, 1) :-
	x(guan_now, A, 1),
	x(sns, A, -1).
x(temp3, A, -1) :-
	x(guan, A, 1).
x(temp3, A, 1) :-
	x(guan, A, -1).
x(temp3, A, -1) :-
	x(catechole, A, 1).
x(temp3, A, 1) :-
	x(catechole, A, -1).
x(temp3, A, 1) :-
	x(glucagon, A, 1).
x(temp3, A, -1) :-
	x(glucagon, A, -1).
x(temp3, A, 1) :-
	x(glucose, A, 1).
x(temp3, A, -1) :-
	x(glucose, A, -1).
x(temp3, A, 1) :-
	x(pns, A, 1).
x(temp3, A, -1) :-
	x(pns, A, -1).
x(fromPancreas, A, 1) :-
	x(temp3, A, 1).
x(fromPancreas, A, -1) :-
	x(temp3, A, -1).
x(insulin, A, 1) :-
	x(insulinBolis, A, 1).
x(insulin, A, -1) :-
	x(insulinBolis, A, -1).
x(insulin, A, 1) :-
	x(insulin10, A, 1).
x(insulin, A, -1) :-
	x(insulin10, A, -1).
x(insulin, A, 1) :-
	x(insulin30, A, 1).
x(insulin, A, -1) :-
	x(insulin30, A, -1).
x(insulin, A, 1) :-
	x(chroniCinsulin, A, 1).
x(insulin, A, -1) :-
	x(chroniCinsulin, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut10, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut10, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut20, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut20, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut30, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut30, A, -1).
x(fromPancreas, A, 1) :-
	x(chroniCtolbut, A, 1).
x(fromPancreas, A, -1) :-
	x(chroniCtolbut, A, -1).
x(da, A, -1) :-
	x(neProduction, A, 1).
x(ne, A, 1) :-
	x(dummy9, A, 1).
x(ne, A, -1) :-
	x(dummy9, A, -1).
x(dummy9, A, 1) :-
	x(msg_now, A, -1),
	x(neProduction, A, 1).
x(ne, A, 1) :-
	x(msg, A, -1).
x(ne, A, -1) :-
	x(ne2dhpg, A, 1).
x(ne, A, -1) :-
	x(ne2Epin, A, 1).
x(dhpg, A, 1) :-
	x(dummy10, A, 1).
x(dhpg, A, -1) :-
	x(dummy10, A, -1).
x(dummy10, A, 1) :-
	x(msg_now, A, -1),
	x(ne2dhpg, A, 1).
x(dhpg, A, 1) :-
	x(msg, A, -1).
x(crf, A, 1) :-
	x(dhpg, A, 1).
x(crf, A, -1) :-
	x(dhpg, A, -1).
x(sns, A, 1) :-
	x(dhpg, A, 1).
x(sns, A, -1) :-
	x(dhpg, A, -1).
x(neControl, A, 1) :-
	x(stress, A, 1).
x(neControl, A, -1) :-
	x(stress, A, -1).
x(neControl, A, -1) :-
	x(glucocorticoid, A, 1).
x(neControl, A, 1) :-
	x(glucocorticoid, A, -1).
x(neControl, A, -1) :-
	x(brainGlucose, A, 1).
x(neControl, A, 1) :-
	x(brainGlucose, A, -1).
x(neProduction, A, 1) :-
	x(neControl, A, 1).
x(neProduction, A, -1) :-
	x(neControl, A, -1).
x(ne2dhpg, A, 1) :-
	x(neControl, A, 1).
x(ne2dhpg, A, -1) :-
	x(neControl, A, -1).
x(ne2dhpg, A, 1) :-
	x(ne, A, 1).
x(ne2dhpg, A, -1) :-
	x(ne, A, -1).
x(ne2dhpg, A, -1) :-
	x(aluminium, A, 1).
x(ne2dhpg, A, 1) :-
	x(aluminium, A, -1).
x(ne2Epin, A, 1) :-
	x(ne, A, 1).
x(neProduction, A, 1) :-
	x(hgh, A, 1).
x(neProduction, A, -1) :-
	x(hgh, A, -1).
x(neProduction, A, -1) :-
	x(insulin, A, 1).
x(neProduction, A, 1) :-
	x(insulin, A, -1).
x(stress, A, 1) :-
	x(swimstr, A, 1).
x(stress, A, -1) :-
	x(swimstr, A, -1).
x(stress, A, 1) :-
	x(etherstr, A, 1).
x(stress, A, -1) :-
	x(etherstr, A, -1).
x(neProduction, A, 1) :-
	x(yoh, A, 1).
x(neProduction, A, -1) :-
	x(yoh, A, -1).
x(ne2dhpg, A, -1) :-
	x(parg, A, 1).
x(ne2dhpg, A, 1) :-
	x(parg, A, -1).
x(stress, A, 1) :-
	x(gentle, A, 1).
x(stress, A, -1) :-
	x(gentle, A, -1).
x(neControl, A, -1) :-
	x(diaz, A, 1).
x(neControl, A, 1) :-
	x(diaz, A, -1).
x(neControl, A, -1) :-
	x(chroniCdiaz, A, 1).
x(neControl, A, 1) :-
	x(chroniCdiaz, A, -1).
x(vagus, A, 1) :-
	x(pns, A, 1).
x(vagus, A, -1) :-
	x(pns, A, -1).
x(pns, A, 1) :-
	x(insulin, A, 1).
x(pns, A, -1) :-
	x(insulin, A, -1).
x(pns, A, 1) :-
	x(fiveHIAA, A, 1).
x(pns, A, -1) :-
	x(fiveHIAA, A, -1).
x(pns, A, -1) :-
	x(sns, A, 1).
x(pns, A, 1) :-
	x(sns, A, -1).
x(prlRelease, A, -1) :-
	x(da, A, 1).
x(prlRelease, A, 1) :-
	x(da, A, -1).
x(pPrl, A, -1) :-
	x(da, A, 1).
x(pPrl, A, 1) :-
	x(da, A, -1).
x(pPrl, A, -1) :-
	x(prlRelease, A, 1).
x(prl, A, 1) :-
	x(dummy11, A, 1).
x(prl, A, -1) :-
	x(dummy11, A, -1).
x(dummy11, A, 1) :-
	x(hypox_now, A, -1),
	x(prlRelease, A, 1).
x(prl, A, 1) :-
	x(hypox, A, -1).
x(sateity, A, 1) :-
	x(fiveHIAA, A, 1).
x(sateity, A, -1) :-
	x(fiveHIAA, A, -1).
x(sateity, A, -1) :-
	x(brainGlucose, A, 1).
x(sateity, A, 1) :-
	x(brainGlucose, A, -1).
x(serotonin, A, 1) :-
	x(dummy12, A, 1).
x(serotonin, A, -1) :-
	x(dummy12, A, -1).
x(dummy12, A, 1) :-
	x(msg_now, A, -1),
	x(serotoninProduction, A, 1).
x(serotonin, A, 1) :-
	x(msg, A, -1).
x(serotonin, A, -1) :-
	x(serotoninTOfiveHIAA, A, 1).
x(fiveHIAA, A, 1) :-
	x(serotoninTOfiveHIAA, A, 1).
x(serotoninProduction, A, -1) :-
	x(hgh, A, 1).
x(serotoninProduction, A, 1) :-
	x(hgh, A, -1).
x(serotoninProduction, A, -1) :-
	x(t4, A, 1).
x(serotoninProduction, A, 1) :-
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(t4, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(serotonin, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(serotonin, A, -1).
x(serotoninProduction, A, 1) :-
	x(brainGlucose, A, 1).
x(serotoninProduction, A, -1) :-
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 1) :-
	x(insulin, A, 1).
x(serotoninProduction, A, -1) :-
	x(insulin, A, -1).
x(serotoninProduction, A, 1) :-
	x(pns, A, 1).
x(serotoninProduction, A, -1) :-
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(pns, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(parg, A, -1).
x(serotoninProduction, A, -1) :-
	x(msg, A, 1).
x(serotoninProduction, A, 1) :-
	x(msg, A, -1).
x(sns, A, -1) :-
	x(pns, A, 1).
x(sns, A, 1) :-
	x(pns, A, -1).
x(pHgh, A, -1) :-
	x(ghProduction, A, 1).
x(hgh, A, 1) :-
	x(dummy13, A, 1).
x(hgh, A, -1) :-
	x(dummy13, A, -1).
x(dummy13, A, 1) :-
	x(hypox_now, A, 1),
	x(ghProduction, A, 1).
x(hgh, A, 1) :-
	x(hypox, A, 1).
x(hgh, A, 1) :-
	x(hghInj, A, 1).
x(hgh, A, -1) :-
	x(hghInj, A, -1).
x(ghrh, A, 1) :-
	x(fiveHIAA, A, 1).
x(ghrh, A, -1) :-
	x(fiveHIAA, A, -1).
x(pHgh, A, -1) :-
	x(ghrh, A, 1).
x(pHgh, A, 1) :-
	x(ghrh, A, -1).
x(ghProduction, A, 1) :-
	x(ghrh, A, 1).
x(ghProduction, A, -1) :-
	x(ghrh, A, -1).
x(ghProduction, A, 1) :-
	x(glucose, A, 1).
x(ghProduction, A, -1) :-
	x(glucose, A, -1).
x(pHgh, A, 1) :-
	x(glucose, A, 1).
x(pHgh, A, -1) :-
	x(glucose, A, -1).
x(pHgh, A, -1) :-
	x(srif, A, 1).
x(pHgh, A, 1) :-
	x(srif, A, -1).
x(ghProduction, A, -1) :-
	x(srif, A, 1).
x(ghProduction, A, 1) :-
	x(srif, A, -1).
x(srif, A, 1) :-
	x(crf, A, 1).
x(srif, A, -1) :-
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(crf, A, 1),
	x(hypox, A, 1).
x(acthProduction, A, 0) :-
	x(crf, A, 1),
	x(glucocorticoid, A, 1).
x(acthProduction, A, 0) :-
	x(hypox, A, -1),
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(hypox, A, -1),
	x(glucocorticoid, A, 1).
x(cortisolProduction, A, 0) :-
	x(acth, A, 1),
	x(dummy1, A, -1).
x(cortisolProduction, A, 0) :-
	x(acth, A, 1),
	x(guan, A, 1).
x(cortisolProduction, A, 0) :-
	x(dummy1, A, 1),
	x(acth, A, -1).
x(cortisolProduction, A, 0) :-
	x(dummy1, A, 1),
	x(guan, A, 1).
x(cortisolProduction, A, 0) :-
	x(guan, A, -1),
	x(acth, A, -1).
x(cortisolProduction, A, 0) :-
	x(guan, A, -1),
	x(dummy1, A, -1).
x(cortisol, A, 0) :-
	x(dummy2, A, 1),
	x(corticoidProduction, A, 1).
x(cortisol, A, 0) :-
	x(adrx, A, -1),
	x(dummy2, A, -1).
x(cortisol, A, 0) :-
	x(adrx, A, -1),
	x(corticoidProduction, A, 1).
x(acthProduction, A, 0) :-
	x(glucocorticoid, A, -1),
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(glucocorticoid, A, -1),
	x(hypox, A, 1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(acutEdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(dex, A, 1),
	x(acutEdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(dex, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(acutEdex, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(acutEdex, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(chroniCdex, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(chroniCdex, A, 1),
	x(acutEdex, A, -1).
x(catechole, A, 0) :-
	x(dummy3, A, 1),
	x(catecholeDisp, A, 1).
x(catechole, A, 0) :-
	x(adrx, A, -1),
	x(dummy3, A, -1).
x(catechole, A, 0) :-
	x(adrx, A, -1),
	x(catecholeDisp, A, 1).
x(catecholeProd, A, 0) :-
	x(dummy4, A, 1),
	x(guan, A, 1).
x(catecholeProd, A, 0) :-
	x(guan, A, -1),
	x(dummy4, A, -1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(da2Hva, A, 1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(prl, A, -1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(neProduction, A, 1).
x(da, A, 0) :-
	x(prl, A, 1),
	x(da2Hva, A, 1).
x(da, A, 0) :-
	x(prl, A, 1),
	x(neProduction, A, 1).
x(hva, A, 0) :-
	x(msg, A, -1),
	x(dummy5, A, -1).
x(glucagon, A, 0) :-
	x(glucagonProd, A, 1),
	x(glucagonDis, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(glucose, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(glucose, A, 1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(glucose, A, 1).
x(glucose, A, 0) :-
	x(chroniCglucose, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(chroniCglucose, A, 1),
	x(toTissue, A, 1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(chroniCglucose, A, -1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(toTissue, A, 1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(chroniCglucose, A, -1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(toTissue, A, 1).
x(brainGlucoseUptake, A, 0) :-
	x(glucose, A, 1),
	x(twoDg, A, 1).
x(temp1, A, 0) :-
	x(glucose, A, 1),
	x(insulin, A, -1).
x(temp1, A, 0) :-
	x(insulin, A, 1),
	x(glucose, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(guan, A, -1).
x(brainGlucoseUptake, A, 0) :-
	x(twoDg, A, -1),
	x(glucose, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(chroniCinsulin, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(glucose, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(chroniCtolbut, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulin30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut30, A, -1).
x(ne, A, 0) :-
	x(dummy9, A, 1),
	x(ne2dhpg, A, 1).
x(ne, A, 0) :-
	x(dummy9, A, 1),
	x(ne2Epin, A, 1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(dummy9, A, -1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(ne2dhpg, A, 1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(ne2Epin, A, 1).
x(dhpg, A, 0) :-
	x(msg, A, -1),
	x(dummy10, A, -1).
x(sns, A, 0) :-
	x(dhpg, A, 1),
	x(pns, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(chroniCdiaz, A, 1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(insulin, A, 1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(yoh, A, -1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(aluminium, A, 1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(parg, A, 1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(aluminium, A, 1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(parg, A, 1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(parg, A, 1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(insulin, A, 1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(yoh, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(yoh, A, -1).
x(stress, A, 0) :-
	x(swimstr, A, 1),
	x(etherstr, A, -1).
x(stress, A, 0) :-
	x(swimstr, A, 1),
	x(gentle, A, -1).
x(stress, A, 0) :-
	x(etherstr, A, 1),
	x(swimstr, A, -1).
x(stress, A, 0) :-
	x(etherstr, A, 1),
	x(gentle, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(insulin, A, 1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(aluminium, A, 1).
x(stress, A, 0) :-
	x(gentle, A, 1),
	x(swimstr, A, -1).
x(stress, A, 0) :-
	x(gentle, A, 1),
	x(etherstr, A, -1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(diaz, A, 1).
x(pns, A, 0) :-
	x(insulin, A, 1),
	x(fiveHIAA, A, -1).
x(pns, A, 0) :-
	x(insulin, A, 1),
	x(sns, A, 1).
x(pns, A, 0) :-
	x(fiveHIAA, A, 1),
	x(insulin, A, -1).
x(pns, A, 0) :-
	x(fiveHIAA, A, 1),
	x(sns, A, 1).
x(pns, A, 0) :-
	x(sns, A, -1),
	x(insulin, A, -1).
x(pns, A, 0) :-
	x(sns, A, -1),
	x(fiveHIAA, A, -1).
x(pPrl, A, 0) :-
	x(da, A, -1),
	x(prlRelease, A, 1).
x(prl, A, 0) :-
	x(hypox, A, -1),
	x(dummy11, A, -1).
x(sateity, A, 0) :-
	x(fiveHIAA, A, 1),
	x(brainGlucose, A, 1).
x(sateity, A, 0) :-
	x(brainGlucose, A, -1),
	x(fiveHIAA, A, -1).
x(serotonin, A, 0) :-
	x(dummy12, A, 1),
	x(serotoninTOfiveHIAA, A, 1).
x(serotonin, A, 0) :-
	x(msg, A, -1),
	x(dummy12, A, -1).
x(serotonin, A, 0) :-
	x(msg, A, -1),
	x(serotoninTOfiveHIAA, A, 1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(msg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(parg, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(msg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(pns, A, -1).
x(sns, A, 0) :-
	x(pns, A, -1),
	x(dhpg, A, -1).
x(hgh, A, 0) :-
	x(dummy13, A, 1),
	x(hghInj, A, -1).
x(hgh, A, 0) :-
	x(hypox, A, 1),
	x(dummy13, A, -1).
x(hgh, A, 0) :-
	x(hypox, A, 1),
	x(hghInj, A, -1).
x(hgh, A, 0) :-
	x(hghInj, A, 1),
	x(dummy13, A, -1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(glucose, A, -1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(srif, A, 1).
x(ghProduction, A, 0) :-
	x(ghrh, A, 1),
	x(glucose, A, -1).
x(ghProduction, A, 0) :-
	x(ghrh, A, 1),
	x(srif, A, 1).
x(ghProduction, A, 0) :-
	x(glucose, A, 1),
	x(ghrh, A, -1).
x(ghProduction, A, 0) :-
	x(glucose, A, 1),
	x(srif, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(ghrh, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(srif, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(ghrh, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(glucose, A, -1).
x(ghProduction, A, 0) :-
	x(srif, A, -1),
	x(ghrh, A, -1).
x(ghProduction, A, 0) :-
	x(srif, A, -1),
	x(glucose, A, -1).



