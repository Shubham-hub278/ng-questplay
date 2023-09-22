// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UpgradeableMechSuit {
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /// @notice Constructs the contract
    /// @param _implementation Address of logic contract to be linked
    constructor(address _implementation) {
        setImplementation(_implementation);
        setAdmin(msg.sender);
    }

    /// @dev Get implementation address.
    function implementation() internal view returns (address impl) {
        assembly {
            // solium-disable-line
            impl := sload(_IMPLEMENTATION_SLOT)
        }
    }

    /// @dev Get admin address.
    function admin() internal view returns (address _admin) {
        assembly {
            // solium-disable-line
            _admin := sload(ADMIN_SLOT)
        }
    }

    /// @dev Set new implementation address.
    function setImplementation(address codeAddress) internal {
        assembly {
            // solium-disable-line
            sstore(_IMPLEMENTATION_SLOT, codeAddress)
        }
    }

    function setAdmin(address _admin) internal {
        assembly {
            // solium-disable-line
            sstore(ADMIN_SLOT, _admin)
        }
    }

    /// @notice Upgrades contract by updating the linked logic contract
    /// @param _implementation Address of new logic contract to be linked
    function upgradeTo(address _implementation) external {
        require(admin() == msg.sender, "invalid caller");
        setImplementation(_implementation);
    }

    function _delegate(address _implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    fallback() external payable virtual {
        _delegate(implementation());
    }

    receive() external payable virtual {
        _delegate(implementation());

    }
}
