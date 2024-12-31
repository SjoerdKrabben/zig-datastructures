const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn formatToString(input: u64) ![]u8 {
    var buffer: [64]u8 = undefined;

    const slice = std.fmt.bufPrintIntToSlice(&buffer, @as(u64, input), 10, .lower, .{});
    const result = try allocator.dupe(u8, slice);

    return result;
}

pub fn printMessage(message: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("{s}\n", .{message});
}
