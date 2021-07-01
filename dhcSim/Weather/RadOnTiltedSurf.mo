within dhcSim.Weather;
model RadOnTiltedSurf "Compute radiation on tilted surface"
  parameter Real Latitude(unit="deg") = 52.517 "latitude of location";
  parameter Real Azimut(unit="deg") = 13.400
    "azimut of tilted surface, e.g. 0=south, 90=west, 180=north, -90=east";
  parameter Real Tilt(unit="deg") = 90
    "tilt of surface, e.g. 0=horizontal surface, 90=vertical surface";
  parameter Real GroundReflection=0.2 "ground reflection coefficient";
  Real cos_theta;
  Real cos_theta_help;
  Real cos_theta_z;
  Real cos_theta_z_help;
  Real R;
  Real R_help;
  Real term;
  Modelica.Blocks.Interfaces.RealInput InHourAngleSun
                         annotation (Placement(transformation(extent={{-120,30},
            {-100,50}},         rotation=0), iconTransformation(extent={{-120,30},
            {-100,50}})));
  Modelica.Blocks.Interfaces.RealInput InDeclinationSun
                         annotation (Placement(transformation(extent={{-120,-10},
            {-100,10}},           rotation=0), iconTransformation(extent={{-120,
            -10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput InAzimutSun
                         annotation (Placement(transformation(extent={{-120,-50},
            {-100,-30}},          rotation=0), iconTransformation(extent={{-120,
            -50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput InDiffRadHor
    annotation (Placement(transformation(
        origin={-40,-110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealInput InBeamRadHor
    annotation (Placement(transformation(
        origin={40,-110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Interfaces.oc_total_rad OutTotalRadTilted annotation (Placement(
        transformation(extent={{100,-10},{120,10}}, rotation=0),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  // calculation of cos_theta_z [Duffie/Beckman, p.15], cos_theta_z is manually cut at 0 (no neg. values)
  cos_theta_z_help = sin(from_deg(InDeclinationSun))*sin(from_deg(
    Latitude)) + cos(from_deg(InDeclinationSun))*cos(from_deg(Latitude))*
    cos(from_deg(InHourAngleSun));
  cos_theta_z = (cos_theta_z_help + abs(cos_theta_z_help))/2;
  // calculation of cos_theta [Duffie/Beckman, p.15], cos_theta is manually cut at 0 (no neg. values)
  term = cos(from_deg(InDeclinationSun))*sin(from_deg(Tilt))*sin(from_deg(
    Azimut))*sin(from_deg(InHourAngleSun));
  cos_theta_help = sin(from_deg(InDeclinationSun))*sin(from_deg(Latitude))
    *cos(from_deg(Tilt)) - sin(from_deg(InDeclinationSun))*cos(from_deg(
    Latitude))*sin(from_deg(Tilt))*cos(from_deg(Azimut)) + cos(from_deg(
    InDeclinationSun))*cos(from_deg(Latitude))*cos(from_deg(Tilt))*cos(
    from_deg(InHourAngleSun)) + cos(from_deg(InDeclinationSun))*sin(
    from_deg(Latitude))*sin(from_deg(Tilt))*cos(from_deg(Azimut))*cos(
    from_deg(InHourAngleSun)) + term;
  cos_theta = (cos_theta_help + abs(cos_theta_help))/2;
  // calculation of R factor [Duffie/Beckman, p.25], due to numerical problems (cos_theta_z in denominator)
  // R is manually set to 0 for theta_z >= 85° (-> 90° means sunset)
  if (cos_theta_z <= 0.087156) then
    R_help = cos_theta_z*cos_theta;
  else
    R_help = cos_theta/max(cos_theta_z,1e-10);
  end if;
  R = R_help;
  // calculation of total radiation on tilted surface according to model of Liu and Jordan
  // according to [Dissertation Nytsch-Geusen, p.98]
  OutTotalRadTilted.I = max(0, R*InBeamRadHor + 0.5*(1 + cos(from_deg(
    Tilt)))*InDiffRadHor + GroundReflection*(InBeamRadHor + InDiffRadHor)
    *((1 - cos(from_deg(Tilt)))/2));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-80,60},{80,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{14,36},{66,-16}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,225,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-40},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,0}),
        Rectangle(
          extent={{-80,-72},{100,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,-64},{-42,-76},{-42,-32},{-80,-24},{-80,-64}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={226,226,226}),
        Polygon(
          points={{-80,-64},{-100,-72},{-100,-100},{-80,-100},{-42,-76},{-80,-64}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,77,0}),
        Text(
          extent={{-100,100},{100,60}},
          lineColor={0,0,255},
          textString=
               "%name")}),
    DymolaStoredErrors,
    Diagram(graphics),
    Documentation(info="<html>
<p>
The <b>RadOnTiltedSurf</b> model uses output data of the <a href=\"Sun\"><b>Sun</b></a> model and weather data (beam and diffuse radiance on a horizontal surface) to compute total radiance on a tilted surface. It needs information on the tilt angle and the azimut angle of the surface, the latitude of the location and the ground reflection coefficient.
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
  <li><i>March 14, 2005&nbsp;</i>
         by Timo Haase:<br>
         Implemented.</li>
</ul>
</html>"));
end RadOnTiltedSurf;
