const std = @import("std"); 
const builtin = @import("builtin");
const allocator = std.heap.page_allocator;

pub fn write_message(comptime msg: []const u8, args: anytype) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;

    try stdout.print(msg, args);
    try stdout.flush();
}

pub fn nsToMsCeil(ns: u64) u64 {
    return (ns + 1_000_000 - 1) / 1_000_000;
}

pub fn formatToString(comptime input: u64) ![]u8 {
    var buffer: [64]u8 = undefined;
    const m_input: u64 = @as(u64, input);
                       // buf: []u8, comptime fmt: []const u8, args: anytype
    const slice = std.fmt.bufPrint(&buffer, m_input, .{});
    const result = try allocator.dupe(u8, slice);

    return result;
}

pub fn printMessage(message: []const u8) !void {
    std.debug.print("{s}\n", .{message});
}

pub fn formatByteArrayToUsize(array: []const u8) !usize {
    var result: usize = 0;
    for (array) |byte| {
        if (byte >= '0' and byte <= '9') {
            result *= 10;
            result += @as(usize, byte - '0');         
        } else {
            std.debug.print("Ongeldige invoer: '{s}'\n", .{array});
            return error.InvalidInput;
        }
    }
    return result;
}

fn formatWithSeparators(buffer: []u8, number: i64) ![]const u8 {
    var writer = std.mem.Writer(buffer[0..]);
    const abs_num = if (number < 0) -number else number;

    var count = 0;
    var temp_num = abs_num;
    while (temp_num != 0 or count == 0) {
        if (count > 0 and count % 3 == 0) {
            try writer.writeByte('_');
        }
        const digit = temp_num % 10;
        try writer.writeByte(@intCast(digit));
        temp_num /= 10;
        count += 1;
    }

    if (number < 0) {
        try writer.writeByte('-');
    }

    const reversed = writer.toSlice();
    return std.mem.reverse(reversed);
}
