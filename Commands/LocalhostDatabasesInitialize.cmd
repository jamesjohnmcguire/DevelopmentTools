:dzw
@ECHO OFF
CALL go dzw
CD SourceCode\Database
CALL DatabaseCreateEx epiz_27292764_dzw epiz_27292764 STdhGWPpVRyl
CALL DatabaseImport epiz_27292764_dzw epiz_27292764 STdhGWPpVRyl digitalzenworks.development.sql

:euro-casa
CALL go euro
CALL DatabaseCreateEx euro-casa_16qajr euro-casa iEFxiQXoc53ZayM
CALL DatabaseProductionGet.cmd
CALL LocalhostDatabaseUpdate.cmd

:inferret
CALL go inferret
CD SourceCode\Database
CALL DatabaseCreateEx inferret inferret 236J0s@0~/Kg
CALL DatabaseImport inferret inferret 236J0s@0~/Kg inferret.localhost.fast.sql

:irdi
CALL go irdi
CD SourceCode\Database
CALL DatabaseCreateEx Irdi IrdiUser WebDeveloper74#!
CALL DatabaseImport Irdi IrdiUser WebDeveloper74#! irdi.localhost.fast.sql

:japanese
CALL go japan
CD SourceCode\Database
CALL DatabaseCreateEx Japanese student Genki5Nihon
mysql -u student --password=Genki5Nihon Japanese < Schema.sql
mysql -u student --password=Genki5Nihon Japanese < Data.sql

:mailer
CALL go dotpix
CD mailer\BackUps
CALL ServerDatabaseExport full 161.97.79.20 root -i C:\Users\User\.ssh\jamesjohnmcguire@gmail.com.new.ppk 22 MailSender Anything57Goes#! Mailer /root
MOVE /Y Mailer.full.sql Mailer.production.sql
CALL DatabaseCreateEx Mailer MailSender Anything57Goes#!
CALL DatabaseImport Mailer MailSender Anything57Goes#! Mailer.production.sql

:panOrientNews
CALL go pan
CD SourceCode\Database
CALL DatabaseCreateEx PanOrientNews Reporter fKzwcKE4
CALL DatabaseImport PanOrientNews Reporter fKzwcKE4 PanOrientNewsWordPressLocal.sql
