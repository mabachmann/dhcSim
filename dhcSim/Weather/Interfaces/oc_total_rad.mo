within dhcSim.Weather.Interfaces;
connector oc_total_rad "Scalar total radiation connector (output)"
  output Modelica.SIunits.RadiantEnergyFluenceRate I;
  annotation (
    Diagram(graphics={
        Rectangle(
          extent={{-60,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={159,223,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{-21,100}}, color={255,127,0}),
        Line(points={{-60,0},{48,100}}, color={255,127,0}),
        Line(points={{-60,0},{100,81}}, color={255,127,0}),
        Line(points={{-60,0},{100,39}}, color={255,127,0}),
        Line(points={{-60,0},{-21,-100}}, color={255,127,0}),
        Line(points={{-60,0},{48,-100}}, color={255,127,0}),
        Line(points={{-60,0},{100,-81}}, color={255,127,0}),
        Line(points={{-60,0},{100,-39}}, color={255,127,0}),
        Polygon(
          points={{-60,18},{0,18},{0,58},{100,-4},{0,-62},{0,-22},{-60,-22},
              {-60,18}},
          lineColor={0,0,0},
          fillColor={255,191,127},
          fillPattern=FillPattern.Solid)}),
    Icon(graphics={
        Rectangle(
          extent={{-60,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={159,223,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{-21,100}}, color={255,127,0}),
        Line(points={{-60,0},{48,100}}, color={255,127,0}),
        Line(points={{-60,0},{100,81}}, color={255,127,0}),
        Line(points={{-60,0},{100,39}}, color={255,127,0}),
        Line(points={{-60,0},{-21,-100}}, color={255,127,0}),
        Line(points={{-60,0},{48,-100}}, color={255,127,0}),
        Line(points={{-60,0},{100,-81}}, color={255,127,0}),
        Line(points={{-60,0},{100,-39}}, color={255,127,0}),
        Polygon(
          points={{-60,18},{0,18},{0,58},{100,-4},{0,-62},{0,-22},{-60,-22},
              {-60,18}},
          lineColor={0,0,0},
          fillColor={255,191,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
The <b>oc_total_rad</b> connector is used for scalar total radiation output.
</p>

</html>",
      revisions="<html>
Taken from ATplus library.
</html>"));
end oc_total_rad;
