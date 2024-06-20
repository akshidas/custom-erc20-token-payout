// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../interfaces/IERC20.sol";
import "../interfaces/ITodoList.sol";

contract TodoList is ITodoList {
    address private owner;
    uint public taskCount = 0;
    uint[] private availableTaskIds;
    mapping(uint => Task) public tasks;
    mapping(address => Task[]) private users;

    IERC20 private token;
    uint private constant AMOUNT_FOR_NEW_USER = 100;
    uint private constant AMOUNT_FOR_NEW_TASK = 10;

    struct Task {
        uint id;
        string content;
        bool completed;
        uint256 startTime;
        uint256 endTime;
    }

    event TaskAdded(string message);
    event Toggling(uint id, string content, bool completed);
    event Toggled(uint id, string content, bool completed);
    event Removed(uint id, string message);
    event TokenTransferred(uint amount, string message, address user);
    event UserAdded(address userAddress, string message);

    constructor() {
        owner = msg.sender;
    }

    function setToken(address _token) public {
        require(
            msg.sender == owner,
            "Get lost, I have nothing to do with you!!!"
        );
        token = IERC20(_token);
    }

    function getCurrentTokenHolding() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function connectUser() public returns (bool) {
        users[msg.sender];
        emit UserAdded(msg.sender, "User Added");
        token.transfer(msg.sender, AMOUNT_FOR_NEW_USER);
        emit TokenTransferred(AMOUNT_FOR_NEW_USER, "TT transfered", msg.sender);
        return true;
    }

    function getTaskLength() public view returns (uint) {
        return users[msg.sender].length;
    }

    function addTask(string memory _content, uint256 endTime) public {
        bool status = token.transferFrom(
            msg.sender,
            address(this),
            AMOUNT_FOR_NEW_TASK
        );
        require(status == true, "Failed to deposit Tokens");

        uint myTasks = getTaskLength();
        Task memory task = Task(
            myTasks + 1,
            _content,
            false,
            block.timestamp,
            endTime
        );
        users[msg.sender].push(task);
        emit TaskAdded("A New Task has been added");
    }

    function getTask(uint index) public view returns (Task memory) {
        Task[] memory myTasks = users[msg.sender];
        uint _taskCount = getTaskLength();
        require(
            index < _taskCount,
            "Task with the specified index does not exist"
        );
        return myTasks[index];
    }
    /*
    function
    removeTask(uint index) public {
    	Task[] storage _tasks = users[msg.sender];
     	require(index < _tasks.length, "Index Overshot");

      	for(uint i = index; i < _tasks.length; i++) {
     		_tasks[i] = _tasks[i+1];
       	}
        /*_tasks.pop();*/

    /*if (taskExists(_id)) {
            delete tasks[_id];
            for (uint i = 0; i < availableTaskIds.length; i++) {
                if (availableTaskIds[i] == _id) {
                    availableTaskIds[i] = 0;
                    break;
                }
            }
            emit Removed(_id, "Task removed");
        }
        */
    function getPercentageOfTimeElapsed(
        uint256 startTime,
        uint256 endTime
    ) private view returns (uint256) {
        uint256 currentTime = block.timestamp;
        uint256 totalTime = endTime - startTime;
        uint256 elapsedTimeFromStartTime = currentTime - startTime;
        uint256 percentageOfTimeElapsed = (elapsedTimeFromStartTime /
            totalTime) * 100;
        //return startTime - endTime;
        return elapsedTimeFromStartTime;
    }

    function markComplete(uint index) public returns (uint256) {
        require(index < getTaskLength(), "Index Overshot");
        Task memory task = getTask(index);
        //return task.endTime;
        return getPercentageOfTimeElapsed(task.startTime, task.endTime);
        /*
	    emit Toggling(task.id, task.content, task.completed);
	    task.completed = !task.completed;
	    emit Toggled(task.id, task.content, task.completed);*/
    }

    function taskExists(uint _id) private view returns (bool) {
        Task memory task = tasks[_id];
        require(_id > 0 && task.id == _id, "Task Does not exist");

        return true;
    }

    function getTaskCount() private view returns (uint) {
        uint _taskCount = 0;
        for (uint i = 0; i < availableTaskIds.length; i++) {
            if (availableTaskIds[i] > 0) {
                _taskCount++;
            }
        }

        return _taskCount;
    }

    function getTaskIds() public view returns (uint[] memory) {
        uint[] memory ids = new uint[](getTaskCount());
        uint index = 0;
        for (uint i = 0; i < availableTaskIds.length; i++) {
            if (availableTaskIds[i] > 0) {
                ids[index] = availableTaskIds[i];
                index++;
            }
        }
        return ids;
    }
}
