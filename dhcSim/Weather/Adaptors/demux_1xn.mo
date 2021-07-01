within dhcSim.Weather.Adaptors;
block demux_1xn "Vectorial to scalar radiation adaptor"
  parameter Integer n(min=1) = 6 "number of connections";
  MA.Interfaces.ic_total_rad_v ic_total_rad_v(final n=n)
    annotation (                              layer="icon", Placement(
        transformation(extent={{-138,-16},{-100,16}}, rotation=0)));
  MA.Interfaces.oc_total_rad oc_total_rad[n]
    annotation (                           layer="icon", Placement(
        transformation(extent={{100,64},{136,96}}, rotation=0)));
equation
  for i in 1:n loop
    ic_total_rad_v.I[i] = oc_total_rad[i].I;
  end for;
  annotation (
    Window(
      x=0.4,
      y=0.4,
      width=0.6,
      height=0.6),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-15,15},{15,-15}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{0,0}}, color={0,0,255}),
        Line(points={{100,80},{62,80},{60,80},{0,0}}, color={0,0,255}),
        Line(points={{100,30},{90,30},{60,30},{0,0}}, color={0,0,255}),
        Line(points={{100,-30},{94,-30},{60,-30},{0,0}}, color={0,0,255}),
        Line(points={{100,-80},{60,-80},{0,0}}, color={0,0,255}),
        Text(
          extent={{-92,-26},{4,-100}},
          lineColor={0,0,0},
          textString=
               "1xn")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-15,15},{15,-15}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{0,0}}, color={0,0,255}),
        Line(points={{100,30},{90,30},{60,30},{0,0}}, color={0,0,255}),
        Line(points={{100,80},{62,80},{60,80},{0,0}}, color={0,0,255}),
        Line(points={{100,-80},{60,-80},{0,0}}, color={0,0,255}),
        Line(points={{100,-30},{94,-30},{60,-30},{0,0}}, color={0,0,255}),
        Text(
          extent={{-92,-26},{4,-100}},
          lineColor={0,0,0},
          textString=
               "1xn")}),
    Documentation(info="<html>
<p>
The <b>demux_1xn</b> model is used to split a vector of n total radiance elements - as it comes from the <a href=\"CombinedWeatherFlex\"><b>CombinedWeatherFlex</b></a> model and its derivatives - into scalars.
</p>

<dl>
<dt><b>Main Author:</b>
<dd>Timo Haase <br>
    Technische Universtit&auml;t Berlin <br>
    Hermann-Rietschel-Institut <br>
    Marchstr. 4 <br> 
    D-10587 Berlin <br>
    e-mail: <a href=\"mailto:timo.haase@tu-berlin.de\">timo.haase@tu-berlin.de</a><br>
</dl>
<br>

</html>",
    revisions="<html>
<ul>
  <li><i>June 23, 2006&nbsp;</i>
         by Timo Haase:<br>
         Implemented.</li>
</ul>
</html>"));
end demux_1xn;
