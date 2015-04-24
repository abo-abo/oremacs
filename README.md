# A tweak-able (and tweaked) Emacs config

This is my Emacs configuration. There are many like it, but this one is mine.

Actually, there aren't many like it, since it's highly personalized, with the key binding setup relying substantially on `xmodmap`.

This config is easy to replicate, perhaps easier than most starter kits out there.  But it's not meant for Emacs novices. You need to know at least some basic Elisp (like what `;` and `define-key` do).

It's up to you on how much of it you want to use:

- You can try to use it verbatim if you have the same opinion of ergonomics as me.
- You can re-define the keys but keep the package configurations.
- You can wipe everything and just keep the basic extensible and replicable structure.

I'm using only GNU/Linux, but there's no reason for it not to work on other systems.

# Requirements

Emacs 24 is required. Obviously, newer versions are better, but the default `emacs24` that you get from the package manager should work.

# Installation

This config doesn't assume to become your main config when you install it.  It installs in-place in the git directory and will start from there without touching your main config.  But you still get access to all your stuff, like bookmarks stored in your actual `~/.emacs.d/` etc.

```sh
cd ~/git
git clone https://github.com/abo-abo/oremacs
cd oremacs
make install
```

## Running

Run without updating:

```sh
make run
```

Run with an upstream + ELPA update:

```sh
make up
```

Run with an upstream + ELPA + org-mode + CEDET update:

```sh
make install
```

# Personal customization

If you want to track my upstream without difficulties, put your changes into `./oleh/personal/init.el`.  I have another git repository inside `./oleh/personal/` tracking stuff like my email address etc.

# Perks

## Standalone

You can try it without messing up your current Emacs config.  I actually have multiple versions of this on my system to work-around incompatibility between versions. This way, I can use my full setup even in case I get a bug report for an older Emacs version.

## Fast start up

With a SSD, it starts in 1 second. Most features are autoloaded and it's easy to add new autoloaded features.

## Tracks the most recent org-mode and CEDET

Since these packages take a long time to byte compile, they are updated not with `make up` but with `make install`. They are actually git submodules, which means that they won't update if I don't update them in the upstream.

## Bankruptcy-proof

It's hard to become Emacs-bankrupt with this config, since the config is composed of many independent pieces that you can simply ignore if you don't need them.

## Anti-RSI QWERTY mod

The config comes with its own `.Xmodmap` that makes <kbd>;</kbd> into an additional modifier. RSI savers:

- <kbd>;-v</kbd> instead of <kbd>Enter</kbd>.
- <kbd>;-o</kbd> instead of <kbd>Backspace</kbd>.
- <kbd>;-f</kbd> instead of <kbd>Shift-9</kbd> and <kbd>Shift-0</kbd>.
- <kbd>;-a</kbd> instead of <kbd>-</kbd>.
- <kbd>;-s</kbd> instead of <kbd>Shift--</kbd>.
- <kbd>;-q</kbd> instead of <kbd>Shift-'</kbd>.
- <kbd>;-e</kbd> instead of <kbd>=</kbd>.
- <kbd>;-u</kbd> in addition / instead of <kbd>C-u</kbd>.

And obviously the replacements for the two keys that the mod takes away:

- <kbd>;-j</kbd> instead of <kbd>;</kbd>.
- <kbd>;-d</kbd> instead of <kbd>Shift-;</kbd>.

One more Elisp-level RSI-saver is the swap between <kbd>C-p</kbd> and <kbd>C-h</kbd>. Moving up/down line is very important, and it's nice to have these keys close, which <kbd>C-n</kbd> and <kbd>C-h</kbd> are.

It also includes:

- a bunch of Hydras that save you key strokes.
- `lispy-mode` which quickens any LISP mode, especially Elisp.
- `worf-mode` which quickens `org-mode`.
- `ivy-mode` which quickens all completion.
- `swiper` which quickens `isearch` (by replacing it).
- C/C++ is customized with `function-args-mode` and a bunch of hacks.

## Org mode starter

The config starts you off with a fully configured `org-mode` setup that includes:

- gtd.org for getting things done.
- ent.org to track entertainment.
- wiki folder for quickly starting and selecting wikis.
