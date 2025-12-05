const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const btree = @import("datastructures/BinaryTree.zig");
const avltree = @import("datastructures/AVL_SearchTree.zig");
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

const NODES = 5000;

pub fn btreeBenchmark() ![]const u8 {
    var tree = btree.BinaryTree(usize).init(allocator);
    defer tree.deinit();

    try util.printMessage("Benchmark 1: Add numbers to the B-Tree");
    var elapsed: u64 = 0;

    try util.printMessage("Starting timer...");
    var timer = try Timer.start();

    for (1..NODES + 1) |number| {
        try tree.insert(number);
    }

    elapsed = timer.read();
    timer.reset();

    const elapsed_ms = util.nsToMsCeil(elapsed);

    try util.printMessage("Benchmark 1 finished!");

    const result = std.fmt.allocPrint(allocator, "Binary Tree inserts, Time passed:\t {}ns = {}ms \n", .{elapsed, elapsed_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}ns = {}ms \n", .{elapsed, elapsed_ms});
    return result;
}

pub fn avltreeBenchmark() ![]const u8 {
    var tree = avltree.AVLTree(usize).init(allocator);
    defer tree.deinit();
    try util.printMessage("Benchmark 1: Add numbers to the AVL-Tree");
    var elapsed: u64 = 0;

    try util.printMessage("Starting timer...");
    var timer = try Timer.start();

    for (0..NODES + 1) |number| {
        try tree.insert(number);
    }

    elapsed = timer.read();
    timer.reset();

    const elapsed_ms = util.nsToMsCeil(elapsed);

    try util.printMessage("Benchmark 1 finished!");

    const result = std.fmt.allocPrint(allocator, "AVL-Tree inserts, Time passed:\t {}ns = {}ms \n", .{elapsed, elapsed_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}ns = {}ms \n", .{elapsed, elapsed_ms});
    return result;
}
