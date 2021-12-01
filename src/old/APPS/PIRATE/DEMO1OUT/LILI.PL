% Pirate, a small OO case tool (Version 0.1)
% Application ... lili.pl
% Author ........ timm
% Source ........ demos/lili
% Date .......... 01/03/98 (Sunday)

:- ['/home/timm/apps/pirate/pout/bin/pirate.pl'].
:- style_check(-atom).

:- viewpoint(isc(0.1)/timm).
 
&something be &something.
&type      be &something
	   does :test are of boolean.   % test applies the rule symbol

&boolean   be &type.
&string    be &type.
&atom      be &type.
&number    be &type.
&date      be &type.
&time      be &type.
 
&triad be &something
	has :range are in (yes,no)
	has :pos=yes.

&jpos    be &triad.
&jneg    be &triad but :pos=no.
&neutral be &triad.

&portHole be &something
	has :aka	are of &string
	has :ask	are of &string
        has :why        are of &string
	has :say	are of &string
	has :triad	are of &triad.

% standard port is a jpos porthole. defined for convenience.

&sPort   be &portHole 
	 has :triad     are of &jpos. 	
&neuPort be &portHole 
	 has :triad     are of &neutral.
&nPort   be &portHole 
         has :triad     are of &jneg.

&words be &something
	has :say
	has :why.

&report be &something
	has :thing2test
        has :ifYes = ""
        has :ifNo  = ""
        has :ifMaybe = ""
        has :ifNotYes = "".

&rule be &something
	has :head
	has :body.
 
&concCon 	if say(&prelim) and &persons and &fOffer and &fAccept.
&persons 	if &offerors and &offerees.
&offerors 	if &oneOffer or &manyOffer.
&offerees  	if &oneOfferee or &manyOfferee.
&fOffer 	if &oProposed and &oAddressed and &suffDef and &boundIntent
		   and report(&rPropose) and &oReaches and &open 
		   and &concCon. % included for testing
&oProposed	if &oneP or &series.
&series		if (&oInvites or &oInitial or &oCounter or &oInquiry) and
                    &oFinal.
&oAddressed	if &specificPerson or &specificPersons or &nonSpecificPersons
			and say(&iOffer) and oIntend.
 
&concCon = &sPort
	but :aka = "Concluded CONTRACT"
.
&fAccept = &sPort 
  but	:aka	= "Effective ACCEPTANCE"
  but	:ask	= "Is there an effective acceptance in law ?"
  but	:why	= [23]
  but	:say	= "If you select uncertain as your			
	               answer, you will be led through a series
		       of questions which will establish whether
		       or not there is an effective acceptance in
		       your case."
.
&fOffer = &sPort 
  but	:aka	= "Effective OFFER"
  but	:ask	= "Is there an effective offer in law ?"
  but	:why	= [14.1,15.1, 14.21] % should this last one be here?
  but	:say	= "If you select uncertain as your
		      answer, you will be led through a series
		      of questions which will establish whether
	    	      or not there is an effective offer in your 
	              case"	% i worry about this kinda 
				% control knowledge here
.
&offerees = &sPort 
  but	:aka = "OFFEREE(S)"
  but	:ask = "Is there at least one offeree ?"
  but	:why = [14.1, 15.1]
.
&offerors = &sPort
  but	:aka = "OFFEROR(S)"
  but	:ask = "Is there at least one offeror ?"
  but	:why= [14.1,15.1]
.
&persons = &sPort 
  but	:aka 	= "PERSONS"
  but	:ask 	= "Are there at least two persons who are 
                   parties to the transaction?"
  but	:why 	= [14.1,14.2]
.
&prelim = &words 
  but	:say = "It is assumed that you are investigating 
		a real or hypothetical transaction in order
		to determine whether or not: {
		**	There is a contract for the  international
			sale of goods
		**	Parties to the transaction have rights
			obligations or remedies under the United 
			Nations Convention on Contracts for the 
			International Sale of Goods. 
	        }"
.
&oneOffer = &sPort 
  but	:aka = "ONE offeror"
  but	:ask = "Is there one offeror only ?"
.
&manyOffer = &sPort 
  but	:aka = "MORE THAN ONE offeror"
  but	:ask = "Is there more than one offeror ?"
  but	:say = "{** If there is more than one offeror,
		      you will need to process the case
		      for each offeror separately.
		   ** If the case for each offeror is 
		      identical, then the processing of one 
		      offeror's case will apply to all offerors.}"
.
&oneOfferee = &sPort 
  but	:aka = "ONE offeree"
  but	:ask = "Is there one offeree only?"
  but	:why = [14.1, 14.2]
.
&manyOfferee = &sPort 
  but	:aka = "MORE THAN ONE offeree"
  but	:ask = "Is there more than one offeree ?"
  but	:say = "For all offerees who are concerned in the
		   transaction: {
		   ** If there is more than one offeree,
		      you will need to process the case for
		      each offeree separately.
		   ** If the case for each offeree is identical,
		      then the processing of one offeree's 
		      case will apply to all offerees. 
		   ** If there is more than one offeror, then
		      the processing required is for each
		      offeree in relation to each offeror
		      separately. 
		   ** Where there are identical cases for a 
		      group of offerors and/or a group of 
		      offerees, processing for one of the 
		      group applies to all in the group.}"
.		
&oProposed = &sPort
  but	:aka = "PROPOSAL by offeror(s)"
  but	:ask = "Is there a proposal by the offeror for 
		  concluding a contract?"
  but	:why= [14.1]
.	
&oAddressed =  &sPort 
  but	:aka = "ADDRESSED to offeree(s)"
  but	:why = [14.1]
  but	:ask = "Is the proposal addressed to the offeree (s) ?"
  but	:say = "If the proposal is addressed to more than
		   one offeree then one, some or all of these 
		   offerees may respond to it."
.
&suffDef = &sPort 
  but	:aka =  "sufficiently DEFINITE"
  but	:why = [14.1]
  but	:say = "If you select uncertain as your answer,
		  you will be led through a series of 
		  questions which will establish whether
		  or not the proposal is sufficiently definite."
.
&boundIntent = &sPort 
  but	:aka = "INTENTION to be bound"
  but	:why = [14.1]
  but	:ask = "Does the proposal indicate that the offeror 
		  intends to be bound by it on its acceptance ?"
.
&rPropose = &report 
  but	:thing2test = foffer
  but	:ifNotYes =  "The proposal for concluding a contract is not 
                      an offer in law. Do you wish to continue your 
                      instructions as if there was an offer in law ?"
			% an instruction to the assumption controller
  but	:ifYes   = "The proposal for concluding a contract is an offer 
		    in law. Further questioning will establish if the 
		    offer is effective and open for acceptance."
.
&oReaches = &sPort 
  but	:aka = "REACHES offeree(s)"	
  but	:ask = "Has the offer reached the offeree ?"
  but	:why = [15.1,24]
  but	:say = "If you select uncertain as your answer,
		   you will be led through a series of 
		   questions which will establish whether
		   or not the offer has reached the offeree."
.
&open = &sPort 
  but	:aka 	  = "OPEN"
  but	:ask 	  = "Was the offer open at the time of acceptance ?"
  but	:why 	  = [15.1,15.2,16.1,16.2,17,18.2,18.3,19.1,19.2,
			19.3,20.1,20.2,21.1,21.2]
  but	:say      = "If you select uncertain as your answer, 
		     you will be led through a series of 	
                     or not the offer was open at the time of	    
		     acceptance.  All of these questions require
		     circumstances at the time of the actual or
		     hypothetical acceptance in your case."
.
&oneP = &sPort 
  but	:aka= "ONE proposal"
  but	:why = [14.2,19]
  but	:ask = "Was there only one proposal for concluding a contract ?"
.
&nP = &sPort 
  but	:aka= "SERIES of proposals"
  but	:why = [14.2, 19]
  but	:ask = "Was there a series of proposals for concluding a contract ?"
.
&series = &words
  but	:say = "If there are negotiations between the parties, 
		there may be any number of any of the following: {
		** 	invitation to make an offer
		**	initial offer
		**	counter offer
		** 	enquiry to clarify an offer.}"
  but	:why = [14,19]
.
&oInvites = &neuPort % why these neuports?
  but	:aka = "INVITATION(S) to make offers"
  but	:ask = "Was there any invitation to make an offer?"
  but	:why = [14.2, 19]
.		
&oInitial = &neuPort 
  but	:aka=	"INITIAL OFFER"
  but	:ask=	"Was there an initial offer ?"
  but	:why=	[14,19]
.
&oCounter = &neuPort
  but 	:aka = "COUNTER-OFFER(S)"
  but	:ask = "Was there any counter-offer ?"
  but	:why = [14.2, 19]
.
&oInquiry = &neuPort
  but	:aka = "INQUIRY"
  but	:ask = "Was there any inquiry to clarify the offer?"
  but	:why = hypo	% add this to the help file
 .
&oFinal = &sPort
  but	:aka=	"FINAL OFFER"
  but	:ask=	"Was there a final offer ?"
  but	:why =	[14,19]
.
&specificPerson  = &sPort
  but	:aka = "specific person"
  but	:ask = "Was the offer addressed to a specific person?"
  but	:why = [14]
.
&specificPersons = &sPort
  but	:ask = "Was the offer addressed to specific persons?"
  but	:aka = "specific persons"
  but	:why = [14]
.
&nonSpecificPersons = &sPort
  but	:ask = "Was the offer addressed to non-specific persons?"
  but	:aka= "non-specific persons"
  but	:why= [14]
.
&iOffer = &words
  but	:why = [14.2]
  but	:say = "A proposal for concluding a contract which is
               addressed to non-specific persons is prima facie an
               invitation to make an offer unless it can be shown that
               the proposer intended that it be an offer. WARNING: 
               The Convention does not clearly state
               that a proposal which is made to specific and
               non-specific persons is prima facie an invitation to
               make an offer. In this hybrid case, all the
               circumstances should be considered to discover the
               intention of the offeror, which will be one of the
               following: There is an offer to all the specfic and
               non-specific offerees.  There is an invitation to make
               an offer to all the specific and non-specific invitees.
               There is an offer to specific offerees and an
               invitation to make offers to non-specific invitees.
               (rare) There is an invitation to make offers to the
               specific invitees and an offer to the non-specific
               offerees."
.
&oIntend  = &sPort
  but	:aka= "INTENDED as an offer"
  but	:ask= "Was the offer to non-specific persons indended as an
	       offer to them?"
  but	:why= [14]
.
 
