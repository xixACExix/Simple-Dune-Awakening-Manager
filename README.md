# DuneManager by Ace

Local Windows GUI manager for the Dune Awakening Self-Hosted Server package.

## Download

Use the latest release ZIP:

[DuneManager by Ace v1.0.0](https://github.com/xixACExix/DuneAwakening-Manager/releases/tag/v1.0.0)

Download `DuneManager-v1.0.0.zip`, extract it, then run:

```powershell
.\Start-DuneManager.bat
```

The launcher opens the GUI and requests Administrator access automatically. Administrator access is required for Hyper-V VM setup, VM start/stop, switch setup, and repair actions.

## Server Package Detection

DuneManager looks for the official Steam server package through Steam registry data, Steam `libraryfolders.vdf`, and common Steam library paths across local drives. You can override detection by setting:

```powershell
$env:DUNE_SERVER_ROOT = "<your Steam library>\steamapps\common\Dune Awakening Self-Hosted Server"
```

If the package is not found, the manager shows `Steam server package not found` and keeps VM-only actions available where possible.

## Main Features

- First-time setup automation: VM import, Hyper-V switch setup, VM memory, SSH key setup, password change, IP setup, bootstrap upload, and initial battlegroup setup.
- Region selection during first-time setup.
- Server settings editor for world title, Sietch name, join password, PvP, security zones, resource multipliers, storms, sandworm behavior, durability, deterioration, and building limits.
- Reinstall-safe local backups and restores for the battlegroup database plus manager-edited ini settings.
- Health watchdog with optional safe auto-repair.
- Manual repair button for failed startup/schema pods and stopped battlegroups.
- Quick actions for status, start, restart, stop, update, local backup, logs, file browser, and Director.
- Existing install detection that locks reinstall behind `Replace existing VM / reinstall`.

## Notes

Use the release ZIP, not GitHub's `Code` download button. The release package contains the manager scripts and the required SSH dependency in a clean user-ready layout.

The manager calls the official Dune Awakening self-hosted server scripts from the local Steam server package. It does not include or redistribute the game server package.

## License / Use

DuneManager by Ace may be used, copied, modified, and shared for personal, private, or community Dune Awakening self-hosted server management.

Do not sell it, bundle it as paid software, or present it as an official Funcom tool. Dune Awakening and related names belong to their owners.

This tool changes local Hyper-V and server files at your direction. Keep backups before updates, imports, or reinstalls.

Signed,
Ace
