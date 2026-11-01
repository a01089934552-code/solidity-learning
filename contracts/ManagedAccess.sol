// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

abstract contract ManagedAccess {
    address public owner;
    address public manager;

    // ===== Multi Manager =====
    address[] public managers;
    mapping(address => bool) public isManager;
    mapping(address => bool) public confirmed;

    constructor(address _owner, address _manager) {
        owner = _owner;
        manager = _manager;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    modifier onlyManager() {
        require(
            msg.sender == manager,
            "You are not authorized to manage this contract"
        );
        _;
    }

    // ===== Multi Manager =====
    function _setManagers(address[] memory _managers) internal {
        require(_managers.length >= 3, "At least 3 managers required");
        for (uint256 i = 0; i < _managers.length; i++) {
            managers.push(_managers[i]);
            isManager[_managers[i]] = true;
        }
    }

    function confirm() external {
        require(isManager[msg.sender], "You are not a manager");
        confirmed[msg.sender] = true;
    }

    modifier onlyAllConfirmed() {
        require(isManager[msg.sender], "You are not a manager");
        for (uint256 i = 0; i < managers.length; i++) {
            require(confirmed[managers[i]], "Not all confirmed yet");
        }
        for (uint256 i = 0; i < managers.length; i++) {
            confirmed[managers[i]] = false;
        }
        _;
    }
}
