@IF "%1"=="dzw" GOTO dzw
@@IF "%1"=="japanese" GOTO japanese
@IF "%1"=="pokeman" GOTO pokeman
@IF "%1"=="root" GOTO root
@IF "%1"=="user" GOTO dzw
@GOTO end

:dzw
mysql --default-character-set=utf8 --show-warnings -u epiz_27292764 --password=STdhGWPpVRyl epiz_27292764_dzw
@GOTO end

:japanese
mysql --default-character-set=utf8 --show-warnings -u student --password=Genki5Nihon Japanese
@GOTO end

:pokeman
mysql --default-character-set=utf8 --show-warnings -u pokeman --password=Something5Else! gawa 
@GOTO end

:root
mysql --default-character-set=utf8 --show-warnings -u root --password=Nvtip7UCzK1U2
@GOTO end

:user
mysql --default-character-set=utf8 --show-warnings -u mp_renewal --password=metr0 dev_metropolis
@GOTO end

:end
