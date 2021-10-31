// SPDX-License-Identifier: MIT


pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract MintCoordinator is Ownable, AccessControl {
    using SafeERC20 for IERC20;
    IERC20 public constant PAD =
        IERC20(0x885f8CF6E45bdd3fdcDc644efdcd0AC93880c781);
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public totalMinted;
    using SafeMath for uint256;

    modifier onlyHasRole(bytes32 _role) {
        require(
            hasRole(_role, _msgSender()),
            "NearPad.onlyHasRole: msg.sender does not have role"
        );
        _;
    }

    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function mint(address _to, uint256 _amount)
        public
        onlyHasRole(MINTER_ROLE)
    {
        PAD.safeTransfer(_to, _amount);
        totalMinted = totalMinted.add(_amount);
    }

    function grantRole(bytes32 role, address account) public virtual override {
        super.grantRole(role, account);
    }

    function rescue(IERC20 _token) public onlyOwner {
        _token.safeTransfer(_msgSender(), _token.balanceOf(address(this)));
    }
}
