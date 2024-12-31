const std = @import("std");
const jsonDataset = @import("json_parser.zig");
const util = @import("functions.zig");
const bm = @import("benchmarks.zig");
const srt = @import("datastructures/Sorting.zig");
const meta = std.meta;
const allocator = std.heap.page_allocator;
const print = std.debug.print;
const Timer = std.time.Timer;

var selection: u8 = 0;
const TOTALRUNS = 10;

pub fn main() !void {
    const dataset_sorteren = try jsonDataset.loadDataset(allocator, "assets/test_json.json");
    const options = [_][]const u8{ "1: DynamicList", "2: DoublyLinkedList", "3: Stack", "4: DoubleEndedQueue", "5: PriorityQueue", "6: BinarySearch", "7: Sorting Algoritms", "8: Parallel-Merge Sort", "9: Hashtable", "10: Graph", "11: Dijkstra", "12: AVL-Searchtree" };

    while (true) {
        switch (selection) {
            0 => {
                selection = try showMain(options);
                continue;
            },
            1 => {
                selection = try benchmarkDynamicList(dataset_sorteren);
                continue;
            },
            2 => {
                selection = try benchmarkDoublyLinkedList(dataset_sorteren);
                continue;
            },
            3 => {
                selection = try benchmarkStack(dataset_sorteren);
                continue;
            },
            4 => {
                selection = try benchmarkDeque(dataset_sorteren);
                continue;
            },
            5 => {
                selection = try benchmarkPriorityQueue(dataset_sorteren);
                continue;
            },
            6 => {
                selection = try benchmarkBinarySearch(dataset_sorteren);
                continue;
            },
            7 => {
                selection = try benchmarkSortingAlgoritms(dataset_sorteren);
                continue;
            },
            8 => {
                selection = 10;
                continue;
            },
            9 => {
                selection = 10;
                continue;
            },

            else => {
                try util.printMessage("Program terminated!");
                selection = 10;
                break;
            },
        }
    }
}

fn showMain(opts: [12][]const u8) !u8 {
    const stdin = std.io.getStdIn().reader();
    var inputBuffer: [10]u8 = undefined;
    var returnValue: u8 = 0;

    try util.printMessage("");
    try util.printMessage("Kies uit de verschillende datastructuren en algoritmes om ze te testen: ");

    for (opts) |option| {
        print("{s} \n", .{option});
    }

    try util.printMessage("\n");
    try util.printMessage("Kies een optie: ");

    const input = try stdin.readUntilDelimiterOrEof(&inputBuffer, '\n');

    if (input) |val| {
        if (val.len == 0) {
            try util.printMessage("Je hebt niets ingevuld!");
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
    try util.printMessage("DynamicList benchmarks LOADING...");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.dlBenchmark1(data, TOTALRUNS);

    results[1] = try bm.dlBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nDynamicList Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkDoublyLinkedList(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("DoublyLinkedList benchmarks LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.dllBenchmark1(data, TOTALRUNS);

    results[1] = try bm.dllBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nDoublyLinkedList Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkStack(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("Stack LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.stckBenchmark1(data, TOTALRUNS);
    results[1] = try bm.stckBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nStack Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkDeque(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("Double-Ended Queue LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.dqueBenchmark1(data, TOTALRUNS);
    results[1] = try bm.dqueBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nDouble-Ended Queue Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkPriorityQueue(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("PriorityQueue LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.pqueBenchmark1(data, TOTALRUNS);
    results[1] = try bm.pqueBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nPriorityQueue Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}
fn benchmarkBinarySearch(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("BinarySearch test");
    var results = [_][]const u8{""};

    results[0] = try bm.bsrcBenchmark1(data);

    try util.printMessage("\nBinarySearch Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

fn benchmarkSortingAlgoritms(data: jsonDataset.Dataset_sorteren) !u8 {
    try util.printMessage("Sorting Benchmarks Starting...");
    var results = [_][]const u8{""};

    const sort = srt.Sort(u16);

    if (bm.sortLijstWillekeurigBenchmark(sort.selectionSort, data, TOTALRUNS)) |result| {
        results[0] = try std.fmt.allocPrint(allocator, "1. SelectionSort => {s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[0] = "SelectionSort Failed!",
        }
    }
    if (bm.sortLijstWillekeurigBenchmark(sort.insertionSort, data, TOTALRUNS)) |result| {
        results[0] = try std.fmt.allocPrint(allocator, "2. InsertionSort => {s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[0] = "SelectionSort Failed!",
        }
    }

    try util.printMessage("\nSorting Benchmarks finished!");

    for (results) |r| {
        try std.io.getStdOut().writer().print("{s}", .{r});
    }

    return 0;
}

test "addJsonFileToDynamicList" {
    const dl = @import("datastructures/DynamicList.zig");
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
    const dll = @import("datastructures/DoublyLinkedList.zig");
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
