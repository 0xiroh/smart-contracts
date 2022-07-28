//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Lottery {
    uint public minFee;
    address public owner;
    address[] players;
    uint public availableTix;
    mapping(address => uint) public playerBalances;


    constructor(uint _minFee, uint _availableTix) {
        minFee = _minFee;
        availableTix = _availableTix;
        owner = msg.sender;
    }

    function buyLotteryTicket() public payable minFeeToPay {
        require(msg.value >= minFee, "Pay moar");
        require(availableTix > 0);
        players.push(msg.sender);
        availableTix = availableTix - 1;
        playerBalances[msg.sender] ++;

    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getRandomNumber() public view returns(uint256) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % players.length;
        (bool success, ) = players[index].call{value:getBalance()}("");
        require(success, "Pago fallido, favor reintentar");
        players = new address[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier minFeeToPay() {
        require(msg.value >= minFee);
        _;
    }
}