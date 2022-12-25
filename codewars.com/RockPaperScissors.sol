// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^ 0.8.0;

contract RockPaperScissors {
    event GameCreated(address creator, uint gameNumber, uint bet);
    event GameStarted(address[]players, uint gameNumber);
    event GameComplete(address winner, uint gameNumber);

    enum State {
        JoinIn,
        MakeMove,
        Finished
    }

    enum Result {
        P1Win,
        P2Win,
        Draw
    }

    struct Game {
        bool initialized;
        State state;
        address[]players;
        uint betSize;
        uint p1Choice;
        uint p2Choice;
        Result result;
    }

    // Maps Game address => Game data
    mapping(uint => Game)public games;
    uint gamesCounter;

    /**
     * Use this endpoint to create a game.
     * It is a payable endpoint meaning the creator of the game will send ether directly to it.
     * The ether sent to the contract should be used as the bet for the game.
     * @param participant - The address of the participant allowed to join the game.
     */
    function createGame(address payable participant)public payable {

        require(msg.sender != participant, "Participant must have a different address");
        require(msg.value > 0, "No bet was sent");

        uint gameNumber = gamesCounter + 1;
      
        games[gameNumber].initialized = true;
        games[gameNumber].players.push(msg.sender);
        games[gameNumber].players.push(participant);
        games[gameNumber].betSize = msg.value;
        games[gameNumber].state = State.JoinIn;

        emit GameCreated(msg.sender, gameNumber, msg.value);
        gamesCounter++;
    }

    /**
     * Use this endpoint to join a game.
     * It is a payable endpoint meaning the joining participant will send ether directly to it.
     * The ether sent to the contract should be used as the bet for the game.
     * Any additional ether that exceeds the original bet of the creator should be refunded.
     * @param gameNumber - Corresponds to the gameNumber provided by the GameCreated event
     */
    function joinGame(uint gameNumber)public payable {

        require(games[gameNumber].initialized == true, "Game number does not exist");
        require(games[gameNumber].players[0] == msg.sender || games[gameNumber].players[1] == msg.sender, "You're not in this game");
        require(games[gameNumber].state == State.JoinIn, "Game not in correct phase. You cannot join in at this moment");

        uint originalBetSize = games[gameNumber].betSize;
        uint betSizeDiff = msg.value - originalBetSize;

        require(betSizeDiff >= 0, "Insuficient bet size");

        if (betSizeDiff > 0) {
            payable(msg.sender).transfer(betSizeDiff);
        }

        games[gameNumber].state = State.MakeMove;

        emit GameStarted(games[gameNumber].players, gameNumber);
    }

    /**
     * Use this endpoint to make a move during a game
     * @param gameNumber - Corresponds to the gameNumber provided by the GameCreated event
     * @param moveNumber - The move for this player (1, 2, or 3 for rock, paper, scissors respectively)
     */
    function makeMove(uint gameNumber, uint moveNumber)public {

        require(games[gameNumber].initialized == true, "Game number does not exist");
        require(games[gameNumber].players[0] == msg.sender || games[gameNumber].players[1] == msg.sender, "You're not in this game");
        require(games[gameNumber].state == State.MakeMove, "Game not in correct phase. You cannot join in at this moment");

        require(moveNumber >= 1 && moveNumber <= 3, "Invalid Move");

        bool p1NeedStart = (games[gameNumber].players[0] == msg.sender && games[gameNumber].p1Choice == 0);
        bool p2NeedStart = (games[gameNumber].players[1] == msg.sender && games[gameNumber].p2Choice == 0);
        require(p1NeedStart || p2NeedStart, "You already made your move, wait for the other player move");

        if (games[gameNumber].players[0] == msg.sender) {
            games[gameNumber].p1Choice = moveNumber;
        } else {
            games[gameNumber].p2Choice = moveNumber;
        }

        if (games[gameNumber].p1Choice != 0 && games[gameNumber].p2Choice != 0) {
            games[gameNumber].state = State.Finished;
            address winner = determineWinner(gameNumber);

            if (winner != address(0)) {
                payable(winner).transfer(games[gameNumber].betSize * 2);
            } else {
                payable(games[gameNumber].players[0]).transfer(games[gameNumber].betSize);
                payable(games[gameNumber].players[1]).transfer(games[gameNumber].betSize);
            }

            emit GameComplete(winner, gameNumber);
        }

    }

    function determineWinner(uint gameNumber)public returns(address) {

        uint choice = games[gameNumber].p1Choice;
        uint rivalChoice = games[gameNumber].p2Choice;

        if (choice == rivalChoice) {
            games[gameNumber].result = Result.Draw;
            return address(0);
        } else if (choice == 1) {
            if (rivalChoice == 3) {
                games[gameNumber].result = Result.P1Win;
                return games[gameNumber].players[0];
            } else {
                games[gameNumber].result = Result.P2Win;
                return games[gameNumber].players[1];
            }
        } else if (choice == 2) {
            if (rivalChoice == 1) {
                games[gameNumber].result = Result.P1Win;
                return games[gameNumber].players[0];
            } else {
                games[gameNumber].result = Result.P2Win;
                return games[gameNumber].players[1];
            }
        } else {
            if (rivalChoice == 2) {
                games[gameNumber].result = Result.P1Win;
                return games[gameNumber].players[0];
            } else {
                games[gameNumber].result = Result.P2Win;
                return games[gameNumber].players[1];
            }
        }

    }

}
