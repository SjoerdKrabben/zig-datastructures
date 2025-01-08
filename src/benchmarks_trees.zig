const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const btree = @import("datastructures/BinaryTree.zig");
const avltree = @import("datastructures/AVL_SearchTree.zig");
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

pub fn btreeBenchmark() ![]const u8 {
    var tree = btree.BinaryTree(u8).init(allocator);
    try util.printMessage("Benchmark 1: Add numbers to the B-Tree");
    var total_elapsed: u64 = 0;
    var elapsed: u64 = 0;

    const numbers: [9]u8 = .{ 2, 4, 6, 8, 10, 12, 14, 16, 18 };
    try util.printMessage("Starting timer...");
    var timer = try Timer.start();
    for (numbers) |number| {
        try tree.insert(number);

        elapsed = timer.read();
        total_elapsed += elapsed;
        timer.reset();
    }

    try util.printMessage("Benchmark 1 finished!");

    var average_time: u64 = 0;
    average_time = total_elapsed / numbers.len;

    const result = std.mem.concat(allocator, u8, &.{ "Find random number in lijst_oplopend_10000\t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Average Time passed: {}ns. Nodes in tree: {}\n", .{ average_time, numbers.len });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn avltreeBenchmark() ![]const u8 {
    var tree = avltree.AVLTree(u8).init(allocator);
    try util.printMessage("Benchmark 1: Add numbers to the AVL-Tree");
    var total_elapsed: u64 = 0;
    var elapsed: u64 = 0;

    const numbers: [9]u8 = .{ 2, 4, 6, 8, 10, 12, 14, 16, 18 };
    try util.printMessage("Starting timer...");
    var timer = try Timer.start();
    for (numbers) |number| {
        try tree.insert(number);

        elapsed = timer.read();
        total_elapsed += elapsed;
        timer.reset();
    }

    try util.printMessage("Benchmark 1 finished!");

    var average_time: u64 = 0;
    average_time = total_elapsed / numbers.len;

    const result = std.mem.concat(allocator, u8, &.{ "Find random number in lijst_oplopend_10000\t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Average Time passed: {}ns. Nodes in tree: {}\n", .{ average_time, numbers.len });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}
