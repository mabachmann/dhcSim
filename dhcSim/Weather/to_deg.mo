within dhcSim.Weather;
function to_deg "Convert from radian to degree"
  extends Modelica.SIunits.Conversions.ConversionIcon;
  input Modelica.SIunits.Angle radian "radian value";
  output Modelica.SIunits.Conversions.NonSIunits.Angle_deg degree
    "degree value";
algorithm
  degree := (180.0/Modelica.Constants.pi)*radian;
  annotation (
    Icon(graphics={Text(
          extent={{-20,100},{-100,20}},
          lineColor={0,0,0},
          textString=
               "rad"), Text(
          extent={{100,-20},{20,-100}},
          lineColor={0,0,0},
          textString=
               "deg")}),
    Diagram(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0}),
        Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,100},{-100,20}},
          lineColor={0,0,0},
          textString=
               "rad"),
        Text(
          extent={{100,-20},{20,-100}},
          lineColor={0,0,0},
          textString=
               "deg")}),
    Documentation(revisions="Taken from Modelica.SIunits.Conversions",
        info="<html>
<p>
The <b>to_deg</b> function converts radian values into degree values.
</p>

</html>"));
end to_deg;
