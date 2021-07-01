within dhcSim.DHC.Submodules.TwoPortModules.Interfaces;
function LogMeanTemp
  "Fucntion calculates logarithmic mean temperature of counter flow heat exchanger"

 input Modelica.SIunits.Temperature T1In "Temperature of inflow at network side";
 input Modelica.SIunits.Temperature T1Out "Temperature of outflow at network side";
 input Modelica.SIunits.Temperature T2In "Temperature of inflow at building side";
 input Modelica.SIunits.Temperature T2Out "Temperature of outflow at network side";
 output Modelica.SIunits.TemperatureDifference dTm "Logarithmic mean temperature";

protected
  parameter Modelica.SIunits.TemperatureDifference dT0 = abs(T1In-T2Out);
  parameter Modelica.SIunits.TemperatureDifference dTA = abs(T1Out-T2In);

algorithm

  if abs(dT0-dTA)<0.001 then
    dTm :=abs(dTA + dT0)/2;
  else
    dTm :=abs(abs(dTA - dT0)/Modelica.Math.log(dTA/dT0));
  end if;

end LogMeanTemp;
