const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn nsToMsCeil(ns: u64) u64 {
    return (ns + 1_000_000 - 1) / 1_000_000;
}

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

pub fn formatByteArrayToUsize(array: []const u8) !usize {
    var result: usize = 0;
    for (array) |byte| {
        // Controleer of de byte een cijfer is
        if (byte >= '0' and byte <= '9') {
            // Zet de byte om naar een cijfer en werk de resultaatwaarde bij
            result *= 10;
            result += @as(usize, byte - '0'); // Converteer het cijfer naar een getal
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
