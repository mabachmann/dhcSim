within dhcSim.DHC.ControlSystems;
model decentralNetController

  parameter dhcSim.DHC.ControlSystems.Types.ControlerTypes ctrlType=dhcSim.DHC.ControlSystems.Types.ControlerTypes.synchron
    "Define control type";

  parameter Integer nPro(min=1, max=Modelica.Constants.inf) = 1 "Number of producers";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_min = 0.001 * m_flow_nominal "Minimal mass flow rate";
  parameter Integer seq[nPro] = 1:nPro "Sequence of producer control" annotation(Dialog(enable=ctrlType
           == dhcSim.DHC.ControlSystems.Types.ControlerTypes.sequence));

  // controler parameter

  parameter Real sign_inp = 1 "Sign of input signals (1, -1). Use -1 for negetaive input values";

  parameter Real ctrlOffset = 0.01 "Offset between measured and set input value of controller if outside of cotrol range";

  parameter Modelica.Blocks.Types.SimpleController controllerType=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller";
  parameter Real k(min=0, unit="1") = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.InitPID initType= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));

  parameter dhcSim.Types.Reset reset=dhcSim.Types.Reset.Disabled
    "Type of controller output reset"
    annotation (Evaluate=true, Dialog(group="Integrator reset"));

  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge, used if reset == dhcSim.Types.Reset.Parameter"
    annotation(Dialog(enable=reset == dhcSim.Types.Reset.Parameter,
                      group="Integrator reset"));

  Real ProCtrl[nPro] "Control variable of producers";

  Buildings.Controls.Continuous.LimPID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    reverseActing=false,
    final reset=reset,
    final y_start=y_start,
    final y_reset=y_reset,
    final strict=strict,
    final yMax=1,
    final yMin=0)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_input
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput[nPro] ProCtrl_out
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression u_s_exp(y=sign_inp*max((1 - ctrlOffset)
        *m_flow_input, m_flow_min)/m_flow_nominal)
    annotation (Placement(transformation(extent={{-56,-12},{-36,8}})));
  Modelica.Blocks.Sources.RealExpression u_m_exp(y=sign_inp*m_flow_input/
        m_flow_nominal)
    annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
  Modelica.Blocks.Sources.RealExpression[nPro] ProCtrl_exp(y=ProCtrl)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

//initial equation
//  ProCtrl = zeros(nPro);

equation

  if ctrlType == dhcSim.DHC.ControlSystems.Types.ControlerTypes.synchron then
    ProCtrl = conPID.y.*ones(nPro);
  else
    ProCtrl = dhcSim.DHC.ControlSystems.Fuctions.ConvTotalSignal2Vec(
      nPro*conPID.y,
      nPro,
      seq);
  end if;

  connect(u_s_exp.y, conPID.u_s)
    annotation (Line(points={{-35,-2},{-12,-2}},
                                               color={0,0,127}));
  connect(u_m_exp.y, conPID.u_m)
    annotation (Line(points={{-35,-40},{0,-40},{0,-14}}, color={0,0,127}));
  connect(ProCtrl_exp.y, ProCtrl_out)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,94},{72,20}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{-84,-60},{-84,46},{-62,46}}, color={0,0,0}),
        Line(points={{-68,52},{-62,46},{-68,40}}, color={0,0,0}),
        Line(points={{72,46},{88,46},{88,-62}}, color={0,0,0}),
        Text(
          extent={{-60,90},{66,18}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="NetMngSys"),
        Rectangle(
          extent={{-62,-20},{72,-94}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-58,-26},{68,-98}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Network"),
        Line(points={{-84,-60},{-62,-60}}, color={0,0,0}),
        Line(points={{72,-62},{88,-62}}, color={0,0,0}),
        Line(
          points={{-3,6},{3,0},{-3,-6}},
          color={0,0,0},
          origin={75,-62},
          rotation=180),
        Text(
          extent={{-156,106},{144,146}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end decentralNetController;
