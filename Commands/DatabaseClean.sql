DELETE FROM wp_posts WHERE post_type = 'revision';
DELETE FROM `wp_options` WHERE `option_name` LIKE ('%\_transient\_%');
DROP TABLE wp_wfBadLeechers;
DROP TABLE wp_wfBlockedCommentLog;
DROP TABLE wp_wfBlockedIPLog;
DROP TABLE wp_wfBlocks;
DROP TABLE wp_wfBlocks7;
DROP TABLE wp_wfBlocksAdv;
DROP TABLE wp_wfConfig;
DROP TABLE wp_wfCrawlers;
DROP TABLE wp_wfFileChanges;
DROP TABLE wp_wfFileMods;
DROP TABLE wp_wfHits;
DROP TABLE wp_wfHoover;
DROP TABLE wp_wfIssues;
DROP TABLE wp_wfKnownFileList;
DROP TABLE wp_wfLeechers;
DROP TABLE wp_wfLiveTrafficHuman;
DROP TABLE wp_wfLockedOut;
DROP TABLE wp_wfLocs;
DROP TABLE wp_wfls_settings;
DROP TABLE wp_wfls_2fa_secrets;
DROP TABLE wp_wfLogins;
DROP TABLE wp_wfNet404s;
DROP TABLE wp_wfNotifications;
DROP TABLE wp_wfPendingIssues;
DROP TABLE wp_wfReverseCache;
DROP TABLE wp_wfSNIPCache;
DROP TABLE wp_wfScanners;
DROP TABLE wp_wfStatus;
DROP TABLE wp_wfThrottleLog;
DROP TABLE wp_wftrafficrates;
DROP TABLE wp_wfVulnScanners;