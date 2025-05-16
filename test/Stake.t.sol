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
     PriceConverter priceConverter;
    address User1 = makeAddr("User1");
    address User2 = makeAddr("User2");
    address OwnerAddress = makeAddr("Owner");

    function setUp() public {
        factory = new Factory();
        token = new ERC20Mock();
        priceFeed = new MockV3Aggregator(
            18,
            653
         );
          priceConverter = new PriceConverter(address(priceFeed))
        staking = new TaccStaking(
            address(token),
            address(token),
            address(priceFeed),
            OwnerAddress,
            60,
            100,
            10
        );

        vm.startPrank(msg.sender);
        token.mint(User1, 100001e18);
         token.mint(User2, 100001e18);
         token.mint(address(staking), 1000001e18);
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

    function testDeposit() external {

        uint256 UserStartTokenBalance = token.balanceOf(User1);
        uint256 UserStartETherBalance = address(User1).balance;
        console.log("Start Token Balance:", UserStartTokenBalance );
        console.log("Start ETH Balance:", UserStartETherBalance );

        vm.prank(User1);
        // hoax(User1, 1 ether);
        token.approve(address(staking), type(uint256).max);
        staking.deposit{value: 0.000765 ether}(10001e18);
        // vm.stopPrank();

        uint256 UserEndTokenBalance = token.balanceOf(User1);
        uint256 UserEndETherBalance = address(User1).balance;
        console.log("Start Token Balance:", UserEndTokenBalance);
        console.log("Start ETH Balance:", UserEndETherBalance);
    }

}
