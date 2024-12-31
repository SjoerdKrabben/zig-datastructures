const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");
const stck = @import("datastructures/Stack.zig");
const dque = @import("datastructures/DoubleEndedQueue.zig");
const pque = @import("datastructures/PriorityQueue.zig");
const bsrc = @import("datastructures/BinarySearch.zig");
const insrt = @import("datastructures/InsertionSort.zig");
const selsrt = @import("datastructures/SelectionSort.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var starttime: i64 = undefined;
var selection: u8 = 0;

pub fn dlBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var list = try dl.DynamicList(u16).init(allocator);
    defer list.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 10000 u16 into DynamicList");

    for (0..repeat) |i| {
        list.clear();

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_willekeurig_10000) |item| {
            try list.add(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(list.size() == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.size() });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn dlBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var list = try dl.DynamicList(f128).init(allocator);
    defer list.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 2: Load 8001 f128 into DynamicList");

    for (0..repeat) |i| {
        list.clear();

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_float_8001) |item| {
            try list.add(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(list.size() == data.lijst_float_8001.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.size() });

    const result = std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t\t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn dllBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    const L = dll.DoublyLinkedList(u16);
    var list = L{};
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 10000 u16 into DoublyLinkedList");

    for (0..repeat) |i| {
        while (true) {
            const item = list.pop();

            if (item == null) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_willekeurig_10000) |item| {
            const node = try allocator.create(L.Node);
            node.* = L.Node{ .data = item };

            list.append(node);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(list.len == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.len });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn dllBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    try util.printMessage("DoublyLinkedList LOADING");
    const L = dll.DoublyLinkedList(f128);
    var list = L{};
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 2: Load 8001: f128 into DoublyLinkedList");

    for (0..repeat) |i| {
        while (true) {
            const item = list.pop();

            if (item == null) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_float_8001) |item| {
            const node = try allocator.create(L.Node);
            node.* = L.Node{ .data = item };

            list.append(node);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(list.len == data.lijst_float_8001.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.len });

    const result = std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t\t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn stckBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var stack = stck.Stack(u16).init(allocator);
    defer stack.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 10000 u16 into Stack");

    for (0..repeat) |i| {
        while (true) {
            const item = stack.pop();

            if (item == error.StackUnderflow) {
                break;
            }
        }
        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_willekeurig_10000) |item| {
            try stack.push(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(stack.size() == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in stack: {}\n", .{ average_time, stack.size() });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn stckBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var stack = stck.Stack(f128).init(allocator);
    defer stack.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 2: Load 8001 f128 into Stack");

    for (0..repeat) |i| {
        while (true) {
            const item = stack.pop();

            if (item == error.StackUnderflow) {
                break;
            }
        }
        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_float_8001) |item| {
            try stack.push(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(stack.size() == data.lijst_float_8001.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in stack: {}\n", .{ average_time, stack.size() });

    const result = std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t\t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn dqueBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var deque = try dque.Deque(u16).init(allocator);
    defer deque.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 10000 u16 into Deque");

    for (0..repeat) |i| {
        while (true) {
            if (deque.deleteRight() catch |err| err == error.EmptyQueue) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_willekeurig_10000) |item| {
            try deque.insertRight(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(deque.size() == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in deque: {}\n", .{ average_time, deque.size() });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn dqueBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var deque = try dque.Deque(f128).init(allocator);
    defer deque.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 8001 f128 into Deque");

    for (0..repeat) |i| {
        while (true) {
            if (deque.deleteRight() catch |err| err == error.EmptyQueue) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_float_8001) |item| {
            try deque.insertRight(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(deque.size() == data.lijst_float_8001.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in deque: {}\n", .{ average_time, deque.size() });

    const result = std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn pqueBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var prioque = try pque.PriorityQueue(u16).init(allocator);
    defer prioque.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 10000 u16 into PriorityQueue");

    for (0..repeat) |i| {
        while (true) {
            if (prioque.poll() catch |err| err == error.EmptyQueue) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_willekeurig_10000) |item| {
            try prioque.add(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(prioque.size() == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in PriorityQueue: {}\n", .{ average_time, prioque.size() });

    const result = std.mem.concat(allocator, u8, &.{ "1. Load 10000 integers: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn pqueBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var prioque = try pque.PriorityQueue(f128).init(allocator);
    defer prioque.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 8001 f128 into Deque");

    for (0..repeat) |i| {
        while (true) {
            if (prioque.poll() catch |err| err == error.EmptyQueue) {
                break;
            }
        }

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        for (data.lijst_float_8001) |item| {
            try prioque.add(item);
        }

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(prioque.size() == data.lijst_float_8001.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns. Items in PriorityQueue: {}\n", .{ average_time, prioque.size() });

    const result = std.mem.concat(allocator, u8, &.{ "2. Load 8001 floats: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});
    return result;
}

pub fn bsrcBenchmark1(data: jsonDataset.Dataset_sorteren) ![]const u8 {
    try util.printMessage("Benchmark 1: Find random number in lijst_oplopend_10000");
    const rand = std.crypto.random;
    const number = rand.intRangeAtMost(i32, 0, 10000);

    try util.printMessage("Starting timer...");
    var timer = try Timer.start();

    const hasNumber = bsrc.binarySearch(data.lijst_oplopend_10000, 0, data.lijst_oplopend_10000.len - 1, number);

    try util.printMessage("BinarySearch finished!");

    const elapsed = timer.read();
    try util.printMessage("Benchmark 1 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ns. Items in list: {}\n", .{ elapsed, data.lijst_oplopend_10000.len });

    if (hasNumber > -1) {
        try std.io.getStdOut().writer().print("The array contains {}!\n", .{number});
    } else {
        try std.io.getStdOut().writer().print("Number {} not found!\n", .{number});
    }

    const result = std.fmt.allocPrint(allocator, "1. Number {} found in lijst_oplopend_10000", .{hasNumber});

    return result;
}

pub fn sortLijstWillekeurigBenchmark(sort: fn ([]u16) void, data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
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
        sort(data.lijst_willekeurig_10000);

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(sortedList.len == data.lijst_willekeurig_10000.len);
        try std.io.getStdOut().writer().print("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    const average_time = total_elapsed / (repeat - 1);

    try std.io.getStdOut().writer().print("Average time passed: {}ns.\n", .{average_time});

    const result = std.mem.concat(allocator, u8, &.{ " lijst_willekeurig_10000: \t", try util.formatToString(average_time), "ns \n" });

    try std.io.getStdOut().writer().print("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});
    return result;
}
