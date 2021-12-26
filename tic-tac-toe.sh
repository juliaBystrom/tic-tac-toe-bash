#!/bin/sh

# Initial graphic set up

declare -i board_width=43
declare -i game_width=80
declare -i game_height=20
BOLD='\x1b[1m'
RESET_BOLT='\x1b[22m'
WALL_CHAR='█'
BLOCK_CHAR='▃'
let SQUARE_WIDTH=(board_width-4)/3-1
let SQUARE_HEIGHT=board_width/7


# Hide cursor
printf '\x1b[?25l'
# Set terminal size to 20*80
printf "\e[8;${game_height};${game_width}t"
# Set background colour to yellow 229
printf '\x1b[48;5;229m' 
# Set foreground (text) colour to green 42
printf '\x1b[38;5;42m'

##################################################################################
#   Each number in board represent a square in the game by index as follow:
#                                   0  1  2
#                                   3  4  5
#                                   6  7  8
#
#   The value of the number indicate the following:
#   0 = Empty       1 = Player1 in square          2 = Player2 in swuare
##################################################################################
declare -ai board=(0 1 1 0 2 0 0 2 0)



draw_board()
{
clear
for row in {0..2}; do
    printf "$BOLD"
    printf "$WALL_CHAR%.0s" $(seq $board_width)
    for row_height in $(seq $SQUARE_HEIGHT); do
        printf "\n$WALL_CHAR"
        for col in {0..2}; do
            case ${board[row*3+col]} in
                0)
                    printf "%${SQUARE_WIDTH}s $WALL_CHAR"
                    ;;
                1)
                    printf "%${SQUARE_WIDTH}s1$WALL_CHAR"
                    ;;
                2)
                    printf "%${SQUARE_WIDTH}s2$WALL_CHAR"
                    ;;
                *)
                    printf "%${SQUARE_WIDTH}sE$WALL_CHAR"
                    ;;
            esac
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