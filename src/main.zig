//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const dl = @import("1_DynamicList/DynamicList.zig");
const jsonDataset = @import("99_JSONParser/JsonParser.zig");
const print = std.debug.print;
var selection: u8 = 9;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const options = [5][]const u8{ "1: DynamicList", "2: DoublyLinkedList", "3: Stack", "4: Queue", "5: PriorityQueue" };

    try jsonDataset.loadStrFromFile();

    while (true) {
        switch (selection) {
            0 => {
                selection = try showMain(options[0..5]);
                continue;
            },
            1 => {
                selection = try showDynamicList();
                continue;
            },
            2 => {
                selection = try showDoublyLinkedList();
                continue;
            },
            else => {
                try stdout.print("Program terminated!\n", .{});
                selection = 9;
                break;
            },
        }
    }
}

fn showMain(opts: *const [5][]const u8) !u8 {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var inputBuffer: [10]u8 = undefined;
    var returnValue: u8 = 0;

    try stdout.print("\n", .{});
    try stdout.print("Kies uit de verschillende datastructuren en algoritmes om ze te testen: \n", .{});
    try stdout.print("\n", .{});

    for (opts) |option| {
        print("{s} \n", .{option});
    }

    try stdout.print("\n", .{});
    try stdout.print("Kies een optie: ", .{});

    const input = try stdin.readUntilDelimiterOrEof(&inputBuffer, '\n');

    if (input) |val| {
        if (val.len == 0) {
            try stdout.print("Je hebt niets ingevuld!\n", .{});
        } else {
            const byteValue: []u8 = val[0..1];
            const chosenNumber = try std.fmt.parseInt(usize, byteValue, 10);

            if (chosenNumber < opts.len) {
                try stdout.print("Je hebt {s} gekozen!\n", .{opts[chosenNumber - 1]});
            }

            returnValue = @as(u8, @truncate(chosenNumber));
        }
    }
    return returnValue;
}

fn showDynamicList() !u8 {
    const stdout = std.io.getStdOut().writer();
    const file = try std.fs.cwd().createFile("assets/dataset_sorteren.json", .{ .read = true });

    try stdout.print("DynamicList LOADING\n", .{});

    defer file.close();

    return 0;
}

fn showDoublyLinkedList() !u8 {
    const stdout = std.io.getStdOut().writer();
    const file = try std.fs.cwd().createFile("assets/dataset_sorteren.json", .{ .read = true });

    try stdout.print("DoublyLinkedList LOADING\n", .{});

    defer file.close();
    return 0;
}
