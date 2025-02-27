@echo off

title Building BO2-Reimagined

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source\dependencies" ^
--output-folder "%cd%\zone_source\dependencies" camo_materials

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_prison_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source\dependencies" ^
--output-folder "%cd%\zone_source\dependencies" camo_zmb_dlc2_materials

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\zm_tomb_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source\dependencies" ^
--output-folder "%cd%\zone_source\dependencies" camo_zmb_dlc4_materials

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\weapons!metalstorm_mms_sp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" weapons!metalstorm_mms_sp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\weapons!exptitus6_sp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" weapons!exptitus6_sp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\code_post_gfx.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" code_post_gfx

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\frontend_patch.ff" ^
--load "%OAT_GAME%\zone\all\frontend.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" frontend

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\afghanistan.ff" ^
--load "%OAT_GAME%\zone\all\so_cmp_afghanistan.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" afghanistan

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_patch_mp.ff" ^
--load "%OAT_GAME%\zone\all\common_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" common_mp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\code_post_gfx_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" code_post_gfx_mp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\english\en_code_post_gfx_mp.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" en_code_post_gfx_mp

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\patch_zm.ff" ^
--load "%OAT_GAME%\zone\all\common_zm.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" common_zm

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%OAT_GAME%\zone\all\patch_ui_zm.ff" ^
--load "%OAT_GAME%\zone\all\ui_zm.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" ui_zm

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_transit_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_transit.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_transit

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_nuked_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_nuked.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_nuked

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_highrise_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_highrise.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_highrise

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_prison.ff" ^
--load "%OAT_GAME%\zone\all\so_zencounter_zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_prison

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_buried_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_buried.ff" ^
--load "%OAT_GAME%\zone\all\so_zencounter_zm_buried.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_buried

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb_patch.ff" ^
--load "%OAT_GAME%\zone\all\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%\zone_source" zm_tomb

if %ERRORLEVEL% NEQ 0 pause

"%OAT_BASE%\Linker.exe" ^
--load "%cd%\zone_source\dependencies\camo_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc2_materials.ff" ^
--load "%cd%\zone_source\dependencies\camo_zmb_dlc4_materials.ff" ^
--load "%cd%\zone_source\weapons!metalstorm_mms_sp.ff" ^
--load "%cd%\zone_source\weapons!exptitus6_sp.ff" ^
--load "%cd%\zone_source\code_post_gfx.ff" ^
--load "%cd%\zone_source\frontend.ff" ^
--load "%cd%\zone_source\afghanistan.ff" ^
--load "%cd%\zone_source\common_mp.ff" ^
--load "%cd%\zone_source\code_post_gfx_mp.ff" ^
--load "%cd%\zone_source\en_code_post_gfx_mp.ff" ^
--load "%cd%\zone_source\common_zm.ff" ^
--load "%cd%\zone_source\ui_zm.ff" ^
--load "%cd%\zone_source\zm_transit.ff" ^
--load "%cd%\zone_source\zm_nuked.ff" ^
--load "%cd%\zone_source\zm_highrise.ff" ^
--load "%cd%\zone_source\zm_prison.ff" ^
--load "%cd%\zone_source\zm_buried.ff" ^
--load "%cd%\zone_source\zm_tomb.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%cd%" ^
--source-search-path "%cd%\zone_source" ^
--output-folder "%cd%" mod

if %ERRORLEVEL% NEQ 0 pause

del /s %cd%\zone_source\*.ff 1>nul

pwsh -Command "Compress-Archive -Force -Path attachmentunique,images,maps,scripts,ui,ui_mp,weapons -DestinationPath mod.iwd"

for %%f in (ff,iwd,sabs,sabl,json) do xcopy /i /y *.%%f ..\zm_reimagined

del *.iwd