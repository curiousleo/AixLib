within AixLib.Utilities.Sources.InternalGains.BaseClasses;
partial model PartialInternalGain
  "Partial model to build a heat source with convective and radiative component"
  parameter Real ratioConv(min=0, max=1) = 0.6
    "Ratio convective to total heat release" annotation(Dialog(descriptionLabel = true));
  parameter Modelica.SIunits.Emissivity emissivity(min=0, max=1) = 0.95
    "Emissivity of radiative heat source surface";
  Modelica.Blocks.Interfaces.RealInput schedule(min=0, max=1)
    "Relative input related to max. value (might be number of people [-] or area [m2] or area specific heat flow [W/m2]"
     annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow convectiveHeat(final T_ref=293.15, final alpha=0)
     annotation (Placement(transformation(extent={{24,10},{44,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow radiativeHeat(final T_ref=293.15, final alpha=0)
     annotation (Placement(transformation(extent={{24,-30},{44,-10}})));
  AixLib.Utilities.HeatTransfer.HeatToRad radConvertor(final eps=emissivity)
    "Adaptor for approximative longwave radiation exchange with surface area"
    annotation (Placement(transformation(extent={{52,-70},{72,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a convHeat
    "Convective heat flow connector"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  AixLib.Utilities.Interfaces.RadPort radHeat
    "Radiative heat flow connector"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
protected
  Modelica.Blocks.Math.MultiProduct productHeatOutput(each u(unit="W/m2"))
    annotation (Placement(transformation(extent={{-20,-6},{-8,6}})));
  Modelica.Blocks.Math.Gain gainConv(final k=ratioConv) annotation (Placement(transformation(extent={{8,16},{16,24}})));
  Modelica.Blocks.Math.Gain gainRad(final k=1 - ratioConv) annotation (Placement(transformation(extent={{8,-24},{16,-16}})));
equation
  connect(convectiveHeat.port,convHeat)  annotation(Line(points={{44,20},{48,20},{48,60},{90,60}},          color = {191, 0, 0}, pattern = LinePattern.Solid));
  connect(gainConv.y, convectiveHeat.Q_flow) annotation (Line(points={{16.4,20},{24,20}}, color={0,0,127}));
  connect(gainRad.y, radiativeHeat.Q_flow) annotation (Line(points={{16.4,-20},{24,-20}}, color={0,0,127}));
  connect(productHeatOutput.y, gainConv.u) annotation (Line(points={{-6.98,0},{0,0},{0,20},{7.2,20}}, color={0,0,127}));
  connect(productHeatOutput.y, gainRad.u) annotation (Line(points={{-6.98,0},{0,0},{0,-20},{7.2,-20}}, color={0,0,127}));
  connect(radiativeHeat.port, radConvertor.conv) annotation (Line(points={{44,-20},{48,-20},{48,-60},{52.8,-60}}, color={191,0,0}));
  connect(radConvertor.rad, radHeat) annotation (Line(
      points={{71.1,-60},{90,-60}},
      color={95,95,95},
      pattern=LinePattern.Solid));
  annotation (Documentation(revisions="<html>
<ul>
<li><i>March 26, 202020&nbsp;</i> by Philipp Mehrfeld:<br/><a href=\"https://github.com/RWTH-EBC/AixLib/issues/886\">#886</a> refactor input schedule and other components.</li>
<li><i>Mai 19, 2014&nbsp;</i> by Ana Constantin:<br/>Uses components from MSL and respects the naming conventions </li>
<li><i>May 02, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately </li>
<li><i>April 30, 2012</i> by Peter Matthes:<br/>implemented partial model for heat sources to work with Ana&apos;s models. </li>
<li><i>August 10, 2011</i> by Ana Constantin:<br/>implemented </li>
</ul>
</html>",  info = "<html>
 <h4><font color=\"#008000\">Overview</font></h4>
 <p>Partial model to build a heat source with convective and radiative components. The parameter <code>ratioConv</code> determines the percentage of convective heat.</p>
 </html>"));
end PartialInternalGain;
