within AixLib.Utilities.Sources.InternalGains.Humans.BaseClasses;
model PartialHuman "Partial model for internal gains of humans"
  //Internal Gains People
  parameter Real specificPersons(unit="1/(m.m)") = 1.0 "Specific persons per square metre" annotation(Dialog(descriptionLabel = true));
  parameter Real RatioConvectiveHeat = 0.5
    "Ratio of convective heat from overall heat output"                                        annotation(Dialog(descriptionLabel = true));
  parameter Modelica.SIunits.Area RoomArea=20 "Area of room" annotation(Dialog(descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0 = Modelica.SIunits.Conversions.from_degC(22)
    "Initial temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a ConvHeat annotation(Placement(transformation(extent = {{80, 40}, {100, 60}})));
  Utilities.HeatTransfer.HeatToStar_Avar RadiationConvertor(eps = Emissivity_Human) annotation(Placement(transformation(extent = {{48, -22}, {72, 2}})));
  Interfaces.RadPort        RadHeat annotation(Placement(transformation(extent = {{80, -20}, {100, 0}})));
  Modelica.Blocks.Interfaces.RealInput Schedule annotation(Placement(transformation(extent = {{-120, -40}, {-80, 0}}), iconTransformation(extent = {{-102, -22}, {-80, 0}})));
  Modelica.Blocks.Math.Gain nrPeople(k=specificPersons*RoomArea)
    annotation (Placement(transformation(extent={{-70,-26},{-58,-14}})));
  Modelica.Blocks.Math.Gain SurfaceArea_People(k = SurfaceArea_Human) annotation(Placement(transformation(extent={{16,-54},
            {28,-42}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1e+23, uMin=1)      annotation(Placement(transformation(extent={{-18,-58},
            {2,-38}})));
  Modelica.Blocks.Math.Gain gain(k = RatioConvectiveHeat) annotation(Placement(transformation(extent = {{6, 28}, {14, 36}})));
  Modelica.Blocks.Math.Gain gain1(k = 1 - RatioConvectiveHeat) annotation(Placement(transformation(extent = {{6, -12}, {14, -4}})));
  Modelica.Blocks.Math.MultiProduct productHeatOutput(nu=1)
    annotation (Placement(transformation(extent={{-40,-6},{-20,14}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,50})));
protected
  parameter Modelica.SIunits.Area SurfaceArea_Human = 2;
  parameter Real Emissivity_Human = 0.98;
  parameter Modelica.SIunits.HeatFlowRate HeatPerPerson = 70 "Average Heat Flow per person taken from DIN V 18599-10" annotation(Dialog(descriptionLabel = true));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow ConvectiveHeat(T_ref = T0) annotation(Placement(transformation(extent = {{18, 20}, {42, 44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow RadiativeHeat(T_ref = T0) annotation(Placement(transformation(extent = {{18, -20}, {42, 4}})));
equation
  connect(RadiativeHeat.port, RadiationConvertor.Therm) annotation(Line(points = {{42, -8}, {44, -8}, {44, -12}, {48, -12}, {48, -10}, {48.96, -10}}, color = {191, 0, 0}, pattern = LinePattern.Solid));
  connect(RadiationConvertor.Star, RadHeat) annotation(Line(points = {{70.92, -10}, {90, -10}}, color = {95, 95, 95}, pattern = LinePattern.Solid));
  connect(Schedule, nrPeople.u)
    annotation (Line(points={{-100,-20},{-71.2,-20}}, color={0,0,127}));
  connect(gain.y, ConvectiveHeat.Q_flow) annotation(Line(points = {{14.4, 32}, {18, 32}}, color = {0, 0, 127}));
  connect(gain1.y, RadiativeHeat.Q_flow) annotation(Line(points = {{14.4, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(limiter.y, SurfaceArea_People.u) annotation (Line(
      points={{3,-48},{14.8,-48}},
      color={0,0,127}));
  connect(SurfaceArea_People.y, RadiationConvertor.A) annotation (Line(
      points={{28.6,-48},{40,-48},{40,20},{60,20},{60,0.8}},
      color={0,0,127}));
  connect(nrPeople.y, productHeatOutput.u[1]) annotation (Line(points={{-57.4,
          -20},{-54,-20},{-54,4},{-40,4},{-40,4}},
                                              color={0,0,127}));
  connect(productHeatOutput.y, gain1.u) annotation (Line(points={{-18.3,4},{-8,
          4},{-8,-8},{5.2,-8}}, color={0,0,127}));
  connect(productHeatOutput.y, gain.u) annotation (Line(points={{-18.3,4},{-8,4},
          {-8,32},{5.2,32}}, color={0,0,127}));
  connect(ConvectiveHeat.port, thermalCollector.port_a[1]) annotation (Line(
        points={{42,32},{48,32},{48,50},{52,50}}, color={191,0,0}));
  connect(thermalCollector.port_b, ConvHeat)
    annotation (Line(points={{72,50},{90,50}}, color={191,0,0}));
  connect(nrPeople.y, limiter.u) annotation (Line(points={{-57.4,-20},{-52,-20},
          {-52,-48},{-20,-48}}, color={0,0,127}));
  annotation(Icon(graphics={  Ellipse(extent = {{-36, 98}, {36, 26}}, lineColor = {255, 213, 170}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Rectangle(extent = {{-48, 20}, {54, -94}}, fillColor = {255, 0, 0},
            fillPattern =                                                                                                   FillPattern.Solid, pattern = LinePattern.None), Text(extent = {{-40, -2}, {44, -44}}, lineColor = {255, 255, 255}, fillColor = {255, 0, 0},
            fillPattern =                                                                                                   FillPattern.Solid, textString = "ERC"), Ellipse(extent = {{-24, 80}, {-14, 70}}, fillColor = {0, 0, 0},
            fillPattern =                                                                                                   FillPattern.Solid, pattern = LinePattern.None, lineColor = {0, 0, 0}), Ellipse(extent = {{10, 80}, {20, 70}}, fillColor = {0, 0, 0},
            fillPattern =                                                                                                   FillPattern.Solid, pattern = LinePattern.None, lineColor = {0, 0, 0}), Line(points = {{-18, 54}, {-16, 48}, {-10, 44}, {-4, 42}, {2, 42}, {10, 44}, {16, 48}, {18, 54}}, color = {0, 0, 0}, thickness = 1)}), Documentation(info="<html>
<p><b><font style=\"color: #008000; \">Overview</font></b> </p>
<p>Partial model for internal gains of a person. The model uses the specific value for <i>Persons/m<sup>2</sup></i> and the <i>RoomArea</i> to calculate the persons in the room considering the schedule. </p>
<p><b><font style=\"color: #008000; \">Concept</font></b> </p>
<p>A schedule is used as constant presence of people in a room is not realistic. The schedule describes the presence of only one person, and can take values from 0 to 1. </p>
<p><b><font style=\"color: #008000; \">Assumptions</font></b> </p>
<p>The surface for radiation exchange is computed from the number of persons in the room, which leads to a surface area of zero, when no one is present. In particular cases this might lead to an error as depending of the rest of the system a division by this surface will be introduced in the system of equations -&gt; division by zero.For this reason a limitiation for the surface has been intoduced: as a minimum the surface area of one human and as a maximum a value of 1e+23 m2 (only needed for a complete parametrization of the model). </p>
</html>",  revisions="<html>
 <ul>
 <li><i>July 10, 2019&nbsp;</i> by Martin Kremer:<br/>Implemented based on old human model</li>
 </ul>
 </html>"));
end PartialHuman;
