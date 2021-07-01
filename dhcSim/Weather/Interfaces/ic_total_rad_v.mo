within dhcSim.Weather.Interfaces;
connector ic_total_rad_v "Vectorial total radiation connector (input)"
  parameter Integer n=1 "Dimension of signal vector";
  input Modelica.SIunits.RadiantEnergyFluenceRate I[n];
  annotation (
    Diagram(graphics={
        Rectangle(
          extent={{60,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={159,223,223},
          fillPattern=FillPattern.Solid),
        Line(points={{21,100},{60,0}}, color={255,127,0}),
        Line(points={{-48,100},{60,0}}, color={255,127,0}),
        Line(points={{-100,81},{60,0}}, color={255,127,0}),
        Line(points={{-100,39},{60,0}}, color={255,127,0}),
        Line(points={{-100,-81},{60,0}}, color={255,127,0}),
        Line(points={{-100,-39},{60,0}}, color={255,127,0}),
        Polygon(
          points={{-100,22},{-40,22},{-40,62},{60,0},{-40,-58},{-40,-18},{
              -100,-18},{-100,22}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-30,-36},{-8,-70}}, color={0,0,0}),
        Text(
          extent={{-2,-42},{54,-96}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          textString=
               "%n")}),
    Icon(graphics={
        Rectangle(
          extent={{60,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={159,223,223},
          fillPattern=FillPattern.Solid),
        Line(points={{21,100},{60,0}}, color={255,127,0}),
        Line(points={{-48,100},{60,0}}, color={255,127,0}),
        Line(points={{-100,81},{60,0}}, color={255,127,0}),
        Line(points={{-100,39},{60,0}}, color={255,127,0}),
        Line(points={{-100,-81},{60,0}}, color={255,127,0}),
        Line(points={{-100,-39},{60,0}}, color={255,127,0}),
        Polygon(
          points={{-100,22},{-40,22},{-40,62},{60,0},{-40,-58},{-40,-18},{
              -100,-18},{-100,22}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-30,-36},{-8,-70}}, color={0,0,0}),
        Text(
          extent={{-2,-42},{54,-96}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          textString=
               "%n")}),
    Documentation(info="<html>
<p>
The <b>ic_total_rad_v</b> connector is used for vectorial total radiation input.
</p>

</html>",
      revisions="<html>
Taken from ATplus library.
</html>"));
end ic_total_rad_v;
