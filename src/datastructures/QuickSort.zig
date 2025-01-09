const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn quickSort(array: []i32, low: usize, high: usize) void {
    if (low < high) {
        const pivot_index = partition(array, low, high);

        if (pivot_index > 0) {
            quickSort(array, low, pivot_index - 1);
        }
        quickSort(array, pivot_index + 1, high);
    }
}

fn partition(array: []i32, low: usize, high: usize) usize {
    const mid = low + (high - low) / 2;

    if (array[low] > array[mid]) swap(array, low, mid);
    if (array[low] > array[high]) swap(array, low, high);
    if (array[mid] > array[high]) swap(array, mid, high);

    const pivot = array[mid];
    swap(array, mid, high);

    var i = low;
    for (i..high) |j| {
        if (array[j] < pivot) {
            swap(array, j, i);
            i += 1;
        }
    }

    swap(array, i, high);
    return i;
}

fn swap(array: []i32, a: usize, b: usize) void {
    const temp = array[a];
    array[a] = array[b];
    array[b] = temp;
}

test "quicksort werkt correct met een gesorteerde array" {
    var array: [5]i32 = [_]i32{ 1, 2, 3, 4, 5 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een omgekeerde array" {
    var array: [5]i32 = [_]i32{ 5, 4, 3, 2, 1 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een array met herhaalde waarden" {
    var array: [7]i32 = [_]i32{ 4, 2, 4, 3, 1, 4, 2 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 2, 3, 4, 4, 4 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een array van één element" {
    var array: [1]i32 = [_]i32{42};
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{42};

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een willekeurige array" {
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 11, 12, 22, 25, 64 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}
