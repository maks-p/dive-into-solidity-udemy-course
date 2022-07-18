//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public owner;
    uint256 constant ENTRANCE_FEE = 0.1 ether;

    // declaring modifiers
    modifier onlyOwner () {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }
    // declaring the constructor
    constructor() {
        owner = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        require(msg.value == ENTRANCE_FEE, "ENTRANCE_FEE_INCORRECT");
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // selecting the winner
    function pickWinner() public onlyOwner {
        require(players.length >= 3, "NOT_ENOUGH_PLAYERS");

        uint256 r = random();
        address winner;

        uint256 randomIdx = r % players.length;
        winner = players[randomIdx]; 

        gameWinners.push(winner);

        delete players;

        (bool success, ) = winner.call{value: address(this).balance}("");
        require(success, "BALANCE_NOT_TRANSFERRED");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    // getter that returns number of players
    function getNumberPlayers() public view returns (uint256) {
        return players.length;
    }
}
