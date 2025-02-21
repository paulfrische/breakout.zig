const std = @import("std");

const rl = @import("raylib");

const windowWidth = 1280;
const windowHeight = 720;

const paddleWidth = 192;
const paddleHeight = 32;
const paddlePadding = 64;
const paddleSpeed = 300;

const ballRadius = 16;
const ballSpeed = 350;

const GameState = struct {
    paused: bool,

    playerPosition: f32, // paddle x

    ballPosition: rl.Vector2,
    ballDirection: rl.Vector2,

    fn init() GameState {
        return .{
            .paused = true,
            .playerPosition = (windowWidth - paddleWidth) / 2,
            .ballPosition = rl.Vector2.init(windowWidth / 2, windowHeight / 2),
            .ballDirection = rl.Vector2.zero(),
        };
    }

    fn update(self: *GameState) void {
        const dt = rl.getFrameTime();

        if (self.paused) {
            self.ballPosition.x = @floatCast(windowWidth * 0.7 * std.math.sin(rl.getTime() * 0.5));

            if (rl.isKeyPressed(rl.KeyboardKey.space)) {
                const mousePos = rl.getMousePosition();
                self.ballDirection = rl.Vector2.init(mousePos.x - self.ballPosition.x, mousePos.y - self.ballPosition.y).normalize();
                self.paused = false;
            }

            return;
        }

        if (rl.isKeyDown(rl.KeyboardKey.a)) {
            self.playerPosition -= paddleSpeed * dt;
        }

        if (rl.isKeyDown(rl.KeyboardKey.d)) {
            self.playerPosition += paddleSpeed * dt;
        }

        self.playerPosition = std.math.clamp(self.playerPosition, 0, windowWidth - paddleWidth);

        self.ballPosition.x += self.ballDirection.x * ballSpeed * dt;
        self.ballPosition.y += self.ballDirection.y * ballSpeed * dt;

        if ((self.ballPosition.x < 0) or (self.ballPosition.x >= windowWidth - ballRadius)) {
            self.ballDirection.x *= -1;
        }

        if (self.ballPosition.x >= self.playerPosition and self.ballPosition.x <= self.playerPosition + paddleWidth and self.ballPosition.y + ballRadius >= windowHeight - paddlePadding - paddleHeight and self.ballPosition.y + ballRadius <= windowHeight - paddlePadding) {
            self.ballDirection.y *= -1;
        }

        if (self.ballPosition.y <= ballRadius) {
            self.ballDirection.y *= -1;
        }
    }

    fn draw(self: *GameState) void {
        rl.drawCircleV(self.ballPosition, ballRadius, rl.Color.red);
        rl.drawRectangle(@intFromFloat(self.playerPosition), windowHeight - paddlePadding - paddleHeight, paddleWidth, paddleHeight, rl.Color.green);
    }
};

pub fn main() !void {
    var state = GameState.init();

    rl.initWindow(windowWidth, windowHeight, "BREAKOUT!!!");
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {
        state.update();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);
        state.draw();
    }
}
