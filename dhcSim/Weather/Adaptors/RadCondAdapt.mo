within dhcSim.Weather.Adaptors;
class RadCondAdapt "Compute the heat flow caused by radiation on a surface"
  parameter Real coeff=0.6 "Weight coefficient";
  parameter Modelica.SIunits.Area A=6 "Area of surface";
  Interfaces.ic_total_rad ic_total_rad1 annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  port.Q_flow = -ic_total_rad1.I*A*coeff;
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={223,191,159},
          fillPattern=FillPattern.Solid),
        Text(extent={{-82,22},{-38,-22}},textString=
                                             "I"),
        Text(extent={{38,22},{82,-22}},textString=
                                           "J"),
        Rectangle(
          extent={{0,48},{6,-48}},
          lineColor={0,0,0},
          fillColor={191,95,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,4},{34,-4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,8},{34,6},{34,-8},{40,0},{34,8}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,0},{-4,0}},
          color={255,255,0},
          thickness=0.5),
        Line(
          points={{-14,10},{-4,0},{-14,-10}},
          color={255,255,0},
          thickness=0.5),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString=
               "%name")}),
    Window(
      x=0.29,
      y=0.14,
      width=0.6,
      height=0.6),
    Documentation(info="<html>
<p>
The <b>RadCondAdapt</b> model computes a heat flow rate caused by the absorbance of radiation. The amount of radiation being transformed into a heat flow is controlled by a given coefficient.
</p>

</html>",
    revisions="<html>
Taken from ATplus library.
</html>"));
end RadCondAdapt;
