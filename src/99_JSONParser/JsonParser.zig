const std = @import("std");

pub fn loadStrFromFile() !void {
    var buffer: [1024]u8 = undefined;
    const file = try std.fs.cwd().readFile("assets/dataset_sorteren.json", &buffer);

    _ = file;
    for (buffer) |item| {
        std.debug.print("Item: {}\n", .{item});
    }
    std.debug.print("Size of buffer: {} \n", .{buffer.len});
}

pub fn loadJsonArray(json_array: []const u8, allocator: *std.mem.Allocator) !void {
    const parsedStr = try std.json.parseFromSlice([]u8, allocator, json_array, .{});

    for (parsedStr.value) |value| {
        std.debug.print("{}\n", .{value});
    }
}
