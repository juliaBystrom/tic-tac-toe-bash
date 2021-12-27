#!/bin/sh

# Initial graphic set up

declare -i board_width=43
declare -i game_width=80
declare -i game_height=20
declare -i player_in_turn=1
# Three following indices indicate a 
declare -ai WIN=(0 1 2 3 4 5 6 7 8 # horizontal win
                    0 4 8 2 4 6 # diagonal win 
                    0 3 6 1 4 7 2 5 8) # vertical win 
declare -i winner_index

BOLD='\x1b[1m'
RESET_BOLT='\x1b[22m'
WALL_CHAR='█'
BLINK='\x1b[5m'
RESET_BLINK='\x1b[25m'
GREEN_F='\x1b[38;5;42m'
WIN_F_COL='\x1b[38;5;5m'

let SQUARE_WIDTH=(board_width-4)/3-1
let SQUARE_HEIGHT=board_width/7-1


# Hide cursor
printf '\x1b[?25l'
# Set terminal size to 20*80
printf "\e[8;${game_height};${game_width}t"
# Set background colour to yellow 229
printf '\x1b[48;5;229m' 
# Set foreground (text) colour to green 42
printf $GREEN_F

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

declare -a player1=(' \       / ' '   \   /   ' '     X     ' '   /   \   ' ' /       \ ')
declare -a player2=('    ▄▄▄    ' ' ▟█▘   ▝█▙ ' '▐         ▌' ' ▜█▖   ▗█▛ ' '    ▀▀▀    ')


switch_player_in_turn()
{
if [ $player_in_turn -eq 1 ]; then
    player_in_turn=2
else
    player_in_turn=1
fi
}

is_winning_square()
{

if [ -n "$winner_index" ]; then
    if [[ $1 -eq ${WIN[$((winner_index*3))]} ||
         $1 -eq ${WIN[$((winner_index*3+1))]} ||
         $1 -eq ${WIN[$((winner_index*3+2))]} ]]; then 
        echo true
    else
        echo false
    fi
else
    echo false
fi
}

draw_board()
{
# clear
for row in {0..2}; do
    printf "$BOLD"
    printf "$WALL_CHAR%.0s" $(seq $board_width)
    for row_height in $(seq $SQUARE_HEIGHT); do
        printf "\n$WALL_CHAR"
        for col in {0..2}; do
            winning=$(is_winning_square $((row*3+col)))
            if $winning ; then
                printf "$WIN_F_COL$BLINK"
            fi
            case ${board[row*3+col]} in
                0)
                    printf "%${SQUARE_WIDTH}s $WALL_CHAR"
                    ;;
                1)
                    printf " ${player1[row_height-1]}"
                    printf "$GREEN_F$RESET_BLINK $WALL_CHAR"
                    ;;
                2)
                    printf " ${player2[row_height-1]}"
                    printf "$GREEN_F$RESET_BLINK $WALL_CHAR"
                    ;;
                *)
                    # Error
                    printf "%${SQUARE_WIDTH}sE$WALL_CHAR"
                    ;;
            esac
            if $winning ; then
                printf "$GREEN_F$RESET_BLINK"
            fi
        done
    done
    printf "\n"
done
printf "$WALL_CHAR%.0s" clea$(seq $board_width) 
printf "\n"
printf "$RESET_BOLT"
}

square_is_playable()
{
if [ ${board[$1-1]} -eq 0 ]; then
    echo true
else
    echo false
fi
}

get_player_move()
{
while true; do
    INPUT="no"
    local reg='^[1-9]$'
    while [[ ! $INPUT =~ $reg ]]; do
        read -n 1 -p "NR " -r INPUT
        printf "U: $player_in_turn input: $INPUT \n" >> log.txt # Log
    done
    playable=$(square_is_playable $INPUT)
    if $playable; then
        echo $INPUT
        break
    fi
done
}

update_board()
{
printf "Update board id: $(($1-1)) \n" >> log.txt # Log
if [ $player_in_turn -eq 1 ]; then
    board[$1-1]=1
else
    board[$1-1]=2
fi
    
}

check_board()
{
  #printf "\n pl in t: $player_in_turn"
  for i in {0..7}; do
    if [[ "board[${WIN[$((i*3))]}]" -eq $player_in_turn && 
          "board[${WIN[$((i*3+1))]}]" -eq $player_in_turn &&
          "board[${WIN[$((i*3+2))]}]" -eq $player_in_turn ]]; then

        printf "Detected win id $i : board[${WIN[$((i*3))]}] 
                                   : board[${WIN[$((i*3+1))]}] 
                                   : board[${WIN[$((i*3+2))]}] \n" >> log.txt # Log
        echo $i
        break
    fi
  done
}

draw_winner()
{
    printf "Winner $1 \n"
    winner_index=$1
    draw_board
    sleep 2
    exit 0

}

printf " >>>>>>>> GAME <<<<<<<< \n" > log.txt # Log

while true; do 
    draw_board
    move=$(get_player_move)
    printf "Move for: $player_in_turn move: $move \n" >> log.txt # Log
    printf "\n"
    update_board $move
    win=$(check_board)
    reg='^[0-7]$'
    if [[ -n $win && $win =~ $reg ]]; then
        draw_winner $win
    fi
    switch_player_in_turn
done
    


#Make cursor visible
printf '\x1b[?25h'
