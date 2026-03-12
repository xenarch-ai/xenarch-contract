// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract XenarchSplitter {
    using SafeERC20 for IERC20;
    address public owner;
    address public treasury;
    IERC20 public immutable usdc;
    bool public paused;

    uint256 public constant MAX_FEE_BPS = 99; // 0.99%, IMMUTABLE
    uint256 public feeBps = 0; // starts at 0%

    event Split(address indexed payer, address indexed collector, uint256 amount, uint256 fee);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _usdc, address _treasury) {
        owner = msg.sender;
        treasury = _treasury;
        usdc = IERC20(_usdc);
    }

    function split(address collector, uint256 amount) external {
        require(!paused, "Paused");
        require(amount > 0 && amount <= 1_000_000, "Invalid amount"); // max $1 (6 decimals)

        uint256 fee = (amount * feeBps) / 10_000;
        uint256 net = amount - fee;

        usdc.safeTransferFrom(msg.sender, collector, net);
        if (fee > 0) {
            usdc.safeTransferFrom(msg.sender, treasury, fee);
        }

        emit Split(msg.sender, collector, amount, fee);
    }

    function setFee(uint256 _newFeeBps) external onlyOwner {
        require(_newFeeBps <= MAX_FEE_BPS, "Exceeds max fee");
        feeBps = _newFeeBps;
    }

    function setTreasury(address _newTreasury) external onlyOwner {
        treasury = _newTreasury;
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
    }
}
