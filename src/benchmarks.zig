const std = @import("std");
const jsonDataset = @import("json_parser.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");
const bsrc = @import("datastructures/BinarySearch.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var starttime: i64 = undefined;
var selection: u8 = 0;

pub fn dlBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    var list = try dl.DynamicList(u16).init(allocator);
    defer list.deinit();

    try printMessage("Benchmark 1: Load 10000 u16 into DynamicList");
    try printMessage("Starting timer...");
    var timer = try Timer.start();

    for (data.lijst_willekeurig_10000) |item| {
        try list.add(item);
    }

    const elapsed = timer.read();
    try printMessage("Benchmark 1 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, list.size() });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try formatToString(elapsed), "ns \n" });

    return result;
}

pub fn dlBenchmark2(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    var list = try dl.DynamicList(f128).init(allocator);
    defer list.deinit();

    try printMessage("Benchmark 2: Load 8001 f128 into DynamicList");
    try printMessage("Starting timer...");
    var timer = try Timer.start();

    for (data.lijst_float_8001) |item| {
        try list.add(item);
    }

    const elapsed = timer.read();
    try printMessage("Benchmark 2 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, list.size() });

    const result = std.mem.concat(allocator, u8, &.{ "2: Load 8001 floats: \t", try formatToString(elapsed), "ns \n" });

    return result;
}

pub fn dllBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    const L = dll.DoublyLinkedList(u16);
    var list = L{};

    try printMessage("Benchmark 1: Load 10000 u16 into DoublyLinkedList");
    try printMessage("Starting timer...");
    var timer = try Timer.start();

    for (data.lijst_willekeurig_10000) |item| {
        const node = try allocator.create(L.Node);
        node.* = L.Node{ .data = item };

        list.append(node);
    }

    const elapsed = timer.read();
    try printMessage("Benchmark 1 finished!");

    try std.io.getStdOut().writer().print("Timer passed: {d}ns. Items in list: {}\n", .{ elapsed, list.len });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try formatToString(elapsed), "ns \n" });
    return result;
}

pub fn dllBenchmark2(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    try printMessage("DoublyLinkedList LOADING");
    const L = dll.DoublyLinkedList(f128);
    var list = L{};

    try printMessage("Benchmark 2: Load 8001: f128 into DoublyLinkedList");
    try printMessage("Starting timer...");
    var timer = try Timer.start();

    for (data.lijst_float_8001) |item| {
        const node = try allocator.create(L.Node);
        node.* = L.Node{ .data = item };

        list.append(node);
    }

    const elapsed = timer.read();
    try printMessage("Benchmark 2 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, list.len });

    const result = try std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t", try formatToString(elapsed), "ns \n" });
    return result;
}

pub fn bsBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    try printMessage("Benchmark 1: Find random number in lijst_oplopend_10000");
    const rand = std.crypto.random;
    const number = rand.intRangeAtMost(u16, 0, 10000);

    try printMessage("Starting timer...");
    var timer = try Timer.start();

    const hasNumber = bsrc.binarySearch(data.lijst_oplopend_10000, 0, data.lijst_oplopend_10000.len - 1, number);

    try printMessage("BinarySearch finished!");

    const elapsed = timer.read();
    try printMessage("Benchmark 1 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, data.lijst_oplopend_10000.len });

    if (hasNumber > -1) {
        try std.io.getStdOut().writer().print("The array contains {}!\n", .{number});
    } else {
        try std.io.getStdOut().writer().print("Number {} not found!\n", .{number});
    }

    const result = std.fmt.allocPrint(allocator, "1. Number {} found in lijst_oplopend_10000", .{hasNumber});

    return result;
}

fn formatToString(input: u64) ![]u8 {
    var buffer: [64]u8 = undefined;

    const slice = std.fmt.bufPrintIntToSlice(&buffer, @as(u64, input), 10, .lower, .{});
    const result = try allocator.dupe(u8, slice);

    return result;
}

fn printMessage(message: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("{s}\n", .{message});
}
