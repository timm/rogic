
 
*crf  ++  acthProduction.
*acthProduction  +-+  acth.
*hypox  --  acthProduction.
*acth  ++  cortisolProduction. 
*if no guan then   sns  ++  cortisolProduction.
*if no adrx then cortisolProduction  +-+  cortisol.
*corticoidProduction  +--  cortisol.
*glucocorticoid  --  acthProduction.
*corticoidProduction  +-+  glucocorticoid.
*dex  ++  glucocorticoid.
*acutEdex  ++  glucocorticoid.
*chroniCdex  ++  glucocorticoid.
*if no adrx then catecholeProd  +-+  catechole.
*catecholeDisp  +--  catechole.
*if no guan then sns  ++  catecholeProd.
*daProduction  +-+  da.
*da2Hva  +--  da.
*prl  ++  da.
*aluminium  --  daProduction.
*if no msg then da2Hva  +-+  hva.
*parg  --  da2Hva.
*glucagonProd  +-+  glucagon.
*glucagonDis  +--  glucagon.
*if no guan then sns  ++  glucagonProd.
*glucose  --  glucagonProd.
*insulin  --  glucagonProd.
*chroniCglucose  ++  glucose.
*fromGut  +-+  glucose.
*fromLiver  +-+  glucose.
*brainGlucoseUptake  +--  glucose.
*glucose  ++  brainGlucoseUptake.
*toTissue  +--  glucose.
*brainGlucoseUptake  +-+  brainGlucose.
*temp1  ++  toTissue.
*glucose  ++  temp1.
*insulin  ++  temp1.
*temp2  ++  fromLiver.
*insulin  --  temp2.
*glucocorticoid  ++  temp2.
*pns  --  temp2.
*catechole  ++  temp2.
*if no guan then sns  --  temp2.
*glucagon  ++  temp2.
*twoDg  --  brainGlucoseUptake.
*fromPancreas  +-+  insulin.
*toKidneys  +--  insulin.
*insulin  ++  toKidneys.
*if guan then  sns  --  temp3.
*catechole  --  temp3.
*glucagon  ++  temp3.
*glucose  ++  temp3.
*pns  ++  temp3.
*temp3  ++  fromPancreas.
*insulinBolis  ++  insulin.
*insulin10  ++  insulin.
*insulin30  ++  insulin.
*chroniCinsulin  ++  insulin.
*tolbut10  ++  fromPancreas.
*tolbut20  ++  fromPancreas.
*tolbut30  ++  fromPancreas.
*chroniCtolbut  ++  fromPancreas.
*neProduction  +--  da.
*if no msg then neProduction  +-+  ne.
*ne2dhpg  +--  ne.
*ne2Epin  +--  ne.
*if no msg then   ne2dhpg  +-+  dhpg.
*dhpg  ++  crf.
*dhpg  ++  sns.
*stress  ++  neControl.
*glucocorticoid  --  neControl.
*brainGlucose  --  neControl.
*neControl  ++  neProduction.
*neControl  ++  ne2dhpg.
*ne  ++  ne2dhpg.
*aluminium  --  ne2dhpg.
*ne  +-+  ne2Epin.
*hgh  ++  neProduction.
*insulin  --  neProduction.
*swimstr  ++  stress.
*etherstr  ++  stress.
*yoh  ++  neProduction.
*parg  --  ne2dhpg.
*gentle  ++  stress.
*diaz  --  neControl.
*chroniCdiaz  --  neControl.
*pns  ++  vagus.
*insulin  ++  pns.
*fiveHIAA  ++  pns.
*sns  --  pns.
*da  --  prlRelease.
*da  --  prl.
*prlRelease  +--  prl.
*if no hypox then prlRelease  +-+  prl.
*fiveHIAA  ++  sateity.
*brainGlucose  --  sateity.
*if no msg then serotoninProduction  +-+  serotonin.
*serotoninTOfiveHIAA  +--  serotonin.
*serotoninTOfiveHIAA  +-+  fiveHIAA.
*hgh  --  serotoninProduction.
*t4  --  serotoninProduction.
*t4  ++  serotoninTOfiveHIAA.
*serotonin  ++  serotoninTOfiveHIAA.
*brainGlucose  ++  serotoninProduction.
*insulin  ++  serotoninProduction.
*pns  ++  serotoninProduction.
*pns  ++  serotoninTOfiveHIAA.
*parg  --  serotoninTOfiveHIAA.
*msg  --  serotoninProduction.
*pns  --  sns.
*ghProduction  +--  pHgh.
*if hypox then  ghProduction  +-+  hgh.
*hghInj  ++  hgh.
*fiveHIAA  ++  ghrh.
*ghrh  --  pHgh.
*ghrh  ++  ghProduction.
*glucose  ++  ghProduction.
*glucose  ++  pHgh.
*srif  --  pHgh.
*srif  --  ghProduction.
*crf  ++  srif.

[rx= [[], [msg], [diaz], [guan], [parg], [hypox], [twoDg], [acutEdex],
 [gentle],[chroniCdex], [swimstr ], [  etherstr ], [  ptu,  yoh ], [  tolbut10 ],
 [  tolbut20 ], [  insulin10 ], [  insulin30 ], [  msg,  parg ], [  chroniCtolbut ],
[  chroniCglucose ], [  chroniCinsulin ], [  gentle , yoh ], [  guan , twoDg ],
 [ptu , swimstr ], [  ptu,  etherstr ], [  diaz,  chroniCdiaz ], [  hypox , hghInj ],
[  acutEdex , swimstr ], [chroniCdex , swimstr ], [  chroniCglucose , chroniCtolbut]]

,da=[10,5,10,-,20,10,10,-,-,-,10,15,-,9,10,-,-,20,10,7,10,-,-,10,10,10,10,-,-,10]
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

