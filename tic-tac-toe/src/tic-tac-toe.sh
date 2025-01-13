#!/bin/bash

readonly BLANK_TILE="_"
readonly CROSS="X"
readonly CIRCLE="O"
readonly CROSS_WIN="Crosses win!"
readonly CIRCLE_WIN="Circles win!"
readonly GAME_DRAW="Draw!"

currentPlayer=1; # player O = 1, player X = 2
selectedBlankTileIndex=-1; # numerical 0-8, verified to be blank
winText="" # if not empty, indicates that the game was finished
board=();

for i in {1..9}; do
    board+=("$BLANK_TILE");
done

function Main() {
    while true; do
        makeTurn;
        echoResultAndExitIfGameOver;
    done;
}

function makeTurn() {
    clear;
    displayBoard;

    echo -ne "\nCurrent player: ";
    if [ $currentPlayer -eq 1 ]; 
    then
        echo "CIRCLE";
    else
        echo "CROSS";
    fi

    getTileInput;
    if [ $currentPlayer -eq 1 ]; 
    then
        board[$selectedBlankTileIndex]="$CIRCLE";
        currentPlayer=2;
    else
        board[$selectedBlankTileIndex]="$CROSS";
        currentPlayer=1;
    fi
}

function echoResultAndExitIfGameOver() {
    local playerFieldVal;
    if [ $currentPlayer -eq 1 ];
    then
        # we check if previous player won (opposite to $currentPlayer)
        playerFieldVal="$CROSS"
    else
        playerFieldVal="$CIRCLE"
    fi

    local winScenarios=(
        "0 1 2" "3 4 5" "6 7 8"     # horizontal
        "0 3 6" "1 4 7" "2 5 8"     # vertical
        "0 4 8" "2 4 6"             # diagonal
    );

    for combo in "${winScenarios[@]}"; do
        set -- $combo

        if [[ ${board[$1]} = "$playerFieldVal" 
            && ${board[$2]} = "$playerFieldVal" 
            && ${board[$3]} = "$playerFieldVal" ]]; 
        then
            if [ $currentPlayer -eq 1 ]; 
            then
                clear;
                displayBoard;
                echo -e "\n$CROSS_WIN";
                exit;
            else
                clear;
                displayBoard;
                echo -e "\n$CIRCLE_WIN";
                exit;
            fi
        fi
    done

    for tile in ${board[@]}; do
        if [[ "$tile" = "$BLANK_TILE" ]];
        then
            return 0;
        fi
    done

    echo "$GAME_DRAW";
    exit;
}

function displayBoard() {
    echo -e "Kółeczko i krzyżyczek\n"
    echo -e "-------------\t-------------";
    echo -e "| ${board[0]} | ${board[1]} | ${board[2]} |\t| 1 | 2 | 3 |";
    echo -e "-------------\t-------------";
    echo -e "| ${board[3]} | ${board[4]} | ${board[5]} |\t| 4 | 5 | 6 |";
    echo -e "-------------\t-------------";
    echo -e "| ${board[6]} | ${board[7]} | ${board[8]} |\t| 7 | 8 | 9 |";
    echo -e "-------------\t-------------";
}

function getTileInput() {
    local input
    while true; do
        read -p "Select a tile from 1 to 9: " input;
        if [[ ! "$input" =~ ^[1-9]$ ]]; then
            echo "Invalid input. Please choose a number between 1 and 9.";
            continue;
        fi
        
        if [ "${board[$((input))-1]}" = "$BLANK_TILE" ]; 
        then
            selectedBlankTileIndex=$((input))-1;
            return 0;
        else
            echo "Tile is already drawn on.";
            continue;
        fi
    done;
}

Main;
