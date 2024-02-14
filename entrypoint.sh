#!/bin/sh
set -e


# # Function definitions
# check_for_errors() {

#     # Check the exit code of the last command

#     # This method does not yet work, as godot always returns 0: https://github.com/godotengine/godot/issues/83042
#     # It would be more elegant than the current solution, so I'm leaving it here for now.

#     # if [ $? -ne 0 ]; then
#     #   echo "Godot build failed. Exiting with error. This is the build log:"
#     #   cat godot_error.log
#     #   exit 1
#     # fi


#     # A hacky way to do this but as mentioned Godot currently always returns 0
#     errors=$(grep -c "Error: " godot_error.log)
#     ignoredErrors=$(grep -c "!EditorSettings::get_singleton() || !EditorSettings::get_singleton()->has_setting(p_setting)" godot_error.log)

#     echo "Found $errors errors in the project. Ignoring $ignoredErrors errors."

#     # Check if the project is valid
#     if [ $errors -gt 0 ] && [ $errors -gt $ignoredErrors ]
#     then
#         echo "Godot project is invalid/build has failed. Exiting with error. This is the build log:"
#         cat godot_error.log
#         exit 1
#     fi
# }


# Move godot templates already installed from the docker image to home
mkdir -v -p ~/.local/share/godot/export_templates
cp -a /root/.local/share/godot/templates/. ~/.local/share/godot/export_templates/


# Verify the dotnet installation
if [ "$7" = "true" ]
then
    echo "Installed Dotnet SDK version:"
    dotnet --version
    echo "Installed Mono version:"
    mono --version
    echo "Installed dotnet runtimes:"
    dotnet --info
fi


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

# Set up files required for the build
echo "Setting up editor files required for the build"
# godot --headless --editor --quit-after 60 . 2> godot_error.log

# check_for_errors

# A hacky way to do this but as mentioned Godot currently always returns 0
# errors=$(grep -c "Error: " godot_error.log)
# ignoredErrors=$(grep -c "!EditorSettings::get_singleton() || !EditorSettings::get_singleton()->has_setting(p_setting)" godot_error.log)

# echo "Found $errors errors in the project. Ignoring $ignoredErrors errors."

# # Check if the project is valid
# if [ $errors -gt 0 ] && [ $errors -gt $ignoredErrors ]
# then
#     echo "Godot project is invalid/build has failed. Exiting with error. This is the build log:"
#     cat godot_error.log
#     exit 1
# fi


# Build the project
echo "Building the project"
godot --headless --verbose --${mode} "$2" $GITHUB_WORKSPACE/build/${SubDirectoryLocation:-""}$1 2> godot_error.log


# Check if the build was successful by grepping the log file for a possible error message
# check_for_errors

# A hacky way to do this but as mentioned Godot currently always returns 0
errors=$(grep -c "Error: " godot_error.log)
ignoredErrors=$(grep -c "!EditorSettings::get_singleton() || !EditorSettings::get_singleton()->has_setting(p_setting)" godot_error.log)

echo "Found $errors errors in the project. Ignoring $ignoredErrors errors."

# Check if the project is valid
if [ $errors -gt 0 ] && [ $errors -gt $ignoredErrors ]
then
    echo "Godot project is invalid/build has failed. Exiting with error. This is the build log:"
    cat godot_error.log
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

exit 0