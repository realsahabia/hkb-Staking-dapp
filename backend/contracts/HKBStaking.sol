// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./HKBToken.sol";

contract HKBStaking is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint256 amount;
        uint256 pendingReward;
    }

    struct PoolInfo {
        IERC20 lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 rewardTokenPerShare;
    }

    HKBToken public hkb;
    address public dev;
    uint256 public hkbPerBlock;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    PoolInfo[] public poolInfo;
    uint256 public totalAllocation = 0;
    uint256 public startBlock;
    uint256 public BONUS_MULTIPLIER;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event RewardPaid(address indexed user, uint256 amount);

    constructor (
        HKBToken _hkb,
        address _dev,
        uint256 _hkbPerBlock,
        uint256 _startBlock,
        uint256 _multiplier
    ) Ownable(_msgSender()) {
        hkb = _hkb;
        dev = _dev;
        hkbPerBlock = _hkbPerBlock;
        startBlock = _startBlock;
        BONUS_MULTIPLIER = _multiplier;

        // Initialize the pool with HKBToken itself
        poolInfo.push(PoolInfo({
            lpToken: _hkb,
            allocPoint: 10000,
            lastRewardBlock: _startBlock,
            rewardTokenPerShare: 0
        }));

        totalAllocation = 10000;
    }  

}
