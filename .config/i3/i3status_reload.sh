#!/bin/bash

if grep -E 'status_command.+;$' ~/.config/i3/config
then
    # Remove the semicolon
    sed -i -E 's/(status_command.+) ;$/\1/' ~/.config/i3/config
else
    # Add the semicolon
    sed -i -E 's/(status_command.+)$/\1 ;/' ~/.config/i3/config
fi

i3-msg reload
