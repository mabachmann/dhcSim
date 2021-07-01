within dhcSim.DHC.Submodules.TwoPortModules.Interfaces;
function CharCounterFlowHX
  "Characteristic of counter flow heat exchanger"

  input Real Phi "Characteristic of heat exchanger";
  input Real NTU "Number of Transfer units of heat exchanger";
  input Real R "Coefficient between heat capacity flows";
  output Real y "Output variable";

algorithm

  y:=(1-Modelica.Math.exp(-NTU+NTU*R))/(1-R*Modelica.Math.exp(-NTU+R*NTU))-Phi;

end CharCounterFlowHX;
