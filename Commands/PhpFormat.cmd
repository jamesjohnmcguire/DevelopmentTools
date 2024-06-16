call phpCB --space-after-if --space-after-switch --space-after-while --space-before-start-angle-bracket --space-after-end-angle-bracket --extra-padding-for-case-statement --one-true-brace-function-declaration --glue-amperscore --change-shell-comment-to-double-slashes-comment --indent-with-tab --force-large-php-code-tag --force-true-false-null-contant-lowercase --comment-rendering-style PHPDoc --equal-align-position 50 --padding-char-count 4 %1 >%1.tmp
ren %1 %.bak
ren %1.tmp %1
