//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const dl = @import("1_DynamicList/DynamicList.zig");

pub fn main() !void {
    const print = std.debug.print;
    const allocator = std.heap.page_allocator;

    var list = try dl.DynamicList(i32).init(allocator);

    for (0..10) |i| {
        const value = 10 * @as(i32, @intCast(i));
        try list.add(value);

        print("The size of this list is: {} and position {} and value: {} \n", .{ list.size(), i, list.get(i) });
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const global = struct {
        fn testOne(input: []const u8) anyerror!void {
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(global.testOne, .{});
}
