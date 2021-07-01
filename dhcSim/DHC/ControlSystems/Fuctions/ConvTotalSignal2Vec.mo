within dhcSim.DHC.ControlSystems.Fuctions;
function ConvTotalSignal2Vec
  "Functions that converts the total producer signal to several producer signals of all producers"

  input Real u_tot "Total control signal";
  input Integer nPro "Amount of producer";
  input Integer[nPro] seq "Sequence for output control";
  output Real[nPro] y "Output signal";

algorithm

  for i in 0:(nPro-1) loop
    y[seq[i+1]] :=max(min(u_tot - i, 1),0);
  end for;

end ConvTotalSignal2Vec;
