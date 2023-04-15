<#
.SYNOPSIS
A function that reads an ini file and returns a hashtable of its contents.

.DESCRIPTION
This function takes a path to an ini file as a parameter and reads it line by line. It then parses the lines into sections, keys, and values and stores them in a hashtable.

.PARAMETER Path
The path to the ini file to be read.

.EXAMPLE
Get-IniContent -Path C:\Users\user\Documents\config.ini

This example reads the config.ini file from the C:\Users\user\Documents directory and returns a hashtable of its contents.

.NOTES
This function assumes that the ini file has a valid format and does not contain any duplicate sections or keys.
#>

# Define the Get-IniContent function
function Get-IniContent {
  # Define the parameter
  Param (
    [string]$Path
  )
  Write-Host "*** Check config.ini for MongoDB URI, OpenAI API Key and BingAI Access Token... ***" -ForegroundColor Blue
  Write-Host "`n"
  # Check if the path is valid
  if (-not (Test-Path -Path $Path)) {
    Write-Error "Invalid path: $Path"
    return
  }

  # Create an empty hashtable for the output
  $output = @{}

  # Read the ini file line by line
  $lines = Get-Content -Path $Path

  # Loop through each line
  foreach ($line in $lines) {
    # Use a switch statement to check the type of line
    switch -Regex ($line) {
      # If the line is a section name
      "^\[(.+)\]$" {
        # Get the section name
        $section = $Matches[1]
        # Create an empty hashtable for the section
        $output[$section] = @{}
      }
      # If the line is a key-value pair
      "(.+?)\s*=\s*(.*)" {
        # Get the key and value
        $key = $Matches[1]
        $value = $Matches[2]
        # Add the key-value pair to the section hashtable
        $output[$section][$key] = $value
      }
      # If the line is something else
      default {
        # Ignore it
      }
    }
  }
  Write-Host "config.ini content check done"
  # Return the output hashtable
  return $output
  # Pause and clear the screen
  Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Clear-Host	
}
