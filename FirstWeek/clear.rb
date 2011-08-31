require 'green_shoes'
Shoes.app {
    @prose = <<EOF
    My eyes have blinked again
    And I have just realized
    This upright world
    I have been in.
             
    My eyelids wipe
    My eyes hundreds of times
    Resetting and renovating
    The scenery.
EOF
    @poem = stack {
      para @prose
    }
    para link("Clear"){@poem.clear}
}
