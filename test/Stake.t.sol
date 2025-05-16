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

         hoax(User1, 1 ether);
        //  hoax(User2, 1 ether);
    }


    modifier onlyStartReward() {

        vm.prank(staking.owner());
        staking.startReward();
        _;
    }


    function testPriceOfBNB() external {
        vm.prank(User2);
        uint256 priceOfBNB =  staking.getPriceofBNB();
        // vm.stopPrank();
        // uint256 AmountOfeegetInBNB = staking.getAmountOfFeeInBNB();

        console.log("Price of BNB:", priceOfBNB );
        // console.log("Amount Fee for BNB", AmountOfeegetInBNB );

    }
    function testDeposit() external onlyStartReward{

        uint256 UserStartTokenBalance = token.balanceOf(User1);
        uint256 UserStartETherBalance = address(User1).balance;
        console.log("Start Token Balance:", UserStartTokenBalance );
        console.log("Start ETH Balance:", UserStartETherBalance );

        vm.prank(User1);
        // hoax(User1, 1 ether);
        token.approve(address(staking), type(uint256).max);
        // uint256 price = staking.getPriceofBNB();
        staking.deposit{value: 0.00077 ether}(1000 ether);
        // vm.stopPrank();

        uint256 UserEndTokenBalance = token.balanceOf(User1);
        uint256 UserEndETherBalance = address(User1).balance;
        // console.log("Price of BNB:", price);
        console.log("Start Token Balance:", UserEndTokenBalance);
        console.log("Start ETH Balance:", UserEndETherBalance);
    }

}
