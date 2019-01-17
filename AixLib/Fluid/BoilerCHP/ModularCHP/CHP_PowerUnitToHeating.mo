within AixLib.Fluid.BoilerCHP.ModularCHP;
model CHP_PowerUnitToHeating
  "Model of engine combustion, its power output and heat transfer to the cooling circle and ambient"
  import AixLib;

  replaceable package Medium_Fuel =
      AixLib.DataBase.CHP.ModularCHPEngineMedia.LiquidFuel_LPG      constrainedby
    DataBase.CHP.ModularCHPEngineMedia.CHPCombustionMixtureGasNasa
                                annotation(choicesAllMatching=true);

  replaceable package Medium_Air =
      AixLib.DataBase.CHP.ModularCHPEngineMedia.EngineCombustionAir
                                                               constrainedby
    DataBase.CHP.ModularCHPEngineMedia.EngineCombustionAir
                         annotation(choicesAllMatching=true);

  replaceable package Medium_Exhaust =
      DataBase.CHP.ModularCHPEngineMedia.CHPFlueGasLambdaOnePlus  constrainedby
    DataBase.CHP.ModularCHPEngineMedia.CHPCombustionMixtureGasNasa
                                 annotation(choicesAllMatching=true);

  replaceable package Medium_Coolant =
      DataBase.CHP.ModularCHPEngineMedia.CHPCoolantPropyleneGlycolWater (
                                 property_T=356, X_a=0.50)   constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  parameter
    AixLib.DataBase.CHP.ModularCHPEngineData.CHPEngDataBaseRecord
    CHPEngineModel=DataBase.CHP.ModularCHPEngineData.CHP_ECPowerXRGI15()
    "CHP engine data for calculations"
    annotation (choicesAllMatching=true, Dialog(group="Unit properties"));

  parameter Fluid.BoilerCHP.ModularCHP.EngineMaterialData EngMat=
      Fluid.BoilerCHP.ModularCHP.EngineMaterial_CastIron()
    "Thermal engine material data for calculations"
    annotation (choicesAllMatching=true, Dialog(group="Unit properties"));

  inner Modelica.Fluid.System system(p_ambient=p_ambient, T_ambient=T_ambient)
    annotation (Placement(transformation(extent={{-100,-100},{-84,-84}})));

  parameter Modelica.SIunits.Temperature T_ambient=298.15
    "Default ambient temperature"
    annotation (Dialog(group="Ambient Parameters"));
  parameter Modelica.SIunits.AbsolutePressure p_ambient=101325
    "Default ambient pressure" annotation (Dialog(group="Ambient Parameters"));
  Modelica.SIunits.Temperature T_CoolRet=tempReturnFlow.T
    "Coolant return temperature" annotation (Dialog(tab="Engine Cooling Circle"));
  Modelica.SIunits.Temperature T_CoolSup=tempSupplyFlow.T
    "Coolant supply temperature"
    annotation (Dialog(tab="Engine Cooling Circle"));
  Modelica.SIunits.Power Q_Therm=cHP_PowerUnit.Q_Therm "Thermal power output of the CHP unit";
  Modelica.SIunits.Power P_Mech=cHP_PowerUnit.P_Mech "Mechanical power output of the CHP unit";
  Modelica.SIunits.Power P_El=cHP_PowerUnit.P_El "Electrical power output of the CHP unit";
  Modelica.SIunits.Power P_Fuel=cHP_PowerUnit.P_Fuel "CHP fuel expenses";
  Modelica.SIunits.Power Q_TotUnused=cHP_PowerUnit.Q_TotUnused "Total heat error of the CHP unit";
 // Modelica.SIunits.Power Q_ExhUnused=exhaustHeatExchanger.volExhaust.ports_H_flow[1]+exhaustHeatExchanger.volExhaust.ports_H_flow[2]+exhaustHeatExchanger.volExhaust.heatPort.Q_flow "Total exhaust heat error";
  Modelica.SIunits.MassFlowRate m_CO2=cHP_PowerUnit.m_CO2 "CO2 emission output rate";
  Modelica.SIunits.MassFlowRate m_Fuel=cHP_PowerUnit.m_Fuel "Fuel consumption rate of CHP unit";
  type SpecificEmission=Real(final unit="g/(kW.h)", min=0.0001);
  SpecificEmission b_CO2=cHP_PowerUnit.b_CO2 "Specific CO2 emissions per kWh (heat and power)";
  SpecificEmission b_e=cHP_PowerUnit.b_e "Specific fuel consumption per kWh (heat and power)";
  Real FueUtiRate = cHP_PowerUnit.FueUtiRate "Fuel utilization rate of the CHP unit";
  Real PowHeatRatio = cHP_PowerUnit.PowHeatRatio "Power to heat ration of the CHP unit";
  Real eta_Therm = cHP_PowerUnit.eta_Therm "Thermal efficiency of the CHP unit";
  Real eta_Mech = cHP_PowerUnit.eta_Mech "Mechanical efficiency of the CHP unit";
  Real eta_El = cHP_PowerUnit.eta_El "Mechanical efficiency of the CHP unit";

  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flowCoo=2
    "Nominal mass flow rate of coolant inside the engine cooling circle" annotation (Dialog(tab=
          "Engine Cooling Circle"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flowHeaCir=
      CHPEngineModel.m_floCooNominal
    "Nominal mass flow rate inside the heating circuit" annotation (Dialog(tab="Engine Cooling Circle"));
  parameter Modelica.SIunits.ThermalConductance GCoolChannel=65
    "Thermal conductance of engine housing from the cylinder wall to the water cooling channels"
    annotation (Dialog(tab="Engine Cooling Circle"));
  parameter Modelica.SIunits.ThermalConductance GCooHex=25000
    "Thermal conductance of the coolant heat exchanger at nominal flow"
    annotation (Dialog(tab="Engine Cooling Circle"));
  parameter Modelica.SIunits.Area A_surExhHea=100
    "Surface for exhaust heat transfer"
    annotation (Dialog(tab="Engine Cooling Circle"));
  parameter Boolean ConTec=false
    "Is condensing technology used and should latent heat be considered?"
    annotation (Dialog(tab="Advanced", group="Latent heat use"));
  parameter Boolean useGenHea=true
    "Is the thermal loss energy of the elctric machine used?"
    annotation (Dialog(tab="Advanced", group="Generator heat use"));
  parameter Boolean allowFlowReversalExhaust=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for exhaust medium"
    annotation (Dialog(tab="Advanced", group="Assumptions"));
  parameter Boolean allowFlowReversalCoolant=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for coolant medium"
    annotation (Dialog(tab="Advanced", group="Assumptions"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    mExh_flow_small=0.001
    "Small exhaust mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced", group="Assumptions"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    mCool_flow_small=0.005
    "Small coolant mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced", group="Assumptions"));

  AixLib.Fluid.BoilerCHP.ModularCHP.CHP_PowerUnit cHP_PowerUnit(
    redeclare package Medium_Fuel = Medium_Fuel,
    redeclare package Medium_Air = Medium_Air,
    redeclare package Medium_Exhaust = Medium_Exhaust,
    CHPEngineModel=CHPEngineModel,
    EngMat=EngMat,
    T_ambient=T_ambient,
    p_ambient=p_ambient,
    m_flow=m_flowCoo,
    GCoolChannel=GCoolChannel,
    ConTec=ConTec,
    useGenHea=useGenHea,
    allowFlowReversalExhaust=allowFlowReversalExhaust,
    allowFlowReversalCoolant=allowFlowReversalCoolant,
    mExh_flow_small=mExh_flow_small,
    mCool_flow_small=mCool_flow_small,
    T_CoolRet=tempCoolantReturn.T,
    T_CoolSup=tempCoolantSupply.T,
    A_surExhHea=A_surExhHea,
    mEng=mEng,
    redeclare package Medium_Coolant = Medium_Coolant)
    annotation (Placement(transformation(extent={{-24,0},{24,48}})));
  AixLib.Fluid.Movers.BaseClasses.IdealSource coolantPump(
    control_m_flow=true,
    control_dp=true,
    dp_start=CHPEngineModel.dp_Coo,
    m_flow_small=mCool_flow_small,
    redeclare package Medium = Medium_Coolant)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Fluid.Sources.FixedBoundary fixedPressureLevel(
    nPorts=1,
    redeclare package Medium = Medium_Coolant,
    p=300000,
    T=298.15)
    annotation (Placement(transformation(extent={{-112,-2},{-92,18}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort tempCoolantSupply(
    m_flow_nominal=CHPEngineModel.m_floCooNominal,
    m_flow_small=mCool_flow_small,
    redeclare package Medium = Medium_Coolant)
    annotation (Placement(transformation(extent={{40,2},{56,18}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort tempCoolantReturn(
    m_flow_small=mCool_flow_small,
    m_flow_nominal=CHPEngineModel.m_floCooNominal,
    redeclare package Medium = Medium_Coolant)
    annotation (Placement(transformation(extent={{-40,-48},{-56,-32}})));
  Modelica.Blocks.Sources.RealExpression massFlowCoolant(y=if pumpControl.y
         then m_flowCoo else mCool_flow_small)
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  Modelica.Blocks.Interfaces.BooleanInput
                                       cHPOnOff
    annotation (Placement(transformation(extent={{-110,64},{-94,80}})));
  Modelica.Blocks.Sources.BooleanPulse cHPIsOnOff(
    startTime(displayUnit="h") = 0,
    period(displayUnit="h") = 86400,
    width=50)
    annotation (Placement(transformation(extent={{-106,48},{-90,64}})));
  AixLib.Fluid.BoilerCHP.ModularCHP.HexCoolant                  coolantHex(
    redeclare package Medium2 = Medium_Coolant,
    allowFlowReversal1=allowFlowReversalCoolant,
    allowFlowReversal2=allowFlowReversalCoolant,
    m1_flow_nominal=CHPEngineModel.m_floCooNominal,
    m2_flow_nominal=CHPEngineModel.m_floCooNominal,
    m1_flow_small=mCool_flow_small,
    m2_flow_small=mCool_flow_small,
    dp1_nominal=1,
    dp2_nominal=1,
    UA_nominal=GCooHex,
    redeclare package Medium1 = Medium_Coolant)
    annotation (Placement(transformation(extent={{20,-72},{-20,-32}})));
  Modelica.Fluid.Sources.MassFlowSource_T coolantReturnFlow(
    redeclare package Medium = Medium_Coolant,
    nPorts=1,
    use_T_in=true,
    m_flow=m_flowHeaCir)
    annotation (Placement(transformation(extent={{-110,-74},{-90,-54}})));
  Modelica.Fluid.Sources.FixedBoundary coolantSupplyFlow(redeclare package
      Medium = Medium_Coolant, nPorts=1)
    annotation (Placement(transformation(extent={{110,-74},{90,-54}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort tempReturnFlow(
    redeclare package Medium = Medium_Coolant,
    m_flow_small=mCool_flow_small,
    m_flow_nominal=CHPEngineModel.m_floCooNominal)
    annotation (Placement(transformation(extent={{-56,-72},{-40,-56}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort tempSupplyFlow(
    redeclare package Medium = Medium_Coolant,
    m_flow_small=mCool_flow_small,
    m_flow_nominal=CHPEngineModel.m_floCooNominal)
    annotation (Placement(transformation(extent={{40,-72},{56,-56}})));

  Modelica.Blocks.Sources.RealExpression conCoe_GC1(y=2000000)
    annotation (Placement(transformation(extent={{-38,-98},{-18,-78}})));
  Modelica.Blocks.Sources.RealExpression conCoe_GC2(y=2000000)
    annotation (Placement(transformation(extent={{-38,-28},{-18,-8}})));

  Modelica.Blocks.Logical.Timer timerIsOff
    annotation (Placement(transformation(extent={{-18,84},{-4,98}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-44,84},{-30,98}})));
  Modelica.Blocks.Logical.LessThreshold declarationTime(threshold=2400)
    annotation (Placement(transformation(extent={{8,84},{22,98}})));
  Modelica.Blocks.Logical.Or pumpControl
    annotation (Placement(transformation(extent={{38,70},{58,90}})));
  Modelica.Blocks.Sources.RealExpression massFlowCoolant1(y=if cHPIsOnOff.y
         then 350 else 313.15)
    annotation (Placement(transformation(extent={{-142,-70},{-122,-50}})));
  parameter Modelica.SIunits.Mass mEng=80
    "Total engine mass for heat capacity calculation of the motor block"
    annotation (Dialog(tab="Engine Cooling Circle"));
equation
  connect(coolantPump.port_b, cHP_PowerUnit.port_Return) annotation (Line(
        points={{-40,10},{-28,10},{-28,10.08},{-19.2,10.08}},
                                                        color={0,127,255}));
  connect(tempCoolantReturn.port_b, coolantPump.port_a) annotation (Line(points={{-56,-40},
          {-76,-40},{-76,10},{-60,10}},         color={0,127,255}));
  connect(fixedPressureLevel.ports[1], coolantPump.port_a) annotation (Line(
        points={{-92,8},{-76,8},{-76,10},{-60,10}}, color={0,127,255}));
  connect(massFlowCoolant.y, coolantPump.m_flow_in)
    annotation (Line(points={{-59,32},{-56,32},{-56,18}},color={0,0,127}));
  connect(tempCoolantSupply.port_b, coolantHex.port_a1) annotation (Line(points=
         {{56,10},{74,10},{74,-40},{20,-40}}, color={0,127,255}));
  connect(coolantHex.port_b1, tempCoolantReturn.port_a)
    annotation (Line(points={{-20,-40},{-40,-40}}, color={0,127,255}));
  connect(coolantReturnFlow.ports[1],tempReturnFlow. port_a)
    annotation (Line(points={{-90,-64},{-56,-64}}, color={0,127,255}));
  connect(coolantHex.port_a2, tempReturnFlow.port_b)
    annotation (Line(points={{-20,-64},{-40,-64}}, color={0,127,255}));
  connect(coolantHex.port_b2, tempSupplyFlow.port_a)
    annotation (Line(points={{20,-64},{40,-64}}, color={0,127,255}));
  connect(tempSupplyFlow.port_b, coolantSupplyFlow.ports[1])
    annotation (Line(points={{56,-64},{90,-64}}, color={0,127,255}));
  connect(cHPIsOnOff.y, cHP_PowerUnit.onOffStep) annotation (Line(points={{-89.2,
          56},{-44,56},{-44,40.32},{-23.04,40.32}}, color={255,0,255}));
  connect(cHP_PowerUnit.port_Supply, tempCoolantSupply.port_a) annotation (Line(
        points={{19.2,10.08},{29.6,10.08},{29.6,10},{40,10}},
                                                          color={0,127,255}));
  connect(conCoe_GC1.y, coolantHex.Gc_2)
    annotation (Line(points={{-17,-88},{-8,-88},{-8,-72}}, color={0,0,127}));
  connect(coolantHex.Gc_1, conCoe_GC2.y) annotation (Line(points={{8,-32},{8,-32},
          {8,-18},{8,-18},{8,-18},{-17,-18}}, color={0,0,127}));
  connect(timerIsOff.u, not1.y)
    annotation (Line(points={{-19.4,91},{-29.3,91}}, color={255,0,255}));
  connect(not1.u, cHP_PowerUnit.onOffStep) annotation (Line(points={{-45.4,91},
          {-56,91},{-56,56},{-44,56},{-44,40.32},{-23.04,40.32}},color={255,0,255}));
  connect(timerIsOff.y, declarationTime.u)
    annotation (Line(points={{-3.3,91},{6.6,91}}, color={0,0,127}));
  connect(declarationTime.y, pumpControl.u1) annotation (Line(points={{22.7,91},
          {30,91},{30,80},{36,80}}, color={255,0,255}));
  connect(pumpControl.u2, cHP_PowerUnit.onOffStep) annotation (Line(points={{36,
          72},{-56,72},{-56,56},{-44,56},{-44,40.32},{-23.04,40.32}}, color={255,
          0,255}));
  connect(coolantReturnFlow.T_in, massFlowCoolant1.y)
    annotation (Line(points={{-112,-60},{-121,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-50,58},{50,18}},
          lineColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175},
          textString="CHP",
          textStyle={TextStyle.Bold}),
                              Rectangle(
          extent={{-60,80},{60,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,170,255}),                                       Text(
          extent={{-50,68},{50,28}},
          lineColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175},
          textStyle={TextStyle.Bold},
          textString="CHP
physikal"),
        Rectangle(
          extent={{-12,6},{12,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-16},{-10,-36},{-8,-30},{8,-30},{10,-36},{10,-16},{-10,-16}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2,-26},{4,-32}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,-54},{-8,-64}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,-30},{-14,-54},{-10,-56},{0,-32},{-2,-30}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4.5,-15.5},{-8,-10},{0,4},{6,-4},{10,-4},{8,-8},{8,-12},{5.5,
              -15.5},{-4.5,-15.5}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,127,0}),
        Polygon(
          points={{-4.5,-13.5},{0,-4},{6,-10},{2,-14},{-4.5,-13.5}},
          lineColor={255,255,170},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
         __Dymola_Commands(file="Modelica://AixLib/Resources/Scripts/Dymola/Fluid/CHP/Examples/CHP_OverviewScript.mos" "QuickOverviewSimulateAndPlot"),
    Documentation(info="<html>
<p>Limitations:</p>
<p>- Transmissions between generator and engine are not considered </p>
<p>- </p>
</html>"));
end CHP_PowerUnitToHeating;
