#!/bin/sh

# Initial graphic set up

declare -i board_width=31
declare -i game_width=80
declare -i game_height=20
BOLD='\x1b[1m'
RESET_BOLT='\x1b[22m'
WALL_CHAR='█'
BLOCK_CHAR='▃'
let SQUARE_WIDTH=(board_width-4)/3
let SQUARE_HEIGHT=board_width/7


# Hide cursor
printf '\x1b[?25l'
# Set terminal size to 20*80
printf "\e[8;${game_height};${game_width}t"
# Set background colour to yellow 229
printf '\x1b[48;5;229m' 
# Set foreground (text) colour to green 42
printf '\x1b[38;5;42m' 

draw_board()
{
clear
for row in {1..3}; do
    printf "$BOLD"
    printf "$WALL_CHAR%.0s" $(seq $board_width)
    for row_height in $(seq $SQUARE_HEIGHT); do
        printf "\n$WALL_CHAR"
        for column in {1..3}; do
            printf "%${SQUARE_WIDTH}s$WALL_CHAR"
        done
    done
    printf "\n"
done
printf "$WALL_CHAR%.0s" clea$(seq $board_width) 
printf "\n"
printf "$RESET_BOLT"
}

draw_board

#Make cursor visible
printf '\x1b[?25h'



