// 游戏常量
const GRID_SIZE = 20; // 网格大小
const CELL_SIZE = 20; // 单元格大小
const INITIAL_SPEED = 150; // 初始速度（毫秒）

// 游戏状态
let snake = [];
let food = {};
let direction = "right";
let nextDirection = "right";
let gameSpeed = INITIAL_SPEED;
let score = 0;
let gameInterval;
let isGameOver = false;
let isPaused = false;

// DOM 元素
const canvas = document.getElementById("game-canvas");
const ctx = canvas.getContext("2d");
const scoreElement = document.getElementById("score");
const startButton = document.getElementById("start-btn");
const pauseButton = document.getElementById("pause-btn");
const resetButton = document.getElementById("reset-btn");

// 初始化游戏
function initGame() {
    // 重置游戏状态
    snake = [
        { x: 10, y: 10 },
        { x: 9, y: 10 },
        { x: 8, y: 10 }
    ];
    direction = "right";
    nextDirection = "right";
    score = 0;
    isGameOver = false;
    isPaused = false;
    
    // 更新分数显示
    updateScore();
    
    // 生成初始食物
    generateFood();
    
    // 渲染游戏
    drawGame();
}

// 生成食物
function generateFood() {
    // 确保食物不会生成在蛇身上
    let overlapping;
    do {
        overlapping = false;
        food = {
            x: Math.floor(Math.random() * GRID_SIZE),
            y: Math.floor(Math.random() * GRID_SIZE)
        };
        
        // 检查是否与蛇重叠
        for (let segment of snake) {
            if (segment.x === food.x && segment.y === food.y) {
                overlapping = true;
                break;
            }
        }
    } while (overlapping);
}

// 移动蛇
function moveSnake() {
    // 更新方向
    direction = nextDirection;
    
    // 获取蛇头位置
    const head = { x: snake[0].x, y: snake[0].y };
    
    // 根据方向移动蛇头
    switch (direction) {
        case "up":
            head.y--;
            break;
        case "down":
            head.y++;
            break;
        case "left":
            head.x--;
            break;
        case "right":
            head.x++;
            break;
    }
    
    // 添加新蛇头
    snake.unshift(head);
    
    // 检查是否吃到食物
    if (head.x === food.x && head.y === food.y) {
        // 吃到食物，增加分数
        score++;
        updateScore();
        generateFood();
        
        // 随着分数增加，游戏速度略微提升
        if (score % 5 === 0 && gameSpeed > 50) {
            gameSpeed -= 10;
            restartGameLoop();
        }
    } else {
        // 没有吃到食物，移除尾部
        snake.pop();
    }
}

// 检查碰撞
function checkCollision() {
    const head = snake[0];
    
    // 检查边界碰撞
    if (head.x < 0 || head.x >= GRID_SIZE || head.y < 0 || head.y >= GRID_SIZE) {
        return true;
    }
    
    // 检查自身碰撞
    for (let i = 1; i < snake.length; i++) {
        if (snake[i].x === head.x && snake[i].y === head.y) {
            return true;
        }
    }
    
    return false;
}

// 绘制游戏
function drawGame() {
    // 清空画布
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // 绘制蛇
    snake.forEach((segment, index) => {
        ctx.fillStyle = index === 0 ? "#4CAF50" : "#8BC34A";
        ctx.fillRect(segment.x * CELL_SIZE, segment.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
        
        // 绘制蛇的边框
        ctx.strokeStyle = "#388E3C";
        ctx.strokeRect(segment.x * CELL_SIZE, segment.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    });
    
    // 绘制食物
    ctx.fillStyle = "#F44336";
    ctx.beginPath();
    ctx.arc(
        food.x * CELL_SIZE + CELL_SIZE / 2,
        food.y * CELL_SIZE + CELL_SIZE / 2,
        CELL_SIZE / 2,
        0,
        Math.PI * 2
    );
    ctx.fill();
    
    // 如果游戏结束，显示游戏结束文字
    if (isGameOver) {
        ctx.fillStyle = "rgba(0, 0, 0, 0.5)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        ctx.fillStyle = "white";
        ctx.font = "24px Arial";
        ctx.textAlign = "center";
        ctx.fillText("游戏结束", canvas.width / 2, canvas.height / 2 - 20);
        ctx.font = "18px Arial";
        ctx.fillText(`最终得分: ${score}`, canvas.width / 2, canvas.height / 2 + 20);
    }
    
    // 如果游戏暂停，显示暂停文字
    if (isPaused) {
        ctx.fillStyle = "rgba(0, 0, 0, 0.3)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        ctx.fillStyle = "white";
        ctx.font = "24px Arial";
        ctx.textAlign = "center";
        ctx.fillText("游戏暂停", canvas.width / 2, canvas.height / 2);
    }
}

// 更新分数显示
function updateScore() {
    scoreElement.textContent = score;
}

// 游戏循环
function gameLoop() {
    if (!isPaused && !isGameOver) {
        moveSnake();
        
        if (checkCollision()) {
            isGameOver = true;
            clearInterval(gameInterval);
        }
        
        drawGame();
    }
}

// 重启游戏循环
function restartGameLoop() {
    if (gameInterval) {
        clearInterval(gameInterval);
    }
    gameInterval = setInterval(gameLoop, gameSpeed);
}

// 开始游戏
function startGame() {
    if (!gameInterval && !isGameOver) {
        isPaused = false;
        restartGameLoop();
    }
}

// 暂停游戏
function pauseGame() {
    isPaused = !isPaused;
    drawGame(); // 重绘以显示暂停信息
}

// 重置游戏
function resetGame() {
    // 清除游戏循环
    if (gameInterval) {
        clearInterval(gameInterval);
        gameInterval = null;
    }
    
    // 重新初始化游戏
    initGame();
}

// 处理键盘输入
function handleKeyPress(e) {
    // 防止页面滚动
    if ([37, 38, 39, 40, 87, 65, 83, 68, 32].includes(e.keyCode)) {
        e.preventDefault();
    }
    
    // 根据按键更新方向，但不能直接向相反方向移动
    switch (e.keyCode) {
        case 38: // 上箭头
        case 87: // W键
            if (direction !== "down") {
                nextDirection = "up";
            }
            break;
        case 40: // 下箭头
        case 83: // S键
            if (direction !== "up") {
                nextDirection = "down";
            }
            break;
        case 37: // 左箭头
        case 65: // A键
            if (direction !== "right") {
                nextDirection = "left";
            }
            break;
        case 39: // 右箭头
        case 68: // D键
            if (direction !== "left") {
                nextDirection = "right";
            }
            break;
        case 32: // 空格键
            if (isGameOver) {
                resetGame();
            } else {
                pauseGame();
            }
            break;
    }
}

// 事件监听器
startButton.addEventListener("click", startGame);
pauseButton.addEventListener("click", pauseGame);
resetButton.addEventListener("click", resetGame);
document.addEventListener("keydown", handleKeyPress);

// 初始化游戏
window.addEventListener("load", initGame);