<chart>
id=133742006359390268
symbol=WINZ24
description=IBOVESPA MINI
period_type=0
period_size=5
digits=0
tick_size=5.000000
position_time=1729765800
scale_fix=0
scale_fixed_min=130405.000000
scale_fixed_max=132105.000000
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=8
mode=1
fore=0
grid=0
volume=2
scroll=0
shift=1
shift_size=49.951124
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=0
bidline=1
askline=0
lastline=1
days=1
descriptions=0
tradelines=1
tradehistory=1
window_left=78
window_top=78
window_right=948
window_bottom=498
window_type=3
floating=0
floating_left=0
floating_top=0
floating_right=0
floating_bottom=0
floating_type=1
floating_toolbar=1
floating_tbstate=
background_color=1447438
foreground_color=16777215
barup_color=11829830
bardown_color=255
bullcandle_color=11829830
bearcandle_color=255
chartline_color=65280
volumes_color=3329330
grid_color=10061943
bidline_color=10061943
askline_color=255
lastline_color=49152
stops_color=255
windows_total=2

<window>
height=125.311147
objects=8

<indicator>
name=Main
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Exodus Bands Ultimate Trading tools.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=4
fixed_height=-1

<graph>
name=Centered TMA
draw=10
style=2
width=1
arrow=251
color=-1
</graph>

<graph>
name=Centered TMA upper band
draw=1
style=0
width=5
arrow=251
color=255
</graph>

<graph>
name=Centered TMA lower band
draw=1
style=0
width=5
arrow=251
color=255
</graph>

<graph>
name=Rebound down
draw=3
style=0
width=1
arrow=226
color=-1
</graph>

<graph>
name=Rebound up
draw=3
style=0
width=1
arrow=225
color=-1
</graph>

<graph>
name=Centered TMA angle caution
draw=3
style=0
width=1
arrow=251
color=-1
</graph>
<inputs>
HalfLength=38
Price=6
AtrPeriod=100
AtrMultiplier=2.0
TMAangle=4
</inputs>
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Examples\ParabolicSAR.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=4
fixed_height=-1

<graph>
name=SAR(0.05,0.50)
draw=3
style=0
width=1
arrow=159
color=65535
</graph>
<inputs>
InpSARStep=0.05
InpSARMaximum=0.5
</inputs>
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=1
color=255
</graph>
period=9
method=0
</indicator>
<object>
type=1
name=M5 Horizontal Line 28303
value1=131974.801829
</object>

<object>
name=M5 Vertical Line 61335
ray=1
date1=1729788600
</object>

<object>
type=32
name=autotrade #114666034 sell 10 WINZ24 at 130795, WINZ24
hidden=1
color=1918177
selectable=0
date1=1729675756
value1=130795.000000
</object>

<object>
type=31
name=autotrade #114670194 buy 10 WINZ24 at 131095, WINZ24
hidden=1
descr=[Ordem de zerada automatica]
color=11296515
selectable=0
date1=1729678136
value1=131095.000000
</object>

<object>
type=32
name=autotrade #114670195 sell 10 WINZ24 at 130795, profit -600.00, 
hidden=1
descr=#133314659 by #133306657
color=1918177
selectable=0
date1=1729678136
value1=130795.000000
</object>

<object>
type=31
name=autotrade #114670196 buy 10 WINZ24 at 131095, profit 0.00, WINZ
hidden=1
descr=#133314659 by #133306657
color=11296515
selectable=0
date1=1729678136
value1=131095.000000
</object>

<object>
type=2
name=autotrade #114666034 -> #114670196, profit 0.00, WINZ24
hidden=1
descr=130795 -> 131095
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1729675756
date2=1729678136
value1=130795.000000
value2=131095.000000
</object>

<object>
type=2
name=autotrade #114670194 -> #114670195, profit -600.00, WINZ24
hidden=1
descr=131095 -> 130795
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1729678136
date2=1729678136
value1=131095.000000
value2=130795.000000
</object>

</window>

<window>
height=66.391847
objects=0

<indicator>
name=Custom Indicator
path=Indicators\Examples\RSI.ex5
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=1
scale_fix_min_val=0.000000
scale_fix_max=1
scale_fix_max_val=100.000000
expertmode=4
fixed_height=-1

<graph>
name=
draw=1
style=0
width=1
arrow=251
color=16748574
</graph>

<level>
level=20.000000
style=2
color=12632256
width=1
descr=
</level>

<level>
level=80.000000
style=2
color=12632256
width=1
descr=
</level>
<inputs>
InpPeriodRSI=14
</inputs>
</indicator>

<indicator>
name=Parabolic SAR
path=
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=131257.550000
scale_fix_min=0
scale_fix_min_val=130474.075000
scale_fix_max=0
scale_fix_max_val=132041.025000
expertmode=0
fixed_height=-1

<graph>
name=
draw=3
style=0
width=1
arrow=159
color=16777215
</graph>
step=0.050000
max=0.500000
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=131345.835000
scale_fix_min=0
scale_fix_min_val=130698.820500
scale_fix_max=0
scale_fix_max_val=131992.849500
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=1
color=255
</graph>
period=9
method=0
</indicator>
</window>
</chart>