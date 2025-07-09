// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IyabokoOracle {
    uint256 public latestFieldValue;
    address public deviceManager;

    modifier onlyDevice() {
        require(msg.sender == deviceManager, "Unauthorized device");
        _;
    }

    constructor(address _manager) {
        deviceManager = _manager;
    }

    function updateFieldValue(uint256 newValue) external onlyDevice {
        latestFieldValue = newValue;
    }

    function getFieldReading() external view returns (uint256) {
        return latestFieldValue;
    }
}
