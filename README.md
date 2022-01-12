![](demo.gif)

This repository demonstrates how to create bindings to use vim digraph bindings
anywhere native text input is used on your mac os.

This means you can type:

`CTRL`+`k` then `(` then `-` to insert the `∈` unicode symbol

If you're new to digraphs, open `vim` and issue `:help digraphs`

# To Install

### 1. Install [Karabiner](https://karabiner-elements.pqrs.org/)
### 2. Add a "complex modification" to map `CTRL+K` to `CTRL+SHIFT+F12` 
```
cp complex_modification.json ~/.config/karabiner/assets/complex_modifications/
```

>This is assuming you're not already using Karabiner for anything else.
>
> AFAIK, Karabiner wants you to add rules via browser
> commands (really?). I'm not sure how to just import this as json. 
> So, you could recreate this modification using
> https://genesy.github.io/karabiner-complex-rules-generator/ 
> Note, in mine I've set this to activate _unless_ the
> frontmost application's bundle identifier matches `com.apple.Terminal` (I'm
> assuming that if I'm in Terminal then I'm typing into vim and will use its
> native digraph support). 
> Then you 

### 3. Install KeyBindings

```
mkdir -p ~/Library/KeyBindings/
cp ./DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
```

### 4. Restart apps for change to take place

> Karabiner changes take place immediately, but `DefaultKeyBinding.dict`
> requires reloading apps. If you hear a "doink" when pressing `CTRL+K`, it may
> indicate an issue with `DefaultKeyBinding.dict`. Try restarting the app in
> use.


# Building `./DefaultKeyBinding.dict`

To regenerate the `./DefaultKeyBinding.dict` file run:

```
./build.rb
```

This ruby script will download the latest digraphs help page from vim on github.
It will scan through this file and and look through your `~/.vimrc` file for any
`digr ...` commands to generate a list of digraphs to create key bindings for.
