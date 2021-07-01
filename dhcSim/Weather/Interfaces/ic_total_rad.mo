within dhcSim.Weather.Interfaces;
connector ic_total_rad "Scalar total radiation connector (input)"
  input Modelica.SIunits.RadiantEnergyFluenceRate I;
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
        Line(points={{21,-100},{60,0}}, color={255,127,0}),
        Line(points={{-48,-100},{60,0}}, color={255,127,0}),
        Line(points={{-100,-81},{60,0}}, color={255,127,0}),
        Line(points={{-100,-39},{60,0}}, color={255,127,0}),
        Polygon(
          points={{-100,22},{-40,22},{-40,62},{60,0},{-40,-58},{-40,-18},{
              -100,-18},{-100,22}},
          lineColor={0,0,0},
          fillColor={255,191,127},
          fillPattern=FillPattern.Solid)}),
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
        Line(points={{21,-100},{60,0}}, color={255,127,0}),
        Line(points={{-48,-100},{60,0}}, color={255,127,0}),
        Line(points={{-100,-81},{60,0}}, color={255,127,0}),
        Line(points={{-100,-39},{60,0}}, color={255,127,0}),
        Polygon(
          points={{-100,22},{-40,22},{-40,62},{60,0},{-40,-58},{-40,-18},{
              -100,-18},{-100,22}},
          lineColor={0,0,0},
          fillColor={255,191,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
The <b>ic_total_rad</b> connector is used for scalar total radiation input.
</p>
 
</html>",
      revisions="<html>
Taken from ATplus library.
</html>"));
end ic_total_rad;
