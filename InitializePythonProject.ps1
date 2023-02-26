<#
    Setup for a new Python Project (uses CI_CodeQuality repository)

    Usage: "InitializePythonProject.ps1 projectname"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$projectname
)

# Clean Conflicts
try {
    Remove-Item -Recurse -Force .\CI_CodeQuality -ErrorAction Stop
}
catch {
    "No CI_CodeQuality folder conflict"
}


if (Test-Path -Path ".\$projectname") {
    throw "Project Folder already exists! terminating..."
}


git clone https://github.com/Pedro-Ponteiro/CI_CodeQuality.git $projectname
Set-Location $projectname

# Setup python venv
py -m venv venv
venv/Scripts/activate
py -m pip install -r dev_requirements.txt

# Clean readme file from git clone
Remove-Item README.md

# Setup new Git repository
Remove-Item -Recurse -Force ./.git
git init
git add .

# Setup pre-commit
pre-commit autoupdate
pre-commit install


Set-Location ..

Write-Output "$projectname folder created"
Write-Output "Don't forget to git commit Initial setup :)"