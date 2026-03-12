// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/XenarchSplitter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    constructor() ERC20("USD Coin", "USDC") {}

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract XenarchSplitterTest is Test {
    event Split(address indexed payer, address indexed collector, uint256 amount, uint256 fee);

    XenarchSplitter public splitter;
    MockUSDC public usdc;

    address owner = address(this);
    address treasury = makeAddr("treasury");
    address collector = makeAddr("collector");
    address payer = makeAddr("payer");
    address nobody = makeAddr("nobody");

    function setUp() public {
        usdc = new MockUSDC();
        splitter = new XenarchSplitter(address(usdc), treasury);

        // Fund payer with 10 USDC
        usdc.mint(payer, 10_000_000);

        // Payer approves splitter
        vm.prank(payer);
        usdc.approve(address(splitter), type(uint256).max);
    }

    // --- Split with fee = 0 (all to collector) ---

    function test_split_zeroFee() public {
        uint256 amount = 3000; // $0.003

        vm.prank(payer);
        splitter.split(collector, amount);

        assertEq(usdc.balanceOf(collector), amount);
        assertEq(usdc.balanceOf(treasury), 0);
    }

    // --- Split with fee = 50 bps (0.5%) ---

    function test_split_fiftyBps() public {
        splitter.setFee(50);

        uint256 amount = 1_000_000; // $1.00
        uint256 expectedFee = (amount * 50) / 10_000; // 5000
        uint256 expectedNet = amount - expectedFee; // 995000

        vm.prank(payer);
        splitter.split(collector, amount);

        assertEq(usdc.balanceOf(collector), expectedNet);
        assertEq(usdc.balanceOf(treasury), expectedFee);
    }

    // --- Split with fee = 99 bps (0.99% max) ---

    function test_split_maxFee() public {
        splitter.setFee(99);

        uint256 amount = 1_000_000;
        uint256 expectedFee = (amount * 99) / 10_000; // 9900
        uint256 expectedNet = amount - expectedFee; // 990100

        vm.prank(payer);
        splitter.split(collector, amount);

        assertEq(usdc.balanceOf(collector), expectedNet);
        assertEq(usdc.balanceOf(treasury), expectedFee);
    }

    // --- Fee cap enforcement ---

    function test_setFee_maxSucceeds() public {
        splitter.setFee(99);
        assertEq(splitter.feeBps(), 99);
    }

    function test_setFee_exceedsMaxReverts() public {
        vm.expectRevert("Exceeds max fee");
        splitter.setFee(100);
    }

    // --- Access control ---

    function test_setFee_nonOwnerReverts() public {
        vm.prank(nobody);
        vm.expectRevert("Not owner");
        splitter.setFee(50);
    }

    function test_setTreasury_nonOwnerReverts() public {
        vm.prank(nobody);
        vm.expectRevert("Not owner");
        splitter.setTreasury(nobody);
    }

    function test_setPaused_nonOwnerReverts() public {
        vm.prank(nobody);
        vm.expectRevert("Not owner");
        splitter.setPaused(true);
    }

    // --- Edge cases ---

    function test_split_zeroAmountReverts() public {
        vm.prank(payer);
        vm.expectRevert("Invalid amount");
        splitter.split(collector, 0);
    }

    function test_split_maxAmount() public {
        vm.prank(payer);
        splitter.split(collector, 1_000_000); // $1 exactly
        assertEq(usdc.balanceOf(collector), 1_000_000);
    }

    function test_split_exceedsMaxAmountReverts() public {
        vm.prank(payer);
        vm.expectRevert("Invalid amount");
        splitter.split(collector, 1_000_001);
    }

    // --- Pause ---

    function test_split_whenPausedReverts() public {
        splitter.setPaused(true);

        vm.prank(payer);
        vm.expectRevert("Paused");
        splitter.split(collector, 1000);
    }

    function test_split_afterUnpause() public {
        splitter.setPaused(true);
        splitter.setPaused(false);

        vm.prank(payer);
        splitter.split(collector, 1000);
        assertEq(usdc.balanceOf(collector), 1000);
    }

    // --- Events ---

    function test_split_emitsEvent() public {
        splitter.setFee(50);
        uint256 amount = 100_000;
        uint256 expectedFee = (amount * 50) / 10_000;

        vm.prank(payer);
        vm.expectEmit(true, true, false, true);
        emit Split(payer, collector, amount, expectedFee);
        splitter.split(collector, amount);
    }

    // --- Treasury ---

    function test_setTreasury() public {
        address newTreasury = makeAddr("newTreasury");
        splitter.setTreasury(newTreasury);
        assertEq(splitter.treasury(), newTreasury);
    }

    // --- Constructor ---

    function test_constructor() public view {
        assertEq(splitter.owner(), owner);
        assertEq(splitter.treasury(), treasury);
        assertEq(address(splitter.usdc()), address(usdc));
        assertEq(splitter.feeBps(), 0);
        assertEq(splitter.paused(), false);
    }

    // --- Fuzz ---

    function testFuzz_split_validAmounts(uint256 amount) public {
        amount = bound(amount, 1, 1_000_000);

        vm.prank(payer);
        splitter.split(collector, amount);

        assertEq(usdc.balanceOf(collector), amount);
    }

    function testFuzz_split_withFee(uint256 amount, uint256 fee) public {
        amount = bound(amount, 1, 1_000_000);
        fee = bound(fee, 0, 99);

        splitter.setFee(fee);

        uint256 expectedFee = (amount * fee) / 10_000;
        uint256 expectedNet = amount - expectedFee;

        vm.prank(payer);
        splitter.split(collector, amount);

        assertEq(usdc.balanceOf(collector), expectedNet);
        assertEq(usdc.balanceOf(treasury), expectedFee);
    }
}
