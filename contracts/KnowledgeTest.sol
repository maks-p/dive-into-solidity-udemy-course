//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    address public owner;
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;

    constructor() {
        owner = msg.sender;
    }

    function changeTokens() public {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function transferAll(address destination) public returns (bool, bytes memory){
        require(msg.sender == owner, "ONLY_OWNER");
        (bool success, bytes memory returnBytes) = destination.call{value: address(this).balance}(""); 
        return (success, returnBytes);
    }

    function start() public {
        players.push(msg.sender);
    }

    function concatenate(string calldata str1, string calldata str2) public pure returns (string memory) {
        return string(abi.encodePacked(str1, str2));
    }

    receive() external payable {}
}
