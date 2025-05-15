
// SPDX-License-Identifier: MIT
// pragma solidity 0.8.11;
pragma solidity ^0.8.13;


// import "bsc-library/contracts/IBEP20.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



pragma solidity ^0.8.13;

import {TaccStaking, Ownable} from "./Staking.sol";

contract Factory is Ownable  {

    event NewStakeContract(address indexed stakeAddress);
    error  CallertNotOwner();

      address[] public deployedPools;

    constructor()  {  
          

    }

    function deployPool(
         address _stakedToken,
        address _rewardToken,
        address _feeCollector,
        uint256 _lockDuration,
        uint256 _apy,
        uint256 _exitPenaltyPerc

    ) external onlyOwner  {
        require(IBEP20(_stakedToken).totalSupply() >= 0);
        require(IBEP20(_rewardToken).totalSupply() >= 0);
        // bytes memory bytecode = type(TaccStaking).creationCode;
         bytes memory bytecode = abi.encodePacked(
            type(TaccStaking).creationCode,
            abi.encode(_stakedToken, _rewardToken, _feeCollector,_lockDuration, _apy, _exitPenaltyPerc)
        );
        bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _rewardToken, _feeCollector, _lockDuration, _apy,
        _exitPenaltyPerc ));

         address payable stakeAddress;
   
        assembly {
            stakeAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
          
          TaccStaking(stakeAddress).transferOwnership(owner());
        //   TaccStaking(stakeAddress).startReward();
          deployedPools.push(stakeAddress);


         emit  NewStakeContract(stakeAddress);
    }
   
        function getAllDeployedPools() external view returns (address[] memory) {
        return deployedPools;
    }

    // Optional: Get pool count
    function getDeployedPoolCount() external view returns (uint256) {
        return deployedPools.length;
    }

    // Deployed Stake Contract: 0xD2f8c01aAe9d1bF355619A35AAc8b9492482D83D
    //1st USer Current Balance: 57,185.47646 DCC  after withdraw= 58,185.53811 DCC
    //2nd User Current Balance: 178,862.3642 DCC after withdraw = 179,362.39432 DCC
    // 2nd User Current Balance: 
     // 1st User Deposited 1000 DCC
     // 2nd User Deposit 500DCC

     //unlockTime = 1,747,233,000
     //current time = 1,747,233,328
}
