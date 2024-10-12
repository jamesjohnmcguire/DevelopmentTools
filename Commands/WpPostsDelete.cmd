CALL go Xampp
COPY /Y %USERPROFILE%\Data\ProgramData\Scripts\WpPostsDeleteBase.cmd .

@ECHO ON
CALL wp post list --post_type='revision' --format=ids > temp.txt

@ECHO ON
COPY /Y WpPostsDeleteBase.cmd + temp.txt DeleteCommand.cmd
@ECHO ON
CALL  DeleteCommand.cmd
DEL /Q WpPostsDeleteBase.cmd temp.txt DeleteCommand.cmd
