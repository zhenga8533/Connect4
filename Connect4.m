clc, clear

% Initial variables
rows = input("Choose the row size: ");
columns = input("Choose the column size: ");

clc

board = zeros(rows, columns);
board = displayBoard(board);
win = 0;

while win == 0
    % Resets player turns
    turn1 = 1;
    turn2 = 1;
    
    % Player 1 turn phase
    board = runTurn(1, board);
    win = checkWin(board, 1);
    
    % Player 2 turn phase
    if win == 0
        board = runTurn(2, board);
        win = checkWin(board, 2);
    end
end

% Final statement, declares winner

if win == 1
    fprintf("Player O wins!")
elseif win == 2
    fprintf("Player X wins!")
else
    fprintf("The game is a tie!")
end

% Runs a turn for either player
function board = runTurn(player, board)
    turn = 1;
    columns = length(board(1, :));
    
    while turn
        if player == 1
            fprintf("Player O, choose a column to drop in (1-%i): ", columns)
        else
            fprintf("Player X, choose a column to drop in (1-%i): ", columns)
        end
        drop = input("");
        % && is not used to detect if drop is blank
        if drop > 0
            if drop <= columns
                if board(1, drop) == 0
                   board = dropPiece(player, board, drop);
                   turn = 0;
                else
                    fprintf("That column is full.\n\n")
                end
            else
                fprintf("That column is out of bounds.\n\n")
            end
        else
            fprintf("That column is out of bounds.\n\n")
        end
    end
    
    clc
    board = displayBoard(board);
    return
end

% Draws out the board into the command window
function board = displayBoard(board)
    fprintf("Current Board:\n")
    rows = length(board(:, 1));
    columns = length(board(1, :));
    for i = 1:rows
        rowNum = rows-i+1;
        fprintf(2, " %i ", rowNum)
        for j = 1:columns
            if board(i, j) == 0
                fprintf('  -  ')
            elseif board(i, j) == 1
                fprintf("  O  ")
            elseif board(i, j) == 2
                fprintf("  X  ")
            end
        end
        fprintf("\n")
    end
    
    fprintf("   ")
    for i = 1:columns
        fprintf(2, "  %i  ", mod(i, 10))
    end
    fprintf("\n\n")
    
    return
end

% Drops a piece onto the board relative to a player
function board = dropPiece(player, board, column)
    rows = length(board(:, 1));
    for i = 1:rows
        if board(i, column) ~= 0
            board(i - 1, column) = player;
            break
        elseif i == rows
            board(i, column) = player;
        end
    end
    return
end

% Checks for a win for a specific player
function win = checkWin(board, player)
    rows = length(board(:, 1));
    columns = length(board(1, :));
    win = 0;
    winCon = [player, player, player, player];
    
    % Vertical check
    for i = 1:columns
        for j = 1:rows - 3
            checkSet = [board(j, i), board(j+1, i), board(j+2, i), board(j+3, i)];
            if checkSet == winCon
                win = player;
            end
        end
    end
    
    % Diagonal check \
    for i = 1:columns - 3
        for j = 1:rows - 3
            checkSet = [board(j, i), board(j+1, i+1), board(j+2, i+2), board(j+3, i+3)];
            if checkSet == winCon
                win = player;
            end
        end
    end
    
    % Diagonal check /
    for i = 1:columns - 3
        for j = rows:-1:4
            checkSet = [board(j, i), board(j-1, i+1), board(j-2, i+2), board(j-3, i+3)];
            if checkSet == winCon
                win = player;
            end
        end
    end
    
    % Horizontal check
    for i = 1:rows
        for j = 1:columns - 3
            checkSet = [board(i, j), board(i, j+1), board(i, j+2), board(i, j+3)];
            if checkSet == winCon
                win = player;
            end
        end
    end
    
    % Check tie
    count = 0;
    for i = 1:columns
        if board(1, i) ~= 0
            count = count + 1;
        end
    end
    if count == columns
        win = 3;
    end
    
    return
end