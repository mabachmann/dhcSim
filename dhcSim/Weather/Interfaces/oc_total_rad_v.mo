within dhcSim.Weather.Interfaces;
connector oc_total_rad_v "Vectorial total radiation connector (output)"
  parameter Integer n=1 "Dimension of signal vector";
  output Modelica.SIunits.RadiantEnergyFluenceRate I[n];
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
        Text(
          extent={{42,-46},{98,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          textString=
               "%n"),
        Line(points={{-60,0},{-18,-100}}, color={255,127,0}),
        Line(points={{-60,0},{100,-40}}, color={255,127,0}),
        Polygon(
          points={{-60,18},{0,18},{0,58},{100,-4},{0,-62},{0,-22},{-60,-22},
              {-60,18}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Line(points={{14,-40},{36,-74}}, color={0,0,0})}),
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
        Text(
          extent={{42,-46},{98,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          textString=
               "%n"),
        Line(points={{-60,0},{-18,-100}}, color={255,127,0}),
        Line(points={{-60,0},{100,-40}}, color={255,127,0}),
        Polygon(
          points={{-60,18},{0,18},{0,58},{100,-4},{0,-62},{0,-22},{-60,-22},
              {-60,18}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Line(points={{14,-40},{36,-74}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
The <b>oc_total_rad_v</b> connector is used for vectorial total radiation output.
</p>

</html>",
      revisions="<html>
Taken from ATplus library.
</html>"));
end oc_total_rad_v;
