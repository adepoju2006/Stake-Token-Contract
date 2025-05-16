pragma solidity ^0.8.13;
import {Script} from "forge-std/Script.sol";
// import {TaccToken} from "../src/Token.sol";
import { Factory } from "../src/FactoryStaking.sol";
import {Test,console} from "forge-std/Test.sol";
import {TaccStaking} from "../src/Staking.sol";
import { MockV3Aggregator} from "lib/chainlink/contracts/src/v0.8/shared/mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {PriceConverter} from "../src/PriceConverter.sol";
contract StakeTest is Test, Script {
    Factory factory;
    TaccStaking staking;
     MockV3Aggregator priceFeed;
     ERC20Mock public token;
    //  PriceConverter priceConverter;
    address User1 = makeAddr("User1");
    address User2 = makeAddr("User2");
    address OwnerAddress = makeAddr("Owner");

    function setUp() public {
        factory = new Factory();
        token = new ERC20Mock();
        // priceFeed = new MockV3Aggregator(
        //     18,
        //     653
        //  );
        //   priceConverter = new PriceConverter(address(priceFeed))
        staking = new TaccStaking(
            address(token),
            address(token),
            //  0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526,
            OwnerAddress,
            60,
            100,
            10
        );

        vm.startPrank(msg.sender);
        token.mint(User1, 10000 ether);
         token.mint(User2, 10000 ether);
         token.mint(address(staking), 100000 ether);
         vm.stopPrank();

        //  vm.startPrank(User1);
        //    token.approve(address(staking), type(uint256).max);
        //  vm.stopPrank();

        //   vm.startPrank(User2);
        //    token.approve(address(staking), type(uint256).max);
        //  vm.stopPrank();

         vm.deal(User1, 1 ether);
        //  hoax(User2, 1 ether);
    }


    modifier onlyStartReward() {

        vm.prank(staking.owner());
        staking.startReward();
        _;
    }


  function testPriceOfBNB() external {
    uint256 priceOfBNB = staking.getPriceofBNB();
    console.log("Price of BNB:", priceOfBNB );
}
    function testDeposit() external onlyStartReward {
    uint256 UserStartTokenBalance = token.balanceOf(User1);
    uint256 UserStartEtherBalance = address(User1).balance;

    console.log("Start Token Balance:", UserStartTokenBalance);
    console.log("Start ETH Balance:", UserStartEtherBalance);

    // Prank as User1 and give them enough ETH
    vm.deal(User1, 1 ether);
    vm.startPrank(User1);

    // Approve staking contract to spend User1's tokens
    token.approve(address(staking), type(uint256).max);

    // Get price of BNB in USD (wei/USD)
    uint256 price = staking.getPriceofBNB(); // e.g., 651573585340000000000

    // Calculate $0.50 worth of BNB in wei
    uint256 fee = (0.5e18 * 1e18) / price; // = $0.50 * 1e18 / price

    // Optional: add a buffer to prevent rounding issues
    fee += 1e12;

    console.log("Calculated fee in wei:", fee);
    console.log("BNB/USD price:", price);

    // Deposit with correct fee
    staking.deposit{value: fee}(1000 ether);

    vm.stopPrank();

    uint256 UserEndTokenBalance = token.balanceOf(User1);
    uint256 UserEndEtherBalance = address(User1).balance;

    console.log("End Token Balance:", UserEndTokenBalance);
    console.log("End ETH Balance:", UserEndEtherBalance);
}

function testWithdraw() external onlyStartReward {
    // Fund User1 with ETH and Tokens
    deal(address(token), User1, 1000 ether);
    deal(User1, 1 ether);

    // Prank as User1
    vm.startPrank(User1);

    // Approve and deposit first
    token.approve(address(staking), type(uint256).max);
    staking.deposit{value: staking.getAmountOfFeeInBNB()}(1000 ether);

    // Simulate time passing to allow withdrawal
    skip(staking.lockDuration() + 1);

    uint256 startTokenBalance = token.balanceOf(User1);
    uint256 startETHBalance = User1.balance;

    console.log("Start Token Balance:", startTokenBalance);
    console.log("Start ETH Balance:", startETHBalance);

    // Withdraw (will return both staked + rewards)
    staking.withdraw{value: staking.getAmountOfFeeInBNB()}(0); // amount ignored inside function

    uint256 endTokenBalance = token.balanceOf(User1);
    uint256 endETHBalance = User1.balance;

    console.log("End Token Balance:", endTokenBalance);
    console.log("End ETH Balance:", endETHBalance);

    assertGt(endTokenBalance, startTokenBalance, "Token balance should increase after withdrawal");
    assertLt(endETHBalance, startETHBalance, "ETH balance should decrease due to fee payment");

    vm.stopPrank();
}

function testEmergencyWithdraw() external {
    // Start impersonating User1
    vm.startPrank(User1);

    uint256 depositAmount = 1000 ether;
    token.approve(address(staking), type(uint256).max);
    staking.deposit{value: staking.getAmountOfFeeInBNB()}(depositAmount);

    (uint256 stakedBalanceBefore, ) = staking.userInfo(User1);
    uint256 userTokenBalanceBefore = token.balanceOf(User1);

    // emergencyWithdraw called inside the same prank session, no new startPrank needed
    staking.emergencyWithdraw();

    (uint256 stakedBalanceAfter, ) = staking.userInfo(User1);
    uint256 userTokenBalanceAfter = token.balanceOf(User1);

    assertEq(stakedBalanceAfter, 0, "User staking amount should be zero after emergencyWithdraw");
    assertGt(userTokenBalanceAfter, userTokenBalanceBefore, "User token balance should increase after emergencyWithdraw");

    uint256 unlockTime = staking.holderUnlockTime(User1);
    assertEq(unlockTime, 0, "Unlock time should be reset to zero");

    vm.stopPrank();
}
}
