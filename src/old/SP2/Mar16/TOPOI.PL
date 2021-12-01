 known = [ age_lessThen_7
         , infant
 	, legally_responsible
	, moron
	, motives
	, means
	, opportunity
	, witness
	, guilty
	, jail].

if infant or moron                               then not legally_responsible.
if guilty                                        then jail.
if age_lessThen_7                                then infant.
if motives and means and opportunity and witness then guilty.
if guilty and not legally_responsible            then not jail.


