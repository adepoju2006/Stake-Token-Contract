pragma solidity ^0.8.11;
import {Script} from "forge-std/Script.sol";
// import {TaccToken} from "../src/Token.sol";
import { Factory } from "../src/FactoryStaking.sol";

contract DeployToken is Script {
    // TaccToken taccToken;
    Factory factory;
    // address TellerToken =0xF8A37509C8a1ee397e8585A4C84B02358a2240A8;
    // address feeCollector =0x669c876e0C1Caa8c562E2C9545F203cF4819C923
    // address bnbUsdPriceFeed =0xbC792147B026F2B998A97d6BC9718569Df79ec65
    // uint256 Duration = block
    // function run() public returns(TaccToken) {
 function run() public returns(Factory) {
        
        vm.startBroadcast();
        // taccToken = new TaccToken();
        factory = new Factory();

        vm.stopBroadcast();

        // return taccToken;
          return factory;

    }

}