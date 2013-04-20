#!/usr/bin/env bash

# Define vars
source_path=~/Library/Application\ Support/Colloquy/Repositories
styles_path=~/Library/Application\ Support/Colloquy/Styles
git_path=https://github.com/crossblaim/campfire-theme-for-colloquy.git
project_name=campfire-theme-for-colloquy
style_name=Campfire.colloquyStyle
original_pwd=`pwd`

# Function: returns true if passed command exists
function command_exists() {
  command -v "$1" &> /dev/null ;
}

# Function: prints error message and exits
function error() {
  echo -e "ERROR: $1" >&2
  exit 1
}

# Echo empty newline
echo ""

# Ensure git command exists, otherwise print error and exit
command_exists "git" ||
  error "Please install 'git' first."

# Create dirs exist if they don't exist already
mkdir -p "$source_path"
mkdir -p "$styles_path"

# Change to source dir
cd "$source_path"

# Either git pull or git clone
if [ -d "$project_name" ]; then
  cd "$project_name"
  echo "Found existing git project:"
  echo "   => $source_path/$project_name"
  echo "Update git project with a pull request..."
  echo "----------------------------------------"
  git pull
  echo "----------------------------------------"
else
  echo "Clone new git project to:"
  echo "  => $source_path/$project_name"
  echo "----------------------------------------"
  git clone "$git_path" "$project_name"
  echo "----------------------------------------"
fi

# Prepare for symlink
if [ -e "$styles_path/$style_name" ]; then 
  # Replace existing file, directory, or symlink
  if [ -L "$styles_path/$style_name" ]; then 
    echo "Symlink already exists." 
  else
    # Replace existing file or directory
    echo "Replace existing style with a symlink:"
    echo "   => $styles_path/$style_name"
  fi
  rm -r "$styles_path/$style_name"
else
  # Create a new symlink since nothing existing
  echo "Create symlink:"
  echo "  => $styles_path/$style_name"
fi

# Create symlink
ln -s "$source_path/$project_name/$style_name" "$styles_path/$style_name"

# Restore original pwd
cd "$original_pwd"

# Print success message
echo "Installation successful."
echo ""
echo "*** Please restart Colloquy. ***"
echo ""
