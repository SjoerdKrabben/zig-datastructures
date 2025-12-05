const std = @import("std");
const jsonDataset = @import("json_parser.zig");
const util = @import("functions.zig");
const bm = @import("benchmarks.zig");
const bms = @import("benchmarks_sorteren.zig");
const bmh = @import("benchmarks_hashtable.zig");
const bmt = @import("benchmarks_trees.zig");
const srt = @import("datastructures/Sorting.zig");
const htable = @import("datastructures/HashTableSeparateChaining.zig");
const grp = @import("datastructures/Graph.zig");
const dks = @import("datastructures/Dijkstra.zig");
const meta = std.meta;
const testing = std.testing;
const allocator = std.heap.page_allocator;
const assert = std.debug.assert;
const print = std.debug.print;
const Timer = std.time.Timer;

var selection: usize = 0;
const TOTALRUNS = 5;

pub fn main() !void {
    const dataset_sorteren = try jsonDataset.loadDatasetSorteren(allocator);
    // const dataset_hashen = try jsonDataset.loadDatasetHashen(allocator);

    const options = [_][]const u8{ "1: DynamicList", "2: DoublyLinkedList", "3: Stack", "4: DoubleEndedQueue", "5: PriorityQueue", "6: BinarySearch", "7: Sorting Algoritms", "8: Hashtable", "9: Dijkstra", "10: Binary Tree", "11: AVL-Searchtree" };

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
                selection = try benchmarkHashmaps();
                continue;
            },
            9 => {
                selection = try testDijkstraShowTranslationFromPDF();
                continue;
            },
            10 => {
                selection = try benchmarkBinaryTree();
                continue;
            },
            11 => {
                selection = try benchmarkAVLTree();
                continue;
            },
            else => {
                try util.printMessage("Program terminated!");
                break;
            },
        }
    }
}

fn showMain(opts: [11][]const u8) !usize {
    var stdin_buffer: [1024]u8 = undefined; 
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin: *std.Io.Reader = &stdin_reader.interface;

    var returnValue: usize = 0;

    try util.printMessage("");
    try util.printMessage("Kies uit de verschillende datastructuren en algoritmes om ze te testen: ");

    for (opts) |option| {
        print("{s} \n", .{option});
    }

    try util.printMessage("\n");
    try util.printMessage("Kies een optie: ");

    var stdout_buffer: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;

    if(stdin.takeDelimiterExclusive('\n')) |line| {
        try stdout.print("{s}", .{line});
        if(line.len > 0) {
            const trimmedInput = std.mem.trim(u8, line, " \t\r\n");
            const formattedInput = try util.formatByteArrayToUsize(trimmedInput);

            if (formattedInput < opts.len) {
                try stdout.print("Je hebt {s} gekozen!\n", .{opts[formattedInput - 1]});
                try stdout.flush();
            }

            returnValue = formattedInput;
        }
    } else |err| switch (err) {
        error.EndOfStream => {
            try util.printMessage("Je hebt niets ingevuld!");
            returnValue = 0;
            // reached end
            // the normal case
        },
        error.StreamTooLong => {
            // the line was longer than the internal buffer
            return err;
        },
        error.ReadFailed => {
            // the read failed
            return err;
        },
    }
    return returnValue;
}

fn benchmarkDynamicList(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("DynamicList benchmarks LOADING...");
    var results = [_][]const u8{ "", "", "" };

    results[0] = try bm.dlBenchmark1(data, TOTALRUNS);

    results[1] = try bm.dlBenchmark2(data, TOTALRUNS);

    results[2] = try bm.dlBenchmark3(data, TOTALRUNS);

    try util.printMessage("\nDynamicList Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkDoublyLinkedList(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("DoublyLinkedList benchmarks LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.dllBenchmark1(data, TOTALRUNS);

    results[1] = try bm.dllBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nDoublyLinkedList Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkStack(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("Stack LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.stckBenchmark1(data, TOTALRUNS);
    results[1] = try bm.stckBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nStack Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkDeque(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("Double-Ended Queue LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.dqueBenchmark1(data, TOTALRUNS);
    results[1] = try bm.dqueBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nDouble-Ended Queue Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkPriorityQueue(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("PriorityQueue LOADING");
    var results = [_][]const u8{ "", "" };

    results[0] = try bm.pqueBenchmark1(data, TOTALRUNS);
    results[1] = try bm.pqueBenchmark2(data, TOTALRUNS);

    try util.printMessage("\nPriorityQueue Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}
fn benchmarkBinarySearch(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("BinarySearch test");
    var results = [_][]const u8{""};

    results[0] = try bm.bsrcBenchmark1(data, TOTALRUNS);

    try util.printMessage("\nBinarySearch Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkSortingAlgoritms(data: jsonDataset.Dataset_sorteren) !usize {
    try util.printMessage("Sorting Benchmarks Starting...");
    //var results = [_][]const u8{ "", "", "", "", "", "", "", "", ""};
    var results: [9][]const u8 = undefined;

    const sort = srt.Sort(u16);

    if (bms.sortLijstWillekeurigBenchmark(sort.insertionSort, data, TOTALRUNS)) |result| {
        results[0] = try std.fmt.allocPrint(allocator, "2. InsertionSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[0] = "SelectionSort Failed!",
        }
    }
    if (bms.sortLijstWillekeurigBenchmark(sort.selectionSort, data, TOTALRUNS)) |result| {
        results[1] = try std.fmt.allocPrint(allocator, "1. SelectionSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[1] = "SelectionSort Failed!",
        }
    }

    if (bms.sortLijstWillekeurigBenchmark(sort.quickSort, data, TOTALRUNS)) |result| {
        results[2] = try std.fmt.allocPrint(allocator, "3. QuickSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[2] = "QuickSort Failed!",
        }
    }
    if (bms.sortLijstWillekeurigBenchmark(sort.mergeSort, data, TOTALRUNS)) |result| {
        results[3] = try std.fmt.allocPrint(allocator, "4. Parallel-MergeSort => \t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[3] = "Parallel-MergeSort Failed!",
        }
    }

    results[4] = "-----------------------------------\n\n";

    const newSort = srt.Sort(u32);

    if (bms.sort100000Random(newSort.insertionSort, TOTALRUNS)) |result| {
        results[5] = try std.fmt.allocPrint(allocator, "5. InsertionSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[5] = "InsertionSort Failed!",
        }
    }

    if (bms.sort100000Random(newSort.selectionSort, TOTALRUNS)) |result| {
        results[6] = try std.fmt.allocPrint(allocator, "6. SelectionSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[6] = "SelectionSort Failed!",
        }
    }

    if (bms.sort100000Random(newSort.quickSort, TOTALRUNS)) |result| {
        results[7] = try std.fmt.allocPrint(allocator, "7. QuickSort => \t\t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[7] = "QuickSort Failed!",
        }
    }

    if (bms.sort100000Random(newSort.mergeSort, TOTALRUNS)) |result| {
        results[8] = try std.fmt.allocPrint(allocator, "8. Parallel-MergeSort => \t{s}\n", .{result});
    } else |err| {
        switch (err) {
            else => results[8] = "Parallel-MergeSort Failed!",
        }
    }

    try util.printMessage("\nSorting Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkHashmaps() !usize {
    try util.printMessage("Hashtable Benchmarks Starting...");
    var results: [1][]const u8 = undefined;
    const result = try bmh.insert100000RandomEntries(TOTALRUNS);

    results[0] = try std.fmt.allocPrint(allocator, "Insert Random numbers => \t{s}\n", .{result});

    try util.printMessage("\nHashTable Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn testDijkstraShowTranslationFromPDF() !usize {
    var G = try grp.Graph().init(allocator, 5);
    defer G.deinit();

    const v1 = try G.createVertex("Vertex_A");
    const v2 = try G.createVertex("Vertex_B");
    const v3 = try G.createVertex("Vertex_C");
    const v4 = try G.createVertex("Vertex_D");
    const v5 = try G.createVertex("Vertex_E");

    try G.addEdge(v1, v2, 12);
    try G.addEdge(v1, v4, 87);
    try G.addEdge(v2, v5, 11);
    try G.addEdge(v3, v1, 19);
    try G.addEdge(v4, v2, 23);
    try G.addEdge(v4, v3, 10);
    try G.addEdge(v5, v4, 43);

    try dks.Dijkstra(&G, "Vertex_A");

    try util.printMessage("Dijkstra algoritm result: ");

    try printShortestPath(v1, "Vertex_A");
    try printShortestPath(v2, "Vertex_B");
    try printShortestPath(v3, "Vertex_C");
    try printShortestPath(v4, "Vertex_D");
    try printShortestPath(v5, "Vertex_E");

    return 0;
}

fn printShortestPath(target: *grp.Graph().Vertex, target_name: []const u8) !void {
    try util.write_message("From Vertex_A to {s}: ", .{target_name});

    if (target.prev == null) {
        try util.write_message("No path found.\n", .{});
        return;
    }

    var current: ?*grp.Graph().Vertex = target;
    var path = std.ArrayList(u8).empty;
    defer path.deinit(allocator);

    while (current) |current_vertex| {
        if (current_vertex.name) |name| {
            try path.appendSlice(allocator, name);
        }
        current = current_vertex.prev;
    }
    try util.write_message("Shortest Distance: {d}\n", .{target.dist.?});
}

fn benchmarkBinaryTree() !usize {
    try util.printMessage("BinaryTree Benchmarks Starting...");
    var results: [1][]const u8 = undefined;
    const result = try bmt.btreeBenchmark();

    results[0] = try std.fmt.allocPrint(allocator, "Binary Tree => \t{s}\n", .{result});

    try util.printMessage("\nBinaryTree Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
    }

    return 0;
}

fn benchmarkAVLTree() !usize {
    try util.printMessage("AVL-Tree Benchmarks Starting...");
    var results: [1][]const u8 = undefined;
    const result = try bmt.avltreeBenchmark();

    results[0] = try std.fmt.allocPrint(allocator, "AVL-Searchtree => \t{s}\n", .{result});

    try util.printMessage("\nAVL-tree Benchmarks finished!");

    for (results) |r| {
        try util.write_message("{s}", .{r});
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
