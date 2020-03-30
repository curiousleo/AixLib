within AixLib.Utilities.Sources.InternalGains.Lights;
model LightsAreaSpecific "Heat flow due to lighting relative to room area and specific lighting power"
  extends BaseClasses.PartialInternalGain(
    emissivity=0.98,
    ratioConv=0.5,
    radConvertor(final A=max(Modelica.Constants.eps, areaSurfaceLightsTotal)),
    gain(final k=roomArea*lightingPowerRoomAreaSpecific),
    gainSurfaces(final k=areaSurfaceLightsTotal));
  parameter Modelica.SIunits.Area roomArea "Area of room"    annotation(Dialog( descriptionLabel = true));
  parameter Real lightingPowerRoomAreaSpecific=10 "Lighting power per square meter room"
                                                                           annotation(Dialog( descriptionLabel = true));
  parameter Modelica.SIunits.Area areaSurfaceLightsTotal=0.01*roomArea "Surface of all lights in the room";

  annotation (Icon(graphics={
        Ellipse(
          extent={{-50,72},{50,-40}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,60},{40,20}},
          lineColor={0,0,0},
          textString="A"),
        Text(
          extent={{-44,20},{44,-8}},
          lineColor={0,0,0},
          textString="Room"),
        Line(
          points={{-26,-48},{26,-48}},
          thickness=1),
        Line(
          points={{-24,-56},{24,-56}},
          thickness=1),
        Line(
          points={{-22,-64},{22,-64}},
          thickness=1),
        Line(
          points={{-20,-72},{20,-72}},
          thickness=1),
        Line(
          points={{-28,-42},{-28,-80},{28,-80},{28,-42}},
          thickness=1)}), Documentation(revisions="<html>
<ul>
<li><i>October 21, 2014&nbsp;</i> by Ana Constantin:<br/>Added a lower positive limit to the surface area, so it will not lead to a division by zero</li>
<li><i>Mai 19, 2014&nbsp;</i> by Ana Constantin:<br/>Uses components from MSL and respects the naming conventions</li>
<li><i>May 07, 2013&nbsp;</i> by Ole Odendahl:<br/>Added documentation and formatted appropriately</li>
</ul>
</html>",
    info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Light heat source model. Maximum lighting can be given as input and be adjusted by a schedule input.</p>
<h4><span style=\"color:#008000\">Known limitation</span></h4>
<p>The parameter <b>A</b> cannot be set by default since other models must be able to implement their own equations for <b>A</b>. For a model with variable area <b>A</b> refer to <a href=\"Building.Components.Sources.InternalGains.Lights.Lights_Avar\">Lights_Avar</a>.</p>
<p>The input signal can take values from 0 to 1, and is then multiplied with the maximum lighting power per square meter and the room area. </p>
<h4><span style=\"color:#008000\">Assumptions</span></h4>
<p>The surface for radiation exchange is computed from the schedule, which leads to a surface area of zero, when no activity takes place. In particular cases this might lead to an error as depending of the rest of the system a division by this surface will be introduced in the system of equations -&gt; division by zero. For this reason a lower limitation of 1e-4 m2 has been introduced.</p>
<h4><span style=\"color:#008000\">Example Results</span></h4>
<p><a href=\"AixLib.Building.Examples.Sources.InternalGains.Lights\">AixLib.Building.Examples.Sources.InternalGains.Lights</a> </p>
<p><a href=\"AixLib.Building.Examples.Sources.InternalGains.OneOffice\">AixLib.Building.Examples.Sources.InternalGains.OneOffice</a></p>
</html>"));
end LightsAreaSpecific;
