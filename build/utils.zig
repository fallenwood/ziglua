const std = @import("std");

const Build = std.Build;
const Step = std.Build.Step;

pub fn patchFile(
    b: *Build,
    target: Build.ResolvedTarget,
    lib: *Step.Compile,
    file: Build.LazyPath,
    patch_file: Build.LazyPath,
    output_file: []const u8,
) Build.LazyPath {
    const patch = b.addExecutable(.{
        .name = "patch",
        .root_source_file = b.path("build/patch.zig"),
        .target = target,
    });

    const patch_run = b.addRunArtifact(patch);
    patch_run.addFileArg(file);
    patch_run.addFileArg(patch_file);
    const out = patch_run.addOutputFileArg(output_file);

    lib.step.dependOn(&patch_run.step);

    return out;
}
