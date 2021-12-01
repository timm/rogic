% the following line allows long strings
:- style_check(-atom).
%
 
concCon isa sPort
but 	[aka = "Concluded CONTRACT"].

fAccept isa sPort 
but	[aka	= "Effective ACCEPTANCE"
	,ask	= "Is there an effective acceptance in law ?"
	,why	= [23]
	,say	= "If you select uncertain as your			
	               answer, you will be led through a series
		       of questions which will establish whether
		       or not there is an effective acceptance in
		       your case."
	].

fOffer isa sPort 
but	[aka	= "Effective OFFER"
	,ask	= "Is there an effective offer in law ?"
	,why	= [14.1,15.1, 14.21] % should this last one be here?
	,say	= "If you select uncertain as your
		      answer, you will be led through a series
		      of questions which will establish whether
	    	      or not there is an effective offer in your 
	              case"	% i worry about this kinda 
				% control knowledge here
	].


offerees isa sPort 
but	[aka = "OFFEREE(S)"
	,ask = "Is there at least one offeree ?"
	,why = [14.1, 15.1]
	].

offerors isa sPort
but	[aka = "OFFEROR(S)"
	,ask = "Is there at least one offeror ?"
	,why= [14.1,15.1]
	]. 

persons isa sPort 
but	[aka 	= "PERSONS"
	,ask 	= "Are there at least two persons who are 
                   parties to the transaction?"
	,why 	= [14.1,14.2]
	].

prelim isa words 
but	[say = "It is assumed that you are investigating 
		a real or hypothetical transaction in order
		to determine whether or not:
		**	There is a contract for the  international
			sale of goods
		**	Parties to the transaction have rights
			obligations or remedies under the United 
			Nations Convention on Contracts for the 
			International Sale of Goods."
	].

oneOffer isa sPort 
but	[aka = "ONE offeror"
	,ask = "Is there one offeror only ?"
 	].
manyOffer isa sPort 
but	[aka = "MORE THAN ONE offeror"
	,ask = "Is there more than one offeror ?"
	,say = "** If there is more than one offeror,
		      you will need to process the case
		      for each offeror separately.
		   ** If the case for each offeror is 
		      identical, then the processing of one 
		      offeror's case will apply to all offerors."].

oneOfferee isa sPort 
but	[aka = "ONE offeree"
	,ask = "Is there one offeree only?"
	,why = [14.1, 14.2]
	].

manyOfferee isa sPort 
but	[aka = "MORE THAN ONE offeree"
	,ask = "Is there more than one offeree ?"
	,say = "For all offerees who are concerned in the
		   transaction: 
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
		      group applies to all in the group."
	].		

oProposed isa sPort
but	[aka = "PROPOSAL by offeror(s)"
	,ask = "Is there a proposal by the offeror for 
		  concluding a contract?"
	,why= [14.1]
	].	

oAddressed isa  sPort 
but	[aka = "ADDRESSED to offeree(s)"
	,why = [14.1]
	,ask = "Is the proposal addressed to the offeree (s) ?"
	,say = "If the proposal is addressed to more than
		   one offeree then one, some or all of these 
		   offerees may respond to it."
	].

suffDef isa sPort 
but	[aka =  "sufficiently DEFINITE"
	,why = [14.1]
	,say = "If you select uncertain as your answer,
		  you will be led through a series of 
		  questions which will establish whether
		  or not the proposal is sufficiently definite."
	].

boundIntent isa sPort 
but	[aka = "INTENTION to be bound"
	,why = [14.1]
	,ask = "Does the proposal indicate that the offeror 
		  intends to be bound by it on its acceptance ?"
	].


rPropose isa report 
but	[thing2test = foffer
	,ifNotYes =  "The proposal for concluding a contract is not 
                      an offer in law. Do you wish to continue your 
                      instructions as if there was an offer in law ?"
			% an instruction to the assumption controller
	,ifYes   = "The proposal for concluding a contract is an offer 
		    in law. Further questioning will establish if the 
		    offer is effective and open for acceptance."
	].

oReaches isa sPort 
but	[aka = "REACHES offeree(s)"	
	,ask = "Has the offer reached the offeree ?"
	,why = [15.1,24]
	,say = "If you select uncertain as your answer,
		   you will be led through a series of 
		   questions which will establish whether
		   or not the offer has reached the offeree."
	].

open isa sPort 
but	[aka 	  = "OPEN"
	,ask 	  = "Was the offer open at the time of acceptance ?"
	,why 	  = [15.1,15.2,16.1,16.2,17,18.2,18.3,19.1,19.2,
			19.3,20.1,20.2,21.1,21.2]
	,say      = "If you select uncertain as your answer,					       
		     you will be led through a series of 						
		     questions which will establish whether					        
		     or not the offer was open at the time of					        
		     acceptance.  All of these questions require 					
	             an answer by reference to the 
		     circumstances at the time of the actual or
		     hypothetical acceptance in your case."
	].

oneP isa sPort 
but	[aka= "ONE proposal"
	,why = [14.2,19]
	,ask = "Was there only one proposal for concluding a contract ?"].

nP isa sPort 
but	[aka= "SERIES of proposals"
	,why = [14.2, 19]
	,ask = "Was there a series of proposals for concluding a contract ?"
	].

series isa words
but	[say = "If there are negotiations between the parties, 
		there may be any number of any of the following:
		** 	invitation to make an offer
		**	initial offer
		**	counter offer
		** 	enquiry to clarify an offer"
	,why = [14,19]
	].

oInvites isa neuPort % why these neuports?
but	[aka = "INVITATION(S) to make offers"
	,ask = "Was there any invitation to make an offer?"
	,why = [14.2, 19]
	].		

oInitial isa neuPort 
but	[aka=	"INITIAL OFFER"
	,ask=	"Was there an initial offer ?"
	,why=	[14,19]
	].

oCounter isa neuPort
but 	[aka = "COUNTER-OFFER(S)"
	,ask = "Was there any counter-offer ?"
	,why = [14.2, 19]
	].

oInquiry isa neuPort
but	[aka = "INQUIRY"
	,ask = "Was there any inquiry to clarify the offer?"
	,why = hypo	% add this to the help file
	].

oFinal isa sPort
but	[aka=	"FINAL OFFER"
	,ask=	"Was there a final offer ?"
	,why =	[14,19]
	].

specificPerson  isa sPort
but	[aka = "specific person"
	,ask = "Was the offer addressed to a specific person?"
	,why = [14]
	].

specificPersons isa sPort
but	[ask = "Was the offer addressed to specific persons?"
	,aka = "specific persons"
	,why = [14]
	].

nonSpecificPersons isa sPort
but	[ask = "Was the offer addressed to non-specific persons?"
	,aka= "non-specific persons"
	,why= [14]
	].

iOffer isa words
but	[why = [14.2]
	,say = "A proposal for concluding a contract which is
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
	].

oIntend  isa sPort
but	[aka= "INTENDED as an offer"
	,ask= "Was the offer to non-specific persons indended as an
	       offer to them?"
	,why= [14]
	].
         
/*
z1_helix_3_"sufficiently DEFINITE'	 has		
      [start='INDICATES GOODS'		Does the offer sufficiently indicate the
						goods ?					jpos=yes	Article: 14 (1)
%details of goods=wormhole+
       say: 'An effective offer must contain details of the goods in one of the following ways:		Article: 14 (1)
			
		. By expressly fixing the quantity and price of the goods.
		. By implicitly fixing the quantity and price of the goods.
		. By expressly making provision for determining the quantity and price of the goods.
		. By implicitly making provision for determining the quantity and price of the goods.

There is a choice of  implicit or explicit 
There is a choice of  fixing or making provision for


      ,path= 'DETAILS of goods'		Does the offer expressly fix the quantity
						and price of the goods ?			jpos=yes       	Article: 14 (1)
	    					Does the offer implicitly fix the quantity
						and price of the goods ?			jpos=yes        Article: 14 (1)
						Does the offer expressly make provision 	
						for determining the quantity and price of 
						the goods ?					jpos=yes   	Article: 14 (1)
						Does the offer implicitly make provision 	
						for determining the quantity and price of 
						the goods ?					jpos=yes	Article: 14 (1)

      ,stop='sufficiently DEFINITE'										Article: 14 (1)

------------------------------------------------------------------------------------------------------------------

% Questions are not identical to graph which should show:

z1_helix_3_'DETAILS of GOODS'
STATES
DETERMINATION
QUANTITY
PRICE

z2_doublehelix_5_'STATES' has
% 2 fans_mutex
     [fan1='EXPRESSLY'
       fan2='IMPLIEDLY'

z2_doublehelix_5_'DETERMINATION' has
%2 fans_mutex
     [fan1 fixes
      fan2 makes provision for determining


----------------------------------------------------------
									
? z1_helix_2_'INTENTION to be bound' has














3
'REACHES offeree(s)'												Article: 14 (1), 15
			made orally to offeree(s)
			delivered by non-oral means 
				to offeree(s) personally
				to offeree(s) place of business
				to offeree(s) mailing address
				4d option (no place of business and no mailing address) to habitual residence    				

3
'OPEN'
	lasting  
	  revocable, not revoked in time/irrevocable, 
	  not lapsed
	  in specified time 
		reasonable time
		not withdrawn
		by withdrawal reaching offeree(s) before offer
		by withdrawal reaching offeree(s) at the same time as offer
	not rejected
		rejection reaches offeror
		by counteroffer made with
			terms
		           	   additions
		              different provisions
			    limitations
			    other modifications
		material alteration to
                       	    price
			    payment
			    goods
				quality
				quantity
             		    delivery
                                           place
			            time 
	 		    extent of liability
			    settlement of disputes
			    other provisions of the offer
															

'LASTING' has


helix_2_'EFFECTIVE ACCEPTANCE' has		
      [start=behaviour of offeree
	     statement/other conduct indicating assent to binding offer					Article 14 (1),15, 23
      ,path=['REACHES OFFEROR'
		      made orally to offeror(s)
		      delivered by non-oral means 
				to offeree(s) personally
				to offeree(s) place of business
				to offeree(s) mailing address
				4d option (no place of business and no mailing address) to habitual residence    		
           		, not withdrawn]	                    				 				Article 14 (1), Article 1
                           before 
                           at same time
      ,stop=effective acceptance].										Article 14 (1), Article 15
	

























Secondary Stream - negotiation-neutral=fan of 4 rivers with
	[fan=1
	[start=invitation to treat]
	[fan=2
	[start=lapsed offer]
	[fan=3
	[start=revoked offer]
	[fan=4
	[start=rejected offer]
	,stop=negotiation-neutral].

Tertiary Stream 

Tertiary Stream - lapsed offer=river with
	[start=offer
	,stop=lapsed offer
	,path=
	].

Tertiary Stream - revoked offer=river with
	[start=offer
	,stop=revoked offer
	,path=
	].

Tertiary Stream - rejected offer=river with
	[start=offer
	,stop=rejected offer
	,path=
	].
												neutral-4d 
	      'FINALITY']									(if for concluding 
												a contract is not yes)
												jneg-yes



{PAGE|18}


*/