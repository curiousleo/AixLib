within AixLib.FastHVAC.Data.CHP.Engine;
record Dachs
  extends Engine.BaseDataDefinition(
    a_0=0.1710,
    a_1=0.0080,
    a_2=0.0199,
    a_3=-4.6258,
    a_4=0.3781,
    a_5=-0.0000,
    a_6=0.0000,
    b_0=1.4312,
    b_1=-0.0232,
    b_2=-0.0839,
    b_3=2.2559,
    b_4=0.7906,
    b_5=0.0000,
    b_6=-0.0031,
    P_elRated=5500,
    tauQ_th_start=147.05,
    tauQ_th_stop = 90,
    tauP_el=73.52,
    dotm_max=0.27778,
    dotm_min=0.27778,
    dotQ_thRated = 12500,
    dotE_fuelRated = 20600,
    P_elStop = -190,
    P_elStart = -190,
    P_elStandby = -90);
    // the last three parameters where only available for the AisinSeiki ICE, so they are just copied!
end Dachs;
