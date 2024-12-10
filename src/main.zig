const std = @import("std");
const jsonDataset = @import("json_parser.zig");
const dl = @import("datastructures/DynamicList.zig");
const dll = @import("datastructures/DoublyLinkedList.zig");

const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;

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
                selection = try benchmarkDoublyLinkedList();
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
    var list = try dl.DynamicList(u16).init(allocator);
    defer list.deinit();

    try printMessage("Benchmark 1: Load 10000 u16 into DynamicList");
    try printMessage("Starting timer...");
    starttime = std.time.milliTimestamp();

    for (data.lijst_willekeurig_10000) |item| {
        try list.add(item);
    }

    const endtime = std.time.milliTimestamp() - starttime;
    try printMessage("Benchmark 1 finished!");
    try std.io.getStdOut().writer().print("Time passed: {}ms. Items in list: {}\n", .{ endtime, list.size() });

    return 0;
}

fn benchmarkDoublyLinkedList() !u8 {
    try printMessage("DoublyLinkedList LOADING");

    return 0;
}

fn printMessage(message: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("{s}\n", .{message});
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
