 known = [ capabilities(driver)
         , physical_handicap(driver)
         , available_reaction_time(driver)
         , slacker(period)
         , power(vehicle)
         , comfort(vehicle)
         , avoidance_action_quality(driver)
         , speed(vehicle)
         , age(driver)
         , complexity(situation)
         , driving_period(driver)
         , experience(driver)
         , risk_of_accident(driver)
         , visibility(roadsign)
         , state_quality(vehicle)
         , age(vehicle)
         , kinetic_energy(vehicle)
         , violence(crash)
         , importance(deformation)
         ].


if age(driver) or physical_handicap(driver) then not capabilities(driver).
if slacker(period) or power(vehicle) or comfort(vehicle) then speed(vehicle).
if speed(vehicle) then kinetic_energy(vehicle).
if speed(vehicle) then not available_reaction_time(driver).
if speed(vehicle) then not avoidance_action_quality(driver).
if age(driver) or driving_period(driver) then experience(driver).
if speed(vehicle) or complexity(situation) or not (experience(driver) and visibility(roadsign) and state_quality(vehicle)) then risk_of_accident(driver).
if age(vehicle) then not state_quality(vehicle).
if kinetic_energy(vehicle) then violence(crash).
if violence(crash) then importance(deformation).


