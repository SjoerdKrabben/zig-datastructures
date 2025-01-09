const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn insertionSort(array: []i32) void {
    for (1..array.len) |i| {
        const key: i32 = array[i];
        var j: usize = i;

        while (j > 0 and array[j - 1] > key) : (j -= 1) {
            array[j] = array[j - 1];
        }
        print("i = {} and j = {}\n", .{ i, j });
        array[j] = key;
    }
}

test "Test insertionSort" {
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };

    print("Originele array: {d}\n", .{array[0..]});
    insertionSort(&array);
    print("Gesorteerde array: {d}\n", .{array[0..]});

    var data: [5]i32 = [_]i32{ 5, 3, 4, 1, 2 };
    insertionSort(&data);
    for (1..5) |n| {
        try testing.expect(data[n - 1] == n);
    }
}
