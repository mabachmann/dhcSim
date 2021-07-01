within dhcSim.Weather.Adaptors;
block mux_5x1 "Scalar to vectorial radiation adaptor"
  MA.Interfaces.ic_total_rad ic_total_rad_south
    annotation (                               layer="icon", Placement(
        transformation(extent={{-136,-46},{-100,-14}}, rotation=0),
        iconTransformation(extent={{-136,-56},{-100,-24}})));
  MA.Interfaces.oc_total_rad_v oc_total_rad_v(final n=5)
    annotation (                            layer="icon", Placement(
        transformation(extent={{100,-16},{138,16}}, rotation=0)));
  MA.Interfaces.ic_total_rad ic_total_rad_west
    annotation (                               layer="icon", Placement(
        transformation(extent={{-136,-96},{-100,-64}}, rotation=0),
        iconTransformation(extent={{-136,-96},{-100,-64}})));
  MA.Interfaces.ic_total_rad ic_total_rad_east
    annotation (                             layer="icon", Placement(
        transformation(extent={{-136,14},{-100,46}}, rotation=0),
        iconTransformation(extent={{-136,-14},{-100,18}})));
  MA.Interfaces.ic_total_rad ic_total_rad_north
    annotation (                             layer="icon", Placement(
        transformation(extent={{-136,64},{-100,96}}, rotation=0),
        iconTransformation(extent={{-136,26},{-100,58}})));
  MA.Interfaces.ic_total_rad ic_total_rad_horizontal
    annotation (                             layer="icon", Placement(
        transformation(extent={{-152,66},{-102,98}}, rotation=0),
        iconTransformation(extent={{-136,68},{-100,96}})));
equation
  [oc_total_rad_v.I] = [ic_total_rad_horizontal.I; ic_total_rad_north.I; ic_total_rad_east.I;
    ic_total_rad_south.I; ic_total_rad_west.I];
  annotation (
    Window(
      x=0.4,
      y=0.4,
      width=0.6,
      height=0.6),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,80},{-60,80},{0,0}}),
        Line(points={{-100,30},{-60,30},{0,0}}),
        Line(points={{-101,-30},{-60,-30},{0,0}}),
        Line(points={{-100,-80},{-60,-80},{0,0}}),
        Line(points={{0,0},{100,0}}),
        Ellipse(
          extent={{-15,15},{15,-15}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,80},{-60,80},{0,0}}),
        Line(points={{-100,40},{-60,40},{-6,2}}),
        Line(points={{-101,-40},{-60,-40},{-6,-2}}),
        Line(points={{-100,-80},{-60,-80},{0,0}}),
        Ellipse(
          extent={{-15,15},{15,-15}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,0},{100,0}}),
        Line(points={{-99,2},{-58,2},{0,0}})}),
    Documentation(info="<html>
<p>
The <b>mux_5x1</b> model is used to build a vector consisting of four total radiance elements.
</p>

<dl>
<dt><b>Main Author:</b>
<dd>Stefan Brandt <br>
    Technische Universtit&auml;t Berlin <br>
    Hermann-Rietschel-Institut <br>
    Marchstr. 4 <br> 
    D-10587 Berlin <br>
    e-mail: <a href=\"mailto:s.brandt@tu-berlin.de\">s.brandt@tu-berlin.de</a><br>
</dl>
<br>

</html>",
    revisions="<html>
<ul>
  <li><i>2012&nbsp;</i>
         by Stfan Brandt:<br>
         Implemented.</li>
</ul>
</html>"));
end mux_5x1;
