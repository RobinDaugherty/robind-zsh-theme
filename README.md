# robind.zsh-theme

A ZSH theme forked from [agnoster's theme](https://github.com/agnoster/agnoster-zsh-theme),
with the addition of the current date and time.

![Screenshot](images/screenshot.png)

Optimized for people who use:

- Solarized color theme
- Git
- Unicode-compatible fonts and terminal software

For Mac users, I highly recommend a [Solarized Dark theme in Terminal](https://github.com/tomislav/osx-terminal.app-colors-solarized) with the Meslo Powerline font.

This theme shows:

- The current date and time
- Indication that the previous command failed (✘)
- Elevated (root) privileges (⚡)
- Indication of background tasks (⚙)
- User and hostname (if user is not `$DEFAULT_USER`, see below)
- Working directory
- Git and/or Mercurial status
  - Branch (![Branch Character](images/branch.png)) or detached head (➦)
  - Current branch or commit hash if in detached head state
  - Dirty working directory (±, color change)
- Active Ruby version (if [rbenv](https://github.com/rbenv/rbenv) is available)
- Name of the currently active Python virtual environment (if `$VIRTUAL_ENV` is set)

# Installation

Paste these commands to install the latest version of this theme and activate it:

```sh
mkdir -p ~/.oh-my-zsh/custom/themes
curl https://raw.githubusercontent.com/RobinDaugherty/robind-zsh-theme/master/robind.zsh-theme > ~/.oh-my-zsh/custom/themes/robind.zsh-theme
echo 'export ZSH_THEME="robind"' >> ~/.zshrc
```

Or, if you prefer to do it manually, place the theme file in your `.oh-my-zsh/custom/themes/` directory (create the directory if it doesn't exist) and set your `ZSH_THEME` to "robind".

(See https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes for more detail.)

## Compatibility

**NOTE:** In all likelihood, you will need to install a [Powerline-patched font](https://github.com/powerline/fonts) for this theme to render correctly.

To test if your terminal and font support it, check that all the necessary characters are supported by copying the following command to your terminal: `echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"`. The result should look like this:

![Character Example](images/characters.png)

If you are using a Powerline-patched font, and that still doesn't look right (especially the segment separator or branch symbols), then you may be using an old, incompatible version of the Powerline-patched fonts. Download and install a current version of the font. [More detail here.](https://github.com/robbyrussell/oh-my-zsh/issues/4065)

# Configuration

The theme can be configured by setting these environment variables:

* `DEFAULT_USER` - A user name you typically log in as, and which should be omitted from the prompt display when you are that user.

* `VIRTUAL_ENV_DISABLE_PROMPT` - If set, Python virtualenv will be disabled. It is enabled by default.

## Future Work

- Support for `rvm`
- Node version if using `nvm`
