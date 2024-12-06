const std = @import("std");
const meta = std.meta;

const Dataset_sorteren = struct { lijst_aflopend_2: []const i64, lijst_oplopend_2: []i64, lijst_float_8001: []f128, lijst_gesorteerd_aflopend_3: []u8, lijst_gesorteerd_oplopend_3: []u8, lijst_herhaald_1000: []i8, lijst_leeg_0: []u8, lijst_null_1: []?u8, lijst_null_3: []?u8, lijst_oplopend_10000: []u16, lijst_willekeurig_10000: []u16, lijst_willekeurig_3: []u8 };

const Test_dataset = struct {
    const Self = @This();
    items: Dataset_sorteren,

    const Fields = meta.FieldEnum(Dataset_sorteren);

    pub fn readField(self: Self, comptime field: Fields) meta.FieldType(Dataset_sorteren, field) {
        const item_ref = &self.items;
        return @field(item_ref, meta.fieldInfo(Dataset_sorteren, field).name);
    }
};

pub fn loadDataset(allocator: std.mem.Allocator, file_path: []const u8) !Dataset_sorteren {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_content);

    const parsed = try std.json.parseFromSlice(Dataset_sorteren, allocator, file_content, .{});
    defer parsed.deinit();

    const source: Dataset_sorteren = parsed.value;
    const dataset: Test_dataset = undefined;
    std.debug.print("source: {any}\n", .{@typeInfo(source.lijst_aflopend_2)});
    std.debug.print("dest: {any}\n", .{@typeInfo(dataset.items.lijst_aflopend_2)});

    // const dataset_items = try allocateFieldsToHeap(allocator, parsed.value);

    // dataset.items = dataset_items;

    // std.debug.print("{any}\n", .{dataset.readField(.lijst_aflopend_2)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_oplopend_2)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_float_8001)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_gesorteerd_aflopend_3)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_herhaald_1000)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_leeg_0)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_null_1)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_null_3)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_oplopend_10000)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_willekeurig_10000)});
    // std.debug.print("{any}\n", .{dataset.readField(.lijst_willekeurig_3)});

    return dataset;
}

fn allocateFieldsToHeap(allocator: std.mem.Allocator, source: Dataset_sorteren) !Dataset_sorteren {
    var result: Dataset_sorteren = undefined;

    result.lijst_aflopend_2 = try allocator.dupe(i64, source.lijst_aflopend_2);
    result.lijst_oplopend_2 = try allocator.dupe([]i64, source.lijst_oplopend_2);
    result.lijst_float_8001 = try allocator.dupe([]f128, source.lijst_float_8001);
    result.lijst_gesorteerd_aflopend_3 = try allocator.dupe([]u8, source.lijst_gesorteerd_aflopend_3);
    result.lijst_gesorteerd_oplopend_3 = try allocator.dupe([]u8, source.lijst_gesorteerd_oplopend_3);
    result.lijst_herhaald_1000 = try allocator.dupe([]i8, source.lijst_herhaald_1000);
    result.lijst_leeg_0 = try allocator.dupe([]u8, source.lijst_leeg_0);
    result.lijst_null_1 = try allocator.dupe([]u8, source.lijst_null_1);
    result.lijst_null_3 = try allocator.dupe([]u8, source.lijst_null_3);
    result.lijst_oplopend_10000 = try allocator.dupe([]u16, source.lijst_oplopend_10000);
    result.lijst_willekeurig_10000 = try allocator.dupe([]u16, source.lijst_willekeurig_10000);
    result.lijst_willekeurig_3 = try allocator.dupe([]u8, source.lijst_willekeurig_3);

    return result;
}
