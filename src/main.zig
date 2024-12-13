const std = @import("std");
const jsonDataset = @import("json_parser.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var starttime: i64 = undefined;
var selection: u8 = 0;

pub fn main() !void {
    const testData = try jsonDataset.loadDataset(allocator);
    const options = [5][]const u8{ "1: DynamicList", "2: DoublyLinkedList", "3: Stack", "4: Queue", "5: PriorityQueue" };

    while (true) {
        switch (selection) {
            0 => {
                selection = try showMain(options[0..5]);
                continue;
            },
            1 => {
                selection = try benchmarkDynamicList(testData);
                continue;
            },
            2 => {
                selection = try benchmarkDoublyLinkedList(testData);
                continue;
            },
            else => {
                try printMessage("Program terminated!");
                selection = 9;
                break;
            },
        }
    }
}

fn showMain(opts: *const [5][]const u8) !u8 {
    const stdin = std.io.getStdIn().reader();
    var inputBuffer: [10]u8 = undefined;
    var returnValue: u8 = 0;

    try printMessage("");
    try printMessage("Kies uit de verschillende datastructuren en algoritmes om ze te testen: ");

    for (opts) |option| {
        print("{s} \n", .{option});
    }

    try printMessage("\n");
    try printMessage("Kies een optie: ");

    const input = try stdin.readUntilDelimiterOrEof(&inputBuffer, '\n');

    if (input) |val| {
        if (val.len == 0) {
            try printMessage("Je hebt niets ingevuld!");
        } else {
            const byteValue: []u8 = val[0..1];
            const chosenNumber = try std.fmt.parseInt(usize, byteValue, 10);

            if (chosenNumber < opts.len) {
                print("Je hebt {s} gekozen!\n", .{opts[chosenNumber - 1]});
            }

            returnValue = @as(u8, @truncate(chosenNumber));
        }
    }
    return returnValue;
}

fn benchmarkDynamicList(data: jsonDataset.Dataset_sorteren) !u8 {
    try printMessage("DynamicList benchmarks LOADING...");
    var results = [2][]const u8{ "", "" };

    results[0] = try dlBenchmark1(data);

    results[1] = try dlBenchmark2(data);

    try printMessage("\nDynamicList Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkDoublyLinkedList(data: jsonDataset.Dataset_sorteren) !u8 {
    try printMessage("DoublyLinkedList LOADING");
    var results = [2][]const u8{ "", "" };

    results[0] = try dllBenchmark1(data);

    results[1] = try dllBenchmark2(data);

    try printMessage("\nDoublyLinkedList Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn printMessage(message: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("{s}\n", .{message});
}

fn dlBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
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

fn dlBenchmark2(data: jsonDataset.Dataset_sorteren) ![]const u8 {
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

fn dllBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
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

fn dllBenchmark2(data: jsonDataset.Dataset_sorteren) ![]const u8 {
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
    try printMessage("Benchmark 1 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, list.len });

    const result = try std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t", try formatToString(elapsed), "ns \n" });
    return result;
}

fn formatToString(input: u64) ![]u8 {
    var buffer: [64]u8 = undefined;

    const slice = std.fmt.bufPrintIntToSlice(&buffer, @as(u64, input), 10, .lower, .{});
    const result = try allocator.dupe(u8, slice);

    return result;
}

test "addJsonFileToDynamicList" {
    const dataset = try jsonDataset.loadDataset(allocator, "assets/test_json.json");
    var dList = try dl.DynamicList(i64).init(allocator);

    var count: u32 = 0;
    for (dataset.lijst_willekeurig_3) |item| {
        try dList.add(item);
        count += 1;
    }
    print("Count: {}\n", .{count});
}

test "addJsonFileToDoublyLinkedList" {
    const dataset = try jsonDataset.loadDataset(allocator, "assets/test_json.json");
    const L = dll.DoublyLinkedList(u8);
    var list = L{};

    for (dataset.lijst_willekeurig_3) |item| {
        const node = try allocator.create(L.Node);
        node.* = L.Node{ .data = item };

        list.append(node);
    }

    var it = list.first;
    var index: u32 = 0;
    while (it) |node| : (it = node.next) {
        print("Item on index: {} has value: {any}\n", .{ index, node.data });
        index += 1;
    }
}
