
*[
foreignSales,
publicConfidence,
inflation,
wagesRestraint,
currentAccountBalance,
corporateSpending, 
companyProfits,
domesticSales,
tradeDeficit,
investorConfidence
].
*foreignSales      ++ publicConfidence.
*domesticSales     ++ companyProfits.
*foreignSales      ++ companyProfits.
*publicConfidence  -- inflation.
*inflation         -- wagesRestraint.
*companyProfits    ++ corporateSpending.
*corporateSpending -- wagesRestraint.
*corporateSpending ++ investorConfidence.
*corporateSpending ++ currentAccountBalance.
*tradeDeficit      -- currentAccountBalance.
*tradeDeficit      -- investorConfidence.

*rx                 = [[domesticSales],[foriegnSales]].
*companyProfits     = [0,               10].
*investorConfidence = [0,               10].
*wagesRestraint     = [0,               10].

*done.
