// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Staking {
    address public owner;
    address public token;

    mapping(address => StakingInfo) public stakingInfo;

    struct StakingInfo {
        uint256 amount; // Amount of ERC20 tokens staked
        uint256 startTime; // Timestamp when staking started
        uint256 endTime; // Timestamp when staking ends
        uint256 rewards; // Rewards earned
    }

    event Staked(
        address indexed user,
        uint256 amount,
        uint256 startTime,
        uint256 endTime
    );

    event Withdrawn(address indexed user, uint256 amount, uint256 rewards);

    constructor(address _token) {
        owner = msg.sender;
        token = _token;
    }

    // Function to stake ERC20 tokens
    function stakeTokens(uint256 _amount, uint256 _duration) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        // Calculate end time
        uint256 endTime = block.timestamp + _duration;

        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        stakingInfo[msg.sender] = StakingInfo(
            _amount,
            block.timestamp,
            endTime,
            0
        );

        emit Staked(msg.sender, _amount, block.timestamp, endTime);
    }

    function calculateRewards(address _user) public view returns (uint256) {
        StakingInfo storage info = stakingInfo[_user];
        uint256 duration = info.endTime - info.startTime;
        uint256 rewards = (info.amount * duration) / 100; // Reward rate: 1% per second
        return rewards;
    }

    function withdraw() public {
        StakingInfo storage info = stakingInfo[msg.sender];
        require(
            block.timestamp >= info.endTime,
            "Staking period has not ended"
        );

        uint256 rewards = calculateRewards(msg.sender);

        info.rewards = rewards;

        IERC20(token).transfer(msg.sender, info.amount + rewards);

        emit Withdrawn(msg.sender, info.amount, rewards);
    }
}
