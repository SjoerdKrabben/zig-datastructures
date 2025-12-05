const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const ht = @import("datastructures/HashTable.zig");
const htsc = @import("datastructures/HashTableSeparateChaining.zig");
const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var starttime: i64 = undefined;

pub fn insert100000RandomEntries(repeat: usize) ![]const u8 {
    const TOTAL_SIZE = 100000;
    var total_elapsed: u64 = 0;
    var total_elapsed2: u64 = 0;
    var hashTableLinearProbing = try ht.HashTable(u32).init(allocator, TOTAL_SIZE);
    var hashTableSeparateChaining = try htsc.HashTableSeparateChaining(u32).init(allocator, TOTAL_SIZE);
    defer hashTableLinearProbing.deinit();
    defer hashTableSeparateChaining.deinit();
    var keys: [TOTAL_SIZE][]u8 = undefined;
    var values: [TOTAL_SIZE]u32 = undefined;

    try util.printMessage("Benchmark 1: Inserting 100000 Random Numbers");

    for (0..TOTAL_SIZE) |j| {
        const key = try std.fmt.allocPrint(allocator, "key_{}", .{j});
        const rand = std.crypto.random;
        const number = rand.intRangeAtMost(u32, 0, TOTAL_SIZE);
        keys[j] = key;
        values[j] = number;
    }

    for (0..repeat) |i| {
        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var elapsed: u64 = 0;
        var elapsed2: u64 = 0;

        for (0..2) |k| {
            var timer = try Timer.start();
            if (k == 0) {
                for (0..keys.len - 1) |l| {
                    try hashTableLinearProbing.insert(keys[l], values[l]);
                }
                elapsed = timer.read();
            } else {
                for (0..keys.len - 1) |m| {
                    try hashTableSeparateChaining.insert(keys[m], values[m]);
                }
                elapsed2 = timer.read();
            }
        }
        if (i > 0) {
            total_elapsed += elapsed;
            total_elapsed2 += elapsed2;
        }

        try util.write_message("Run {}: \tLinearProbing Time {}ns | SeparateChaining Time {}ns \n", .{ i + 1, elapsed, elapsed2 });
    }
    var average_time: u64 = 0;
    var average_time2: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
        average_time2 = total_elapsed2 / (repeat - 1);
    } else {
        average_time = total_elapsed;
        average_time2 = total_elapsed2;
    }

    try util.write_message("Average time passed: {}ns.\n", .{average_time});

    const result = try std.fmt.allocPrint(allocator, "Insert 100000 Random numbers \tLinearProbing: {}ns \tSeparateChaining: {}ns\n", .{average_time, average_time2});

    try util.write_message("Benchmark 2 finished! Total LinearProbing: {}ns | Total SeparateChaining: {}ns | Total time: {}\n", .{ total_elapsed, total_elapsed2, total_elapsed + total_elapsed2 });
    return result;
}
