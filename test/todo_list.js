const TodoList = artifacts.require("TodoList");
const Token = artifacts.require("TodoToken");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TodoList", async function ([primary]) {
    it("Deployed successfully", async function () {
        const todoList = await TodoList.deployed();
        const token = await Token.deployed();
        const balance = await token.balanceOf(todoList.address);
        assert.equal(
            balance,
            "1000000000000000000000000",
            "Balance does not match"
        );
    });

    it("User connected successfully", async function () {
        const todoList = await TodoList.deployed();
        const token = await Token.deployed();
        const status = await todoList.connectUser();
        const balance = await token.balanceOf(primary);
        assert.strictEqual(
            balance.toString(),
            "100",
            "Transferred Amount is not correct"
        );
    });

    it("Task added successfully", async function () {
        const todoList = await TodoList.deployed();
        const todo = await TodoList.deployed();
        const token = await Token.deployed();

        await token.approve(todo.address, 10);
        var date = new Date("06/22/2024 14:12:00");

        await todoList.addTask("This is my first Task", date.getTime() / 1000);
        const taskLength = await todoList.getTaskLength();
        assert.strictEqual(
            taskLength.toString(),
            "1",
            "Task length should be one but do not match"
        );
    });
    it("Task persists", async function () {
        const todo = await TodoList.deployed();
        const taskLength = await todo.getTaskLength();
        assert.strictEqual(
            taskLength.toString(),
            "1",
            "Task length should be one but do not match"
        );
    });

    it("Ten Tokens transferred to user", async function () {
        const todo = await TodoList.deployed();
        const token = await Token.deployed();
        const taskLength = await todo.getTaskLength();
        assert.strictEqual(
            taskLength.toString(),
            "1",
            "Task length should be one but do not match"
        );

        const balance = await token.balanceOf(primary);
        assert.strictEqual(
            balance.toString(),
            "90",
            "Transferred Amount is not correct"
        );
    });

    it("Reward calculated", async function () {
        const todo = await TodoList.deployed();
        function timeout(ms) {
            return new Promise((resolve) => setTimeout(resolve, ms));
        }

        console.log("10 second timer started");
        await timeout(20000);
        console.log("timeout ended");
        const test = await todo.markComplete.call(0);
        console.log(test.toString());

        //const task = await todo.getTask(0);
        //const startTime = task[3];
        //const endTime = task[4];
        //console.log(
        //    startTime,
        //    endTime,
        //    startTime - endTime,
        //    endTime - startTime
        //);

        //const reward = await todo.markComplete.call(0) // a transaction will not return a value but only a transaction hash
        //console.log(await reward.toString())
        // assert.strictEqual(1, 1, 'test')
    }); // it('Failed to remove task', async function() {
    //   const todo = await TodoList.deployed()
    //   const taskLength = await todo.getTaskLength()
    //   console.log(taskLength.toString())
    //   await todo.addTask('This is my first Task');
    //   await todo.addTask('This is my first Task');
    //   // await todo.removeTask(0);
    //   assert.strictEqual(taskLength.toString(), '0', "Task length should be zero but do not match");

    // })
    // it('Task added succesfully', async function() {
    //   const todoList = await TodoList.deployed();
    //   await todoList.addTask('This is first Task');
    //   const taskCount = await todoList.taskCount();
    //   assert.strictEqual(taskCount.toString(), '1', `Task Count is ${taskCount.toString()} instead of '1'`);
    // })
    // it("Ten Tokens transferred to the task creator", async function() {
    //   const token = await Token.deployed()
    //   const balance = await token.balanceOf(primary)
    //   assert.strictEqual(balance.toString(), '100', "Transferred Amount is not correct")
    // })
});
