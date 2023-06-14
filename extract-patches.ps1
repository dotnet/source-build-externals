$repoRoot = $PSScriptRoot
$submoduleRoot = Join-Path $repoRoot 'src'
$componentName = Split-Path -Leaf $pwd
$patchesDir = Join-Path $repoRoot 'patches' $componentName

# Retrieve the sha for the submodule
$baseSha = git -C $submoduleRoot ls-tree HEAD $componentName --object-only

if  (!(Test-Path -Path $patchesDir)) {
    New-Item -ItemType directory -Path $patchesDir
}

# Remove existing patches
Remove-Item $patchesDir/*.patch

# Now format and reset back to the original state to be ready for testing
git format-patch -N -o $patchesDir $baseSha
git reset --hard $baseSha