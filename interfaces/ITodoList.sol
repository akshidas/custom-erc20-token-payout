// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


interface ITodoList {
	function getCurrentTokenHolding() external view returns(uint256);
	function addTask(string memory, uint256) external;
	/*function removeTask(uint) external;*/
	function markComplete(uint) external returns(uint256);
	function getTaskIds() external view returns(uint[] memory);
	function setToken(address) external;
}
