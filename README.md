# robind.zsh-theme

A ZSH theme forked from [agnoster's theme](https://github.com/agnoster/agnoster-zsh-theme),
with the addition of the current date and time.

Optimized for people who use:

- Solarized color theme
- Git
- Unicode-compatible fonts and terminal software

For Mac users, I highly recommend a [Solarized Dark theme in Terminal](https://github.com/tomislav/osx-terminal.app-colors-solarized) with the Meslo Powerline font.

## Compatibility

**NOTE:** In all likelihood, you will need to install a [Powerline-patched font](https://github.com/powerline/fonts) for this theme to render correctly.

To test if your terminal and font support it, check that all the necessary characters are supported by copying the following command to your terminal: `echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"`. The result should look like this:

![Character Example](images/characters.png)

If you are using a Powerline-patched font, and that still doesn't look right (especially the segment separator or branch symbols), then you may be using an old, incompatible version of the Powerline-patched fonts. Download and install a current version of the font.

## What does it show?

- If the previous command failed (✘)
- User @ Hostname (if user is not DEFAULT_USER, which can then be set in your profile)
- Git status
  - Branch (![Branch Character](images/branch.png)) or detached head (➦)
  - Current branch / SHA1 in detached head state
  - Dirty working directory (±, color change)
- Working directory
- Name of the currently active Python virtual environment
- Elevated (root) privileges (⚡)

![Screenshot](images/screenshot.png)

# Installation


# Configuration

The theme can be configured by setting these environment variables:

* `DEFAULT_USER` - A user name you typically log in as, and which should be omitted from the prompt display when you are that user.

* `VIRTUAL_ENV_DISABLE_PROMPT` - If set, Python virtualenv will be disabled. It is enabled by default.

## Future Work
