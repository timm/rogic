%<
(s(prec,Prec) ;s(flex,Flex) ;s(arch,Arch)
;s(team,Team) ;s(pmat,Pmat) ;s(rely,Rely)
;s(data,Data) ;s(cplx,Cplx) ;s(ruse,Ruse)
;s(docu,Docu) ;s(time,Time) ;s(stor,Stor)
;s(pvol,Pvol) ;s(acap,Acap) ;s(pcap,Pcap)
;s(pcon,Pcon) ;s(aexp,Aexp) ;s(pexp,Pexp)
;s(ltex,Ltex) ;s(tool,Tool) ;s(site,Site) ;s(sced,Sced)
):-
	scores(Prec,Flex,Arch,Team,Pmat,Rely,Data,Cplx,
	        Ruse,Docu,Time,Stor,Pvol,Acap,Pcap,Pcon,
		Aexp,Pexp,Ltex,Tool,Site,Sced),
		
	vlvh(Prec), vlvh(Flex), vlvh(Arch), vlvh(Team),
	vlvh(Pmat), vlvh(Rely),  lvh(Data), vlxh(Cplx),
	 lxh(Ruse), vlvh(Docu),  nxh(Time),  nxh(Stor),
	 lvh(Pvol), vlvh(Acap), vlvh(Pcap), vlvh(Pcon),
	vlvh(Aexp), vlvh(Pexp), vlvh(Ltex), vlvh(Tool),
	vlxh(Site).
%>
