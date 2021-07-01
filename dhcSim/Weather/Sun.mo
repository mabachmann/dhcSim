within dhcSim.Weather;
model Sun "Solar radiation model"
  parameter Real Latitude(unit="deg") "latitude of location";
  parameter Real Longitude(unit="deg") "longitude of location in";
  parameter Real DiffWeatherDataTime(unit="h")
    "difference between local time and UTC, e.g. +1 for MET";
  Real NumberOfDay;
  Real AzimutSun;
  Real ElevationSun;
  Modelica.Blocks.Interfaces.RealOutput OutHourAngleSun
    annotation (Placement(transformation(extent={{100,30},{120,50}},
          rotation=0), iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput OutDeclinationSun
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput OutAzimutSun
    annotation (Placement(transformation(extent={{100,-50},{120,-30}},
          rotation=0), iconTransformation(extent={{100,-50},{120,-30}})));
protected
  Real DeclinationSun;
  Real HourAngleSun;
  Real TimeEquation;
  Real DayAngleSun;
  Real ArgACOS(min=-1, max=1)
    "helper variable to protect 'acos' from Arguments > 1";
equation
  // number of day: 1 = Jan 1st
  NumberOfDay = time/86400 + 1;
  // day angle of sun
  DayAngleSun = 360/365.25*(NumberOfDay - 1);
  // equation of time in hours - used to convert local time in solar time
  TimeEquation = -0.128*sin(from_deg(DayAngleSun - 2.8)) - 0.165*sin(
    from_deg(2*DayAngleSun + 19.7));
  // hour angle of sun, first term calculates local time of day from continuous time signal
  HourAngleSun = 15*(mod(time/3600, 24) - DiffWeatherDataTime +
    TimeEquation + Longitude/15 - 12);
  if (HourAngleSun > 180) then
    OutHourAngleSun = HourAngleSun - 360;
  elseif (HourAngleSun < -180) then
    OutHourAngleSun = HourAngleSun + 360;
  else
    OutHourAngleSun = HourAngleSun;
  end if;
  // declination of sun
  DeclinationSun = noEvent(to_deg(asin(0.3978*sin(from_deg(DayAngleSun
     - 80.2 + 1.92*sin(from_deg(DayAngleSun - 2.8)))))));
  OutDeclinationSun = DeclinationSun;
  // elevation of sun over horizon
  ElevationSun = noEvent(to_deg(asin(cos(from_deg(DeclinationSun))*cos(
    from_deg(OutHourAngleSun))*cos(from_deg(Latitude)) + sin(from_deg(
    DeclinationSun))*sin(from_deg(Latitude)))));
  // azimut of sun
  // AzimutSun = noEvent(to_deg(arctan((cos(from_deg(DeclinationSun))*sin(from_deg(
  //   OutHourAngleSun)))/(cos(from_deg(DeclinationSun))*cos(from_deg(
  //   OutHourAngleSun))*sin(from_deg(Latitude)) - sin(from_deg(
  //   DeclinationSun))*cos(from_deg(Latitude))))));
  ArgACOS = (sin(from_deg(ElevationSun))*sin(from_deg(Latitude)) - sin(
    from_deg(DeclinationSun)))/(cos(from_deg(ElevationSun))*cos(from_deg(
    Latitude)));
  AzimutSun = to_deg(acos(if noEvent(ArgACOS > 1) then 1 else (if
    noEvent(ArgACOS < -1) then -1 else ArgACOS)));
   if AzimutSun >= 0 then
     OutAzimutSun = 180 - AzimutSun;
   else
     OutAzimutSun = 180 + AzimutSun;
   end if;
algorithm
  // correcting azimut calculation for output
  // OutAzimutSun := AzimutSun;
  // while (OutAzimutSun < 0) loop
  //   OutAzimutSun := OutAzimutSun + 180;
  // end while;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,60}},
          lineColor={0,0,255},
          textString=
               "%name")}),
    DymolaStoredErrors,
    Diagram(graphics),
    Documentation(info="<html>
<p>
The <b>Sun</b> model computes the hour angle, the declination and the azimut of the sun for a given set of geographic position and local time. The model needs information on the difference between the local time zone (corresponding to the time basis of the simulation) and UTC (universal time coordinated) in hours. The ouput data of the <b>Sun</b> model is yet not very useful itself, but it is most commonly used as input data for e.g. <a href=\"RadOnTiltedSurf\"><b>RadOnTiltedSurf</b></a> models to compute the solar radiance according to the azimut of a surface.
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

</html>",
    revisions="<html>
<ul>
  <li><i>September 29, 2006&nbsp;</i>
         by Peter Matthes:<br>
         Included ArgACOS variable to protect acos function from arguments &gt; 1. Added protection for some variables.</li>
  <li><i>March 14, 2005&nbsp;</i>
         by Timo Haase:<br>
         Implemented.</li>
</ul>
</html>"));
end Sun;
