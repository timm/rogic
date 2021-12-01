
*[companyProfits,corporateSpending, crimeRate,
 domesticSales, foriegnSales, inflation,
 investorConfidence, publicConfidence,
 savings, wagesRestraint].

*companyProfits    ++ corporateSpending.
*companyProfits    ++ inflation.
*corporateSpending ++ investorConfidence.
*corporateSpending -- wagesRestraint.
*crimeRate         -- publicConfidence.
*domesticSales     ++ companyProfits.
*foriegnSales      ++ companyProfits.
*foriegnSales      ++ publicConfidence.
*inflation         ++ wagesRestraint.
*inflation         -- wagesRestraint.
*publicConfidence  ++ savings.
*publicConfidence  -- inflation.

*rx                 = [[domesticSales],[foriegnSales]].
*companyProfits     = [0,               10].
*investorConfidence = [0,               10].
*wagesRestraint     = [0,               10].

*done.
