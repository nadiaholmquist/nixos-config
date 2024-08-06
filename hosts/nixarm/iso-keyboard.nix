{ ... }:

{

  # So, Apple decided to do something very strange in macOS with ISO keyboards.
  # The key codes sent by the key left of "1" and the key right of Left Shift, the one not present on ANSI keyboards, are swapped when the keyboard type in macOS is set to ISO.
  # Wouldn't really be more than a technical oddity if it wasn't for the problem that no applications account for this, not even Apple's own Virtualization framework, so the keys in the VM will be swapped. That's pretty annoying!
  # ... So here I tell udev to swap them back.
  
  # Also swaps left/right Option and Command to be in the same spot as PC keyboards.

  services.udev.extraHwdb = ''
    evdev:input:b*v05ACp8105*
      KEYBOARD_KEY_70064=grave
      KEYBOARD_KEY_70035=102nd
      KEYBOARD_KEY_700e2=leftmeta
      KEYBOARD_KEY_700e3=leftalt
      KEYBOARD_KEY_700e6=rightmeta
      KEYBOARD_KEY_700e7=rightalt
  '';
}
