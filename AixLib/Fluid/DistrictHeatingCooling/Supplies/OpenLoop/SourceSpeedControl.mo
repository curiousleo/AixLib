within AixLib.Fluid.DistrictHeatingCooling.Supplies.OpenLoop;
model SourceSpeedControl "Simple supply node model with speed controled pump"
  extends
    AixLib.Fluid.DistrictHeatingCooling.BaseClasses.Supplies.OpenLoop.PartialSupplyLessInputs(
      senT_return(allowFlowReversal=true));

  parameter Modelica.SIunits.AbsolutePressure pReturn
    "Fixed return pressure";

  AixLib.Fluid.Sources.Boundary_pT source(          redeclare package Medium =
        Medium,
    nPorts=2,
    use_T_in=true,
    use_p_in=false,
    p=pReturn)
    "Ideal fluid source with prescribed temperature and pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,40})));

  AixLib.Fluid.Sources.FixedBoundary sink(
    redeclare package Medium = Medium,
    p=pReturn,
    use_T=false,
    nPorts=1) "Ideal sink for return from the network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-34,-20})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow
    annotation (Placement(transformation(extent={{98,70},{118,90}})));

  AixLib.Fluid.Movers.SpeedControlled_Nrpm pump_single(redeclare package Medium
      = Medium, redeclare JuLib.SIHI_Halberg_CBKA200500_single per)
    annotation (Placement(transformation(extent={{-40,70},{-20,50}})));
  Modelica.Blocks.Interfaces.RealInput TIn "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-124,40},{-84,80}})));
  Modelica.Blocks.Interfaces.RealInput RpmIn
    "Prescribed rotational speed"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  AixLib.Fluid.HeatExchangers.Heater_T CHP(
    redeclare package Medium = Medium,
    m_flow_nominal=182,
    dp_nominal(displayUnit="bar") = 300000,
    QMax_flow(displayUnit="MW") = 30000000)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis_two_pumps(
    uLow=320,
    uHigh=400,
    u=senMasFlo.m_flow/senDen.d*3600)
    "Switches between two parallel pumps and one pump (True when parallel mode)"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  AixLib.Fluid.Sensors.DensityTwoPort senDen(redeclare package Medium = Medium,
      m_flow_nominal=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,20})));
  AixLib.Fluid.Movers.SpeedControlled_Nrpm pump_double(redeclare package Medium
      = Medium, redeclare JuLib.SIHI_Halberg_CBKA200500_double per)
    annotation (Placement(transformation(extent={{-40,30},{-20,10}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  AixLib.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Medium,
    m_flow_nominal=184,
    dpValve_nominal=3000)
    annotation (Placement(transformation(extent={{-10,30},{10,10}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{26,-20},{6,0}})));
  AixLib.Fluid.HeatExchangers.Heater_T Gas_Burner(
    redeclare package Medium = Medium,
    m_flow_nominal=182,
    dp_nominal(displayUnit="bar") = 300000)
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Constant T_max_BHKW(k=273.15 + 115)
    annotation (Placement(transformation(extent={{-74,66},{-54,86}})));
equation
  Q_flow = (senT_supply.T - senT_return.T) * 4180 * senMasFlo.m_flow;
  connect(senT_return.port_a, sink.ports[1])
    annotation (Line(points={{-60,0},{-50,0},{-50,-20},{-44,-20}},
                                               color={0,127,255}));
  connect(source.ports[1], pump_single.port_a) annotation (Line(points={{-60,42},
          {-50,42},{-50,60},{-40,60}}, color={0,127,255}));
  connect(senDen.port_b, senT_supply.port_a)
    annotation (Line(points={{40,10},{40,0}}, color={0,127,255}));
  connect(switch1.u2, hysteresis_two_pumps.y)
    annotation (Line(points={{22,-80},{59,-80}}, color={255,0,255}));
  connect(switch1.y, pump_double.Nrpm)
    annotation (Line(points={{-1,-80},{-30,-80},{-30,8}}, color={0,0,127}));
  connect(senT_return.T, source.T_in) annotation (Line(points={{-70,11},{-70,20},
          {-92,20},{-92,44},{-82,44}}, color={0,0,127}));
  connect(switch2.y, pump_single.Nrpm) annotation (Line(points={{-1,-40},{-12,
          -40},{-12,40},{-30,40},{-30,48}}, color={0,0,127}));
  connect(pump_double.port_a, source.ports[2]) annotation (Line(points={{-40,20},
          {-50,20},{-50,40},{-60,40},{-60,38}}, color={0,127,255}));
  connect(switch2.u2, hysteresis_two_pumps.y) annotation (Line(points={{22,-40},
          {40,-40},{40,-80},{59,-80}}, color={255,0,255}));
  connect(const.y, switch2.u1) annotation (Line(points={{59,-40},{42,-40},{42,
          -32},{22,-32}}, color={0,0,127}));
  connect(RpmIn, switch2.u3) annotation (Line(points={{-100,-60},{28,-60},{28,
          -48},{22,-48}}, color={0,0,127}));
  connect(RpmIn, switch1.u1) annotation (Line(points={{-100,-60},{28,-60},{28,
          -72},{22,-72}}, color={0,0,127}));
  connect(const.y, switch1.u3) annotation (Line(points={{59,-40},{42,-40},{42,
          -88},{22,-88}}, color={0,0,127}));
  connect(val.port_2,CHP. port_a) annotation (Line(points={{10,20},{14,20},{14,
          64},{-4,64},{-4,80},{0,80}},
                        color={0,127,255}));
  connect(pump_double.port_b, val.port_1)
    annotation (Line(points={{-20,20},{-10,20}}, color={0,127,255}));
  connect(val.port_3, pump_single.port_b)
    annotation (Line(points={{0,30},{0,60},{-20,60}}, color={0,127,255}));
  connect(booleanToReal.y, val.y)
    annotation (Line(points={{5,-10},{0,-10},{0,8}}, color={0,0,127}));
  connect(booleanToReal.u, hysteresis_two_pumps.y) annotation (Line(points={{28,
          -10},{40,-10},{40,-80},{59,-80}}, color={255,0,255}));
  connect(CHP.port_b, Gas_Burner.port_a)
    annotation (Line(points={{20,80},{30,80}}, color={0,127,255}));
  connect(senDen.port_a, Gas_Burner.port_b) annotation (Line(points={{40,30},{
          40,60},{60,60},{60,80},{50,80}}, color={0,127,255}));
  connect(T_max_BHKW.y, CHP.TSet) annotation (Line(points={{-53,76},{-28,76},{
          -28,88},{-2,88}}, color={0,0,127}));
  connect(TIn, Gas_Burner.TSet) annotation (Line(points={{-104,60},{-82,60},{
          -82,94},{28,94},{28,88}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{98,50},{118,70}})),
              Icon(coordinateSystem(extent={{-100,-100},{120,100}}),
                   graphics={Ellipse(
          extent={{-78,40},{2,-40}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
March 3, 2018, by Marcus Fuchs:<br/>
Implemented for <a href=\"https://github.com/RWTH-EBC/AixLib/issues/402\">issue 403</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model represents the supply node with an ideal pressure source and sink.
It provides a prescribed supply pressure and supply temperature to the network.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end SourceSpeedControl;