within dhcSimSep.DHC.Data;
record SystemTemperatures
  "System temperatures of building heating system"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Temperature TRoo_nominal "Nominal room temperature";
  parameter Modelica.SIunits.Temperature TRoo "Set room temperature";
  parameter Modelica.SIunits.Temperature TAmb_nominal "Nominal ambient temperature";
  parameter Modelica.SIunits.Temperature TSup_nominal "Nominal supply temperature";
  parameter Modelica.SIunits.Temperature TRet_nominal "Nominal return temperature";
  parameter Real m "Radiator index";

 annotation (preferredView="info",
 defaultComponentPrefixes="parameter",
 defaultComponentName="datThePro",
  Documentation(info="<html>
  Base record for nominal building temperatures. 
<br/>

</html>"), Icon(graphics={
        Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
        Text(
          extent={{-80,36},{-10,12}},
          lineColor={0,0,0},
          textString="T_iNom=%T_iNom"),
        Text(
          extent={{-80,-58},{-6,-88}},
          lineColor={0,0,0},
          textString="T_aNom=%T_aNom"),
        Text(
          extent={{-74,-12},{-14,-36}},
          lineColor={0,0,0},
          textString="T_i=%T_i"),
        Line(points={{-100,0},{100,0}},     color={0,0,0}),
        Text(
          extent={{12,36},{82,12}},
          lineColor={0,0,0},
          textString="T_sNom=%T_sNom"),
        Text(
          extent={{12,-12},{82,-36}},
          lineColor={0,0,0},
          textString="T_rNom=%T_rNom"),
        Text(
          extent={{10,-62},{80,-86}},
          lineColor={0,0,0},
          textString="M_A=%M_A")}));
end SystemTemperatures;
