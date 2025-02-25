<chart>
id=133743524398529251
symbol=WINZ24
description=IBOVESPA MINI
period_type=0
period_size=5
digits=0
tick_size=5.000000
position_time=0
scale_fix=0
scale_fixed_min=131255.000000
scale_fixed_max=132505.000000
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=8
mode=1
fore=0
grid=0
volume=0
scroll=0
shift=1
shift_size=49.570201
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=1
bidline=1
askline=0
lastline=1
days=1
descriptions=0
tradelines=0
tradehistory=1
window_left=0
window_top=0
window_right=0
window_bottom=0
window_type=1
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
barup_color=8421376
bardown_color=16777215
bullcandle_color=8421376
bearcandle_color=0
chartline_color=65280
volumes_color=3329330
grid_color=10061943
bidline_color=10061943
askline_color=255
lastline_color=49152
stops_color=255
windows_total=2

<window>
height=151.500896
objects=9

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
arrow=251
color=65535
</graph>
period=25
method=0
</indicator>
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
type=31
name=autotrade #114817447 buy 1 WINZ24 at 131725, WINZ24
hidden=1
color=11296515
selectable=0
date1=1729863001
value1=131725.000000
</object>

<object>
type=32
name=autotrade #114817740 sell 1 WINZ24 at 131825, TP, profit 20.00,
hidden=1
descr=[tp 131825]
color=1918177
selectable=0
date1=1729863295
value1=131825.000000
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

<object>
type=2
name=autotrade #114817447 -> #114817740, TP, profit 20.00, WINZ24
hidden=1
descr=131725 -> 131825
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1729863001
date2=1729863295
value1=131725.000000
value2=131825.000000
</object>

</window>

<window>
height=42.216310
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
color=255
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
scale_line_value=131925.000000
scale_fix_min=0
scale_fix_min_val=131422.850000
scale_fix_max=0
scale_fix_max_val=132427.150000
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
scale_line_value=131821.945000
scale_fix_min=0
scale_fix_min_val=131592.380500
scale_fix_max=0
scale_fix_max_val=132051.509500
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=0
width=2
color=65535
</graph>
period=9
method=0
</indicator>
</window>
</chart>