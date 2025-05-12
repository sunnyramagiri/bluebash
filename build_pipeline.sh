#!/bin/bash

# Define build path
BUILD_ROOT="/var/www/apps/current/builds"
mkdir -p "$BUILD_ROOT"
cd "$BUILD_ROOT" || exit 1

echo ">>> Starting Build Pipeline at $(date)"

# Step 1: Rebuild first 3 builds
for i in 1 2 3; do
    echo "Rebuilding build${i}..."
    rm -rf "build${i}"
    mkdir "build${i}"
    echo "Build ${i} created on $(date)" > "build${i}/index.html"
done

# Step 2: Delete 1 build (e.g., oldest by modification time)
echo "Deleting oldest build..."
OLDEST_BUILD=$(ls -dt build*/ | tail -1)
if [ -n "$OLDEST_BUILD" ]; then
    rm -rf "$OLDEST_BUILD"
    echo "Deleted $OLDEST_BUILD"
else
    echo "No build to delete."
fi

# Step 3: Maintain/Recreate next 3 builds (build4 to build6)
for i in 4 5 6; do
    echo "Ensuring build${i} exists..."
    mkdir -p "build${i}"
    if [ ! -f "build${i}/index.html" ]; then
        echo "Build ${i} created on $(date)" > "build${i}/index.html"
    fi
done

echo ">>> Build Pipeline Completed at $(date)"
