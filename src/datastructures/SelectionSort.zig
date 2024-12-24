const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn selectionSort(array: []i32) void {
    var min_index: usize = 0;
    for (array, 0..) |_, i| {
        min_index = i;

        for (i + 1..array.len) |j| {
            if (array[j] < array[min_index]) {
                min_index = j;
            }
        }

        if (min_index != i) {
            const temp: i32 = array[i];
            array[i] = array[min_index];
            array[min_index] = temp;
        }
    }
}

test "Test selectionSort" {
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };

    print("Originele array: {d}\n", .{array[0..]});
    selectionSort(&array);
    print("Gesorteerde array: {d}\n", .{array[0..]});

    var data: [5]i32 = [_]i32{ 5, 3, 4, 1, 2 };
    selectionSort(&data);
    for (1..5) |n| {
        try testing.expect(data[n - 1] == n);
    }
}
