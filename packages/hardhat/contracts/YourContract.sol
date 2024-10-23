//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

contract YourContract {

	enum Side {
		Kamala,
		Trump
	}

	struct Result {
		Side winner;
		Side loser;
	}

	Result public result;
	bool public electionFinished;
	mapping (Side => uint) public betsPerCandidate;
	mapping (address => mapping (Side => uint)) public betsPerGambler;
	address public oracle;

	constructor (address _oracle) {
		oracle = _oracle;
	}

	//function for placing bet
	function bet (Side _side) external payable {
		require(electionFinished == false, "Election already finished");
		betsPerCandidate[_side] += msg.value;
		betsPerGambler[msg.sender][_side] += msg.value;
	}

	//withdraw
	function withdraw () external {
		uint gamblerBet = betsPerGambler[msg.sender][result.winner];
		require(gamblerBet > 0, "You do not have any bets to withdraw");
		require(electionFinished == true, "Election not finished yet");
		uint gain = gamblerBet + betsPerCandidate[result.loser] + gamblerBet / betsPerCandidate[result.winner];
		betsPerGambler[msg.sender][Side.Kamala] = 0;
		betsPerGambler[msg.sender][Side.Trump] = 0;
		(bool success, ) = payable(msg.sender).call{value: gain}("");
		require(success == true, "Failed to withdraw");
	}

	// Report
	function report (Side _winner, Side _loser) external {
		require(oracle == msg.sender, "Only oracle can report");
		require(_winner != _loser, "Winner and loser cannot be the same");
		result.winner = _winner;
		result.loser = _loser;
		electionFinished = true;
	}
}