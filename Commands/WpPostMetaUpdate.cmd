REM Arguments are postId, meta_key, meta_value
CD \Util\Xampp\htdocs

@ECHO ON
wp post meta update %1 %2 %3
