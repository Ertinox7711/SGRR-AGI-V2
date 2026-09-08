@echo off
setlocal
REM ===================================================================
REM  SGRR AGI V2 - ONE CLICK INSTALL (Windows)
REM
REM  Double-click this file. It installs the whole rig into %USERPROFILE%\.claude
REM  (CLAUDE.md, PITFALLS.md, memory, rules, commands, agents, scripts, skills,
REM  docs, shops, shopify, formations) and smart-merges the settings WITHOUT destroying your
REM  own keys, plugins, permissions or hooks.
REM
REM  Nothing is uploaded. No secret is ever read, asked for, or stored.
REM  Anything it overwrites with different content is backed up as <file>.bak-<date>.
REM
REM  Flags:  GO.bat /dry     -> show what would happen, write nothing
REM          GO.bat /minimal -> core only (no skills, docs, shops, shopify, formations)
REM ===================================================================

cd /d "%~dp0"

set "ARGS="
if /I "%~1"=="/dry"     set "ARGS=-DryRun"
if /I "%~1"=="/dryrun"  set "ARGS=-DryRun"
if /I "%~1"=="/minimal" set "ARGS=-Minimal"

echo.
echo  ===========================================================
echo    SGRR AGI V2  -  installing into %%USERPROFILE%%\.claude
echo  ===========================================================
echo.

where powershell >nul 2>&1
if errorlevel 1 (
  echo  [X] powershell not found on PATH. Cannot continue.
  echo      Run install.ps1 manually from a PowerShell window.
  goto :end
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %ARGS%
if errorlevel 1 (
  echo.
  echo  [X] The installer reported an error. Nothing else was run.
  goto :end
)

echo.
echo  -----------------------------------------------------------
echo   Files are in place. Two things left, INSIDE Claude Code:
echo.
echo     1^) /plugin marketplace add JuliusBrussee/caveman
echo        then enable the plugins listed in SETUP.md
echo        ^(or paste INSTALLER-PROMPT.md and let Claude do it^)
echo.
echo     2^) restart Claude Code, then run  /session-check
echo        -^> GO/NO-GO verdict that the rig is actually live
echo.
echo   Then personalise:
echo     %%USERPROFILE%%\.claude\protected-zones.json   ^(your read-only folders^)
echo     %%USERPROFILE%%\.claude\shops-registry.md      ^(your stores, if any^)
echo     %%USERPROFILE%%\.claude\CLAUDE.md              ^(fill the ^<PLACEHOLDER^>s^)
echo  -----------------------------------------------------------
echo.

:end
echo.
pause
endlocal
