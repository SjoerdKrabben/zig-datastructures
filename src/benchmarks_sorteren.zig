const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var starttime: i64 = undefined;
var selection: u8 = 0;

pub fn sortLijstWillekeurigBenchmark(sort: fn ([]u16, usize, usize) void, data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Sorting lijst_willekeurig_10000");

    for (0..repeat) |i| {
        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        const sortedList = data.lijst_oplopend_10000;
        sort(data.lijst_willekeurig_10000, 0, data.lijst_willekeurig_10000.len - 1);

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(sortedList.len == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try std.io.getStdOut().writer().print("Average time passed: {}ns.\n", .{average_time});

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.mem.concat(allocator, u8, &.{ " lijst_willekeurig_10000: \t", try util.formatToString(average_time), "ns  = ", try util.formatToString(average_ms), "ms \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn sort100000Random(sort: fn ([]u32, usize, usize) void, repeat: usize) ![]const u8 {
    var total_elapsed: u64 = 0;
    var list: [100000]u32 = undefined;

    try util.printMessage("Benchmark 2: Sorting 100000 Random Numbers");

    for (0..repeat) |i| {
        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }
        for (0..list.len - 1) |j| {
            const rand = std.crypto.random;
            const number = rand.intRangeAtMost(u32, 0, list.len);

            list[j] = number;
        }

        var timer = try Timer.start();

        sort(&list, 0, list.len - 1);

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try std.io.getStdOut().writer().print("Average time passed: {}ns.\n", .{average_time});

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.mem.concat(allocator, u8, &.{ " 100000 Random numbers: \t", try util.formatToString(average_time), "ns  = ", try util.formatToString(average_ms), "ms \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});
    return result;
}
