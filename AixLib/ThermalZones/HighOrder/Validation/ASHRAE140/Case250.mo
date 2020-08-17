within AixLib.ThermalZones.HighOrder.Validation.ASHRAE140;
model Case250
  extends AixLib.ThermalZones.HighOrder.Validation.ASHRAE140.Case220(
    solar_absorptance_OW=0.9,
    ReferenceHeatingLoad(table=[250,4751,7024]),
    ReferenceCoolingLoad(table=[250,-3380,-2177]));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>July 1, 2020</i> by Konstantina Xanthopoulou:<br/>
    Implemented
  </li>
</ul>
</html>", info="<html>
<p>
  As described in ASHRAE Standard 140.
</p>
<p>
  Difference to case 220:
</p>
<ul>
  <li>Solar absorptance on exterior surface = 0.9
  </li>
</ul>
</html>"));
end Case250;