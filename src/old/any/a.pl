def(a(name,safety, devTime,devCost,opCost,capability)).

a('target_critical_mission_phases'           ,p,m,m,p,m).
a('target_critical_commands'                 ,p,m,m,p,m).
a('target_critical_events'                   ,p,m,m,p,m).
a('onboard_checking'                         ,p,p,p,m,_).
a('reduce_flight_complexity'                 ,p,m,m,_,m).
a('test_fly_prototypes'                      ,p,m,m,_,_).
a('enhance_safing'                           ,p,p,p,m,_).
a('certification'                            ,p,_,_,_,_).
a('increase_vv'                              ,p,p,p,m,_).
a('reduce_onboard_autonomy'                  ,_,m,m,p,m).
a('reuse_across_missions'                    ,_,m,m,_,_).
a('increase_developer_capabilities'          ,p,m,m,_,_).
a('increase_developer_tool_use'              ,p,m,m,_,_).
a('implement_optional_functions_after_launch',_,m,_,_,_).
a('reduce_vv_cost'                           ,_,_,m,_,_).
a('increase_vv_speed'                        ,_,m,_,_,_).
a('increase_vv_capabilities'                 ,p,m,m,_,p).
