const std = @import("std");
const util = @import("functions.zig");
const jsonDataset = @import("json_parser.zig");
const srt = @import("datastructures/Sorting.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");
const stck = @import("datastructures/Stack.zig");
const dque = @import("datastructures/DoubleEndedQueue.zig");
const pque = @import("datastructures/PriorityQueue.zig");
const bsrc = @import("datastructures/BinarySearch.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;
const rand = std.crypto.random;

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
        
        try util.write_message("Run {}, Time {}ns \n", .{i + 1, elapsed});
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "1. Load 10000 integers: \t {}ns = {}ms \n", .{average_time, average_ms});
    
    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "2. Load 8001 floats: \t\t {}ns = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn dlBenchmark3(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var list = try dl.DynamicList(u16).init(allocator);
    defer list.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Remove 10000 u16 from DynamicList");

    for (data.lijst_willekeurig_10000) |item| {
        try list.add(item);
    }

    for (0..repeat * 10) |i| {
        const search_item = rand.intRangeAtMost(u16, 0, 12000);

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        const found = list.contains(search_item);

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        std.debug.assert(list.size() == data.lijst_willekeurig_10000.len);

        try util.write_message("Run {}, Item {} found?: {} Time {}ns \n", .{ i + 1, search_item, found, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat * 10 - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "1. List contains: \t {}ns = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.len });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "1. Load 10000 integers: \t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in list: {}\n", .{ average_time, list.len });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "2. Load 8001 floats: \t\t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

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
    }
    var average_time: u64 = 0;

    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    const average_ms = util.nsToMsCeil(average_time);

    const result = std.fmt.allocPrint(allocator, "1. Load 10000 integers: \t {}ns  = {}ms \n", .{average_time, average_ms});
    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in stack: {}\n", .{ average_time, stack.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "2. Load 8001 floats: \t\t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn dqueBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var deque = dque.Deque(u16).init(allocator);
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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in deque: {}\n", .{ average_time, deque.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "1. Load 10000 integers: \t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn dqueBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    var deque = dque.Deque(f128).init(allocator);
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
        
        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in deque: {}\n", .{ average_time, deque.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "2. Load 8001 floats: \t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn pqueBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    const sort = srt.Sort(u16);
    var prioque = try pque.PriorityQueue(u16).init(allocator, sort.insertionSort);
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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in PriorityQueue: {}\n", .{ average_time, prioque.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "1. Load 10000 integers: \t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn pqueBenchmark2(data: jsonDataset.Dataset_sorteren, repeat: usize) ![]const u8 {
    const sort = srt.Sort(f128);
    var prioque = try pque.PriorityQueue(f128).init(allocator, sort.insertionSort);
    defer prioque.deinit();
    var total_elapsed: u64 = 0;

    try util.printMessage("Benchmark 1: Load 8001 f128 into PriorityQueue");

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

        try util.write_message("Run {}, Time {}ns \n", .{ i + 1, elapsed });
    }
    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    try util.write_message("Average time passed: {}ns. Items in PriorityQueue: {}\n", .{ average_time, prioque.size() });

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "2. Load 8001 floats: \t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Benchmark 2 finished! Total time: {}\n", .{total_elapsed});

    return result;
}

pub fn bsrcBenchmark1(data: jsonDataset.Dataset_sorteren, repeat: u8) ![]const u8 {
    try util.printMessage("Benchmark 1: Find random number in lijst_oplopend_10000");
    var total_elapsed: u64 = 0;

    for (0..repeat) |i| {
        const number = rand.intRangeAtMost(i32, 0, 10000);

        if (i == 0) {
            try util.printMessage("Warming up...");
        } else {
            try util.printMessage("Starting timer...");
        }

        var timer = try Timer.start();

        const hasNumber = bsrc.binarySearch(data.lijst_oplopend_10000, 0, data.lijst_oplopend_10000.len - 1, number);

        const elapsed = timer.read();

        if (i > 0) {
            total_elapsed += elapsed;
        }

        try util.printMessage("Benchmark 1 finished!");

        if (hasNumber > -1) {
            try util.write_message("Run {}, Time {}ns. The array contains {}!\n", .{ i + 1, elapsed, number });
        } else {
            try util.write_message("Run {}, Time {}ns. The array contains {}!\n", .{ i + 1, elapsed, number });
        }
    }

    var average_time: u64 = 0;
    if (repeat > 1) {
        average_time = total_elapsed / (repeat - 1);
    } else {
        average_time = total_elapsed;
    }

    const average_ms = util.nsToMsCeil(average_time);
    const result = std.fmt.allocPrint(allocator, "Find random number in lijst_oplopend_10000\t {}ns  = {}ms \n", .{average_time, average_ms});

    try util.write_message("Average Time passed: {}ns. Items in list: {}\n", .{ average_time, data.lijst_oplopend_10000.len });

    try util.write_message("Benchmark 1 finished! Total time: {}\n", .{total_elapsed});

    return result;
}
