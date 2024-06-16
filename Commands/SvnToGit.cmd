@ECHO OFF
ECHO Argument 1: Path to your repository
ECHO Argument 2: Path to your new Git working directory
ECHO Argument 3: Relative URL segment of bitbucket repository, without .git
ECHO.
ECHO Create authors.txt file
ECHO It will contain lines like:
ECHO "JamesMc = James John McGuire <jamesjohnmcguire@gmail.com>"
ECHO.
PAUSE

ECHO Starting service...
ECHO If the service is disabled, it will need to be manually set to Manual.
@ECHO ON
sc create svnserve binpath= "\"C:\Program Files\CollabNet\Subversion Client\svnserve.exe\" --service --root C:\Users\JamesMc\Data\Repositories\Svn" displayname= "Subversion Server" depend= tcpip start= auto
sc start svnserve
PAUSE

@ECHO OFF
SET Temp=Temp
CD %USERPROFILE%\Data
@ECHO ON
CD Clients
IF EXIST bare.git\NUL RD /S /Q bare.git
IF EXIST %Temp%\NUL RD /S /Q %Temp%

@ECHO OFF
REM The following will not work, if SVN is using a newer FS than what Git is aware of
REM git svn clone file:///%1 --prefix=svn/ --no-metadata -A authors.txt --stdlayout %Temp%
REM So, use
@ECHO ON
REM If empty, perhaps try removing --stdlayout
git svn clone svn://localhost/%1 --prefix=svn/ --no-metadata --stdlayout -A authors.txt %Temp%
sc stop svnserve
sc delete svnserve
PAUSE

REM GitIgnore
cd %Temp%
git svn show-ignore > .gitignore

git add .gitignore
git commit -m "Convert svn:ignore properties to .gitignore."

REM clean up SVN type stuff
git branch -rd svn/trunk
cd ..

REM Manual changes if needed for tags
REM git for-each-ref --format='%(refname)' refs/heads/tags |
REM cut -d / -f 4 |
REM while read ref
REM do
REM   git tag "$ref" "refs/heads/tags/$ref";
REM   git branch -D "tags/$ref";
REM done

REM Working Directory
ren %Temp% %2

cd %2
git checkout main

REM git remote remove origin
PAUSE

REM Add remotes, like:
REM git remote add origin https://<username>@bitbucket.org/<username>/<projectname>.git
git remote add origin https://jamesjohnmcguire@bitbucket.org/jamesjohnmcguire/%3.git

git push -u origin main
