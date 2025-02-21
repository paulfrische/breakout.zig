const std = @import("std");

const rl = @import("raylib");

const windowWidth = 1280;
const windowHeight = 720;

const paddleWidth = 192;
const paddleHeight = 32;
const paddlePadding = 64;
const paddleSpeed = 300;

const GameState = struct {
    playerPosition: f32, // paddle x

    fn init() GameState {
        return .{ .playerPosition = (windowWidth - paddleWidth) / 2 };
    }

    fn update(self: *GameState) void {
        const dt = rl.getFrameTime();

        if (rl.isKeyDown(rl.KeyboardKey.a)) {
            self.playerPosition -= paddleSpeed * dt;
        }

        if (rl.isKeyDown(rl.KeyboardKey.d)) {
            self.playerPosition += paddleSpeed * dt;
        }

        self.playerPosition = std.math.clamp(self.playerPosition, 0, windowWidth - paddleWidth);
    }

    fn draw(self: *GameState) void {
        rl.drawRectangle(@intFromFloat(self.playerPosition), windowHeight - paddlePadding - paddleHeight, paddleWidth, paddleHeight, rl.Color.red);
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
