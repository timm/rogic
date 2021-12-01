:- [dd].

+source(v1,u0,when(2000,8,28,17,35,2)).

+r(549,1,_,_,v1).

+f(36,_,1,_,v1).
+f(39,_,1,_,v1).
+f(42,_,1,_,v1).
+f(17,_,1,_,v1).

+f(29,_,1,_,v1).
+f(33,_,1,_,v1).
+f(286,_,1,_,v1).

+f(132,_,1,_,v1).
+f(135,_,1,_,v1).
+f(138,_,1,_,v1).
+f(49,_,1,_,v1).
+f(91,_,1,_,v1).
+f(111,_,1,_,v1).
+f(55,_,1,_,v1).
+f(79,_,1,_,v1).
+f(82,_,1,_,v1).
+f(85,_,1,_,v1).
+f(120,_,1,_,v1).
+f(114,_,1,_,v1).
+f(149,_,1,_,v1).
+f(99,_,1,_,v1).
+f(102,_,1,_,v1).
+f(105,_,1,_,v1).
+f(108,_,1,_,v1).
+f(152,_,1,_,v1).



+f(96,_,1,_,v1) :- f(149),f(99),f(102),f(105),f(108).
+f(64,_,1,_,v1) :- f(55),f(79),f(82),f(85),f(120).
+f(61,_,1,_,v1) :- f(49),f(91),f(111).
+f(46,_,1,_,v1) :- f(61),f(64),f(114).
+f(142,_,1,_,v1) :- f(138).
+f(125,_,1,_,v1) :- f(132),f(135),f(142).
+f(26,_,1,_,v1) :- f(29).
+f(14,_,1,_,v1) :- f(36),f(39),f(42).
+f(11,_,1,_,v1) :- f(14),f(17),f(26),f(33),f(286).







+p(182,_,_,1,v1).
+p(191,_,_,1,v1).
+p(200,_,_,1,v1).
+p(194,_,_,1,v1).
+p(164,_,_,1,v1).
+p(168,_,_,1,v1).
+p(174,_,_,1,v1).
+p(177,_,_,1,v1).
+p(282,_,_,1,v1).
+p(203,_,_,1,v1).
+p(209,_,_,1,v1).
+p(212,_,_,1,v1).
+p(215,_,_,1,v1).
+p(268,_,_,1,v1).
+p(252,_,_,1,v1).
+p(339,_,_,1,v1).
+p(221,_,_,1,v1).
+p(224,_,_,1,v1).
+p(227,_,_,1,v1).
+p(249,_,_,1,v1).
+p(233,_,_,1,v1).
+p(236,_,_,1,v1).
+p(239,_,_,1,v1).
+p(256,_,_,1,v1).
+p(259,_,_,1,v1).
+p(246,_,_,1,v1).
+p(263,_,_,1,v1).

+p(243,_,_,1,v1) :- p(256),p(259).

+p(230,_,_,1,v1) :- p(233),p(236).

+p(218,_,_,1,v1) :- p(249),p(252),p(339).

+p(206,_,_,1,v1) :- p(209),p(212),p(215),p(268).

+p(185,_,_,1,v1) :- p(182),p(191),p(200).

+p(171,_,_,1,v1) :- p(174),p(177),p(282).

+p(197,_,_,1,v1) :- p(203).

+p(161,_,_,1,v1) :- p(164),p(168),p(171).

+aka(u0,"Baseline",v1).
+aka(r(549),"Dummy requirement",v1).
+aka(f(11),"Resource Use Defects",v1).
+aka(f(14),"Run time memory",v1).
+aka(f(36),"Stack",v1).
+aka(f(39),"Heap",v1).
+aka(f(42),"Other",v1).
+aka(f(17),"Executable storage",v1).
+aka(f(26),"Time",v1).
+aka(f(29),"Inadequate event response time",v1).
+aka(f(33),"Bus usage",v1).
+aka(f(286),"Unknown limits on resource usage",v1).
+aka(f(125),"Poor external interface",v1).
+aka(f(132),"Undocumented",v1).
+aka(f(135),"Inconsistent/unclear",v1).
+aka(f(142),"Data streams",v1).
+aka(f(138),"Poor metadata",v1).
+aka(f(46),"Robustness defects",v1).
+aka(f(61),"External",v1).
+aka(f(49),"Out-of-range or missing inputs",v1).
+aka(f(91),"Race conditions",v1).
+aka(f(111),"Unanticipated combination of inputs",v1).
+aka(f(64),"Internal",v1).
+aka(f(55),"Dangling / out of date pointers",v1).
+aka(f(79),"Undefined",v1).
+aka(f(82),"Boundary conditions",v1).
+aka(f(85),"Infinite loops / deadlock",v1).
+aka(f(120),"Unassigned/uninitialized variable/parameter",v1).
+aka(f(114),"Fails to recover gracefully",v1).
+aka(f(96),"Incorrect outputs",v1).
+aka(f(149),"Too fast!",v1).
+aka(f(99),"Wrong units",v1).
+aka(f(102),"Imprecise",v1).
+aka(f(105),"Just plain wrong",v1).
+aka(f(108),"Ignored an input",v1).
+aka(f(152),"Late delivery",v1).
+aka(p(161),"Measure resource usage",v1).
+aka(p(164),"CPU utilization",v1).
+aka(p(168),"Time",v1).
+aka(p(171),"Memory",v1).
+aka(p(174),"Examine high water marks on stack and heap",v1).
+aka(p(177),"Measure allocated memory",v1).
+aka(p(282),"Measure size of stored code",v1).
+aka(p(185),"Language appropriate to application",v1).
+aka(p(182),"Garbage collection in language",v1).
+aka(p(191),"Pointerless languages",v1).
+aka(p(200),"Well defined language",v1).
+aka(p(194),"O/S appropriate to application",v1).
+aka(p(197),"Good tool support",v1).
+aka(p(203),"Debuggers",v1).
+aka(p(206),"Testing",v1).
+aka(p(209),"Test automation",v1).
+aka(p(212),"Test selection",v1).
+aka(p(215),"Regression testing",v1).
+aka(p(268),"Match testing to status of development",v1).
+aka(p(218),"Analysis",v1).
+aka(p(249),"Model checking",v1).
+aka(p(252),"Formal verification",v1).
+aka(p(339),"Other",v1).
+aka(p(221),"Code generation",v1).
+aka(p(224),"Formal design approaches",v1).
+aka(p(227),"Reviews",v1).
+aka(p(230),"Good programmers",v1).
+aka(p(233),"Team players",v1).
+aka(p(236),"Technically competent",v1).
+aka(p(239),"Configuration management",v1).
+aka(p(243),"Code reuse",v1).
+aka(p(256),"Use existing libraries",v1).
+aka(p(259),"Make reusable",v1).
+aka(p(246),"Validate inputs",v1).
+aka(p(263),"Keep trends and metrics on development status",v1).

+impact(f(111),r(549),0.1,v1).
+impact(f(55),r(549),0.1,v1).
+impact(f(79),r(549),0.1,v1).
+impact(f(82),r(549),0.1,v1).
+impact(f(85),r(549),0.1,v1).
+impact(f(120),r(549),0.1,v1).
+impact(f(114),r(549),0.1,v1).
+impact(f(149),r(549),0.1,v1).
+impact(f(99),r(549),0.1,v1).
+impact(f(102),r(549),0.1,v1).
+impact(f(105),r(549),0.1,v1).
+impact(f(108),r(549),0.1,v1).
+impact(f(152),r(549),0.1,v1).
+impact(f(91),r(549),0.1,v1).
+impact(f(49),r(549),0.1,v1).
+impact(f(138),r(549),0.1,v1).
+impact(f(135),r(549),0.1,v1).
+impact(f(132),r(549),0.1,v1).
+impact(f(286),r(549),0.1,v1).
+impact(f(36),r(549),0.1,v1).
+impact(f(39),r(549),0.1,v1).
+impact(f(42),r(549),0.1,v1).
+impact(f(17),r(549),0.1,v1).
+impact(f(29),r(549),0.1,v1).
+impact(f(33),r(549),0.1,v1).
+effect(f(36),p(174),0.7,v1).
+effect(f(39),p(174),0.7,v1).
+effect(f(42),p(177),0.7,v1).
+effect(f(39),p(177),0.3,v1).
+effect(f(17),p(282),0.99,v1).
+effect(f(29),p(164),0.3,v1).
+effect(f(29),p(168),0.9,v1).
+effect(f(149),p(168),0.9,v1).
+effect(f(29),p(203),0.7,v1).
+effect(f(85),p(164),0.1,v1).
+effect(f(85),p(212),0.7,v1).
+effect(f(85),p(194),0.1,v1).
+effect(f(36),p(212),0.7,v1).
+effect(f(36),p(227),0.3,v1).
+effect(f(36),p(236),0.7,v1).
+effect(f(39),p(182),0.7,v1).
+effect(f(39),p(191),0.7,v1).
+effect(f(36),p(215),0.1,v1).
+effect(f(39),p(215),0.1,v1).
+effect(f(42),p(215),0.1,v1).
+effect(f(36),p(252),0.05,v1).
+effect(f(39),p(252),0.05,v1).
+effect(f(36),p(221),0.3,v1).
+effect(f(39),p(221),0.3,v1).
+effect(f(42),p(221),0.3,v1).
+effect(f(39),p(227),0.3,v1).
+effect(f(42),p(227),0.3,v1).
+effect(f(39),p(236),0.7,v1).
+effect(f(42),p(236),0.7,v1).
+effect(f(17),p(233),0.3,v1).
+effect(f(17),p(236),0.1,v1).
+effect(f(17),p(259),0.3,v1).
+effect(f(17),p(263),0.1,v1).
+effect(f(33),p(212),0.7,v1).
+effect(f(33),p(215),0.1,v1).
+effect(f(29),p(215),0.1,v1).
+effect(f(33),p(339),0.1,v1).
+effect(f(33),p(227),0.3,v1).
+effect(f(33),p(236),0.1,v1).
+effect(f(33),p(263),0.3,v1).
+effect(f(286),p(212),0.7,v1).
+effect(f(286),p(215),0.3,v1).
+effect(f(286),p(339),0.1,v1).
+effect(f(286),p(224),0.7,v1).
+effect(f(286),p(227),0.3,v1).
+effect(f(286),p(233),0.3,v1).
+effect(f(286),p(239),0.3,v1).
+effect(f(286),p(263),0.3,v1).
+effect(f(132),p(227),0.7,v1).
+effect(f(132),p(233),0.7,v1).
+effect(f(132),p(246),0.7,v1).
+effect(f(135),p(227),0.7,v1).
+effect(f(135),p(233),0.7,v1).
+effect(f(135),p(246),0.5,v1).
+effect(f(135),p(212),0.5,v1).
+effect(f(132),p(212),0.7,v1).
+effect(f(135),p(224),0.7,v1).
+effect(f(132),p(268),0.5,v1).
+effect(f(135),p(268),0.5,v1).
+effect(f(138),p(212),0.7,v1).
+effect(f(138),p(252),0.3,v1).
+effect(f(138),p(339),0.3,v1).
+effect(f(138),p(227),0.7,v1).
+effect(f(138),p(236),0.5,v1).
+effect(f(138),p(256),0.3,v1).
+effect(f(138),p(259),0.1,v1).
+effect(f(138),p(246),0.7,v1).
+effect(f(49),p(203),0.3,v1).
+effect(f(49),p(209),0.3,v1).
+effect(f(49),p(212),0.99,v1).
+effect(f(49),p(215),0.3,v1).
+effect(f(49),p(268),0.3,v1).
+effect(f(49),p(249),0.1,v1).
+effect(f(49),p(252),0.1,v1).
+effect(f(49),p(339),0.1,v1).
+effect(f(49),p(221),0.3,v1).
+effect(f(49),p(224),0.3,v1).
+effect(f(49),p(227),0.7,v1).
+effect(f(49),p(236),0.7,v1).
+effect(f(49),p(256),0.1,v1).
+effect(f(49),p(259),0.1,v1).
+effect(f(49),p(246),0.99,v1).
+effect(f(91),p(203),0.7,v1).
+effect(f(91),p(212),0.9,v1).
+effect(f(91),p(249),0.7,v1).
+effect(f(91),p(252),0.1,v1).
+effect(f(91),p(164),0.1,v1).
+effect(f(91),p(227),0.3,v1).
+effect(f(91),p(236),0.7,v1).
+effect(f(91),p(233),0.3,v1).
+effect(f(111),p(212),0.7,v1).
+effect(f(111),p(209),0.3,v1).
+effect(f(111),p(215),0.1,v1).
+effect(f(111),p(268),0.1,v1).
+effect(f(111),p(249),0.1,v1).
+effect(f(111),p(252),0.1,v1).
+effect(f(111),p(339),0.1,v1).
+effect(f(111),p(227),0.3,v1).
+effect(f(111),p(236),0.3,v1).
+effect(f(111),p(256),0.1,v1).
+effect(f(111),p(259),0.1,v1).
+effect(f(111),p(246),0.7,v1).
+effect(f(55),p(191),1,v1).
+effect(f(55),p(182),0.3,v1).
+effect(f(55),p(194),0.3,v1).
+effect(f(55),p(203),0.7,v1).
+effect(f(55),p(212),0.7,v1).
+effect(f(55),p(177),0.3,v1).
+effect(f(55),p(339),0.1,v1).
+effect(f(55),p(221),0.3,v1).
+effect(f(55),p(236),0.3,v1).
+effect(f(55),p(256),0.3,v1).
+effect(f(55),p(259),0.1,v1).
+effect(f(79),p(221),1,v1).
+effect(f(79),p(252),0.1,v1).
+effect(f(79),p(339),0.7,v1).
+effect(f(79),p(203),0.3,v1).
+effect(f(79),p(246),0.3,v1).
+effect(f(82),p(236),0.7,v1).
+effect(f(82),p(200),0.1,v1).
+effect(f(82),p(203),0.3,v1).
+effect(f(82),p(212),0.9,v1).
+effect(f(82),p(215),0.3,v1).
+effect(f(82),p(252),0.1,v1).
+effect(f(82),p(339),0.3,v1).
+effect(f(82),p(221),0.3,v1).
+effect(f(82),p(224),0.1,v1).
+effect(f(82),p(227),0.3,v1).
+effect(f(82),p(233),0.1,v1).
+effect(f(82),p(239),0.1,v1).
+effect(f(82),p(256),0.3,v1).
+effect(f(82),p(259),0.1,v1).
+effect(f(85),p(168),0.3,v1).
+effect(f(85),p(249),0.9,v1).
+effect(f(85),p(252),0.1,v1).
+effect(f(85),p(256),0.1,v1).
+effect(f(120),p(203),0.3,v1).
+effect(f(120),p(339),0.3,v1).
+effect(f(120),p(252),0.1,v1).
+effect(f(120),p(221),0.7,v1).
+effect(f(120),p(212),0.7,v1).
+effect(f(120),p(236),0.7,v1).
+effect(f(120),p(259),0.1,v1).
+effect(f(120),p(246),0.1,v1).
+effect(f(114),p(194),0.7,v1).
+effect(f(114),p(203),0.1,v1).
+effect(f(114),p(212),0.3,v1).
+effect(f(114),p(215),0.1,v1).
+effect(f(114),p(227),0.3,v1).
+effect(f(114),p(233),0.1,v1).
+effect(f(114),p(236),0.3,v1).
+effect(f(114),p(256),0.1,v1).
+effect(f(114),p(224),0.7,v1).
+effect(f(114),p(259),0.1,v1).
+effect(f(114),p(246),0.3,v1).
+effect(f(149),p(212),0.7,v1).
+effect(f(149),p(215),0.1,v1).
+effect(f(149),p(227),0.3,v1).
+effect(f(149),p(224),0.7,v1).
+effect(f(99),p(212),0.3,v1).
+effect(f(99),p(227),0.7,v1).
+effect(f(99),p(233),0.3,v1).
+effect(f(102),p(212),0.7,v1).
+effect(f(102),p(227),0.3,v1).
+effect(f(105),p(249),0.3,v1).
+effect(f(105),p(252),0.6,v1).
+effect(f(105),p(339),0.6,v1).
+effect(f(105),p(209),0.1,v1).
+effect(f(105),p(212),0.7,v1).
+effect(f(105),p(215),0.3,v1).
+effect(f(105),p(268),0.3,v1).
+effect(f(108),p(246),0.7,v1).
+effect(f(108),p(212),0.7,v1).
+effect(f(108),p(215),0.3,v1).
+effect(f(108),p(268),0.3,v1).
+effect(f(152),p(268),0.9,v1).
+effect(f(152),p(200),0.3,v1).
+effect(f(152),p(263),0.7,v1).
+effect(f(152),p(259),0.1,v1).
+effect(f(152),p(239),0.7,v1).
+effect(f(152),p(256),0.3,v1).

