within dhcSim.Weather;
model CombinedWeather "Simple integrated weather model"
  parameter Real Latitude(unit="deg") = 52.517 "latitude of location"
    annotation (Dialog(group="Location Properties"));
  parameter Real Longitude(unit="deg") = 13.400 "longitude of location"
    annotation (Dialog(group="Location Properties"));
  parameter Real DiffWeatherDataTime(unit="h") = 1
    "difference between weather data time and UTC, e.g. +1 for CET"
    annotation (Dialog(group="Properties of Weather Data"));
  parameter Real GroundReflection=0.2 "ground reflection coefficient"
    annotation (Dialog(group="Location Properties"));
  parameter String tableName="wetter"
    "table name on file or in function usertab"
    annotation (Dialog(group="Properties of Weather Data"));
  parameter String fileName="TRY_Potsdam.dat" "file where matrix is stored"
                                 annotation (Dialog(
      group="Properties of Weather Data",
      loadSelector(filter="Dat files (*.dat);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]={16,15,10,12,11,9}
    "columns of table to be interpolated, order: diffuse radiation, beam radiation, temperature, moisture, pressure, wind speed"
    annotation (Dialog(group="Properties of Weather Data"));
  parameter Real offset[:]={0} "Offsets of output signals"
    annotation (Dialog(group="Properties of Weather Data"));
  parameter Integer extrapolation[1](
    min={0},
    max={2}) = {2}
    "= 0/1/2 constant/last two points/periodic (same value for all columns)"
    annotation (Dialog(group="Properties of Weather Data"));
  // startTime should not be modified by the user. Instead use the dsin.txt file to set the simulation start time.
protected
  parameter Real startTime[1]={0}
    "Output = offset for time < startTime (same value for all columns)"
    annotation (Dialog(group="Properties of Weather Data"));
public
  parameter Integer smoothNess=0
    "= 0/1 linear/spline interpolation of table data"
    annotation (Dialog(group="Properties of Weather Data"));
  Sun Sun1(
    Longitude=Longitude,
    Latitude=Latitude,
    DiffWeatherDataTime=DiffWeatherDataTime)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}},
          rotation=0)));
  RadOnTiltedSurf RadOnTiltedSurf_east(
    Latitude=Latitude,
    GroundReflection=GroundReflection,
    Tilt=90,
    Azimut=-90) annotation (Placement(transformation(extent={{0,20},{20,40}},
                  rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable WeatherData(
    fileName=fileName,
    columns=columns,
    offset=offset,
    table=[0, 0; 1, 1],
    startTime=scalar(startTime),
    tableName=tableName,
    tableOnFile=(tableName) <> "NoName",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}},
          rotation=0)));
    RadOnTiltedSurf RadOnTiltedSurf_north(
    Tilt=90,
    Latitude=Latitude,
    GroundReflection=GroundReflection,
    Azimut=180) annotation (Placement(transformation(extent={{0,50},{20,70}},
                  rotation=0)));
  RadOnTiltedSurf RadOnTiltedSurf_south(
    Tilt=90,
    Latitude=Latitude,
    GroundReflection=GroundReflection,
    Azimut=0) annotation (Placement(transformation(extent={{0,-10},{20,10}},
                  rotation=0)));
  RadOnTiltedSurf RadOnTiltedSurf_west(
    Tilt=90,
    Latitude=Latitude,
    GroundReflection=GroundReflection,
    Azimut=90) annotation (Placement(transformation(extent={{0,-40},{20,-20}},
                   rotation=0)));
  RadOnTiltedSurf radOnTiltedSurf_horizontal(
    Tilt=0,
    GroundReflection=GroundReflection,
    Latitude=Latitude,
    Azimut=180) annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Interfaces.RealOutput TempOut annotation (Placement(transformation(extent={{90,-40},
            {110,-20}},rotation=0), iconTransformation(extent={{90,-40},{110,-20}})));
  Modelica.Blocks.Interfaces.RealOutput MoistOut annotation (Placement(transformation(extent={{90,-60},
            {110,-40}},rotation=0), iconTransformation(extent={{90,-60},{110,-40}})));
  Modelica.Blocks.Math.Gain ConvertToKg_Kg(k=0.001) annotation (Placement(transformation(extent={{60,-58},
            {76,-42}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput PressOut annotation (Placement(transformation(extent={{90,-80},
            {110,-60}},      rotation=0), iconTransformation(extent={{90,-80},{110,
            -60}})));
  Modelica.Blocks.Routing.DeMultiplex6 DeMultiplex6 annotation (Placement(transformation(extent={{-40,-80},
            {-20,-60}},
          rotation=0)));
  Modelica.Blocks.Math.Gain ConvertToPa(k=100) annotation (Placement(transformation(extent={{60,-78},
            {76,-62}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput WindSpeedOut annotation (Placement(transformation(extent={{90,-100},
            {110,-80}},       rotation=0), iconTransformation(extent={{90,-100},
            {110,-80}})));
  Interfaces.oc_total_rad[5] oc_total_rad annotation (Placement(
        transformation(extent={{90,20},{110,40}}, rotation=0),
        iconTransformation(extent={{90,20},{110,40}})));
equation
  connect(ConvertToKg_Kg.y, MoistOut) annotation (Line(points={{76.8,-50},{100,-50}},
                     color={0,0,127}));
  connect(WeatherData.y, DeMultiplex6.u) annotation (Line(points={{-59,-70},
          {-34,-70},{-42,-70}},
                           color={0,0,127}));
  connect(DeMultiplex6.y1[1], RadOnTiltedSurf_west.InDiffRadHor)
    annotation (Line(points={{-19,-61},{6,-61},{6,-41}},      color={0,0,
          127}));
  connect(DeMultiplex6.y2[1], RadOnTiltedSurf_west.InBeamRadHor)
    annotation (Line(points={{-19,-64.6},{14,-64.6},{14,-41}},      color=
         {0,0,127}));
  connect(DeMultiplex6.y3[1], TempOut) annotation (Line(points={{-19,-68.2},{44,
          -68.2},{44,-30},{100,-30}},color={0,0,127}));
  connect(DeMultiplex6.y4[1], ConvertToKg_Kg.u) annotation (Line(points={{-19,
          -71.8},{46,-71.8},{46,-50},{58.4,-50}},     color={0,0,127}));
  connect(DeMultiplex6.y5[1], ConvertToPa.u) annotation (Line(points={{-19,
          -75.4},{48,-75.4},{48,-70},{58.4,-70}}, color={0,0,127}));
  connect(ConvertToPa.y, PressOut) annotation (Line(points={{76.8,-70},{76.8,-70},
          {100,-70}},
                    color={0,0,127}));
  connect(DeMultiplex6.y6[1], WindSpeedOut) annotation (Line(points={{-19,-79},{
          45.5,-79},{45.5,-90},{100,-90}},      color={0,0,127}));
  connect(radOnTiltedSurf_horizontal.OutTotalRadTilted, oc_total_rad[5])
    annotation (Line(
      points={{21,90},{42,90},{42,38},{100,38}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_north.OutTotalRadTilted, oc_total_rad[4])
    annotation (Line(
      points={{21,60},{38,60},{38,34},{100,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_east.OutTotalRadTilted, oc_total_rad[3])
    annotation (Line(
      points={{21,30},{100,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_south.OutTotalRadTilted, oc_total_rad[2])
    annotation (Line(
      points={{21,0},{38,0},{38,26},{100,26}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_west.OutTotalRadTilted, oc_total_rad[1])
    annotation (Line(
      points={{21,-30},{42,-30},{42,22},{100,22}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(Sun1.OutHourAngleSun, radOnTiltedSurf_horizontal.InHourAngleSun)
    annotation (Line(
      points={{-59,34},{-52,34},{-52,94},{-1,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutDeclinationSun, radOnTiltedSurf_horizontal.InDeclinationSun)
    annotation (Line(
      points={{-59,30},{-50,30},{-50,90},{-1,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutAzimutSun, radOnTiltedSurf_horizontal.InAzimutSun)
    annotation (Line(
      points={{-59,26},{-48,26},{-48,86},{-1,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutHourAngleSun, RadOnTiltedSurf_north.InHourAngleSun)
    annotation (Line(
      points={{-59,34},{-44,34},{-44,64},{-1,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutDeclinationSun, RadOnTiltedSurf_north.InDeclinationSun)
    annotation (Line(
      points={{-59,30},{-42,30},{-42,60},{-1,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutAzimutSun, RadOnTiltedSurf_north.InAzimutSun) annotation (
     Line(
      points={{-59,26},{-40,26},{-40,56},{-1,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutHourAngleSun, RadOnTiltedSurf_south.InHourAngleSun)
    annotation (Line(
      points={{-59,34},{-18,34},{-18,4},{-1,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutDeclinationSun, RadOnTiltedSurf_south.InDeclinationSun)
    annotation (Line(
      points={{-59,30},{-20,30},{-20,0},{-1,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Sun1.OutAzimutSun, RadOnTiltedSurf_south.InAzimutSun) annotation (
     Line(
      points={{-59,26},{-22,26},{-22,-4},{-1,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_east.InDeclinationSun, Sun1.OutDeclinationSun)
    annotation (Line(
      points={{-1,30},{-59,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_east.InHourAngleSun, Sun1.OutHourAngleSun)
    annotation (Line(
      points={{-1,34},{-59,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_east.InAzimutSun, Sun1.OutAzimutSun) annotation (
      Line(
      points={{-1,26},{-59,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_west.InHourAngleSun, Sun1.OutHourAngleSun)
    annotation (Line(
      points={{-1,-26},{-28,-26},{-28,34},{-59,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_west.InDeclinationSun, Sun1.OutDeclinationSun)
    annotation (Line(
      points={{-1,-30},{-30,-30},{-30,30},{-59,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RadOnTiltedSurf_west.InAzimutSun, Sun1.OutAzimutSun) annotation (
      Line(
      points={{-1,-34},{-32,-34},{-32,26},{-59,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y1[1], RadOnTiltedSurf_south.InDiffRadHor)
    annotation (Line(
      points={{-19,-61},{26,-61},{26,-18},{6,-18},{6,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y2[1], RadOnTiltedSurf_south.InBeamRadHor)
    annotation (Line(
      points={{-19,-64.6},{30,-64.6},{30,-16},{14,-16},{14,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y1[1], RadOnTiltedSurf_east.InDiffRadHor)
    annotation (Line(
      points={{-19,-61},{26,-61},{26,12},{6,12},{6,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y2[1], RadOnTiltedSurf_east.InBeamRadHor)
    annotation (Line(
      points={{-19,-64.6},{30,-64.6},{30,14},{14,14},{14,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y1[1], RadOnTiltedSurf_north.InDiffRadHor)
    annotation (Line(
      points={{-19,-61},{26,-61},{26,42},{6,42},{6,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y2[1], RadOnTiltedSurf_north.InBeamRadHor)
    annotation (Line(
      points={{-19,-64.6},{30,-64.6},{30,44},{14,44},{14,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y1[1], radOnTiltedSurf_horizontal.InDiffRadHor)
    annotation (Line(
      points={{-19,-61},{26,-61},{26,72},{6,72},{6,79}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DeMultiplex6.y2[1], radOnTiltedSurf_horizontal.InBeamRadHor)
    annotation (Line(
      points={{-19,-64.6},{30,-64.6},{30,74},{14,74},{14,79}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
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
          extent={{-26,2},{26,-50}},
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
          extent={{-100,-72},{100,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{-48,-68}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={180,90,0}),
        Ellipse(
          extent={{-64,-30},{-40,-54}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Sphere,
          fillColor={0,158,0}),
        Polygon(
          points={{-56,-68},{-68,-74},{-60,-74},{-48,-68},{-56,-68}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Sphere,
          fillColor={0,77,0}),
        Ellipse(
          extent={{-55,-72},{-80,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,77,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,28},{34,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,24},{42,18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,24},{48,32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,28},{54,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-28},{68,-68}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={226,226,226}),
        Line(points={{62,-34},{64,-34}}, color={0,0,0}),
        Line(points={{62,-36},{64,-36}}, color={0,0,0}),
        Line(points={{62,-46},{64,-46}}, color={0,0,0}),
        Line(points={{62,-40},{64,-40}}, color={0,0,0}),
        Line(points={{62,-38},{64,-38}}, color={0,0,0}),
        Line(points={{62,-44},{64,-44}}, color={0,0,0}),
        Line(points={{62,-42},{64,-42}}, color={0,0,0}),
        Line(points={{62,-48},{64,-48}}, color={0,0,0}),
        Line(points={{62,-50},{64,-50}}, color={0,0,0}),
        Line(points={{62,-52},{64,-52}}, color={0,0,0}),
        Line(points={{62,-54},{64,-54}}, color={0,0,0}),
        Line(points={{62,-56},{64,-56}}, color={0,0,0}),
        Line(points={{62,-58},{64,-58}}, color={0,0,0}),
        Line(
          points={{63,-37},{63,-65}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{63,-61},{63,-65}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{61,-29},{65,-33}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={226,226,226},
          textString=
               "°C"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString=
               "%name")}),
    Documentation(info="<html>
<p>
The <b>CombinedWeather</b> model aggregates a <a href=\"Sun\"><b>Sun</b></a> model, a TRY-file (test reference year) reader and four <a href=\"RadOnTiltedSurf\"><b>RadOnTiltedSurf</b></a> models to compute total solar radiation (beam and diffuse) on vertical surfaces heading north, west, south and east. Additionally, it passes on the ambient temperature, humidity of the ambient air, and ambient air pressure from the TRY-file. </p>
<p>
<b>HINT:</b> Use the <a href=\"Interfaces.Adaptors.demux_1x4\"><b>demux_1x4</b></a> model to extract the four radiation scalars from the output vector.
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
end CombinedWeather;
