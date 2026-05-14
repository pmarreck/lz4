const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.option(
        std.builtin.OptimizeMode,
        "optimize",
        "Optimization mode",
    ) orelse .ReleaseFast;

    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    lib_mod.addCSourceFiles(.{
        .files = &.{
            "lib/lz4.c",
            "lib/lz4hc.c",
            "lib/lz4frame.c",
            "lib/xxhash.c",
        },
        .flags = &.{
            "-std=c99",
            "-O3",
            "-Wall",
            "-Wextra",
        },
    });

    lib_mod.addIncludePath(b.path("lib"));

    const lib = b.addLibrary(.{
        .name = "lz4",
        .linkage = .static,
        .root_module = lib_mod,
    });

    lib.installHeadersDirectory(b.path("lib"), "", .{
        .include_extensions = &.{".h"},
        .exclude_extensions = &.{ ".c", ".md", ".in", ".rc.in" },
    });

    b.installArtifact(lib);
}
