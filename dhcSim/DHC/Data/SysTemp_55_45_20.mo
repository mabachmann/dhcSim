within dhcSimSep.DHC.Data;
record SysTemp_55_45_20 =
                       dhcSimSep.DHC.Data.SystemTemperatures (
    TRoo_nominal=273.15 + 20,
    TRoo=273.15 + 20,
    TAmb_nominal=273.15 - 15,
    TSup_nominal=273.15 + 55,
    TRet_nominal=273.15 + 45,
    m=1.3) "System temperatures 55/45/20";
