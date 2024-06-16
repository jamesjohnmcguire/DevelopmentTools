for /d /r . %%d in (.nuget,bin,debug,ipch,obj,packages,release,ReleaseMinSize,x86,x64,UnicodeDebug,"Unicode Debug") do @if exist "%%d" rd /s/q "%%d"

ATTRIB /S -h *.*

DEL /Q /S *.~?? *.??~ *.___ *.--- *.aps *.bak *.bsc *.cache *.csm *.docstates *.dsp *.dsw *.err *.exp *.hpj *.ilk *.idb *.log *.map *.ncb *.obj *.old *.opendb *.opensdf *.opt *.pch *.pdb *.plg *.rws *.sdf *.sbr *.suo *.sym *.tmp *.t?w TestResult.xml *.vcw *.VisualState.xml *.vs10x *.wsp Resource.Designer.cs UpgradeLog.htm

@IF "%1"=="full" DEL /Q /S *.user
@IF "%1"=="full" rd /s/q .vs
