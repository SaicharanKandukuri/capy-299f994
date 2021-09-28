const std = @import("std");
const zgt = @import("zgt");

var opacity = zgt.DataWrapper(f64).of(0);

fn startAnimation(button: *zgt.Button_Impl) !void {
    // Ensure the current animation is done before starting another
    if (!opacity.hasAnimation()) {
        if (opacity.get() == 0) { // if hidden
            // Show the label in 1000ms
            opacity.animate(zgt.Easings.In, 1, 1000);
            button.setLabel("Hide");
        } else {
            // Hide the label in 1000ms
            opacity.animate(zgt.Easings.Out, 0, 1000);
            button.setLabel("Show");
        }
    }
}

pub fn main() !void {
    try zgt.backend.init();

    var window = try zgt.Window.init();
    
    try window.set(
        zgt.Column(.{ .expand = .Fill }, .{
            zgt.Row(.{}, .{
                zgt.Expanded(
                    zgt.Label(.{ .text = "Hello Zig" })
                        .bindOpacity(&opacity)
                ),
                zgt.Button(.{ .label = "Show", .onclick = startAnimation })
            })
        })
    );

    window.resize(250, 100);
    window.show();

    while (zgt.stepEventLoop(.Asynchronous)) {
        _ = opacity.update();
        std.time.sleep(16);
    }
}