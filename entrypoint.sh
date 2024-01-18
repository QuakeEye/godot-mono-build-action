#!/bin/sh
set -e


# Move godot templates already installed from the docker image to home
mkdir -v -p ~/.local/share/godot/export_templates
cp -a /root/.local/share/godot/templates/. ~/.local/share/godot/export_templates/


# Verify the dotnet installation
echo "Installed Dotnet SDK version:"
dotnet --version
echo "Installed Mono version:"
mono --version


# Set the subdirectory location, if provided
if [ "$3" != "" ]
then
    SubDirectoryLocation="$3/"
fi


# Set the export mode, based on the debug flag parameter
mode="export-release"
if [ "$6" = "true" ]
then
    echo "Exporting in debug mode!"
    mode="export-debug"
fi


# Export
echo "Building $1 for $2"
mkdir -p $GITHUB_WORKSPACE/build/${SubDirectoryLocation:-""}
cd "$GITHUB_WORKSPACE/$5"
godot --headless --${mode} "$2" $GITHUB_WORKSPACE/build/${SubDirectoryLocation:-""}$1 > $GITHUB_WORKSPACE/godotheadless.log 2>&1


# Check the exit code of the last command using exit code

# This method does not yet work, as godot always returns 0: https://github.com/godotengine/godot/issues/83042
# It would be more elegant than the current solution, so I'm leaving it here for now.

# if [ $? -ne 0 ]; then
#   echo "Godot build failed. Exiting with error."
#   exit 1
# fi


# Check if the build was successful by grepping the log file for a possible error message
grep -q "ERROR" $GITHUB_WORKSPACE/godotheadless.log
if [ $? -ne 0 ]; then
  echo "Godot build failed. Exiting with error."
  exit 1
fi


echo "Build Done"

echo ::set-output name=build::build/${SubDirectoryLocation:-""}


# Pack the build, if requested
if [ "$4" = "true" ]
then
    echo "Packing Build"
    mkdir -p $GITHUB_WORKSPACE/package
    cd $GITHUB_WORKSPACE/build
    zip $GITHUB_WORKSPACE/package/artifact.zip ${SubDirectoryLocation:-"."} -r
    echo ::set-output name=artifact::package/artifact.zip
    echo "Done"
fi