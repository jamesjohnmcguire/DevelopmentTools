#!/bin/bash

mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DELETE FROM wp_posts WHERE post_type = 'revision';"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DELETE FROM `wp_options` WHERE `option_name` LIKE ('$\_transient\_$');"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBadLeechers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBlockedCommentLog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBlockedIPLog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBlocks;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBlocks7;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfBlocksAdv;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfConfig;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfCrawlers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfFileChanges;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfFileMods;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfHits;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfHoover;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfIssues;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfKnownFileList;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfLeechers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfLiveTrafficHuman;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfLockedOut;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfLocs;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfls_settings;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfls_2fa_secrets;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfLogins;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfNet404s;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfNotifications;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfPendingIssues;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfReverseCache;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfSNIPCache;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfScanners;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfStatus;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfThrottleLog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wftrafficrates;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfVulnScanners;"

mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfbadleechers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfblockedcommentlog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfblockediplog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfblocks;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfblocks7;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfblocksadv;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfconfig;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfcrawlers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wffilechanges;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wffilemods;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfhits;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfhoover;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfissues;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfknownfilelist;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfleechers;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wflivetraffichuman;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wflockedout;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wflocs;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfls_settings;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfls_2fa_secrets;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wflogins;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfnet404s;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfnotifications;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfpendingissues;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfreversecache;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfsnipcache;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfscanners;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfstatus;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfthrottlelog;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wftrafficrates;"
mysql --default-character-set=utf8 --show-warnings -u $2 --password=$3 $1 -e "DROP TABLE wp_wfvulnscanners;"