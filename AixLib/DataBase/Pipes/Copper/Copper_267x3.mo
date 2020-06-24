within AixLib.DataBase.Pipes.Copper;
record Copper_267x3 "Copper 267x3"

  extends PipeBaseDataDefinition(
    d_i=0.261,
    d_o=0.267,
    d=8900,
    lambda=393,
    c=390);
  // Constant chemical values assumed

  annotation (Documentation(revisions="<html>
<ul>
<li><i>July 9, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
<li><i>June 29, 2011&nbsp;</i> by Ana Constantin:<br/>Implemented.</li>
</ul>
</html>",
info="<html>
<h4><font color=\"#008000\">Overview</font></h4>
<p>
Record for copper pipe
</p>



<p>Source: </p>
<ul>
<li>DIN EN 1057:2010-06</li>
<li>Table 3, Page 14</li>
</ul>
</html>"));
end Copper_267x3;
