within dhcSim.Weather;
function from_deg "Convert from degree to radian"
  extends Modelica.SIunits.Conversions.ConversionIcon;
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg degree "degree value";
  output Modelica.SIunits.Angle radian "radian value";
algorithm
  radian := (Modelica.Constants.pi/180.0)*degree;
  annotation (
    Icon(graphics={Text(
          extent={{-20,100},{-100,20}},
          lineColor={0,0,0},
          textString=
               "deg"), Text(
          extent={{100,-20},{20,-100}},
          lineColor={0,0,0},
          textString=
               "rad")}),
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
               "deg"),
        Text(
          extent={{100,-20},{20,-100}},
          lineColor={0,0,0},
          textString=
               "rad")}),
    Documentation(info="<html>
<p>
The <b>from_deg</b> function converts degree values into radian values.
</p>

</html>",
    revisions="Taken from Modelica.SIunits.Conversions"));
end from_deg;
